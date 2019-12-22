import UIKit
import CoreLocation

class WeaponCalculator {
    
    public static func getRatingAndHealthAfterShoot(killerRating: Int, victimRating: Int, victimHealth: Int, weaponDamage: Int) ->
        (killerRating: Int, victimRating: Int, victimHealth: Int) {
            let victimHealth = healthAfterShoot(weaponDamage: weaponDamage, health: victimHealth)
            guard victimHealth <= 0 else {
                return (killerRating: killerRating, victimRating: victimRating, victimHealth: victimHealth)
            }
            let delta = getRatingChangeDelta(killerRating: killerRating, victimRating: victimRating)
            return (killerRating + delta, victimRating - delta, 0)
    }
    
    private class func healthAfterShoot(weaponDamage: Int, health: Int) -> Int {
        let newHealth = health - weaponDamage
        return newHealth < 0 ? 0 : newHealth
    }
    
    private static func getRatingChangeDelta(killerRating: Int, victimRating: Int) -> Int {
        let difference = Double(abs(killerRating - victimRating))
        let delta = Int(ratingChangingFunction(difference: difference))
        return killerRating < victimRating ? 50 - delta : delta
    }
    
    private static func ratingChangingFunction(difference: Double) -> Double {
        switch difference {
        case ..<100:
            return (25 - 5 * difference / 100).rounded()
        case 100..<1390:
            return (20 - 5 * log2(difference / 100)).rounded()
        default:
            return 1
        }
    }
}

extension CLLocationCoordinate2D {
    public func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        return sqrt(self.getSquaredDistance(to: to))
    }
    public func getSquaredDistance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        return pow(self.latitude - to.latitude, 2) + pow(self.longitude - to.longitude, 2)
    }
}

extension UIColor {
    
    static let masterColor          = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
    static let candidateMasterColor = UIColor(red: 1, green: 0, blue: 1, alpha: 1)
    static let expertColor          = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
    static let specialistColor      = UIColor(red: 0, green: 1, blue: 1, alpha: 1)
    static let pupilColor           = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    static let unratedColor         = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    
    public class func getRatingColor(for rating: Int) -> UIColor {
        switch rating {
        case 2000...:
            return UIColor.masterColor
        case 1800..<2000:
            return UIColor.candidateMasterColor
        case 1600..<1800:
            return UIColor.expertColor
        case 1400..<1600:
            return UIColor.specialistColor
        case 1000..<1400:
            return UIColor.pupilColor
        default:
            return UIColor.unratedColor
        }
    }
}

extension UserDefaults {
    
    func saveWeapon(for indexPath: IndexPath) {
        self.set(indexPath.section, forKey: Weapon.defaultWeapon)
    }
    
    func getDefaultWeapon() -> Weapon {
        // 100% sure because we set defaultValue in AppDelegate in the @method - application(..., didFinishLaunchingWithOptions) -> Bool
        let section = self.value(forKey: Weapon.defaultWeapon) as! Int
        let key = WeaponTypes.allCases[section].rawValue
        return WeaponModel.shared.items[key]!.first!
    }
}



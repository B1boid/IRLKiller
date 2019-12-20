import UIKit
import CoreLocation

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

class DistanceCalculator {
    
    static public func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        return sqrt(getSquaredDistance(from: from, to: to))
    }
    
    static public func getSquaredDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        return pow(from.latitude - to.latitude, 2) + pow(from.longitude - to.longitude, 2)
    }
    
}



class WeaponCalculator {
    
    enum WeaponCalculatorError: Error {
        case WeaponNotSet
    }
    
    public class func ratingAfterShoot(weapon: Weapon, rating: Int) -> Int {
        return rating - Int(weapon.damage)
    }
    
    public class func ratingAfterShoot(for key: String, rating: Int) throws -> Int {
        guard let weapon = UserDefaults.standard.value(forKey: key) as? Weapon else { throw WeaponCalculatorError.WeaponNotSet }
        let rating = ratingAfterShoot(weapon: weapon, rating: rating)
        return rating < 0 ? 0 : rating
    }
}

extension UserDefaults {
    func saveWeapon(for indexPath: IndexPath) {
        let path = "\(indexPath.row) \(indexPath.section)"
        self.set(path, forKey: Weapon.currentWeaponKey)
    }
}


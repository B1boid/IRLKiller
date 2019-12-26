import Foundation

extension UserDefaults {
    
    func saveWeaponSection(for indexPath: IndexPath) {
        self.set(indexPath.section, forKey: Weapon.defaultWeaponKey)
    }
    
    func getDefaultWeapon() -> Weapon {
        // 100% sure because we set defaultValue in AppDelegate in the @method - application(..., didFinishLaunchingWithOptions) -> Bool
        let section = self.value(forKey: Weapon.defaultWeaponKey) as! Int
        let key = WeaponTypes.allCases[section].rawValue
        return WeaponModel.shared.items[key]!.first!
    }
}

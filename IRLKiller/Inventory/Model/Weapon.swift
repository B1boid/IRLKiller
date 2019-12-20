struct Weapon {
    let name: String
    let cost: Float
    let distance: Float
    let capacity: Float
    let reloadTime: Float
    let damage: Float
    
    static let currentWeaponKey: String = "CurrentWeapon"
}

enum WeaponTypes: String, CaseIterable {
    case gun
    case grenade
    case rifle
    case test1
    case test2
    case test3
    case test4
}

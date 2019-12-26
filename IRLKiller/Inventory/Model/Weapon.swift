struct Weapon {
    let name      : String
    let cost      : UInt
    let distance  : UInt
    let capacity  : UInt
    let reloadTime: UInt
    let damage    : Int
    
    static let defaultWeaponKey: String = "CurrentWeapon"
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

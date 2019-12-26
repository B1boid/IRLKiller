struct Weapon {
    let name      : String
    let cost      : UInt
    let distance  : Double
    let capacity  : UInt
    let reloadTime: UInt
    let damage    : Int
    
    static let defaultWeaponKey: String = "CurrentWeapon"
}

enum WeaponTypes: String, CaseIterable {
    case weapons
    case pistols
    case rifles
    case bigguns
}

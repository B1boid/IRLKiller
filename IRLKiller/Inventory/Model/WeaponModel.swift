protocol WeaponProtocol {
    
    var weaponName: String { set get }
//
//    var weaponCost: Int  { set get }
//    var weaponDistance: Int { set get }
//    var weaponCapacity: Int { get set }
//
//    var weaponReloadTime: Float { get set }
//    var weaponDamage: Float { get set }
}

struct Weapon: WeaponProtocol  {
    var weaponName: String
    var weaponCost: Float
    var weaponDistance: Float
    var weaponCapacity: Float
    var weaponReloadTime: Float
    var weaponDamage: Float
}

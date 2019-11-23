protocol WeaponProtocol {

//    var name: String { set get }
//
//    var weaponCost: Int  { set get }
//    var weaponDistance: Int { set get }
//    var weaponCapacity: Int { get set }
//
//    var weaponReloadTime: Float { get set }
//    var weaponDamage: Float { get set }
}

struct Weapon: WeaponProtocol  {
    let name: String
    let cost: Float
    let distance: Float
    let capacity: Float
    let reloadTime: Float
    let damage: Float
}

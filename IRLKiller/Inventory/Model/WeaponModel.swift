import Foundation

class WeaponModel {
    
    static let shared = WeaponModel()
    
    fileprivate init() {
        
    }
    
    func getWeapon(for key: String, index: Int) -> Weapon? {
        guard let values = items[key] else { return nil }
        return values[index]
    }
    
    static var defaultWeapon: Weapon!
    
    var items: [String: [Weapon]] = [
        
        WeaponTypes.weapons.rawValue: [
            Weapon(name: "basic", cost: 10, distance: 0.001, capacity: 10, reloadTime: 6, damage: 20),
            Weapon(name: "revolver", cost: 20, distance: 0.001, capacity: 7, reloadTime: 5, damage: 25),
            Weapon(name: "knife", cost: 30, distance: 0.001, capacity: 7, reloadTime: 5, damage: 30),
            Weapon(name: "ak-47", cost: 30, distance: 0.002, capacity: 10, reloadTime: 6, damage: 40),
            Weapon(name: "sniper-rifle", cost: 40, distance: 0.004, capacity: 7, reloadTime: 12, damage: 80),
            Weapon(name: "shootgun", cost: 40, distance: 0.001, capacity: 10, reloadTime: 6, damage: 70),
            Weapon(name: "bazooka", cost: 50, distance: 0.002, capacity: 1, reloadTime: 15, damage: 100)
        ],
        
        WeaponTypes.pistols.rawValue: [
            Weapon(name: "basic", cost: 10, distance: 0.001, capacity: 10, reloadTime: 6, damage: 20),
            Weapon(name: "revolver", cost: 20, distance: 0.001, capacity: 7, reloadTime: 5, damage: 25),
            Weapon(name: "knife", cost: 30, distance: 0.001, capacity: 7, reloadTime: 5, damage: 30)
        ],
        
        WeaponTypes.rifles.rawValue: [
            Weapon(name: "ak-47", cost: 30, distance: 0.002, capacity: 10, reloadTime: 6, damage: 40),
            Weapon(name: "sniper-rifle", cost: 40, distance: 0.004, capacity: 7, reloadTime: 12, damage: 80)
        ],
        
        WeaponTypes.bigguns.rawValue: [
            Weapon(name: "shootgun", cost: 40, distance: 0.001, capacity: 10, reloadTime: 6, damage: 70),
            Weapon(name: "bazooka", cost: 50, distance: 0.002, capacity: 1, reloadTime: 15, damage: 100)
        ],
        
        
    ]
}


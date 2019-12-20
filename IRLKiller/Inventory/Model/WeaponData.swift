import Foundation

class WeaponData {
    
    static let shared = WeaponData()
    
    fileprivate init() {
        
    }
    
    func getWeapon(for key: String, index: Int) -> Weapon? {
        guard let values = items[key] else { return nil }
        return values[index]
    }
    
    var items: [String: [Weapon]] = [
        
        WeaponTypes.gun.rawValue: [
            Weapon(name: "shotgun", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "revolver", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20)
        ],
        
        WeaponTypes.grenade.rawValue: [
            Weapon(name: "shotgun", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
            Weapon(name: "basic", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "revolver", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        WeaponTypes.rifle.rawValue: [
            Weapon(name: "shotgun", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
            Weapon(name: "basic", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "revolver", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
            Weapon(name: "basic", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "revolver", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20)
        ],
        
        WeaponTypes.test1.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        WeaponTypes.test2.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        WeaponTypes.test3.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        WeaponTypes.test4.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
    ]
}


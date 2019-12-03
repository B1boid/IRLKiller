enum Weapons: String, CaseIterable {
    case gun
    case grenade
    case rifle
    case test1
    case test2
    case test3
    case test4
}

class WeaponData {
    
    static let shared = WeaponData()
    
    fileprivate init() {
        
    }
    
    func getWeapon(for key: String, index: Int) -> Weapon? {
        guard let values = items[key] else { return nil }
        return values[index]
    }
    
    var items: [String: [Weapon]] = [
        
        Weapons.gun.rawValue: [
            Weapon(name: "shotgun", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "revolver", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20)
        ],
        
        Weapons.grenade.rawValue: [
            Weapon(name: "shotgun", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
            Weapon(name: "basic", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "revolver", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        Weapons.rifle.rawValue: [
            Weapon(name: "shotgun", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
            Weapon(name: "basic", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "revolver", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
            Weapon(name: "basic", cost: 10, distance: 10, capacity: 10, reloadTime: 6, damage: 50),
            Weapon(name: "revolver", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20)
        ],
        
        Weapons.test1.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        Weapons.test2.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        Weapons.test3.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        Weapons.test4.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
    ]
}


enum Weapons: String, CaseIterable {
    case gun
    case grenade
    case rifle
    case a
    case b
    case c
    case d
}

class WeaponData {
    
    static let shared = WeaponData()
    
    fileprivate init() {
        
    }
    
    func getWeapon(for key: String, index: Int) -> Weapon? {
        guard let values = items[key] else { return nil }
        return values[index]
    }
    
    var tagNeedReload: [Bool] = Array(repeating: false, count: 7)
    
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
        
        Weapons.a.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        Weapons.b.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        Weapons.c.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
        
        Weapons.d.rawValue: [
            Weapon(name: "knife", cost: 20, distance: 20, capacity: 7, reloadTime: 5, damage: 20),
        ],
    ]
}


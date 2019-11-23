enum Weapons: String, CaseIterable {
    case gun
    case grenade
    case rifle
}

let weaponItems = [
    
    Weapons.gun.rawValue: [
        Weapon(weaponName: "shotgun", weaponCost: 10, weaponDistance: 10, weaponCapacity: 10, weaponReloadTime: 6, weaponDamage: 50),
        Weapon(weaponName: "revolver", weaponCost: 20, weaponDistance: 20, weaponCapacity: 7, weaponReloadTime: 5, weaponDamage: 20)
    ],
    
    Weapons.grenade.rawValue: [
        Weapon(weaponName: "shotgun", weaponCost: 10, weaponDistance: 10, weaponCapacity: 10, weaponReloadTime: 6, weaponDamage: 50),
        Weapon(weaponName: "revolver", weaponCost: 20, weaponDistance: 20, weaponCapacity: 7, weaponReloadTime: 5, weaponDamage: 20),
        Weapon(weaponName: "basic", weaponCost: 10, weaponDistance: 10, weaponCapacity: 10, weaponReloadTime: 6, weaponDamage: 50),
        Weapon(weaponName: "knife", weaponCost: 20, weaponDistance: 20, weaponCapacity: 7, weaponReloadTime: 5, weaponDamage: 20),
    ],
    
    Weapons.rifle.rawValue: [
        Weapon(weaponName: "shotgun", weaponCost: 10, weaponDistance: 10, weaponCapacity: 10, weaponReloadTime: 6, weaponDamage: 50),
        Weapon(weaponName: "revolver", weaponCost: 20, weaponDistance: 20, weaponCapacity: 7, weaponReloadTime: 5, weaponDamage: 20),
        Weapon(weaponName: "basic", weaponCost: 10, weaponDistance: 10, weaponCapacity: 10, weaponReloadTime: 6, weaponDamage: 50),
        Weapon(weaponName: "revolver", weaponCost: 20, weaponDistance: 20, weaponCapacity: 7, weaponReloadTime: 5, weaponDamage: 20),
        Weapon(weaponName: "shotgun", weaponCost: 10, weaponDistance: 10, weaponCapacity: 10, weaponReloadTime: 6, weaponDamage: 50),
        Weapon(weaponName: "knife", weaponCost: 20, weaponDistance: 20, weaponCapacity: 7, weaponReloadTime: 5, weaponDamage: 20)
    ]
]

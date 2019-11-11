enum Weapons: String, CaseIterable {
    case gun
    case granade
    case somethingElse
}

let weaponItems = [
    Weapons.gun.rawValue: ["gun", "gun"],
    Weapons.granade.rawValue: ["gun", "gun", "gun"],
    Weapons.somethingElse.rawValue: ["gun", "gun", "gun", "gun"]
]

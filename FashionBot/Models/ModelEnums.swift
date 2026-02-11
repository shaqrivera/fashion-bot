import Foundation

enum ClothingCategory: String, Codable, CaseIterable {
    case top
    case bottom
    case shoes
    case accessory
    case outerwear
}

enum Season: String, Codable, CaseIterable {
    case spring
    case summer
    case fall
    case winter
}

enum Occasion: String, Codable, CaseIterable {
    case casual
    case formal
    case business
    case sporty
    case dateNight
}

enum StylePreference: String, Codable, CaseIterable {
    case classic
    case streetwear
    case bohemian
    case minimalist
    case preppy
    case athleisure
}

enum BodyType: String, Codable, CaseIterable {
    case slim
    case athletic
    case average
    case curvy
    case tall
    case petite
}

enum LifestyleTag: String, Codable, CaseIterable {
    case office
    case active
    case social
    case creative
    case outdoor
    case travel
}

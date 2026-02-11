import Foundation
import SwiftData

@Model
final class ClothingItem {
    var name: String
    var category: ClothingCategory
    var color: String
    var seasonTags: [Season]
    var imageData: Data?
    var dateAdded: Date

    var outfits: [Outfit]?

    init(
        name: String,
        category: ClothingCategory,
        color: String,
        seasonTags: [Season] = [],
        imageData: Data? = nil,
        dateAdded: Date = .now
    ) {
        self.name = name
        self.category = category
        self.color = color
        self.seasonTags = seasonTags
        self.imageData = imageData
        self.dateAdded = dateAdded
    }
}

import Foundation
import SwiftData

@Model
final class Outfit {
    @Relationship(inverse: \ClothingItem.outfits)
    var items: [ClothingItem]
    var dateCreated: Date
    var occasion: Occasion
    var aiNotes: String

    var historyEntries: [OutfitHistory]?

    init(
        items: [ClothingItem] = [],
        dateCreated: Date = .now,
        occasion: Occasion,
        aiNotes: String = ""
    ) {
        self.items = items
        self.dateCreated = dateCreated
        self.occasion = occasion
        self.aiNotes = aiNotes
    }
}

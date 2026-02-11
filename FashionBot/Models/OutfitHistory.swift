import Foundation
import SwiftData

@Model
final class OutfitHistory {
    @Relationship(inverse: \Outfit.historyEntries)
    var outfit: Outfit?
    var dateWorn: Date
    var season: Season
    var userRating: Int

    init(
        outfit: Outfit? = nil,
        dateWorn: Date = .now,
        season: Season,
        userRating: Int
    ) {
        self.outfit = outfit
        self.dateWorn = dateWorn
        self.season = season
        self.userRating = userRating
    }
}

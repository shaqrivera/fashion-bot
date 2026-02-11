import Foundation
import SwiftData

@Model
final class UserProfile {
    var stylePreferences: [StylePreference]
    var bodyType: BodyType
    var preferredColors: [String]
    var lifestyleTags: [LifestyleTag]

    init(
        stylePreferences: [StylePreference] = [],
        bodyType: BodyType = .average,
        preferredColors: [String] = [],
        lifestyleTags: [LifestyleTag] = []
    ) {
        self.stylePreferences = stylePreferences
        self.bodyType = bodyType
        self.preferredColors = preferredColors
        self.lifestyleTags = lifestyleTags
    }
}

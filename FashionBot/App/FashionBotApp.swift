import SwiftData
import SwiftUI

@main
struct FashionBotApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [
            ClothingItem.self,
            Outfit.self,
            UserProfile.self,
            OutfitHistory.self
        ])
    }
}

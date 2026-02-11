import SwiftData
import SwiftUI

@main
struct FashionBotApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: ModelContainerFactory.modelTypes)
    }
}

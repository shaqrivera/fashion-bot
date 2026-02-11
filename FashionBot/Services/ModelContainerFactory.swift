import SwiftData

enum ModelContainerFactory {
    /// All SwiftData model types used by the app.
    static let modelTypes: [any PersistentModel.Type] = [
        ClothingItem.self,
        Outfit.self,
        UserProfile.self,
        OutfitHistory.self,
    ]

    /// Schema built from all model types.
    static let schema = Schema(modelTypes)

    /// Creates the default disk-backed container for production use.
    static func create() throws -> ModelContainer {
        let configuration = ModelConfiguration(schema: schema)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    /// Creates an in-memory container for previews and tests.
    static func createPreview() throws -> ModelContainer {
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}

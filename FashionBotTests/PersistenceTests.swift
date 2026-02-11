import Foundation
import SwiftData
import Testing
@testable import FashionBot

@Suite(.serialized)
struct ModelContainerFactoryTests {
    @Test func previewContainerIncludesAllModelTypes() throws {
        let container = try ModelContainerFactory.createPreview()
        let context = ModelContext(container)

        // Insert one of each model type to verify the schema includes all types
        let item = ClothingItem(name: "Test", category: .top, color: "Red")
        context.insert(item)

        let outfit = Outfit(items: [item], occasion: .casual)
        context.insert(outfit)

        let profile = UserProfile(stylePreferences: [.classic])
        context.insert(profile)

        let history = OutfitHistory(outfit: outfit, season: .summer, userRating: 3)
        context.insert(history)

        try context.save()

        #expect(try context.fetchCount(FetchDescriptor<ClothingItem>()) == 1)
        #expect(try context.fetchCount(FetchDescriptor<Outfit>()) == 1)
        #expect(try context.fetchCount(FetchDescriptor<UserProfile>()) == 1)
        #expect(try context.fetchCount(FetchDescriptor<OutfitHistory>()) == 1)
    }

    @Test func schemaContainsAllModelTypes() {
        let schema = ModelContainerFactory.schema
        let entityNames = schema.entities.map(\.name).sorted()
        #expect(entityNames == ["ClothingItem", "Outfit", "OutfitHistory", "UserProfile"])
    }
}

// MARK: - CRUD Tests

@Suite(.serialized)
struct ClothingItemCRUDTests {
    private func makeContext() throws -> ModelContext {
        let container = try ModelContainerFactory.createPreview()
        return ModelContext(container)
    }

    @Test func insertAndFetch() throws {
        let context = try makeContext()

        let item = ClothingItem(name: "Blue Oxford", category: .top, color: "Blue", seasonTags: [.spring, .fall])
        context.insert(item)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<ClothingItem>())
        #expect(fetched.count == 1)
        #expect(fetched[0].name == "Blue Oxford")
        #expect(fetched[0].category == .top)
        #expect(fetched[0].color == "Blue")
        #expect(fetched[0].seasonTags == [.spring, .fall])
    }

    @Test func update() throws {
        let context = try makeContext()

        let item = ClothingItem(name: "Old Name", category: .top, color: "Red")
        context.insert(item)
        try context.save()

        item.name = "New Name"
        item.color = "Navy"
        item.seasonTags = [.winter]
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<ClothingItem>())
        #expect(fetched.count == 1)
        #expect(fetched[0].name == "New Name")
        #expect(fetched[0].color == "Navy")
        #expect(fetched[0].seasonTags == [.winter])
    }

    @Test func delete() throws {
        let context = try makeContext()

        let item1 = ClothingItem(name: "Keep", category: .top, color: "White")
        let item2 = ClothingItem(name: "Remove", category: .bottom, color: "Black")
        context.insert(item1)
        context.insert(item2)
        try context.save()
        #expect(try context.fetchCount(FetchDescriptor<ClothingItem>()) == 2)

        context.delete(item2)
        try context.save()

        let remaining = try context.fetch(FetchDescriptor<ClothingItem>())
        #expect(remaining.count == 1)
        #expect(remaining[0].name == "Keep")
    }

    @Test func fetchWithPredicate() throws {
        let context = try makeContext()

        context.insert(ClothingItem(name: "Sneakers", category: .shoes, color: "White"))
        context.insert(ClothingItem(name: "T-Shirt", category: .top, color: "Black"))
        context.insert(ClothingItem(name: "Boots", category: .shoes, color: "Brown"))
        try context.save()

        let targetColor = "White"
        let descriptor = FetchDescriptor<ClothingItem>(
            predicate: #Predicate { $0.color == targetColor }
        )
        let fetched = try context.fetch(descriptor)
        #expect(fetched.count == 1)
        #expect(fetched[0].name == "Sneakers")
    }
}

@Suite(.serialized)
struct OutfitCRUDTests {
    private func makeContext() throws -> ModelContext {
        let container = try ModelContainerFactory.createPreview()
        return ModelContext(container)
    }

    @Test func insertAndFetch() throws {
        let context = try makeContext()

        let shirt = ClothingItem(name: "Dress Shirt", category: .top, color: "White")
        let pants = ClothingItem(name: "Chinos", category: .bottom, color: "Khaki")
        context.insert(shirt)
        context.insert(pants)

        let outfit = Outfit(items: [shirt, pants], occasion: .business, aiNotes: "Office ready")
        context.insert(outfit)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<Outfit>())
        #expect(fetched.count == 1)
        #expect(fetched[0].items.count == 2)
        #expect(fetched[0].occasion == .business)
        #expect(fetched[0].aiNotes == "Office ready")
    }

    @Test func update() throws {
        let context = try makeContext()

        let outfit = Outfit(occasion: .casual, aiNotes: "Original notes")
        context.insert(outfit)
        try context.save()

        outfit.occasion = .formal
        outfit.aiNotes = "Updated notes"
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<Outfit>())
        #expect(fetched.count == 1)
        #expect(fetched[0].occasion == .formal)
        #expect(fetched[0].aiNotes == "Updated notes")
    }

    @Test func delete() throws {
        let context = try makeContext()

        let outfit = Outfit(occasion: .sporty)
        context.insert(outfit)
        try context.save()
        #expect(try context.fetchCount(FetchDescriptor<Outfit>()) == 1)

        context.delete(outfit)
        try context.save()

        #expect(try context.fetchCount(FetchDescriptor<Outfit>()) == 0)
    }

    @Test func updateOutfitItems() throws {
        let context = try makeContext()

        let shirt = ClothingItem(name: "Tee", category: .top, color: "White")
        let jeans = ClothingItem(name: "Jeans", category: .bottom, color: "Blue")
        let jacket = ClothingItem(name: "Jacket", category: .outerwear, color: "Black")
        context.insert(shirt)
        context.insert(jeans)
        context.insert(jacket)

        let outfit = Outfit(items: [shirt, jeans], occasion: .casual)
        context.insert(outfit)
        try context.save()
        #expect(outfit.items.count == 2)

        // Add an item to the outfit
        outfit.items.append(jacket)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<Outfit>())
        #expect(fetched[0].items.count == 3)
    }
}

@Suite(.serialized)
struct UserProfileCRUDTests {
    private func makeContext() throws -> ModelContext {
        let container = try ModelContainerFactory.createPreview()
        return ModelContext(container)
    }

    @Test func insertAndFetch() throws {
        let context = try makeContext()

        let profile = UserProfile(
            stylePreferences: [.minimalist, .classic],
            bodyType: .athletic,
            preferredColors: ["Black", "Navy"],
            lifestyleTags: [.office, .active]
        )
        context.insert(profile)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<UserProfile>())
        #expect(fetched.count == 1)
        #expect(fetched[0].stylePreferences == [.minimalist, .classic])
        #expect(fetched[0].bodyType == .athletic)
        #expect(fetched[0].preferredColors == ["Black", "Navy"])
        #expect(fetched[0].lifestyleTags == [.office, .active])
    }

    @Test func update() throws {
        let context = try makeContext()

        let profile = UserProfile(bodyType: .average)
        context.insert(profile)
        try context.save()

        profile.bodyType = .curvy
        profile.stylePreferences = [.bohemian, .streetwear]
        profile.preferredColors = ["Red", "Orange"]
        profile.lifestyleTags = [.creative, .social]
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<UserProfile>())
        #expect(fetched.count == 1)
        #expect(fetched[0].bodyType == .curvy)
        #expect(fetched[0].stylePreferences == [.bohemian, .streetwear])
        #expect(fetched[0].preferredColors == ["Red", "Orange"])
        #expect(fetched[0].lifestyleTags == [.creative, .social])
    }

    @Test func delete() throws {
        let context = try makeContext()

        let profile = UserProfile()
        context.insert(profile)
        try context.save()
        #expect(try context.fetchCount(FetchDescriptor<UserProfile>()) == 1)

        context.delete(profile)
        try context.save()

        #expect(try context.fetchCount(FetchDescriptor<UserProfile>()) == 0)
    }
}

@Suite(.serialized)
struct OutfitHistoryCRUDTests {
    private func makeContext() throws -> ModelContext {
        let container = try ModelContainerFactory.createPreview()
        return ModelContext(container)
    }

    @Test func insertAndFetch() throws {
        let context = try makeContext()

        let outfit = Outfit(occasion: .casual)
        context.insert(outfit)

        let history = OutfitHistory(outfit: outfit, season: .summer, userRating: 5)
        context.insert(history)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<OutfitHistory>())
        #expect(fetched.count == 1)
        #expect(fetched[0].season == .summer)
        #expect(fetched[0].userRating == 5)
        #expect(fetched[0].outfit === outfit)
    }

    @Test func update() throws {
        let context = try makeContext()

        let outfit = Outfit(occasion: .formal)
        context.insert(outfit)

        let history = OutfitHistory(outfit: outfit, season: .winter, userRating: 3)
        context.insert(history)
        try context.save()

        history.userRating = 5
        history.season = .fall
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<OutfitHistory>())
        #expect(fetched.count == 1)
        #expect(fetched[0].userRating == 5)
        #expect(fetched[0].season == .fall)
    }

    @Test func delete() throws {
        let context = try makeContext()

        let outfit = Outfit(occasion: .dateNight)
        context.insert(outfit)

        let history = OutfitHistory(outfit: outfit, season: .spring, userRating: 4)
        context.insert(history)
        try context.save()
        #expect(try context.fetchCount(FetchDescriptor<OutfitHistory>()) == 1)

        context.delete(history)
        try context.save()

        #expect(try context.fetchCount(FetchDescriptor<OutfitHistory>()) == 0)
        // Outfit should still exist
        #expect(try context.fetchCount(FetchDescriptor<Outfit>()) == 1)
    }

    @Test func multipleHistoryEntriesForSameOutfit() throws {
        let context = try makeContext()

        let outfit = Outfit(occasion: .casual)
        context.insert(outfit)

        let h1 = OutfitHistory(outfit: outfit, season: .spring, userRating: 3)
        let h2 = OutfitHistory(outfit: outfit, season: .summer, userRating: 4)
        let h3 = OutfitHistory(outfit: outfit, season: .fall, userRating: 5)
        context.insert(h1)
        context.insert(h2)
        context.insert(h3)
        try context.save()

        #expect(try context.fetchCount(FetchDescriptor<OutfitHistory>()) == 3)
        #expect(outfit.historyEntries?.count == 3)
    }
}

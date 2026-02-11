import Foundation
import SwiftData
import Testing
@testable import FashionBot

struct ModelEnumTests {
    @Test func clothingCategoryHasExpectedCases() {
        let cases = ClothingCategory.allCases
        #expect(cases.count == 5)
        #expect(cases.contains(.top))
        #expect(cases.contains(.bottom))
        #expect(cases.contains(.shoes))
        #expect(cases.contains(.accessory))
        #expect(cases.contains(.outerwear))
    }

    @Test func seasonHasExpectedCases() {
        let cases = Season.allCases
        #expect(cases.count == 4)
        #expect(cases.contains(.spring))
        #expect(cases.contains(.summer))
        #expect(cases.contains(.fall))
        #expect(cases.contains(.winter))
    }

    @Test func occasionHasExpectedCases() {
        let cases = Occasion.allCases
        #expect(cases.count == 5)
        #expect(cases.contains(.casual))
        #expect(cases.contains(.formal))
        #expect(cases.contains(.business))
        #expect(cases.contains(.sporty))
        #expect(cases.contains(.dateNight))
    }

    @Test func stylePreferenceHasExpectedCases() {
        let cases = StylePreference.allCases
        #expect(cases.count == 6)
        #expect(cases.contains(.classic))
        #expect(cases.contains(.streetwear))
        #expect(cases.contains(.bohemian))
        #expect(cases.contains(.minimalist))
        #expect(cases.contains(.preppy))
        #expect(cases.contains(.athleisure))
    }

    @Test func bodyTypeHasExpectedCases() {
        let cases = BodyType.allCases
        #expect(cases.count == 6)
        #expect(cases.contains(.slim))
        #expect(cases.contains(.athletic))
        #expect(cases.contains(.average))
        #expect(cases.contains(.curvy))
        #expect(cases.contains(.tall))
        #expect(cases.contains(.petite))
    }

    @Test func lifestyleTagHasExpectedCases() {
        let cases = LifestyleTag.allCases
        #expect(cases.count == 6)
        #expect(cases.contains(.office))
        #expect(cases.contains(.active))
        #expect(cases.contains(.social))
        #expect(cases.contains(.creative))
        #expect(cases.contains(.outdoor))
        #expect(cases.contains(.travel))
    }

    @Test func enumsAreCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let category = ClothingCategory.top
        let data = try encoder.encode(category)
        let decoded = try decoder.decode(ClothingCategory.self, from: data)
        #expect(decoded == category)

        let season = Season.winter
        let seasonData = try encoder.encode(season)
        let decodedSeason = try decoder.decode(Season.self, from: seasonData)
        #expect(decodedSeason == season)

        let occasion = Occasion.dateNight
        let occasionData = try encoder.encode(occasion)
        let decodedOccasion = try decoder.decode(Occasion.self, from: occasionData)
        #expect(decodedOccasion == occasion)
    }
}

@Suite(.serialized)
struct ClothingItemTests {
    @Test func createClothingItem() {
        let item = ClothingItem(
            name: "Blue Oxford Shirt",
            category: .top,
            color: "Blue",
            seasonTags: [.spring, .fall]
        )
        #expect(item.name == "Blue Oxford Shirt")
        #expect(item.category == .top)
        #expect(item.color == "Blue")
        #expect(item.seasonTags == [.spring, .fall])
        #expect(item.imageData == nil)
    }

    @Test func createClothingItemWithImageData() {
        let imageData = Data([0x00, 0x01, 0x02])
        let item = ClothingItem(
            name: "Red Sneakers",
            category: .shoes,
            color: "Red",
            imageData: imageData
        )
        #expect(item.imageData == imageData)
    }
}

@Suite(.serialized)
struct OutfitTests {
    @Test func createOutfit() {
        let shirt = ClothingItem(name: "White Tee", category: .top, color: "White")
        let jeans = ClothingItem(name: "Blue Jeans", category: .bottom, color: "Blue")
        let outfit = Outfit(items: [shirt, jeans], occasion: .casual, aiNotes: "Simple weekend look")

        #expect(outfit.items.count == 2)
        #expect(outfit.occasion == .casual)
        #expect(outfit.aiNotes == "Simple weekend look")
    }

    @Test func createOutfitWithDefaults() {
        let outfit = Outfit(occasion: .formal)
        #expect(outfit.items.isEmpty)
        #expect(outfit.aiNotes == "")
    }
}

@Suite(.serialized)
struct UserProfileTests {
    @Test func createUserProfile() {
        let profile = UserProfile(
            stylePreferences: [.minimalist, .classic],
            bodyType: .athletic,
            preferredColors: ["Black", "Navy", "White"],
            lifestyleTags: [.office, .active]
        )
        #expect(profile.stylePreferences == [.minimalist, .classic])
        #expect(profile.bodyType == .athletic)
        #expect(profile.preferredColors.count == 3)
        #expect(profile.lifestyleTags == [.office, .active])
    }

    @Test func createUserProfileWithDefaults() {
        let profile = UserProfile()
        #expect(profile.stylePreferences.isEmpty)
        #expect(profile.bodyType == .average)
        #expect(profile.preferredColors.isEmpty)
        #expect(profile.lifestyleTags.isEmpty)
    }
}

@Suite(.serialized)
struct OutfitHistoryTests {
    @Test func createOutfitHistory() {
        let outfit = Outfit(occasion: .business)
        let history = OutfitHistory(outfit: outfit, season: .winter, userRating: 4)

        #expect(history.outfit === outfit)
        #expect(history.season == .winter)
        #expect(history.userRating == 4)
    }

    @Test func ratingValues() {
        for rating in 1...5 {
            let history = OutfitHistory(season: .summer, userRating: rating)
            #expect(history.userRating == rating)
        }
    }
}

@Suite(.serialized)
struct ModelPersistenceTests {
    private func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(
            for: ClothingItem.self, Outfit.self, UserProfile.self, OutfitHistory.self,
            configurations: config
        )
    }

    @Test func persistClothingItem() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let item = ClothingItem(name: "Black Blazer", category: .outerwear, color: "Black", seasonTags: [.fall, .winter])
        context.insert(item)
        try context.save()

        let descriptor = FetchDescriptor<ClothingItem>()
        let fetched = try context.fetch(descriptor)
        #expect(fetched.count == 1)
        #expect(fetched[0].name == "Black Blazer")
        #expect(fetched[0].category == .outerwear)
        #expect(fetched[0].seasonTags == [.fall, .winter])
    }

    @Test func persistOutfitWithItems() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let shirt = ClothingItem(name: "Dress Shirt", category: .top, color: "White")
        let pants = ClothingItem(name: "Chinos", category: .bottom, color: "Khaki")
        context.insert(shirt)
        context.insert(pants)

        let outfit = Outfit(items: [shirt, pants], occasion: .business, aiNotes: "Office ready")
        context.insert(outfit)
        try context.save()

        let descriptor = FetchDescriptor<Outfit>()
        let fetched = try context.fetch(descriptor)
        #expect(fetched.count == 1)
        #expect(fetched[0].items.count == 2)
        #expect(fetched[0].occasion == .business)
    }

    @Test func persistUserProfile() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let profile = UserProfile(
            stylePreferences: [.streetwear],
            bodyType: .slim,
            preferredColors: ["Black"],
            lifestyleTags: [.creative]
        )
        context.insert(profile)
        try context.save()

        let descriptor = FetchDescriptor<UserProfile>()
        let fetched = try context.fetch(descriptor)
        #expect(fetched.count == 1)
        #expect(fetched[0].bodyType == .slim)
        #expect(fetched[0].stylePreferences == [.streetwear])
    }

    @Test func persistOutfitHistory() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let outfit = Outfit(occasion: .casual)
        context.insert(outfit)

        let history = OutfitHistory(outfit: outfit, season: .spring, userRating: 5)
        context.insert(history)
        try context.save()

        let descriptor = FetchDescriptor<OutfitHistory>()
        let fetched = try context.fetch(descriptor)
        #expect(fetched.count == 1)
        #expect(fetched[0].userRating == 5)
        #expect(fetched[0].outfit === outfit)
    }

    @Test func outfitClothingItemRelationship() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let shirt = ClothingItem(name: "Polo", category: .top, color: "Green")
        context.insert(shirt)

        let outfit = Outfit(items: [shirt], occasion: .casual)
        context.insert(outfit)
        try context.save()

        // Verify inverse relationship
        #expect(shirt.outfits?.contains(where: { $0 === outfit }) == true)
    }

    @Test func outfitHistoryRelationship() throws {
        let container = try makeContainer()
        let context = ModelContext(container)

        let outfit = Outfit(occasion: .formal)
        context.insert(outfit)

        let history = OutfitHistory(outfit: outfit, season: .winter, userRating: 3)
        context.insert(history)
        try context.save()

        // Verify inverse relationship
        #expect(outfit.historyEntries?.contains(where: { $0 === history }) == true)
    }
}

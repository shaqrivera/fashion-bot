import Foundation
import SwiftData
import Testing
import UIKit
@testable import FashionBot

@Suite(.serialized)
@MainActor
struct AddClothingItemViewModelTests {
    private func makeContext() throws -> ModelContext {
        let container = try ModelContainerFactory.createPreview()
        return ModelContext(container)
    }

    private func makeTestImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        return renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
        }
    }

    // MARK: - Validation

    @Test func canSaveIsFalseWhenImageIsNil() {
        let vm = AddClothingItemViewModel()
        vm.name = "T-Shirt"

        #expect(!vm.canSave)
    }

    @Test func canSaveIsFalseWhenNameIsEmpty() {
        let vm = AddClothingItemViewModel()
        vm.selectedImage = makeTestImage()
        vm.name = ""

        #expect(!vm.canSave)
    }

    @Test func canSaveIsFalseWhenNameIsWhitespace() {
        let vm = AddClothingItemViewModel()
        vm.selectedImage = makeTestImage()
        vm.name = "   "

        #expect(!vm.canSave)
    }

    @Test func canSaveIsTrueWhenImageAndNameProvided() {
        let vm = AddClothingItemViewModel()
        vm.selectedImage = makeTestImage()
        vm.name = "Blue Oxford"

        #expect(vm.canSave)
    }

    // MARK: - Defaults

    @Test func defaultCategoryIsTop() {
        let vm = AddClothingItemViewModel()
        #expect(vm.category == .top)
    }

    @Test func defaultSeasonTagsAreEmpty() {
        let vm = AddClothingItemViewModel()
        #expect(vm.seasonTags.isEmpty)
    }

    @Test func defaultNameIsEmpty() {
        let vm = AddClothingItemViewModel()
        #expect(vm.name.isEmpty)
    }

    // MARK: - Save

    @Test func saveInsertsClothingItemIntoContext() throws {
        let context = try makeContext()
        let vm = AddClothingItemViewModel()
        vm.selectedImage = makeTestImage()
        vm.name = "Test Shirt"
        vm.category = .top
        vm.color = "Red"
        vm.seasonTags = [.summer, .spring]

        vm.save(context: context)

        let items = try context.fetch(FetchDescriptor<ClothingItem>())
        #expect(items.count == 1)
        #expect(items[0].name == "Test Shirt")
        #expect(items[0].category == .top)
        #expect(items[0].color == "Red")
        #expect(Set(items[0].seasonTags) == [.summer, .spring])
    }

    @Test func saveCompressesImageData() throws {
        let context = try makeContext()
        let vm = AddClothingItemViewModel()
        vm.selectedImage = makeTestImage()
        vm.name = "Jacket"

        vm.save(context: context)

        let items = try context.fetch(FetchDescriptor<ClothingItem>())
        #expect(items.count == 1)
        #expect(items[0].imageData != nil)
    }

    @Test func saveTrimsWhitespaceFromName() throws {
        let context = try makeContext()
        let vm = AddClothingItemViewModel()
        vm.selectedImage = makeTestImage()
        vm.name = "  Padded Name  "
        vm.color = "  Blue  "

        vm.save(context: context)

        let items = try context.fetch(FetchDescriptor<ClothingItem>())
        #expect(items[0].name == "Padded Name")
        #expect(items[0].color == "Blue")
    }
}

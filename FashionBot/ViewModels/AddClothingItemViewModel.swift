import Foundation
import Observation
import PhotosUI
import SwiftData
import SwiftUI
import UIKit

@MainActor
@Observable
final class AddClothingItemViewModel {
    var selectedImage: UIImage?
    var name: String = ""
    var category: ClothingCategory = .top
    var color: String = ""
    var seasonTags: Set<Season> = []

    var isCameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    var canSave: Bool {
        selectedImage != nil && !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func save(context: ModelContext) {
        let imageData = selectedImage.flatMap { ImageService.compress($0) }
        let item = ClothingItem(
            name: name.trimmingCharacters(in: .whitespaces),
            category: category,
            color: color.trimmingCharacters(in: .whitespaces),
            seasonTags: Array(seasonTags),
            imageData: imageData
        )
        context.insert(item)
        try? context.save()
    }

    func loadImage(from item: PhotosPickerItem) async {
        guard let data = try? await item.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data) else {
            return
        }
        selectedImage = uiImage
    }
}

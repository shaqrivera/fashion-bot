import UIKit

enum ImageService {
    /// Resizes an image proportionally so neither dimension exceeds `maxDimension`.
    /// Returns the original image if it already fits within the limit.
    static func resize(_ image: UIImage, maxDimension: CGFloat = 1024) -> UIImage {
        let size = image.size
        guard size.width > maxDimension || size.height > maxDimension else {
            return image
        }

        let scale = min(maxDimension / size.width, maxDimension / size.height)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    /// Resizes the image and compresses it to JPEG data at the given quality (0.0–1.0).
    static func compress(_ image: UIImage, quality: CGFloat = 0.8) -> Data? {
        let resized = resize(image)
        return resized.jpegData(compressionQuality: quality)
    }
}

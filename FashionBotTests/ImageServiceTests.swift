import Testing
import UIKit
@testable import FashionBot

@Suite struct ImageServiceTests {
    /// Creates a solid-color test image with the given dimensions.
    private func makeTestImage(width: CGFloat, height: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        return renderer.image { context in
            UIColor.blue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        }
    }

    // MARK: - Resize

    @Test func resizeLargeImageScalesDown() {
        let image = makeTestImage(width: 2048, height: 1536)
        let resized = ImageService.resize(image)

        #expect(resized.size.width <= 1024)
        #expect(resized.size.height <= 1024)
    }

    @Test func resizePreservesAspectRatio() {
        let image = makeTestImage(width: 2000, height: 1000)
        let resized = ImageService.resize(image)

        let aspectBefore = image.size.width / image.size.height
        let aspectAfter = resized.size.width / resized.size.height

        #expect(abs(aspectBefore - aspectAfter) < 0.01)
    }

    @Test func resizeDoesNothingForSmallImage() {
        let image = makeTestImage(width: 500, height: 300)
        let resized = ImageService.resize(image)

        #expect(resized.size.width == 500)
        #expect(resized.size.height == 300)
    }

    @Test func resizeWithCustomMaxDimension() {
        let image = makeTestImage(width: 800, height: 600)
        let resized = ImageService.resize(image, maxDimension: 400)

        #expect(resized.size.width <= 400)
        #expect(resized.size.height <= 400)
    }

    @Test func resizeTallImageConstrainsHeight() {
        let image = makeTestImage(width: 500, height: 2000)
        let resized = ImageService.resize(image)

        #expect(resized.size.height <= 1024)
        #expect(resized.size.width <= 1024)
    }

    // MARK: - Compress

    @Test func compressReturnsNonNilData() {
        let image = makeTestImage(width: 100, height: 100)
        let data = ImageService.compress(image)

        #expect(data != nil)
    }

    @Test func compressOutputIsSmallerThanRawBitmap() {
        let image = makeTestImage(width: 500, height: 500)
        let data = ImageService.compress(image)

        // Raw RGBA bitmap for 500x500 would be 500*500*4 = 1,000,000 bytes
        let rawSize = 500 * 500 * 4
        #expect(data != nil)
        #expect(data!.count < rawSize)
    }

    @Test func compressWithLowQualityProducesSmallerData() {
        let image = makeTestImage(width: 500, height: 500)
        let highQuality = ImageService.compress(image, quality: 1.0)
        let lowQuality = ImageService.compress(image, quality: 0.1)

        #expect(highQuality != nil)
        #expect(lowQuality != nil)
        #expect(lowQuality!.count < highQuality!.count)
    }

    @Test func compressResizesBeforeCompressing() {
        let largeImage = makeTestImage(width: 3000, height: 3000)
        let data = ImageService.compress(largeImage)

        // If it resized first, data should be much smaller than unresized JPEG
        #expect(data != nil)

        // Verify by checking the compressed data creates a smaller image
        let resultImage = UIImage(data: data!)
        #expect(resultImage != nil)
        #expect(resultImage!.size.width <= 1024)
        #expect(resultImage!.size.height <= 1024)
    }
}

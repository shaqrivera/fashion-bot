import XCTest

final class FashionBotUITests: XCTestCase {
    func testAppLaunches() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Wardrobe"].exists)
        XCTAssertTrue(app.tabBars.buttons["Outfits"].exists)
        XCTAssertTrue(app.tabBars.buttons["Profile"].exists)
    }
}

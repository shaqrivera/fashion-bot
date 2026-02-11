import XCTest

final class FashionBotUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // MARK: - Tab Bar

    func testTabBarShowsAllTabs() throws {
        XCTAssertTrue(app.tabBars.buttons["Wardrobe"].exists)
        XCTAssertTrue(app.tabBars.buttons["Outfits"].exists)
        XCTAssertTrue(app.tabBars.buttons["Profile"].exists)
    }

    func testWardrobeTabIsSelectedByDefault() throws {
        let wardrobeTab = app.tabBars.buttons["Wardrobe"]
        XCTAssertTrue(wardrobeTab.isSelected)
    }

    // MARK: - Tab Switching

    func testSwitchToOutfitsTab() throws {
        app.tabBars.buttons["Outfits"].tap()
        XCTAssertTrue(app.navigationBars["Outfits"].exists)
    }

    func testSwitchToProfileTab() throws {
        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.navigationBars["Profile"].exists)
    }

    func testSwitchBackToWardrobeTab() throws {
        app.tabBars.buttons["Profile"].tap()
        app.tabBars.buttons["Wardrobe"].tap()
        XCTAssertTrue(app.navigationBars["Wardrobe"].exists)
    }

    // MARK: - Navigation Titles

    func testWardrobeNavigationTitle() throws {
        XCTAssertTrue(app.navigationBars["Wardrobe"].exists)
    }

    func testOutfitsNavigationTitle() throws {
        app.tabBars.buttons["Outfits"].tap()
        XCTAssertTrue(app.navigationBars["Outfits"].exists)
    }

    func testProfileNavigationTitle() throws {
        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.navigationBars["Profile"].exists)
    }

    // MARK: - Empty States

    func testWardrobeShowsEmptyState() throws {
        XCTAssertTrue(app.staticTexts["No Clothing Items"].exists)
    }

    func testOutfitsShowsEmptyState() throws {
        app.tabBars.buttons["Outfits"].tap()
        XCTAssertTrue(app.staticTexts["No Outfits Yet"].exists)
    }

    func testProfileShowsEmptyState() throws {
        app.tabBars.buttons["Profile"].tap()
        XCTAssertTrue(app.staticTexts["Profile"].exists)
    }

    // MARK: - Add Clothing Item

    func testWardrobeHasAddButton() throws {
        let addButton = app.navigationBars["Wardrobe"].buttons["Add Clothing Item"]
        XCTAssertTrue(addButton.exists)
    }

    func testAddButtonPresentsSheet() throws {
        app.navigationBars["Wardrobe"].buttons["Add Clothing Item"].tap()
        XCTAssertTrue(app.navigationBars["Add Clothing Item"].waitForExistence(timeout: 2))
    }

    func testAddSheetHasCancelButton() throws {
        app.navigationBars["Wardrobe"].buttons["Add Clothing Item"].tap()
        XCTAssertTrue(app.navigationBars["Add Clothing Item"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Cancel"].exists)
    }

    func testAddSheetCancelDismisses() throws {
        app.navigationBars["Wardrobe"].buttons["Add Clothing Item"].tap()
        XCTAssertTrue(app.navigationBars["Add Clothing Item"].waitForExistence(timeout: 2))
        app.buttons["Cancel"].tap()
        // After dismissal, we should be back to the Wardrobe nav bar
        XCTAssertTrue(app.navigationBars["Wardrobe"].waitForExistence(timeout: 2))
    }
}

import XCTest

final class SearchNavBarDisappearReproUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testTapSearchFieldKeepsKeyboardFocus() {
        let app = XCUIApplication()
        app.launch()

        XCUIDevice.shared.orientation = .landscapeLeft
        XCUIDevice.shared.orientation = .portrait

        let searchField = app.searchFields["searchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))

        searchField.tap()

        XCTAssertTrue(searchField.waitForExistence(timeout: 2))
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 2))

        searchField.typeText("a")
        XCTAssertEqual(searchField.value as? String, "a")
    }
}

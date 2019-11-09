import XCTest
@testable import Parse

final class ParseTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Parse().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

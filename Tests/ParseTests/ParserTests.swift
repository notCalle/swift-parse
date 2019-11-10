import XCTest
@testable import Parse

final class ParserTests: XCTestCase {
    typealias IntArray = Array<Int>
    typealias IntParser = Parser<Int, IntArray>

    let any = IntParser.any

    func testAnySuccess() {
        let (result, remainder) = any.parse([1,2])!

        XCTAssertEqual(result, 1)
        XCTAssertEqual(remainder, [2])
    }

    func testAnyFailure() {
        XCTAssertNil(any.parse([]))
    }

    let notAny = IntParser.not(.any)

    func testNotAnySuccess() {
        let (result, remainder) = notAny.parse([])!

        XCTAssertNil(result)
        XCTAssertEqual(remainder, [])
    }

    func testNotAnyFailure() {
        XCTAssertNil(notAny.parse([1]))
    }

    // MARK: - List of all tests
    let allTests = [
        "testAnySuccess": testAnySuccess,
        "testAnyFailure": testAnyFailure,
    ]
}

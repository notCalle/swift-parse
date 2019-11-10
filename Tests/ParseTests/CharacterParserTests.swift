import XCTest
@testable import Parse

final class CharacterParserTests: XCTestCase {
    typealias CP = CharacterParser

    let one = CP.character("1")

    func testOneParserSuccess() {
        let (result, remainder) = one.parse("123")!
        XCTAssertTrue(result == "1")
        XCTAssertTrue(remainder == "23")
    }

    func testOneParserFailure() {
        XCTAssertNil(one.parse("23"))
    }

    let digit = CP.digit

    func testCharacterSetSuccess() {
        let (result, remainder) = digit.parse("123")!
        XCTAssertTrue(result == "1")
        XCTAssertTrue(remainder == "23")
    }

    func testCharacterSetFailure() {
        XCTAssertNil(digit.parse("abc"))
    }

    let digits = CP.digit.many

    func testManySuccess() {
        let (result, remainder) = digits.parse("123")!
        XCTAssertTrue(String(result) == "123")
        XCTAssertTrue(remainder == "")
    }

    func testManyFailure() {
        let (result, remainder) = digits.parse("abc")!
        XCTAssertTrue(String(result) == "")
        XCTAssertTrue(remainder == "abc")
    }

    var nodigit = CP.digit.none

    func testNoneSuccess() {
        let (result, remainder) = nodigit.parse("abc")!
        XCTAssertTrue(String(result) == "")
        XCTAssertTrue(remainder == "abc")
    }

    func testNoneFailure() {
        XCTAssertNil(nodigit.parse("123"))
    }

    // MARK: - List of all tests
    let allTests = [
        "testOneParserSuccess": testOneParserSuccess,
        "testOneParserFailure": testOneParserFailure,
        "testCharacterSetSuccess": testCharacterSetSuccess,
        "testCharacterSetFailure": testCharacterSetFailure,
        "testManySuccess": testManySuccess,
        "testManyFailure": testManyFailure,
        "testNoneSuccess": testNoneSuccess,
        "testNoneFailure": testNoneFailure,
    ]
}

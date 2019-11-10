import XCTest
@testable import Parse

final class CombinedParserTests: XCTestCase {
    typealias CP = CharacterParser
    typealias StringParser = CP.Map<String>
    typealias IntParser = CP.Map<Int>

    let sign = { $0 ?? "+" } <^> CP.character(in: "+-").optional
    let digits = CP.digit.many1
    var number: StringParser { curry { String([$0] + $1) } <^> sign <*> digits }
    var integer: IntParser { { Int($0)! } <^> number }

    func testInteger() {
        let (result, remainder) = integer.parse("1")!
        XCTAssertEqual(result, 1)
        XCTAssertEqual(remainder, "")
    }

    func testNegInteger() {
        let (result, remainder) = integer.parse("-1")!
        XCTAssertEqual(result, -1)
        XCTAssertEqual(remainder, "")
    }

    func testPosInteger() {
        let (result, remainder) = integer.parse("+1")!
        XCTAssertEqual(result, 1)
        XCTAssertEqual(remainder, "")
    }

    let star = CP.character(in: "*")
    var multiplication: IntParser {
        curry { $0 * ($1 ?? 1) } <^> integer
            <*> (star *> integer).optional }

    func testMultiplication() {
        let (result, remainder) = multiplication.parse("1*2")!
        XCTAssertEqual(result, 2)
        XCTAssertEqual(remainder, "")
    }

    let plus = CP.character(in: "+")
    var addition: IntParser {
        curry { $0 + ($1 ?? 0) } <^> multiplication
            <*> (plus *> multiplication)<? }

    func testAddition() {
        let (result, remainder) = addition.parse("1+2")!
        XCTAssertEqual(result, 3)
        XCTAssertEqual(remainder, "")
    }

    // MARK: - List of all tests
    let allTests = [
        "testInteger": testInteger,
        "testNegInteger": testNegInteger,
        "testPosInteger": testPosInteger,
        "testMultiplication": testMultiplication,
        "testAddition": testAddition,
    ]
}

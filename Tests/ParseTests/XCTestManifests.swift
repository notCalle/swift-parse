import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ParserTests.allTests),
        testCase(CharacterParserTests.allTests),
        testCase(CombinedParserTests.allTests),
    ]
}
#endif

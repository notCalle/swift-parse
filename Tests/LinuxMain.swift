import XCTest

import ParseTests

var tests = [XCTestCaseEntry]()
tests += testCase(ParserTests.allTests)
tests += testCase(CharacterParserTests.allTests)
tests += testCase(CombinedParserTests.allTests)
tests += testCase(RecursiveParserTests.allTests)
XCTMain(tests)

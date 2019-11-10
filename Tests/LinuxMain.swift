import XCTest

import ParseTests

var tests = [XCTestCaseEntry]()
tests += testCase(ParserTests.allTests)
tests += testCase(CharacterParserTests.allTests)
XCTMain(tests)

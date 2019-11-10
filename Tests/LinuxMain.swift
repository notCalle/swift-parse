import XCTest

import ParseTests

var tests = [XCTestCaseEntry]()
tests += testCase(ParserTests.allTests)
XCTMain(tests)

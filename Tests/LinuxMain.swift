import XCTest

import DefaultsWrapperTests

var tests = [XCTestCaseEntry]()
tests += DefaultsWrapperTests.allTests()
tests += UserDefaultsExtensionTests.allTests()

XCTMain(tests)

//
//  String+ExtensionsTests.swift
//  Redux.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 4/25/24.
//

import XCTest
@testable import Redux_Demo_SwiftUI

class String_Extensions_Tests: XCTestCase {
  func test_when_initialized_from_empty_extension() {
    let string: String = .empty
    XCTAssertEqual(string, "")
  }
}

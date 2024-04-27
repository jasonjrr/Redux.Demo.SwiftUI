//
//  EdgeInsets+ExtensionsTests.swift
//  Redux.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 4/24/24.
//

import XCTest
import SwiftUI
@testable import Redux_Demo_SwiftUI

class EdgeInsets_Extensions_Tests: XCTestCase {
  func test_when_initialized_with_all() {
    let expected = 10.0
    let subject = EdgeInsets(all: expected)
    XCTAssertEqual(subject.leading, expected)
    XCTAssertEqual(subject.top, expected)
    XCTAssertEqual(subject.trailing, expected)
    XCTAssertEqual(subject.bottom, expected)
  }
  
  func test_when_initialized_with_horizontal_and_vertical() {
    let horizontal = 10.0
    let vertical = 15.0
    let subject = EdgeInsets(horizontal: horizontal, vertical: vertical)
    XCTAssertEqual(subject.leading, horizontal)
    XCTAssertEqual(subject.top, vertical)
    XCTAssertEqual(subject.trailing, horizontal)
    XCTAssertEqual(subject.bottom, vertical)
  }
  
  func test_when_initialized_with_top_and_remaining() {
    let top = 10.0
    let remaining = 15.0
    let subject = EdgeInsets(top: top, and: remaining)
    XCTAssertEqual(subject.leading, remaining)
    XCTAssertEqual(subject.top, top)
    XCTAssertEqual(subject.trailing, remaining)
    XCTAssertEqual(subject.bottom, remaining)
  }
  
  func test_when_initialized_from_all_extension() {
    let expected = 10.0
    let subject = EdgeInsets.all(expected)
    XCTAssertEqual(subject.leading, expected)
    XCTAssertEqual(subject.top, expected)
    XCTAssertEqual(subject.trailing, expected)
    XCTAssertEqual(subject.bottom, expected)
  }
  
  func test_when_initialized_from_horizontal_and_vertical_extension() {
    let horizontal = 10.0
    let vertical = 15.0
    let subject = EdgeInsets.horizontal(horizontal, vertical: vertical)
    XCTAssertEqual(subject.leading, horizontal)
    XCTAssertEqual(subject.top, vertical)
    XCTAssertEqual(subject.trailing, horizontal)
    XCTAssertEqual(subject.bottom, vertical)
  }
  
  func test_when_initialized_from_top_and_remaining_extension() {
    let top = 10.0
    let remaining = 15.0
    let subject = EdgeInsets.top(top, and: remaining)
    XCTAssertEqual(subject.leading, remaining)
    XCTAssertEqual(subject.top, top)
    XCTAssertEqual(subject.trailing, remaining)
    XCTAssertEqual(subject.bottom, remaining)
  }
}

//
//  ColorServiceTests.swift
//  Redux.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 4/26/24.
//

import XCTest
@testable import Redux_Demo_SwiftUI

class ColorServiceTest: XCTestCase {
  var colorService: ColorService!
  
  override func setUp() async throws {
    try await super.setUp()
    self.colorService = ColorService()
  }
}

class ColorService_when_getNextColor_executed: ColorServiceTest {
  func test_then_result_is_expected() {
    XCTAssertEqual(self.colorService.getNextColor(), .blue)
    XCTAssertEqual(self.colorService.getNextColor(), .green)
    XCTAssertEqual(self.colorService.getNextColor(), .orange)
    XCTAssertEqual(self.colorService.getNextColor(), .pink)
    XCTAssertEqual(self.colorService.getNextColor(), .purple)
    XCTAssertEqual(self.colorService.getNextColor(), .red)
    XCTAssertEqual(self.colorService.getNextColor(), .yellow)
    XCTAssertEqual(self.colorService.getNextColor(), .blue)
    XCTAssertEqual(self.colorService.getNextColor(), .green)
    XCTAssertEqual(self.colorService.getNextColor(), .orange)
    XCTAssertEqual(self.colorService.getNextColor(), .pink)
    XCTAssertEqual(self.colorService.getNextColor(), .purple)
    XCTAssertEqual(self.colorService.getNextColor(), .red)
    XCTAssertEqual(self.colorService.getNextColor(), .yellow)
  }
}

class ColorService_when_generateColors_executed: ColorServiceTest {
  func test_then_result_is_expected() async throws {
    let result = try await self.colorService
      .generateColors(every: 0.01)
      .collect(.byTime(RunLoop.main, .seconds(1)))
      .eraseToAnyPublisher()
      .async()
    result.forEach {
      XCTAssertTrue(ColorModel.allCases.contains($0))
    }
  }
}

//
//  UIReducer+ColorWizardTests.swift
//  Redux.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 4/27/24.
//

import XCTest
@testable import Redux_Demo_SwiftUI

class UIReducer_ColorWizardTests: XCTestCase {
  var colorService: ColorService!
  var colorWizardState: UIState.ColorWizardState!
  
  override func setUp() async throws {
    try await super.setUp()
    self.colorService = ColorService()
    self.colorWizardState = await self.colorService.fetchColorWizardState()
  }
  
  func test_when_state_is_nil_all_actions_return_nil() {
    XCTAssertNil(UIReducer.ColorWizardReducer.reduce(nil, action: .onBack))
    XCTAssertNil(UIReducer.ColorWizardReducer.reduce(nil, action: .onNext))
    XCTAssertNil(UIReducer.ColorWizardReducer.reduce(nil, action: .onFinish))
  }
  
  func test_when_state_is_not_nil() {
    var actual = UIReducer.ColorWizardReducer.reduce(self.colorWizardState, action: .onBack)
    XCTAssertEqual(actual, self.colorWizardState)
    
    actual = UIReducer.ColorWizardReducer.reduce(self.colorWizardState, action: .onNext)
    var expectedScreens = self.colorWizardState.screens
    expectedScreens[0].next = .push
    XCTAssertEqual(
      actual,
      UIState.ColorWizardState(
        id: self.colorWizardState.id,
        screens: expectedScreens,
        currentScreenIndex: 1,
        canMoveBack: true,
        canMoveNext: true,
        canFinish: false))
    
    actual = UIReducer.ColorWizardReducer.reduce(actual, action: .onBack)
    expectedScreens = self.colorWizardState.screens
    expectedScreens[0].next = .none
    XCTAssertEqual(
      actual,
      UIState.ColorWizardState(
        id: self.colorWizardState.id,
        screens: expectedScreens,
        currentScreenIndex: 0,
        canMoveBack: false,
        canMoveNext: true,
        canFinish: false))
    
    actual = UIReducer.ColorWizardReducer.reduce(self.colorWizardState, action: .onNext)
    actual = UIReducer.ColorWizardReducer.reduce(actual, action: .onNext)
    actual = UIReducer.ColorWizardReducer.reduce(actual, action: .onNext)
    actual = UIReducer.ColorWizardReducer.reduce(actual, action: .onNext)
    actual = UIReducer.ColorWizardReducer.reduce(actual, action: .onNext)
    expectedScreens = self.colorWizardState.screens
    expectedScreens[0].next = .push
    expectedScreens[1].next = .push
    expectedScreens[2].next = .push
    expectedScreens[3].next = .push
    expectedScreens[4].next = .push
    XCTAssertEqual(
      actual,
      UIState.ColorWizardState(
        id: self.colorWizardState.id,
        screens: expectedScreens,
        currentScreenIndex: 5,
        canMoveBack: true,
        canMoveNext: false,
        canFinish: true))
    
    actual = UIReducer.ColorWizardReducer.reduce(actual, action: .onNext)
    XCTAssertEqual(
      actual,
      UIState.ColorWizardState(
        id: self.colorWizardState.id,
        screens: expectedScreens,
        currentScreenIndex: 5,
        canMoveBack: true,
        canMoveNext: false,
        canFinish: true))
  }
}

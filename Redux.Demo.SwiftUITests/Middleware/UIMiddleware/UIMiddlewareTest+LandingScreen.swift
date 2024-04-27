//
//  UIMiddlewareTest+LandingScreen.swift
//  Redux.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 4/25/24.
//

import XCTest
@testable import Redux_Demo_SwiftUI

class UIMiddleware_when_ui_landingScreen: UIMiddlewareTest {
  func test_and_onPulseTapped_is_executed_then_input_action_is_returned() async {
    let action = Actions.uiAction(.landingScreen(.onPulseTapped))
    let result = await self.subject(action: action, dispatcher: self.store.eraseToAnyStoreDispatcher())
    XCTAssertEqual(result, .action(action))
  }
  
  func test_and_onSignInTapped_is_executed_then_input_action_is_returned() async {
    let action = Actions.uiAction(.landingScreen(.onSignInTapped))
    let result = await self.subject(action: action, dispatcher: self.store.eraseToAnyStoreDispatcher())
    XCTAssertEqual(result, .action(action))
  }
  
  func test_and_dismissSignInModal_is_executed_then_input_action_is_returned() async {
    let action = Actions.uiAction(.landingScreen(.dismissSignInModal))
    let result = await self.subject(action: action, dispatcher: self.store.eraseToAnyStoreDispatcher())
    XCTAssertEqual(result, .action(action))
  }
  
  func test_and_dismissPulseView_is_executed_then_input_action_is_returned() async {
    let action = Actions.uiAction(.landingScreen(.dismissPulseView))
    let result = await self.subject(action: action, dispatcher: self.store.eraseToAnyStoreDispatcher())
    XCTAssertEqual(result, .action(action))
  }
  
  func test_and_setColorWizardState_is_executed_then_input_action_is_returned() async {
    let action = Actions.uiAction(.landingScreen(.setColorWizardState(nil)))
    let result = await self.subject(action: action, dispatcher: self.store.eraseToAnyStoreDispatcher())
    XCTAssertEqual(result, .action(action))
  }
}

class UIMiddleware_when_ui_landingScreen_onSignOutTapped_is_executed: UIMiddlewareTest {
  var action: Actions!
  var result: Redux.MiddlewareResult!
  
  override func setUp() async throws {
    try await super.setUp()
    self.action = .uiAction(.landingScreen(.onSignOutTapped))
    self.result = await self.subject(action: self.action, dispatcher: self.store.eraseToAnyStoreDispatcher())
  }
  
  func test_then_result_is_handled() {
    XCTAssertEqual(self.result, .handled)
  }
  
  func test_then_actions_cache_contains_expected_actions() {
    let expected: [Actions] = [
      .userAction(.signOut),
    ]
    XCTAssertEqual(self.actionsCache.actions, expected)
  }
}

class UIMiddleware_when_ui_landingScreen_onStartColorWizard_is_executed: UIMiddlewareTest {
  var action: Actions!
  var result: Redux.MiddlewareResult!
  
  override func setUp() async throws {
    try await super.setUp()
    self.action = .uiAction(.landingScreen(.onStartColorWizard))
    self.result = await self.subject(action: self.action, dispatcher: self.store.eraseToAnyStoreDispatcher())
  }
  
  func test_then_result_is_handled() {
    XCTAssertEqual(self.result, .handled)
  }
  
  func test_then_actions_cache_contains_expected_actions() {
    let config = ColorWizardConfiguration.mock()
    let screens = config.pages.compactMap { page in
      if let color = page.color {
        return UIState.ColorWizardScreenState(title: page.title, data: .color(color))
      } else if let colors = page.colors {
        return UIState.ColorWizardScreenState(title: page.title, data: .summary(colors))
      } else {
        return nil
      }
    }
    let colorWizardState = UIState.ColorWizardState(
      screens: screens, currentScreenIndex: 0,
      canMoveBack: false,
      canMoveNext: screens.count > 1,
      canFinish: screens.count == 1)
    
    let expected: [Actions] = [
      .uiAction(.landingScreen(.setColorWizardState(colorWizardState)))
    ]
    XCTAssertEqual(self.actionsCache.actions, expected)
  }
}

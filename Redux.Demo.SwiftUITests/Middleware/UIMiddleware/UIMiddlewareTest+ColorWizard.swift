//
//  UIMiddlewareTest+ColorWizard.swift
//  Redux.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 4/25/24.
//

import XCTest
@testable import Redux_Demo_SwiftUI

class UIMiddleware_when_ui_colorWizard: UIMiddlewareTest {
  func test_and_onBack_is_executed_then_input_action_is_returned() async {
    let action = Actions.ui(.colorWizard(.onBack))
    let result = await self.subject(action: action, dispatcher: self.store.eraseToAnyStoreDispatcher())
    XCTAssertEqual(result, .action(action))
  }
  
  func test_and_onNext_is_executed_then_input_action_is_returned() async {
    let action = Actions.ui(.colorWizard(.onNext))
    let result = await self.subject(action: action, dispatcher: self.store.eraseToAnyStoreDispatcher())
    XCTAssertEqual(result, .action(action))
  }
}

class UIMiddleware_when_ui_colorWizard_onFinished_is_executed: UIMiddlewareTest {
  var action: Actions!
  var result: Redux.MiddlewareResult!
  
  override func setUp() async throws {
    try await super.setUp()
    self.action = .uiAction(.colorWizard(.onFinish))
    self.result = await self.subject(action: self.action, dispatcher: self.store.eraseToAnyStoreDispatcher())
  }
  
  func test_then_result_is_handled() {
    XCTAssertEqual(self.result, .handled)
  }
  
  func test_then_actions_cache_contains_expected_actions() {
    let expected: [Actions] = [
      .uiAction(.landingScreen(.setColorWizardState(nil))),
    ]
    XCTAssertEqual(self.actionsCache.actions, expected)
  }
}

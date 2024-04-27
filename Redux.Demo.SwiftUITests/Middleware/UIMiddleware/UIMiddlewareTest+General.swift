//
//  UIMiddlewareTest+General.swift
//  Redux.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 4/25/24.
//

import XCTest
@testable import Redux_Demo_SwiftUI

class UIMiddleware_when_ui_general_presentFailedToSignInAlert_is_executed: UIMiddlewareTest {
  func test_then_input_action_is_returned() async {
    let username = "test.username"
    let action = Actions.ui(.general(.presentFailedToSignInAlert(error: TestError.test, username: username)))
    let result = await self.subject(action: action, dispatcher: self.store.eraseToAnyStoreDispatcher())
    XCTAssertEqual(result, .action(action))
  }
}

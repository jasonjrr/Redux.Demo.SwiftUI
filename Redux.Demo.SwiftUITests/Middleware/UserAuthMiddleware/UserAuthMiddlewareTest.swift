//
//  UserAuthMiddlewareTest.swift
//  Redux.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 4/25/24.
//

import XCTest
@testable import Redux_Demo_SwiftUI
import BusyIndicator

class UserAuthMiddlewareTest: XCTestCase {
  var busyIndicatorService: BusyIndicatorService!
  var actionsCache: ActionsCacheReducer!
  var store: AppReduxStore!
  var subject: UserAuthMiddleware!
  
  override func setUp() async throws {
    try await super.setUp()
    self.busyIndicatorService = BusyIndicatorService()
    self.subject = UserAuthMiddleware(busyIndicatorService: self.busyIndicatorService)
    self.actionsCache = ActionsCacheReducer()
    self.store = AppReduxStore { [weak actionsCache] state, action in
      actionsCache?.append(action)
      return AppReducer.reduce(state, action: action)
    } middleware: {
      self.subject
    }
  }
}

class UserAuthMiddleware_when_signIn_executed_and_username_and_password_are_empty: UserAuthMiddlewareTest {
  var action: Actions!
  var result: Redux.MiddlewareResult!
  
  override func setUp() async throws {
    try await super.setUp()
    self.action = .userAction(.signIn(username: .empty, password: .empty))
    self.result = await self.subject(action: self.action, dispatcher: self.store.eraseToAnyStoreDispatcher())
  }
  
  func test_then_result_is_user_setFailedToSignIn() {
    XCTAssertEqual(self.result, .action(Actions.userAction(.setFailedToSignIn(
      error: UserAuthMiddleware.Errors.failedToSignIn(
        username: .empty, password: .empty),
      username: .empty,
      password: .empty)))
    )
  }
}

class UserAuthMiddleware_when_signIn_executed_and_username_and_password_are_valid: UserAuthMiddlewareTest {
  var action: Actions!
  var result: Redux.MiddlewareResult!
  
  override func setUp() async throws {
    try await super.setUp()
    self.action = .userAction(.signIn(username: "username", password: "password"))
    self.result = await self.subject(action: self.action, dispatcher: self.store.eraseToAnyStoreDispatcher())
  }
  
  func test_then_result_is_handled() {
    XCTAssertEqual(self.result, .handled)
  }
  
  func test_then_actions_cache_contains_expected_actions() {
    let expected: [Actions] = [
      .userAction(.signInSuccessful(username: "username")),
      .uiAction(.landingScreen(.dismissSignInModal)),
    ]
    XCTAssertEqual(self.actionsCache.actions, expected)
  }
}

class UserAuthMiddleware_when_setFailedToSignIn_executed: UserAuthMiddlewareTest {
  var action: Actions!
  var result: Redux.MiddlewareResult!
  
  override func setUp() async throws {
    try await super.setUp()
    self.action = .userAction(.setFailedToSignIn(error: UserAuthMiddleware.Errors.failedToSignIn(username: "username", password: "password"), username: "username", password: "password"))
    self.result = await self.subject(action: self.action, dispatcher: self.store.eraseToAnyStoreDispatcher())
  }
  
  func test_then_result_is_handled() {
    XCTAssertEqual(self.result, .handled)
  }
  
  func test_then_actions_cache_contains_expected_actions() {
    let expected: [Actions] = [
      .uiAction(.landingScreen(.dismissSignInModal)),
      .uiAction(.general(.presentFailedToSignInAlert(error: UserAuthMiddleware.Errors.failedToSignIn(username: "username", password: "password"), username: "username"))),
    ]
    XCTAssertEqual(self.actionsCache.actions, expected)
  }
}

class UserAuthMiddleware_when_signInSuccessful_executed: UserAuthMiddlewareTest {
  var action: Actions!
  var result: Redux.MiddlewareResult!
  
  override func setUp() async throws {
    try await super.setUp()
    self.action = .userAction(.signInSuccessful(username: "username"))
    self.result = await self.subject(action: self.action, dispatcher: self.store.eraseToAnyStoreDispatcher())
  }
  
  func test_then_result_is_action() {
    XCTAssertEqual(self.result, .action(self.action))
  }
}

class UserAuthMiddleware_when_signOut_executed: UserAuthMiddlewareTest {
  var action: Actions!
  var result: Redux.MiddlewareResult!
  
  override func setUp() async throws {
    try await super.setUp()
    self.action = .userAction(.signOut)
    self.result = await self.subject(action: self.action, dispatcher: self.store.eraseToAnyStoreDispatcher())
  }
  
  func test_then_result_is_action() {
    XCTAssertEqual(self.result, .action(self.action))
  }
}

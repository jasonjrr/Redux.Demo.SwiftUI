//
//  UIMiddlewareTest.swift
//  Redux.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 4/25/24.
//

import XCTest
@testable import Redux_Demo_SwiftUI

class UIMiddlewareTest: XCTestCase {
  var actionsCache: ActionsCacheReducer!
  var store: AppReduxStore!
  var subject: UIMiddleware!
  
  override func setUp() async throws {
    try await super.setUp()
    self.subject = UIMiddleware()
    self.actionsCache = ActionsCacheReducer()
    self.store = AppReduxStore { [weak actionsCache] state, action in
      actionsCache?.append(action)
      return AppReducer.reduce(state, action: action)
    } middleware: {
      self.subject
    }
  }
}

extension UIMiddlewareTest {
  enum TestError: LocalizedError {
    case test
  }
}

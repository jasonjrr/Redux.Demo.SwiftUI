//
//  UserAuthMiddleware.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/29/24.
//

import Foundation
import BusyIndicator

class UserAuthMiddleware: Redux.Middleware {
  enum Errors: Error {
    case failedToSignIn(username: String, password: String)
  }
  
  private let busyIndicatorService: BusyIndicatorServiceProtocol
  
  init(busyIndicatorService: any BusyIndicatorServiceProtocol) {
    self.busyIndicatorService = busyIndicatorService
  }
  
  func callAsFunction(action: Redux.Action, dispatcher: Redux.AnyStoreDispatcher) async -> Redux.MiddlewareResult {
    guard let newAction = action as? Actions else {
      return .action(action)
    }
    switch newAction {
    case .userAction(let userAction):
      return await handle(action: action, userAction: userAction, dispatcher: dispatcher)
    default:
      return .action(action)
    }
  }
  
  private func handle(action: some Redux.Action, userAction: Actions.UserActions, dispatcher: Redux.AnyStoreDispatcher) async -> Redux.MiddlewareResult {
    switch userAction {
    case .signIn(let username, let password):
      if username.isEmpty || password.isEmpty {
        return .action(
          .user(.setFailedToSignIn(
            error: Errors.failedToSignIn(username: username, password: password),
            username: username,
            password: password)))
      }
      await dispatcher.dispatch(action: .user(.signInSuccessful(username: username)))
      await dispatcher.dispatch(action: .ui(.landingScreen(.dismissSignInModal)))
      return .handled
      
    case .setFailedToSignIn(let error, let username, _):
      await dispatcher.dispatch(action: .ui(.landingScreen(.dismissSignInModal)))
      await dispatcher.dispatch(action: .ui(.general(.presentFailedToSignInAlert(error: error, username: username))))
      return .handled
      
    case .signInSuccessful: break
    case .signOut:
      let busySubject = self.busyIndicatorService.enqueue()
      try? await Task.sleep(for: .seconds(2))
      busySubject.dequeue()
    }
    return .action(action)
  }
}

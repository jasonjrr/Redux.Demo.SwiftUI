//
//  UIReducer+General.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Actions.UIActions {
  enum GeneralActions: Equatable {
    case presentFailedToSignInAlert(error: Error, username: String)
    
    static func == (lhs: GeneralActions, rhs: GeneralActions) -> Bool {
      switch (lhs, rhs) {
      case (.presentFailedToSignInAlert(let error1, let username1), .presentFailedToSignInAlert(let error2, let username2)):
        return error1.localizedDescription == error2.localizedDescription && username1 == username2
      default:
        return false
      }
    }
  }
}

extension UIState {
  struct GeneralState: Redux.State {
    var failedToSignInAlert: FailedToSignInAlert?
  }
  
  struct FailedToSignInAlert {
    let error: Error
    let username: String
  }
}

extension UIReducer {
  enum GeneralReducer {
    static func reduce(_ state: UIState.GeneralState, action: Actions.UIActions.GeneralActions) -> UIState.GeneralState {
      switch action {
      case .presentFailedToSignInAlert(let error, let username):
        var newState = state
        newState.failedToSignInAlert = UIState.FailedToSignInAlert(error: error, username: username)
        return newState
      }
    }
  }
}

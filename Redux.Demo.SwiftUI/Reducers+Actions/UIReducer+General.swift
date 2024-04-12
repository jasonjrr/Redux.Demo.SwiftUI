//
//  UIReducer+General.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Actions.UIActions {
  enum GeneralActions {
    case presentFailedToSignInAlert(error: Error, username: String)
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

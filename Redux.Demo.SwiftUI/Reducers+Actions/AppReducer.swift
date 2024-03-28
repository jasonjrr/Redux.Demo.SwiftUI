//
//  AppReducer.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/28/24.
//

import Foundation

/// Note: We only mark the root of actions as a `Redux.Action` to avoid sending a partial action.
enum Actions: Redux.Action {
  case uiAction(Actions.UIActions)
  case userAction(Actions.UserActions)
}

extension Redux.Action where Self == Actions {
  static func ui(_ action: Actions.UIActions) -> Redux.Action {
    Actions.uiAction(action)
  }
  static func user(_ action: Actions.UserActions) -> Redux.Action {
    Actions.userAction(action)
  }
}

struct AppState: Redux.State {
  var ui: UIState = UIState()
  var user: UserState = UserState()
  
  init() {}
}

enum AppReducer {
  static func reduce(_ state: AppState, action: Actions) -> AppState {
    var newState = state
    switch action {
    case .uiAction(let uiAction):
      newState.ui = UIReducer.reduce(newState.ui, action: uiAction)
    case .userAction(let userAction):
      newState.user = UserReducer.reduce(newState.user, action: userAction)
    }
    return newState
  }
}

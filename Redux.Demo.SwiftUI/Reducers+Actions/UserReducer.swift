//
//  UserReducer.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/28/24.
//

import Foundation

extension Actions {
  enum UserActions {
    case signIn(username: String, password: String)
    case setFailedToSignIn(error: Error, username: String, password: String)
    case signInSuccessful(username: String)
    case signOut
  }
}

struct UserState: Redux.State {
  var username: String? = nil
  var userSignInError: Error? = nil
  
  init() {}
}

enum UserReducer {
  static func reduce(_ state: UserState, action: Actions.UserActions) -> UserState {
    switch action {
    case .signIn: return state
    case .setFailedToSignIn(let error, _, _):
      var newState = state
      newState.userSignInError = error
      return newState
    case .signInSuccessful(let username):
      var newState = state
      newState.username = username
      newState.userSignInError = nil
      return newState
      
    case .signOut:
      var newState = state
      newState.username = nil
      newState.userSignInError = nil
      return newState
    }
  }
}

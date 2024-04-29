//
//  UserReducer.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/28/24.
//

import Foundation

extension Actions {
  enum UserActions: Equatable {
    case signIn(username: String, password: String)
    case setFailedToSignIn(error: Error, username: String, password: String)
    case signInSuccessful(username: String)
    case signOut
    
    static func == (lhs: UserActions, rhs: UserActions) -> Bool {
      switch (lhs, rhs) {
      case (.signIn(let username1, let password1), .signIn(let username2, let password2)):
        return username1 == username2 && password1 == password2
      case (.setFailedToSignIn(let error1, let username1, let password1), .setFailedToSignIn(let error2, let username2, let password2)):
        return error1.localizedDescription == error2.localizedDescription && username1 == username2 && password1 == password2
      case (.signInSuccessful(let username1), .signInSuccessful(let username2)):
        return username1 == username2
      case (.signOut, .signOut):
        return true
      default:
        return false
      }
    }
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

//
//  UIReducer+LandingScreen.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Actions.UIActions {
  enum LandingScreenActions {
    case onSignInTapped
    case onSignOutTapped
    case onPulseTapped
    case onStartColorWizard
    case dismissSignInModal
    case dismissPulseView
    
    case setColorWizardState(UIState.ColorWizardState?)
  }
}

extension UIState {
  struct LandingScreenState: Redux.State {
    var showSignInModal: Bool = false
    var showPulseScreen: Bool = false
    var colorWizard: ColorWizardState?
  }
}

extension UIReducer {
  enum LandingScreenReducer {
    static func reduce(_ state: UIState.LandingScreenState, action: Actions.UIActions.LandingScreenActions) -> UIState.LandingScreenState {
      switch action {
      case .onSignInTapped:
        var newState = state
        newState.showSignInModal = true
        return newState
      case .onSignOutTapped:
        fatalError("Handled in UIMiddleware")
      case .onPulseTapped:
        var newState = state
        newState.showPulseScreen = true
        return newState
      case .onStartColorWizard:
        fatalError("Handled in UIMiddleware")
      case .dismissSignInModal:
        var newState = state
        newState.showSignInModal = false
        return newState
      case .dismissPulseView:
        var newState = state
        newState.showPulseScreen = false
        return newState
        
      case .setColorWizardState(let colorWizardState):
        var newState = state
        newState.colorWizard = colorWizardState
        return newState
      }
    }
  }
}

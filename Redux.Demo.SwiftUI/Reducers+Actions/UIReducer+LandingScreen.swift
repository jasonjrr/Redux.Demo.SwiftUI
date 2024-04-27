//
//  UIReducer+LandingScreen.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Actions.UIActions {
  enum LandingScreenActions: Equatable {
    case onSignInTapped
    case onSignOutTapped
    case onPulseTapped
    case onStartColorWizard
    case dismissSignInModal
    case dismissPulseView
    
    case setColorWizardState(UIState.ColorWizardState?)
    
    static func == (lhs: LandingScreenActions, rhs: LandingScreenActions) -> Bool {
      switch (lhs, rhs) {
      case (.onSignInTapped, .onSignInTapped),
        (.onSignOutTapped, .onSignOutTapped),
        (.onPulseTapped, .onPulseTapped),
        (.onStartColorWizard, .onStartColorWizard),
        (.dismissSignInModal, .dismissSignInModal),
        (.dismissPulseView, .dismissPulseView):
        return true
      case (.setColorWizardState(let colorWizardState1), .setColorWizardState(let colorWizardState2)):
        return colorWizardState1 == colorWizardState2
      default:
        return false
      }
    }
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

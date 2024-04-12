//
//  UIReducer.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/29/24.
//

import Foundation

extension Actions {
  enum UIActions {
    case general(GeneralActions)
    
    case colorWizard(ColorWizardActions)
    case landingScreen(LandingScreenActions)
  }
}

struct UIState: Redux.State {
  var general: GeneralState = GeneralState()
  var landingScreen: LandingScreenState = LandingScreenState()
  
  init() {}
}

enum UIReducer {
  static func reduce(_ state: UIState, action: Actions.UIActions) -> UIState {
    switch action {
    case .general(let action):
      var newState = state
      newState.general = GeneralReducer.reduce(newState.general, action: action)
      return newState
    case .landingScreen(let action):
      var newState = state
      newState.landingScreen = LandingScreenReducer.reduce(newState.landingScreen, action: action)
      return newState
    case .colorWizard(let action):
      var newState = state
      newState.landingScreen.colorWizard = ColorWizardReducer
        .reduce(
          newState.landingScreen.colorWizard,
          action: action)
      return newState
    }
  }
}

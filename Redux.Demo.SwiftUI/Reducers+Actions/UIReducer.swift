//
//  UIReducer.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/29/24.
//

import Foundation

// MARK: Actions
extension Actions {
  enum UIActions {
    case general(GeneralActions)
    
    case colorWizard(ColorWizardActions)
    case landingScreen(LandingScreenActions)
  }
}

extension Actions.UIActions {
  enum GeneralActions {
    case presentFailedToSignInAlert(error: Error, username: String)
  }
}

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

extension Actions.UIActions {
  enum ColorWizardActions {
    case onBack
    case onNext
    case onFinish
  }
}

// MARK: State
struct UIState: Redux.State {
  var general: GeneralState = GeneralState()
  var landingScreen: LandingScreenState = LandingScreenState()
  
  init() {}
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

extension UIState {
  struct LandingScreenState: Redux.State {
    var showSignInModal: Bool = false
    var showPulseScreen: Bool = false
    var colorWizard: ColorWizardState?
  }
}

extension UIState {
  struct ColorWizardState: Identifiable, Hashable {
    var id: UUID = UUID()
    
    var screens: [ColorWizardScreenState]
    var currentScreenIndex: Int
    
    var canMoveBack: Bool
    var canMoveNext: Bool
    var canFinish: Bool
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(screens)
      hasher.combine(self.currentScreenIndex)
    }
    
    static func ==(lhs: ColorWizardState, rhs: ColorWizardState) -> Bool {
      if lhs.screens.count == rhs.screens.count {
        for i in 0..<lhs.screens.count {
          if lhs.screens[i] != rhs.screens[i] {
            return false
          }
        }
      }
      return lhs.currentScreenIndex == rhs.currentScreenIndex
    }
  }
  
  struct ColorWizardScreenState: Hashable {
    enum Screen: Hashable {
      case color(ColorModel)
      case summary([ColorModel])
      
      func hash(into hasher: inout Hasher) {
        switch self {
        case .color(let colorModel):
          hasher.combine(colorModel)
        case .summary(let colorModels):
          hasher.combine(colorModels)
        }
      }
    }
    indirect enum Next: Hashable {
      case none
      case push
      
      func hash(into hasher: inout Hasher) {
        switch self {
        case .none:
          hasher.combine("none")
        case .push:
          hasher.combine("push")
        }
      }
    }
    
    var title: String
    var data: Screen
    var next: Next
    
    init(title: String, data: Screen) {
      self.title = title
      self.data = data
      self.next = .none
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(self.title)
      hasher.combine(self.data)
      hasher.combine(self.next)
    }
    
    static func ==(lhs: ColorWizardScreenState, rhs: ColorWizardScreenState) -> Bool {
      if lhs.title != rhs.title {
        return false
      }
      switch lhs.data {
      case .color(let lhsColorModel):
        switch rhs.data {
        case .color(let rhsColorModel):
          if lhsColorModel != rhsColorModel {
            return false
          }
        default:
          return false
        }
      case .summary(let lhsColorModels):
        switch rhs.data {
        case .summary(let rhsColorModels):
          if lhsColorModels != rhsColorModels {
            return false
          }
        default:
          return false
        }
      }
      
      switch lhs.next {
      case .none:
        switch rhs.next {
        case .none: break
        default:
          return false
        }
      case .push:
        switch rhs.next {
        case .none:
          return false
        case .push: break
        }
      }
      
      return true
    }
  }
}

// MARK: Reducers
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

extension UIReducer {
  enum ColorWizardReducer {
    static func reduce(_ state: UIState.ColorWizardState?, action: Actions.UIActions.ColorWizardActions) -> UIState.ColorWizardState? {
      switch action {
      case .onBack:
        guard var state else {
          return nil
        }
        guard state.currentScreenIndex > 0 else {
          return state
        }
        state.currentScreenIndex = state.currentScreenIndex - 1
        state.screens[state.currentScreenIndex].next = .none
        state.canMoveBack = state.currentScreenIndex > 0
        state.canMoveNext = state.currentScreenIndex + 1 < state.screens.count
        state.canFinish = state.currentScreenIndex + 1 == state.screens.count
        return state
        
      case .onNext:
        guard var state else {
          return nil
        }
        guard state.currentScreenIndex + 1 < state.screens.count else {
          return state
        }
        state.screens[state.currentScreenIndex].next = .push
        state.currentScreenIndex = state.currentScreenIndex + 1
        state.canMoveBack = true
        state.canMoveNext = state.currentScreenIndex + 1 < state.screens.count
        state.canFinish = state.currentScreenIndex + 1 == state.screens.count
        return state
        
      case .onFinish:
        fatalError("Handled in middleware")
      }
    }
  }
}

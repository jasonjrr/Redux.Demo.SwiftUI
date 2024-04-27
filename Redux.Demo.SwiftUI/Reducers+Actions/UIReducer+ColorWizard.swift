//
//  UIReducer+ColorWizard.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Actions.UIActions {
  enum ColorWizardActions: Equatable {
    case onBack
    case onNext
    case onFinish
    
    static func == (lhs: ColorWizardActions, rhs: ColorWizardActions) -> Bool {
      switch (lhs, rhs) {
      case (.onBack, .onBack), (.onNext, .onNext), (.onFinish, .onFinish):
        return true
      default:
        return false
      }
    }
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
      switch (lhs.data, rhs.data) {
      case (.color(let lhsColorModel), .color(let rhsColorModel)):
        if lhsColorModel != rhsColorModel {
          return false
        }
      case (.summary(let lhsColorModels), .summary(let rhsColorModels)):
        if lhsColorModels != rhsColorModels {
          return false
        }
      default:
        return false
      }
      switch (lhs.next, rhs.next) {
      case (.none, .none): break
      case (.push, .push): break
      default:
        return false
      }
      return true
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

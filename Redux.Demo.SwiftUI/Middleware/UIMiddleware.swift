//
//  UIMiddleware.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/3/24.
//

import Foundation

struct UIMiddleware: Redux.Middleware {
  func callAsFunction(action: any Redux.Action, dispatcher: Redux.AnyStoreDispatcher) async -> Redux.MiddlewareResult {
    guard let newAction = action as? Actions else {
      return .action(action)
    }
    switch newAction {
    case .uiAction(let uiAction):
      return await handle(action: action, uiAction: uiAction, dispatcher: dispatcher)
    default:
      return .action(action)
    }
  }
  
  private func handle(action: some Redux.Action, uiAction: Actions.UIActions, dispatcher: Redux.AnyStoreDispatcher) async -> Redux.MiddlewareResult {
    switch uiAction {
    case .general: return .action(action)
    case .colorWizard(let colorWizardAction):
      return await handle(action: action, colorWizardAction: colorWizardAction, dispatcher: dispatcher)
    case .landingScreen(let landingScreenAction):
      switch landingScreenAction {
      case .onSignInTapped, .onPulseTapped, .dismissSignInModal, .dismissPulseView, .setColorWizardState:
        return .action(action)
      case .onSignOutTapped:
        await dispatcher.dispatch(action: .user(.signOut))
        return .handled
      case .onStartColorWizard:
        let config = ColorWizardConfiguration.mock()
        let screens = config.pages.compactMap { page in
          if let color = page.color {
            return UIState.ColorWizardScreenState(title: page.title, data: .color(color))
          } else if let colors = page.colors {
            return UIState.ColorWizardScreenState(title: page.title, data: .summary(colors))
          } else {
            return nil
          }
        }
        let colorWizardState = UIState.ColorWizardState(
          screens: screens, currentScreenIndex: 0,
          canMoveBack: false,
          canMoveNext: screens.count > 1,
          canFinish: screens.count == 1)
        await dispatcher.dispatch(action: Actions.uiAction(.landingScreen(.setColorWizardState(colorWizardState))))
        return .handled
      }
    }
  }
}

extension UIMiddleware {
  private func handle(
    action: some Redux.Action,
    colorWizardAction: Actions.UIActions.ColorWizardActions,
    dispatcher: Redux.AnyStoreDispatcher
  ) async -> Redux.MiddlewareResult {
    switch colorWizardAction {
    case .onBack, .onNext:
      return .action(action)
    case .onFinish:
      await dispatcher.dispatch(action: Actions.uiAction(.landingScreen(.setColorWizardState(nil))))
      return .handled
    }
  }
}

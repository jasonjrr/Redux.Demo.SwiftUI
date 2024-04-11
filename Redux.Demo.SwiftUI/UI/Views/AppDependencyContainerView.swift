//
//  AppDependencyContainerView.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/4/24.
//

import SwiftUI
import BusyIndicator

typealias AppReduxStore = Redux.Store<AppState, Actions>

fileprivate let busyIndicatorService: BusyIndicatorServiceProtocol = {
  let config = BusyIndicatorConfiguration()
  config.showBusyIndicatorDelay = 100
  return BusyIndicatorService(configuration: config)
}()

fileprivate let colorService: ColorService = ColorService()

struct AppDependencyContainerView<Content: View>: View {
  @StateObject var store: AppReduxStore = AppReduxStore { state, action in
    AppReducer.reduce(state, action: action)
  } middleware: {
    UserAuthMiddleware(busyIndicatorService: busyIndicatorService)
    UIMiddleware()
  }
  
  private let content: () -> Content
  private let startingActions: ((AppReduxStore) async -> Void)?
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.startingActions = nil
    self.content = content
  }
  
  init(
    startingActions: @escaping (AppReduxStore) async -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.startingActions = startingActions
    self.content = content
  }
  
  var body: some View {
    self.content()
      .reduxStore(self.store)
      .busyIndicator(busyIndicatorService.busyIndicator)
      .environmentObject(colorService)
      .task {
        await self.startingActions?(self.store)
      }
  }
}

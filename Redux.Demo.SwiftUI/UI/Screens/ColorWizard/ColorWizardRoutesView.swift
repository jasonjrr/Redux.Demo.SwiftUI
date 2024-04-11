//
//  ColorWizardRoutesView.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/6/24.
//

import SwiftUI

struct ColorWizardRoutesView: View {
  @EnvironmentObject var store: AppReduxStore
  
  @State private var path = NavigationPath()
  
  init() {}
  
  var body: some View {
    NavigationStack(path: self.$path) {
      DestinationView(state: nil, index: 0)
    }
  }
}

extension ColorWizardRoutesView {
  fileprivate struct ScreenView: View {
    private let state: UIState.ColorWizardScreenState?
    private let index: Int
    
    init(state: UIState.ColorWizardScreenState?, index: Int) {
      self.state = state
      self.index = index
    }
    
    @ViewBuilder
    var body: some View {
      if let state {
        switch state.data {
        case .color(let colorModel):
          ColorWizardColorView(color: colorModel, index: self.index)
        case .summary(let colorModels):
          ColorWizardSummaryView(colors: colorModels, index: self.index)
        }
      }
    }
  }
  
  fileprivate struct DestinationView: View {
    @EnvironmentObject private var store: AppReduxStore
    
    private let index: Int
    
    @State var state: UIState.ColorWizardScreenState?
    @State var canMoveBack: Bool = false
    @State var canMoveNext: Bool = false
    @State var canFinish: Bool = false
    
    @State var next: UIState.ColorWizardScreenState?
    
    init(state: UIState.ColorWizardScreenState?, index: Int) {
      self.state = state
      self.index = index
    }
    
    var body: some View {
      buildScreen(state: self.state, index: self.index)
        .onReceive(self.store.state
          .map { $0.ui.landingScreen.colorWizard }
          .filter { $0 != nil }
          .map { $0! }
          .receive(on: RunLoop.main)
        ) { (colorWizard: UIState.ColorWizardState) in
          self.state = colorWizard.screens[self.index]
          self.canMoveBack = colorWizard.canMoveBack
          self.canMoveNext = colorWizard.canMoveNext
          self.canFinish = colorWizard.canFinish
          
          switch self.state?.next {
          case .push:
            self.next = colorWizard.screens[self.index + 1]
          default:
            self.next = nil
          }
        }
        .navigationDestination(item: self.$next) { next in
          DestinationView(state: next, index: self.index + 1)
        }
    }
    
    @ViewBuilder
    private func buildScreen(state: UIState.ColorWizardScreenState?, index: Int) -> some View {
      ScreenView(state: state, index: index)
        .navigationTitle(state?.title ?? .empty)
        .navigationBarBackButtonHidden(true)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            if self.canMoveBack {
              Button {
                Task {
                  await self.store.dispatch(action: .uiAction(.colorWizard(.onBack)))
                }
              } label: {
                Text("Back")
              }
            }
          }
          ToolbarItem(placement: .navigationBarTrailing) {
            if self.canMoveNext {
              Button {
                Task {
                  await self.store.dispatch(action: .uiAction(.colorWizard(.onNext)))
                }
              } label: {
                Text("Forward")
              }
            } else if self.canFinish {
              Button {
                Task {
                  await self.store.dispatch(action: .uiAction(.colorWizard(.onFinish)))
                }
              } label: {
                Text("Done")
              }
            }
          }
        }
    }
  }
}

#Preview {
  AppDependencyContainerView { store in
    await store.dispatch(action: .uiAction(.landingScreen(.onStartColorWizard)))
  } content: {
    ColorWizardRoutesView()
  }
}

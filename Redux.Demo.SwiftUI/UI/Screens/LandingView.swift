//
//  LandingView.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/4/24.
//

import SwiftUI
import BusyIndicator

struct LandingView: View {
  @EnvironmentObject private var store: AppReduxStore
  @EnvironmentObject private var colorService: ColorService
  
  @ScaledMetric private var buttonPadding: CGFloat = 8.0
  @ScaledMetric private var inverseHorizontalPadding: CGFloat = 8.0
  
  @State private var isAuthenticated: Bool = false
  @State private var username: String = .empty
  @State private var pulseColor: Color = .accentColor
  
  @State private var showSignIn: Bool = false
  @State private var showPulseView: Bool = false
  @State private var colorWizard: UIState.ColorWizardState?
  
  var body: some View {
    ZStack {
      VStack(alignment: .center, spacing: 24.0) {
        signInOutButton()
        pulseButton()
        colorWizardButton()
      }
      .padding([.leading, .trailing], max(56.0 - self.inverseHorizontalPadding, 4.0))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay {
      if self.showSignIn {
        SignInCardView()
      }
    }
    .navigationBarHidden(true)
    .onReceive(self.store.state
      .map { $0.user.username }
      .removeDuplicates()
      .receive(on: RunLoop.main)
    ) { username in
      self.username = username ?? .empty
      self.isAuthenticated = username != nil
    }
    .onReceive(self.store.state
      .map { $0.ui.landingScreen.showSignInModal }
      .removeDuplicates()
      .receive(on: RunLoop.main)
    ) { showSignInModal in
      self.showSignIn = showSignInModal
    }
    .onReceive(self.store.state
      .map { $0.ui.landingScreen.showPulseScreen }
      .removeDuplicates()
      .debounce(for: 0.05, scheduler: RunLoop.main)
      .receive(on: RunLoop.main)
    ) { showPulseView in
      self.showPulseView = showPulseView
    }
    .onReceive(self.store.state
      .map { $0.ui.landingScreen.colorWizard }
      .removeDuplicates()
      .receive(on: RunLoop.main)
    ) {
      self.colorWizard = $0
    }
    .onChange(of: self.showPulseView) {
      if !self.showPulseView {
        Task {
          await self.store.dispatch(action:
            .uiAction(.landingScreen(.dismissPulseView)))
        }
      }
    }
    .onReceive(self.colorService
      .generateColors()
      .receive(on: RunLoop.main)
    ) { colorModel in
      withAnimation(.easeInOut) {
        self.pulseColor = colorModel.asColor()
      }
    }
    .navigationDestination(isPresented: self.$showPulseView) {
      PulseView()
    }
    .fullScreenCover(item: self.$colorWizard) { _ in
      ColorWizardRoutesView()
    }
  }
  
  private func signInOutButton() -> some View {
    Button {
      Task {
        if self.isAuthenticated {
          await self.store.dispatch(action:
              .uiAction(.landingScreen(.onSignOutTapped)))
        } else {
          await self.store.dispatch(action:
              .uiAction(.landingScreen(.onSignInTapped)))
        }
      }
    } label: {
      Text(self.isAuthenticated ? "Sign Out, \(self.username)" : "Sign In")
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .padding(self.buttonPadding)
        .frame(maxWidth: .infinity, minHeight: 54.0)
        .contentShape(Rectangle())
    }
    .buttonStyle(.brightBorderedButton)
    .busyOverlay()
    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
  }
  
  private func pulseButton() -> some View {
    Button {
      Task {
        await self.store.dispatch(action:
            .uiAction(.landingScreen(.onPulseTapped)))
      }
    } label: {
      Text("Pulse")
        .padding(self.buttonPadding)
        .frame(maxWidth: .infinity, minHeight: 54.0)
        .contentShape(Rectangle())
    }
    .buttonStyle(.brightBorderedButton(color: self.pulseColor))
  }
  
  private func colorWizardButton() -> some View {
    Button {
      Task {
        await self.store.dispatch(action: .uiAction(.landingScreen(.onStartColorWizard)))
      }
    } label: {
      Text("Color Wizard")
        .multilineTextAlignment(.center)
        .lineLimit(nil)
        .padding(self.buttonPadding)
        .frame(maxWidth: .infinity, minHeight: 54.0)
        .contentShape(Rectangle())
    }
    .buttonStyle(.brightBorderedButton)
    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
  }
}

#Preview {
  AppDependencyContainerView {
    NavigationStack {
      LandingView()
    }
  }
}

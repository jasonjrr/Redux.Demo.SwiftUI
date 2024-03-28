//
//  AppRootView.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/27/24.
//

import SwiftUI

struct AppRootView: View {
  @State private var path = NavigationPath()
  
  var body: some View {
    AppDependencyContainerView {
      NavigationStack(path: self.$path) {
        LandingView()   
      }
    }
  }
}

#Preview {
  AppRootView()
}

//
//  Redux+Store+Enviroment.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/29/24.
//

import SwiftUI

extension View {
  @inlinable
  public func reduxStore<S: Redux.State, A: Redux.Action>(_ store: Redux.Store<S, A>) -> some View {
    environmentObject(store)
  }
}

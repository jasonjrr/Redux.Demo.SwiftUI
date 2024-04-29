//
//  TestAppReduxStore.swift
//  Redux.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 4/25/24.
//

import Foundation
@testable import Redux_Demo_SwiftUI

class ActionsCacheReducer {
  private(set) var actions: [Actions] = []
  
  func append(_ action: Actions) {
    self.actions.append(action)
  }
}

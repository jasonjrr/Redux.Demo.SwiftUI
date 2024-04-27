//
//  Redux.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/27/24.
//

import Foundation

public enum Redux {}

extension Redux {
  public protocol Action: Equatable {}
}

extension Redux.Action {
  public func isEqual(to other: some Redux.Action) -> Bool {
    guard let other = other as? Self else { return false }
    return self == other
  }
  
  public func eraseToAnyAction() -> Redux.AnyAction {
    Redux.AnyAction(wrapped: self)
  }
}

extension Redux {
  public struct AnyAction: Redux.Action {
    public let wrapped: any Redux.Action
    
    init(wrapped: some Redux.Action) {
      self.wrapped = wrapped
    }
    
    public static func == (lhs: AnyAction, rhs: AnyAction) -> Bool {
      lhs.wrapped.isEqual(to: rhs.wrapped)
    }
  }
}

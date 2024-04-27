//
//  Redux+Middleware.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/28/24.
//

import Foundation

extension Redux {
  public enum MiddlewareResult: Equatable {
    case handled
    case action(any Redux.Action)
    
    public static func == (lhs: MiddlewareResult, rhs: MiddlewareResult) -> Bool {
      switch (lhs, rhs) {
      case (.handled, .handled):
        return true
      case (.action(let action1), .action(let action2)):
        return action1.eraseToAnyAction() == action2.eraseToAnyAction()
      default:
        return false
      }
    }
  }
  
  public protocol Middleware {
    func callAsFunction(action: any Redux.Action, dispatcher: Redux.AnyStoreDispatcher) async -> Redux.MiddlewareResult
  }
  
  struct EchoMiddleware: Middleware {
    public func callAsFunction(action: any Redux.Action, dispatcher: Redux.AnyStoreDispatcher) async -> Redux.MiddlewareResult {
      .action(action)
    }
  }
  
  public struct MiddlewarePipeline: Middleware {
    private let middleware: [any Middleware]
    
    public init(_ middleware: any Middleware...) {
      self.middleware = middleware
    }
    
    public init(_ middleware: [any Middleware]) {
      self.middleware = middleware
    }
    
    public func callAsFunction(action: any Redux.Action, dispatcher: Redux.AnyStoreDispatcher) async -> MiddlewareResult {
      var currentAction: any Redux.Action = action
      for m in middleware {
        let result = await m(action: currentAction, dispatcher: dispatcher)
        switch result {
        case .handled:
          return .handled
        case .action(let action):
          currentAction = action
        }
      }
      return .action(currentAction)
    }
  }
  
  @resultBuilder
  public struct MiddlewareBuilder {
    public static func buildArray(
      _ components: [MiddlewarePipeline]
    ) -> some Middleware {
      MiddlewarePipeline(components)
    }
    
    public static func buildBlock(
      _ components: any Middleware...
    ) -> MiddlewarePipeline {
      MiddlewarePipeline(components)
    }
    
    public static func buildEither<M: Middleware>(
      first component: M
    ) -> some Middleware {
      component
    }
    
    public static func buildEither<M: Middleware>(
      second component: M
    ) -> some Middleware {
      component
    }
    
    public static func buildExpression<M: Middleware>(
      _ expression: M
    ) -> some Middleware {
      expression
    }
    
    public static func buildFinalResult<M: Middleware>(
      _ component: M
    ) -> some Middleware {
      component
    }
    
    public static func buildOptional(
      _ component: MiddlewarePipeline?
    ) -> Middleware {
      guard let component = component else {
        return EchoMiddleware()
      }
      return component
    }
  }
}

extension Redux.Middleware {
  public func eraseToAnyMiddleware() -> some Redux.Middleware {
    self
  }
}

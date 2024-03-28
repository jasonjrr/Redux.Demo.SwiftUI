//
//  Redux+Store.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/28/24.
//

import Foundation
import Combine

extension Redux {
  public actor Store<S: Redux.State, A: Redux.Action>: ObservableObject {
    public typealias Reducer = (S, A) -> S
    
    private let _state: CurrentValueSubject<S, Never>
    public nonisolated var state: AnyPublisher<S, Never> { self._state.eraseToAnyPublisher() }
    
    private let middleware: Middleware
    private let reducer: Reducer
    
    public init(
      initialState: S = S(),
      reducer: @escaping Reducer,
      @MiddlewareBuilder middleware: () -> some Middleware
    ) {
      self._state = CurrentValueSubject(initialState)
      self.reducer = reducer
      self.middleware = middleware()
    }
    
    public init(
      initialState: S = S(),
      reducer: @escaping Reducer
    ) {
      self.init(
        initialState: initialState,
        reducer: reducer,
        middleware: {
          EchoMiddleware().eraseToAnyMiddleware()
        }
      )
    }
    
    public func dispatch(action: A) async {
      let result = await self.middleware(action: action, dispatcher: self.eraseToAnyStoreDispatcher())
      switch result {
      case .action(let action):
        guard let newAction = action as? A else {
          fatalError()
        }
        let currentState = self._state.value
        let newState = self.reducer(currentState, newAction)
        self._state.send(newState)
      case .handled:
        return
      }
    }
  }
}

extension Redux.Store {
  func dispatch(_ factory: () async -> A) async {
    await self.dispatch(action: await factory())
  }
  
  func dispatch<Seq: AsyncSequence>(
    sequence: Seq
  ) async throws where Seq.Element == A {
    for try await action in sequence {
      await dispatch(action: action)
    }
  }
  
  func dispatch(future: Future<A?, Never>) {
    var subscription: AnyCancellable?
    subscription = future.sink { _ in
      if subscription != nil {
        subscription = nil
      }
    } receiveValue: { action in
      guard let action = action else {
        return
      }
      
      Task {
        await self.dispatch(action: action)
      }
    }
  }
  
  func dispatch<P: Publisher>(publisher: P) where P.Output == A, P.Failure == Never {
    var subscription: AnyCancellable?
    subscription = publisher.sink { _ in
      if subscription != nil {
        subscription = nil
      }
    } receiveValue: { action in
      Task {
        await self.dispatch(action: action)
      }
    }
  }
}

// MARK: AnyStoreDispatcher
extension Redux {
  public actor AnyStoreDispatcher {
    private let _dispatch: (any Redux.Action) async -> Void
    
    init(_dispatch: @escaping (any Redux.Action) async -> Void) {
      self._dispatch = _dispatch
    }
    
    public func dispatch(action: any Redux.Action) async {
      await self._dispatch(action)
    }
    
    public func dispatchAsync(action: any Redux.Action) {
      Task {
        await self._dispatch(action)
      }
    }
  }
}

extension Redux.Store {
  public func eraseToAnyStoreDispatcher() -> Redux.AnyStoreDispatcher {
    Redux.AnyStoreDispatcher { action async in
      guard let action = action as? A else {
        fatalError("Unhandled root action \(action)")
      }
      await self.dispatch(action: action)
    }
  }
}

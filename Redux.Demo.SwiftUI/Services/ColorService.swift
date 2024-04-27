//
//  ColorService.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/5/24.
//

import Foundation
import Combine
import SwiftUI

enum ColorModel: String, CaseIterable, Identifiable {
  case blue
  case green
  case orange
  case pink
  case purple
  case red
  case yellow
  case white
  
  var id: String {
    self.rawValue
  }
}

extension ColorModel {
  func asColor() -> Color {
    switch self {
    case .blue: return .blue
    case .green: return .green
    case .orange: return .orange
    case .pink: return .pink
    case .purple: return .purple
    case .red: return .red
    case .white: return .white
    case .yellow: return .yellow
    }
  }
}

protocol ColorServiceProtocol: ObservableObject {
  func getNextColor() -> ColorModel
  func generateColors(every timeInterval: TimeInterval, on runLoop: RunLoop) -> AnyPublisher<ColorModel, Never>
}

extension ColorServiceProtocol {
  func generateColors(every timeInterval: TimeInterval = 1.0, on runLoop: RunLoop = .main) -> AnyPublisher<ColorModel, Never> {
    generateColors(every: timeInterval, on: runLoop)
  }
}

class ColorService: ColorServiceProtocol {
  private var index: Int = 0
  
  func getNextColor() -> ColorModel {
    let selection = self.index % 7
    self.index = self.index + 1
    switch selection {
    case 0: return .blue
    case 1: return .green
    case 2: return .orange
    case 3: return .pink
    case 4: return .purple
    case 5: return .red
    case 6: return .yellow
    default: return .white
    }
  }
  
  func generateColors(every timeInterval: TimeInterval = 1.0, on runLoop: RunLoop = .main) -> AnyPublisher<ColorModel, Never> {
    return Timer.publish(every: timeInterval, on: runLoop, in: .default)
      .autoconnect()
      .map { timer in
        let selection = Int(timer.timeIntervalSince1970 * 1.5) % 7
        switch selection {
        case 0: return .blue
        case 1: return .green
        case 2: return .orange
        case 3: return .pink
        case 4: return .purple
        case 5: return .red
        case 6: return .yellow
        default: return .white
        }
      }
      .eraseToAnyPublisher()
  }
}

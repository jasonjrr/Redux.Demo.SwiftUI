//
//  ColorWizardConfiguration+Mock.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/6/24.
//

import Foundation

extension ColorWizardConfiguration {
  static func mock() -> ColorWizardConfiguration {
    ColorWizardConfiguration(pages: [
      .page("First Color", color: .green),
      .page("Second Color", color: .orange),
      .page("Third Color", color: .red),
      .page("Fourth Color", color: .pink),
      .page("Fifth Color", color: .purple),
      .page("Summary", colors: [
        .green,
        .orange,
        .red,
        .pink,
        .purple,
      ]),
    ])
  }
}

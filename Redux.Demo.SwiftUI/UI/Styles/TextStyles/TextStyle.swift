//
//  TextStyle.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/4/24.
//

import SwiftUI

protocol TextStyle: ViewModifier {}

extension View {
  func textStyle<Style: TextStyle>(_ style: Style) -> some View {
    ModifiedContent(content: self, modifier: style)
  }
}

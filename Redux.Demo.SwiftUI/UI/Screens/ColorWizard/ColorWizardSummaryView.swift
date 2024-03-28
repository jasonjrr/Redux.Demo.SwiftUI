//
//  ColorWizardSummaryView.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/6/24.
//

import SwiftUI

struct ColorWizardSummaryView: View {
  private let colors: [ColorModel]
  private let index: Int
  
  init(colors: [ColorModel], index: Int) {
    self.colors = colors
    self.index = index
  }
  
  var body: some View {
    ScrollView {
      VStack {
        ForEach(self.colors) { color in
          RoundedRectangle(cornerRadius: 36.0, style: .continuous)
            .fill(color.asColor())
            .frame(maxWidth: .infinity, minHeight: 54.0, idealHeight: 54.0, maxHeight: 54.0)
            .padding([.leading, .trailing], 16.0)
        }
      }
    }
  }
}

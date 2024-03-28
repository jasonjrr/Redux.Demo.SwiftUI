//
//  ColorWizardColorView.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/6/24.
//

import SwiftUI

struct ColorWizardColorView: View {
  private let color: ColorModel
  private let index: Int
  
  init(color: ColorModel, index: Int) {
    self.color = color
    self.index = index
  }
  
  var body: some View {
    self.color.asColor().ignoresSafeArea()
  }
}

//
//  ColorWizardConfiguration.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/6/24.
//

import Foundation

struct ColorWizardConfiguration {
  let pages: [Page]
}

extension ColorWizardConfiguration {
  struct Page {
    let title: String
    let color: ColorModel?
    let colors: [ColorModel]?
    
    static func page(_ title: String, color: ColorModel? = nil, colors: [ColorModel]? = nil) -> Page {
      Page(title: title, color: color, colors: colors)
    }
  }
}

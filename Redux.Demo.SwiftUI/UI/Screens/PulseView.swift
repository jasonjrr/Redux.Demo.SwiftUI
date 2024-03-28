//
//  PulseView.swift
//  Redux.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 4/5/24.
//

import SwiftUI

struct PulseView: View {
  @EnvironmentObject var store: AppReduxStore
  @EnvironmentObject var colorService: ColorService
  
  @State private var title: String = .empty
  @State private var colorItems: [ColorItem] = []
  
  var body: some View {
    ZStack {
      ForEach(self.colorItems) { item in
        PulseCircle(colorItem: item)
          .frame(
            width: max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height),
            height: max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
          )
      }
    }
    .navigationTitle(self.title)
    .navigationBarTitleDisplayMode(.inline)
    .overlay(.thinMaterial)
    .onReceive(self.store.state
      .map { $0.user.username }
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
    ) {
      if let username = $0 {
        self.title = "Welcome, \(username)"
      } else {
        self.title = "Hello, mysterious stranger"
      }
    }
    .onReceive(self.colorService
      .generateColors()
      .receive(on: RunLoop.main)
    ) { colorModel in
      var colorItems = self.colorItems
      colorItems.insert(ColorItem(model: colorModel), at: 0)
      if colorItems.count > 3 {
        let _ = self.colorItems.popLast()
      }
      self.colorItems = colorItems
    }
  }
}

extension PulseView {
  struct ColorItem: Identifiable {
    let id: UUID = UUID()
    let model: ColorModel
  }
  
  struct PulseCircle: View {
    @State private var item: ColorItem
    @State private var circleOpacity: Double = 0.0
    
    init(colorItem: ColorItem) {
      self.item = colorItem
    }
    
    var body: some View {
      Circle()
        .fill(Color.white)
        .colorMultiply(self.item.model.asColor())
        .opacity(self.circleOpacity)
        .animation(.easeIn, value: self.self.circleOpacity)
        .onAppear {
          withAnimation {
            self.circleOpacity = 1.0
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
            withAnimation {
              self.circleOpacity = 0.0
            }
          }
        }
    }
  }
}

#Preview {
  AppDependencyContainerView {
    NavigationStack {
      PulseView()
    }
  }
}

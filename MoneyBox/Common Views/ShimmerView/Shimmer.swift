//
//  Shimmer.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//
import SwiftUI

// MARK: - Shimmer
public struct Shimmer: ViewModifier {
  @State private var isInitialState = true

  public func body(content: Content) -> some View {
    content
      .mask(LinearGradient(gradient: .init(colors: [.black.opacity(0.2), .black, .black.opacity(0.2)]),
                           startPoint: isInitialState ? .init(x: -0.3, y: -0.3) : .init(x: 1, y: 1),
                           endPoint: isInitialState ? .init(x: 0, y: 0) : .init(x: 1.3, y: 1.3)))
      .animation(.linear(duration: 1.5).delay(0.25).repeatForever(autoreverses: false), value: isInitialState)
      .onAppear {
        isInitialState = false
      }
  }
}

extension View {
  @ViewBuilder
  func shimmer(when isLoading: Binding<Bool>) -> some View {
    if isLoading.wrappedValue {
      modifier(Shimmer())
        .redacted(reason: isLoading.wrappedValue ? .placeholder : [])
    } else {
      self
    }
  }
}

//
//  ShimmeringView.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//
import SwiftUI

// MARK: - ShimmeringView
struct ShimmeringView<Content: View>: View {
  private let content: () -> Content
  private let configuration: ShimmerConfiguration
  @State private var startPoint: UnitPoint
  @State private var endPoint: UnitPoint
  init(configuration: ShimmerConfiguration, @ViewBuilder content: @escaping () -> Content) {
    self.configuration = configuration
    self.content = content
    _startPoint = .init(wrappedValue: configuration.initialLocation.start)
    _endPoint = .init(wrappedValue: configuration.initialLocation.end)
  }

  var body: some View {
    ZStack {
      content()
      LinearGradient(gradient: configuration.gradient,
                     startPoint: startPoint,
                     endPoint: endPoint)
        .opacity(configuration.opacity)
        .blendMode(.screen)
        .onAppear {
          withAnimation(Animation.linear(duration: configuration.duration).repeatForever(autoreverses: false)) {
            startPoint = configuration.finalLocation.start
            endPoint = configuration.finalLocation.end
          }
        }
    }
  }
}

// MARK: - ShimmerModifier
public struct ShimmerModifier: ViewModifier {
  let configuration: ShimmerConfiguration
  public func body(content: Content) -> some View {
    ShimmeringView(configuration: configuration) { content }
  }
}

public extension View {
  func shimmer(configuration: ShimmerConfiguration = .default) -> some View {
    modifier(ShimmerModifier(configuration: configuration))
  }
}

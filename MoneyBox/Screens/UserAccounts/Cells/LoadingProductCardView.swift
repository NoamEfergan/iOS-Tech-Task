//
//  LoadingProductCardView.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import SwiftUI

struct LoadingProductCardView: View {
  // MARK: - Properties
  private let iconSize: CGFloat = 32
  var body: some View {
    VStack {
      HStack {
        Circle()
          .frame(width: iconSize, height: iconSize, alignment: .center)
        Rectangle()
          .frame(height: iconSize)
      }
    }

    .foregroundStyle(.gray.opacity(0.7))
//    .shimmer(when: .constant(true))
  }
}

#Preview {
  HStack {
    LoadingProductCardView()
  }
  .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
  .background(Color(.grey))
}

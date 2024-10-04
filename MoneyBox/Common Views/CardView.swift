//
//  CardView.swift
//  MoneyBox
//
//  Created by Noam Efergan on 04/10/2024.
//

import UIKit

// MARK: - CardView
class CardView: UIView {
  // MARK: - Properties
  var cornerRadius: CGFloat = 12 {
    didSet {
      layer.cornerRadius = cornerRadius
    }
  }

  var shadowOpacity: Float = 0.1 {
    didSet {
      layer.shadowOpacity = shadowOpacity
    }
  }

  var shadowOffset: CGSize = .init(width: 0, height: 2) {
    didSet {
      layer.shadowOffset = shadowOffset
    }
  }

  var shadowRadius: CGFloat = 4 {
    didSet {
      layer.shadowRadius = shadowRadius
    }
  }

  var shadowColor: UIColor = .black {
    didSet {
      layer.shadowColor = shadowColor.cgColor
    }
  }

  // MARK: - Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  // MARK: - Setup
  private func setupView() {
    backgroundColor = .white
    layer.cornerRadius = cornerRadius
    layer.shadowColor = shadowColor.cgColor
    layer.shadowOpacity = shadowOpacity
    layer.shadowOffset = shadowOffset
    layer.shadowRadius = shadowRadius

    // Improve performance by rasterizing the layer
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }

  // MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
  }
}

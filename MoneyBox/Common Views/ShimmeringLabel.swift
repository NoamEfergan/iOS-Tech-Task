//
//  ShimmeringLabel.swift
//  MoneyBox
//
//  Created by Noam Efergan on 04/10/2024.
//

import UIKit

class ShimmeringLabel: UILabel {
  private let shimmerLayer = CAGradientLayer()
  private var isShimmering = false

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupShimmerLayer()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupShimmerLayer()
  }

  private func setupShimmerLayer() {
    shimmerLayer.colors = [
      UIColor.clear.cgColor,
      UIColor.white.withAlphaComponent(0.5).cgColor,
      UIColor.clear.cgColor
    ]
    shimmerLayer.locations = [0, 0.5, 1]
    shimmerLayer.startPoint = CGPoint(x: 0, y: 0.5)
    shimmerLayer.endPoint = CGPoint(x: 1, y: 0.5)
    shimmerLayer.opacity = 0
    layer.addSublayer(shimmerLayer)
  }

  func shimmer() {
    guard !isShimmering else { return }
    isShimmering = true

    let overlay = UIView(frame: bounds)
    overlay.backgroundColor = .systemGray5
    overlay.tag = 100
    addSubview(overlay)

    shimmerLayer.frame = bounds
    shimmerLayer.opacity = 1

    let animation = CABasicAnimation(keyPath: "transform.translation.x")
    animation.duration = 1.5
    animation.fromValue = -frame.width
    animation.toValue = frame.width
    animation.repeatCount = .infinity
    shimmerLayer.add(animation, forKey: "shimmerAnimation")
  }

  func stopShimmering() {
    guard isShimmering else { return }
    isShimmering = false

    shimmerLayer.removeAllAnimations()
    shimmerLayer.opacity = 0

    if let overlay = viewWithTag(100) {
      overlay.removeFromSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    shimmerLayer.frame = bounds
    if let overlay = viewWithTag(100) {
      overlay.frame = bounds
    }
  }
}

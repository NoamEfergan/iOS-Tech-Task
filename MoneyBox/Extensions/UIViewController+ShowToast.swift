//
//  UIViewController+ShowToast.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import UIKit
public extension UIViewController {
  func showToast(toastModel: ToastModel) {
    guard let view else { return }
    for subview in view.subviews where subview is ToastView {
      subview.removeFromSuperview()
    }
    let height: CGFloat = 64
    let width: CGFloat = min(400, view.bounds.width - (2 * Padding.large))
    
    let yPosition = view.bounds.height + view.bounds.origin.y - Padding.regular - height
    let frame = CGRect(x: view.bounds.width - Padding.large - width,
                       y: yPosition,
                       width: width,
                       height: height)
    let toastView = ToastView(frame: frame, toastModel: toastModel)
    view.addSubview(toastView)
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(toastModel.length)) {
      UIView.animate(withDuration: 1, delay: 0, options: .allowUserInteraction) {
        toastView.alpha = 0.02
      } completion: { _ in
        toastView.removeFromSuperview()
      }
    }
  }
}

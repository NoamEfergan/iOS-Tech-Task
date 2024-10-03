//
//  ToastStyle.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import UIKit
public enum ToastStyle {
  case success
  case info
  case error

  var image: UIImage? {
    switch self {
    case .success:
      return .init(resource: .checkCircle)
    case .info:
      return .init(resource: .infoFilled)
    case .error:
      return .init(resource: .error)
    }
  }

  var backgroundColor: UIColor {
    switch self {
    case .success:
      return UIColor(rgb: 0x43B374)
    case .info:
      return UIColor(rgb: 0x3B4960)
    case .error:
      return UIColor(rgb: 0xC62828) // new case added
    }
  }
}

//
//  UIColor+RGB.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import UIKit

public extension UIColor {
  convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 255) {
    self.init(red: CGFloat(red) / 255,
              green: CGFloat(green) / 255,
              blue: CGFloat(blue) / 255,
              alpha: CGFloat(alpha) / 255)
  }

  @objc
  convenience init(rgb: Int) {
    assert(rgb < 0x1000000, "rgb colour value should fit within 24 bits")
    self.init(red: UInt8((rgb >> 16) & 0xff),
              green: UInt8((rgb >> 8) & 0xff),
              blue: UInt8(rgb & 0xff))
  }

  convenience init(rgba: Int) {
    assert(rgba < 0x100000000, "rgba colour value should fit within 32 bits")
    self.init(red: UInt8((rgba >> 24) & 0xff),
              green: UInt8((rgba >> 16) & 0xff),
              blue: UInt8((rgba >> 8) & 0xff),
              alpha: UInt8(rgba & 0xff))
  }

  @objc
  convenience init?(hexString: String) {
    guard let number = Int(hexString, radix: 16) else { return nil }
    self.init(rgb: number)
  }
}

//
//  Array+Safe.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import Foundation

public extension Array {
  subscript(safe index: Index) -> Element? {
    index >= 0 && index < count ? self[index] : nil
  }
}

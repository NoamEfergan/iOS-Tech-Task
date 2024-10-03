//
//  UserDefaultsManager.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import Foundation

enum UserDefaultsManager {
  private static let nameKey = "UserName"

  static func saveName(_ name: String) {
    UserDefaults.standard.set(name, forKey: nameKey)
  }

  static func fetchName() -> String? {
    UserDefaults.standard.string(forKey: nameKey)
  }

  static func deleteName() {
    UserDefaults.standard.removeObject(forKey: nameKey)
  }
}

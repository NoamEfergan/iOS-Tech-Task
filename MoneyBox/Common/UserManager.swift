//
//  UserManager.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import Foundation
import Networking

// MARK: - UserManager
actor UserManager {
  // MARK: - Properties
  public private(set) var token: String?

  public func setToken(_ token: String) {
    self.token = token
  }
}

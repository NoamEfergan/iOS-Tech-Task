//
//  UserAccountsViewModel.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//
import Foundation
import Networking

final class UserAccountsViewModel {
  // MARK: - Properties
  private let networkingService: DataProviderLogic
  weak var sessionManager: SessionManager?

  init(networkingService: DataProviderLogic) {
    self.networkingService = networkingService
  }
}

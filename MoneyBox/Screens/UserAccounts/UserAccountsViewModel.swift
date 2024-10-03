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

  // MARK: - Initialiser
  init(networkingService: DataProviderLogic) {
    self.networkingService = networkingService
  }

  // MARK: - Public methods

  func fetchProducts() {
    networkingService.fetchProducts { response in
      print("Noam: \(response)")
    }
  }
}

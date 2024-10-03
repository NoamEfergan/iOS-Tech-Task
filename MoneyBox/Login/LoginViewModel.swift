//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import Foundation
import Networking

// MARK: - LoginViewModel
final class LoginViewModel {
  // MARK: - Properties
  private let networkingService: DataProviderLogic

  init(networkingService: DataProviderLogic) {
    self.networkingService = networkingService
  }

  func performLogin(with email: String, and password: String) async -> String? {
    let request = LoginRequest(email: email, password: password)
    return await withCheckedContinuation { continuation in
      networkingService.login(request: request) { result in
        switch result {
        case let .success(success):
          print("Noam: \(success)")
          KeychainManager.saveCredentialsToKeychain(email: email, password: password)
          continuation.resume(returning: nil)
        case let .failure(failure):
          continuation.resume(returning: failure.localizedDescription)
        }
      }
    }
  }
}

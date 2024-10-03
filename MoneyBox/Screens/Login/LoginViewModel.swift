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
  weak var sessionManager: SessionManager?

  init(networkingService: DataProviderLogic) {
    self.networkingService = networkingService
  }

  func performLogin(with email: String, and password: String) async throws {
    let request = LoginRequest(email: email, password: password)
    return try await withCheckedThrowingContinuation { continuation in
      networkingService.login(request: request) { result in
        switch result {
        case let .success(success):
          self.sessionManager?.setUserToken(success.session.bearerToken)
          if let firstName = success.user.firstName {
            UserDefaultsManager.saveName(firstName)
          }
          KeychainManager.saveCredentialsToKeychain(email: email, password: password)
          continuation.resume()
        case let .failure(failure):
          continuation.resume(throwing: LoginError.failure(msg: failure.localizedDescription))
        }
      }
    }
  }
}

// MARK: LoginViewModel.LoginError
extension LoginViewModel {
  enum LoginError: Error {
    case failure(msg: String)
  }
}

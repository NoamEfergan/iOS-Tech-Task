//
//  LoginViewModel.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import Foundation
import Networking

// MARK: - LoginViewModelDelegate
protocol LoginViewModelDelegate: NSObject {
  func onStateUpdate(_ state: LoginViewModel.State)
}

// MARK: - LoginViewModel
final class LoginViewModel {
  // MARK: - Properties
  private let networkingService: DataProviderLogic
  weak var sessionManager: SessionManager?
  weak var delegate: LoginViewModelDelegate?
  private var loadingTask: Task<Void, Never>?
  private var state: State = .loading {
    didSet { delegate?.onStateUpdate(state) }
  }

  // MARK: - Initialisers

  init(networkingService: DataProviderLogic, state: State = .loading) {
    self.networkingService = networkingService
    self.state = state
  }

  deinit {
    loadingTask = nil
  }

  // MARK: - Public methods
  func login(with email: String?, and password: String?) {
    state = .loading
    guard let email, LoginValidator.validateEmail(email) else {
      state = .error("Invalid email")
      return
    }
    guard let password, LoginValidator.validatePassword(password) else {
      state = .error("Invalid password")
      return
    }
    login(email: email, password: password)
  }
}

// MARK: - Private methods
private extension LoginViewModel {
  func login(email: String, password: String) {
    loadingTask?.cancel()
    loadingTask = Task {
      do {
        try await performLogin(with: email, and: password)
        self.state = .success
      } catch {
        self.state = .error(error.localizedDescription)
      }
    }
  }

  @MainActor
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

// MARK: LoginViewModel.State
extension LoginViewModel {
  enum State {
    case error(String)
    case success
    case loading
  }
}

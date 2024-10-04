//
//  MockDataProvider.swift
//  MoneyBox
//
//  Created by Noam Efergan on 04/10/2024.
//

import Foundation
import Networking

// MARK: - MockDataProvider
class MockDataProvider: DataProviderLogic {
  var shouldFail: Bool

  init(shouldFail: Bool) {
    self.shouldFail = shouldFail
  }

  func login(request _: Networking.LoginRequest,
             completion: @escaping ((Result<Networking.LoginResponse, any Error>) -> Void)) {
    if shouldFail {
      completion(.failure(StubError.stubError))
    } else {
      StubData.read(file: "LoginSucceed", callback: completion)
    }
  }

  func fetchProducts(completion: @escaping ((Result<Networking.AccountResponse, any Error>) -> Void)) {
    if shouldFail {
      completion(.failure(StubError.stubError))
    } else {
      StubData.read(file: "Accounts", callback: completion)
    }
  }

  func addMoney(request _: Networking.OneOffPaymentRequest,
                completion: @escaping ((Result<Networking.OneOffPaymentResponse, any Error>) -> Void)) {
    if shouldFail {
      completion(.failure(StubError.stubError))
    } else {
      StubData.read(file: "Add", callback: completion)
    }
  }

  enum StubError: Error {
    case stubError
  }
}

//
//  LoginViewModelTests.swift
//  MoneyBoxTests
//
//  Created by Noam Efergan on 04/10/2024.
//

@testable import MoneyBox
import Networking
import XCTest

// MARK: - LoginViewModelTests
class LoginViewModelTests: XCTestCase {
  override class func tearDown() {
    KeychainManager.clearCredentialsFromKeychain()
    UserDefaultsManager.deleteName()
  }

  func test_successfulLogin() {
    let expectation = expectation(description: "Should update state")

    let networkService = MockDataProvider(shouldFail: false)
    let mockDelegate = MockDelegate { state in
      switch state {
      case .success:
        expectation.fulfill()
      case let .error(errorMessage):
        XCTFail(errorMessage)
      default:
        print("Updated state: \(state)")
      }
    }
    let sut = LoginViewModel(networkingService: networkService)
    sut.delegate = mockDelegate
    sut.login(with: "a@b.com", and: "12345678")
    waitForExpectations(timeout: 2)
  }

  func test_failLogin() {
    let expectation = expectation(description: "Should update state")

    let networkService = MockDataProvider(shouldFail: true)
    let mockDelegate = MockDelegate { state in
      switch state {
      case .success:
        XCTFail("Should've failed")

      case .error:
        expectation.fulfill()

      default:
        print("Updated state: \(state)")
      }
    }
    let sut = LoginViewModel(networkingService: networkService)
    sut.delegate = mockDelegate
    sut.login(with: "a@b.com", and: "12345678")
    waitForExpectations(timeout: 2)
  }
}

// MARK: - MockDelegate
private class MockDelegate: NSObject, LoginViewModelDelegate {
  let didUpdateState: (LoginViewModel.State) -> Void
  init(didUpdateState: @escaping (LoginViewModel.State) -> Void) {
    self.didUpdateState = didUpdateState
  }

  func onStateUpdate(_ state: LoginViewModel.State) {
    didUpdateState(state)
  }
}

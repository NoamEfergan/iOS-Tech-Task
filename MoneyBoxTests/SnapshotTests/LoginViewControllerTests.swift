//
//  LoginViewControllerTests.swift
//  MoneyBox
//
//  Created by Noam Efergan on 04/10/2024.
//

import SnapshotTesting
import XCTest

class LoginViewControllerTests: XCTestCase {
  override class func setUp() {
    KeychainManager.clearCredentialsFromKeychain()
    UserDefaultsManager.deleteName()
  }

  func test_EmptyState() {
    let sut = LoginViewController(viewModel: .init(networkingService: MockDataProvider(shouldFail: false)))
    sut.loadViewIfNeeded()
    assertSnapshot(of: sut, as: .image)
  }

  func test_loadingState() {
    let viewModel = LoginViewModel(networkingService: MockDataProvider(shouldFail: false))
    let sut = LoginViewController(viewModel: viewModel)
    sut.loadViewIfNeeded()

    viewModel.delegate?.onStateUpdate(.loading)

    let expectation = XCTestExpectation(description: "View updated")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)

    assertSnapshot(of: sut, as: .image)
  }

  func test_errorState() {
    let viewModel = LoginViewModel(networkingService: MockDataProvider(shouldFail: false))
    let sut = LoginViewController(viewModel: viewModel)
    sut.loadViewIfNeeded()

    viewModel.delegate?.onStateUpdate(.error("Something went wrong"))

    let expectation = XCTestExpectation(description: "View updated")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)

    assertSnapshot(of: sut, as: .image)
  }
}

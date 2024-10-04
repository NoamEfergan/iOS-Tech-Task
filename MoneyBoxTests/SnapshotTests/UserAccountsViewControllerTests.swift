//
//  UserAccountsViewControllerTests.swift
//  MoneyBoxTests
//
//  Created by Noam Efergan on 04/10/2024.
//

import SnapshotTesting
import XCTest

class UserAccountsViewControllerTests: XCTestCase {
  override class func setUp() {
    UserDefaultsManager.saveName("Test")
  }

  override class func tearDown() {
    UserDefaultsManager.deleteName()
  }

  func test_LoadingState() {
    let sut = UserAccountsViewController(viewModel: .init(networkingService: MockDataProvider(shouldFail: false)))
    assertSnapshot(of: sut, as: .image)
  }

  func test_ErrorState() {
    let viewModel = UserAccountsViewModel(networkingService: MockDataProvider(shouldFail: true))
    let sut = UserAccountsViewController(viewModel: viewModel)
    viewModel.delegate?.onStateUpdate(state: .error(errorMessage: "Something went wrong"))
    sut.loadViewIfNeeded()
    let expectation = XCTestExpectation(description: "View updated")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)

    assertSnapshot(of: sut, as: .image)
  }

  func test_LoadedState() {
    let viewModel = UserAccountsViewModel(networkingService: MockDataProvider(shouldFail: false))
    let sut = UserAccountsViewController(viewModel: viewModel)
    viewModel.delegate?.onStateUpdate(state: .loading)
    sut.loadViewIfNeeded()
    let expectation = XCTestExpectation(description: "View updated")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)

    assertSnapshot(of: sut, as: .image)
  }
}

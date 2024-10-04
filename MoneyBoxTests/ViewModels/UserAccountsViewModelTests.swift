//
//  UserAccountsViewModelTests.swift
//  MoneyBox
//
//  Created by Noam Efergan on 04/10/2024.
//
@testable import MoneyBox
import Networking
import XCTest

// MARK: - UserAccountsViewModelTests
class UserAccountsViewModelTests: XCTestCase {
  func test_successfulFetch() {
    let expectation = expectation(description: "Should update state")
    let networkService = MockDataProvider(shouldFail: false)
    let mockDelegate = MockDelegate { state in
      switch state {
      case let .loaded(response):
        XCTAssertEqual(response.accounts?.count, 2)
        XCTAssertEqual(response.productResponses?.count, 2)
        expectation.fulfill()
      case let .error(errorMessage):
        XCTFail(errorMessage)
      default:
        print("Updated state: \(state)")
      }
    }
    let sut = UserAccountsViewModel(networkingService: networkService)
    sut.delegate = mockDelegate
    sut.fetchProducts()
    waitForExpectations(timeout: 2)
  }

  func test_failFetch() {
    let expectation = expectation(description: "Should update state")
    let networkService = MockDataProvider(shouldFail: true)
    let mockDelegate = MockDelegate { state in
      switch state {
      case .loaded:
        XCTFail("Should not have succeeded")
      case .error:
        expectation.fulfill()
      default:
        print("Updated state: \(state)")
      }
    }
    let sut = UserAccountsViewModel(networkingService: networkService)
    sut.delegate = mockDelegate
    sut.fetchProducts()
    waitForExpectations(timeout: 2)
  }
}

// MARK: - MockDelegate
private class MockDelegate: NSObject, UserAccountsViewModelDelegate {
  let didUpdateState: (UserAccountsViewModel.State) -> Void
  init(didUpdateState: @escaping (UserAccountsViewModel.State) -> Void) {
    self.didUpdateState = didUpdateState
  }

  func onStateUpdate(state: UserAccountsViewModel.State) {
    didUpdateState(state)
  }
}

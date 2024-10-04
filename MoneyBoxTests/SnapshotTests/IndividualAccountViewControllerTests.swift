//
//  IndividualAccountViewControllerTests.swift
//  MoneyBox
//
//  Created by Noam Efergan on 04/10/2024.
//

import SnapshotTesting
import XCTest

class IndividualAccountViewControllerTests: XCTestCase {
  let mockProduct = DisplayableProduct(name: "test",
                                       planValue: "£100",
                                       moneyBoxValue: "£100",
                                       id: 1)
  func test_LoadedStateState() {
    let viewModel = IndividualAccountViewModel(networkingService: MockDataProvider(shouldFail: false))
    let sut = IndividualAccountViewController(product: mockProduct, viewModel: viewModel)
    sut.loadViewIfNeeded()
    assertSnapshot(of: sut, as: .image)
  }

  func test_LoadingState() {
    let viewModel = IndividualAccountViewModel(networkingService: MockDataProvider(shouldFail: false))
    let sut = IndividualAccountViewController(product: mockProduct, viewModel: viewModel)
    sut.loadViewIfNeeded()
    viewModel.delegate?.onStateUpdate(state: .loading)
    let expectation = XCTestExpectation(description: "View updated")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)
    assertSnapshot(of: sut, as: .image)
  }

  func test_SuccessState() {
    let viewModel = IndividualAccountViewModel(networkingService: MockDataProvider(shouldFail: false))
    let sut = IndividualAccountViewController(product: mockProduct, viewModel: viewModel)
    sut.loadViewIfNeeded()
    viewModel.delegate?.onStateUpdate(state: .success(newAmount: "£50"))
    let expectation = XCTestExpectation(description: "View updated")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)
    assertSnapshot(of: sut, as: .image)
  }

  func test_errorState() {
    let viewModel = IndividualAccountViewModel(networkingService: MockDataProvider(shouldFail: true))
    let sut = IndividualAccountViewController(product: mockProduct, viewModel: viewModel)
    sut.loadViewIfNeeded()
    viewModel.delegate?.onStateUpdate(state: .failure(msg: "Something went wrong"))
    let expectation = XCTestExpectation(description: "View updated")
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1.0)
    assertSnapshot(of: sut, as: .image)
  }
}

@testable import MoneyBox
import Networking
import XCTest

// MARK: - IndividualAccountViewModelTests
class IndividualAccountViewModelTests: XCTestCase {
  func test_successfulMoneyAdding() {
    let expectation = expectation(description: "Should update state")
    let networkService = MockDataProvider(shouldFail: false)
    let mockDelegate = MockDelegate { state in
      switch state {
      case let .success(newAmount):
        XCTAssertEqual(newAmount, "£685.00")
        expectation.fulfill()
      case let .failure(msg):
        XCTFail(msg)
      default:
        print("Updated state: \(state)")
      }
    }
    let sut = IndividualAccountViewModel(networkingService: networkService)
    sut.delegate = mockDelegate
    sut.addMoney(id: 1)
    waitForExpectations(timeout: 2)
  }

  func test_failingMoneyAdding() {
    let expectation = expectation(description: "Should update state")
    let networkService = MockDataProvider(shouldFail: true)
    let mockDelegate = MockDelegate { state in
      switch state {
      case .success:
        XCTFail("Should not have succeeded")
      case .failure:
        expectation.fulfill()
      default:
        print("Updated state: \(state)")
      }
    }
    let sut = IndividualAccountViewModel(networkingService: networkService)
    sut.delegate = mockDelegate
    sut.addMoney(id: 1)
    waitForExpectations(timeout: 2)
  }
}

// MARK: - MockDelegate
private class MockDelegate: NSObject, IndividualAccountViewModelDelegate {
  let didUpdateState: (IndividualAccountViewModel.State) -> Void
  init(didUpdateState: @escaping (IndividualAccountViewModel.State) -> Void) {
    self.didUpdateState = didUpdateState
  }

  func onStateUpdate(state: IndividualAccountViewModel.State) {
    didUpdateState(state)
  }
}

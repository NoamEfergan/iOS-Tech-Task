//
//  IndividualAccountViewModel.swift
//  MoneyBox
//
//  Created by Noam Efergan on 04/10/2024.
//
import Networking
import UIKit

// MARK: - IndividualAccountViewModelDelegate
protocol IndividualAccountViewModelDelegate: NSObject {
  func onStateUpdate(state: IndividualAccountViewModel.State)
}

// MARK: - IndividualAccountViewModel
final class IndividualAccountViewModel {
  // MARK: - Properties
  weak var delegate: IndividualAccountViewModelDelegate?
  private let networkingService: DataProviderLogic
  private var state: State { didSet { delegate?.onStateUpdate(state: state) }}
  private var loadingTask: Task<Void, Never>?

  // MARK: - Initialiser
  init(networkingService: DataProviderLogic, state: State = .idle) {
    self.networkingService = networkingService
    self.state = state
  }

  deinit {
    loadingTask = nil
  }

  // MARK: - Public methods

  func addMoney(id: Int) {
    self.state = .loading
    loadingTask?.cancel()
    loadingTask = Task {
      do {
        let newAmount = try await performAddMoney(id: id)
        self.state = .success(newAmount: newAmount)

      } catch {
        self.state = .failure(msg: error.localizedDescription)
      }
    }
  }
}

// MARK: - Private methods
private extension IndividualAccountViewModel {
  func performAddMoney(id: Int, amount: Int = 10) async throws -> String {
    let request: OneOffPaymentRequest = .init(amount: amount, investorProductID: id)
    return try await withCheckedThrowingContinuation { continuation in
      networkingService.addMoney(request: request) { result in
        switch result {
        case let .success(success):
          guard let amount = success.moneybox?.formatted(.currency(code: "GBP")) else {
            continuation.resume(throwing: IndividualAccountViewModelErrors.invalidAmount)
            return
          }
          continuation.resume(returning: amount)
        case let .failure(failure):
          continuation.resume(throwing: failure)
        }
      }
    }
  }
}

// MARK: IndividualAccountViewModel.IndividualAccountViewModelErrors
extension IndividualAccountViewModel {
  enum IndividualAccountViewModelErrors: Error {
    case invalidAmount

    var localisedDescription: String {
      switch self {
      case .invalidAmount:
        return "Invalid amount"
      }
    }
  }
}

// MARK: IndividualAccountViewModel.State
extension IndividualAccountViewModel {
  enum State: Equatable {
    case idle
    case loading
    case success(newAmount: String)
    case failure(msg: String)
  }
}

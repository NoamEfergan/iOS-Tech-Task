//
//  UserAccountsViewModel.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//
import Foundation
import Networking

// MARK: - UserAccountsViewModelDelegate
protocol UserAccountsViewModelDelegate: NSObject {
  func onStateUpdate(state: UserAccountsViewModel.State)
}

// MARK: - UserAccountsViewModel
final class UserAccountsViewModel {
  // MARK: - Properties
  private let networkingService: DataProviderLogic
  public private(set) var state: State = .loading {
    didSet {
      delegate?.onStateUpdate(state: state)
    }
  }

  private var loadingTask: Task<Void, Never>?
  weak var delegate: UserAccountsViewModelDelegate?

  // MARK: - Initialiser
  init(networkingService: DataProviderLogic, state: State = .loading) {
    self.state = state
    self.networkingService = networkingService
  }

  deinit {
    loadingTask = nil
  }

  // MARK: - Public methods

  func fetchProducts() {
    state = .loading
    loadingTask?.cancel()
    loadingTask = Task {
      do {
        let response = try await getProducts()
        self.state = .loaded(response: response)
      } catch {
        print("Noam: \(error.localizedDescription)")
        self.state = .error(errorMessage: error.localizedDescription)
      }
    }
  }
}

// MARK: - Private methods
private extension UserAccountsViewModel {
  func getProducts() async throws -> AccountResponse {
    try await withCheckedThrowingContinuation { continuation in
      networkingService.fetchProducts { result in
        switch result {
        case let .success(success):
          continuation.resume(returning: success)
        case let .failure(failure):
          continuation.resume(throwing: failure)
        }
      }
    }
  }
}

// MARK: UserAccountsViewModel.State
extension UserAccountsViewModel {
  enum State {
    case loading
    case error(errorMessage: String)
    case loaded(response: AccountResponse)
  }
}

extension ProductResponse {
  func mapToDisplayable() -> DisplayableProduct? {
    guard let id,
          let name = product?.friendlyName else { return nil }
    return .init(name: name,
                 planValue: planValue?.formatted(.currency(code: "GBP")) ?? "--",
                 moneyBoxValue: moneybox?.formatted(.currency(code: "GBP")) ?? "--",
                 id: id)
  }
}

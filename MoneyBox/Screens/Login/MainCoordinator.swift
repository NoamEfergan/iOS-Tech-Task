//
//  MainCoordinator.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import Networking
import UIKit

class MainCoordinator: Coordinator {
  // MARK: - Properties
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  let sessionManager: SessionManager
  private let networkService = DataProvider()

  // MARK: - Initialisers
  init(navigationController: UINavigationController, sessionManager: SessionManager = SessionManager()) {
    self.navigationController = navigationController
    self.sessionManager = sessionManager
  }

  // MARK: - Public methods
  func start() {
    let viewModel = LoginViewModel(networkingService: networkService)
    viewModel.sessionManager = sessionManager
    let loginVC = LoginViewController(viewModel: viewModel)
    loginVC.coordinator = self
    navigationController.pushViewController(loginVC, animated: false)
  }

  func navigateToUserAccounts() {
    let viewModel = UserAccountsViewModel(networkingService: networkService)
    let viewController = UserAccountsViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

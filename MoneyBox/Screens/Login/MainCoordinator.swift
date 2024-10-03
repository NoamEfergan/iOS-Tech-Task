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
  var sessionManager: SessionManager?
  private let networkService = DataProvider()

  // MARK: - Initialisers
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
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
    viewModel.sessionManager = sessionManager
    let viewController = UserAccountsViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

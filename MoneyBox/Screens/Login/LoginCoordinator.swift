//
//  LoginCoordinator.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import Networking
import UIKit

class LoginCoordinator: Coordinator {
  // MARK: - Properties
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  var sessionManager: SessionManager?

  // MARK: - Initialisers
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Public methods
  func start() {
    let viewModel = LoginViewModel(networkingService: DataProvider())
    viewModel.sessionManager = sessionManager
    let loginVC = LoginViewController(viewModel: viewModel)
    loginVC.coordinator = self
    navigationController.pushViewController(loginVC, animated: false)
  }

  func navigateToUserAccounts() {
    let userAccountsCoordinator = UserAccountsCoordinator(navigationController: navigationController)
    childCoordinators.append(userAccountsCoordinator)
    userAccountsCoordinator.start()
  }
}

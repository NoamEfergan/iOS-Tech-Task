//
//  UserAccountsCoordinator.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import UIKit

final class UserAccountsCoordinator: Coordinator {
  // MARK: - Properties
  var childCoordinators: [Coordinator] = []
  weak var loginCoordinator: LoginCoordinator?
  var navigationController: UINavigationController

  // MARK: - Initialisers
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Public methods
  func start() {
    let viewController = UserAccountsViewController()
    viewController.coordinator = self
    navigationController.pushViewController(viewController, animated: true)
  }
}

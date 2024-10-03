//
//  LoginCoordinator.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import UIKit

class LoginCoordinator: Coordinator {
  // MARK: - Properties
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController

  // MARK: - Initialisers
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Public methods
  func start() {
    let loginVC = LoginViewController()
    loginVC.coordinator = self
    navigationController.pushViewController(loginVC, animated: false)
  }
}

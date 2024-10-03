//
//  Coordinator.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import UIKit

protocol Coordinator {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }

  func start()
}

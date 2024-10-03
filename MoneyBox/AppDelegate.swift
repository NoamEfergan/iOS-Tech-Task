//
//  AppDelegate.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 15.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      let navController = UINavigationController()
      let loginVC = LoginViewController()
      navController.pushViewController(loginVC, animated: false)
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.rootViewController = navController
      window?.makeKeyAndVisible()
      return true
    }
}


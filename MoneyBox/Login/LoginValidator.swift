//
//  LoginValidator.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//
import Foundation
import Networking

enum LoginValidator {
  static func validateEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
  }

  static func validatePassword(_ password: String) -> Bool {
    // we can (AND SHOULD!) have other forms of validation like a special character, numbers, etc. however, for the demo
    // there's no need
    password.count >= 8
  }
}

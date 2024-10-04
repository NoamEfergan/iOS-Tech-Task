//
//  LoginValidatorTests.swift
//  MoneyBox
//
//  Created by Noam Efergan on 04/10/2024.
//

@testable import MoneyBox
import XCTest

class LoginValidatorTests: XCTestCase {
  func testValidateEmail_ValidEmails_ReturnsTrue() {
    XCTAssertTrue(LoginValidator.validateEmail("test@example.com"))
    XCTAssertTrue(LoginValidator.validateEmail("user.name+tag@example.co.uk"))
    XCTAssertTrue(LoginValidator.validateEmail("user123@gmail.com"))
  }

  func testValidateEmail_InvalidEmails_ReturnsFalse() {
    XCTAssertFalse(LoginValidator.validateEmail(""))
    XCTAssertFalse(LoginValidator.validateEmail("invalid"))
    XCTAssertFalse(LoginValidator.validateEmail("invalid@"))
    XCTAssertFalse(LoginValidator.validateEmail("invalid@.com"))
    XCTAssertFalse(LoginValidator.validateEmail("@invalid.com"))
  }

  func testValidatePassword_ValidPasswords_ReturnsTrue() {
    XCTAssertTrue(LoginValidator.validatePassword("password123"))
    XCTAssertTrue(LoginValidator.validatePassword("longpassword"))
    XCTAssertTrue(LoginValidator.validatePassword("12345678"))
  }

  func testValidatePassword_InvalidPasswords_ReturnsFalse() {
    XCTAssertFalse(LoginValidator.validatePassword(""))
    XCTAssertFalse(LoginValidator.validatePassword("short"))
    XCTAssertFalse(LoginValidator.validatePassword("1234567"))
  }

  func testValidatePassword_EdgeCaseEightCharacters_ReturnsTrue() {
    XCTAssertTrue(LoginValidator.validatePassword("exactly8"))
  }
}

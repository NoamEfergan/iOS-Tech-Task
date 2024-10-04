//
//  MapToDisplayableTests.swift
//  MoneyBox
//
//  Created by Noam Efergan on 04/10/2024.
//

@testable import MoneyBox
import Networking
import XCTest

class ProductResponseTests: XCTestCase {
  func testMapToDisplayableWithValidData() {
    // Arrange
    let productResponse = ProductResponse(id: 1,
                                          planValue: 1000.50,
                                          moneybox: 500.25,
                                          product: Product(friendlyName: "Test Product"),
                                          // Add other required properties with default values
                                          assetBoxGlobalID: nil, subscriptionAmount: nil, totalFees: nil,
                                          isSelected: nil, isFavourite: nil, collectionDayMessage: nil,
                                          wrapperID: nil, isCashBox: nil, pendingInstantBankTransferAmount: nil,
                                          assetBox: nil, investorAccount: nil, personalisation: nil,
                                          contributions: nil, moneyboxCircle: nil, isSwitchVisible: nil,
                                          state: nil, dateCreated: nil)

    // Act
    let result = productResponse.mapToDisplayable()

    // Assert
    XCTAssertNotNil(result)
    XCTAssertEqual(result?.id, 1)
    XCTAssertEqual(result?.name, "Test Product")
    XCTAssertEqual(result?.planValue, "£1,000.50")
    XCTAssertEqual(result?.moneyBoxValue, "£500.25")
  }

  func testMapToDisplayableWithMissingRequiredData() {
    // Arrange
    let productResponse = ProductResponse(id: nil,
                                          planValue: 1000.50,
                                          moneybox: 500.25,
                                          product: Product(friendlyName: nil),
                                          // Add other required properties with default values
                                          assetBoxGlobalID: nil, subscriptionAmount: nil, totalFees: nil,
                                          isSelected: nil, isFavourite: nil, collectionDayMessage: nil,
                                          wrapperID: nil, isCashBox: nil, pendingInstantBankTransferAmount: nil,
                                          assetBox: nil, investorAccount: nil, personalisation: nil,
                                          contributions: nil, moneyboxCircle: nil, isSwitchVisible: nil,
                                          state: nil, dateCreated: nil)

    // Act
    let result = productResponse.mapToDisplayable()

    // Assert
    XCTAssertNil(result)
  }

  func testMapToDisplayableWithMissingOptionalData() {
    // Arrange
    let productResponse = ProductResponse(id: 1,
                                          planValue: nil,
                                          moneybox: nil,
                                          product: Product(friendlyName: "Test Product"),
                                          // Add other required properties with default values
                                          assetBoxGlobalID: nil, subscriptionAmount: nil, totalFees: nil,
                                          isSelected: nil, isFavourite: nil, collectionDayMessage: nil,
                                          wrapperID: nil, isCashBox: nil, pendingInstantBankTransferAmount: nil,
                                          assetBox: nil, investorAccount: nil, personalisation: nil,
                                          contributions: nil, moneyboxCircle: nil, isSwitchVisible: nil,
                                          state: nil, dateCreated: nil)

    // Act
    let result = productResponse.mapToDisplayable()

    // Assert
    XCTAssertNotNil(result)
    XCTAssertEqual(result?.id, 1)
    XCTAssertEqual(result?.name, "Test Product")
    XCTAssertEqual(result?.planValue, "--")
    XCTAssertEqual(result?.moneyBoxValue, "--")
  }
}

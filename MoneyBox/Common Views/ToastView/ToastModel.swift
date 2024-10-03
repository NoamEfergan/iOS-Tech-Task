//
//  ToastModel.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//


public struct ToastModel {
  var style: ToastStyle
  var title: String
  var description: String?
  let length: Int
  
  /// The configuration model for the toast
  /// - Parameters:
  ///   - style: What kind of toast it is. enum.
  ///   - title: The title of the toast
  ///   - description: Body of the toast, doesn't have to be there
  ///   - length: How long do we want the toast to be on screen for.
  public init(style: ToastStyle,
              title: String,
              description: String? = nil,
              length: Int = 2) {
    self.style = style
    self.title = title
    self.description = description
    self.length = length
  }
}

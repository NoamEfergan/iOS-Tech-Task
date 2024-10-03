//
//  ToastView.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import UIKit

// MARK: - ToastView
public class ToastView: UIView {
  // MARK: - UI Views
  private let verticalView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.titleFont
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 2
    return label
  }()

  // MARK: - Lifecycle methods
  public init(frame: CGRect, toastModel: ToastModel) {
    super.init(frame: frame)
    setupViews(with: toastModel)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UIMethods
private extension ToastView {
  func addCornerRadius() {
    layer.cornerRadius = Constants.cornerRadius
    layer.masksToBounds = false
  }

  func addShadowLayer() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = Constants.shadowOffset
    layer.shadowOpacity = Constants.shadowOpacity
    layer.shadowRadius = Constants.shadowRadius
    layer.masksToBounds = false
  }
}

// MARK: - Setup UI Methods
private extension ToastView {
  func setupViews(with toastModel: ToastModel) {
    backgroundColor = .white
    titleLabel.text = toastModel.title
    imageView.image = toastModel.style.image
    verticalView.backgroundColor = toastModel.style.backgroundColor
    setupVerticalView()
    setupImageView()
    setupTitleLabel()
    addCornerRadius()
    addShadowLayer()
  }

  func setupVerticalView() {
    addSubview(verticalView)
    NSLayoutConstraint.activate([
      verticalView.leadingAnchor.constraint(equalTo: leadingAnchor),
      verticalView.topAnchor.constraint(equalTo: topAnchor),
      verticalView.bottomAnchor.constraint(equalTo: bottomAnchor),
      verticalView.widthAnchor.constraint(equalToConstant: Constants.verticalViewWidth)
    ])
  }

  func setupImageView() {
    addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: verticalView.trailingAnchor, constant: Constants.padding),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
      imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize)
    ])
  }

  func setupTitleLabel() {
    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.padding),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding)
    ])
  }
}

// MARK: ToastView.Constants
private extension ToastView {
  enum Constants {
    static let width: CGFloat = min(400, UIScreen.main.bounds.width - (2 * 20))
    static let cornerRadius: CGFloat = 8
    static let imageSize: CGFloat = 24
    static let shadowOffset: CGSize = .init(width: 0, height: 2)
    static let shadowOpacity: Float = 0.1
    static let shadowRadius: CGFloat = 4
    static let verticalViewWidth: CGFloat = 4
    static let titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
    static let padding: CGFloat = 12
  }
}

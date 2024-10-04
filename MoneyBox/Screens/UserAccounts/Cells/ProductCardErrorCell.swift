//
//  ProductCardErrorCell.swift
//  MoneyBox
//
//  Created by Noam Efergan on 04/10/2024.
//

import UIKit

// MARK: - ProductCardErrorCellDelegate
protocol ProductCardErrorCellDelegate: NSObject {
  func retryButtonTapped()
}

// MARK: - ProductCardErrorCell
final class ProductCardErrorCell: UICollectionViewCell {
  static let identifier: String = "ProductCardErrorCell"

  // MARK: - UIViews
  private let containerView = UIView()
  private let errorLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: Constants.fontSize, weight: .medium)
    label.textAlignment = .center
    return label
  }()

  private let retryButton: UIButton = {
    let button = UIButton()
    button.setTitle("Retry", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: Constants.fontSize, weight: .medium)
    button.backgroundColor = UIColor(resource: .accent)
    button.layer.cornerRadius = Constants.buttonCornerRadius
    return button
  }()

  private let errorStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.spacing = Padding.regular
    return stack
  }()

  // MARK: - Properties
  weak var delegate: ProductCardErrorCellDelegate?

  // MARK: - Initialisers
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  func configure(error: String) {
    errorLabel.text = error
    retryButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
  }
}

// MARK: - Private methods
private extension ProductCardErrorCell {
  @objc
  func handleTap() {
    delegate?.retryButtonTapped()
  }
}

// MARK: - UIMethods
private extension ProductCardErrorCell {
  func setupUI() {
    setupContainerView()
    setupStackView()
  }

  func setupContainerView() {
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = Constants.containerCornerRadius
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowOpacity = Constants.shadowOpacity
    containerView.layer.shadowOffset = Constants.shadowOffset
    containerView.layer.shadowRadius = Constants.shadowRadius
    containerView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(containerView)

    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.small),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.small),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.small),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.small),
      containerView.heightAnchor.constraint(equalToConstant: 150)
    ])
  }

  func setupStackView() {
    errorStack.addArrangedSubview(errorLabel)
    errorStack.addArrangedSubview(retryButton)
    containerView.addSubview(errorStack)

    NSLayoutConstraint.activate([
      errorStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      errorStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      errorStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Padding.regular),
      errorStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Padding.regular),

      retryButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
      retryButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth)
    ])

    errorLabel.numberOfLines = 0
    errorLabel.textAlignment = .center
  }
}

// MARK: ProductCardErrorCell.Constants
private extension ProductCardErrorCell {
  enum Constants {
    static let fontSize: CGFloat = 14
    static let shadowOffset = CGSize(width: 0, height: 2)
    static let shadowRadius: CGFloat = 4
    static let shadowOpacity: Float = 0.1
    static let containerCornerRadius: CGFloat = 12
    static let buttonCornerRadius: CGFloat = 12
    static let buttonHeight: CGFloat = 44
    static let buttonWidth: CGFloat = 100
  }
}

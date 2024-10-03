//
//  ProductCardCell.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import UIKit

// MARK: - ProductCardCell
final class ProductCardCell: UICollectionViewCell {
  static let identifier: String = "ProductCardCell"

  // MARK: - UIViews
  private let containerView = UIView()
  private let nameLabel = UILabel()
  private let planValueLabel = UILabel()
  private let moneyBoxValueLabel = UILabel()

  // MARK: - Initialisers
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI Setup
private extension ProductCardCell {
  func setupUI() {
    setupContainerView()
    setupNameLabel()
    setupPlanValueLabel()
    setupMoneyBoxValueLabel()
    setupConstraints()
  }

  func setupContainerView() {
    containerView.backgroundColor = .systemBackground
    containerView.layer.cornerRadius = Constants.containerCornerRadius
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowOpacity = Constants.shadowOpacity
    containerView.layer.shadowOffset = Constants.shadowOffset
    containerView.layer.shadowRadius = Constants.shadowRadius
    containerView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(containerView)
  }

  func setupNameLabel() {
    nameLabel.font = .systemFont(ofSize: Constants.nameFontSize, weight: .medium)
    nameLabel.textColor = .secondaryLabel
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(nameLabel)
  }

  func setupPlanValueLabel() {
    planValueLabel.font = .systemFont(ofSize: Constants.valueFontSize, weight: .bold)
    planValueLabel.textColor = .label
    planValueLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(planValueLabel)
  }

  func setupMoneyBoxValueLabel() {
    moneyBoxValueLabel.font = .systemFont(ofSize: Constants.moneyBoxFontSize, weight: .regular)
    moneyBoxValueLabel.textColor = .secondaryLabel
    moneyBoxValueLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(moneyBoxValueLabel)
  }

  func setupConstraints() {
    setupContainerViewConstraints()
    setupNameLabelConstraints()
    setupPlanValueLabelConstraints()
    setupMoneyBoxValueLabelConstraints()
  }

  func setupContainerViewConstraints() {
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.small),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.small),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.small),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.small)
    ])
  }

  func setupNameLabelConstraints() {
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Padding.regular),
      nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Padding.regular),
      nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Padding.regular)
    ])
  }

  func setupPlanValueLabelConstraints() {
    NSLayoutConstraint.activate([
      planValueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Padding.small),
      planValueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Padding.regular),
      planValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Padding.regular)
    ])
  }

  func setupMoneyBoxValueLabelConstraints() {
    NSLayoutConstraint.activate([
      moneyBoxValueLabel.topAnchor.constraint(equalTo: planValueLabel.bottomAnchor, constant: Padding.extraSmall),
      moneyBoxValueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Padding.regular),
      moneyBoxValueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Padding.regular),
      moneyBoxValueLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor,
                                                 constant: -Padding.regular)
    ])
  }
}

// MARK: - Public methods
extension ProductCardCell {
  func configure(product: DisplayableProduct) {
    nameLabel.text = product.name
    planValueLabel.text = product.planValue
    moneyBoxValueLabel.text = product.moneyBoxValue
  }
}

// MARK: ProductCardCell.Constants
private extension ProductCardCell {
  enum Constants {
    static let containerCornerRadius: CGFloat = 12
    static let shadowOpacity: Float = 0.1
    static let shadowOffset = CGSize(width: 0, height: 2)
    static let shadowRadius: CGFloat = 4
    static let nameFontSize: CGFloat = 14
    static let valueFontSize: CGFloat = 24
    static let moneyBoxFontSize: CGFloat = 16
  }
}

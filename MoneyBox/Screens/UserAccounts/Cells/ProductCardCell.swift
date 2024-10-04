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

  private let nameStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = Padding.extraSmall
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  private let nameLabel = UILabel()
  private let nameTitleLabel = UILabel()

  private let planStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = Padding.extraSmall
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  private let planValueLabel = UILabel()
  private let planValueTitleLabel = UILabel()

  private let moneyBoxStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = Padding.extraSmall
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()

  private let moneyBoxValueLabel = UILabel()
  private let moneyBoxValueTitleLabel = UILabel()

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
    setupNameStack()
    setupPlanValueStack()
    setupMoneyBoxValueStack()
    setupConstraints()
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
  }

  func setupNameStack() {
    nameLabel.font = .systemFont(ofSize: Constants.nameFontSize, weight: .medium)
    nameLabel.textColor = .secondaryLabel
    nameTitleLabel.font = .systemFont(ofSize: Constants.nameFontSize - 2, weight: .light)
    nameTitleLabel.text = "Product name:"
    nameStack.addArrangedSubview(nameTitleLabel)
    nameStack.addArrangedSubview(nameLabel)
    containerView.addSubview(nameStack)
  }

  func setupPlanValueStack() {
    planValueLabel.font = .systemFont(ofSize: Constants.valueFontSize, weight: .bold)
    planValueLabel.textColor = .label
    planValueTitleLabel.font = .systemFont(ofSize: Constants.valueFontSize - 4, weight: .light)
    planValueTitleLabel.text = "Plan value:"
    planStack.addArrangedSubview(planValueTitleLabel)
    planStack.addArrangedSubview(planValueLabel)
    containerView.addSubview(planStack)
  }

  func setupMoneyBoxValueStack() {
    moneyBoxValueLabel.font = .systemFont(ofSize: Constants.moneyBoxFontSize, weight: .regular)
    moneyBoxValueLabel.textColor = .secondaryLabel
    moneyBoxValueTitleLabel.font = .systemFont(ofSize: Constants.moneyBoxFontSize - 2, weight: .light)
    moneyBoxValueTitleLabel.text = "Money box:"
    moneyBoxStack.addArrangedSubview(moneyBoxValueTitleLabel)
    moneyBoxStack.addArrangedSubview(moneyBoxValueLabel)
    containerView.addSubview(moneyBoxStack)
  }

  func setupConstraints() {
    setupContainerViewConstraints()
    setupNameStackConstraints()
    setupPlanValueStackConstraints()
    setupMoneyBoxValueStackConstraints()
  }

  func setupContainerViewConstraints() {
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.small),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.small),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.small),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.small)
    ])
  }

  func setupNameStackConstraints() {
    NSLayoutConstraint.activate([
      nameStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Padding.regular),
      nameStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Padding.regular),
      nameStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Padding.regular)
    ])
  }

  func setupPlanValueStackConstraints() {
    NSLayoutConstraint.activate([
      planStack.topAnchor.constraint(equalTo: nameStack.bottomAnchor, constant: Padding.small),
      planStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Padding.regular),
      planStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Padding.regular)
    ])
  }

  func setupMoneyBoxValueStackConstraints() {
    NSLayoutConstraint.activate([
      moneyBoxStack.topAnchor.constraint(equalTo: planStack.bottomAnchor, constant: Padding.extraSmall),
      moneyBoxStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Padding.regular),
      moneyBoxStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Padding.regular),
      moneyBoxStack.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor,
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

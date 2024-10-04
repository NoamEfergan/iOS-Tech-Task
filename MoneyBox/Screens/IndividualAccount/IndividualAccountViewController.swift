import UIKit

// MARK: - IndividualAccountViewController
final class IndividualAccountViewController: UIViewController {
  // MARK: - UIViews
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32, weight: .black)
    label.textColor = UIColor(resource: .accent)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let cardView: CardView = {
    let view = CardView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let planValueLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .bold)
    return label
  }()

  private let planValueStackView: UIStackView = {
    let label = UILabel()
    label.text = "Plan value:"
    label.font = .systemFont(ofSize: 16, weight: .regular)
    let stackView = UIStackView(arrangedSubviews: [label])
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let moneyBoxValueLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .bold)
    return label
  }()

  private let moneyBoxValueStackView: UIStackView = {
    let label = UILabel()
    label.text = "Moneybox:"
    label.font = .systemFont(ofSize: 16, weight: .regular)
    let stackView = UIStackView(arrangedSubviews: [label])
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let contentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = Padding.regular
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let addButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Add £10", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    button.backgroundColor = UIColor(resource: .accent)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  // MARK: - Initialisers
  init(product: DisplayableProduct) {
    titleLabel.text = product.name
    planValueLabel.text = product.planValue
    moneyBoxValueLabel.text = product.moneyBoxValue
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(resource: .grey)
    setupUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
}

// MARK: - UIMethods

private extension IndividualAccountViewController {
  func setupUI() {
    setupTitleLabel()
    setupCardView()
    setupContentStackView()
    setupAddButton()
  }

  func setupCardView() {
    view.addSubview(cardView)
    NSLayoutConstraint.activate([
      cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Padding.large),
      cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.regular),
      cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.regular)
    ])
  }

  func setupContentStackView() {
    planValueStackView.addArrangedSubview(planValueLabel)
    moneyBoxValueStackView.addArrangedSubview(moneyBoxValueLabel)
    contentStackView.addArrangedSubview(planValueStackView)
    contentStackView.addArrangedSubview(moneyBoxValueStackView)
    cardView.addSubview(contentStackView)
    NSLayoutConstraint.activate([
      contentStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Padding.regular),
      contentStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Padding.regular),
      contentStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Padding.regular),
      contentStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Padding.regular)
    ])
  }

  func setupTitleLabel() {
    view.addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 4),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.regular),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.regular)
    ])
  }

  func setupAddButton() {
    view.addSubview(addButton)
    NSLayoutConstraint.activate([
      addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      addButton.widthAnchor.constraint(equalToConstant: 120),
      addButton.heightAnchor.constraint(equalToConstant: 44)
    ])
  }
}

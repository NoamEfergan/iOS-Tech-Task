import Lottie
import UIKit

// MARK: - IndividualAccountViewController
final class IndividualAccountViewController: UIViewController {
  // MARK: - Properties
  private let viewModel: IndividualAccountViewModel
  private let id: Int
  private var confettiAnimationView: LottieAnimationView?

  // MARK: - UIViews
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .black)
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
    label.font = .systemFont(ofSize: Constants.valueFontSize, weight: .bold)
    return label
  }()

  private let planValueStackView: UIStackView = {
    let label = UILabel()
    label.text = "Plan value:"
    label.font = .systemFont(ofSize: Constants.valueFontSize, weight: .regular)
    let stackView = UIStackView(arrangedSubviews: [label])
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let moneyBoxValueLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: Constants.valueFontSize, weight: .bold)
    return label
  }()

  private let moneyBoxValueStackView: UIStackView = {
    let label = UILabel()
    label.text = "Moneybox:"
    label.font = .systemFont(ofSize: Constants.valueFontSize, weight: .regular)
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

  private let addButton: LoadingButton = {
    let button = LoadingButton()
    button.setTitle("Add £10", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: Constants.valueFontSize, weight: .semibold)
    button.backgroundColor = UIColor(resource: .accent)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = Constants.buttonCornerRadius
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  // MARK: - Initialisers
  init(product: DisplayableProduct, viewModel: IndividualAccountViewModel) {
    self.viewModel = viewModel
    id = product.id
    titleLabel.text = product.name
    planValueLabel.text = product.planValue
    moneyBoxValueLabel.text = product.moneyBoxValue
    super.init(nibName: nil, bundle: nil)
    viewModel.delegate = self
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
    setupConfettiAnimation()
  }

  func setupConfettiAnimation() {
    confettiAnimationView = .init(name: "Confetti_lottie")
    confettiAnimationView?.frame = view.bounds
    confettiAnimationView?.contentMode = .scaleAspectFit
    confettiAnimationView?.loopMode = .playOnce
    confettiAnimationView?.animationSpeed = 0.5
    view.addSubview(confettiAnimationView!)
    confettiAnimationView?.isHidden = true
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
    addButton.addTarget(self, action: #selector(onAddButtonTapped), for: .touchUpInside)
    view.addSubview(addButton)
    NSLayoutConstraint.activate([
      addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      addButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
      addButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
    ])
  }
}

// MARK: - Private methods
private extension IndividualAccountViewController {
  @objc
  func onAddButtonTapped() {
    viewModel.addMoney(id: id)
  }

  func playConfettiAnimation() {
    confettiAnimationView?.isHidden = false
    confettiAnimationView?.play { [weak self] finished in
      if finished {
        self?.confettiAnimationView?.isHidden = true
      }
    }
  }
}

// MARK: IndividualAccountViewModelDelegate
extension IndividualAccountViewController: IndividualAccountViewModelDelegate {
  func onStateUpdate(state: IndividualAccountViewModel.State) {
    switch state {
    case .idle:
      addButton.stopLoading()
    case .loading:
      addButton.startLoading()
    case let .success(newAmount):
      addButton.stopLoading()
      let toastModel = ToastModel(style: .success, title: "Added successfully")
      DispatchQueue.main.async { [weak self] in
        self?.moneyBoxValueLabel.text = newAmount
        self?.showToast(toastModel: toastModel)
        self?.playConfettiAnimation()
      }
    case let .failure(msg):
      addButton.stopLoading()
      let toastModel = ToastModel(style: .error, title: msg)
      DispatchQueue.main.async { [weak self] in
        self?.showToast(toastModel: toastModel)
      }
    }
  }
}

// MARK: IndividualAccountViewController.Constants
private extension IndividualAccountViewController {
  enum Constants {
    static let titleFontSize: CGFloat = 32
    static let valueFontSize: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 8
    static let buttonHeight: CGFloat = 44
    static let buttonWidth: CGFloat = 120
  }
}

import Networking
import UIKit

private extension String {
  static let cellReusableID: String = "Cell"
}

// MARK: - UserAccountsViewController
final class UserAccountsViewController: UIViewController {
  // MARK: - Properties
  weak var coordinator: MainCoordinator?
  private let viewModel: UserAccountsViewModel
  private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

  // MARK: - UIViews
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32, weight: .black)
    label.textColor = UIColor(resource: .accent)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let totalPlanValueTitle: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .black)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let totalPlanValueLabel: ShimmeringLabel = {
    let label = ShimmeringLabel()
    label.font = .systemFont(ofSize: 16, weight: .black)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let totalPlanValueStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = Padding.regular
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let titleStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = Padding.regular
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var logoutButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
    button.tintColor = UIColor(resource: .accent)
    button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private lazy var collectionView: UICollectionView = {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    listConfiguration.showsSeparators = false
    let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  // MARK: - Initialisers

  init(viewModel: UserAccountsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    viewModel.delegate = self
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle methods

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    configureDataSource()
    viewModel.fetchProducts()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
}

// MARK: - UI Setup Methods
private extension UserAccountsViewController {
  func setupUI() {
    view.backgroundColor = UIColor(resource: .grey)
    setupTitleStack()
    setupPlanValueStack()
    setupCollectionView()
  }

  func setupPlanValueStack() {
    totalPlanValueTitle.text = "Total Plan Value:"
    totalPlanValueLabel.text = "Loading..." // Won't show due to shimmer
    totalPlanValueLabel.shimmer()
    totalPlanValueStackView.addArrangedSubview(totalPlanValueTitle)
    totalPlanValueStackView.addArrangedSubview(totalPlanValueLabel)
  }

  func setupTitleStack() {
    let titleAndLogoutStack = UIStackView(arrangedSubviews: [titleLabel, logoutButton])
    titleAndLogoutStack.axis = .horizontal
    titleAndLogoutStack.alignment = .center

    titleStackView.addArrangedSubview(titleAndLogoutStack)
    titleStackView.addArrangedSubview(totalPlanValueStackView)
    titleLabel.text = "Hello \(UserDefaultsManager.fetchName() ?? "")!"
    view.addSubview(titleStackView)
    NSLayoutConstraint.activate([
      titleStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 4),
      titleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.regular),
      titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.regular),

      logoutButton.widthAnchor.constraint(equalToConstant: 44),
      logoutButton.heightAnchor.constraint(equalToConstant: 44)
    ])
  }

  func setupCollectionView() {
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    collectionView.backgroundColor = .clear
  }
}

// MARK: - Private methods
private extension UserAccountsViewController {
  func updateTotalPlanValue(value: String?) {
    totalPlanValueLabel.text = value
    totalPlanValueLabel.stopShimmering()
  }

  @objc
  func logoutButtonTapped() {
    coordinator?.logout()
  }
}

// MARK: - DataSource methods

private extension UserAccountsViewController {
  func configureDataSource() {
    let productCellRegistration = UICollectionView
      .CellRegistration<ProductCardCell, DisplayableProduct> { cell, _, product in
        cell.configure(product: product)
        cell.backgroundColor = UIColor(resource: .grey)
      }

    let errorCellRegistration = UICollectionView
      .CellRegistration<ProductCardErrorCell, String> { cell, _, errorMessage in
        cell.configure(error: errorMessage)
        cell.delegate = self
      }

    let placeholderCellRegistration = UICollectionView.CellRegistration<ProductCardCell, Void> { cell, _, _ in
      cell.placeHolder()
    }

    dataSource = UICollectionViewDiffableDataSource<Section,
      Item>(collectionView: collectionView) { collectionView, indexPath, item in
        switch item {
        case let .product(product):
          return collectionView
            .dequeueConfiguredReusableCell(using: productCellRegistration,
                                           for: indexPath,
                                           item: product)
        case let .error(errorMessage):
          return collectionView
            .dequeueConfiguredReusableCell(using: errorCellRegistration,
                                           for: indexPath,
                                           item: errorMessage)
        case .placeholder:
          return collectionView
            .dequeueConfiguredReusableCell(using: placeholderCellRegistration,
                                           for: indexPath,
                                           item: ())
        }
      }
  }

  func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.appendSections([.main])

    switch viewModel.state {
    case .loading:
      snapshot.appendItems([Item.placeholder])
    case let .error(errorMessage):
      snapshot.appendItems([.error(errorMessage)])
    case let .loaded(response):
      updateTotalPlanValue(value: response.totalPlanValue?.formatted(.currency(code: "GBP")))
      if let products = response.productResponses?.compactMap({ $0.mapToDisplayable() }) {
        snapshot.appendItems(products.map { Item.product($0) })
      }
    }

    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}

// MARK: UICollectionViewDelegate
extension UserAccountsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch viewModel.state {
    case .loading, .error:
      collectionView.deselectItem(at: indexPath, animated: false)
    case let .loaded(response):
      collectionView.deselectItem(at: indexPath, animated: true)
      guard let products = response.productResponses?.compactMap({ $0.mapToDisplayable() }),
            let product = products[safe: indexPath.row] else { return }
      coordinator?.navigateToIndividualAccounts(product: product)
    }
  }
}

// MARK: UserAccountsViewModelDelegate
extension UserAccountsViewController: UserAccountsViewModelDelegate {
  func onStateUpdate() {
    DispatchQueue.main.async { [weak self] in
      self?.applySnapshot()
    }
  }
}

// MARK: ProductCardErrorCellDelegate
extension UserAccountsViewController: ProductCardErrorCellDelegate {
  func retryButtonTapped() {
    viewModel.fetchProducts()
  }
}

// MARK: - Helper types
extension UserAccountsViewController {
  enum Section {
    case main
  }

  enum Item: Hashable {
    case product(DisplayableProduct)
    case error(String)
    case placeholder
  }
}

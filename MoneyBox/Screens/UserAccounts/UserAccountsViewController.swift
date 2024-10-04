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
  private let titleView: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32, weight: .black)
    label.textColor = UIColor(resource: .accent)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var collectionView: UICollectionView = {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    listConfiguration.showsSeparators = false
    let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    setupTitleView()
    setupCollectionView()
  }

  func setupTitleView() {
    view.addSubview(titleView)
    titleView.text = "Hello \(UserDefaultsManager.fetchName() ?? "")!"
    NSLayoutConstraint.activate([
      titleView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 4),
      titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Padding.regular),
      titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Padding.regular)
    ])
  }

  func setupCollectionView() {
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    collectionView.backgroundColor = .clear
  }

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
          return collectionView.dequeueConfiguredReusableCell(using: productCellRegistration,
                                                              for: indexPath,
                                                              item: product)
        case let .error(errorMessage):
          return collectionView.dequeueConfiguredReusableCell(using: errorCellRegistration,
                                                              for: indexPath,
                                                              item: errorMessage)
        case .placeholder:
          return collectionView.dequeueConfiguredReusableCell(using: placeholderCellRegistration,
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
      if let products = response.productResponses?.compactMap({ $0.mapToDisplayable() }) {
        snapshot.appendItems(products.map { Item.product($0) })
      }
    }

    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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

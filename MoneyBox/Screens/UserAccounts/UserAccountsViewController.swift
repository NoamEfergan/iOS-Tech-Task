//
//  UserAccountsViewController.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

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

  // MARK: - UIViews
  private let titleView: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32, weight: .black)
    label.textColor = UIColor(resource: .accent)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let collectionView: UICollectionView = {
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
    viewModel.fetchProducts()
    setupUI()
  }

  override func viewWillAppear(_ animated: Bool) {
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
    collectionView.dataSource = self
    collectionView.register(ProductCardCell.self, forCellWithReuseIdentifier: ProductCardCell.identifier)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: .cellReusableID)
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    collectionView.backgroundColor = .clear
  }
}

// MARK: UICollectionViewDataSource
extension UserAccountsViewController: UICollectionViewDataSource {
  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    switch viewModel.state {
    case .loading:
      return 4
    case .error:
      return 1
    case let .loaded(response):
      return response.productResponses?.count ?? 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch viewModel.state {
    case .loading:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCardCell.identifier,
                                                          for: indexPath) as? ProductCardCell else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .cellReusableID, for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
      }
      cell.placeHolder()
      return cell
    case .error:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .cellReusableID, for: indexPath)
      cell.backgroundColor = .red
      return cell
    case let .loaded(response):
      guard let product = response.productResponses?[safe: indexPath.row],
            let displayable = product.mapToDisplayable(),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCardCell.identifier,
                                                          for: indexPath) as? ProductCardCell
      else {
        return collectionView.dequeueReusableCell(withReuseIdentifier: .cellReusableID, for: indexPath)
      }
      cell.configure(product: displayable)
      cell.backgroundColor = UIColor(resource: .grey)
      return cell
    }
  }
}

// MARK: UserAccountsViewModelDelegate
extension UserAccountsViewController: UserAccountsViewModelDelegate {
  func onStateUpdate() {
    DispatchQueue.main.async { [collectionView] in
      collectionView.reloadData()
    }
  }
}

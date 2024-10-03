//
//  UserAccountsViewController.swift
//  MoneyBox
//
//  Created by Noam Efergan on 03/10/2024.
//

import Networking
import UIKit

// MARK: - UserAccountsViewController
final class UserAccountsViewController: UIViewController {
  // MARK: - Properties
  weak var coordinator: UserAccountsCoordinator?
  private var state: State = .loading

  // MARK: - UIViews
  private let titleView: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 32, weight: .black)
    label.textColor = UIColor(resource: .accent)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let collectionView: UICollectionView = {
    var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
    listConfiguration.showsSeparators = false
    let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()

  // MARK: - Lifecycle methods

  override func viewDidLoad() {
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
    collectionView.register(ProductCardCell.self, forCellWithReuseIdentifier: ProductCardCell.identifier)
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Padding.regular),
      collectionView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}

// MARK: UICollectionViewDataSource
extension UserAccountsViewController: UICollectionViewDataSource {
  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    switch state {
    case .loading:
      return 3
    case .error:
      return 1
    case let .loaded(products):
      return products.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch state {
    case .loading, .error:
      return UICollectionViewCell() // TODO: Implement these
    case let .loaded(products):
      guard let product = products[safe: indexPath.row],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCardCell.identifier,
                                                          for: indexPath) as? ProductCardCell else {
        assertionFailure("Couldn't get cells!")
        return UICollectionViewCell()
      }
      cell.configure(product: product)
      return cell
    }
  }
}

// MARK: UserAccountsViewController.State
private extension UserAccountsViewController {
  enum State {
    case loading
    case error
    case loaded(products: [DisplayableProduct])
  }
}

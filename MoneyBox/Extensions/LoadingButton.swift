import UIKit

// MARK: - LoadingButton
class LoadingButton: UIButton {
  // MARK: - Properties
  private let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .medium)
    indicator.hidesWhenStopped = true
    indicator.color = .white
    return indicator
  }()

  // MARK: - Lifecycle methods
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupActivityIndicator()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupActivityIndicator()
  }
}

// MARK: - Public methods
extension LoadingButton {
  func startLoading() {
    isEnabled = false
    titleLabel?.alpha = 0
    activityIndicator.startAnimating()
  }

  func stopLoading() {
    isEnabled = true
    titleLabel?.alpha = 1
    activityIndicator.stopAnimating()
  }
}

// MARK: - Private methods
private extension LoadingButton {
  private func setupActivityIndicator() {
    addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}

//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import Networking
import UIKit

// MARK: - LoginViewController
class LoginViewController: UIViewController {
  // MARK: - UIViews
  private let emailTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Email"
    textField.borderStyle = .roundedRect
    textField.backgroundColor = .systemGray6
    return textField
  }()

  private let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Password"
    textField.borderStyle = .roundedRect
    textField.backgroundColor = .systemGray6
    textField.isSecureTextEntry = true
    textField.clearsOnInsertion = true
    return textField
  }()

  private let loginButton: LoadingButton = {
    let button = LoadingButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Login", for: .normal)
    button.backgroundColor = UIColor(resource: .accent)
    button.layer.cornerRadius = 5
    return button
  }()

  private let logo: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(resource: .moneybox)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let loginStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .medium)
    indicator.color = .white
    indicator.hidesWhenStopped = true
    return indicator
  }()

  // MARK: - Properties
  private var state: State = .loading {
    didSet { handleState(state) }
  }

  private let viewModel = LoginViewModel(networkingService: DataProvider())
  private var loadingTask: Task<Void, Never>?

  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    setupUI()
    addKeyboardObservers()
  }

  override func viewDidDisappear(_: Bool) {
    removeKeyboardObservers()
  }

  deinit {
    loadingTask = nil
  }
}

// MARK: - UI methods
private extension LoginViewController {
  func setupUI() {
    view.backgroundColor = UIColor(resource: .grey)
    setupStackView()
    setupLoginButton()
  }

  func setupStackView() {
    loginStack.addArrangedSubview(logo)
    loginStack.addArrangedSubview(emailTextField)
    loginStack.addArrangedSubview(passwordTextField)
    view.addSubview(loginStack)
    NSLayoutConstraint.activate([
      loginStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loginStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
      loginStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      loginStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    ])
  }

  func setupLoginButton() {
    loginButton.addTarget(self, action: #selector(onTapLoginButton), for: .touchUpInside)
    view.addSubview(loginButton)
    NSLayoutConstraint.activate([
      loginButton.topAnchor.constraint(equalTo: loginStack.bottomAnchor, constant: 20),
      loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loginButton.widthAnchor.constraint(equalTo: loginStack.widthAnchor),
      loginButton.heightAnchor.constraint(equalToConstant: 44)
    ])
  }
}

// MARK: - Private methods
private extension LoginViewController {
  func handleState(_ state: State) {
    switch state {
    case let .errored(error):
      handleErrorState(error)
    case .success:
      print("Success")
    case .loading:
      handleLoadingState()
    }
  }

  @objc
  func onTapLoginButton() {
    state = .loading
    guard let email = emailTextField.text, LoginValidator.validateEmail(email) else {
      state = .errored("Invalid email")
      return
    }
    guard let password = passwordTextField.text, LoginValidator.validatePassword(password) else {
      state = .errored("Invalid password")
      return
    }
    login(email: email, password: password)
  }

  @MainActor
  func login(email: String, password: String) {
    loadingTask?.cancel()
    loadingTask = Task {
      if let errorMessage = await viewModel.performLogin(with: email, and: password) {
        self.state = .errored(errorMessage)
      } else {
        self.state = .success
      }
    }
  }

  func handleErrorState(_ error: String) {
    let model = ToastModel(style: .error, title: error)
    passwordTextField.isEnabled = true
    emailTextField.isEnabled = true
    loginButton.stopLoading()
    showToast(toastModel: model)
  }

  func handleLoadingState() {
    passwordTextField.isEnabled = false
    emailTextField.isEnabled = false
    loginButton.startLoading()
  }
}

// MARK: - Keyboard observers
private extension LoginViewController {
  func addKeyboardObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }

  func removeKeyboardObservers() {
    NotificationCenter.default.removeObserver(self)
  }

  @objc
  func keyboardWillShow(notification _: NSNotification) {
    if view.frame.origin.y == 0 {
      view.frame.origin.y -= 50
    }
  }

  @objc
  func keyboardWillHide(notification _: NSNotification) {
    if view.frame.origin.y != 0 {
      view.frame.origin.y = 0
    }
  }
}

// MARK: LoginViewController.State
extension LoginViewController {
  enum State {
    case errored(String)
    case success
    case loading
  }
}

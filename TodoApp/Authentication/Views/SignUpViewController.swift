//
//  RegistrationViewController.swift
//  TodoApp
//
//  Created by Marwa Awad on 10.03.2025.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: - Varivbles
    private let animationViews = AnimationViews.shared
    private let viewModel = SignUpViewModel.shared
    // MARK: - UI Components
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "to-do-list")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Create an Account"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let subHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up to get started"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerLabel, subHeaderLabel,  emailTextField, passwordTextField, confirmPasswordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let bottomStackView = UIStackView(arrangedSubviews: [loginPromptLabel, loginButton])
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 5
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        return bottomStackView
    }()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationViews.animateHeader(label: headerLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
//        animationViews.setupGradientBackground(view: view)
    }
    
    //MARK: - Animation
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor(red: 0.35, green: 0.78, blue: 0.98, alpha: 1.0).cgColor,
            UIColor(red: 0.85, green: 0.43, blue: 0.97, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func animateHeader() {
        headerLabel.alpha = 0
        headerLabel.transform = CGAffineTransform(translationX: 0, y: -20)
        
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.headerLabel.alpha = 1
            self.headerLabel.transform = .identity
        }
    }
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoImage)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        

        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: 120),
            logoImage.heightAnchor.constraint(equalToConstant: 120),
            
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - Selectors
extension SignUpViewController {
    
    @objc private func didTapLogin() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSignUp() {
        let email =  emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if viewModel.regestration(email: email, password: password) {
            print("did tap sign up")
            
            let homeVC = TabBarController()
            navigationController?.setViewControllers([homeVC], animated: true)
            
        }
    }
}

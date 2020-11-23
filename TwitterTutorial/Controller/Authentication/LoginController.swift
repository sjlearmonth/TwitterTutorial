//
//  LoginController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 20/11/2020.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Properties
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
    private lazy var emailContainer = Utilities.createCustomInputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"),
                                                                               andTextField: emailTextField)
       
    private lazy var passwordContainer = Utilities.createCustomInputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),
                                                                                  andTextField: passwordTextField)
    
    private let emailTextField = Utilities.createCustomTextField(withPlaceholder: "Email")

    private let passwordTextField: UITextField = {
        let tf = Utilities.createCustomTextField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.setHeight(to: 50.0)
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        button.addTarget(self, action: #selector(handleLogInButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAnAccountButton = Utilities.createCustomButton(withFirstPart: "Don't have an account? ",
                                                                       secondPart: "Sign Up",
                                                                       target: self,
                                                                       andSelector: #selector(handleDontHaveAnAccountButtonClicked))

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150.0, height: 150.0)
        
        let stack = UIStackView(arrangedSubviews: [emailContainer,
                                                   passwordContainer,
                                                   logInButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingLeft: 32.0,
                     paddingRight: 32.0)
        
        view.addSubview(dontHaveAnAccountButton)
        dontHaveAnAccountButton.anchor(left: view.leftAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingLeft: 40.0,
                                     paddingRight: 40.0)
    }
    
    // MARK: - Selectors

    @objc func handleLogInButtonClicked() {
        print("DEBUG: Log In button clicked")
    }
    
    @objc func handleDontHaveAnAccountButtonClicked() {
        print("DEBUG: Don't have an account button clicked")
    }
}


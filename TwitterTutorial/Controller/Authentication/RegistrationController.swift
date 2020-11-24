//
//  RegistrationController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 20/11/2020.
//

import UIKit

class RegistrationController: UIViewController {

    // MARK: - Properties
    
    private let photoPlusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePhotoPlusButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainer = Utilities.createCustomInputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"),
                                                                               andTextField: emailTextField)
       
    private lazy var passwordContainer = Utilities.createCustomInputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),
                                                                                  andTextField: passwordTextField)
    
    private lazy var fullnameContainer = Utilities.createCustomInputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"),
                                                                               andTextField: fullnameTextField)
       
    private lazy var usernameContainer = Utilities.createCustomInputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),
                                                                                  andTextField: usernameTextField)

    private let emailTextField = Utilities.createCustomTextField(withPlaceholder: "Email")

    private let passwordTextField: UITextField = {
        let tf = Utilities.createCustomTextField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()

    private let fullnameTextField = Utilities.createCustomTextField(withPlaceholder: "Full Name")

    private let usernameTextField = Utilities.createCustomTextField(withPlaceholder: "Username")
    
    private let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.setHeight(to: 50.0)
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        button.addTarget(self, action: #selector(handleRegistrationButtonClicked), for: .touchUpInside)
        return button
    }()

    private let alreadyHaveAnAccountButton = Utilities.createCustomButton(withFirstPart: "Already have an account? ",
                                                                          secondPart: "Log In",
                                                                          target: self,
                                                                          andSelector: #selector(handleAlreadyHaveAnAccountButtonClicked))


    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.backgroundColor = .twitterBlue
        
        view.addSubview(photoPlusButton)
        photoPlusButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        photoPlusButton.setDimensions(width: 128.0, height: 128.0)
        
        let stack = UIStackView(arrangedSubviews: [emailContainer,
                                                   passwordContainer,
                                                   fullnameContainer,
                                                   usernameContainer,
                                                   registrationButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
        
        view.addSubview(stack)
        stack.anchor(top: photoPlusButton.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32.0,
                     paddingLeft: 32.0,
                     paddingRight: 32.0)
        
        view.addSubview(alreadyHaveAnAccountButton)
        alreadyHaveAnAccountButton.anchor(left: view.leftAnchor,
                                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                          right: view.rightAnchor,
                                          paddingLeft: 40.0,
                                          paddingRight: 40.0)

    }
    
    // MARK: - Selectors
    
    @objc func handleAlreadyHaveAnAccountButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handlePhotoPlusButtonClicked() {
        print("DEBUG: photo plus button clicked")
    }

    @objc func handleRegistrationButtonClicked() {
        print("DEBUG: registration button clicked")
    }
}

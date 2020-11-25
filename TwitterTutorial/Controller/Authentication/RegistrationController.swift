//
//  RegistrationController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 20/11/2020.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {

    // MARK: - Properties
    
    private let imagePickerController = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let photoPlusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePhotoPlusButtonClicked), for: .touchUpInside)
        button.layer.cornerRadius = 128.0 / 2.0
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        return button
    }()
    
    private lazy var emailContainer = Utilities.createCustomInputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"),
                                                                               andTextField: emailTextField)
       
    private lazy var passwordContainer = Utilities.createCustomInputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"),
                                                                                  andTextField: passwordTextField)
    
    private lazy var fullnameContainer = Utilities.createCustomInputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"),
                                                                               andTextField: fullnameTextField)
       
    private lazy var usernameContainer = Utilities.createCustomInputContainerView(withImage: #imageLiteral(resourceName: "ic_person_outline_white_2x"),
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
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
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
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.modalTransitionStyle = .crossDissolve
        present(imagePickerController, animated: true)
    }

    @objc func handleRegistrationButtonClicked() {
        print("DEBUG: registration button clicked")
        
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let fullname = fullnameTextField.text, !fullname.isEmpty,
              let username = usernameTextField.text, !username.isEmpty else { return }
        
        let credentials = AuthCredentials(email: email,
                                          password: password,
                                          fullname: fullname,
                                          username: username,
                                          profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: credentials) { (error, ref) in
            print("DEBUG: sign up successful")
            print("DEBUG: handle update user interface here")
        }
    
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        self.profileImage = profileImage
        self.photoPlusButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.photoPlusButton.layer.borderColor = UIColor.white.cgColor
        self.photoPlusButton.layer.borderWidth = 3.0
        
        dismiss(animated: true, completion: nil)
    }
}

//
//  EditProfileController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 01/02/2021.
//

import UIKit

private let reuseIdentifier = "EditProfileReuseIdentifier"

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
}

class EditProfileController: UITableViewController {
    
    // MARK - Properties
    
    private var user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private let footerView = EditProfileFooter()
    private let imagePicker = UIImagePickerController()
    private var selectedImage: UIImage? {
        didSet {
            headerView.profileImageView.image = selectedImage
        }
    }
    private var userInfoChanged = false
    
    private var userPhotoChanged: Bool {
        return selectedImage != nil
    }
    
    weak var delegate: EditProfileControllerDelegate?
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureImagePicker()
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        view.endEditing(true)
        guard userPhotoChanged || userInfoChanged else { return }
        updateUserData()
    }
    
    // MARK: - API
    
    func updateUserData() {
        
        if userPhotoChanged && !userInfoChanged {
            updateProfileImage()
        }
        
        if userInfoChanged && !userPhotoChanged {
            UserService.shared.saveUserData(user: user) { (err, ref) in
                self.delegate?.controller(self, wantsToUpdate: self.user)
            }
        }
        
        if userInfoChanged && userPhotoChanged {
            UserService.shared.saveUserData(user: user) { (error, ref) in
                self.updateProfileImage()
            }
        }
    }
    
    func updateProfileImage() {
        guard let image = selectedImage else { return }
        
        UserService.shared.updateProfileImage(image: image) { (profileImageUrl) in
            self.user.profileImageURL = profileImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    // MARK: - Helpers
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        
    }
    
    private func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 180.0)
        
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        headerView.delegate = self
        footerView.delegate = self
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}


// MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0.0 }
        
        return option == .bio ? 100.0 : 48.0
    }
}

// MARK: - UIImagePickerControllerDelegate/UINavigationControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else { return }
        switch viewModel.option {
        
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.fullname = fullname
            userInfoChanged = true
            navigationItem.rightBarButtonItem?.isEnabled = true
            
        case .username:
            guard let username = cell.infoTextField.text else { return }
            user.username = username
            
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
}

extension EditProfileController: EditProfileFooterDelegate {
    func handleLogout() {
        
    }
    
    
}

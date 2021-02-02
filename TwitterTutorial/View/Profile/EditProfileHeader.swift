//
//  EditProfileHeader.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 01/02/2021.
//

import UIKit

protocol EditProfileHeaderDelegate: class {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    
    // MARK: - Properties
    
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?
    
    public let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3.0
        iv.setDimensions(width: 100.0, height: 100.0)
        iv.layer.cornerRadius = 100.0 / 2.0
        return iv
    }()

    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhotoClicked), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        
        backgroundColor = .twitterBlue
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16.0)
        profileImageView.sd_setImage(with: user.profileImageURL, completed: nil)
        
        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8.0)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleChangeProfilePhotoClicked() {
        delegate?.didTapChangeProfilePhoto()
    }
}

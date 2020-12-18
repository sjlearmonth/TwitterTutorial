//
//  ProfileHeader.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 14/12/2020.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeader)
}


class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let filterBar = ProfileFilterView()
    
    private lazy var containerView: UIView = {

        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42.0, paddingLeft: 30.0)
        backButton.setDimensions(width: 30.0, height: 30.0)
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.backgroundColor = .lightGray
        piv.layer.borderColor = UIColor.white.cgColor
        piv.layer.borderWidth = 4.0
        return piv
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        button.setDimensions(width: 100.0, height: 36.0)
        button.layer.cornerRadius = 36.0 / 2.0
        button.addTarget(self, action: #selector(handleEditProfileButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor."
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleFollowingLabelClicked))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGestureRecogniser)
        return label
    }()

    private let followersLabel: UILabel = {
        let label = UILabel()
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleFollowersLabelClicked))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGestureRecogniser)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108.0)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24.0, paddingLeft: 8.0)
        profileImageView.setDimensions(width: 80.0, height: 80.0)
        profileImageView.layer.cornerRadius = 80.0 / 2.0
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12.0, paddingRight: 12.0)
        
        let userDetailsStackView = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        userDetailsStackView.axis = .vertical
        userDetailsStackView.distribution = .fillProportionally
        userDetailsStackView.spacing = 4.0
        
        addSubview(userDetailsStackView)
        userDetailsStackView.anchor(top: profileImageView.bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         paddingTop: 8.0,
                         paddingLeft: 12.0,
                         paddingRight: 12.0)
        
        let followStackView = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStackView.axis = .horizontal
        followStackView.spacing = 8
        followStackView.distribution = .fillEqually
        
        addSubview(followStackView)
        followStackView.anchor(top: userDetailsStackView.bottomAnchor, left: leftAnchor, paddingTop: 8.0, paddingLeft: 12.0)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50.0)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleBackButtonClicked() {
        print("DEBUG: back button clicked")
        delegate?.handleDismissal()
    }
    
    @objc func handleEditProfileButtonClicked() {
        print("DEBUG: edit profile follow clicked")
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func handleFollowingLabelClicked() {
        
    }
    
    @objc func handleFollowersLabelClicked() {
        
    }
    
    // MARK: Helper Functions
    
    private func configure() {
        guard let user = user else { return }
        
        let viewModel = ProfileHeaderViewModel(user: user)
        
        profileImageView.sd_setImage(with: user.profileImageURL)
        
        editProfileButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
    }
}

// MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }
        
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
    

}

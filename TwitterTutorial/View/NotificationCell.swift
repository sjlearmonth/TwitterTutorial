//
//  NotificationCell.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 18/01/2021.
//

import UIKit
import SDWebImage

protocol NotificationCellDelegate: class {
    func didTapProfileImage(_ cell: NotificationCell)
    func didTapFollowButton(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var notification: Notification? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.setDimensions(width: 40.0, height: 40.0)
        piv.layer.cornerRadius = 40.0 / 2.0
        piv.backgroundColor = .twitterBlue
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        piv.addGestureRecognizer(tapGestureRecognizer)
        piv.isUserInteractionEnabled = true
        return piv
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowButtonClicked), for: .touchUpInside)
        button.setDimensions(width: 92.0, height: 32.0)
        button.layer.cornerRadius = 32.0 / 2.0
        return button
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some test notification message"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right: rightAnchor, paddingRight: 12)
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        delegate?.didTapProfileImage(self)
    }
    
    @objc func handleFollowButtonClicked() {
        delegate?.didTapFollowButton(self)
    }
    
    // MARK: - Helper Functions
    
    private func configure() {
        guard let notification = notification else { return }
        let viewModel = NotificationViewModel(notification: notification)
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        notificationLabel.attributedText = viewModel.notificationText
        
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonText, for: .normal)
    }
}

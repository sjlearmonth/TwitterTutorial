//
//  NotificationCell.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 18/01/2021.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        
    }
}

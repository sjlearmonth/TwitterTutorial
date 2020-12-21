//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 21/12/2020.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    private lazy var profileImageView: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.setDimensions(width: 48.0, height: 48.0)
        piv.layer.cornerRadius = 48.0 / 2.0
        piv.backgroundColor = .twitterBlue
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        piv.addGestureRecognizer(tapGestureRecognizer)
        piv.isUserInteractionEnabled = true
        return piv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.text = "Peter Parker"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .lightGray
        label.text = "spiderman"
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.numberOfLines = 0
        label.text = "Some test caption from spiderman for now"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = .left
        label.text = "6:33 PM - 01/28/2020"
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(handleOptionsButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let topDivider = UIView()
        topDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(topDivider)
        topDivider.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8.0, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16.0)
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(bottomDivider)
        bottomDivider.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8.0, height: 1.0)

        return view
    }()
    
    private lazy var retweetsLabel: UILabel = {
        let label = UILabel()
        label.text = "2 retweets"
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()

    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.text = "0 likes"
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stackView.spacing = 12
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16.0, paddingLeft: 16.0)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stackView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20.0, paddingLeft: 16.0, paddingRight: 16.0)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20.0, paddingLeft: 16.0)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stackView)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8.0)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20.0, height: 40.0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        print("DEBUG: profile image tapped")
    }
    
    @objc func handleOptionsButtonClicked() {
        print("DEBUG: options button clicked")
    }
}

//
//  TweetCell.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 09/12/2020.
//

import UIKit

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFit
        piv.clipsToBounds = true
        piv.setDimensions(width: 48.0, height: 48.0)
        piv.layer.cornerRadius = 48.0 / 2.0
        piv.backgroundColor = .twitterBlue
        return piv
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.text = "Some test caption"
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20.0, height: 20.0)
        button.addTarget(self, action: #selector(handleCommentButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20.0, height: 20.0)
        button.addTarget(self, action: #selector(handleRetweetButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20.0, height: 20.0)
        button.addTarget(self, action: #selector(handleLikeButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20.0, height: 20.0)
        button.addTarget(self, action: #selector(handleShareButtonClicked), for: .touchUpInside)
        return button
    }()

    private let infoLabel = UILabel()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor,
                                left: leftAnchor,
                                paddingTop: 8.0,
                                paddingLeft: 8.0)
        
        let stackView = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        
        addSubview(stackView)
        stackView.anchor(top: profileImageView.topAnchor,
                         left: profileImageView.rightAnchor,
                         right: rightAnchor,
                         paddingLeft: 12.0,
                         paddingRight: 12.0)
        
        infoLabel.font = UIFont.systemFont(ofSize: 14.0)
        infoLabel.text = "Eddie Brock @venom"
        
        let actionButtonStack = UIStackView(arrangedSubviews: [commentButton,
                                                               retweetButton,
                                                               likeButton,
                                                               shareButton])
        actionButtonStack.axis = .horizontal
        actionButtonStack.spacing = 72.0
        
        addSubview(actionButtonStack)
        actionButtonStack.anchor(bottom: bottomAnchor, paddingBottom: 8.0)
        actionButtonStack.centerX(inView: self)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor,
                             bottom: bottomAnchor,
                             right: rightAnchor,
                             height: 1.0)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleCommentButtonClicked() {
        print("DEBUG: comment button clicked")
    }

    @objc func handleRetweetButtonClicked() {
        print("DEBUG: retweet button clicked")
    }

    @objc func handleLikeButtonClicked() {
        print("DEBUG: like button clicked")
    }

    @objc func handleShareButtonClicked() {
        print("DEBUG: share button clicked")
        
    }

    // MARK: -
    
}

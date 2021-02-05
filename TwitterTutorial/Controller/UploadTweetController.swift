//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 02/12/2020.
//

import UIKit
import ActiveLabel

class UploadTweetController: UIViewController {
    
    // MARK: - Properties
    
    private let user: User
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private lazy var tweetActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32.0 / 2.0
        button.addTarget(self, action: #selector(handleTweetActionButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let piv = UIImageView()
        piv.contentMode = .scaleAspectFill
        piv.clipsToBounds = true
        piv.setDimensions(width: 48.0, height: 48.0)
        piv.layer.cornerRadius = 48.0 / 2.0
        piv.backgroundColor = .twitterBlue
        return piv
    }()
    
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        label.setWidth(to: view.frame.width)
        return label
    }()
    
    private let captionTextView = InputTextView()
    
    // MARK: - Lifecycle
    
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMentionHandler()
        
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
                
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12.0
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 16.0,
                     paddingLeft: 16.0,
                     paddingRight: 16.0)
        
        profileImageView.sd_setImage(with: user.profileImageURL, completed: nil)
        
        tweetActionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        
        replyLabel.isVisible = viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
        
    }
    
    private func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetActionButton)
    }
    
    private func configureMentionHandler() {
        replyLabel.handleMentionTap { mention in
            
        }
    }
    
    // MARK: - API
    
    fileprivate func uploadMentionNotification(forCaption caption: String, tweetId: String?) {
        guard caption.contains("@") else { return }
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        
        words.forEach { word in
            guard word.hasPrefix("@") else { return }
            
            var username = word.trimmingCharacters(in: .symbols)
            username = username.trimmingCharacters(in: .punctuationCharacters)
            
            UserService.shared.fetchUser(withUsername: username) { mentionedUser in
                NotificationService.shared.uploadNotification(toUser: mentionedUser, type: .mention, tweetId: tweetId)
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleCancelClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTweetActionButtonClicked() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: config) { (error, reference) in
            if let error = error {
                print("DEBUG: Failed to upload tweet with error = \(error.localizedDescription)")
                return
            }
            
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(toUser: tweet.user, type: .reply, tweetId: tweet.tweetId)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

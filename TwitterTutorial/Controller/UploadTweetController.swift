//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 02/12/2020.
//

import UIKit

class UploadTweetController: UIViewController {
    
    // MARK: - Properties
    
    private let user: User
    
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
        piv.contentMode = .scaleAspectFit
        piv.clipsToBounds = true
        piv.setDimensions(width: 48.0, height: 48.0)
        piv.layer.cornerRadius = 48.0 / 2.0
        piv.contentMode = .scaleAspectFill
        piv.backgroundColor = .twitterBlue
        return piv
    }()
    
    private let captionTextView = CaptionTextView()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
                
        let stackView = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stackView.axis = .horizontal
        stackView.spacing = 12.0
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 16.0,
                         paddingLeft: 16.0,
                         paddingRight: 16.0)
        
        profileImageView.sd_setImage(with: user.profileImageURL, completed: nil)
        
    }
    
    private func configureNavigationBar() {
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetActionButton)
    }
    
    // MARK: - API
    
    // MARK: - Selectors
    
    @objc func handleCancelClicked() {
        print("DEBUG: cancel clicked")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTweetActionButtonClicked() {
        print("DEBUG: tweet action button clicked")
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption) { (error, reference) in
            print("DEBUG: Tweet has been uploaded to the realtime database.")
            if let error = error {
                print("DEBUG: Failed to upload tweet with error = \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

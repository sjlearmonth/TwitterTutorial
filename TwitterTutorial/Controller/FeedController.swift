//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 19/11/2020.
//

import UIKit
import SDWebImage

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            print("DEBUG: Did set user in feed controller")
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let reuseIdentifier = "TweetCell"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        fetchTweets()
        
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44.0, height: 44.0)
        navigationItem.titleView = imageView
        
    }
    
    private func configureLeftBarButton() {
     
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32.0, height: 32.0)
        profileImageView.layer.cornerRadius = 32.0 / 2.0
        profileImageView.layer.masksToBounds = true
        profileImageView.sd_setImage(with: user.profileImageURL, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)

    }
    
    // MARK: - API
    
    private func fetchTweets() {
        TweetService.shared.fetchTweets {tweets in
            self.tweets = tweets
            
        }
    }
}

// MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}

extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped() {
        let controller = ProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(controller, animated: true)
    }
    

}

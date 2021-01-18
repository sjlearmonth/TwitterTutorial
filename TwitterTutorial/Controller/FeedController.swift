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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.barStyle = .default
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
            self.checkIfUserLikedTweets(tweets)
        }
    }
    
    func checkIfUserLikedTweets(_ tweets: [Tweet]) {
        for (index, tweet) in tweets.enumerated() {
            TweetService.shared.checkIfUserLikedTweet(tweet) { (didLike) in
                guard didLike == true else { return }
                
                self.tweets[index].didLike = true
            }
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 72)
    }
}

// MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    func handleLikeTapped(_ cell: TweetCell) {
        
        guard let tweet = cell.tweet else { return }
        
        TweetService.shared.likeTweet(tweet: tweet) { (error, ref) in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            // only upload notification if tweet is being liked
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        present(navigationController, animated: true, completion: nil)
    }
    
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileController(user: user)
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

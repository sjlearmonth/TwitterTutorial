//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 19/11/2020.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    var user: User? {
        didSet {
            guard let navigationController = viewControllers?.first as? UINavigationController else { return }
            guard let feedController = navigationController.viewControllers.first as? FeedController else { return }
            feedController.user = user
        }
    }
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(#imageLiteral(resourceName: "new_tweet"), for: .normal)
        button.layer.cornerRadius = 56 / 2
        button.addTarget(self, action: #selector(handleActionButtonClicked), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .twitterBlue
//        logUserOut()
        authenticateUserAndConfigureUI()
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
    }
    
    private func configureViewControllers() {
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feedNC = makeNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let exploreNC = makeNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)

        let notifications = NotificationsController()
        let notificationsNC = makeNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        let conversationsNC = makeNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        viewControllers = [feedNC, exploreNC, notificationsNC, conversationsNC]
    }
    
    private func makeNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nc = UINavigationController(rootViewController: rootViewController)
        nc.tabBarItem.image = image
        nc.navigationBar.tintColor = .white
        return nc
    }

    // MARK: - Selectors
    
    @objc func handleActionButtonClicked() {
        guard let user = user else { return }
        let viewController = UploadTweetController(user: user, config: .tweet)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func authenticateUserAndConfigureUI() {
        
        if Auth.auth().currentUser == nil {
            // The UINavigationController instantiation code must be done on the main thread or it won't work
            DispatchQueue.main.async {
                let navigationController = UINavigationController(rootViewController: LoginController())
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.modalTransitionStyle = .crossDissolve
                self.present(navigationController, animated: true, completion: nil)
            }
        } else {
            configureUI()
            configureViewControllers()
            fetchUserData()
        }
    }
    
    private func logUserOut() {
        
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    private func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
}

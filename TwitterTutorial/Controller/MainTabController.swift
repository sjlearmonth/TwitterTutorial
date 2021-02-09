//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 19/11/2020.
//

import UIKit
import Firebase

enum ActionButtonConfiguration {
    case tweet
    case message
}

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    private var buttonConfig: ActionButtonConfiguration = .tweet
    
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
        authenticateUserAndConfigureUI()
    
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        self.delegate = self
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
    }
    
    private func configureViewControllers() {
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feedNC = makeNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = SearchController(config: .UserSearch)
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
        
        let controller: UIViewController
        
        switch buttonConfig {
        case .message:
            controller = SearchController(config: .messages)
        case .tweet:
            guard let user = user else { return }
            controller = UploadTweetController(user: user, config: .tweet)
        }

        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true, completion: nil)
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
    
    private func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        let actionButtonImage:UIImage = index == 3 ? #imageLiteral(resourceName: "mail") : #imageLiteral(resourceName: "new_tweet")
        actionButton.setImage(actionButtonImage, for: .normal)
        buttonConfig = index == 3 ? .message : .tweet
    }
}

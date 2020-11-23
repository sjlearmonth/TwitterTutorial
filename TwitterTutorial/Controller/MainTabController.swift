//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 19/11/2020.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties
    
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
        
        view.backgroundColor = .red
        
        configureViewController()
        
        configureUI()

    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        
    }
    
    private func configureViewController() {
        
        let feed = FeedController()
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
        
    }
    
}

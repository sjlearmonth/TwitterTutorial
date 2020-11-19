//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 19/11/2020.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        configureViewController()

    }
    
    // MARK: - Helper Functions
    
    private func configureViewController() {
        
        let feed = FeedController()
        let feedNC = makeNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let exploreNC = makeNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)

        let notifications = NotificationsController()
        let notificationsNC = makeNavigationController(image: UIImage(named: "search_unselected"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        let conversationsNC = makeNavigationController(image: UIImage(named: "search_unselected"), rootViewController: conversations)
        
        viewControllers = [feedNC, exploreNC, notificationsNC, conversationsNC]
    }
    
    private func makeNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nc = UINavigationController(rootViewController: rootViewController)
        nc.tabBarItem.image = image
        nc.navigationBar.tintColor = .white
        return nc
    }


    
}

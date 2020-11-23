//
//  ConversationsController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 19/11/2020.
//

import UIKit

class ConversationsController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        
        view.backgroundColor = .white
        
        navigationItem.title = "Messages"
    }
}

//
//  TweetController.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 19/12/2020.
//

import UIKit

class TweetController : UICollectionViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor 
        configureCollectionView()
    }
    
    // MARK: - Helper Functions
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        
    }
}

//
//  UploadTweetViewModel.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 22/12/2020.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
        case .reply(let tweet):
            
        }
    }
}


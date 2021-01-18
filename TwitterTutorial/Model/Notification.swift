//
//  Notification.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 18/01/2021.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    let tweetId: String?
    var timestamp: Date!
    let user: User
    var tweet: Tweet?
    var type: NotificationType!
    
    init(user: User, tweet: Tweet?, dictionary: [String: AnyObject]) {
        self.user = user
        self.tweet = tweet
        
        self.tweetId = dictionary["tweetId"] as? String ?? ""
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
        
    }
}

//
//  Tweet.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 09/12/2020.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetId: String
    var likes: Int
    var timestamp: Date!
    let retweetCount: Int
    var user: User
    var didLike = false
    
    init(user: User, tweetId: String, dictionary: [String : Any]) {
        self.caption = dictionary["caption"] as? String ?? "Empty caption"
        self.tweetId = tweetId
        self.likes = dictionary["likes"] as? Int ?? 0
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        self.user = user
    }
}

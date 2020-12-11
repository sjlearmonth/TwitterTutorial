//
//  TweetViewModel.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 11/12/2020.
//

import UIKit

struct TweetViewModel {
    
    let tweet: Tweet
    let user: User
    
    var profileImageURL: URL? {
        return user.profileImageURL
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? ""
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0)])
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " ・ \(timestamp)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        print("DEBUG: date of tweet is \(timestamp)")
        return title
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
}

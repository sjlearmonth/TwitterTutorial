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
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ・ dd/MM/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var retweetsAttributedString: NSAttributedString? {
        return attributedText(withvalue: tweet.retweetCount, andText: "Retweets")
    }

    var likesAttributedString: NSAttributedString? {
        return attributedText(withvalue: tweet.likes, andText: "Likes")
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
    
    private func attributedText(withvalue value: Int, andText text: String) -> NSAttributedString {
        
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14.0)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),
                                                               NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        return attributedTitle
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.setWidth(to: width)
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

}

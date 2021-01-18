//
//  NotificationService.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 18/01/2021.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType,
                            tweet: Tweet? = nil,
                            user: User? = nil) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        if let tweet = tweet {
            values["tweetId"] = tweet.tweetId
            NOTIFICATIONS_REF.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            NOTIFICATIONS_REF.child(user.uid).childByAutoId().updateChildValues(values)
        }
        
        
    }
}

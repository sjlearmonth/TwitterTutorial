//
//  TweetService.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 02/12/2020.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping ( Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values: [AnyHashable: Any] = ["uid": uid,
                                          "timestamp": Int(NSDate().timeIntervalSince1970),
                                          "likes": 0,
                                          "retweets": 0,
                                          "caption": caption]
        
        TWEETS_REF.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
}



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
        
        let ref = TWEETS_REF.childByAutoId()
        
        ref.updateChildValues(values) { (error, ref) in
            guard let tweetId = ref.key else { return }
            USER_TWEETS_REF.child(uid).updateChildValues([tweetId : 1], withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        TWEETS_REF.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key
            
            UserService.shared.fetchUserData(uid: uid) { (user) in
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        USER_TWEETS_REF.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            
            TWEETS_REF.child(tweetId).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String : Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }

                UserService.shared.fetchUserData(uid: uid) { (user) in
                    let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
}



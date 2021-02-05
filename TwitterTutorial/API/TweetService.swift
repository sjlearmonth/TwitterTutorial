//
//  TweetService.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 02/12/2020.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping DatabaseCompletionType) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [AnyHashable: Any] = ["uid": uid,
                                          "timestamp": Int(NSDate().timeIntervalSince1970),
                                          "likes": 0,
                                          "retweets": 0,
                                          "caption": caption]
        
        switch type {
        case .tweet:
            TWEETS_REF.childByAutoId().updateChildValues(values) { (error, ref) in
                guard let tweetId = ref.key else { return }
                USER_TWEETS_REF.child(uid).updateChildValues([tweetId : 1], withCompletionBlock: completion)
            }
            break
        case .reply(let tweet):
            values["replyingTo"] = tweet.user.username
            TWEET_REPLIES_REF.child(tweet.tweetId).childByAutoId().updateChildValues(values) { (error, ref) in
                guard let replyKey = ref.key else { return }
                USER_REPLIES_REF.child(uid).updateChildValues([tweet.tweetId: replyKey], withCompletionBlock: completion)
            }
            
            break
        }
    }
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(currentUid).observe(.childAdded) { snapshot in
            let followerUid = snapshot.key
            
            USER_TWEETS_REF.child(followerUid).observe(.childAdded) { snapshot in
                let tweetId = snapshot.key
                self.fetchTweet(withTweetId: tweetId) { tweet in
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
        
        USER_TWEETS_REF.child(currentUid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            self.fetchTweet(withTweetId: tweetId) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        USER_TWEETS_REF.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            
            self.fetchTweet(withTweetId: tweetId) { (tweet) in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweet(withTweetId tweetId: String, completion: @escaping (Tweet) -> Void) {
        TWEETS_REF.child(tweetId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }

            UserService.shared.fetchUser(uid: uid) { (user) in
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    func fetchLikes(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        USER_LIKES_REF.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            self.fetchTweet(withTweetId: tweetId) { likedTweet in
                var tweet = likedTweet
                tweet.didLike = true
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchReplies(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var replies = [Tweet]()
        
        USER_REPLIES_REF.child(user.uid).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else { return }
            
            TWEET_REPLIES_REF.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String : Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let replyId = snapshot.key

                UserService.shared.fetchUser(uid: uid) { (user) in
                    let reply = Tweet(user: user, tweetId: replyId, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping ( [Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        
        TWEET_REPLIES_REF.child(tweet.tweetId).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key

            UserService.shared.fetchUser(uid: uid) { (user) in
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }

        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping (DatabaseCompletionType)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        TWEETS_REF.child(tweet.tweetId).child("likes").setValue(likes)
        
        if tweet.didLike {
            // unlike tweet
            USER_LIKES_REF.child(uid).child(tweet.tweetId).removeValue { (error, ref) in
                TWEET_LIKES_REF.child(tweet.tweetId).removeValue(completionBlock: completion)
            }
            
        } else {
            // like tweet
            USER_LIKES_REF.child(uid).updateChildValues([tweet.tweetId: 1]) { (error, ref) in
                TWEET_LIKES_REF.child(tweet.tweetId).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
        
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        USER_LIKES_REF.child(uid).child(tweet.tweetId).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
}



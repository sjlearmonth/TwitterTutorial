//
//  Constants.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 25/11/2020.
//

import Firebase

let REALTIME_DATABASE_REF = Database.database().reference()
let USERS_REF = REALTIME_DATABASE_REF.child("users")
let TWEETS_REF = REALTIME_DATABASE_REF.child("tweets")
let USER_TWEETS_REF = REALTIME_DATABASE_REF.child("user-tweets")
let USER_FOLLOWERS_REF = REALTIME_DATABASE_REF.child("user-followers")
let USER_FOLLOWING_REF = REALTIME_DATABASE_REF.child("user-following")
let TWEET_REPLIES_REF = REALTIME_DATABASE_REF.child("tweet-replies")
let USER_LIKES_REF = REALTIME_DATABASE_REF.child("user-likes")
let TWEET_LIKES_REF = REALTIME_DATABASE_REF.child("tweet-likes")
let NOTIFICATIONS_REF = REALTIME_DATABASE_REF.child("notifications")
let USER_REPLIES_REF = REALTIME_DATABASE_REF.child("user-replies")

let STORAGE_REF = Storage.storage().reference()
let PROFILE_IMAGES_REF = STORAGE_REF.child("profile_images")




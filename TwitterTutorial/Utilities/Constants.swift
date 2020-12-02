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

let STORAGE_REF = Storage.storage().reference()
let PROFILE_IMAGES_REF = STORAGE_REF.child("profile_images")


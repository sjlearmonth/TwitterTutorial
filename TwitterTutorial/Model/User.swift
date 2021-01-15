//
//  User.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 26/11/2020.
//

import Foundation
import Firebase

struct User {
    let fullname: String
    let email: String
    let username: String
    var profileImageURL: URL?
    let uid: String
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    var isFollowed = false
    var stats: UserRelationStats?
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? "fullname unknown"
        self.email = dictionary["email"] as? String ?? "email unknown"
        self.username = dictionary["username"] as? String ?? "username unknown"
        
        if let profileImageURLString = dictionary["profileImageURL"] as? String {
            guard let URL = URL(string: profileImageURLString) else { return }
            self.profileImageURL = URL
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}


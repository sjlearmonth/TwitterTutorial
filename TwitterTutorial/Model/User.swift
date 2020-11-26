//
//  User.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 26/11/2020.
//

import Foundation

struct User {
    let fullname: String
    let email: String
    let username: String
    let profileImageURL: String
    let uid: String
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullname = dictionary["fullname"] as? String ?? "fullname unknown"
        self.email = dictionary["email"] as? String ?? "email unknown"
        self.username = dictionary["username"] as? String ?? "username unknown"
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? "profileImageURL unknown"
    }
}

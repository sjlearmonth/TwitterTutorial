//
//  ProfileHeaderViewModel.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 15/12/2020.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followersString: NSAttributedString? {
        return attributedText(withvalue: 0, andText: "followers")
    }

    var followingString: NSAttributedString? {
        return attributedText(withvalue: 2, andText: "following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Loading"
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    private func attributedText(withvalue value: Int, andText text: String) -> NSAttributedString {
        
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14.0)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),
                                                               NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        return attributedTitle
    }
}

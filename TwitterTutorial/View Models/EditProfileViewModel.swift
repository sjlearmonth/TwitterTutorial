//
//  EditProfileViewModel.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 01/02/2021.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .fullname: return "Username"
        case .username: return "Name"
        case .bio: return "Bio"
        }
    }
}

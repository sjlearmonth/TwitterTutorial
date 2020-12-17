//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 26/11/2020.
//

import Firebase

struct UserService {
    
    static let shared = UserService()
    
    func fetchUserData(uid: String, completion: @escaping (User) -> Void) {
        
        USERS_REF.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshotDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: snapshotDictionary)
            completion(user)
        }
        
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        USERS_REF.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
}

//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 26/11/2020.
//

import Firebase

struct UserService {
    
    static let shared = UserService()
    
    func fetchUserData(completion: @escaping (User) -> Void) {
       print("DEBUG: Fetch current user data")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        USERS_REF.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshotDictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: snapshotDictionary)
            completion(user)
        }
        
    }
}

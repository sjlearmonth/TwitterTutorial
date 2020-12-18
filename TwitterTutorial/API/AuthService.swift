//
//  AuthService.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 25/11/2020.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func registerUser(credentials: AuthCredentials, completion: @escaping DatabaseCompletionType) {
        
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let imageFilename = NSUUID().uuidString
        let storageRef = PROFILE_IMAGES_REF.child(imageFilename)
        
        storageRef.putData(imageData, metadata: nil) { (metaData, error) in
            storageRef.downloadURL { (URL, error) in
                guard let profileImageURL = URL?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    
                    if let error = error {
                        print("DEBUG: error is \(error.localizedDescription)")
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email" : email,
                                  "fullname" : fullname,
                                  "username" : username,
                                  "profileImageURL" : profileImageURL]
                    
                    USERS_REF.child(uid).updateChildValues(values, withCompletionBlock: completion)
                        
                }
                
            }
        }
    }
    
    func logUserIn(withEmail email: String, andPassword password: String, completion: AuthDataResultCallback?) {
        
        debugPrint("DEBUG: email is \(email), password is \(password)")
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
}


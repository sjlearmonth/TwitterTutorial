//
//  NotificationService.swift
//  TwitterTutorial
//
//  Created by Stephen Learmonth on 18/01/2021.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(toUser user: User,
                            type: NotificationType,
                            tweetId: String? = nil) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        if let tweetId = tweetId {
            values["tweetId"] = tweetId
        }
        
        NOTIFICATIONS_REF.child(user.uid).childByAutoId().updateChildValues(values)
    }
    
    func fetchNotifications(completion: @escaping ([Notification]) -> Void) {
        
        var notifications = [Notification]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        NOTIFICATIONS_REF.child(uid).observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { (user) in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
}

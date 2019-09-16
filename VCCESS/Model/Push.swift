//
//  Push.swift
//  PremiumAlerts
//
//  Created by Todd Mathison on 12/3/16.
//  Copyright © 2016 Todd Mathison. All rights reserved.
//

import UIKit
import UserNotifications

class Push: NSObject, UNUserNotificationCenterDelegate
{
    public static let shared = Push()
    public static let PushTokenSetNotification: String = "PushTokenSetNotification"
    public static let PushRequestComplete: String = "PushRequestComplete"
    public var pushToken: String?
    {
        didSet
        {
            if let token = self.pushToken
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Push.PushTokenSetNotification), object: token)
                
//                guard let userID = User.shared.userID
//                    , let apiToken = User.shared.apiToken
//                    else { return() }
//
//                var languageCode: String = ""
//
//                if let code = Locale.current.languageCode
//                {
//                    languageCode = code
//                }
//
//                if let language = Locale.preferredLanguages.first
//                {
//                    let codes = language.components(separatedBy: "-")
//                    if codes.count == 2
//                        , let code = codes.first
//                    {
//                        languageCode = code
//                    }
//                }
//
//                User.shared.appInit(userID: userID, apiToken: apiToken, deviceToken: token, language: languageCode, completion: { error in })
            }
        }
    }
    
    override init()
    {
        super.init()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateApplicationBadge(sender:)), name: NSNotification.Name(rawValue: MessagingService.MessagingServiceUnreadUpdated), object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateApplicationBadge(sender:)), name: NSNotification.Name(rawValue: User.UserPendingEventsUpdated), object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateApplicationBadge(sender:)), name: NSNotification.Name(rawValue: User.UserPendingFollowersUpdated), object: nil)

    }
    
    @objc func updateApplicationBadge(sender: Notification?)
    {
        DispatchQueue.main.async
        {
//            UIApplication.shared.applicationIconBadgeNumber = MessagingService.shared.unreadConversations().count + User.shared.followersPending.count + User.shared.eventsPending.count
        }
    }

    func register()
    {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options:[.badge, .alert, .sound])
        {
            granted, error in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Push.PushRequestComplete), object: nil)
        }
    }
 
    
    func update(product_code: String, token: String, completionHandler: @escaping (NSError?) -> ())
    {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        //  User clicked on it
        
        self.handleResponse(notification: response.notification)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert])
        
        //  App is up and running
    }
    
    func handleResponse(notification: UNNotification)
    {
        print(notification.request.content.userInfo)
        
        if let type: String = notification.request.content.userInfo["type"] as? String
        {
//            switch type.lowercased()
//            {
//                case "event_invite":
//                case "user_follow":
//                case "chat_message":
//                default:
//                    return()
//            }
        }
    }
}

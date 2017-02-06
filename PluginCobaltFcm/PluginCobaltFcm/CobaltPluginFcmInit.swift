//
//  CobaltPluginFcmInit.swift
//  PluginCobaltFcm
//
//  Created by antoine on 01/02/2017.
//  Copyright © 2017 Cobaltians. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging
import UserNotifications

class CobaltPluginFcmInit: CobaltViewController{
    
    let gcmMessageIDKey = "gcm.message_id"
    
    static func initFCM(application:UIApplication){
        // Override point for customization after application launch.
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        FIRApp.configure()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CobaltPluginFcm.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
    }
    
}


@available(iOS 10, *)
extension CobaltPluginFcmInit : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    // App in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension CobaltPluginFcmInit : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}



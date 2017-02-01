//
//  Notifications.swift
//  FirebaseDemo
//
//  Created by antoine on 30/01/2017.
//  Copyright © 2017 Cobaltians. All rights reserved.


import Foundation
import Firebase
import FirebaseMessaging

class Notifications: CobaltViewController{
    
    static let sharedInstance = Notifications()
    private var token:String?
    private var callback: String?
    var deleg:CobaltDelegate?

    
    func getToken(callback:String){
        Notifications.sharedInstance.callback = callback
        if Notifications.sharedInstance.token != nil{
            onTokenReceived()
        }

    }
    
    
    
    
    
    
    func tokenRefreshNotification(_ notification: Notification) {
        Notifications.sharedInstance.token = FIRInstanceID.instanceID().token()
        
        
        if Notifications.sharedInstance.callback != nil && Notifications.sharedInstance.deleg != nil{
            var data = Dictionary<String, String>()
            data["token"] = Notifications.sharedInstance.token
            data["apiKey"] = SECRET_KEY
            let notificationName = Notification.Name("onTokenReceived")
            NotificationCenter.default.post(name: notificationName, object: data)
            Notifications.sharedInstance.callback = nil
        }
        
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
        
        print("TOKEN : ")
        print(FIRInstanceID.instanceID().token()!)
        Notifications.sharedInstance.token = FIRInstanceID.instanceID().token()
        onTokenReceived()
    }
    
    
    
    func onTokenReceived(){
        var data = Dictionary<String, String>()
        data["token"] = Notifications.sharedInstance.token
        data["apiKey"] = SECRET_KEY
        data["callback"] = Notifications.sharedInstance.callback
        
        let notificationName = Notification.Name("onTokenReceived")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: data)
        Notifications.sharedInstance.callback = nil
    }
    

    
}

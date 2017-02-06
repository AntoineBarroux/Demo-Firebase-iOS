//
//  CobaltFcmPluginManager.swift
//  FirebaseDemo
//
//  Created by antoine on 01/02/2017.
//  Copyright © 2017 Cobaltians. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging

let CALLBACK = "callback"
let ACTION = "action"

let ACTION_GETTOKEN = "getToken"
let ACTION_SUBSCRIBE = "subscribeToTopic"
let ACTION_UNSUBSCRIBE = "unsubscribeFromTopic"


class FcmManager: CobaltAbstractPlugin{
    
    static var token:String?
    private static var controller:CobaltViewController?
    private static var callback:String?
    
    override init(){
        NSLog("initialisation de FcmManager")
    }
    
    static func initFCM(application: UIApplication){
        CobaltFcmPluginInit.sharedInstance.initFCM(application: application)
    }
    
    // MARK : CobaltAbstractPlugin
    
    override func onMessage(fromCobaltController viewController: CobaltViewController!, andData data: [AnyHashable : Any]!) {
        self.onMessageWithCobaltController(viewController: viewController, andData: data)
    }
    
    override func onMessageFromWebLayer(withCobaltController viewController: CobaltViewController!, andData data: [AnyHashable : Any]!) {
        self.onMessageWithCobaltController(viewController: viewController, andData: data)

    }
    
    func onMessageWithCobaltController(viewController: CobaltViewController, andData data: [AnyHashable: Any]){
        var callback:String? = data[CALLBACK] as? String
        var action:String? = data[ACTION] as? String
        
        if action != nil{
            if action == ACTION_GETTOKEN{
                // Need to provide the generated token
                FcmManager.controller = viewController
                FcmManager.callback = callback
                FcmManager.getToken()
            }
            
            if action == ACTION_SUBSCRIBE{
                let data = data["data"] as! NSDictionary
                if let topic = data["topic"] as? String{
                    FIRMessaging.messaging().subscribe(toTopic: "/topics/\(topic)")
                    NSLog("Inscription au topic \(topic)")
                }
                if callback != nil{
                    viewController.sendCallback(callback, withData: nil)
                }
            }
            
            if action == ACTION_UNSUBSCRIBE{
                let data = data["data"] as! NSDictionary
                if let topic = data["topic"] as? String{
                    FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/\(topic)")
                    NSLog("Désinscription du topic \(topic)")
                }
                if callback != nil{
                    viewController.sendCallback(callback, withData: nil)
                }
            }
        }
    }
    
    
    // MARK : MANAGEMENT OF FCM
    
    static func connect() {
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
        
        FcmManager.token = FIRInstanceID.instanceID().token()
        FcmManager.onTokenReceived()
    }
    
    
    static func disconnect(){
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    
    
    
    // MARK : TOKEN MANAGEMENT
    
    static func getToken(){
        if FcmManager.token != nil{
            FcmManager.onTokenReceived()
        }
    }
    
    static func onTokenReceived(){
        var data = Dictionary<String, String>()
        data["token"] = FcmManager.token
        
        // If controller is not nil,we send the callback with the token
        if let myController = FcmManager.controller{
            if FcmManager.token != nil{
                myController.sendCallback(FcmManager.callback, withData: data as NSDictionary)
                FcmManager.controller = nil
                FcmManager.callback = nil
            }
        }
    }
}

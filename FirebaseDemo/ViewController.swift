//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by antoine on 19/12/2016.
//  Copyright © 2016 Cobaltians. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

class ViewController: CobaltViewController, CobaltDelegate {
    
    private var notif:Notifications
    
    //MARK : LIFECYCLE

    required init?(coder: NSCoder){
        notif = Notifications.sharedInstance
        
        super.init(coder: coder)
        self.setDelegate(self)
        
        notif.deleg = self
        let notificationName = Notification.Name("onTokenReceived")
        NotificationCenter.default.addObserver(self, selector: #selector(self.onTokenReceived), name: notificationName, object: nil)
        
        Cobalt.setResourcePath(Bundle.main.resourcePath! + "/common/")
        initWithPage("index.html", andController: "default")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MARK : DELEGATE
    
    func onUnhandledEvent(_ event: String, withData data: [AnyHashable : Any], andCallback callback: String) -> Bool{

        if (event == EVENT_GETTOKEN){
            self.notif.getToken(callback: callback)
            return true
        }
        
        if (event == EVENT_SUBSCRIBE){
            let nomTopic:String = data["name"] as! String
            FIRMessaging.messaging().subscribe(toTopic: "/topics/\(nomTopic)")
            NSLog("Abonnement au topic \(nomTopic)")
            sendCallback(callback, withData: nil)
            return true
        }
        
        if (event == EVENT_UNSUBSCRIBE){
            let nomTopic:String = data["name"] as! String
            FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/\(nomTopic)")
            NSLog("Désabonnement du topic \(nomTopic)")
            sendCallback(callback, withData: nil)
            return true
        }
        
        
        return false
    }
    
    func onUnhandledMessage(_ message: [AnyHashable : Any]) -> Bool{
        return false
    }
    
    func onUnhandledCallback(_ callback: String, withData data: [AnyHashable : Any]) -> Bool{
        return false
    }
    
    func onTokenReceived(notification: NSNotification){
        let infos:Dictionary<String, String> = notification.userInfo as! Dictionary<String, String>
        var data = Dictionary<String, String>()
        data["token"] = infos["token"]
        data["apiKey"] = infos["apiKey"]
        sendCallback(infos["callback"], withData: data as NSDictionary)
    }


}


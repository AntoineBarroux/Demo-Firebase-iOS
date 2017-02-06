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
    
    //MARK : LIFECYCLE

    required init?(coder: NSCoder){
        super.init(coder: coder)
        self.setDelegate(self)
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

        if (event == EVENT_GETAPIKEY){
            NSLog("Récupération de la clé d'API")
            var data = Dictionary<String, String>()
            data["apiKey"] = SECRET_KEY
            sendCallback(callback, withData: data as NSDictionary)
        }
        
        return false
    }
    
    func onUnhandledMessage(_ message: [AnyHashable : Any]) -> Bool{
        return false
    }
    
    func onUnhandledCallback(_ callback: String, withData data: [AnyHashable : Any]) -> Bool{
        return false
    }
    

}


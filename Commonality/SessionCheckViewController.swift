//
//  SessionCheckViewController.swift
//  Commonality
//
//  Created by Chris Rodriguez on 12/16/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

class SessionCheckViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if let email = defaults.string(forKey: defaultsKeys.userEmail), let sessionID = defaults.string(forKey: defaultsKeys.sessionID) {
                
            print("Credentials:")
            print(sessionID)
            print(email)
            
            getRequest(url: baseUrl + "users/sessionValid") { (d: Dictionary<String, AnyObject>) in
                DispatchQueue.main.async(){
                    if (d["resultCode"]! as! Int == 130) {
                        print("Logged in.")
                        self.performSegue(withIdentifier: "loggedIn", sender: self)
                    } else {
                        print("Not logged in.")
                        self.performSegue(withIdentifier: "notLoggedIn", sender: self)
                    }
                }
            }
        } else {
            print("No Credentials saved.")
            self.performSegue(withIdentifier: "notLoggedIn", sender: self)
        }
    }
}

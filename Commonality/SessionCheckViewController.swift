//
//  SessionCheckViewController.swift
//  Commonality
//
//  Created by Chris Rodriguez on 12/16/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit
import Alamofire

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
            
            let headers: HTTPHeaders = [
                "email": defaults.string(forKey: defaultsKeys.userEmail)!,
                "sessionID": defaults.string(forKey: defaultsKeys.sessionID)!
            ]
            
            AF.request(baseUrl + "users/sessionValid", method: .get, headers: headers).responseJSON { response in
                switch (response.result) {
                case .success:
                    if let result = response.value {
                        let JSON = result as! NSDictionary
                        print(JSON)
    
                        // Perform the correct segue based on if the user is logged in or not.
                        let segue = JSON["resultCode"]! as! Int == 130 ? "loggedIn" : "notLoggedIn"
                        self.performSegue(withIdentifier: segue, sender: self)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.performSegue(withIdentifier: "notLoggedIn", sender: self)
                }
            }
            
        } else {
            print("No Credentials saved.")
            self.performSegue(withIdentifier: "notLoggedIn", sender: self)
        }
    }
}

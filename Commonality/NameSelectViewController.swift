//
//  NameSelectViewController.swift
//  Commonality
//
//  Created by Chris Rodriguez on 12/16/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit
import Alamofire

class NameSelectViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func continueTapped(_ sender: Any) {
        
        if let nameText = nameTextField.text?.trim(), !nameText.isEmpty {
        
            self.continueButton.loadingIndicator(true, "");
            let defaults = UserDefaults.standard
            
            let parameters = ["field": nameText] as Dictionary<String, String>
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "email": defaults.string(forKey: defaultsKeys.userEmail)!,
                "sessionID": defaults.string(forKey: defaultsKeys.sessionID)!
            ]

            // Send the request up. Woo.
            AF.request(baseUrl + "users/setHandle", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                print(response)
                
                switch (response.result) {
                case .success:
                    if let result = response.value {
                        let JSON = result as! NSDictionary
                        print(JSON)
    
                        switch JSON["resultCode"]! as! Int {
                        case 150:
                            self.performSegue(withIdentifier: "signedUp", sender: self)
                            break
                            
                        default:
                            self.continueButton.loadingIndicator(false, "Continue")
                            showAlert(title: "Oops...", message: JSON["message"]! as! String, view: self)
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.continueButton.loadingIndicator(false, "Continue")
                    showAlert(title: "Oops...", message: "There was a server error.", view: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.setBottomBorder()
        continueButton.applyDesign()
        
        nameTextField.delegate = self
    }
}

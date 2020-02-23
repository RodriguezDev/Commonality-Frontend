//
//  NameSelectViewController.swift
//  Commonality
//
//  Created by Chris Rodriguez on 12/16/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

class NameSelectViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBAction func continueTapped(_ sender: Any) {
        
        if let nameText = nameTextField.text?.trim(), !nameText.isEmpty {
        
            self.continueButton.loadingIndicator(true, "");
            
            let params = ["field": nameText] as Dictionary<String, String>
            
            postRequest(url: baseUrl + "users/setHandle", params: params) { (d: Dictionary<String, AnyObject>) in
                if (d["resultCode"]! as! Int == 150) {
                    DispatchQueue.main.async() {
                        self.performSegue(withIdentifier: "signedUp", sender: self)
                    }
                } else {
                    DispatchQueue.main.async() {
                        self.continueButton.loadingIndicator(false, "Continue")
                        showAlert(title: "Oops...", message: d["message"]! as! String, view: self)
                    }
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

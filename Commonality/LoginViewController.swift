//
//  LoginViewController.swift
//  Commonality
//
//  Created by Chris Rodriguez on 12/16/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginTapped(_ sender: Any) {
        attemptLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // Apply styles to buttons and fields.
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        loginButton.applyDesign()
        passwordTextField.returnKeyType = UIReturnKeyType.go
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // If the user taps enter, attempt login and resign keyboard.
        textField.resignFirstResponder()
        attemptLogin()
        return true
    }

    func attemptLogin() {
        // Only send request if there's something in the text fields.
        if let emailText = emailTextField.text, !emailText.isEmpty, let passText = passwordTextField.text, !passText.isEmpty {
            
            self.loginButton.loadingIndicator(true, "");
            
            let parameters = ["email": emailText.trim(), "password": passText] as Dictionary<String, String>
            let headers: HTTPHeaders = ["Content-Type": "application/json"]

            // Send the request up. Woo.
            AF.request(baseUrl + "users/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                print(response)
                
                switch (response.result) {
                case .success:
                    if let result = response.value {
                        let JSON = result as! NSDictionary
                        print(JSON)
    
                        switch JSON["resultCode"]! as! Int {
                        case 120:
                            // Save the credentials for future authentication, and then segue.
                            let defaults = UserDefaults.standard
                            defaults.set(JSON["sessionID"] as! String, forKey: defaultsKeys.sessionID)
                            defaults.set(emailText.trim(), forKey: defaultsKeys.userEmail)
                            
                            self.performSegue(withIdentifier: "loggedIn", sender: self)
                            break
                            
                        default:
                            self.loginButton.loadingIndicator(false, "Login")
                            showAlert(title: "Oops...", message: JSON["message"] as! String, view: self)
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.loginButton.loadingIndicator(false, "Login")
                    showAlert(title: "Oops...", message: "There was a server error.", view: self)
                }
            }
        } else {
            // One of the fields is empty.
            self.loginButton.loadingIndicator(false, "Login")
            showAlert(title: "Oops...", message: "Please fill out all fields.", view: self)
        }
    }
}

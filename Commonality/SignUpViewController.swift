//
//  SignUpViewController.swift
//  Commonality
//
//  Created by Chris Rodriguez on 12/16/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstPasswordTextField: UITextField!
    @IBOutlet weak var secondPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpTapped(_ sender: Any) {
        attemptSignUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.delegate = self
        self.firstPasswordTextField.delegate = self
        self.secondPasswordTextField.delegate = self
        
        // Apply styles to buttons and fields.
        emailTextField.setBottomBorder()
        firstPasswordTextField.setBottomBorder()
        secondPasswordTextField.setBottomBorder()
        signUpButton.applyDesign()
        secondPasswordTextField.returnKeyType = UIReturnKeyType.go
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // If the user taps enter, attempt login and resign keyboard.
        textField.resignFirstResponder()
        attemptSignUp()
        return true
    }

    func attemptSignUp() {
        // Only send request if there's something in the text fields.
        if let emailText = emailTextField.text, !emailText.isEmpty, let firstPass = firstPasswordTextField.text, !firstPass.isEmpty,
            let secondPass = secondPasswordTextField.text, !secondPass.isEmpty {
            
            // But first check that the two entered passwords are the same.
            if (secondPass != firstPass) {
                showAlert(title: "Oops...", message: "Passwords don't match.", view: self)
                return
            }
            
            // Attempt the sign up.
            self.signUpButton.loadingIndicator(true, "");
            let parameters = ["email": emailText.trim(), "password": firstPass] as Dictionary<String, String>
            let headers: HTTPHeaders = ["Content-Type": "application/json"]

            // Send the request up. Woo.
            AF.request(baseUrl + "users/register", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                print(response)
                
                switch (response.result) {
                case .success:
                    if let result = response.value {
                        let JSON = result as! NSDictionary
                        print(JSON)
    
                        switch JSON["resultCode"]! as! Int {
                        case 110:
                            // Save the credentials for future authentication, and then segue.
                            let defaults = UserDefaults.standard
                            defaults.set(JSON["sessionID"] as! String, forKey: defaultsKeys.sessionID)
                            defaults.set(emailText.trim(), forKey: defaultsKeys.userEmail)
                            
                            self.performSegue(withIdentifier: "toUsernameSelection", sender: self)
                            break
                            
                        default:
                            self.signUpButton.loadingIndicator(false, "Sign Up")
                            showAlert(title: "Oops...", message: JSON["message"] as! String, view: self)
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.signUpButton.loadingIndicator(false, "Sign Up")
                    showAlert(title: "Oops...", message: "There was a server error.", view: self)
                }
            }
        } else {
            // One of the fields is empty.
            showAlert(title: "Oops...", message: "Please fill out all fields.", view: self)
        }
    }
}

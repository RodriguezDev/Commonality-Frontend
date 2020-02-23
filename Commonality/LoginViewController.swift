//
//  LoginViewController.swift
//  Commonality
//
//  Created by Chris Rodriguez on 12/16/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

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
        if let usernameText = emailTextField.text, !usernameText.isEmpty, let passText = passwordTextField.text, !passText.isEmpty {
            
            self.loginButton.loadingIndicator(true, "");
            
            let params = ["email": usernameText.trim(), "password": passText] as Dictionary<String, String>

            var request = URLRequest(url: URL(string: baseUrl + "users/login")!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    var json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    json["email"] = usernameText as AnyObject
                    
                    let statusCode = json["resultCode"] as! Int
                    switch statusCode {
                    case 120:
                        self.completion(json: json)
                        break
                    default:
                        break;
                    }
                    self.errorHandler(message: json["message"] as! String)
                } catch {
                    self.errorHandler(message: "Unable to connect to server.")
                    print("Error parsing JSON")
                }
            })

            task.resume()
        } else {
            // One of the fields is empty.
            showAlert(title: "Oops...", message: "Please fill out all fields.", view: self)
        }
    }
    
    func completion(json: Dictionary<String, AnyObject>) {
        DispatchQueue.main.async(){
            // Save the credentials for future authentication.
            let defaults = UserDefaults.standard
            defaults.set(json["sessionID"] as! String, forKey: defaultsKeys.sessionID)
            defaults.set(json["email"] as! String, forKey: defaultsKeys.userEmail)
            
            self.performSegue(withIdentifier: "loggedIn", sender: self)
        }
    }
    
    func errorHandler(message: String) {
        DispatchQueue.main.async(){
            self.loginButton.loadingIndicator(false, "Login")
            showAlert(title: "Oops...", message: message, view: self)
        }
    }
}

//
//  SignUpViewController.swift
//  Commonality
//
//  Created by Chris Rodriguez on 12/16/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import UIKit

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
            let params = ["email": emailText.trim(), "password": firstPass] as Dictionary<String, String>

            var request = URLRequest(url: URL(string: baseUrl + "users/register")!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    let statusCode = json["resultCode"] as! Int
                    switch statusCode {
                    case 110:
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
    
    // If successful signup.
    func completion(json: Dictionary<String, AnyObject>) {
        DispatchQueue.main.async(){
           self.performSegue(withIdentifier: "toUsernameSelection", sender: self)
        }
    }
    
    // If signup is unsuccessful.
    func errorHandler(message: String) {
        DispatchQueue.main.async(){
            self.signUpButton.loadingIndicator(false,  "Sign Up")
            showAlert(title: "Oops...", message: message, view: self)
        }
    }
}

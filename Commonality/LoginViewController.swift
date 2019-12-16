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
        
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        loginButton.applyDesign()
    }

    func attemptLogin() {
        let params = ["email":"chrismail627@gmail.com", "password":"Cr113097!"] as Dictionary<String, String>

        var request = URLRequest(url: URL(string: "http://192.168.1.195:3313/twitter/api/users/login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                let statusCode = json["resultCode"] as! Int
                switch statusCode {
                case 120:
                    self.completion(json: json)
                    break
                default:
                    break;
                }
            } catch {
                print("error")
            }
        })

        task.resume()
    }
    
    func completion(json: Dictionary<String, AnyObject>) {
        DispatchQueue.main.async(){
           self.performSegue(withIdentifier: "loggedIn", sender: self)
        }
    }
}

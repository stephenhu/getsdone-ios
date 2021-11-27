//
//  SignupController.swift
//  getsdone-ios
//
//  Created by hu on 6/28/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class SignupController: UIViewController, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    
    // MARK: Properties
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //email.becomeFirstResponder()

        email.delegate = self
        password.delegate = self
        username.delegate = self
        
        self.view.bringSubview(toFront: progress)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == email {
            password.becomeFirstResponder()
        } else if textField == password {
            username.becomeFirstResponder()
        } else if textField == username {
            signup(self)
        } else {
            email.becomeFirstResponder()
        }
        
        //password.resignFirstResponder()
        
        //signup(self)
        
        return true
        
    }

    
    // MARK: Actions
    
    @IBAction func singleTap(_ sender: Any) {
        
        email.resignFirstResponder()
        password.resignFirstResponder()
        username.resignFirstResponder()
        
    }
    
    @IBAction func signup(_ sender: Any) {
        
        if email.text!.isEmpty || password.text!.isEmpty || username.text!.isEmpty {
        
            let ac = UIAlertController(title: "Signup error",
                                       message: "Email, password, and username cannot be empty.",
                                       preferredStyle: UIAlertControllerStyle.alert)
            
            let OK = UIAlertAction(title: "OK",
                                   style: UIAlertActionStyle.default,
                                   handler: nil)
            
            ac.addAction(OK)
            
            self.present(ac, animated: true, completion: nil)
            
            return
            
        }
        
        if password.text!.count < 8 {
            
            let ac = UIAlertController(title: "Signup error",
                                       message: "Password must be at least 7 characters",
                                       preferredStyle: UIAlertControllerStyle.alert)
            
            let OK = UIAlertAction(title: "OK",
                                   style: UIAlertActionStyle.default,
                                   handler: nil)
            
            ac.addAction(OK)
            
            self.present(ac, animated: true, completion: nil)
            
            return
            
        }
        
        progress.startAnimating()
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)"
        
        Alamofire.request(url, method: .post,
                          parameters: ["email": email.text!,
                                       "password": password.text!,
                                       "name": username.text!])
            .response{ response in
                
                self.progress.stopAnimating()
                
                if response.error != nil {
                    
                    let ac = UIAlertController(title: "Connection error",
                                               message: response.error?.localizedDescription,
                                               preferredStyle: UIAlertControllerStyle.alert)
                    
                    let OK = UIAlertAction(title: "OK",
                                           style: UIAlertActionStyle.default,
                                           handler: nil)
                    
                    ac.addAction(OK)
                    
                    self.present(ac, animated: true, completion: nil)
                    
                    
                } else if let status = response.response?.statusCode {
                    
                    if status == 200 {
                        
                        self.defaults.removeObject(forKey: Getsdone.COOKIE)
                        
                        if let cookies = HTTPCookieStorage.shared.cookies {
                            
                            var dict = [String: AnyObject]()
                            
                            dict["cookie"] = cookies[0].properties as? AnyObject
                            
                            print(dict["cookie"])
                            
                            self.defaults.set(dict, forKey: Getsdone.COOKIE)
                            
                            self.performSegue(withIdentifier: "homeSegue", sender: self)
                            
                        } else {
                            
                            let ac = UIAlertController(title: "Session error",
                                                       message: "Please try signing up again.    ",
                                                       preferredStyle: UIAlertControllerStyle.alert)
                            
                            let OK = UIAlertAction(title: "OK",
                                                   style: UIAlertActionStyle.default,
                                                   handler: nil)
                            
                            ac.addAction(OK)
                            
                            self.present(ac, animated: true, completion: nil)
                            
                        }
                        
                        
                        
                    } else {
                        
                        let ac = UIAlertController(title: "Signup error",
                                                   message: "Unable to sign up, email and username must be unique.",
                                                   preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OK = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default,
                                               handler: nil)
                        
                        ac.addAction(OK)
                        
                        self.present(ac, animated: true, completion: nil)
                        
                    }
                    
                }
                
        }
        
    } // signup
    
    
} // SignupController

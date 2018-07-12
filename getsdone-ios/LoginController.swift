//
//  LoginController.swift
//  getsdone-ios
//
//  Created by hu on 6/28/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire

class LoginController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    // MARK: Properties
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        checkToken()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.becomeFirstResponder()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkToken() {
        
        if let properties = defaults.object(forKey: Getsdone.COOKIE) as? [String: Any] {

            print("slut")
            print(properties)
            
            let c = HTTPCookie(properties: properties["cookie"] as! [HTTPCookiePropertyKey: Any])
            
            HTTPCookieStorage.shared.setCookie(c!)
            
            self.performSegue(withIdentifier: "homeSegue", sender: self)
            
        } else {
            
        }
        
    }
    
    
    func login() {
    
        let url = "\(Getsdone.HTTP)\(Getsdone.AUTH_ENDPOINT)"
        
        Alamofire.request(url, method: .put, parameters:
            ["email": email.text!, "password": password.text!])
            .response{ response in
                
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
                        
                        if let cookies = HTTPCookieStorage.shared.cookies {
                            
                            var dict = [String: AnyObject]()
                            
                            dict["cookie"] = cookies[0].properties as? AnyObject
                            
                            self.defaults.set(dict, forKey: Getsdone.COOKIE)
                         
                            self.performSegue(withIdentifier: "homeSegue",
                                              sender: self)
                            
                        } else {
                            
                            let ac = UIAlertController(title: "Session error",
                                                       message: "Token not received from server, please login again.",
                                                       preferredStyle: UIAlertControllerStyle.alert)
                            
                            let OK = UIAlertAction(title: "OK",
                                                   style: UIAlertActionStyle.default,
                                                   handler: nil)
                            
                            ac.addAction(OK)
                            
                            self.present(ac, animated: true, completion: nil)
                            
                        }
                        
                        
/*                        if let token = HTTPCookieStorage.shared.cookies?[0] {

                            print(token.value)
                            
                            if !(token.value.isEmpty) {
                            
                                self.defaults.set(
                                    token.value, forKey: Getsdone.TOKEN)
                                
                                self.performSegue(withIdentifier: "homeSegue", sender: self)

                            } 
                            
                        }
  */
                    } else {

                        let ac = UIAlertController(title: "Login error",
                                                   message: "Invalid login credentials, please try again.",
                                                   preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OK = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default,
                                               handler: nil)
                        
                        ac.addAction(OK)
                        
                        self.present(ac, animated: true, completion: nil)

                    }
                    
                }
        }
        
        
    } // login
    
    // MARK: Actions
    @IBAction func loginClicked(_ sender: Any) {
    
        if !(email.text!.isEmpty) && !(password.text!.isEmpty) {
            login()
        } else {
            
            let ac = UIAlertController(title: "Login error",
                                       message: "Email and password cannot be empty.",
                                       preferredStyle: UIAlertControllerStyle.alert)
            
            let OK = UIAlertAction(title: "OK",
                                   style: UIAlertActionStyle.default,
                                   handler: nil)
            
            ac.addAction(OK)
            
            self.present(ac, animated: true, completion: nil)
            
        }
        
    } // loginClicked
    
} // LoginController

//
//  AddContactController.swift
//  getsdone-ios
//
//  Created by hu on 8/26/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire
import Font_Awesome_Swift
import SwiftyJSON

class AddContactController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var uid = String()
    
    // MARK: Properties
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: progress)
        
        email.becomeFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadUserInfo() {
        
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)"
        
        progress.startAnimating()
        
        Alamofire.request(url, method: .get)
            .responseJSON{ response in
                
                self.progress.stopAnimating()
                
                switch response.result {
                case .failure(let error):
                    
                    if response.response?.statusCode == 401 {
                        
                        self.defaults.removeObject(forKey: Getsdone.COOKIE)
                        
                        self.performSegue(withIdentifier: "startSegue", sender: nil)
                        
                    } else {
                        
                        let ac = UIAlertController(title: "Connection error",
                                                   message: error.localizedDescription,
                                                   preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OK = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default,
                                               handler: nil)
                        
                        ac.addAction(OK)
                        
                        self.present(ac, animated: true, completion: nil)
                        
                    }
                    
                    
                case .success:
                    
                    if let status = response.response?.statusCode {
                        
                        print(status)
                        
                        // TODO: revert to get started page if token invalid
                        
                        if status == 200 {
                            
                            if let raw = response.result.value {
                                
                                let j = JSON(raw)
                                
                                print(j)
                                self.uid    = j["id"].string!
                                
                                self.addContactAPI()
                                
                            } else {
                                print(status)
                                print(response.result)
                            }
                            
                        } else {
                            self.performSegue(withIdentifier: "startSegue", sender: nil)
                        }
                        
                    } else {
                        print(response.response)
                    }
                    
                    
                }
                
        }
        
    } // loadUserInfo
    
    func addContactAPI() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_CONTACTS)"
        
        print(url)
        progress.startAnimating()
        
        Alamofire.request(url, method: .post, parameters: ["email": email.text!])
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
                        
                        self.performSegue(withIdentifier: "backSegue", sender: nil)
                        
                    } else if status == 404 {
                        
                        let ac = UIAlertController(title: "Add contact error",
                                                   message: "User not found.",
                                                   preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OK = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default,
                                               handler: nil)
                        
                        ac.addAction(OK)
                        
                        self.present(ac, animated: true, completion: nil)
                        
                    } else if status == 500 {
                        
                        let ac = UIAlertController(title: "Add contact error",
                                                   message: "Contact already exists or has been requested.",
                                                   preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OK = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default,
                                               handler: nil)
                        
                        ac.addAction(OK)
                        
                        self.present(ac, animated: true, completion: nil)
                        
                        
                    } else {
                        
                        let ac = UIAlertController(title: "Add contact error",
                                                   message: response.error?.localizedDescription,
                                                   preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OK = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default,
                                               handler: nil)
                        
                        ac.addAction(OK)
                        
                        self.present(ac, animated: true, completion: nil)
                        
                    }
                    
                }
                
        }
        
    } // addContactAPI
    
    // MARK: Actions
    
    @IBAction func addContact(_ sender: Any) {
        
        if email.text!.isEmpty {
            
            let ac = UIAlertController(title: "Add contact error",
                                       message: "Email cannot be empty",
                                       preferredStyle: UIAlertControllerStyle.alert)
            
            let OK = UIAlertAction(title: "OK",
                                   style: UIAlertActionStyle.default,
                                   handler: nil)
            
            ac.addAction(OK)
            
            self.present(ac, animated: true, completion: nil)
            
        } else {
            
            loadUserInfo()
            
        }
        
    }
    
} // AddContactController

//
//  ProfileController.swift
//  getsdone-ios
//
//  Created by hu on 6/28/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire

class ProfileController: UIViewController {
    
    let defaults = UserDefaults.standard
    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    @IBAction func logout(_ sender: Any) {
        
        let url = "\(Getsdone.HTTP)\(Getsdone.AUTH_ENDPOINT)"
        
        Alamofire.request(url, method: .delete)
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
                        
                        self.defaults.removeObject(forKey: Getsdone.TOKEN)
                        
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                        
                    } else {
                        
                        let ac = UIAlertController(title: "Logout error",
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
        
    }
    
} // ProfileController

//
//  AboutController.swift
//  getsdone-ios
//
//  Created by hu on 8/26/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire
import Font_Awesome_Swift
import SwiftyJSON

class AboutController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    // MARK: Properties
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var logoutBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoutBarBtn.setFAIcon(icon: FAType.FASignOut, iconSize: 24)
        
        self.view.bringSubview(toFront: progress)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    @IBAction func logout(_ sender: Any) {
        
        let url = "\(Getsdone.AUTH_ENDPOINT)"
        
        self.progress.startAnimating()
        
        Alamofire.request(url, method: .delete)
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
                        
                        self.performSegue(withIdentifier: "startSegue", sender: self)
                        
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
    
} // AboutController

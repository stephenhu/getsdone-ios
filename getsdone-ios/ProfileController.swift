//
//  ProfileController.swift
//  getsdone-ios
//
//  Created by hu on 6/28/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire
import Font_Awesome_Swift
import SwiftyJSON

class ProfileController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    // MARK: Properties
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var since: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        icon.setFAIconWithName(icon: FAType.FAUserO, textColor: UIColor.black)
     
        self.view.bringSubview(toFront: progress)
        
        loadUserInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadUserInfo() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)"
        
        self.progress.startAnimating()
        
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
                    
                    if let raw = response.result.value {
                        
                        let j = JSON(raw)
                        
                        print(j)
                        
                        self.name.text = "@\(j["name"].string!)"
                        self.status.text = j["rankName"].string!
                        self.since.text = Getsdone.toReadableDate(j["created"].string!)
                    
                        
                    }
                    
                }
        }
        
    } // loadUserInfo
    
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
    
} // ProfileController

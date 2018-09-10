//
//  TaskController.swift
//  getsdone-ios
//
//  Created by hu on 6/26/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire
import Font_Awesome_Swift
import SwiftyJSON

class TaskController: UIViewController, UITextViewDelegate {

    let defaults = UserDefaults.standard
    
    // MARK: Properties
    @IBOutlet weak var task: UITextView!
    @IBOutlet weak var createTaskBtn: UIBarButtonItem!
    @IBOutlet weak var commentBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        self.task.delegate = self
    
        task.becomeFirstResponder()
        
        self.view.bringSubview(toFront: progress)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {

        guard let keyboardFrame = notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
     
        let height: CGFloat
        if #available(iOS 11.0, *) {
            height = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            height = keyboardFrame.cgRectValue.height
        }
        
        commentBottomConstraint.constant = height
        
    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        commentBottomConstraint.constant = 0.0
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
                    
                    if let raw = response.result.value {
                        
                        let j = JSON(raw)
                        
                        print(j)
                        
                        let username = "@\(j["name"].string!)"
                        
                        if self.task.text!.contains(username) {
                            
                            let ac = UIAlertController(title: "Create task error",
                                                       message: "Cannot delegate task to oneself, please remove @\(j["name"].string!)",
                                preferredStyle: UIAlertControllerStyle.alert)
                            
                            let OK = UIAlertAction(title: "OK",
                                                   style: UIAlertActionStyle.default,
                                                   handler: nil)
                            
                            ac.addAction(OK)
                            
                            self.present(ac, animated: true, completion: nil)
                            
                        } else {
                            self.addTask(j["id"].string!)
                        }
                        
                    }
                    
                }
        }
        
    } // loadUserInfo
    
    func addTask(_ uid: String) {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)"

        progress.startAnimating()
        
        Alamofire.request(url, method: .post, parameters: ["task": task.text!])
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
                        self.performSegue(withIdentifier: "backSegue", sender: self)
                    } else if status == 409 {
                      
                        let ac = UIAlertController(title: "Create task error",
                                                   message: "All task delegates must be added to your contacts in order to create tasks for them",
                                                   preferredStyle: UIAlertControllerStyle.alert)
                        
                        let OK = UIAlertAction(title: "OK",
                                               style: UIAlertActionStyle.default,
                                               handler: nil)
                        
                        ac.addAction(OK)
                        
                        self.present(ac, animated: true, completion: nil)
                        
                    } else {
                        
                        let ac = UIAlertController(title: "Add task error",
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
        
    } // addTask
    
    
    // MARK: Properties
    @IBAction func createTask(_ sender: Any) {
        
        loadUserInfo()
        
    }
    
    
} // TaskController

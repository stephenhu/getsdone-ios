//
//  TaskCommentController.swift
//  getsdone-ios
//
//  Created by hu on 6/26/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire
import Font_Awesome_Swift
import Kingfisher
import SwiftyJSON

class TaskCommentController: UIViewController, UITableViewDelegate,
  UITableViewDataSource, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    
    let cellIdentifier = "cell"
    
    var uid = String()
    var tid = String()
    
    var commentCache = [[String]]()
    
    // MARK: Properties
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var ago: UILabel!
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var svBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        //icon.setFAIcon(icon: FAType.FAUser, iconSize: 48, forState: .normal)
        
        commentsTable.delegate = self
        commentsTable.dataSource = self
        
        commentsTable.rowHeight = 80
        
        tid = defaults.object(forKey: Getsdone.TID) as! String
        
        comment.delegate = self
        
        self.view.bringSubview(toFront: progress)
        
        loadUserInfo()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentCache.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = commentsTable.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath) as! CommentCell
        
        if commentCache[indexPath.item][4] != "" {
            
            let img = URL(string: "\(Getsdone.ROOT_ENDPOINT)/\(commentCache[indexPath.item][4])")

            cell.icon.kf.setImage(with: img)
            
        } else {
            //cell.icon.setFAIconWithName(icon: FAType.FAUser, textColor: .black)
            
            cell.icon.setFAIconWithName(icon: FAType.FAUser, textColor: .black, orientation: UIImageOrientation.up, backgroundColor: .clear, size: CGSize(width: 24, height: 24))
            
            
        }
        
        cell.comment.text = commentCache[indexPath.item][1]
        cell.name.text = "@\(commentCache[indexPath.item][0])"
        cell.ago.text = Getsdone.toAgo(commentCache[indexPath.item][2])
        
        return cell
        
    }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {
        
        guard let keyboardFrame = notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let height: CGFloat
        if #available(iOS 11.0, *) {
            height = keyboardFrame.cgRectValue.height + self.view.safeAreaInsets.bottom
        } else {
            
            height = keyboardFrame.cgRectValue.height
        }
        
        //var rect = self.view.frame
        
        //rect.size.height = rect.size.height - keyboardFrame.cgRectValue.height - 34
        svBottomConstraint.constant = height
        //tableBottomConstraint.constant = height

    }
    
    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        svBottomConstraint.constant = 40.0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        addComment(self)
        
        comment.resignFirstResponder()
        
        return true
        
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
                    
                    let status = response.response?.statusCode
                    
                    if let raw = response.result.value {
                        
                        let j = JSON(raw)
                        
                        print(j)
                        
                        self.uid = j["id"].string!
                        
                        self.loadTask()
                        
                    }
                    
                }
        }
        
    } // loadUserInfo
    
    
    func loadTask() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)/\(tid)"
        
        print(url)
        
        progress.startAnimating()
        
        Alamofire.request(url, method: .get)
            .responseJSON{ response in
        
                self.progress.stopAnimating()
                
                switch response.result {
                case .failure(let error):
                    
                    let ac = UIAlertController(title: "Connection error",
                                               message: error.localizedDescription,
                                               preferredStyle: UIAlertControllerStyle.alert)
                    
                    let OK = UIAlertAction(title: "OK",
                                           style: UIAlertActionStyle.default,
                                           handler: nil)
                    
                    ac.addAction(OK)
                    
                    self.present(ac, animated: true, completion: nil)
                    
                    
                case .success:
                    
                    if let raw = response.result.value {
                        
                        let j = JSON(raw)
                        
                        self.task.attributedText = Getsdone.highlights(j["task"].string!)
                        self.ago.text = Getsdone.toAgo(j["created"].string!)
                        self.username.text = "@\(j["ownerName"].string!)"
                        
                        if j["ownerIcon"]["Valid"].bool! {
                            
                            let img = URL(string: "\(Getsdone.ROOT_ENDPOINT)/\(j["ownerIcon"]["String"].string!)")
                            
                            self.icon.kf.setImage(with: img)
                            
                        } else {
                            self.icon.setFAIconWithName(icon: FAType.FAUser, textColor: .black)
                        }

                        
                        var list = [[String]]()
                        
                        for (_, com) in j["comments"] {
                            
                            var c = [String]()
                            
                            c.append(com["userName"].string!)
                            c.append(com["comment"].string!)
                            c.append(com["created"].string!)
                            c.append(com["id"].string!)
                            
                            if com["userIcon"]["Valid"].bool! {
                                c.append(com["userIcon"]["String"].string!)
                            } else {
                                c.append("")
                            }
                            
                            list.append(c)
                            
                        }
                        
                        self.commentCache = list
                        
                        self.commentsTable.reloadData()
                        
                    }
                }
        }
        
    } // loadTask
    
    // MARK: Properties
    
    @IBAction func addComment(_ sender: Any) {
    
        if comment.text!.isEmpty {
            
            let ac = UIAlertController(title: "Add Comment Error",
                                       message: "Comment must not be empty",
                                       preferredStyle: UIAlertControllerStyle.alert)
            
            let OK = UIAlertAction(title: "OK",
                                   style: UIAlertActionStyle.default,
                                   handler: nil)
            
            ac.addAction(OK)
            
            self.present(ac, animated: true, completion: nil)
            
        } else {
            
            let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)/\(tid)\(Getsdone.API_COMMENTS)"
            
            progress.startAnimating()
            
            Alamofire.request(url, method: .post, parameters: ["comment": comment.text!])
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
                            self.comment.text = ""
                            self.comment.resignFirstResponder()
                            self.loadTask()
                        } else {
                            
                            let ac = UIAlertController(title: "Add comment error",
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
        
    }
    
    
} // TaskCommentController

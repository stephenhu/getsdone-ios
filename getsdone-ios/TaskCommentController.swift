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
import SwiftyJSON

class TaskCommentController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    
    let cellIdentifier = "cell"
    
    var uid = String()
    var tid = String()
    
    var commentCache = [[String]]()
    
    // MARK: Properties
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var ago: UILabel!
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var commentBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        icon.setFAIcon(icon: FAType.FAGithubAlt, iconSize: 48, forState: .normal)
        
        //task.text = "Yi Dian Dian yong le duo lv cha, 5 fen tian, zhen buo ye, zhong bei, qu bing"
        //username.text = "@stephen"
        //ago.text = "12s"
        
        commentsTable.delegate = self
        commentsTable.dataSource = self
        
        commentsTable.rowHeight = 80
        
        comment.becomeFirstResponder()
        
        tid = defaults.object(forKey: Getsdone.TID) as! String
        
        loadUserInfo()
        
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
        
        cell.icon.setFAIcon(icon: FAType.FAGithub, iconSize: 24, forState: .normal)
        cell.comment.text = commentCache[indexPath.item][1]
        cell.name.text = "@\(commentCache[indexPath.item][0])"
        cell.ago.text = Getsdone.toAgo(commentCache[indexPath.item][2])
        
        return cell
        
    }

    
    func loadUserInfo() {
        
        let url = "\(Getsdone.HTTP)\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)"
        
        Alamofire.request(url, method: .get)
            .responseJSON{ response in
                
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
        
        let url = "\(Getsdone.HTTP)\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)/\(tid)"
        
        print(url)
        
        Alamofire.request(url, method: .get)
            .responseJSON{ response in
                
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
                        
                        print(j)
                        
                        self.task.text = j["task"].string!
                        self.ago.text = Getsdone.toAgo(j["created"].string!)
                        self.username.text = "@\(j["ownerName"].string!)"
                        
                        var list = [[String]]()
                        
                        for (_, com) in j["comments"] {
                            
                            var c = [String]()
                            
                            c.append(com["userName"].string!)
                            c.append(com["comment"].string!)
                            c.append(com["created"].string!)
                            c.append(com["id"].string!)
                            
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
            
            let url = "\(Getsdone.HTTP)\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)/\(tid)/comments"
            
            Alamofire.request(url, method: .post, parameters: ["comment": comment.text!])
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

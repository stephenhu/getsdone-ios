//
//  HomeController.swift
//  getsdone-ios
//
//  Created by hu on 6/24/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Alamofire
import Font_Awesome_Swift
import SwiftyJSON

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "cell"
    
    let defaults = UserDefaults.standard
    
    var tasks = [[String]]()
    
    var assigned = [[String]]()
    
    var completed = [[String]]()
    
    var deferred = [[String]]()
    
    var uid     = String()
    var name    = String()

    
    // MARK: Properties
    @IBOutlet weak var createTask: UIBarButtonItem!
    @IBOutlet weak var profile: UIBarButtonItem!
    @IBOutlet weak var tasksTable: UITableView!
    @IBOutlet weak var theView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTask.setFAIcon(icon: FAType.FAEdit, iconSize: 24)
        profile.setFAIcon(icon: FAType.FAMehO, iconSize: 24)
        
        self.tasksTable.dataSource = self
        self.tasksTable.delegate = self
        
        self.tasksTable.rowHeight = 120
        
        loadUserInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if theView.selectedSegmentIndex == 1 {
            return assigned.count
        } else if theView.selectedSegmentIndex == 2 {
            return completed.count
        } else if theView.selectedSegmentIndex == 3 {
            return deferred.count
        } else {
            return tasks.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tasksTable.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath) as! TaskViewCell
        
        cell.owner.setFAIcon(icon: FAType.FAFacebookSquare, iconSize: 48, forState: .normal)
        cell.owner.setTitleColor(UIColor.black, for: .normal)
        //cell.comments.setFAIcon(icon: FAType.FACommentO, forState: .normal)
        
        
        var data = [[String]]()
        
        if theView.selectedSegmentIndex == 0 {
            data = tasks
        } else if theView.selectedSegmentIndex == 1 {
            data = assigned
        } else if theView.selectedSegmentIndex == 2 {
            data = completed
        } else if theView.selectedSegmentIndex == 3 {
            data = deferred
        }
        
        cell.comments.setFAText(prefixText: "", icon: FAType.FACommentO, postfixText: " \(data[indexPath.item][3])", size: 12, iconSize: 12)
        cell.user.text = "@\(data[indexPath.item][0])"
        
        cell.task.text = data[indexPath.item][1]
        
        cell.ago.text = Getsdone.toAgo(data[indexPath.item][2])
        cell.ago.setFAColor(color: Getsdone.TealColor)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var data = [[String]]()
        
        if theView.selectedSegmentIndex == 0 {
            data = tasks
        } else if theView.selectedSegmentIndex == 1 {
            data = assigned
        } else if theView.selectedSegmentIndex == 2 {
            data = completed
        } else if theView.selectedSegmentIndex == 3 {
            data = deferred
        }
        
        defaults.set(data[indexPath.item][4], forKey: Getsdone.TID)
        
        self.performSegue(withIdentifier: "showTask", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if theView.selectedSegmentIndex == 0 {
            
        
            let deferAction = UITableViewRowAction(style: .normal, title: "Defer")
            { (rowAction, indexPath) in
                
            }
            
            deferAction.backgroundColor = Getsdone.BlueColor
            
            let completeAction = UITableViewRowAction(style: .normal, title: "Complete")
            { (rowAction, indexPath) in
                
                self.completeTask(indexPath)
                
            }
            
            completeAction.backgroundColor = Getsdone.GreenColor

            let cloneAction = UITableViewRowAction(style: .normal, title: "Clone")
            { (rowAction, indexPath) in
                
            }
            
            cloneAction.backgroundColor = UIColor.red
            
            return [completeAction, deferAction, cloneAction]
            
        
        } else if theView.selectedSegmentIndex == 3 {

            let undeferAction = UITableViewRowAction(style: .normal, title: "Undefer")
            { (rowAction, indexPath) in
                
            }
            
            undeferAction.backgroundColor = Getsdone.BlueColor
    
            return [undeferAction]
            
            
        } else {
            return []
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func completeTask(_ row: IndexPath) {
        
        let url = "\(Getsdone.HTTP)\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)/\(tasks[row.item][4])"
        
        Alamofire.request(url, method: .put)
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
                        
                        self.loadOpenTasks()
                        
                    } else {
                        
                        let ac = UIAlertController(title: "Complete task error",
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
        
    } // completeTask
    
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
                        self.uid    = j["id"].string!
                        self.name   = j["name"].string!
                        
                        self.loadOpenTasks()
                        
                    }

                }
        }
        
    } // loadUserInfo
    
    
    func loadOpenTasks() {
        
        let url = "\(Getsdone.HTTP)\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)"
        
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
                        
                        var all = [[String]]()
                        
                        for (_, task) in j {
                        
                            var t = [String]()

                            print(task)
                            
                            t.append(task["ownerName"].string!)
                            t.append(task["task"].string!)
                            t.append(task["created"].string!)
                            
                            let count = task["comments"].array!.count
                            
                            t.append(String(count)) // comments
                            t.append(task["id"].string!)
                            
                            if task["delegateId"]["Valid"].bool! {
                                t.append(task["delegateId"]["String"].string!)
                            } else {
                                t.append("")
                            }
                        
                            all.append(t)
                            
                        }
                        
                        self.tasks = all
                        
                        self.tasksTable.reloadData()
                        
                    }
                }
        }
        
    } // loadOpenTasks
    
    
    func loadOpenAssignedTasks() {
        
        let url = "\(Getsdone.HTTP)\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)"
        
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
                        
                        var all = [[String]]()
                        
                        for (_, task) in j {
                            
                            if task["delegateId"]["Valid"].bool! {

                                var t = [String]()

                                t.append(task["ownerName"].string!)
                                t.append(task["task"].string!)
                                t.append(task["created"].string!)
                                
                                let count = task["comments"].array!.count
                                
                                t.append(String(count)) // comments
                                t.append(task["id"].string!)
                                t.append(task["delegateId"]["String"].string!)
                                
                                all.append(t)

                            }
                            
                        }
                        
                        self.assigned = all
                        
                        self.tasksTable.reloadData()
                        
                    }
                }
        }
        
    } // loadOpenAssignedTasks
    
    
    func loadCompletedTasks() {
        
        let url = "\(Getsdone.HTTP)\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)"
        
        print(url)
        
        Alamofire.request(url, method: .get, parameters: ["view": "completed"])
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
                        
                        var all = [[String]]()
                        
                        for (_, task) in j {
                            
                            var t = [String]()
                            
                            print(task)
                            t.append(task["ownerName"].string!)
                            t.append(task["task"].string!)
                            t.append(task["created"].string!)
                            
                            let count = task["comments"].array!.count
                            
                            t.append(String(count)) // comments
                            t.append(task["id"].string!)
                            t.append(task["delegateId"]["String"].string!)
                                
                            all.append(t)
                            
                        }
                        
                        self.completed = all
                        
                        self.tasksTable.reloadData()
                        
                    }
                }
        }
        
    } // loadCompletedTasks
    
    
    func loadDeferredTasks() {
        
        let url = "\(Getsdone.HTTP)\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)"
        
        print(url)
        
        Alamofire.request(url, method: .get, parameters: ["view": "deferred"])
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
                        
                        var all = [[String]]()
                        
                        for (_, task) in j {
                            
                            var t = [String]()
                            
                            t.append(task["ownerName"].string!)
                            t.append(task["task"].string!)
                            t.append(task["created"].string!)
                            
                            let count = task["comments"].array!.count
                            
                            t.append(String(count)) // comments
                            t.append(task["id"].string!)
                            t.append(task["delegateId"]["String"].string!)
                            
                            all.append(t)
                            
                        }
                        
                        self.deferred = all
                        
                        self.tasksTable.reloadData()
                        
                    }
                }
        }
        
    } // loadDeferredTasks
    
    
    // MARK: Actions
    
    @IBAction func changeView(_ sender: Any) {
        
        if theView.selectedSegmentIndex == 0 {
            loadOpenTasks()
        } else if theView.selectedSegmentIndex == 1 {
            loadOpenAssignedTasks()
        } else if theView.selectedSegmentIndex == 2 {
            loadCompletedTasks()
        } else if theView.selectedSegmentIndex == 3 {
            loadDeferredTasks()
        }
        
    }
    
    
} // HomeController

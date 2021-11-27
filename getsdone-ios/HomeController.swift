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
import Kingfisher
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

    var selectedView = 0
    var ascending = 0
    
    // MARK: Properties
    @IBOutlet weak var createTask: UIBarButtonItem!
    //@IBOutlet weak var profile: UIBarButtonItem!
    @IBOutlet weak var tasksTable: UITableView!
    @IBOutlet weak var settings: UIBarButtonItem!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var viewName: UILabel!
    @IBOutlet weak var notasks: UILabel!
    @IBOutlet weak var taskCount: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadUserInfo()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTask.setFAIcon(icon: FAType.FAEdit, iconSize: 24)
        
        settings.setFAIcon(icon: FAType.FASliders, iconSize: 24)
        
        //notasks.setFAIcon(icon: FAType.FAOptinMonster, iconSize: 72)
        notasks.setFAText(prefixText: "",
                          icon: FAType.FAOptinMonster, postfixText: "No tasks found.", size: 18, iconSize: 72)
        
        self.tasksTable.dataSource = self
        self.tasksTable.delegate = self
        
        self.tasksTable.rowHeight = 120
        
        notasks.setFAColor(color: .clear)
        
        self.view.bringSubview(toFront: notasks)
        self.view.bringSubview(toFront: progress)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedView == 1 {
            return assigned.count
        } else if selectedView == 2 {
            return completed.count
        } else if selectedView == 3 {
            return deferred.count
        } else {
            return tasks.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tasksTable.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath) as! TaskViewCell
        
        //cell.owner.setFAIcon(icon: FAType.FAUserO, iconSize: 48, forState: .normal)
        //cell.owner.setTitleColor(Getsdone.BlueColor, for: .normal)
        //cell.comments.setFAIcon(icon: FAType.FACommentO, forState: .normal)
        
        
        var data = [[String]]()
        
        if selectedView == 0 {
            data = tasks
        } else if selectedView == 1 {
            data = assigned
        } else if selectedView == 2 {
            data = completed
        } else if selectedView == 3 {
            data = deferred
        }
        
        cell.comments.setFAText(prefixText: "", icon: FAType.FACommentO, postfixText: " \(data[indexPath.item][3])", size: 12, iconSize: 12)
        cell.user.text = "@\(data[indexPath.item][0])"
        
        cell.task.attributedText = Getsdone.highlights(data[indexPath.item][1])
        
        cell.ago.text = Getsdone.toAgo(data[indexPath.item][2])
        cell.ago.setFAColor(color: Getsdone.TealColor)
        
        if data[indexPath.item][6] != "" {
            
            let img = URL(string: "\(Getsdone.ROOT_ENDPOINT)/\(data[indexPath.item][6])")
            
            cell.owner.kf.setImage(with: img)
            
        } else {
            cell.owner.setFAIconWithName(icon: FAType.FAUser, textColor: .black)
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var data = [[String]]()
        
        if selectedView == 0 {
            data = tasks
        } else if selectedView == 1 {
            data = assigned
        } else if selectedView == 2 {
            data = completed
        } else if selectedView == 3 {
            data = deferred
        }
        
        defaults.set(data[indexPath.item][4], forKey: Getsdone.TID)
        
        self.performSegue(withIdentifier: "showTask", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if selectedView == 0 {
            
        
            let deferAction = UITableViewRowAction(style: .normal, title: "Defer")
            { (rowAction, indexPath) in
                
                self.updateTask(indexPath, state: Getsdone.UPDATE_TASK_DEFERRED)
                
            }
            
            deferAction.backgroundColor = Getsdone.BlueColor
            
            let completeAction = UITableViewRowAction(style: .normal, title: "Complete")
            { (rowAction, indexPath) in
                
                self.updateTask(indexPath, state: Getsdone.UPDATE_TASK_COMPLETED)
                
            }
            
            completeAction.backgroundColor = Getsdone.GreenColor

            let cloneAction = UITableViewRowAction(style: .normal, title: "Clone")
            { (rowAction, indexPath) in
                
            }
            
            cloneAction.backgroundColor = UIColor.red
            
            return [completeAction, deferAction, cloneAction]
            
        
        } else if selectedView == 3 {

            let undeferAction = UITableViewRowAction(style: .normal, title: "Undefer")
            { (rowAction, indexPath) in
                
                self.updateTask(indexPath, state: Getsdone.UPDATE_TASK_UNDEFERRED)
                
            }
            
            undeferAction.backgroundColor = Getsdone.BlueColor
    
            return [undeferAction]
            
            
        } else {
            return []
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    
    func refresh() {
    
        selectedView = defaults.integer(forKey: Getsdone.DEFAULTS_VIEW)
        ascending = defaults.integer(forKey: Getsdone.DEFAULTS_SORT)
        
        if selectedView == 3 {
            
            viewName.text = "Deferred"
            loadDeferredTasks()
            
        } else if selectedView == 1 {
            
            viewName.text = "Delegated"
            loadOpenAssignedTasks()
            
        } else if selectedView == 2 {
            
            viewName.text = "Completed"
            loadCompletedTasks()
            
        } else {
            
            viewName.text = "Open"
            loadOpenTasks()
            
        }
        
    } // refresh
    
    
    func updateTask(_ row: IndexPath, state: String) {
        
        var taskType = [[String]]()
        
        if state == Getsdone.UPDATE_TASK_UNDEFERRED {
            
            if deferred[row.item][5] != uid {
                
                let ac = UIAlertController(title: "Update task error",
                                           message: "Only the delegate can defer this task.",
                                           preferredStyle: UIAlertControllerStyle.alert)
                
                let OK = UIAlertAction(title: "OK",
                                       style: UIAlertActionStyle.default,
                                       handler: nil)
                
                ac.addAction(OK)
                
                self.present(ac, animated: true, completion: nil)
                
                return
                
            }
            
            taskType = deferred
            
        } else {
            taskType = tasks
        }
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)/\(taskType[row.item][4])"
        
        progress.startAnimating()
        
        Alamofire.request(url, method: .put, parameters: ["action": state])
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
                        
                        if state == Getsdone.UPDATE_TASK_UNDEFERRED {
                            self.loadDeferredTasks()
                        } else {
                            self.loadOpenTasks()
                        }
                        
                    } else {
                        
                        let ac = UIAlertController(title: "Update task error",
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
        
    } // updateTask
    
    
    func loadUserInfo() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)"
        
        print(url)
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

                        //print(status)
                        
                        // TODO: revert to get started page if token invalid
                        
                        if status == 200 {

                            if let raw = response.result.value {
                                
                                let j = JSON(raw)
                                
                                //print(j)
                                self.uid    = j["id"].string!
                                self.name   = j["name"].string!
                                
                                self.refresh()
                                
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
    
    
    func loadOpenTasks() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)"
        
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
                        
                        var all = [[String]]()
                        
                        for (_, task) in j {
                        
                            var t = [String]()

                            //print(task)
                            
                            if task["delegateId"]["Valid"].bool! {
                                
                                if task["delegateId"]["String"].string! != self.uid {
                                    continue
                                }
                                
                            }
                            
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
                            
                            if task["ownerIcon"]["Valid"].bool! {
                                t.append(task["ownerIcon"]["String"].string!)
                            } else {
                                t.append("")
                            }
                        
                            all.append(t)
                            
                        }
                        
                        if self.ascending == 0 {
                            self.tasks = all.reversed()
                        } else {
                            self.tasks = all
                        }
                        
                        self.viewName.text = "Open"
                        self.taskCount.text = "\(self.tasks.count)"
                        
                        if self.tasks.count == 0 {
                            self.notasks.setFAColor(color: Getsdone.BlueColor)
                        } else {
                            self.notasks.setFAColor(color: .clear)
                        }
                        
                        self.tasksTable.reloadData()
                        
                    }
                }
        }
        
    } // loadOpenTasks
    
    
    func loadOpenAssignedTasks() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)"

        print(url)
        
        progress.startAnimating()
        
        Alamofire.request(url, method: .get, parameters: ["view": "assigned"])
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

                        var all = [[String]]()
                        
                        for (_, task) in j {
                            
                            if task["delegateId"]["Valid"].bool! {
                                
                                if task["delegateId"]["String"].string! == self.uid {
                                    continue
                                }
                                
                                var t = [String]()

                                t.append(task["ownerName"].string!)
                                t.append(task["task"].string!)
                                t.append(task["created"].string!)
                                
                                let count = task["comments"].array!.count
                                
                                t.append(String(count)) // comments
                                t.append(task["id"].string!)
                                t.append(task["delegateId"]["String"].string!)
                                
                                if task["ownerIcon"]["Valid"].bool! {
                                    t.append(task["ownerIcon"]["String"].string!)
                                } else {
                                    t.append("")
                                }
                                
                                all.append(t)

                            }
                            
                        }
                        
                        if self.ascending == 0 {
                            self.assigned = all.reversed()
                        } else {
                            self.assigned = all
                        }
                        
                        self.viewName.text = "Delegated"
                        self.taskCount.text = "\(self.assigned.count)"
                        
                        if self.assigned.count == 0 {
                            self.notasks.setFAColor(color: Getsdone.BlueColor)
                        } else {
                            self.notasks.setFAColor(color: .clear)
                        }
                        
                        self.tasksTable.reloadData()
                        
                    }
                }
        }
        
    } // loadOpenAssignedTasks
    
    
    func loadCompletedTasks() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)"

        print(url)
        
        progress.startAnimating()
        
        Alamofire.request(url, method: .get, parameters: ["view": "completed"])
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
                        
                        var all = [[String]]()
                        
                        for (_, task) in j {
                            
                            var t = [String]()
                            
                            //print(task)
                            t.append(task["ownerName"].string!)
                            t.append(task["task"].string!)
                            t.append(task["created"].string!)
                            
                            let count = task["comments"].array!.count
                            
                            t.append(String(count)) // comments
                            t.append(task["id"].string!)
                            t.append(task["delegateId"]["String"].string!)
                            
                            if task["ownerIcon"]["Valid"].bool! {
                                t.append(task["ownerIcon"]["String"].string!)
                            } else {
                                t.append("")
                            }
                            
                            all.append(t)
                            
                        }
                        
                        if self.ascending == 0 {
                            self.completed = all.reversed()
                        } else {
                            self.completed = all
                        }
                        
                        self.viewName.text = "Completed"
                        self.taskCount.text = "\(self.completed.count)"
                        
                        if self.completed.count == 0 {
                            self.notasks.setFAColor(color: Getsdone.BlueColor)
                        } else {
                            self.notasks.setFAColor(color: .clear)
                        }
                        
                        self.tasksTable.reloadData()
                        
                    }
                }
        }
        
    } // loadCompletedTasks
    
    
    func loadDeferredTasks() {
        
        let url = "\(Getsdone.API_ENDPOINT)\(Getsdone.API_USERS)/\(uid)\(Getsdone.API_TASKS)"

        print(url)
        
        progress.startAnimating()
        
        Alamofire.request(url, method: .get, parameters: ["view": "deferred"])
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
                            
                            if task["ownerIcon"]["Valid"].bool! {
                                t.append(task["ownerIcon"]["String"].string!)
                            } else {
                                t.append("")
                            }
                            
                            all.append(t)
                            
                        }
                        
                        if self.ascending == 0 {
                            self.deferred = all.reversed()
                        } else {
                            self.deferred = all
                        }
                        
                        self.viewName.text = "Deferred"
                        self.taskCount.text = "\(self.deferred.count)"
                        
                        if self.deferred.count == 0 {
                            self.notasks.setFAColor(color: Getsdone.BlueColor)
                        } else {
                            self.notasks.setFAColor(color: .clear)
                        }
                        
                        self.tasksTable.reloadData()
                        
                    }
                }
        }
        
    } // loadDeferredTasks
    
    
    // MARK: Actions
    
    @IBAction func unwindHome(segue: UIStoryboardSegue) {
        
    }
    
    
} // HomeController

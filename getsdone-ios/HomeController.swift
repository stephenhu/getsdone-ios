//
//  HomeController.swift
//  getsdone-ios
//
//  Created by hu on 6/24/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Font_Awesome_Swift

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "cell"
    
    var tasks = [["lebronjames", "buy milk", "1d", "5", "2"], ["masters", "get car fixed at mini cs store", "2h", "0", "2"], ["mj23", "get estimate for car damage and take photos at crime spot", "30s", "23", "2"]]
    
    var assigned = [["lebronjames", "take daughter to singing lessons", "4s", "11", "2"], ["morgan", "buy 6 tomatoes with celery", "2h", "3", "2"]]
    
    var closed = [["tedj", "eat breakfast with big el", "30d", "5", "2"]]
    
    var deferred = [["ransomware", "my balls itch ooh oh yeah!!", "27m", "2", "2"]]

    
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
        self.tasksTable.reloadData()
        
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
            return closed.count
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
            data = closed
        } else if theView.selectedSegmentIndex == 3 {
            data = deferred
        }
        
        cell.comments.setFAText(prefixText: "", icon: FAType.FACommentO, postfixText: " \(data[indexPath.item][3])", size: 12, iconSize: 12)
        cell.user.text = "@\(data[indexPath.item][0])"
        
        cell.task.text = data[indexPath.item][1]
        cell.ago.text = data[indexPath.item][2]
        cell.ago.setFAColor(color: Getsdone.TealColor)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    
    // MARK: Actions
    
    @IBAction func changeView(_ sender: Any) {
        tasksTable.reloadData()
    }
    
    
} // HomeController

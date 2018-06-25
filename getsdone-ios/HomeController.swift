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
    
    var tasks = [["buy milk", "1d"], ["get car fixed at mini cs store", "2h"], ["get estimate for car damage and take photos at crime spot", "30s"]]
    
    var assigned = [["take daughter to singing lessons", "4s"], ["buy 6 tomatoes with celery", "2h"]]
    
    var closed = [["eat breakfast with big el", "30d"]]
    
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
        
        self.tasksTable.rowHeight = 80
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
        } else {
            return tasks.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tasksTable.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath) as! TaskViewCell
        
        cell.owner.setFAIcon(icon: FAType.FAMehO, iconSize: 48, forState: .normal)
        //cell.comments.setFAIcon(icon: FAType.FACommentO, forState: .normal)
        //cell.comments.setFAText(prefixText: "", icon: FAType.FACommentO, postfixText: " 12", size: 12,
        //forState: .normal)
        
        var data = [[String]]()
        
        if theView.selectedSegmentIndex == 0 {
            data = tasks
        } else if theView.selectedSegmentIndex == 1 {
            data = assigned
        } else if theView.selectedSegmentIndex == 2 {
            data = closed
        }
        
        cell.comments.text = "\(data[indexPath.item][1]), 5 comments"
        cell.task.text = data[indexPath.item][0]

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    // MARK: Actions
    
    @IBAction func changeView(_ sender: Any) {
        tasksTable.reloadData()
    }
    
    
} // HomeController

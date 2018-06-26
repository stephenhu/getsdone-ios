//
//  TaskCommentController.swift
//  getsdone-ios
//
//  Created by hu on 6/26/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Font_Awesome_Swift

class TaskCommentController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "cell"
    
    var commentCache = [["hus", "what are you talking about?", "2s", "1"], ["slacker8", "i don't know dude", "now", "32"], ["thomasj", "here's a really long comment that needs to span a few lines hopefully, but i don't know, what's it look like?", "10m", "25"]]
    
    // MARK: Properties
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var task: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var ago: UILabel!
    @IBOutlet weak var commentsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        icon.setFAIcon(icon: FAType.FAGithubAlt, iconSize: 48, forState: .normal)
        
        task.text = "Yi Dian Dian yong le duo lv cha, 5 fen tian, zhen buo ye, zhong bei, qu bing"
        username.text = "@stephen"
        ago.text = "12s"
        
        commentsTable.delegate = self
        commentsTable.dataSource = self
        
        commentsTable.rowHeight = 80
        
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
        
        cell.icon.setFAIcon(icon: FAType.FAUmbrella, iconSize: 24, forState: .normal)
        cell.comment.text = commentCache[indexPath.item][1]
        cell.name.text = "@\(commentCache[indexPath.item][0])"
        cell.ago.text = commentCache[indexPath.item][2]
        
        return cell
        
    }
    
    // MARK: Properties
    
} // TaskCommentController

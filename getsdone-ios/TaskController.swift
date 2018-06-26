//
//  TaskController.swift
//  getsdone-ios
//
//  Created by hu on 6/26/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Font_Awesome_Swift

class TaskController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var createTaskBtn: UIBarButtonItem!
    @IBOutlet weak var task: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        task.becomeFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Properties
    @IBAction func createTask(_ sender: Any) {
    }
    
    
} // TaskController

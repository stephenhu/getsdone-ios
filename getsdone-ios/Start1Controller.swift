//
//  Start1Controller.swift
//  getsdone-ios
//
//  Created by hu on 7/26/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Font_Awesome_Swift

class Start1Controller: UIViewController {

    // MARK: Properties
    @IBOutlet weak var picture: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picture.setFAIcon(icon: FAType.FAList, iconSize: 128)
        picture.setFAColor(color: Getsdone.TealColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
} // Start1Controller

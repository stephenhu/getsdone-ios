//
//  TaskFilterController.swift
//  getsdone-ios
//
//  Created by hu on 9/14/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Font_Awesome_Swift

class TaskFilterController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    // MARK: Properties
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var delegatedBtn: UIButton!
    @IBOutlet weak var deferredBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    @IBOutlet weak var ascending: UISwitch!
    @IBOutlet weak var openLbl: UILabel!
    @IBOutlet weak var delegatedLbl: UILabel!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var deferredLbl: UILabel!
    @IBOutlet weak var viewStack: UIStackView!
    @IBOutlet weak var sortStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewStack.layer.borderColor = UIColor.blue.cgColor
        viewStack.layer.borderWidth = 2
        
        sortStack.layer.borderColor = UIColor.blue.cgColor
        sortStack.layer.borderWidth = 2
        
        let view = defaults.integer(forKey: Getsdone.DEFAULTS_VIEW)
        let sort = defaults.integer(forKey: Getsdone.DEFAULTS_SORT)
        
        openLbl.setFAIcon(icon: FAType.FACheck, iconSize: 16)
        delegatedLbl.setFAIcon(icon: FAType.FACheck, iconSize: 16)
        deferredLbl.setFAIcon(icon: FAType.FACheck, iconSize: 16)
        completedLbl.setFAIcon(icon: FAType.FACheck, iconSize: 16)

        if view == 1 {

            openLbl.setFAColor(color: .clear)
            delegatedLbl.setFAColor(color: Getsdone.TealColor)
            completedLbl.setFAColor(color: .clear)
            deferredLbl.setFAColor(color: .clear)
            
        } else if view == 2 {

            openLbl.setFAColor(color: .clear)
            delegatedLbl.setFAColor(color: .clear)
            completedLbl.setFAColor(color: Getsdone.TealColor)
            deferredLbl.setFAColor(color: .clear)

            
        } else if view == 3 {

            openLbl.setFAColor(color: .clear)
            delegatedLbl.setFAColor(color: .clear)
            completedLbl.setFAColor(color: .clear)
            deferredLbl.setFAColor(color: Getsdone.TealColor)

        } else {
            
            openLbl.setFAColor(color: Getsdone.TealColor)
            delegatedLbl.setFAColor(color: .clear)
            completedLbl.setFAColor(color: .clear)
            deferredLbl.setFAColor(color: .clear)
            
        }
        
        if sort == 1 {
            ascending.setOn(false, animated: true)
        } else {
            ascending.setOn(true, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    @IBAction func selectOpenView(_ sender: Any) {
        
        defaults.set(0, forKey: Getsdone.DEFAULTS_VIEW)
        
        openLbl.setFAColor(color: Getsdone.TealColor)
        delegatedLbl.setFAColor(color: .clear)
        completedLbl.setFAColor(color: .clear)
        deferredLbl.setFAColor(color: .clear)
    }
    
    @IBAction func selectDelegatedView(_ sender: Any) {

        defaults.set(1, forKey: Getsdone.DEFAULTS_VIEW)
        
        openLbl.setFAColor(color: .clear)
        delegatedLbl.setFAColor(color: Getsdone.TealColor)
        completedLbl.setFAColor(color: .clear)
        deferredLbl.setFAColor(color: .clear)

    }
    
    @IBAction func selectDeferredView(_ sender: Any) {

        defaults.set(3, forKey: Getsdone.DEFAULTS_VIEW)
        
        openLbl.setFAColor(color: .clear)
        delegatedLbl.setFAColor(color: .clear)
        completedLbl.setFAColor(color: .clear)
        deferredLbl.setFAColor(color: Getsdone.TealColor)

    }
    
    @IBAction func selectCompletedView(_ sender: Any) {

        defaults.set(2, forKey: Getsdone.DEFAULTS_VIEW)
        
        openLbl.setFAColor(color: .clear)
        delegatedLbl.setFAColor(color: .clear)
        completedLbl.setFAColor(color: Getsdone.TealColor)
        deferredLbl.setFAColor(color: .clear)

    }
    
    @IBAction func toggleAscending(_ sender: Any) {
        
        if ascending.isOn {
            defaults.set(0, forKey: Getsdone.DEFAULTS_SORT)
        } else {
            defaults.set(1, forKey: Getsdone.DEFAULTS_SORT)
        }
        
        
    }
    
} // TaskFilterController

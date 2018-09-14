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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = defaults.integer(forKey: Getsdone.DEFAULTS_VIEW)
        
        openBtn.setFAIcon(icon: FAType.FACheck, forState: .normal)
        delegatedBtn.setFAIcon(icon: FAType.FACheck, forState: .normal)
        deferredBtn.setFAIcon(icon: FAType.FACheck, forState: .normal)
        completedBtn.setFAIcon(icon: FAType.FACheck, forState: .normal)

        if view == 1 {

            openBtn.setFATitleColor(color: .clear)
            delegatedBtn.setFATitleColor(color: Getsdone.TealColor)
            deferredBtn.setFATitleColor(color: .clear)
            completedBtn.setFATitleColor(color: .clear)

        } else if view == 2 {

            openBtn.setFATitleColor(color: .clear)
            delegatedBtn.setFATitleColor(color: .clear)
            deferredBtn.setFATitleColor(color: .clear)
            completedBtn.setFATitleColor(color: Getsdone.TealColor)

            
        } else if view == 3 {

            openBtn.setFATitleColor(color: .clear)
            delegatedBtn.setFATitleColor(color: .clear)
            deferredBtn.setFATitleColor(color: Getsdone.TealColor)
            completedBtn.setFATitleColor(color: .clear)

        } else {
            
            openBtn.setFATitleColor(color: Getsdone.TealColor)
            delegatedBtn.setFATitleColor(color: .clear)
            deferredBtn.setFATitleColor(color: .clear)
            completedBtn.setFATitleColor(color: .clear)
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    @IBAction func selectOpenView(_ sender: Any) {
        
        defaults.set(0, forKey: Getsdone.DEFAULTS_VIEW)
        
        openBtn.setTitleColor(Getsdone.TealColor, for: .normal)
        delegatedBtn.setTitleColor(.clear, for: .normal)
        deferredBtn.setTitleColor(.clear, for: .normal)
        completedBtn.setTitleColor(.clear, for: .normal)
    }
    
    @IBAction func selectDelegatedView(_ sender: Any) {

        defaults.set(1, forKey: Getsdone.DEFAULTS_VIEW)
        
        openBtn.setTitleColor(.clear, for: .normal)
        delegatedBtn.setTitleColor(Getsdone.TealColor, for: .normal)
        deferredBtn.setTitleColor(.clear, for: .normal)
        completedBtn.setTitleColor(.clear, for: .normal)

    }
    
    @IBAction func selectDeferredView(_ sender: Any) {

        defaults.set(3, forKey: Getsdone.DEFAULTS_VIEW)
        
        openBtn.setTitleColor(.clear, for: .normal)
        delegatedBtn.setTitleColor(.clear, for: .normal)
        deferredBtn.setTitleColor(Getsdone.TealColor, for: .normal)
        completedBtn.setTitleColor(.clear, for: .normal)

    }
    
    @IBAction func selectCompletedView(_ sender: Any) {

        defaults.set(2, forKey: Getsdone.DEFAULTS_VIEW)
        
        openBtn.setTitleColor(.clear, for: .normal)
        delegatedBtn.setTitleColor(.clear, for: .normal)
        deferredBtn.setTitleColor(.clear, for: .normal)
        completedBtn.setTitleColor(Getsdone.TealColor, for: .normal)

    }
    
    
} // TaskFilterController

//
//  MainTabController.swift
//  getsdone-ios
//
//  Created by hu on 6/24/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

import Font_Awesome_Swift

class MainTabController: UITabBarController {
    
    // MARK: Properties
    @IBOutlet weak var tabs: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*tabs.items?[0].setFAIcon(icon: FAType.FAHome)
        tabs.items?[1].setFAIcon(icon: FAType.FAUsers)
        tabs.items?[2].setFAIcon(icon: FAType.FABarChartO)
        tabs.items?[3].setFAIcon(icon: FAType.FAHeart)*/
        
        tabs.items?[0].setFAIcon(icon: FAType.FAHome, size: nil, textColor: .black, backgroundColor: .clear, selectedTextColor: Getsdone.TealColor, selectedBackgroundColor: .clear)
        
        tabs.items?[1].setFAIcon(icon: FAType.FAUsers, size: nil, textColor: .black, backgroundColor: .clear, selectedTextColor: Getsdone.TealColor, selectedBackgroundColor: .clear)
        
        tabs.items?[2].setFAIcon(icon: FAType.FABarChartO, size: nil, textColor: .black, backgroundColor: .clear, selectedTextColor: Getsdone.TealColor, selectedBackgroundColor: .clear)
        
        tabs.items?[3].setFAIcon(icon: FAType.FAHeart, size: nil, textColor: .black, backgroundColor: .clear, selectedTextColor: Getsdone.TealColor, selectedBackgroundColor: .clear)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    
} // MainTabController

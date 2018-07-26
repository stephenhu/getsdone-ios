//
//  StartPageController.swift
//  getsdone-ios
//
//  Created by hu on 7/24/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit

class StartPageController: UIPageViewController, UIPageViewControllerDelegate,
UIPageViewControllerDataSource {
    
    var pages = [UIViewController]()
    
    // MARK: Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        let p1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "start1")
        
        let p2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "start2")
        
        let p3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "start3")
        
        self.view.backgroundColor = UIColor.clear
        
        pages.append(p1)
        pages.append(p2)
        pages.append(p3)
        
        self.setViewControllers([p1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        let currentPage     = pages.index(of: viewController)!
        let previousPage    = abs((currentPage-1) % pages.count)
        
        return pages[previousPage]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentPage     = pages.index(of: viewController)!
        let nextPage        = abs((currentPage+1) % pages.count)
        
        return pages[nextPage]
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
} // StartPageController

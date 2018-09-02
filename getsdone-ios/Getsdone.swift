//
//  Getsdone.swift
//  getsdone-ios
//
//  Created by hu on 6/25/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit


class Getsdone {
    
    
    static let API_ENDPOINT             = "http://127.0.0.1:8888/api"
    static let AUTH_ENDPOINT            = "http://127.0.0.1:8888/auth"
    //static let API_ENDPOINT             = "https://getsdone.xyz/api"
    //static let AUTH_ENDPOINT            = "https://getsdone.xyz/auth"
    static let API_USERS                = "/users"
    static let API_TASKS                = "/tasks"
    static let API_CONTACTS             = "/contacts"
    static let API_COMMENTS             = "/comments"
    static let API_NOTIFICATIONS        = "/notifications"
    
    static let COOKIE                   = "cookie"
    static let TOKEN                    = "token"
    static let TID                      = "tid"
    static let APP_NAME                 = "getsdone"
    
    static let CONTACT_ACCEPTED         = "accepted"
    static let CONTACT_DECLINED         = "declined"
    
    static let UPDATE_TASK_DEFERRED     = "deferred"
    static let UPDATE_TASK_UNDEFERRED   = "undeferred"
    static let UPDATE_TASK_COMPLETED    = "completed"

    
    static let TealColor = UIColor(
        red: 1/255, green: 129/255, blue: 186/255, alpha: 1)

    static let BlueColor = UIColor(
        red: 1/34, green: 68/255, blue: 102/255, alpha: 1)
    
    static let GreenColor = UIColor(
        red: 53/255, green: 129/255, blue: 48/255, alpha: 1)
    
    static func toAgo(_ d: String) -> String {
        
        let f = DateFormatter()
        
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let created = f.date(from: d)
        
        let c = DateComponentsFormatter()
        
        c.allowedUnits = [.day, .hour, .minute, .second]
        c.unitsStyle = .abbreviated
        c.maximumUnitCount = 1
        
        let s = c.string(from: created!, to: Date())
        
        return s!
        
    } // toAgo

    static func toReadableDate(_ d: String) -> String {
        
        let f1 = DateFormatter()
        
        f1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let created = f1.date(from: d)
        
        let f2 = DateFormatter()
        
        f2.dateFormat = "MMM dd, yyyy"
        
        return f2.string(from: created!)
        
    } // toReadableDate
}

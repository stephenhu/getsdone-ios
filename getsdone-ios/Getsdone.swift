//
//  Getsdone.swift
//  getsdone-ios
//
//  Created by hu on 6/25/18.
//  Copyright © 2018 stephenhu. All rights reserved.
//

import UIKit


class Getsdone {
    
    
    static let HTTP                     = "http://"
    static let HTTPS                    = "https://"
    static let SERVER                   = "127.0.0.1:8888"
    static let API_ENDPOINT             = "127.0.0.1:8888/api"
    static let AUTH_ENDPOINT            = "127.0.0.1:8888/auth"
    static let API_USERS                = "/users"
    static let API_TASKS                = "/tasks"
    
    static let COOKIE                   = "cookie"
    static let TOKEN                    = "token"
    static let TID                      = "tid"
    static let APP_NAME                 = "getsdone"

    
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
    
}

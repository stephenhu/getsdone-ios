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
    static let ROOT_ENDPOINT            = "http://127.0.0.1:8888"
    //static let API_ENDPOINT             = "https://getsdone.xyz/api"
    //static let AUTH_ENDPOINT            = "https://getsdone.xyz/auth"
    //static let ROOT_ENDPOINT            = "https://getsdone.xyz"
    static let API_USERS                = "/users"
    static let API_TASKS                = "/tasks"
    static let API_CONTACTS             = "/contacts"
    static let API_COMMENTS             = "/comments"
    static let API_NOTIFICATIONS        = "/notifications"
    static let API_RANKS                = "/ranks"
    static let API_ICONS                = "/icons"
    
    static let COOKIE                   = "cookie"
    static let TOKEN                    = "token"
    static let TID                      = "tid"
    static let APP_NAME                 = "getsdone"
    
    static let GRAVATAR                 = "https://gravatar.com/avatar"
    
    static let DEFAULTS_VIEW            = "getsdone.view"
    static let DEFAULTS_SORT            = "getsdone.sort"
    
    static let FILTER_VIEW_OPEN         = 0
    static let FILTER_VIEW_DELEGATED    = 1
    static let FILTER_VIEW_COMPLETED    = 2
    static let FILTER_VIEW_DEFERRED     = 3
    
    static let FILTER_SORT_ASC          = 0
    static let FILTER_SORT_DESC         = 1
    
    static let CONTACT_ACCEPTED         = "accepted"
    static let CONTACT_DECLINED         = "declined"
    
    static let UPDATE_TASK_DEFERRED     = "deferred"
    static let UPDATE_TASK_UNDEFERRED   = "undeferred"
    static let UPDATE_TASK_COMPLETED    = "completed"
    
    static let MEDIA_TYPE_IMAGE         = "public.image"

    
    // #0181BA
    static let TealColor = UIColor(
        red: 1/255, green: 129/255, blue: 186/255, alpha: 1)
    
    // #
    static let BlueColor = UIColor(
        red: 1/34, green: 68/255, blue: 102/255, alpha: 1)
    
    // #3993BA
    static let LightTealColor = UIColor(
        red: 27/255, green: 147/255, blue: 186/255, alpha: 1)
    
    static let GreenColor = UIColor(
        red: 53/255, green: 129/255, blue: 48/255, alpha: 1)
    
    static let RedColor = UIColor(
        red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
    
    static let PinkColor = UIColor(
        red: 255/255, green: 59/255, blue: 48/255, alpha: 0.3)
    
    // #EDEDED
    static let LightGrayColor = UIColor(
        red: 215/255, green: 215/255, blue: 215/255, alpha: 0.3)
    
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
    

    static func highlights(_ t: String) -> NSAttributedString {
        
        let attrStr = NSMutableAttributedString(string: t)
        
        let regExs = ["#[a-z0-9]+", "@[a-z0-9]+"]
        let highlightColors = [Getsdone.TealColor, Getsdone.PinkColor]
        
        var index = 0
        
        for r in regExs {

            let re = try? NSRegularExpression(pattern: r,                                              options: .caseInsensitive)
            
            let matches = re?.matches(
                in: t, options: [], range: NSRange(location: 0,
                length: t.count))
            
            for m in matches! {
                
                attrStr.addAttribute(
                    NSAttributedStringKey.foregroundColor,
                    value: highlightColors[index], range: m.range)
                
            }

            index += 1
            
        }

        return attrStr
        
    } // highlightHashtags
    
}

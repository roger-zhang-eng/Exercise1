//
//  Utilities.swift
//  Exercise1
//
//  Created by Roger Zhang on 17/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation


class Utilities {
    
    //Define singleton instance.
    //static let shared = CurrentSpot()
    
    private static let formatterForUI: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' h:m a"
        return formatter
    }()
    
    private static let formatterForFS: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    class func getUIDateString(date: NSDate) -> String {
        return Utilities.formatterForUI.stringFromDate(date)
    }
    
    class func getFSCurrentDateString() -> String {
        return Utilities.formatterForFS.stringFromDate(NSDate())
    }
    
}
//
//  CurrentSpot.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation
import CoreLocation
import ReactiveSwift

class CurrentSpot: NSObject {
    //Define singleton instance.
    static let shared = CurrentSpot()
    
    var initiated: Bool
    
    let cityName  = MutableProperty<String>("Loading...")
    
    var geoLocation: CLLocationCoordinate2D? {
        didSet {
            if geoLocation != nil {
                initiated = true
            }
        }
    }
    
    fileprivate override init() {
        self.initiated = false
    }
    
}

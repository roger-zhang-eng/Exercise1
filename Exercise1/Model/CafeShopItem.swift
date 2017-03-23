//
//  CafeShopItem.swift
//  Exercise1
//
//  Created by Roger Zhang on 17/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation
import UIKit

class CafeShopItem {
    let venue: FSVenue
    var cafeShopMap: UIImage?
    var address: String? {
        get {
                guard venue.location?.address != nil else {
                    return nil
                }
            
                return venue.location!.address! + " " + venue.location!.city!
        }
    }
    
    init(venue: FSVenue) {
        self.venue = venue
    }

}

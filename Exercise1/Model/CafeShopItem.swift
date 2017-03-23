//
//  CafeShopItem.swift
//  Exercise1
//
//  Created by Roger Zhang on 17/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation
import UIKit

class CafeShopItem: FSVenue {
    var cafeShopMap: UIImage?
    var address: String? {
        get {
            guard let formattedAddress = super.location?.formattedAddress else {
                return nil
            }
            
            return formattedAddress[0] + " " + formattedAddress[1]
        }
    }

}

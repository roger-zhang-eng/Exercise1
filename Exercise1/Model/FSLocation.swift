//
//  FSLocation.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation

class FSLocation: NSObject {
    var address: String?
    var lat: NSNumber?
    var lng: NSNumber?
    var distance: NSNumber?
    var postalCode: String?
    var cc: String?
    var city: String?
    var state: String?
    var formattedAddress: [String]?
}

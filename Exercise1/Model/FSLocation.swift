//
//  FSLocation.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation
import Gloss

protocol FSLocationModel {
    var address: String? { get }
    var lat: Double?  { get }
    var lng: Double?  { get }
    var distance: Int?  { get }
    var postalCode: String?  { get }
    var cc: String?  { get }
    var city: String?  { get }
    var state: String?  { get }
    var country: String?  { get }
}

struct FSLocation: FSLocationModel {
    let address: String?
    let lat: Double?
    let lng: Double?
    let distance: Int?
    let postalCode: String?
    let cc: String?
    let city: String?
    let state: String?
    let country: String?
}

extension FSLocation: Decodable {
    init?(json: JSON) {
        self.address = "address" <~~ json
        self.city = "city" <~~ json
        self.state = "state" <~~ json
        self.postalCode = "postalCode" <~~ json
        self.cc = "cc" <~~ json
        self.country = "country" <~~ json
        self.lat = "lat" <~~ json
        self.lng = "lng" <~~ json
        self.distance = "distance" <~~ json
    }
}

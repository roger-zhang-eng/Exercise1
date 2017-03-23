//
//  FSVenue.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation
import Gloss

protocol FSVenueModel {
    var name: String? { get }
    var contact: FSContact? { get }
    var location: FSLocation? { get }
    var stats: FSStats? { get }
}

struct FSVenue: FSVenueModel {
    let name: String?
    let contact: FSContact?
    let location: FSLocation?
    let stats: FSStats?
    var verified: Bool?
}

extension FSVenue: Decodable {
    init?(json: JSON) {
        self.name = "name" <~~ json
        self.contact = "contact" <~~ json
        self.location = "location" <~~ json
        self.stats = "stats" <~~ json
        self.verified = "verified" <~~ json
    }
}

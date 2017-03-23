//
//  FSContact.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation
import Gloss

//Define the attribute for read-only
protocol FSContactModel {
    var phone: String? { get }
    var formattedPhone: String? { get }
    var twitter: String? { get }
    var facebookName: String? { get }
}

struct FSContact: FSContactModel {
    let phone: String?
    let formattedPhone: String?
    var twitter: String?
    var facebookName: String?
}

extension FSContact: Decodable {
    init?(json: JSON) {
        self.phone = "phone" <~~ json
        self.formattedPhone = "formattedPhone" <~~ json
        self.twitter = "twitter" <~~ json
        self.facebookName = "facebookName" <~~ json
    }
}

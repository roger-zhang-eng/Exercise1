//
//  FSStats.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation
import Gloss

protocol FSStatsModel {
    var checkinsCount: Int? { get }
    var usersCount: Int? { get }
    var tipCount: Int? { get }
}

struct FSStats: FSStatsModel {
    let checkinsCount: Int?
    let usersCount: Int?
    let tipCount: Int?
}

extension FSStats: Decodable {
    init?(json: JSON) {
        self.checkinsCount = "checkinsCount" <~~ json
        self.usersCount = "usersCount" <~~ json
        self.tipCount = "tipCount" <~~ json
    }
}

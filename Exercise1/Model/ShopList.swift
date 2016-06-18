//
//  ShopList.swift
//  Exercise1
//
//  Created by Roger Zhang on 17/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation

class ShopList: NSObject {
    //Define singleton instance.
    static let shared = ShopList()
    
    var initiated: Bool
    var items: [CafeShopItem] {
        didSet {
            guard items.count > 0 else {
                return
            }
            self.initiated = true
        }
    }
    
    private override init() {
        initiated = false
        items = [CafeShopItem]()
    }
    
    func resetData() {
        self.items.removeAll(keepCapacity: false)
        self.initiated = false
    }
}
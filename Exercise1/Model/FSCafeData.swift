//
//  FSCafeData.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation
import RestKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


public protocol FSCafeDataDelegate: class {
    func updateCafeShotItems()
}

class FSCafeData {
    
    weak var cafeDataDelegate: FSCafeDataDelegate?
    let clientID:String = "ACAO2JPKM1MXHQJCK45IIFKRFR2ZVL0QASMCBCG5NPJQWF2G"
    let clientSecret:String = "YZCKUYJ1WHUV2QICBXUBEILZI1DMPUIDP5SHV043O04FKBHL"
    let categoryID: String = "4bf58dd8d48988d1e0931735,4bf58dd8d48988d16d941735"
    
    init() {
        self.configureRestKit()
    }
    
    //unused
    func url() -> URL {
        var urlcomponent = URLComponents()
        urlcomponent.scheme = "https"
        urlcomponent.host = "api.foursquare.com"
        
        
        return urlcomponent.url!
    }
    
    func configureRestKit() {
        let baseURL = URL(string: "https://api.foursquare.com")
        let client = AFRKHTTPClient(baseURL: baseURL)//url()//AFHTTPClient(baseURL: baseURL)
        
        //Init RestKit
        let objectManager = RKObjectManager(httpClient: client)
        
        //Set decoding data model class
        let venueMapping = RKObjectMapping(for: CafeShopItem.self)
        venueMapping?.addAttributeMappings(from: ["name"])
        
        let contactMapping = RKObjectMapping(for: FSContact.self)
        contactMapping?.addAttributeMappings(from: ["phone","formattedPhone","twitter","facebookName"])
        
        print("contactMapping.addAttributeMappingsFromArray OK")
        
        let locationMapping = RKObjectMapping(for: FSLocation.self)
        locationMapping?.addAttributeMappings(from: ["address","lat","lng","distance","postalCode","cc","city","state","formattedAddress"])
        
        print("locationMapping.addAttributeMappingsFromArray OK")
        
        let statsMapping = RKObjectMapping(for: FSStats.self)
        statsMapping?.addAttributeMappings(from: ["checkinsCount","usersCount","tipCount"])
        
        print("statsMapping.addAttributeMappingsFromArray OK")
        
        
        /**
         Configure Web Service JSON data mapping relationship
         */
        venueMapping?.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "venues", toKeyPath: "venues", with: venueMapping))
        
        venueMapping?.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "contact", toKeyPath: "contact", with: contactMapping))
        venueMapping?.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "location", toKeyPath: "location", with: locationMapping))
        venueMapping?.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "stats", toKeyPath: "stats", with: statsMapping))
        
        let searchResponseDescriptor = RKResponseDescriptor(mapping: venueMapping, method: RKRequestMethod.GET, pathPattern: "/v2/venues/search", keyPath: "response.venues", statusCodes: IndexSet([200]))
        
        //set RestKit resp descriptor for auto data parsing
        objectManager?.addResponseDescriptor(searchResponseDescriptor)
        
        print("configureRestKit OK.")
    }
    
    func loadVenues(_ position: String) {
        //Get the latest date string
        let dateText = Utilities.getFSCurrentDateString()
        
        NSLog("loadVenues: position \(position), categoryID \(categoryID), date \(dateText)")
        
        //set the query infor for RestKit
        let queryParams = [
            "ll":position,
            "client_id":clientID,
            "client_secret":clientSecret,
            "categoryId":categoryID,
            "v":dateText
        ]
        
        let objPath = "/v2/venues/search"
        
        RKObjectManager.shared().getObjectsAtPath(objPath, parameters: queryParams, success: { operation, mappingResult in
            
            print("RKObjectManager getObjectsAtPath Successfully!")

                var venues_array = mappingResult?.array() as! [CafeShopItem]
                NSLog("Totally get venues' record \(venues_array.count)")
                venues_array.sort(by: self.inOrder)

                ShopList.shared.items = venues_array
            self.cafeDataDelegate?.updateCafeShotItems()
            
            }, failure: { operation, error in
                NSLog("There is something wrong: \(error?.localizedDescription)")
        })
    }
    
    
    func inOrder(_ p1:CafeShopItem,p2:CafeShopItem)->Bool {
        //According to distance, sort the array as ascend order
        return p1.location!.distance?.intValue < p2.location!.distance!.intValue
    }
    
}

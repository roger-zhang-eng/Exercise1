//
//  FSCafeData.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation

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
    
    func configureRestKit() {
        let baseURL = NSURL(string: "https://api.foursquare.com")
        let client = AFHTTPClient(baseURL: baseURL)
        
        //Init RestKit
        let objectManager = RKObjectManager(HTTPClient: client)
        
        //Set decoding data model class
        let venueMapping = RKObjectMapping(forClass: CafeShopItem.self)
        venueMapping.addAttributeMappingsFromArray(["name"])
        
        let contactMapping = RKObjectMapping(forClass: FSContact.self)
        contactMapping.addAttributeMappingsFromArray(["phone","formattedPhone","twitter","facebookName"])
        
        print("contactMapping.addAttributeMappingsFromArray OK")
        
        let locationMapping = RKObjectMapping(forClass: FSLocation.self)
        locationMapping.addAttributeMappingsFromArray(["address","lat","lng","distance","postalCode","cc","city","state","formattedAddress"])
        
        print("locationMapping.addAttributeMappingsFromArray OK")
        
        let statsMapping = RKObjectMapping(forClass: FSStats.self)
        statsMapping.addAttributeMappingsFromArray(["checkinsCount","usersCount","tipCount"])
        
        print("statsMapping.addAttributeMappingsFromArray OK")
        
        
        /**
         Configure Web Service JSON data mapping relationship
         */
        venueMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "venues", toKeyPath: "venues", withMapping: venueMapping))
        
        venueMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "contact", toKeyPath: "contact", withMapping: contactMapping))
        venueMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "location", toKeyPath: "location", withMapping: locationMapping))
        venueMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "stats", toKeyPath: "stats", withMapping: statsMapping))
        
        let searchResponseDescriptor = RKResponseDescriptor(mapping: venueMapping, method: RKRequestMethod.GET, pathPattern: "/v2/venues/search", keyPath: "response.venues", statusCodes: NSIndexSet(index: 200))
        
        
        //set RestKit resp descriptor for auto data parsing
        objectManager.addResponseDescriptor(searchResponseDescriptor)
        
        print("configureRestKit OK.")
    }
    
    func loadVenues(position: String) {
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
        
        RKObjectManager.sharedManager().getObjectsAtPath(objPath, parameters: queryParams, success: { operation, mappingResult in
            
            print("RKObjectManager getObjectsAtPath Successfully!")

                var venues_array = mappingResult.array() as! [CafeShopItem]
                NSLog("Totally get venues' record \(venues_array.count)")
                venues_array.sortInPlace(self.inOrder)

                ShopList.shared.items = venues_array
            self.cafeDataDelegate?.updateCafeShotItems()
            
            }, failure: { operation, error in
                NSLog("There is something wrong: \(error.localizedDescription)")
        })
    }
    
    
    func inOrder(p1:CafeShopItem,p2:CafeShopItem)->Bool {
        //According to distance, sort the array as ascend order
        return p1.location!.distance?.integerValue < p2.location!.distance!.integerValue
    }
    
}

//
//  NetworkModel.swift
//  Exercise1
//
//  Created by Roger Zhang on 22/3/17.
//  Copyright © 2017 Roger.Zhang. All rights reserved.
//

import Foundation
import Alamofire

struct UserLocation {
    let lat: Double
    let long: Double
    
    fileprivate var locationQuery: String {
        return [lat, long]
            .map { String(describing: $0) }
            .joined(separator: ",")
    }
}

enum Error: Swift.Error {
    case invalidURL
    case failedJSONParsing
    case networkFailure
}

class NetworkModel {

    static let sharedInstance = NetworkModel()
    
    let scheme = "https"
    let host = "api.foursquare.com"
    let path = "/v2/venues/search"
    let clientID = "ACAO2JPKM1MXHQJCK45IIFKRFR2ZVL0QASMCBCG5NPJQWF2G"
    let clientSecret = "YZCKUYJ1WHUV2QICBXUBEILZI1DMPUIDP5SHV043O04FKBHL"
    let categoryID = "4bf58dd8d48988d1e0931735,4bf58dd8d48988d16d941735"
    
    //static let clientIDQueryItem = URLQueryItem(name: "client_id", value: "ACAO2JPKM1MXHQJCK45IIFKRFR2ZVL0QASMCBCG5NPJQWF2G")
    //static let clientSecretQueryItem = URLQueryItem(name: "client_secret", value: "YZCKUYJ1WHUV2QICBXUBEILZI1DMPUIDP5SHV043O04FKBHL")
    
    
    //static let versionQueryItem = URLQueryItem(name: "v", value: "20170320")
    //static let coffeeQueryItem = URLQueryItem(name: "categoryId", value: "4bf58dd8d48988d1e0931735")
    
    private func url() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        return components.url
    }
    
    func networkConnectRequest(_ location: UserLocation) -> DataRequest?
    {
        //Get the latest date string
        let dateText = Utilities.getFSCurrentDateString()
        let urlText = self.url()!.absoluteString
        let headers : [String : String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        let parameters : [String : String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "v": dateText,
            //"categoryId": categoryID,
            "query": "coffee",
            "ll": location.locationQuery
        ]
        
        return Alamofire.request(urlText, method: .get, parameters: parameters, headers: headers)
    }
    
    func loadVenues(_ position: UserLocation, completion: @escaping (Result<[FSVenue], Error>) -> ()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let request = networkConnectRequest(position)
        request?.validate()
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    if let value = response.result.value as? [String: Any], let fsResponse = value["response"] as? [String: Any], let fsVenues = fsResponse["venues"] as? [[String: Any]], let fsvenues = [FSVenue].from(jsonArray: fsVenues) {
                        completion(Result.success(fsvenues))
                    } else {
                        completion(Result.failure(.failedJSONParsing))
                    }
                    
                case .failure(let error):
                    print("load Venues error: \(error.localizedDescription)")
                    completion(Result.failure(.networkFailure))
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
    }

}


/*
 {
 "meta":{
 "code":200,
 "requestId":"58d270bdf594df18b3a3cc37"
 },
 "response":{
 "venues":[
 {
 "id":"4b5aa658f964a5206bcf28e3",
 "name":"Gloria Jean's Coffees",
 "contact":{
 "phone":"+61433899996",
 "formattedPhone":"+61 433 899 996",
 "twitter":"gloriajeans"
 },
 "location":{
 "address":"The Galleries Victoria\rCnr Pitt & Park Streets",
 "crossStreet":"cnr Pitt St. & Park St.",
 "lat":-33.87294542928269,
 "lng":151.2079882621765,
 "labeledLatLngs":[
 {
 "label":"display",
 "lat":-33.87294542928269,
 "lng":151.2079882621765
 }
 ],
 "distance":113,
 "postalCode":"2000",
 "cc":"AU",
 "city":"Sydney",
 "state":"NSW",
 "country":"Australia",
 "formattedAddress":[
 "The Galleries Victoria\rCnr Pitt & Park Streets (cnr Pitt St. & Park St.)",
 "Sydney NSW 2000",
 "Australia"
 ]
 },
 "categories":[
 {
 "id":"4bf58dd8d48988d1e0931735",
 "name":"Coffee Shop",
 "pluralName":"Coffee Shops",
 "shortName":"Coffee Shop",
 "icon":{
 "prefix":"https:\/\/ss3.4sqi.net\/img\/categories_v2\/food\/coffeeshop_",
 "suffix":".png"
 },
 "primary":true
 }
 ],
 "verified":true,
 "stats":{
 "checkinsCount":8486,
 "usersCount":3689,
 "tipCount":90
 },
 "url":"http:\/\/www.gloriajeanscoffees.com",
 "allowMenuUrlEdit":true,
 "beenHere":{
 "lastCheckinExpiredAt":0
 },
 "specials":{
 "count":0,
 "items":[
 ]
 },
 "hereNow":{
 "count":0,
 "summary":"Nobody here",
 "groups":[
 ]
 },
 "referralId":"v-1490186430",
 "venueChains":[
 ],
 "hasPerk":false
 },
 ... multiple items ... 
 ] //end of venues
 } //end of response
 }
 
 */

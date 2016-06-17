//
//  UserPosition.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import CoreLocation
import Foundation

public protocol LocationCaptureDelegate: class {
    func updateCurrentLocation(position:CLLocationCoordinate2D) ->()
}

class UserPosition: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    weak var locationDelegate:LocationCaptureDelegate?
    
    override init() {
        super.init()
        //Initate Location instance
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters    //kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
    }
    
    func starUpdateingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    //MARK: CLLocationManagerDelegate function
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            print("The location authentication is allowed!")
        } else {
            print("The location is not allowed!")
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location Update get data")
        
        //Get location update time
        let latestLoc = locations.last!
        let eventDate = latestLoc.timestamp
        let howRecent = eventDate.timeIntervalSinceNow
        
        if abs(howRecent) < 30 {
            print("In didUpdateLocations: Locaion: Latitude \(latestLoc.coordinate.latitude.description), Longtitude \(latestLoc.coordinate.longitude.description)")
            
            //update current location
            self.locationDelegate?.updateCurrentLocation(latestLoc.coordinate)
        } else {
            print("In didUpdateLocations: The got location address is too old!")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location \(error.description)")
    }
    
}

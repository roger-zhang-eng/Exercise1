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
    func updateCurrentLocationData(position:CLLocationCoordinate2D) ->()
    func updateCurrentLocationName(name: String) -> ()
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
        print("In UserPosition: starUpdateingLocation")
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
            self.getLocationName(manager.location!)
            
            print("In didUpdateLocations: Locaion: Latitude \(latestLoc.coordinate.latitude.description), Longtitude \(latestLoc.coordinate.longitude.description)")
            
            //update current location
            self.locationDelegate?.updateCurrentLocationData(latestLoc.coordinate)
        } else {
            print("In didUpdateLocations: The got location address is too old!")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location \(error.description)")
    }
    
    func getLocationName(location: CLLocation) {
        
        //CLGeocoder.reverseGeocodeLocation(location)
        
        let geocoder = CLGeocoder()
        var locationName = "Not available"
        print("-> Finding user address...")
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                //stop updating location to save battery life
                //self.locationManager.stopUpdatingLocation()
                
                let pm = placemarks![0] as CLPlacemark
                if pm.locality != nil {
                    locationName = pm.locality!
                }
                CurrentSpot.shared.cityName = locationName
                self.locationDelegate?.updateCurrentLocationName(locationName)
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
            
        })
    }

    func displayLocationInfo(placemark: CLPlacemark) {
        
            print(placemark.locality != nil ? placemark.locality : "")
            print(placemark.postalCode != nil  ? placemark.postalCode : "")
            print(placemark.administrativeArea != nil  ? placemark.administrativeArea : "")
            print(placemark.country != nil  ? placemark.country : "")
    }
    
}

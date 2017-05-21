//
//  UserPosition.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import CoreLocation
import Foundation
import ReactiveSwift

public protocol LocationCaptureDelegate: class {
    func updateCurrentLocationData(_ position:CLLocationCoordinate2D) ->()
    func updateCurrentLocationName(_ name: String) -> ()
}

class UserPosition: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    let currentLocation: MutableProperty<CLLocation?>
    
    override init() {
        
        //Initate Location instance
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters    //kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        currentLocation = MutableProperty(nil)
        
        super.init()
        
        locationManager.delegate = self
        
        self.starUpdateingLocation()
    }
    
    deinit {
        debugPrint("UserPosition deinit.")
    }
    
    private func starUpdateingLocation() {
        print("In UserPosition: starUpdateingLocation")
        locationManager.startUpdatingLocation()
    }
    
    //MARK: CLLocationManagerDelegate function
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            print("The location authentication is allowed!")
        } else {
            print("The location is not allowed!")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location Update get data")
        
        //Get location update time
        let latestLoc = locations.last!
        let eventDate = latestLoc.timestamp
        let howRecent = eventDate.timeIntervalSinceNow
        
        if abs(howRecent) < 30 {
            self.getLocationName(manager.location!)
            
            print("In didUpdateLocations: Locaion: Latitude \(latestLoc.coordinate.latitude.description), Longtitude \(latestLoc.coordinate.longitude.description)")
            
            //update current location
            
            self.currentLocation.value = latestLoc
            self.getLocationName(latestLoc)
            //self.locationDelegate?.updateCurrentLocationData(latestLoc.coordinate)
        } else {
            print("In didUpdateLocations: The got location address is too old!")
        }
    }
    
    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location \(error.localizedDescription)")
    }
    
    private func getLocationName(_ location: CLLocation) {
        
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
                CurrentSpot.shared.cityName.value = locationName
                //self.locationDelegate?.updateCurrentLocationName(locationName)
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
            
        })
    }

    func displayLocationInfo(_ placemark: CLPlacemark) {
        
            print(placemark.locality != nil ? placemark.locality! : "")
            print(placemark.postalCode != nil  ? placemark.postalCode! : "")
            print(placemark.administrativeArea != nil  ? placemark.administrativeArea! : "")
            print(placemark.country != nil  ? placemark.country! : "")
    }
    
}

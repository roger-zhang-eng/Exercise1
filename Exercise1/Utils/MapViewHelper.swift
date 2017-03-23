//
//  MapViewHelper.swift
//  Exercise1
//
//  Created by Roger Zhang on 18/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class MapViewHelper : NSObject, MKMapViewDelegate {

    let fixedDelta = 0.02
    let adjustedDeltaOffset = 0.03
    
    var map: MKMapView
    var centreIndex: Int?
    var centrePoint: CLLocationCoordinate2D?
    var userAnnotation: MKPointAnnotation?
    var cafeShopAnnotation: MKPointAnnotation?
    var shopCenterDisplay = false

    init(mapView: MKMapView) {
        map = mapView
        
        super.init()
        
        map.delegate = self
    }
    
    func displayAllTheCafeShops() {
        print("--> Begin to display mapView")
        
        shopCenterDisplay = false
        let shopLocation = ShopList.shared.items[1].location!
        
        let deltaLat = abs(shopLocation.lat!.doubleValue - CurrentSpot.shared.geoLocation!.latitude)
        let deltaLng = abs(shopLocation.lng!.doubleValue - CurrentSpot.shared.geoLocation!.longitude)
        
        if(deltaLat > fixedDelta) || (deltaLng > fixedDelta) {
            let mapCentreLat: CLLocationDegrees = (CurrentSpot.shared.geoLocation!.latitude + shopLocation.lat!.doubleValue)/2
            let mapCentreLng: CLLocationDegrees = (CurrentSpot.shared.geoLocation!.longitude + shopLocation.lng!.doubleValue)/2
            let mapCentre = CLLocationCoordinate2D(latitude: mapCentreLat, longitude: mapCentreLng)
            
            var deltaValue :CLLocationDegrees?
            if( deltaLat > deltaLng)
            { deltaValue = deltaLat } else
            { deltaValue = deltaLng }
            deltaValue! += adjustedDeltaOffset
            
            drawMapView(mapCentre,fixScopeDelta: false, deltaLat: deltaValue!, deltaLng: deltaValue!)
        } else {
            let mapCentre = CLLocationCoordinate2DMake(shopLocation.lat!.doubleValue,shopLocation.lng!.doubleValue)
            drawMapView(mapCentre,fixScopeDelta: true, deltaLat: nil, deltaLng: nil)
        }
        
        for item in ShopList.shared.items {
            let shopAnnotation = MKPointAnnotation()
            shopAnnotation.coordinate = CLLocationCoordinate2DMake(item.location!.lat!.doubleValue, item.location!.lng!.doubleValue)
            shopAnnotation.title = item.name
            self.map.addAnnotation(shopAnnotation)
        }
        
        //create user location annotation
        self.userAnnotation = MKPointAnnotation()
        self.userAnnotation?.coordinate = CurrentSpot.shared.geoLocation!
        self.userAnnotation?.title = "Current Position"
        self.map.addAnnotation(self.userAnnotation!)
        
        self.map.selectAnnotation(self.userAnnotation!, animated: true)
        
    }

    func drawMapView(_ centerPosition:CLLocationCoordinate2D,fixScopeDelta:Bool, deltaLat:CLLocationDegrees?, deltaLng:CLLocationDegrees?) {
        //set MapKit necessary information
        var theRegion: MKCoordinateRegion?
        if(fixScopeDelta) {
            //Set the display region, and the marker place point
            let theSpan = MKCoordinateSpanMake(self.fixedDelta,self.fixedDelta)
            theRegion = MKCoordinateRegionMake(centerPosition, theSpan)
            print("In drawMapView finish theRegion setting --->")
        } else {
            //Set the display region, and the marker place point
            let theSpan = MKCoordinateSpanMake(deltaLat!,deltaLng!)
            theRegion = MKCoordinateRegionMake(centerPosition, theSpan)
        }
        
        
        self.map.setRegion(theRegion!, animated: false)
        self.map.showsUserLocation = false
        print("In drawMapView finish draw setting --->")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let displayAnnotation = annotation as! MKPointAnnotation
        if displayAnnotation == self.userAnnotation {
            var pin = self.map.dequeueReusableAnnotationView(withIdentifier: "UserPin")
            if(pin == nil) {
                pin = MKAnnotationView(annotation: annotation, reuseIdentifier: "UserPin")
                let icon = UIImage(named: "userLocation")
                pin!.canShowCallout = true
                pin!.image = icon
            }
            return pin
        } else {
        
            var pin = self.map.dequeueReusableAnnotationView(withIdentifier: "CafePin")
            if(pin == nil) {
                pin = MKAnnotationView(annotation: annotation, reuseIdentifier: "CafePin")
                let icon = UIImage(named: "hightLightCafe")
                pin!.canShowCallout = true
                pin!.image = icon
            }
            return pin
        }

    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("In mapView didUpdateUserLocation: \(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)")
        
        

            //update user location annotation
            self.map.removeAnnotation(self.userAnnotation!)
            //create user location annotation
            self.userAnnotation = MKPointAnnotation()
            self.userAnnotation?.coordinate = userLocation.coordinate
            self.userAnnotation?.title = "Current Position"
            self.map.addAnnotation(self.userAnnotation!)
            

    }
    

}

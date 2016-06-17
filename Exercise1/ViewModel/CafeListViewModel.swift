//
//  CafeListViewModel.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//
import CoreLocation
import Foundation

public protocol CafeListViewModelDelegate: class {
    func updateCafeTableView()
}

public class CafeListViewModel: LocationCaptureDelegate, FSCafeDataDelegate {
    var userCurrentPosition: UserPosition = UserPosition()
    var webServiceData: FSCafeData = FSCafeData()
    var currentLocation: CLLocationCoordinate2D?
    weak var cafeListDelegate: CafeListViewModelDelegate?
    
    init() {
        self.userCurrentPosition.locationDelegate = self
        self.webServiceData.cafeDataDelegate = self
        self.userCurrentPosition.starUpdateingLocation()
    }

    
    //Mark: LocationCaptureDelegate for update current location data
    public func updateCurrentLocation(position:CLLocationCoordinate2D) {
        self.currentLocation = position
        
        let centreLocationText = "\(position.latitude.description),\(position.longitude.description)"
        self.webServiceData.loadVenues(centreLocationText)
    }
    
    public func updateCafeShotItems() {
        self.cafeListDelegate?.updateCafeTableView()
    }
    
}
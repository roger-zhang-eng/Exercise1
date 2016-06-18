//
//  CafeListViewModel.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//
import CoreLocation
import Foundation
import SVProgressHUD

//TableView Update delegate
public protocol CafeListViewModelDelegate: class {
    func updateCafeTableView()
}

//Cafe ViewController update delegate
public protocol ViewModelForViewControllerDelegate: class {
    func updateMapButton(status: Bool)
    func updateNavTitle(name: String)
}

public class CafeListViewModel: LocationCaptureDelegate, FSCafeDataDelegate {
    var userCurrentPosition: UserPosition = UserPosition()
    var webServiceData: FSCafeData = FSCafeData()
    //var currentLocation: CLLocationCoordinate2D?
    weak var cafeListDelegate: CafeListViewModelDelegate?
    weak var cafeViewControllerDeleage: ViewModelForViewControllerDelegate?
    
    init() {
        self.userCurrentPosition.locationDelegate = self
        self.webServiceData.cafeDataDelegate = self
    }
    
    func loadCafeShopsData()  {
        
        //Indicate current operation
        SVProgressHUD.showWithStatus("Detecting current location...")
  
        self.userCurrentPosition.starUpdateingLocation()
    }
    
    
    //Mark: LocationCaptureDelegate for update current location data
    public func updateCurrentLocationData(position:CLLocationCoordinate2D) {
        CurrentSpot.shared.geoLocation = position
        
        let centreLocationText = "\(position.latitude.description),\(position.longitude.description)"
        
        //Dissmiss indication
        SVProgressHUD.dismiss()
        
        //Clean previous cafe shops list
        if(ShopList.shared.initiated) {
            ShopList.shared.resetData()
        }
        
        //Indicate current operation
        SVProgressHUD.showWithStatus("Detecting nearby Cafe Shops...")
        self.webServiceData.loadVenues(centreLocationText)
    }
    
    public func updateCurrentLocationName(name: String) {
        print("Current location name: \(name)")
        self.cafeViewControllerDeleage?.updateNavTitle(name)
    }
    
    
    //Mark: ViewModelForViewControllerDelegate
    public func updateCafeShotItems() {
        self.cafeListDelegate?.updateCafeTableView()
        self.cafeViewControllerDeleage?.updateMapButton(true)
        
        //Dissmiss indication
        SVProgressHUD.dismiss()
    }
    
}
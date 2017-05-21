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
import ReactiveSwift

//TableView Update delegate
public protocol CafeListViewModelDelegate: class {
    func updateCafeTableView()
}

//Cafe ViewController update delegate
public protocol ViewModelForViewControllerDelegate: class {
    func updateMapButton(_ status: Bool)
    func updateNavTitle(_ name: String)
}

class CafeListViewModel: LocationCaptureDelegate {
    
    weak var cafeListDelegate: CafeListViewModelDelegate?
    weak var cafeViewControllerDeleage: ViewModelForViewControllerDelegate?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private let userPositionInst: UserPosition
    let svprogressShow = MutableProperty<Bool>(false)
    
    init() {
        //appDelegate.userCurrentPosition.locationDelegate = self
        self.userPositionInst = UserPosition()
    }
    
    func loadCafeShopsData()  {
        
        //Indicate current operation
        SVProgressHUD.show(withStatus: "Detecting current location...")
  
        //appDelegate.userCurrentPosition.starUpdateingLocation()
    }
    
    
    //Mark: LocationCaptureDelegate for update current location data
    func updateCurrentLocationData(_ position:CLLocationCoordinate2D) {
        CurrentSpot.shared.geoLocation = position
        
        let centreLocation = UserLocation(lat: position.latitude, long: position.longitude)
        
        //Dissmiss indication
        SVProgressHUD.dismiss()
        
        //Clean previous cafe shops list
        if(ShopList.shared.initiated) {
            ShopList.shared.resetData()
        }
        
        //Indicate current operation
        SVProgressHUD.show(withStatus: "Detecting nearby Cafe Shops...")
        
        NetworkModel.sharedInstance.loadVenues(centreLocation, completion: { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    print("Successfully get FS data.")
                    //sort the result array by ascending distance
                    let sortedResults = results.sorted { $0.0.location?.distance ?? 0 < $0.1.location?.distance ?? 0 }
                    //transform from [FSVenue] type to [CafeShopItem] type
                    ShopList.shared.resetData()
                    ShopList.shared.items = sortedResults.map({ CafeShopItem(venue: $0) })
                    //Make use of this closure to update TableView
                    self.cafeListDelegate?.updateCafeTableView()
                case .failure(let error):
                    // Propogate and present error to user
                    print("Get FS data failed: \(error)")
                }
            }
        })

    }
    
    open func updateCurrentLocationName(_ name: String) {
        print("Current location name: \(name)")
        self.cafeViewControllerDeleage?.updateNavTitle(name)
    }
    
    
    //Mark: ViewModelForViewControllerDelegate
    open func updateCafeShotItems() {
        self.cafeListDelegate?.updateCafeTableView()
        self.cafeViewControllerDeleage?.updateMapButton(true)
        
        //Dissmiss indication
        SVProgressHUD.dismiss()
    }
    
}

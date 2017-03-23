//
//  CafeOverAllViewController.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import UIKit
import MapKit

class CafeOverAllViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    fileprivate var mapViewHelper: MapViewHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("View Controller viewDidLoad")
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Cafe Shops Map"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.bindMapView()
    }

    func bindMapView()  {
        guard self.mapViewHelper == nil else {
            
            return
        }
        
        self.mapViewHelper = MapViewHelper(mapView: self.mapView)
        self.mapViewHelper?.displayAllTheCafeShops()
    }
    
}

//
//  ShopMapViewInst.swift
//  Exercise1
//
//  Created by Roger Zhang on 18/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import MapKit
import CoreLocation

class ShopMapViewInst: NSObject {
    //Define singleton instance.
    static let shared = ShopMapViewInst()
    
    var initiated: Bool = false
    
    var frame: CGRect {
        didSet {
                self.shopMapView.frame = frame
                initiated = true
        }
        
    }
    
    var shopMapView: MKMapView
    
    private override init() {
        shopMapView = MKMapView(frame: CGRectZero)
        frame = CGRectZero
    }
    
    // Takes a snapshot and calls back with the generated UIImage
    static func takeSnapshot(cafeShopIndex: Int,size: CGSize,withCallback: (UIImage?, NSError?) -> ()) {
        
        let shopLocation = ShopList.shared.items[cafeShopIndex].location!
        let centrePoint = CLLocationCoordinate2DMake(shopLocation.lat!.doubleValue,shopLocation.lng!.doubleValue)
        
        let theSpan = MKCoordinateSpanMake(0.01,0.01)
        let theRegion = MKCoordinateRegionMake(centrePoint, theSpan)
        
        let options = MKMapSnapshotOptions()
        options.region = theRegion
        options.size = size
        options.scale = UIScreen.mainScreen().scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.startWithCompletionHandler() { snapshot, error in
            guard snapshot != nil else {
                withCallback(nil, error)
                return
            }
            
            let image = snapshot!.image
            let finalImageRect = CGRectMake(0, 0, image.size.width, image.size.height)
            let pinImage = UIImage(named: "cafe")
            
            //start to create our final image
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
            image.drawAtPoint(CGPointZero)
            let point = CGPointMake(image.size.width/2, image.size.height/2)

            if CGRectContainsPoint(finalImageRect, point) {
                pinImage!.drawAtPoint(point)
            }
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            
            withCallback(finalImage, nil)
        }
    }
    
}
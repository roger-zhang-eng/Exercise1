//
//  Utilities.swift
//  Exercise1
//
//  Created by Roger Zhang on 17/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

enum Result<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)
}

class Utilities {
    
    //Define singleton instance.
    //static let shared = CurrentSpot()
    
    fileprivate static let formatterForUI: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' h:m a"
        return formatter
    }()
    
    fileprivate static let formatterForFS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    class func getUIDateString(_ date: Date) -> String {
        return Utilities.formatterForUI.string(from: date)
    }
    
    class func getFSCurrentDateString() -> String {
        return Utilities.formatterForFS.string(from: Date())
    }
    
    // Takes a snapshot and calls back with the generated UIImage
    static func takeSnapshot(_ cafeShopIndex: Int,size: CGSize,withCallback: @escaping (UIImage?, NSError?) -> ()) {
        
        let shopLocation = ShopList.shared.items[cafeShopIndex].venue.location!
        let centrePoint = CLLocationCoordinate2DMake(shopLocation.lat!,shopLocation.lng!)
        
        let theSpan = MKCoordinateSpanMake(0.01,0.01)
        let theRegion = MKCoordinateRegionMake(centrePoint, theSpan)
        
        let options = MKMapSnapshotOptions()
        options.region = theRegion
        options.size = size
        options.scale = UIScreen.main.scale
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start(completionHandler: { snapshot, error in
            guard snapshot != nil else {
                withCallback(nil, error as NSError?)
                return
            }
            
            let image = snapshot!.image
            let finalImageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            let pinImage = UIImage(named: "cafe")
            
            //start to create our final image
            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale);
            image.draw(at: CGPoint.zero)
            let point = CGPoint(x: image.size.width/2, y: image.size.height/2)
            
            if finalImageRect.contains(point) {
                pinImage!.draw(at: point)
            }
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            
            withCallback(finalImage, nil)
        })
    }
        
}

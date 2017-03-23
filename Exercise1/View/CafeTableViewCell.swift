//
//  CafeTableViewCell.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import UIKit
import MapKit
import FoldingCell

class CafeTableViewCell: FoldingCell {

    @IBOutlet weak var upCafeName: UILabel!
    @IBOutlet weak var upDistance: UILabel!
    
    @IBOutlet weak var downCafeName: UILabel!
    @IBOutlet weak var downCheckin: UILabel!
    @IBOutlet weak var downCafePhone: UILabel!
    @IBOutlet weak var downAddress: UILabel!
    @IBOutlet weak var shopMapView: UIImageView!
    
    var cellRowIndex: Int?
    
    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    func displayShopMap()  {
        let shopItem = ShopList.shared.items[cellRowIndex!]
        if(shopItem.cafeShopMap != nil) {
            self.shopMapView.image = shopItem.cafeShopMap
        } else {
        
            //let yOffset = self.containerView.frame.size.height - 110
            let width = self.containerView.frame.size.width - 20
            let shopMapViewFrame = CGRect(x: 10, y: 110, width: width, height: 335)
            //ShopMapViewInst.shared.shopMapView.frame = shopMapViewFrame
            
            Utilities.takeSnapshot(self.cellRowIndex!, size: shopMapViewFrame.size, withCallback:{ (image, error) -> Void in
                if error != nil {
                    print("In bindMapView, takeSnapshot has problem: \(error?.description)")
                } else {
                    shopItem.cafeShopMap = image
                    self.shopMapView.image = image
                }
            })
        }
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        
        let durations = [0.16, 0.1, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.1, 0.1, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    func updateForegroundView(_ cafeName: String, distance:String?) {
        self.upCafeName.text = cafeName
        self.upDistance.text = distance
    }
    
    func updateDownView(_ index: Int, cafeName: String, checkinCount: String?, phone: String?, address: String?) {
        self.cellRowIndex = index
        self.downCafeName.text = cafeName
        self.downCheckin.text = checkinCount
        self.downCafePhone.text = phone
        self.downAddress.text = address

    }

}

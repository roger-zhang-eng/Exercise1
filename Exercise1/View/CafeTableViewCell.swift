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
    @IBOutlet weak var downRating: UILabel!
    @IBOutlet weak var downCafePhone: UILabel!
    @IBOutlet weak var downAddress: UILabel!
    @IBOutlet weak var downMapView: MKMapView!
    
    var cafeLocationLat: CGFloat?
    var cafeLocationLng: CGFloat?
    
    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        let durations = [0.16, 0.1, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.1, 0.1, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    func updateForegroundView(cafeName: String, distance:String?) {
        self.upCafeName.text = cafeName
        self.upDistance.text = distance
    }
    
    func updateDownView(cafeName: String, checkinCount: String?, phone: String?, address: String?, lat: CGFloat?, lng: CGFloat?) {
        self.downCafeName.text = cafeName
        self.downRating.text = checkinCount
        self.downCafePhone.text = phone
        self.downAddress.text = address
        self.cafeLocationLat = lat
        self.cafeLocationLng = lng
    }

}

//
//  TableViewBindingHelper.swift
//  Exercise1
//
//  Created by Roger Zhang on 17/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//
import UIKit
import Foundation
import FoldingCell

class TableViewBindingHelper: NSObject, UITableViewDataSource, UITableViewDelegate, CafeListViewModelDelegate {
    
    //MARK: Properties
    
    private let cafeTableView: UITableView
    private let cafeListViewModel: CafeListViewModel

    //Cafe TableViewCell variables
    let cellIndentifier = "CafeViewCell"
    let kCloseCellHeight: CGFloat = 54
    let kOpenCellHeight: CGFloat = 460
    var cellHeights = [CGFloat]()
    var kCellCount = 0
    var data : [CafeShopItem]!
    var lastOpenCellIndexPath: NSIndexPath?
    
    init(viewModel: CafeListViewModel, tableView: UITableView) {

        cafeListViewModel = viewModel
        cafeTableView = tableView
        
        super.init()
        
        cafeTableView.dataSource = self
        cafeTableView.delegate = self
        cafeListViewModel.cafeListDelegate = self
    }
    
    func cleanData()  {
        ShopList.shared.items.removeAll(keepCapacity: false)
        self.cellHeights.removeAll(keepCapacity: false)
        self.kCellCount = 0
    }
    
    func updateCafeTableView() {
        self.kCellCount = ShopList.shared.items.count
        self.data = ShopList.shared.items
        for _ in 1...self.kCellCount {
            cellHeights.append(kCloseCellHeight)
        }
        self.cafeTableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.kCellCount
        }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as! CafeTableViewCell
            let item = self.data[indexPath.row]
            let distanceText = self.getDistanceText(item.location!.distance!.intValue)
        
            cell.updateForegroundView(item.name!, distance: distanceText)
        
            var checkinText = "Checkin: "
            if let checkinNumString = item.stats?.checkinsCount?.stringValue {
                checkinText += checkinNumString
            } else {
                checkinText += "0"
            }
        
            var contactText = "Contact: "
            if let phoneString = item.contact?.formattedPhone {
                contactText += phoneString
            } else {
                contactText += "Not available"
            }
        
            var addressText = "Address: "
            if let addressString = item.address {
                addressText += addressString
            } else {
                addressText += "Not available"
            }
        
            cell.updateDownView(indexPath.row, cafeName: item.name!, checkinCount: checkinText, phone: contactText, address: addressText)
        
            return cell
        }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return cellHeights[indexPath.row]
            
        }
        
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            if cell is FoldingCell {
                let foldingCell = cell as! FoldingCell
                foldingCell.backgroundColor = UIColor.clearColor()
                
                if cellHeights[indexPath.row] == kCloseCellHeight {
                    foldingCell.selectedAnimation(false, animated: false, completion:nil)
                } else {
                    foldingCell.selectedAnimation(true, animated: false, completion: nil)
                }
            }
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! CafeTableViewCell
                
                if cell.isAnimating() {
                    return
                }
            
                var duration = 0.0
                if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
                    
                    
                    //Close last Open cell
                    if lastOpenCellIndexPath != nil {
                        
                        let visibleCellIndexes = self.cafeTableView.indexPathsForVisibleRows!
                        
                        if visibleCellIndexes.contains(lastOpenCellIndexPath!) {
                            let lastOpenCell = self.cafeTableView.cellForRowAtIndexPath(lastOpenCellIndexPath!) as! CafeTableViewCell
                            cellHeights[lastOpenCellIndexPath!.row] = kCloseCellHeight
                            lastOpenCell.selectedAnimation(false, animated: true, completion: nil)
                            duration = 0.8
                        } else {
                            cellHeights[lastOpenCellIndexPath!.row] = kCloseCellHeight
                        }
                    }
                    lastOpenCellIndexPath = indexPath
                    
                    //Bind mapView to display
                    cell.displayShopMap()
                    cellHeights[indexPath.row] = kOpenCellHeight
                    cell.selectedAnimation(true, animated: true, completion: nil)
                    duration = 0.5
                } else {
                    // close cell
                    
                    lastOpenCellIndexPath = nil
                    
                    cellHeights[indexPath.row] = kCloseCellHeight
                    cell.selectedAnimation(false, animated: true, completion: nil)
                    duration = 0.8
                }
                
                UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                    self.cafeTableView.beginUpdates()
                    self.cafeTableView.endUpdates()
                    }, completion: nil)
        }
    
        func getDistanceText(length:Int32) -> String {
            return length < 1000 ? "Distance: \(length) m" : NSString(format: "Distance: %.2f km", Float32(length)/1000) as String
        }


}
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
    let cellIndentifier = "CafeCell"
    let kCloseCellHeight: CGFloat = 50
    let kOpenCellHeight: CGFloat = 470
    var cellHeights = [CGFloat]()
    var kCellCount = 0
    var data : [CafeShopItem]!
    
    init(viewModel: CafeListViewModel, tableView: UITableView) {

        cafeListViewModel = viewModel
        cafeTableView = tableView
        
        //Register nib View as TableViewCell
        let nib = UINib(nibName: "CafeTableViewCell", bundle: nil)
        cafeTableView.registerNib(nib, forCellReuseIdentifier: cellIndentifier)
        
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
       // self.cafeTableView.reloadData()
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
                    cellHeights[indexPath.row] = kOpenCellHeight
                    cell.selectedAnimation(true, animated: true, completion: nil)
                    duration = 0.5
                } else {                                            // close cell
                    cellHeights[indexPath.row] = kCloseCellHeight
                    cell.selectedAnimation(false, animated: true, completion: nil)
                    duration = 0.8
                }
                
                UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    }, completion: nil)
        }
    
    func getDistanceText(length:Int32) -> String {
        return length < 1000 ? "Distance: \(length) m" : NSString(format: "Distance: %.2f km", Float32(length)/1000) as String
    }


}
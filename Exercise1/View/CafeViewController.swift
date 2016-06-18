//
//  CafeViewController.swift
//  Exercise1
//
//  Created by Roger Zhang on 16/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//

import UIKit

class CafeViewController: UIViewController, ViewModelForViewControllerDelegate {
    
    private var viewModel: CafeListViewModel!
    private var bindingHelper: TableViewBindingHelper!
    
    //Navigation Bar location title variables
    let locationTitleWidth: CGFloat = 100
    var locationTitleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSLog("View Controller viewDidLoad")
        // Do any additional setup after loading the view.

        //Add navigation bar title for display Current location city name
        if let navigationBar = self.navigationController?.navigationBar {
            let locationTitleFrameX = navigationBar.frame.width/2 - self.locationTitleWidth/2
            let locationTitleFrame = CGRect(x: locationTitleFrameX, y: 0, width: locationTitleWidth, height: navigationBar.frame.height)
            locationTitleLabel = UILabel(frame: locationTitleFrame)
            locationTitleLabel.textAlignment = .Center
            locationTitleLabel.numberOfLines = 2
            locationTitleLabel.text = "Loading..."
            navigationBar.addSubview(locationTitleLabel)
        }
        
        //Bind viewModel
        self.bindViewModel()
        //Load tableview data
        self.loadTableViewData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func bindViewModel() {
        self.viewModel = CafeListViewModel()
        self.viewModel.cafeViewControllerDeleage = self
        self.bindingHelper = TableViewBindingHelper(viewModel: self.viewModel, tableView:self.tableView)
        
    }
    
    func loadTableViewData() {
        self.viewModel.loadCafeShopsData()
    }
    
    //Mark: ViewModelForViewControllerDelegate
    internal func updateMapButton(status: Bool) {
            self.mapButton.enabled = status
    }
    
    internal func updateNavTitle(name: String) {
        //dispatch_sync(dispatch_get_main_queue(), { () -> Void in
            print("updateNavTitle update as \(name)")
            self.locationTitleLabel.text = name
            self.locationTitleLabel?.setNeedsDisplay()
        //})

    }
    
    override func viewWillAppear(animated: Bool) {
        if self.locationTitleLabel != nil {
            self.locationTitleLabel.text = CurrentSpot.shared.cityName
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Push Cafe Shop Map")
        self.locationTitleLabel.text = "Cafe Shops Map"
        self.locationTitleLabel?.setNeedsDisplay()
    }

}
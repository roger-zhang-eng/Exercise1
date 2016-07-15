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
    
    let navBarDefaultText = "Loading..."
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSLog("View Controller viewDidLoad")
        // Do any additional setup after loading the view.

        //Add navigation bar title for default loading
        self.navigationItem.title = navBarDefaultText
        
        //Bind viewModel
        self.bindViewModel()
        //Load tableview data
        self.loadTableViewData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Bind ViewModel
    func bindViewModel() {
        self.viewModel = CafeListViewModel()
        self.viewModel.cafeViewControllerDeleage = self
        self.bindingHelper = TableViewBindingHelper(viewModel: self.viewModel, tableView:self.tableView)
        
    }
    
    //Grab location data and cafe shop data
    func loadTableViewData() {
        self.viewModel.loadCafeShopsData()
    }
    
    //Mark: ViewModelForViewControllerDelegate
    internal func updateMapButton(status: Bool) {
            self.mapButton.enabled = status
    }
    
    internal func updateNavTitle(name: String) {
            print("updateNavTitle update as \(name)")
            self.navigationItem.title = name
    }
    
    override func viewWillAppear(animated: Bool) {
            self.navigationItem.title = CurrentSpot.shared.cityName
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Push Cafe Shop Map")
    }

}
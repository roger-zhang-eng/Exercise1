//
//  CafeListViewModelTests.swift
//  Exercise1
//
//  Created by Roger Zhang on 19/06/2016.
//  Copyright © 2016 Roger.Zhang. All rights reserved.
//
import UIKit
import XCTest
@testable import Exercise1

class CafeListViewModelTests: XCTestCase, CafeListViewModelDelegate, ViewModelForViewControllerDelegate {

    var cafeListViewModelTest: CafeListViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.cafeListViewModelTest = CafeListViewModel()
        self.cafeListViewModelTest.cafeViewControllerDeleage = self
        self.cafeListViewModelTest.cafeListDelegate = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    //--------- CafeListViewModel Test -----------
    
    //Test ShopList initial status
    func testEmpty() {
        let testData = ShopList.shared.items
        XCTAssert(testData.isEmpty)
    }
    
    //Test loadCafeShopsData func, which could detect location based on latitude and longtitude in Simulator, then verify the saved City name in CurrentSpot.shared.cityName
    //Currently check 'Sydney' on lat: -33.8734 lng: 151.206894, please set this in Simulator -> Debug -> Location -> custom Location
    func testSydneyLocation() {
        
        self.cafeListViewModelTest.loadCafeShopsData()
        
        let expectation = self.expectationWithDescription("Sydney Location Test")
        
        //dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC))
        let delayTime:Int64 =  Int64(5 * Double(NSEC_PER_SEC))
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayTime), dispatch_get_main_queue(), {
            print("print CurrentSpot cityName \(CurrentSpot.shared.cityName)")
            XCTAssertTrue(CurrentSpot.shared.cityName == "Sydney")
            expectation.fulfill()
        })
        
        self.waitForExpectationsWithTimeout(8.0, handler: nil)
        
    }
    
    
    func updateCafeTableView() {
        print("In updateCafeTableView.")
    }
    
    func updateMapButton(status: Bool) {
        print("In updateMapButton: status \(status)")
    }
    
    func updateNavTitle(name: String) {
        print("In updateNavTitle: name \(name)")
    }

}

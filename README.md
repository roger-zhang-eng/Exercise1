# Exercise1 

`Exercise1` is an exercise programm, running on iOS platform.

![Exercise1](https://github.com/roger-zhang-eng/Exercise1/blob/master/demo_video/app.gif)

## Demo	

## Requirements
- iOS 10.0+
- Xcode 8.2
- Swift 3.1
- Pod 1.2.0

## Installation Steps
Please use pod to install [CocoaPods](https://cocoapods.org) workspace, based on Podfile.

1) After download source code package, run 'pod install' in the same directory of 'Podfile'

2) Use Xcode 8.2 to open 'Exercise1.xcworkspace'

3) In the Xcode 8.2, build and run the application. If select Simulator, please use Simulator -> Debug -> Location -> custom Location to set position, like Sydney lat: -33.8734 lng: 151.206894.

Note: Simulator location sometimes is not stable, if App detect long time cannot get location, please manuall change Simulator's Location position, that trick can let App get the location data. 
 
## Programm execution demo
There is one video to demostrate the test. '/Exercise1/demo_video/App_Run_video.mov'

## Basic function
- Locate user current position by CoreLocation.
- Get Cafe Shop JSON data by RestKit, which handle connection URL and data decode.
- Display cafe shop informatioin in TableView, and sorted by distance.
- Display cafe shop location in the MapView by MapKit.

Note: The map display in TableViewCell is just snapshot. However, the map in 'Cafe Shops Map' View can support user tap and zoom in/out operations.

## SW architecture
MVVM design pattern, and source code are designed by swift 2.0

1) 'Model' contains:
- web service raw data model, file name label as FSxxx.swift
- shop list data model, file name ShopList.swift
- user position data model, file name UserPosition.swift
- JSON data getting and decoding, file name FSCafeData.swift 


2) 'ViewModel' is responsible for getting model data, and trigger to display TableView and MapView.

3) 'View' only contains TableView and MapView. And TableView use folding cell as TableViewCell.

All the message flow are driven by protocol/delegate.

## Unit Test
As example, in Exercise1Tests, create one ViewModel unit test.

1) testEmpty: check the model data initial state.

2) testSydneyLocation: check location name detection, by XCTestExpectation Asynchronous Testing.
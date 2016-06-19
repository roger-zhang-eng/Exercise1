# SVProgressHUD

`SVProgressHUD` is an exercise programm, running on iOS platform.

## Requirements
- iOS 8.0+
- Xcode 7.3

## Installation Steps
- Pod 0.38.0, to install [CocoaPods](https://cocoapods.org) workspace, based on Podfile.

1) After download source code package, run 'pod install' in the same directory of 'Podfile'
2) User Xcode 7.3 to open 'Exercise1.xcworkspace'
3) In the Xcode 7.3, build and run the application. If use Simulator, please use Simulator -> Debug -> Location -> custom Location to set Sydney position, like lat: -33.8734 lng: 151.206894.
 
## Programm execution
There is one video to demostrate the test. '/Exercise1/demo_video/App_Run_video.mov'

## Basic function
- Locate user current position by CoreLocation.
- Get Cafe Shop JSON data by RestKit.
- Display cafe shop location in the MapView by MapKit.

## SW architecture
MVVM design pattern, and source code are designed by swift 2.0
1) 'Model' contains web service raw data model, shop list data model, and user position data model
2) 'ViewModel' is responsible for getting model data, and trigger to display TableView and MapView.
3) 'View' only contains TableView and MapView. And TableView use folding cell as TableViewCell.
All the message flow are driven by protocol/delegate.

## Unit Test
As example, in Exercise1UI, create one ViewModel unit test.
1) testEmpty: check the model data initial state.
2) testSydneyLocation: check location name detection.
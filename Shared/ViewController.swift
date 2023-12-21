//
//  ViewController.swift
//  dude wheres my car
//
//  Created by Stanley Jeong on 9/17/22.

import GoogleMobileAds
import Foundation
import UIKit
import MapKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    
    @IBOutlet weak var myMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: GADAdSizeBanner)

//        addBannerViewToView(bannerView)
        
        // Test ads
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        // My Ad Unit ID
        bannerView.adUnitID = "ca-app-pub-2377465396084687/4921097109"
        
        // My real adUnitID
//        bannerView.adUnitID = "ca-app-pub-2377465396084687/4921097109"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
        
        let onLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongTapGesture(gestureRecognizer:)))
        
        self.myMap.addGestureRecognizer(onLongTapGesture)
        
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      // Add banner to view and add constraints as above.
      addBannerViewToView(bannerView)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: view.safeAreaLayoutGuide.bottomAnchor,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    @objc func handleLongTapGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: myMap)
            let locationCoordinate = myMap.convert(touchLocation, toCoordinateFrom: myMap)
            
            print("Tapped latitude \(locationCoordinate.latitude), longitude \(locationCoordinate.longitude)")
        }
    }
}

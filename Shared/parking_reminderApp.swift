//
//  parking_reminderApp.swift
//  Shared
//
//  Created by Stanley Jeong on 7/1/22.
//

import GoogleMobileAds
import SwiftUI

@main
struct parking_reminder: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var showAd = true
    
    var body: some Scene {
        WindowGroup {
            VStack {
                ContentView()
                GADBannerViewControllerWrapper(adUnitID: "ca-app-pub-2377465396084687/4921097109", show: $showAd)
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                                    .background(Color(.systemGray6))
                                    .ignoresSafeArea(.all, edges: .bottom)
            }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

import UIKit

struct GADBannerViewControllerWrapper: UIViewRepresentable {
    let adUnitID: String
    @Binding var show: Bool
    
    func makeUIView(context: Context) -> GADBannerView {
        let adView = GADBannerView(adSize: GADAdSizeBanner)
        adView.adUnitID = adUnitID
        adView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        adView.delegate = context.coordinator
        
        let request = GADRequest()
    
        adView.load(request)
        
        return adView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        if show {
            uiView.isHidden = false
        } else {
            uiView.isHidden = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("Ad received!")
        }
    }
}

struct Previews_parking_reminderApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

//
//  MapViewModel.swift
//  dude wheres my car
//
//  Created by Stanley Jeong on 9/14/22.
//
// PRESS BUTTON TO PIN IS HERE

import SwiftUI
import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation,
                                               span: MapDetails.defaultSpan)
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Location services is disabled. Please turn it on in settings!")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Your location is restricted...")
            case .denied:
                print("You have denied this app location. Please change it in settings!")
            case .authorizedAlways, .authorizedWhenInUse:
                // region updates here automatically
            region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? MapDetails.startingLocation,
                                        span: MapDetails.defaultSpan)
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    var savedLocations: [Location] = [
        Location(coordinates: CLLocationCoordinate2D(
            latitude: UserDefaults.standard.double(forKey: "Latitude"),
            longitude: UserDefaults.standard.double(forKey: "Longitude")
        ))
    ]
    
    func pinLocation() {
        print(savedLocations.last!)
        let currLat = locationManager!.location!.coordinate.latitude
        let currLong = locationManager!.location!.coordinate.longitude
        let currCoords = CLLocationCoordinate2D(latitude: currLat, longitude: currLong)
        savedLocations = [
            Location(coordinates: currCoords)
        ]
        UserDefaults.standard.set(currLat, forKey: "Latitude")
        UserDefaults.standard.set(currLong, forKey: "Longitude")
        checkLocationAuthorization()
    }
}

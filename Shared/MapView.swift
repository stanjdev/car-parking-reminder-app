//
//  MapView.swift
//  dude wheres my car
//
//  Created by Stanley Jeong on 8/7/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View {
        Map(coordinateRegion: $mapViewModel.region, showsUserLocation: true, annotationItems: mapViewModel.savedLocations) { location in
            MapMarker(coordinate: location.coordinates, tint: .blue)
//            MapPin(coordinate: location.coordinates, tint: .green)
        }.ignoresSafeArea()
        .accentColor(Color(.systemOrange))
        .onAppear() {
                mapViewModel.checkIfLocationServicesIsEnabled()
        }
        Button("Pin current location") {
            mapViewModel.pinLocation()
        }.buttonStyle(.borderedProminent)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}


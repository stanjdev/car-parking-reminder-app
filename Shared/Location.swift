//
//  Location.swift
//  dude wheres my car (iOS)
//
//  Created by Stanley Jeong on 9/19/22.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let coordinates: CLLocationCoordinate2D
}

//struct Coordinate: Hashable, Codable {
//    var latitude: Double
//    var longitude: Double
//
//    init(latitude: Double, longitude: Double) {
//        self.latitude = latitude
//        self.longitude = longitude
//    }
//}

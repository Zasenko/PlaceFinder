//
//  Place.swift
//  PlaceFinder
//
//  Created by Dmitry Zasenko on 31.05.23.
//

import Foundation
import MapKit

struct Place: Identifiable {
    var id = UUID().uuidString
    var placemark: CLPlacemark
}

//
//  GeocodingViewModel.swift
//  Roamer
//
//  Created by Ivona Perko on 23.05.2024..
//

import Foundation
import CoreLocation

class GeocodingViewModel: ObservableObject {
    @Published var coordinate: CLLocationCoordinate2D?
    
    private let geocoder = CLGeocoder()
    
    func geocode(address: String) {
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            if let placemark = placemarks?.first,
               let location = placemark.location {
                DispatchQueue.main.async {
                    self?.coordinate = location.coordinate
                }
            } else {
                print("Geocoding error: \(String(describing: error))")
            }
        }
    }
}

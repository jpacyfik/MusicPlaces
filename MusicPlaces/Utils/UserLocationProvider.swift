//
//  UserLocationProvider.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import MapKit

class UserLocationProvider {
    private let locationManager = CLLocationManager()
    static let shared: UserLocationProvider = UserLocationProvider()

    func configure() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }

    var userLocation: CLLocation? {
        return self.locationManager.location
    }

    static func calculateDistanceTo(_ coordinate: CLLocationCoordinate2D) -> String {
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        guard let userLocation = UserLocationProvider.shared.userLocation else { return "unknown" }
        let distanceInMeters = userLocation.distance(from: destination)
        return getFormattedDistanceString(distanceInMeters)
    }

    private static func getFormattedDistanceString(_ meters: Double) -> String {
        let distance = meters.rounded()
        switch distance {
        case 0...1000:
            return "\(Int(distance)) m"
        default:
            return "\(Int(distance) / 1000) km"
        }
    }
}


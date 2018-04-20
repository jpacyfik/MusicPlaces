//
//  PlaceMarker.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import MapKit

class PlaceMarker: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 0)

            let label = UILabel()
            label.text = "MP"
            label.setCorner(radius: 4)
            label.backgroundColor = label.tintColor
            label.sizeToFit()

            rightCalloutAccessoryView = label
            markerTintColor = label.tintColor
            glyphText = "MP"
        }
    }
}

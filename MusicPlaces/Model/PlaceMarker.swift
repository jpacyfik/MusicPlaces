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
            label.textColor = UIColor.white
            label.setCorner(radius: 4)
            label.backgroundColor = label.tintColor
            label.sizeToFit()

            rightCalloutAccessoryView = label
            markerTintColor = label.tintColor
            glyphText = "MP"
        }
    }
}

extension MKAnnotation {
    public var openedDateString: String {
        guard let place = self as? Place, let year = place.lifeSpan?.begin else {
            return "unknown"
        }

        return "Opened in \(year)"
    }
}

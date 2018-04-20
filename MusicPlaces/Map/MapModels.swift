//
//  MapModels.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright (c) 2018 Jakub Pawelski. All rights reserved.
//

import MapKit

enum Map {
    enum SearchPlaces {
        struct Request {
            let searchPhrase: String
        }

        struct Response {
            let places: [Place]
        }

        struct ViewModel {
            let annotations: [MKAnnotation]
        }
    }
}

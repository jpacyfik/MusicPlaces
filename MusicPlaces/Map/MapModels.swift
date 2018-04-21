//
//  MapModels.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright (c) 2018 Jakub Pawelski. All rights reserved.
//

import MapKit

struct Map {
    struct SearchPlaces {
        struct Request {
            let searchPhrase: String
        }

        struct Response {
            let places: [Place]
            let shouldResetAnnotations: Bool
        }

        struct ViewModel {
            let shouldResetAnnotations: Bool
            let annotations: [MKAnnotation]
        }
    }

    struct RemovePlace {
        struct Response {
            let place: Place
        }

        struct ViewModel {
            let annotation: MKAnnotation
        }
    }
}

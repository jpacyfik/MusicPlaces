//
//  MapPresenter.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright (c) 2018 Jakub Pawelski. All rights reserved.
//

import UIKit

protocol MapPresentationLogic {
    func addPlacesToDataSource(_ response: Map.SearchPlaces.Response)
    func removePlaceFromDataSource(_ response: Map.RemovePlace.Response)
}

class MapPresenter: MapPresentationLogic {
    weak var viewController: MapDisplayLogic?

    func addPlacesToDataSource(_ response: Map.SearchPlaces.Response) {
        let viewModel = Map.SearchPlaces.ViewModel(shouldResetAnnotations: response.shouldResetAnnotations, annotations: response.places)
        viewController?.addAnotationsToMap(viewModel)
    }

    func removePlaceFromDataSource(_ response: Map.RemovePlace.Response) {
        let viewModel = Map.RemovePlace.ViewModel(annotation: response.place)
        viewController?.removeAnnotationFromMap(viewModel)
    }
}

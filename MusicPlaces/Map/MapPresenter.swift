//
//  MapPresenter.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright (c) 2018 Jakub Pawelski. All rights reserved.
//

import UIKit

protocol MapPresentationLogic {
    func addPlacesToDataSource(_ response: Map.SearchPlaces.Response)
}

class MapPresenter: MapPresentationLogic {
    weak var viewController: MapDisplayLogic?

    func addPlacesToDataSource(_ response: Map.SearchPlaces.Response) {
        let viewModel = Map.SearchPlaces.ViewModel(annotations: response.places)
        viewController?.addAnotationsToMap(viewModel)
    }
}

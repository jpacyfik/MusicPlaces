//
//  MapInteractor.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright (c) 2018 Jakub Pawelski. All rights reserved.
//

import UIKit

protocol MapBusinessLogic {
    func searchPlaces(_ request: Map.SearchPlaces.Request)
}

protocol MapDataManager: class {
    func addPlaces(_ places: [Place], _ shouldRemoveAllAnnotations: Bool)
}

class MapInteractor: MapBusinessLogic, MapDataManager {
    var presenter: MapPresentationLogic?

    private let placesQueue: OperationQueue = OperationQueue()

    func configureQueue() {
        placesQueue.qualityOfService = .utility
    }

    func searchPlaces(_ request: Map.SearchPlaces.Request) {
        let worker = MapWorker()
        worker.scheduleFetchOperation(request.searchPhrase, queue: self.placesQueue, offset: 0, mapManager: self)
    }

    func addPlaces(_ places: [Place], _ shouldRemoveAllAnnotations: Bool) {
        let response = Map.SearchPlaces.Response(places: places, shouldResetAnnotations: shouldRemoveAllAnnotations)
        presenter?.addPlacesToDataSource(response)
    }
}

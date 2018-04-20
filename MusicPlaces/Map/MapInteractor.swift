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
    func addPlaces(_ places: [Place])
}

class MapInteractor: MapBusinessLogic, MapDataManager {
    var presenter: (MapPresentationLogic)?
    var worker: MapWorker?

    private let placesQueue: OperationQueue = OperationQueue()

    func configureQueue() {
        placesQueue.qualityOfService = .utility
    }

    func searchPlaces(_ request: Map.SearchPlaces.Request) {
        let urlString = RequestURLFactory.generatePlaceURLString(request.searchPhrase, offset: 0)

        let fetchOperation = FetchPlacesOperation(urlString, APIProvider())
        let saveOperation = SavePlacesOperation(self)

        fetchOperation.queuePriority = .low
        saveOperation.queuePriority = .high

        fetchOperation.completionBlock = {
            saveOperation.placesToSave = fetchOperation.fetchedPlaces
        }

        saveOperation.addDependency(fetchOperation)
        placesQueue.addOperations([fetchOperation, saveOperation], waitUntilFinished: false)
    }

    func addPlaces(_ places: [Place]) {
        let response = Map.SearchPlaces.Response(places: places)
        presenter?.addPlacesToDataSource(response)
    }
}

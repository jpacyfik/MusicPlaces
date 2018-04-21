//
//  MapInteractor.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright (c) 2018 Jakub Pawelski. All rights reserved.
//

import UIKit

protocol MapBusinessLogic {
    func searchPlaces(_ request: Map.SearchPlaces.Request)
}

protocol MapDataManager: class {
    func addPlaces(_ places: [Place], _ shouldRemoveAllAnnotations: Bool)
    func removePlace(_ place: Place)
}

class MapInteractor: MapBusinessLogic, MapDataManager {
    var presenter: MapPresentationLogic?

    private let placesQueue: OperationQueue = OperationQueue()


    func configureQueue() {
        placesQueue.qualityOfService = .utility
    }

    func searchPlaces(_ request: Map.SearchPlaces.Request) {
        placesQueue.cancelAllOperations()

        let worker = MapWorker()
        worker.scheduleFetchOperation(request.searchPhrase, queue: placesQueue, offset: 0, mapManager: self)
    }

    func addPlaces(_ places: [Place], _ shouldRemoveAllAnnotations: Bool) {
        let response = Map.SearchPlaces.Response(places: places, shouldResetAnnotations: shouldRemoveAllAnnotations)
        presenter?.addPlacesToDataSource(response)

        if AppSettings.shouldFilterPlacesByDateAndRemovedAfterTime {
            let worker = MapWorker()
            places.forEach({worker.scheduleRemoveOperation($0, self.placesQueue, self)})
        }
    }

    func removePlace(_ place: Place) {
        guard let lifeTime = place.lifeSpan?.lifeTime else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + lifeTime) {
            let response = Map.RemovePlace.Response(place: place)
            self.presenter?.removePlaceFromDataSource(response)
        }
    }
}

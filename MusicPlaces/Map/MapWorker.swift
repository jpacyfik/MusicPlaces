//
//  MapWorker.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright (c) 2018 Jakub Pawelski. All rights reserved.
//

import UIKit

class MapWorker {
    func scheduleFetchOperation(_ searchPhrase: String, queue: OperationQueue, offset: Int, mapManager: MapDataManager) {
        let fetchOperation = FetchPlacesOperation(searchPhrase, APIProvider(), queue, mapManager, offset)
        let saveOperation = SavePlacesOperation()

        fetchOperation.queuePriority = .low
        saveOperation.queuePriority = .high

        fetchOperation.completionBlock = {
            saveOperation.placesToSave = fetchOperation.fetchedPlaces
            saveOperation.mapManager = fetchOperation.mapManager
            saveOperation.shouldRemoveAllAnnotations = fetchOperation.shouldRemoveAllAnnotations
        }

        saveOperation.addDependency(fetchOperation)
        queue.addOperations([fetchOperation, saveOperation], waitUntilFinished: false)
    }

    func createOffsetRequests(_ resultCount: Int, searchPhrase: String, queue: OperationQueue, mapManager: MapDataManager) {
        let offsetsForRequests: [Int] = calculateOffsets(resultCount)

        for offset in offsetsForRequests {
            scheduleFetchOperation(searchPhrase, queue: queue, offset: offset, mapManager: mapManager)
        }
    }

    func scheduleRemoveOperation(_ place: Place, _ queue: OperationQueue, _ mapManager: MapDataManager) {
        let removeOperation = RemovePlaceOperation(place, mapManager)
        removeOperation.queuePriority = .high
        queue.addOperation(removeOperation)
    }

    func calculateOffsets(_ resultCount: Int) -> [Int] {
        var offsets: [Int] = []

        let numberOfOffsetsDobule = (Double(resultCount) / Double(AppSettings.defaultRequestLimit))
        let numberOfOffsets = Int(numberOfOffsetsDobule.rounded(.up))

        guard numberOfOffsets != 0 else {
            return []
        }

        for number in 1...(numberOfOffsets - 1) {
            let currentOffset = (number * AppSettings.defaultRequestLimit)
            offsets.append(currentOffset)
        }

        return offsets
    }
}



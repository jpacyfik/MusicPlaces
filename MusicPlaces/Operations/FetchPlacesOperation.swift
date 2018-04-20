//
//  FetchPlacesOperation.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

final class FetchPlacesOperation: AppOperation {
    private let provider: APIProvider
    private let offset: Int
    private let searchPhrase: String

    weak var parentQueue: OperationQueue?
    weak var mapManager: MapDataManager?

    private var urlString: String {
        return RequestURLFactory.generatePlaceURLString(searchPhrase, offset: offset)
    }

    var shouldRemoveAllAnnotations: Bool = false
    
    var fetchedPlaces: [Place] = []
    
    init(_ searchPhrase: String, _ provider: APIProvider, _ operationQueue: OperationQueue, _ mapManager: MapDataManager?, _ offset: Int = 0) {
        self.provider = provider
        self.offset = offset
        self.searchPhrase = searchPhrase
        self.parentQueue = operationQueue
        self.mapManager = mapManager
    }
    
    override func main() {
        guard !isCancelled else {
            finish(true)
            return
        }
        
        executing(true)
        
        provider.performRequest(urlString) { [weak self] (result) in
            switch result {
            case .failure(error: let error):
                print(error.localizedDescription)
                self?.executing(false)
                self?.cancel()
            case .success(data: let fetchedData):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(APIPlacesResponse.self, from: fetchedData)
                    self?.shouldRemoveAllAnnotations = (response.offset == 0)
                    self?.generateMoreRequestsIfNeeded(response)
                    self?.fetchedPlaces = response.places
                    self?.executing(false)
                    self?.finish(true)
                } catch {
                    self?.executing(false)
                    self?.cancel()
                }
            }
        }
    }

    func generateMoreRequestsIfNeeded(_ response: APIPlacesResponse) {
        guard response.count > AppSettings.defaultRequestLimit && response.offset == 0 else {
            // ALL PLACES DOWNLOADED ON INITIAL FETCH
            return
        }

        guard let mapManager = mapManager, let queue = parentQueue else {
            return
        }

        MapWorker().createOffsetRequests(response.count, searchPhrase: searchPhrase, queue: queue, mapManager: mapManager)
    }
}

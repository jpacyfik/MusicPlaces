//
//  FetchPlacesOperation.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

final class FetchPlacesOperation: AppOperation {
    private let urlString: String
    private let provider: APIProvider
    
    var fetchedPlaces: [Place] = []
    
    init(_ urlString: String, _ provider: APIProvider) {
        self.urlString = urlString
        self.provider = provider
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
}

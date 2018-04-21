//
//  APIProvider.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

enum APIProviderError: Error {
    case invalidURLString
    case dataTaskError(String)
    case noData
    
    var localizedDescription: String {
        return "Something went wrong"
    }
}

enum APIProviderResult {
    case success(data: Data)
    case failure(error: APIProviderError)
}

final class APIProvider {
    func performRequest(_ urlString: String, didFinish: @escaping (APIProviderResult) -> Void) {
        guard let url = URL(string: urlString) else {
            didFinish(.failure(error: .invalidURLString))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let dataError = error {
                didFinish(.failure(error: .dataTaskError(dataError.localizedDescription)))
                return
            }
            
            guard let data = data else {
                didFinish(.failure(error: .noData))
                return
            }
            
            didFinish(.success(data: data))
        }.resume()
    }
}

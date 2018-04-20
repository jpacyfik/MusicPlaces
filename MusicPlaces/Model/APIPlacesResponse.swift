//
//  APIPlacesResponse.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

struct APIPlacesResponse: Decodable {
    let count: Int
    let offset: Int
    let places: [Place]

    enum CodingKeys: String, CodingKey {
        case places, count, offset
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        count = try container.decode(Int.self, forKey: CodingKeys.count)
        offset = try container.decode(Int.self, forKey: CodingKeys.offset)
        places = try container.decode([FailableDecodable<Place>].self, forKey: .places).flatMap({$0.base})
    }
}

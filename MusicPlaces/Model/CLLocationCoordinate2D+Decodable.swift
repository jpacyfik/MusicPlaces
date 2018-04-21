//
//  CLLocationCoordinate2D+Decodable.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D: Decodable {
    enum CodingKeys: String, CodingKey {
        case longitude, latitude
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let latitudeString = try container.decode(String.self, forKey: CodingKeys.latitude)
        let longitudeString = try container.decode(String.self, forKey: CodingKeys.longitude)

        guard let latitude = Double(latitudeString), let longitude = Double(longitudeString) else {
            let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.longitude, CodingKeys.latitude],
                                                debugDescription: "Could not parse location to proper type")
            throw DecodingError.dataCorrupted(context)
        }

        self.longitude = longitude
        self.latitude = latitude
    }
}

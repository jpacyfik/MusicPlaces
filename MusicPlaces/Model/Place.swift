//
//  Place.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import MapKit

final class Place: NSObject, Decodable, MKAnnotation {
    let name: String
    let address: String?
    let id: String
    let coordinate: CLLocationCoordinate2D
    let lifeSpan: LifeSpan?

    var title: String? {
        return name
    }

    var subtitle: String? {
        return address
    }

    enum CodingKeys: String, CodingKey {
        case id, address, name, lifeSpan = "life-span", coordinate = "coordinates"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(String.self, forKey: .id)
        address = try container.decode(String.self, forKey: .address)
        lifeSpan = try container.decode(LifeSpan.self, forKey: .lifeSpan)
        coordinate = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinate)
    }
}


struct LifeSpan: Decodable {
    let begin: Int
    var lifeTime: Double {
        return Double(begin - AppSettings.beginYearFilter)
    }

    enum CodingKeys: String, CodingKey {
        case begin
    }

    public init(from decoder: Decoder) throws {
        guard AppSettings.shouldFilterPlacesByDateAndRemovedAfterTime else {
            // No need to set cuz it's not going to be used.
            // Moreover most of the places have nil 'life-span' dictionary, so we wil avoid unwanted throws (not-parsed objects)
            self.begin = 0
            return
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let begin = try container.decode(String.self, forKey: .begin)

        guard let beginYear = Int(begin), beginYear >= AppSettings.beginYearFilter else {
            let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.begin],
                                                debugDescription: "Could not parse begin to proper type")
            throw DecodingError.dataCorrupted(context)
        }

        self.begin = beginYear
    }
}

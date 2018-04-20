//
//  Place.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import MapKit

final class Place: NSObject, Decodable, MKAnnotation {
    let name: String
    let address: String?
    let id: String
    let coordinate: CLLocationCoordinate2D

    var title: String? {
        return name
    }

    var subtitle: String? {
        return address
    }

    enum CodingKeys: String, CodingKey {
        case id, address, name, coordinate = "coordinates"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: CodingKeys.name)
        id = try container.decode(String.self, forKey: CodingKeys.id)
        address = try container.decode(String.self, forKey: CodingKeys.address)
        coordinate = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinate)
    }
}


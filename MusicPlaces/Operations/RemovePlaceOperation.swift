//
//  RemovePlaceOperation.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

final class RemovePlaceOperation: AppOperation {
    weak var mapManager: MapDataManager?
    let place: Place

    override func main() {
        guard !isCancelled else {
            finish(true)
            return
        }

        executing(true)

        mapManager?.removePlace(place)
        executing(false)
        finish(true)
    }

    init(_ place: Place, _ mapManager: MapDataManager) {
        self.place = place
        self.mapManager = mapManager
    }
}

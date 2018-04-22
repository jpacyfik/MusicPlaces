//
//  AppSettings.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

struct AppSettings {
    // Request page size
    static var defaultRequestLimit: Int = 100

    // Enabling and disabling filtering recieved places by 'beginYearFilter' year and 'marker removing' feature
    static var shouldFilterPlacesByDateAndRemovedAfterTime: Bool = false

    // Reference date used in filtering. Useless when @up flag is disabled
    static var beginYearFilter: Int = 1990
}

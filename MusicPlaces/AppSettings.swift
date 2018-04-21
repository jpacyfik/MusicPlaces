//
//  AppSettings.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

struct AppSettings {
    // Request page size
    static var defaultRequestLimit: Int = 25

    // Enabling and disabling filtering recieved places by 'beginYearFilter' year and wipping out feature
    static let shouldFilterPlacesByDateAndWipeOutAfterTime: Bool = true

    // Reference date used in filtering. Useless when @up flag is disabled
    static let beginYearFilter: Int = 1000
}

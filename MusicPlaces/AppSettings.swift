//
//  AppSettings.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

struct AppSettings {
    static var defaultRequestLimit: Int = 25
    static let shouldRemoveAnnotationsAfterTime: Bool = true
    static let shouldFilterPlacesByBeginDate: Bool = true
    static let beginYearFilter: Int = 1990
}

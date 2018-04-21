//
//  SavePlacesOperation.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 21/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

final class SavePlacesOperation: AppOperation {
    weak var mapManager: MapDataManager?
    
    var placesToSave: [Place] = []
    var shouldRemoveAllAnnotations: Bool = false
    
    override func main() {
        guard !isCancelled else {
            finish(true)
            return
        }

        executing(true)

        mapManager?.addPlaces(placesToSave, shouldRemoveAllAnnotations)
        executing(false)
        finish(true)
    }
}

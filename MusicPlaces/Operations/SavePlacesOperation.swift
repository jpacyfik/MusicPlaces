//
//  SavePlacesOperation.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

final class SavePlacesOperation: AppOperation {
    weak var mapManager: MapDataManager?
    
    var placesToSave: [Place] = []
    var shouldRemoveAllAnnotations: Bool = false
    
    override func main() {
        self.mapManager?.addPlaces(placesToSave, shouldRemoveAllAnnotations)
        self.executing(false)
        self.finish(true)
    }
}

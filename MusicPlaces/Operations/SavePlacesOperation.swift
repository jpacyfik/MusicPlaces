//
//  SavePlacesOperation.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import Foundation

final class SavePlacesOperation: AppOperation {
    private weak var dataStore: MapDataManager?
    
    var placesToSave: [Place] = []
    
    init(_ dataStore: MapDataManager) {
        self.dataStore = dataStore
    }
    
    override func main() {
        print("CALLED")
        self.dataStore?.addPlaces(placesToSave)
        self.executing(false)
        self.finish(true)
    }
}

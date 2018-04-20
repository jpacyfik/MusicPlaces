//
//  MapRouter.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright (c) 2018 Jakub Pawelski. All rights reserved.
//

import UIKit

@objc protocol MapRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol MapDataPassing {
}

class MapRouter: NSObject, MapRoutingLogic, MapDataPassing {
    weak var viewController: MapViewController?
}

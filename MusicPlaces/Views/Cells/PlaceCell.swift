//
//  PlaceCell.swift
//  MusicPlaces
//
//  Created by Jakub Pawelski on 20/04/2018.
//  Copyright © 2018 Jakub Pawelski. All rights reserved.
//

import MapKit

class PlaceCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    func setCell(_ annotation: MKAnnotation) {
        nameLabel.text = annotation.title ?? ""
        distanceLabel.text = UserLocationProvider.calculateDistanceTo(annotation.coordinate)
    }
}

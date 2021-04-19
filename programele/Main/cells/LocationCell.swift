//
//  LocationCell.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import UIKit
import RxSwift
import RxCocoa

final class LocationCell: UITableViewCell {

    @IBOutlet var clubNameLabel: UILabel!
    @IBOutlet var clubWorkingHoursLabel: UILabel!
    
    func setup(location: Location) {
        clubNameLabel.text = location.name
        clubWorkingHoursLabel.text = location.workHours.uppercased()
    }
    
}

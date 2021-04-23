//
//  ActivityListCell.swift
//  programele
//
//  Created by Agne on 2021-04-22.
//

import UIKit

final class ActivityListCell: UITableViewCell {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    
    func setup(activities: ActivitiesRegistration) {
        nameLabel.text = activities.name
        dateLabel.text = activities.date.convertToString
    }
}

extension Date {
    var convertToString: String {
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        
        // Set Date/Time Style
        dateFormatter.dateFormat = "YY/MM/dd"
       // dateFormatter.dateStyle = .short
        
        // Convert Date to String
        return dateFormatter.string(from: self)
    }
}

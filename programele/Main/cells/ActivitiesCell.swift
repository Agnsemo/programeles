//
//  ActivitiesCell.swift
//  programele
//
//  Created by Agne on 2021-03-14.
//

import UIKit
import RxSwift
import RxCocoa

final class ActivitiesCell: UITableViewCell {
    
    @IBOutlet private var backgroundImage: UIImageView!
    @IBOutlet private var title: UILabel!
    
    func setup(activities: Activities) {
        title.text = activities.title
        
        guard let url = URL(string: activities.image) else { return }
        backgroundImage.load(url: url)
        backgroundImage.isHidden = false
    }
}

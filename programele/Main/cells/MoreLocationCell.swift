//
//  MoreLocationCell.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import UIKit

final class MoreLocationCell: UITableViewCell {

    @IBOutlet private var clubCity: UILabel!
    @IBOutlet private var clubName: UILabel!
    @IBOutlet private var gpsButton: UIButton!
    @IBOutlet private var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
    }
    
    func setup(location: Location) {
        clubCity.text = location.city
        clubName.text = location.name
    }
}

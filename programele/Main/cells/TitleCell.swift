//
//  TitleCell.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import UIKit

final class TitleCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    
    func setup(title: String) {
        titleLabel.text = title
    }
}

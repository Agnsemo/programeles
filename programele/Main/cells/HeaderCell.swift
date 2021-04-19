//
//  HeaderCell.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import UIKit

final class HeaderCell: UITableViewCell {

    @IBOutlet private var heyLabel: UILabel!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var mainView: UIView! 
    
    func setup(user: User) {
        heyLabel.text = "Sveiki!"
        userNameLabel.text = user.name.uppercased() + " " + user.surname.uppercased()
    }
}

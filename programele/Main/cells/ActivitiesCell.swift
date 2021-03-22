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
    
    private let disposeBag = DisposeBag()
  
    func setup(activities: Activities) {
        
        //backgroundImage.image = activities.image
        title.text = activities.title
    }
}

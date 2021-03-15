//
//  ActivityDetailsVC.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import UIKit

final class ActivityDetailsVC: UIViewController {

    @IBOutlet private var mainView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UITextView!
    @IBOutlet private var imageView: UIImageView!
    
    var activity: Activities!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = activity.title
        imageView.image = activity.image
        descriptionLabel.text = activity.description
        mainView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)

    }
}

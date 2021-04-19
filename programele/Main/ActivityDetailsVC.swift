//
//  ActivityDetailsVC.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import UIKit
import RxSwift
import RxCocoa

final class ActivityDetailsVC: UIViewController {

    @IBOutlet private var mainView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UITextView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var registrationButton: UIButton!
    
    var activity: Activities!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = activity.title
        descriptionLabel.text = activity.description
        mainView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        
        guard let url = URL(string: activity.image) else { return }
        imageView.load(url: url)
        
        registrationButton.rx.tapDriver
            .driveNext(self, ActivityDetailsVC.openRegistrationVC)

    }
    
    private func openRegistrationVC() {
        performSegue(withIdentifier: "RegistrationVC", sender: activity.title)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? RegistrationVC)?.activity = sender as? String
    }
}

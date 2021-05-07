//
//  RegistrationVC.swift
//  programele
//
//  Created by Agne on 2021-04-19.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyUserDefaults

final class RegistrationVC: UIViewController {

    @IBOutlet private var mainView: UIView!
    @IBOutlet private var activityName: UILabel!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var okButton: LoadingButton!
    @IBOutlet private var timeLabel: UILabel!
    
    var activity: Activities!
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isLoadingDriver: Driver<Bool> {
        return isLoading.asDriver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateRegistration()
        setupDatePicker()
        activityName.text = activity.title
        mainView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        keyboardAdjust(scrollView)
        
        okButton.rx.tapDriver
            .driveNext(self, RegistrationVC.saveDate)
        
        print("ASD", isLoading.value)
        
        isLoadingDriver
            .drive(okButton.rx.isLoading)
            .disposed(by: rx.disposeBag)
        
        timeLabel.text = activity.time
        
    }
    
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        
    }
    
    private func saveDate() {
        isLoading.accept(true)
        let date = datePicker.date
        activitiesRegistrationArray.append(ActivitiesRegistration(name: activity.title, date: date, time: activity.time))
        activitiesRegistrationRelay.accept(activitiesRegistrationArray)
        Defaults.registration = activitiesRegistrationArray
        popToRootVC()
    }
}

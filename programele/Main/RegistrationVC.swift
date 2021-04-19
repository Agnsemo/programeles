//
//  RegistrationVC.swift
//  programele
//
//  Created by Agne on 2021-04-19.
//

import UIKit

final class RegistrationVC: UIViewController {

    @IBOutlet private var mainView: UIView!
    @IBOutlet private var activityName: UILabel!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var okButton: UIButton!
    
    var activity: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatePicker()
        activityName.text = activity
        mainView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        keyboardAdjust(scrollView)
        
    }
    
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        
    }
}

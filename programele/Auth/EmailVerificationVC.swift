//
//  EmailVerificationVC.swift
//  programele
//
//  Created by Agne on 2021-03-09.
//

import UIKit

final class EmailVerificationVC: UIViewController, UITextFieldDelegate {

    @IBOutlet private var mainView: UIView!
    @IBOutlet private var email: UITextField!
    @IBOutlet private var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        email.becomeFirstResponder()
        email.delegate = self
        
        okButton.rx.tapDriver
            .drive(onNext: Weakly(self, EmailVerificationVC.openSignUp))
    }
    
    private func setup() {
        email.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        okButton.backgroundColor = UIColor.appPurple
        email.layer.cornerRadius = 20
        okButton.layer.cornerRadius = 20
    }
    
    private func openSignUp() {
        performSegue(withIdentifier: "SignUpVC", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            email.resignFirstResponder()
            openSignUp()
        }
        return false
    }
}

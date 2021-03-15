//
//  SignUpVC.swift
//  programele
//
//  Created by Agne on 2021-03-09.
//

import UIKit

final class SignUpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private var mainView: UIView!
    @IBOutlet private var nameSurname: UITextField!
    @IBOutlet private var password: UITextField!
    @IBOutlet private var passwordSecond: UITextField!
    @IBOutlet private var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        nameSurname.becomeFirstResponder()
        nameSurname.delegate = self
        password.delegate = self
        passwordSecond.delegate = self
        
        okButton.rx.tapDriver
            .drive(onNext: Weakly(self, SignUpVC.openHome))
    }
    
    private func setup() {
        nameSurname.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        password.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        passwordSecond.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        okButton.backgroundColor = UIColor.appPurple
        okButton.layer.cornerRadius = 20
        nameSurname.layer.cornerRadius = 20
        password.layer.cornerRadius = 20
        passwordSecond.layer.cornerRadius = 20
    }
    
    private func openHome() {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameSurname {
            password.becomeFirstResponder()
        } else if textField == password {
            passwordSecond.becomeFirstResponder()
        } else if textField == passwordSecond {
            passwordSecond.resignFirstResponder()
            openHome()
        }
        
        return false
    }
}

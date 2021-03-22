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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? SignUpVC)?.email = sender as? String
    }
    
    private func openSignUp() {
        let users = db.readUser()
        guard let e = email.text, !e.isEmpty else {
            alert(title: "Privalote užpildyti visus laukelius")
            return }
        
        if users.isEmpty {
            performSegue(withIdentifier: "SignUpVC", sender: e)
        }
        
        users.forEach { user in
            if e == user.email {
                alert(title: "Pašto adresas jau egzistuoja")
            } else {
                performSegue(withIdentifier: "SignUpVC", sender: e)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            email.resignFirstResponder()
            openSignUp()
        }
        return false
    }
}

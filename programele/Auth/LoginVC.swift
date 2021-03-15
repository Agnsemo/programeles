//
//  LoginVC.swift
//  programele
//
//  Created by Agne on 2021-03-09.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet private var mainView: UIView!
    @IBOutlet private var email: UITextField!
    @IBOutlet private var password: UITextField!
    @IBOutlet private var okButton: UIButton!
    @IBOutlet private var register: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        email.delegate = self
        password.delegate = self
        email.becomeFirstResponder()
       
        
        okButton.rx.tapDriver
            .drive(onNext: Weakly(self, LoginVC.openHome))
        
        register.rx.tapDriver
            .drive(onNext: Weakly(self, LoginVC.openSignUp))
        
    }
    
    private func setup() {
        email.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        password.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        okButton.backgroundColor = UIColor.appPurple
        email.layer.cornerRadius = 20
        password.layer.cornerRadius = 20
        okButton.layer.cornerRadius = 20
        
    }
    
    private func openHome() {
        let homieNav = HomeVC.createFrom(storyboard: "Main", identifier: "Main") as! UINavigationController
        //(homieNav.topViewController as! HomeViewController).homeVM = HomeVM(user: user)
        
        UIApplication.shared.windows.first?.rootViewController = homieNav
    }
    
    private func openSignUp() {
        performSegue(withIdentifier: "LoginVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            password.becomeFirstResponder()
        } else if textField == password {
            password.resignFirstResponder()
            openHome()
        }

        return false
    }
}

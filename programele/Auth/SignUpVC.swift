//
//  SignUpVC.swift
//  programele
//
//  Created by Agne on 2021-03-09.
//

import UIKit
import SwiftyUserDefaults

final class SignUpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private var mainView: UIView!
    @IBOutlet private var name: UITextField!
    @IBOutlet private var password: UITextField!
    @IBOutlet private var passwordSecond: UITextField!
    @IBOutlet private var okButton: UIButton!
    @IBOutlet private var username: UITextField!
    @IBOutlet private var surname: UITextField!
    
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        name.becomeFirstResponder()
        name.delegate = self
        surname.delegate = self
        username.delegate = self
        password.delegate = self
        passwordSecond.delegate = self
        
        okButton.rx.tapDriver
            .drive(onNext: Weakly(self, SignUpVC.openHome))
    }
    
    private func setup() {
        name.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        surname.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        username.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        password.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        passwordSecond.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        okButton.backgroundColor = UIColor.appPurple
        okButton.layer.cornerRadius = 20
        name.layer.cornerRadius = 20
        surname.layer.cornerRadius = 20
        username.layer.cornerRadius = 20
        password.layer.cornerRadius = 20
        passwordSecond.layer.cornerRadius = 20
    }
    
    private func openHome() {
        var id = 0
        let readUser = db.readUser()
        for u in readUser {
            if id == u.id || id < u.id {
                id = id + 1
            } else {
                id = u.id
            }
        }
        
        guard let n = name.text, !n.isEmpty, let s = surname.text, !s.isEmpty, let u = username.text, !u.isEmpty, let p = password.text, !p.isEmpty, let pt = passwordSecond.text, !pt.isEmpty else {
            alert(title: "Privalote užpildyti visus laukelius")
            return }
        
        if !checkPassword(password: p, secondPassword: pt) {
            alert(title: "Jusų slaptažodžiai nesutampa")
            print("ASD", p, pt)
        } else {
            let user = User(id: id, name: n, email: email, surname: s, password: p, secondPassword: pt, userName: u)
            db.insertUser(id: id, name: n, email: email, surname: s, password: p, username: u)
            Defaults.user = user
            userRelay.accept(user)
            let homieNav = HomeVC.createFrom(storyboard: "Main", identifier: "Main") as! UINavigationController
            (homieNav.topViewController as! HomeVC).user = user
            UIApplication.shared.windows.first?.rootViewController = homieNav
        }
    }
    
    private func checkPassword(password: String, secondPassword: String) -> Bool {
        if password == secondPassword {
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == name {
            surname.becomeFirstResponder()
        } else if textField == surname {
            username.becomeFirstResponder()
        } else if textField == username {
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

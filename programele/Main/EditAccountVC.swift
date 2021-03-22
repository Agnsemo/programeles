//
//  EditAccountVC.swift
//  programele
//
//  Created by Agne on 2021-03-22.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyUserDefaults

final class EditAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private var mainView: UIView!
    @IBOutlet private var userName: UITextField!
    @IBOutlet private var name: UITextField!
    @IBOutlet private var surname: UITextField!
    @IBOutlet private var okButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        name.delegate = self
        surname.delegate = self
        
        setup()
        setupUserData()
        
        dismissKeyboardOnTap()
        
        okButton.tapDriver
            .drive(onNext: Weakly(self, EditAccountVC.saveUserData))
    }
    
    private func setupUserData() {
        userName.text = userRelay.value?.userName
        name.text = userRelay.value?.name
        surname.text = userRelay.value?.surname
    }
    
    private func setup() {
        userName.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        name.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        surname.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        okButton.backgroundColor = .appPurple
        userName.layer.cornerRadius = 20
        name.layer.cornerRadius = 20
        surname.layer.cornerRadius = 20
        userName.layer.cornerRadius = 20
        name.layer.cornerRadius = 20
        surname.layer.cornerRadius = 20
        okButton.layer.cornerRadius = 20
    }
    
    private func saveUserData() {
        
        guard let username = userName.text, !username.isEmpty, let name = name.text, !name.isEmpty, let surname = surname.text, !surname.isEmpty else {
            alert(title: "Privalote užpildyti visus laukelius")
            return }
        
        let userRelayValue = userRelay.value
        
        let user = User(id: userRelayValue?.id ?? 0, name: name, email: userRelayValue?.email ?? "", surname: surname, password: userRelayValue?.password ?? "", secondPassword: userRelayValue?.secondPassword ?? "", userName: username)
        
        Defaults.user = user
        
        if let u = Defaults.user {
            userRelay.accept(u)
        }
        
        db.editUserByID(id: userRelayValue?.id ?? 0, user: user)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userName {
            name.becomeFirstResponder()
        } else if textField == name {
            surname.becomeFirstResponder()
        } else if textField == surname {
            surname.resignFirstResponder()
            saveUserData()
        }
        
        return false
    }
}

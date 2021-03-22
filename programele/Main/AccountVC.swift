//
//  AccountVC.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import UIKit
import SwiftyUserDefaults
import RxSwift
import RxCocoa

final class AccountVC: UIViewController {

    @IBOutlet private var profilePicture: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var clubNameLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var surnameLabel: UILabel!
    @IBOutlet private var addProfilePictureButton: UIBarButtonItem!
    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var editUserDataButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.tapDriver
            .drive(onNext: Weakly(self, AccountVC.logout))
        
        editUserDataButton.tapDriver
            .drive(onNext: Weakly(self, AccountVC.openEditVC))
        
        userRelay.asDriver()
            .drive(onNext: { user in
                    self.setupUserData(user: user)})
        
    }
    
    private func setupUserData(user: User?) {
        profilePicture.layer.cornerRadius = 75
        usernameLabel.text = user?.userName
        nameLabel.text = user?.name
        surnameLabel.text = user?.surname
        clubNameLabel.text = locationRelay.value.name
    }
    
    private func openEditVC() {
        performSegue(withIdentifier: "EditAccountVC", sender: nil)
    }
   
    private func logout() {
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logOut = UIAlertAction(title: "Logout", style: .destructive) { _ in
            Defaults.user = nil
            Defaults.location = nil
            
            let loginNC = LoginVC.createFrom(storyboard: "Auth", identifier: "LoginVC") as! LoginVC
            UIApplication.shared.windows.first?.rootViewController = loginNC
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(logOut)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
        
    }
    
}

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
import Photos

final class AccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private var profilePicture: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var clubNameLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var surnameLabel: UILabel!
    @IBOutlet private var addProfilePictureButton: UIBarButtonItem!
    @IBOutlet private var logoutButton: UIButton!
    @IBOutlet private var editUserDataButton: UIButton!
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        logoutButton.tapDriver
            .driveNext(self, AccountVC.logout)
        
        editUserDataButton.tapDriver
            .driveNext(self, AccountVC.openEditVC)
        
        userRelay.asDriver()
            .drive(onNext: { user in
                    self.setupUserData(user: user) })
            .disposed(by: rx.disposeBag)
        
        addProfilePictureButton.tapDriver
            .driveNext(self, AccountVC.openGalleryOrCamera)
        
        updateProfilePicture()
        
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
    
    private func updateProfilePicture() {
        
        if let image = Defaults.profilePicture {
            profilePicture.image = image
        }
    }
    
    private func openGalleryOrCamera() {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                
                let status = AVCaptureDevice.authorizationStatus(for: .video)
                switch status {
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { response in
                        if response {
                            DispatchQueue.main.async {
                                self?.openCamera()
                            }
                        } else {
                            return
                        }
                    }
                case .restricted, .denied:
                    self?.openSettingsAlert(title: "Enable camera permissions in settings")
                case .authorized:
                    self?.openCamera()
                @unknown default:
                    return
                }
            }
            
            alertVC.addAction(camera)
        }
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized, .limited:
                self?.openGallery()
            case .denied, .restricted :
                self?.openSettingsAlert(title: "Enable photo permissions in settings")
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized, .limited:
                        DispatchQueue.main.async {
                            self?.openGallery()
                        }
                    case .denied, .restricted:
                        return
                    case .notDetermined:
                        return
                    @unknown default:
                        return
                    }
                }
            @unknown default:
                return
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(gallery)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func openSettingsAlert(title: String) {
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: title, style: .cancel) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    private func openCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    private func openGallery() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            Defaults.profilePicture = image
            updateProfilePicture()
            
        } else if let image = info[.originalImage] as? UIImage {
            Defaults.profilePicture = image
            updateProfilePicture()
        }
        picker.dismiss(animated: true, completion: nil)
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

//
//  ViewController.swift
//  programele
//
//  Created by Agne on 2021-03-14.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    
    class func createFrom(storyboard: String, identifier: String) -> UIViewController {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func alert(title: String) {
        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Gerai", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    //Keyboard dismissal on tap
    func dismissKeyboardOnTap(cancelsTouchesInView: Bool = true) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

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
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRootVC(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func goToSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    func setUpModalSegue(style: UIModalPresentationStyle = .overFullScreen, transition: UIModalTransitionStyle = .crossDissolve) {
        modalTransitionStyle = transition
        modalPresentationStyle = style
    }
    
    func keyboardAdjust(_ scrollView: UIScrollView, shouldScroll: Bool = false, bottomInset: CGFloat = 0) {
        let notificationsCenter = NotificationCenter.default
        
        let willShow = notificationsCenter
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .map{ ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height } //Might be outdated casting
            .filterNil()
        
        let willHide = notificationsCenter
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in bottomInset }
        
        Observable.of(willShow, willHide)
            .merge()
            .subscribe(onNext: { height in
                scrollView.contentInset         .bottom = height
               // scrollView.scrollIndicatorInsets.bottom = height
                // Explanation: Without delay, when codeTextField becomes first responder, logInView will not adjust properly, only numberTextField would adjust properly
                if shouldScroll {
                    delay(0.01) {
                        scrollView.scrollRectToVisible(
                            CGRect(x: 0, y: scrollView.contentSize.height - 1, width: 1, height: 1),
                            animated: true)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    ///Setups scrollView for keyboard, scrollView will move with keyboard.
    func focus(_ scrollView: UIScrollView, onActiveTextFields subViews: [UIView]) {
        let notificationsCenter = NotificationCenter.default
        
        let willShow = notificationsCenter
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .map{ ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height }
            .filterNil()
        
        let willHide = notificationsCenter
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        willHide.subscribe(onNext: { height in
            scrollView.contentInset         .bottom = height
           // scrollView.scrollIndicatorInsets.bottom = height
        })
            .disposed(by: rx.disposeBag)
        
        willShow
            .subscribe(onNext: { [weak self] height in
                guard scrollView.contentInset.bottom == 0 else { return }
                
                guard var aRect: CGRect = self?.view.frame else { return }
                
                var activeField:    UITextField?
                var activeTextView: UITextView?
                var button:         UIButton?
                
                self?.findActiveTextField(subViews, textField: &activeField, textView: &activeTextView, button: &button)
                
                aRect.size.height -= height
                if let activeFieldPresent = activeField {
                    
                    let _frame = scrollView.convert(activeFieldPresent.frame, from: activeFieldPresent.superview)
                    
                    if !aRect.contains(activeFieldPresent.frame.origin) {
                        scrollView.scrollRectToVisible(_frame, animated: true)
                    }
                } else if let activeFieldPresent = activeTextView {
                    
                    let _frame = scrollView.convert(activeFieldPresent.frame, from: activeFieldPresent.superview)
                    
                    if !aRect.contains(activeFieldPresent.frame.origin) {
                        scrollView.scrollRectToVisible(_frame, animated: true)
                    }
                } else if let activeButton = button {
                    let _frame = scrollView.convert(activeButton.frame, from: activeButton.superview)
                    
                    if !aRect.contains(activeButton.frame.origin) {
                        scrollView.scrollRectToVisible(_frame, animated: true)
                    }
                    
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    /// Used to adjust view content according to keyboard
    /// - Parameters:
    ///   - constrain: bottom constraint for view which we want to adjust
    ///   - constantAdjustmentValue: used to adjust constraints constant when keyboard is shown
    func adjustBottom(constrain: NSLayoutConstraint, constantAdjustmentValue: CGFloat? = nil) {
        let notificationsCenter = NotificationCenter.default
        let defaultConstant = constrain.constant
        let safeAreaInsetsBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let willShow = notificationsCenter
            .rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height }
            .filterNil()
        
        let willHide = notificationsCenter
            .rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in defaultConstant }
        
        willHide
            .subscribe(onNext: { [weak self] constant in
                UIView.animate(withDuration: 0.3) {
                    constrain.constant = constant
                    self?.view.layoutIfNeeded()
                }
            })
            .disposed(by: rx.disposeBag)
        
        willShow
            .subscribe(onNext: { [weak self] height in
                //This will be called if app goes to backgeound and comes back to foreground
                //Thus as a quick fix do not adjust constraint if it's already larger than the
                //Keyboard
                guard constrain.constant < (height - safeAreaInsetsBottom) else { return }
                UIView.animate(withDuration: 0.3) {
                    constrain.constant = height - safeAreaInsetsBottom + defaultConstant - (constantAdjustmentValue ?? 0)
                    self?.view.layoutIfNeeded()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func findActiveTextField(_ subviews: [UIView], textField: inout UITextField?, textView: inout UITextView?, button: inout UIButton?) {
        for view in subviews {
            if let tf = view as? UITextField, view.isFirstResponder {
                textField = tf
            } else if let tf = view as? UITextView, view.isFirstResponder {
                textView = tf
            } else if let tf = view as? UIButton {
                button = tf
            }
        }
    }
}

//
//  ViewController.swift
//  programele
//
//  Created by Agne on 2021-03-14.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func createFrom(storyboard: String, identifier: String) -> UIViewController {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}

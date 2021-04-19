//
//  UIView+Appearance.swift
//  MenuPay
//
//  Created by Sarunas Kazlauskas on 29/11/2019.
//  Copyright © 2019 Mediapark. All rights reserved.
//

import UIKit

public extension UIView {
    
    func addRoundedShadow(with color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        clipsToBounds = false
        layer.cornerRadius = radius
        addShadow(with: color, offset: offset, opacity: opacity, radius: radius)
    }
    
    func addShadow(with color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func roundTopCorners(cornerRadius: Double) {
        roundCorners(cornerRadius: CGFloat(cornerRadius))
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func roundCorners(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}

public extension UITabBar {
    
    static func setupAppearance(with color: UIColor) {
        UITabBar.appearance().barTintColor = color
    }
    
}

//
//  Color.swift
//  programele
//
//  Created by Agne on 2021-03-09.
//

import Foundation
import UIKit

extension UIColor {
    
    private convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    class var appPurple: UIColor { return UIColor(hex: 0x967BB6) }
    class var appGrey: UIColor { return UIColor(hex: 0xd3d3d3) }
}

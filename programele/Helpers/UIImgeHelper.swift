//
//  UIImage+Helpers.swift
//  MPUtilities
//
//  Created by Sarunas on 2019-12-09.
//  Copyright © 2019 Mediapark. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

extension UIImage: DefaultsSerializable {
    
    func resize(_ newSize: CGSize, completion: @escaping (_ image: UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            self.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.sync {
                completion(newImage)
            }
        }
    }
    
    func rotate(radians: CGFloat, completion: @escaping (_ image: UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let rotatedSize = CGRect(origin: .zero, size: self.size)
                .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
                .integral.size
            
            UIGraphicsBeginImageContext(rotatedSize)
            
            if let context = UIGraphicsGetCurrentContext() {
                let origin = CGPoint(x: rotatedSize.width / 2.0,
                                     y: rotatedSize.height / 2.0)
                context.translateBy(x: origin.x, y: origin.y)
                context.rotate(by: radians)
                
                self.draw(in: CGRect(x: -origin.y, y: -origin.x,
                                width: self.size.width, height: self.size.height))
                
                let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                DispatchQueue.main.sync {
                    completion(rotatedImage)
                }
            }
        }
    }
    
}

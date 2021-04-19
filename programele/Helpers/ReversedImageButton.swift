//
//  ReversedImageButton.swift
//  MenuPay
//
//  Created by Sarunas on 28/06/2019.
//  Copyright © 2019 Mediapark. All rights reserved.
//

import UIKit
 
@IBDesignable
open class ReversedImageButton: LoadingButton {
    
    @IBInspectable public var imageSize: CGSize {
        set {
            if let image = imageView?.image {
                image.resize(newValue) { [weak self] resizedImage in
                    self?.setImage(resizedImage, for: [])
                }
            }
        }
        get {
            return imageView!.frame.size
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        applyTransformations()
    }
    
    private func applyTransformations() {
        transform =             CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView? .transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
}

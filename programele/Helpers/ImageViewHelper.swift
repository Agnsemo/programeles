//
//  FileAPI.swift
//  Topocentras
//
//  Created by Justas Liola
//  Copyright © 2016 Mediapark. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import Alamofire
import Kingfisher

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

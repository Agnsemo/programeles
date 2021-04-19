//
//  Delay.swift
//  Ananda
//
//  Created by Justas Liola on 22/11/2017.
//  Copyright © 2017 MediaPark. All rights reserved.
//

import Foundation

public func delay(_ time: Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        closure()
    }
}

public func asyncOnMain(closure: @escaping ()->()) {
    DispatchQueue.main.async {
        closure()
    }
}

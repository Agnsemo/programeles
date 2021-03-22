//
//  Location.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import Foundation
import SwiftyUserDefaults

struct Location: Codable, DefaultsSerializable {
    let id: Int
    let name: String
    let city: String
    let workHours: String
}

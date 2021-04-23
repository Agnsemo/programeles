//
//  ActivitiesRegistration.swift
//  programele
//
//  Created by Agne on 2021-04-21.
//

import Foundation
import SwiftyUserDefaults

struct ActivitiesRegistration: Codable, DefaultsSerializable {
    let name: String
    let date: Date
}

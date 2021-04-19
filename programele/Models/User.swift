//
//  User.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import Foundation
import SwiftyUserDefaults

struct User: Codable, DefaultsSerializable {
    let id: Int
    let name: String
    let email: String
    let surname: String
    let password: String
    let secondPassword: String
    let userName: String
}

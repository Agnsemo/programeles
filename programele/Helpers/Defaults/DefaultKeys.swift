//
//  DefaultKeys.swift
//  programele
//
//  Created by Agne on 2021-03-16.
//

import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    var user:             DefaultsKey<User?>   { .init("user") }
    var location:         DefaultsKey<Location?> {.init("location")}
    var profilePicture:            DefaultsKey<UIImage?> {.init("profilePicture")}
    var registration:    DefaultsKey<[ActivitiesRegistration]?> {.init("registration")}
}



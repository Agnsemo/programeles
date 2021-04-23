//
//  UpdateDefaults.swift
//  programele
//
//  Created by Agne on 2021-03-23.
//

import Foundation
import SwiftyUserDefaults

func updateLocation() {
    if let location = Defaults.location {
        locationRelay.accept(location)
    }
}

func updateUser() {
    if let u = Defaults.user {
        userRelay.accept(u)
    }
}

func updateRegistration() {
    if let r = Defaults.registration {
        activitiesRegistrationRelay.accept(r)
        activitiesRegistrationArray = r
    }
}

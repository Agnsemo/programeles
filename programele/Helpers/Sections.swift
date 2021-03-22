//
//  Sections.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import Foundation
import RxSwift
import UIKit
import RxCocoa
import RxDataSources
import SwiftyUserDefaults


var sections: Driver<[MultipleSectionModel]> {
    return Driver<[MultipleSectionModel]>.combineLatest(headerSection, activitiesSection, locationSection)
    { header, activities, location -> [MultipleSectionModel] in
        return [header, activities, location]
    }
}

var userRelay = BehaviorRelay<User?>(value: nil)

var headerSection: Driver<MultipleSectionModel> {
    return userRelay
        .asDriver()
        .map { user in
            guard let u = user else {
                let section = MultipleSectionModel.header(items: [])
                return section }
            
            let header = SectionItem.header(user: u)
            let section = MultipleSectionModel.header(items: [header])
            return section
        }
}

//ACTIVITIES
var activitiesRelay = BehaviorRelay<[Activities]>(value: [])
var activitiesDriver: Driver<[Activities]>{
    return activitiesRelay.asDriver()
}

func insertDataIntoDB() {
    db.insertActivities(id: 0, title: "Groups", description: "Antradieniais - ketvirtadieniais 10.00-11.00 val. Treniruotės 3 - 5 žmonių grupėje. Individualus dėmesys ir motyvuojanti komanda. Trenerio palaikymas ir motyvacija Facebook grupėje. 8 kartai per mėnesį. Sportas gryname ore", image: "")
}

func updateActivities() {
    let activitiesArray = db.readActivities()
    activitiesRelay.accept(activitiesArray)
}

var activitiesSection: Driver<MultipleSectionModel> {
    
    return activitiesDriver
        .map { activities in
            var section = MultipleSectionModel.activities(items: [])
            let header = SectionItem.title(items: "Treniruotės")
            
            let activitiesSections = activities
                .map{ SectionItem.activities(activities: $0)}
            
            section = MultipleSectionModel.activities(items: [header] + activitiesSections)
            return section
        }
}

//LOCATIONS

var moreLocationsRelay = BehaviorRelay<[Location]>(value: [])
var moreLocationsDriver: Driver<[Location]> {
    return moreLocationsRelay.asDriver()
}

var locationRelay = BehaviorRelay<Location>(value: Location(id: 0, name: "OZO G. 41", city: "Vilnius", workHours: "Nedirba"))
var locationDriver: Driver<Location> {
    return locationRelay.asDriver()
}

func updateLocations() {
    let moreLocationsArray = db.readLocation()
    moreLocationsRelay.accept(moreLocationsArray)
}

func insertLocationTODB() {
    db.insertLocation(id: 1, name: "VIENUOLIO G. 4", city: "Vilnius", workHours: "Nedirba")
    db.insertLocation(id: 2, name: "SAVANORIŲ PR. 28", city: "Vilnius", workHours: "Nedirba")
    db.insertLocation(id: 3, name: "VAIRO G. 2", city: "Šiauliai", workHours: "Nedirba")
    db.insertLocation(id: 4, name: "LIEPŲ G. 53A", city: "Klaipėda", workHours: "Nedirba")
    db.insertLocation(id: 5, name: "OZO G. 41", city: "Vilnius", workHours: "Nedirba")
}

var locationSection: Driver<MultipleSectionModel> {
    
    return locationDriver
        .map { loc in
            let header = SectionItem.title(items: "Vieta")
            let location = SectionItem.location(location: loc)
            let section = MultipleSectionModel.location(items: [header, location])
            return section
        }
}


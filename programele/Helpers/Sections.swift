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


var sections: Driver<[MultipleSectionModel]> {
    return Driver<[MultipleSectionModel]>.combineLatest(headerSection, activitiesSection, locationSection)
    { header, activities, location -> [MultipleSectionModel] in
        return [header, activities, location]
    }
}

var headerSection: Driver<MultipleSectionModel> {
    let header = SectionItem.header(user: User(name: "Agne", email: "agne040@gmail.com", surname: "Semonaviciute", password: "12345", secondPassword: "12345", userName: "agneagne123"))
    let section = MultipleSectionModel.header(items: [header])
    return Driver.just(section)
}

var activitiesArray: [Activities] = [Activities(title: "antras", description: "Antradieniais - ketvirtadieniais 10.00-11.00 val. Treniruotės 3 - 5 žmonių grupėje. Individualus dėmesys ir motyvuojanti komanda. Trenerio palaikymas ir motyvacija Facebook grupėje. 8 kartai per mėnesį. Sportas gryname ore", image: UIImage(imageLiteralResourceName: "group2")), Activities(title: "pirmas", description: "Antradieniais - ketvirtadieniais 10.00-11.00 val. Treniruotės 3 - 5 žmonių grupėje. Individualus dėmesys ir motyvuojanti komanda. Trenerio palaikymas ir motyvacija Facebook grupėje. 8 kartai per mėnesį. Sportas gryname ore", image: UIImage(imageLiteralResourceName: "group2")), Activities(title: "pirmas", description: "Antradieniais - ketvirtadieniais 10.00-11.00 val. Treniruotės 3 - 5 žmonių grupėje. Individualus dėmesys ir motyvuojanti komanda. Trenerio palaikymas ir motyvacija Facebook grupėje. 8 kartai per mėnesį. Sportas gryname ore", image: UIImage(imageLiteralResourceName: "group3")), Activities(title: "pirmas", description: "Antradieniais - ketvirtadieniais 10.00-11.00 val. Treniruotės 3 - 5 žmonių grupėje. Individualus dėmesys ir motyvuojanti komanda. Trenerio palaikymas ir motyvacija Facebook grupėje. 8 kartai per mėnesį. Sportas gryname ore", image: UIImage(imageLiteralResourceName: "group1"))]

var activitiesRelay = BehaviorRelay<[Activities]>(value: activitiesArray)

var activitiesSection: Driver<MultipleSectionModel> {
    return activitiesRelay
        .asDriver()
        .map { activities in
            var section = MultipleSectionModel.activities(items: [])
            let header = SectionItem.title(items: "Treniruotės")
            
            let activitiesSections = activities
                .map{ SectionItem.activities(activities: $0)}
            
            section = MultipleSectionModel.activities(items: [header] + activitiesSections)
            return section
        }
}

var locationRelay = BehaviorRelay<Location>(value: Location(name: "OZO G. 41", city: "Vilnius", workHours: "Nedirba"))

var locationSection: Driver<MultipleSectionModel> {
    return locationRelay
        .asDriver()
        .map { loc in
            let header = SectionItem.title(items: "Vieta")
            let location = SectionItem.location(location: loc)
            let section = MultipleSectionModel.location(items: [header, location])
            return section
        }
}

var moreLocations: [Location] = [Location(name: "VIENUOLIO G. 4", city: "Vilnius", workHours: "Nedirba"),
                                 Location(name: "SAVANORIŲ PR. 28", city: "Vilnius", workHours: "Nedirba"),
                                 Location(name: "VAIRO G. 2", city: "Šiauliai", workHours: "Nedirba"),
                                 Location(name: "LIEPŲ G. 53A", city: "Klaipėda", workHours: "Nedirba")]

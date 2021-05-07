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
var activitiesRegistrationArray: [ActivitiesRegistration] = []
var activitiesRegistrationRelay = BehaviorRelay<[ActivitiesRegistration]>(value: [])
var activitiesRegistrationDriver: Driver<[ActivitiesRegistration]> {
    return activitiesRegistrationRelay.asDriver()
}

func insertDataIntoDB() {
    db.insertActivities(id: 0, title: "JOGA", description: " JOGA treniruotė efektyviai mankština kiekvieną kūno raumenį, gerina judesių koordinaciją, plastiką bei suteikia kūnui grakštumo \n Treniruotės trukmė: 50 min., 60 min., 70 min., 90 min. arba 120 min \n Treniruotės vyksta kiekvieną dieną 14h", image: "https://i.pinimg.com/564x/4a/25/a6/4a25a64a44ae8d3592fb5f4d95b31a36.jpg", time: "Treniruotės vyksta kiekvieną dieną 14h")
    db.insertActivities(id: 1, title: "SLOW & STRONG", description: " SLOW & STRONG – lėta funkcinė treniruotė, skirta kūnui sutvirtinti ir proporcingam siluetui formuoti \n Treniruotės trukmė: 50 min \n Dirbantys raumenys: Rankų, pečių, nugaros, pilvo preso, sėdmenų ir kojų raumenys \n Treniruotės vyksta kiekvieną dieną 16h", image: "https://i.pinimg.com/564x/b8/d2/b7/b8d2b7d21f5700d4417cd9120321c113.jpg", time: "Treniruotės vyksta kiekvieną dieną 16h")
    db.insertActivities(id: 2, title: "PILATESAS", description: " PILATESAS – viso kūno mankštos metodika, stiprinanti giluminius ir paviršinius kūno raumenis, lavinanti lankstumą ir koordinaciją \n Treniruotės trukmė: 50 min. arba 60 min \n Dirbantys raumenys: Visos raumenų grupės, ypač nugaros, pilvo preso ir gilieji raumenys \n Treniruotės vyksta kiekvieną dieną 17h", image: "https://i.pinimg.com/564x/72/f1/fe/72f1feb4dabca523b152a80214729196.jpg", time: "Treniruotės vyksta kiekvieną dieną 17h")
    db.insertActivities(id: 3, title: "TRENIRUOTĖS VAIKAMS", description: " Treniruotės vaikams tai - programa kurioje nuosekliai ir kompleksiškai ugdomos visos fizines savybes. Įvairiapusiškas krūvis įvairioms raumenų grupėms stiprina vaikų sveikatą. Todėl  treniruočių programa yra sudaroma taip, kad pakaitomis būtų apkraunamos visos pagrindinės raumenų grupės. Sudarant treniruočių programą yra atsižvelgiama į vaikų amžių, todėl pratimai nėra techniškai sudėtingi \n Treniruotės vyksta kiekvieną dieną 19h", image: "https://i.pinimg.com/564x/dd/cd/56/ddcd5635f2b711e77dacc36d631e7938.jpg", time: "Treniruotės vyksta kiekvieną dieną 19h")
    db.insertActivities(id: 4, title: "ZUMBA", description: " ZUMBA – tai treniruotės, kurių metu derinami šokio ir aerobikos elementai, stiprinantys visas raumenų grupes \n Treniruotės trukmė: 50 min \n Dirbantys raumenys: Visos raumenų grupės, ypač sėdmenys, kojos ir pilvo presas \n Treniruotės vyksta kiekvieną dieną 11h", image: "https://i.pinimg.com/564x/33/b5/39/33b5395e9a18cd9f4116e3f09a9ed041.jpg", time: "Treniruotės vyksta kiekvieną dieną 11h")
    db.insertActivities(id: 5, title: "BODY TONE", description: " BODY TONE – tai riebalų deginimo, jėgos ir ištvermės treniruotė, skirta pagrindiniams kūno raumenims lavinti. \n Treniruotės trukmė: 50 min \n Dirbantys raumenys: Visos raumenų grupės, ypač kojos, sėdmenys, pilvo presas \n Treniruotės vyksta kiekvieną dieną 9h", image: "https://i.pinimg.com/564x/1b/af/27/1baf27b9e7e37b0e19a3218da490acce.jpg", time: "Treniruotės vyksta kiekvieną dieną 9h")
    db.insertActivities(id: 6, title: "FUNCTIONAL HIIT", description: " FUNCTIONAL HIT – fizinį pasirengimą lavinanti funkcinė jėgos treniruotė, kurios metu intensyviai dirba visų grupių raumenys \n Treniruotės vyksta kiekvieną dieną 6h", image: "https://i.pinimg.com/564x/58/16/62/581662ca53877d067079fd292501d528.jpg", time: "Treniruotės vyksta kiekvieną dieną 6h")
    db.insertActivities(id: 7, title: "TAE-BO", description: " TAE-BO - vidutinio ir aukšto intesyvumo aerobinė treniruotė su Tailando bokso elementais - smūgiais rankomis ir spyriais kojomis. Treniruotėje lavinama judesių koordinacija, širdies ištvermė ir naudojami jėgos pratimai. Skirta įvairaus amžiaus žmonėms. Treniruotės metu sudeginama 600-800 kcal \n Treniruotės vyksta kiekvieną dieną 10h", image: "https://i.pinimg.com/564x/27/fa/11/27fa11e3dc74fd8c86befdb87b0abd15.jpg", time: "Treniruotės vyksta kiekvieną dieną 10h")
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

var locationRelay = BehaviorRelay<Location>(value: Location(id: 0, name: "OZO G. 41", city: "Vilnius", workHours: "8:00 - 20:00"))
var locationDriver: Driver<Location> {
    return locationRelay.asDriver()
}

func updateLocations() {
    let moreLocationsArray = db.readLocation()
    moreLocationsRelay.accept(moreLocationsArray)
}

func insertLocationTODB() {
    db.insertLocation(id: 1, name: "VIENUOLIO G. 4", city: "Vilnius", workHours: "8:00 - 20:00")
    db.insertLocation(id: 2, name: "SAVANORIŲ PR. 28", city: "Vilnius", workHours: "8:00 - 20:00")
    db.insertLocation(id: 3, name: "VAIRO G. 2", city: "Šiauliai", workHours: "8:00 - 20:00")
    db.insertLocation(id: 4, name: "LIEPŲ G. 53A", city: "Klaipėda", workHours: "8:00 - 20:00")
    db.insertLocation(id: 5, name: "OZO G. 41", city: "Vilnius", workHours: "8:00 - 20:00")
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


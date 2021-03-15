//
//  tableViewHelper.swift
//  programele
//
//  Created by Agne on 2021-03-14.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import Differentiator

enum MultipleSectionModel {
    case activities(items: [SectionItem])
    case location(items: [SectionItem])
    case header(items: [SectionItem])
}

enum SectionItem {
    case activities(activities: Activities)
    case header(user: User)
    case location(location: Location)
    case title(items: String)
}

extension MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch  self {
        case .activities(items: let items):
            return items.map { $0 }
        case .location(items: let items):
            return items.map { $0 }
        case .header(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: MultipleSectionModel, items: [Item]) {
        switch original {
        case let .activities(items: items):
            self = .activities(items: items)
        case let .location(items: items):
            self = .location(items: items)
        case let .header(items: items):
            self = .header(items: items)
        }
    }
}

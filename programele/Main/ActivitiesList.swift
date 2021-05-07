//
//  ActivitiesList.swift
//  programele
//
//  Created by Agne on 2021-03-23.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyUserDefaults

final class ActivitiesList: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateRegistration()
        tableView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        mainView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        
//        Observable.just(models)
//            .map {
//                $0.filter{ $0.name == name }
//            }.bind(to: modelsBehaviourRelay)
//            .disposed(by: disposeBag)
        
        activitiesRegistrationDriver
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "ActivityListCell", cellType: ActivityListCell.self)) { (row, item, cell) in
                cell.setup(activities: item)
            }.disposed(by: rx.disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe {
                activitiesRegistrationArray.remove(at: $0.element?.row ?? 0)
                Defaults.registration = activitiesRegistrationArray
                activitiesRegistrationRelay.accept(activitiesRegistrationArray)
            }
            .disposed(by: rx.disposeBag)
        
        activitiesRegistrationDriver.driveNext(self, ActivitiesList.showErrorViewIfNeeded)
    }
    
    private func showErrorViewIfNeeded(activities: [ActivitiesRegistration]) {
        if activities.isEmpty {
            tableView.isHidden = true
            alert(title: "Nesate užsiregistravę į jokius užsiėmimus")
        } else {
            tableView.isHidden = false
        }
    }
}

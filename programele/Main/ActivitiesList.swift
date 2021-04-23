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
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateRegistration()
        
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

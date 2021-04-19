//
//  ViewController.swift
//  programele
//
//  Created by Agne on 2021-03-09.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyUserDefaults
import SQLite3

final class HomeVC: UIViewController {
    
    @IBOutlet private var checkinButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var accountButton: UIButton!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        let dataSource = HomeVC.dataSource()
        
        sections
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        
        tableView.rx.modelSelected(SectionItem.self)
            .subscribe{ sectionItem in
                self.getActivity(sectionItem: sectionItem)
            }.disposed(by: rx.disposeBag)
        
        accountButton.rx.tapDriver
            .driveNext(self, HomeVC.openAccount)
        
        checkinButton.rx.tapDriver
            .driveNext(self, HomeVC.openAccountList)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ActivityDetailsVC)?.activity = sender as? Activities
    }
    
    private func openAccount() {
        performSegue(withIdentifier: "AccountVC", sender: nil)
    }
    
    private func openAccountList() {
        performSegue(withIdentifier: "ActivitiesList", sender: nil)
    }
    
   private func getActivity(sectionItem: SectionItem) {
        switch sectionItem {
        case .activities(let activities):
            performSegue(withIdentifier: "ActivityDetailsVC", sender: activities)
        case .location( _):
            return
        case .header(user: _):
            return
        case .title(items: _):
            return
        }
    }
    
    private func setup() {
        tableView.estimatedRowHeight = 50
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        
        userRelay.accept(user)
        
        updateLocation()
        
        insertDataIntoDB()
        updateActivities()
        insertLocationTODB()
        updateLocations()
    }
}

extension HomeVC {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<MultipleSectionModel> {
        return RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
            configureCell: { dataSource, table, idxPath, _ in
                switch dataSource[idxPath] {
                case .activities(let activities):
                    let cell: ActivitiesCell = table.dequeueReusableCell(withIdentifier: "ActivitiesCell") as! ActivitiesCell
                    cell.setup(activities: activities)
                    return cell
                case .header(user: let user):
                    let cell: HeaderCell = table.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
                    cell.setup(user: user)
                    return cell
                case .location(location: let location):
                    let cell: LocationCell = table.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
                    cell.setup(location: location)
                    
                    return cell
                case .title(items: let items):
                    let cell: TitleCell = table.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleCell
                    cell.setup(title: items)
                    return cell
                }
            }
        )
    }
}



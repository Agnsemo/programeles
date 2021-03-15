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

final class HomeVC: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var accountButton: UIButton!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = HomeVC.dataSource()
        
        sections
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(SectionItem.self)
            .subscribe{ sectionItem in
                self.getActivity(sectionItem: sectionItem)
            }.disposed(by: disposeBag)
        
        accountButton.rx.tapDriver
            .drive(onNext: Weakly(self, HomeVC.openAccount))
        
        setup()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ActivityDetailsVC)?.activity = sender as? Activities
    }
    
    func openAccount() {
        performSegue(withIdentifier: "AccountVC", sender: nil)
    }
    
    func getActivity(sectionItem: SectionItem) {
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
    
    func setup() {
        tableView.estimatedRowHeight = 50
        tableView.register(UINib(nibName: "TitleCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
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



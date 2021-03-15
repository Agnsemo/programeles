//
//  LocationVC.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import UIKit
import RxSwift
import RxCocoa

final class LocationVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet private var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        
        Observable.just(moreLocations)
            .bind(to: tableView.rx.items(cellIdentifier: "MoreLocationCell", cellType: MoreLocationCell.self)) { (row, item, cell) in
                cell.setup(location: item)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Location.self)
            .subscribe{ location in
                self.changeHomeLocation(location: location) }
            .disposed(by: disposeBag)
    }
    
    func changeHomeLocation(location: Location) {
        locationRelay.accept(location)
        self.navigationController?.popViewController(animated: true)
    }
}

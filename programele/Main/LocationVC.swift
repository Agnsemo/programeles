//
//  LocationVC.swift
//  programele
//
//  Created by Agne on 2021-03-15.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import SwiftyUserDefaults

final class LocationVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet private var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        
        moreLocationsDriver
            .drive(tableView.rx.items(cellIdentifier: "MoreLocationCell", cellType: MoreLocationCell.self)) { (row, item, cell) in
                cell.setup(location: item)                
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Location.self)
            .subscribe{ location in
                self.changeHomeLocation(location: location) }
            .disposed(by: disposeBag)
    }
    
    private func changeHomeLocation(location: Location) {
        Defaults.location = location
        
        if let l = Defaults.location {
            locationRelay.accept(l)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

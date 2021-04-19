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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        tableView.backgroundColor = UIColor.appPurple.withAlphaComponent(0.2)
        
        moreLocationsDriver
            .drive(tableView.rx.items(cellIdentifier: "MoreLocationCell", cellType: MoreLocationCell.self)) { (row, item, cell) in
                cell.setup(location: item)                
            }
            .disposed(by: rx.disposeBag)
        
        tableView.rx.modelSelected(Location.self)
            .subscribe{ location in
                self.changeHomeLocation(location: location) }
            .disposed(by: rx.disposeBag)
    }
    
    private func changeHomeLocation(location: Location) {
        Defaults.location = location
        
        updateLocation()
        
        self.navigationController?.popViewController(animated: true)
    }
}

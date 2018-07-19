//
//  ActivitiesBoardViewController+DataSource.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

extension ActivitiesBoardViewController: UITableViewDataSource, UITableViewDelegate {
    func configureTable() {
        activitiesTable.dataSource = self
        activitiesTable.delegate = self
        activitiesTable.rowHeight = UITableViewAutomaticDimension
        activitiesTable.register(AcvtivityCell.self, forCellReuseIdentifier: AcvtivityCell.reuseIdentifier)
        activitiesTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.activitiesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AcvtivityCell.reuseIdentifier) as? AcvtivityCell else { return UITableViewCell() }
        cell.configure(with: presenter.activity(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

}

//
//  StationDetailViewController+DataSource.swift
//  suburbano
//
//  Created by Miguel Ruiz on 03/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

extension StationDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func configureTable() {
        detailsTableView.backgroundColor = .white
        detailsTableView.showsVerticalScrollIndicator = false
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.separatorStyle = .none
        detailsTableView.rowHeight = UITableViewAutomaticDimension
        detailsTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        detailsTableView.estimatedSectionFooterHeight = 50
        detailsTableView.register(DetailAddressCell.self, forCellReuseIdentifier: DetailAddressCell.reuseIdentifier)
        detailsTableView.register(DetailScheduleCell.self, forCellReuseIdentifier: DetailScheduleCell.reuseIdentifier)
        detailsTableView.register(DeatilConectionsCell.self, forCellReuseIdentifier: DeatilConectionsCell.reuseIdentifier)
        detailsTableView.register(DetailHeaderView.self, forHeaderFooterViewReuseIdentifier: DetailHeaderView.reuseIdentifier)
        detailsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems(atSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = presenter.item(atIndex: indexPath).cellIdentifier
        return tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let detailCell = cell as? DetailCell else { return }
        detailCell.configure(with: presenter.item(atIndex: indexPath))
        
        guard let detailAddressCell = cell as? DetailAddressCell else { return }
        detailAddressCell.delegate = self
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailHeaderView.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? DetailHeaderView else { return }
        header.configure(with: presenter.section(atIndex: section))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20 + (Theme.Offset.normal * 2)
    }
}

extension StationDetailViewController: DetailAddressCellDelegate {
    func showLocation() {
        flowDelegate?.showDirectionsDetails(for: presenter.station)
    }
}

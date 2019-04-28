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
        detailsTableView.allowsSelection = false
        detailsTableView.separatorStyle = .none
        detailsTableView.rowHeight = UITableView.automaticDimension
        detailsTableView.estimatedRowHeight = UITableView.automaticDimension
        detailsTableView.sectionHeaderHeight = UITableView.automaticDimension
        detailsTableView.estimatedSectionFooterHeight = Theme.Offset.extralarge
        detailsTableView.register(cell: DetailAddressCell.self)
        detailsTableView.register(cell: DetailScheduleCell.self)
        detailsTableView.register(cell: DeatilConectionsCell.self)
        detailsTableView.register(cell: DetailWaitTimeCell.self)
        detailsTableView.registerHeaderFooterView(cell: DetailHeaderView.self)
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
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailHeaderView.reuseIdentifier)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? DetailHeaderView else { return }
        header.configure(with: presenter.section(atIndex: section))
    }
}

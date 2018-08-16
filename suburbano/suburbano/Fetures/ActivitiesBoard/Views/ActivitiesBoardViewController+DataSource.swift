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
        activitiesTable.separatorStyle = .none
        activitiesTable.rowHeight = UITableViewAutomaticDimension
        activitiesTable.register(AcvtivityCell.self, forCellReuseIdentifier: AcvtivityCell.reuseIdentifier)
        activitiesTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.activitiesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AcvtivityCell.reuseIdentifier) as? AcvtivityCell else { return UITableViewCell() }
        cell.configure(with: presenter.activity(at: indexPath), delegate: self)
        return cell
    }
    
    func showEmptyMessage(enable: Bool) {
        guard enable == emptyMessage.isHidden else { return }
        emptyMessage.isHidden = !enable
        
        if enable {
            view.bringSubview(toFront: emptyMessage)
        } else {
            view.sendSubview(toBack: emptyMessage)
        }
    }
}

extension ActivitiesBoardViewController: AcvtivityCellDelegate {
    func sheduleActivity(withId id: String) {
        presenter.hasAccessToSchedule { [weak self] accessRepsonse in
            guard let strongSelf = self else { return }
            switch accessRepsonse {
            case .authorized(let eventStore):
                strongSelf.presentScheduleView(withActivityid: id, eventStore: eventStore)
            case .denied:
                let error = ErrorResponse(code: .unknownCode, header: "Oups!", body: "No tenemos permiso para poder accesar a tu calendario. Puedes darnos acceso en la seccion de ajustes de tu telefono", tecnicalDescription: "")
                let controller = PopUpViewController(context: .error(error: error))
                controller.transitioningDelegate = self
                strongSelf.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func shareActivity(withId id: String) {}
}

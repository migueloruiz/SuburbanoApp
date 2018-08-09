//
//  ActivitiesBoardViewController+EventSchedule.swift
//  suburbano
//
//  Created by Miguel Ruiz on 08/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import EventKitUI

extension ActivitiesBoardViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .saved:
            print("Saved")
        default:
            print("Cancel")
        }
        controller.dismiss(animated: true)
    }
    
    func presentScheduleView(withActivityid id: String) {
        let eventStore = EKEventStore()
        guard let event = presenter.getEvent(withActiviryId: id, eventStore: eventStore) else { return }
        let eventViewController = EKEventEditViewController()
        eventViewController.eventStore = eventStore
        eventViewController.event = event
        eventViewController.editViewDelegate = self
        present(eventViewController, animated: true, completion: nil)
    }
}

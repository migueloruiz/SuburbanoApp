//
//  SchedulCoordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 25/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import EventKitUI

class SchedulCoordinator: Coordinator {

    let activity: Activity
    weak var previousController: ActivitiesBoardViewController?
    let eventStore = EKEventStore()
    var eventViewController: EKEventEditViewController?
    
    init(activity: Activity, previusController: ActivitiesBoardViewController) {
        self.activity = activity
        self.previousController = previusController
    }
    
    func start() {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            eventStore.requestAccess(to: .event) { [weak self] (success, error) in
                guard let strongSelf = self else { return }
                guard success else {
                    let alert = UIAlertController(title: "Alert", message: "Acceso negado", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
                    strongSelf.previousController?.present(alert, animated: true, completion: nil)
                    return
                }
                strongSelf.presentEventEditView()
            }
        case .restricted, .denied:
            let alert = UIAlertController(title: "Alert", message: "Acceso negado", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
            previousController?.present(alert, animated: true, completion: nil)
        case .authorized:
            presentEventEditView()
        }
    }
    
    private func presentEventEditView() {
        eventViewController = EKEventEditViewController()
        let event = EKEvent(eventStore: eventStore)
        event.title = activity.title
        event.location = activity.loaction
        event.calendar = eventStore.calendars(for: .event).first
        let recurrence = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: nil, daysOfTheMonth: [7, 14, 21, 18], monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        //            EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: [EKRecurrenceDayOfWeek(.saturday)], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil)
        
        event.addRecurrenceRule(recurrence)
        event.addAlarm(EKAlarm(relativeOffset: -86400))
        
        eventViewController?.eventStore = eventStore
        eventViewController?.event = event
        eventViewController?.editViewDelegate = previousController
        if let eventController = eventViewController {
            previousController?.present(eventController, animated: true, completion: nil)
        }
    }
}

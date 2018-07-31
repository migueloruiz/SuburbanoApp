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
        
        let startDate = Date(timeIntervalSince1970: TimeInterval(activity.starDate))
        event.startDate = startDate
        event.endDate = Date(timeIntervalSince1970: TimeInterval(activity.starDate + (activity.duration/2)))
        event.addAlarm(EKAlarm(relativeOffset: -86400))
        
        if let repeatEvent = activity.repeatEvent {
            let recurrenceDays = getRecurrenceDays(from: repeatEvent)
            print(recurrenceDays)
            let endDate = EKRecurrenceEnd(end: Date(timeIntervalSince1970: TimeInterval(activity.endDate)))
            let recurrence = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: recurrenceDays, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: endDate)
            event.addRecurrenceRule(recurrence)
        }
        
        eventViewController?.eventStore = eventStore
        eventViewController?.event = event
        eventViewController?.editViewDelegate = previousController
        if let eventController = eventViewController {
            previousController?.present(eventController, animated: true, completion: nil)
        }
    }
    
    func getRecurrenceDays(from repeatEvent: String) -> [EKRecurrenceDayOfWeek] {
        guard repeatEvent != "All" else {
            return [
                EKRecurrenceDayOfWeek(.monday),
                EKRecurrenceDayOfWeek(.thursday),
                EKRecurrenceDayOfWeek(.wednesday),
                EKRecurrenceDayOfWeek(.tuesday),
                EKRecurrenceDayOfWeek(.friday),
                EKRecurrenceDayOfWeek(.saturday),
                EKRecurrenceDayOfWeek(.sunday),
            ]
        }
        let repeatDays = repeatEvent.components(separatedBy: ",")
        var recurrenceDays: [EKRecurrenceDayOfWeek] = []
        
        for day in repeatDays {
            guard let weekDay = weakDay(from: day) else { continue }
            recurrenceDays.append(EKRecurrenceDayOfWeek(weekDay))
        }
        
        return recurrenceDays
    }
    
    func weakDay(from day: String) -> EKWeekday? {
        switch day {
        case "Monday": return .monday
        case "Tuesday": return .tuesday
        case "Wednesday": return .wednesday
        case "Thursday": return .thursday
        case "Friday": return .friday
        case "Saturday": return .saturday
        case "Sunday": return .sunday
        default: return nil
        }
    }
}

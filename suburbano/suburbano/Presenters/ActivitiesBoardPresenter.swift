//
//  ActivitiesBoardPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import EventKitUI

class ActivitiesBoardPresenter {
    let activitiesUseCase: GetActivitiesUseCase?
    private var activities = [Activity]()
    private var activitiesModels = [AcvtivityCellViewModel]()
    
    struct Constants {
        static let dayInterval: Double = 86400
    }
    
    init() {
        activitiesUseCase = UseCaseLocator.getUseCase(ofType: GetActivitiesUseCase.self)
    }
    
    func loadData(complition: @escaping () -> Void ) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            let date = Int(Date().timeIntervalSince1970)
            strongSelf.activities = strongSelf.activitiesUseCase?.get(byDate: date) ?? []
            strongSelf.activitiesModels = strongSelf.activities.map { strongSelf.convert($0) }
            DispatchQueue.main.async(execute: complition)
        }
    }
    
    var activitiesAreEmpty: Bool { return activitiesModels.isEmpty }
    
    var activitiesCount: Int { return activitiesModels.count }
    
    func activity(at index: IndexPath) -> AcvtivityCellViewModel {
        return activitiesModels[index.row]
    }
    
    func getEvent(withActiviryId id: String, eventStore: EKEventStore) -> EKEvent? {
        guard let activity = activities.first(where: { $0.id == id }) else { return nil }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = activity.title
        event.location = activity.loaction
        event.calendar = eventStore.calendars(for: .event).first
        
        let startDate = Date(timeIntervalSince1970: TimeInterval(activity.starDate))
        event.startDate = startDate
        event.endDate = Date(timeIntervalSince1970: TimeInterval(activity.starDate + activity.duration))
        event.addAlarm(EKAlarm(relativeOffset: -Constants.dayInterval))
        
        if let repeatEvent = activity.repeatEvent {
            let recurrenceDays = getRecurrenceDays(from: repeatEvent)
            print(recurrenceDays)
            let endDate = EKRecurrenceEnd(end: Date(timeIntervalSince1970: TimeInterval(activity.endDate)))
            let recurrence = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: recurrenceDays, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: endDate)
            event.addRecurrenceRule(recurrence)
        }
        
        return event
    }
}

extension ActivitiesBoardPresenter {
    private func convert(_ activity: Activity) -> AcvtivityCellViewModel {
        return AcvtivityCellViewModel(id: activity.id,
                                      title: activity.title.uppercased(),
                                      descripcion: activity.descripcion.firstUppercased,
                                      date: activity.displayDate,
                                      schedule: activity.startHour,
                                      category: activity.categoryType)
    }
    
    private func getRecurrenceDays(from repeatEvent: String) -> [EKRecurrenceDayOfWeek] {
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
    
    private func weakDay(from day: String) -> EKWeekday? {
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

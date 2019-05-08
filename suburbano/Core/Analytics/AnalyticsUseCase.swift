//
//  AnalyticsUseCase.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/28/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import FirebaseAnalytics

protocol AnalyticsEvent {
    var tag: String { get }
}

struct ErrorEvent: AnalyticsEvent {
    let name: String
    var tag: String { return "user_error_\(name)" }
}

struct ActionEvent: AnalyticsEvent {
    let name: String
    var tag: String { return "action_\(name)" }
}

protocol AnalyticsUseCase {
    func track(event: AnalyticsEvent, parameters: [String: Any]?, shouldCount: Bool)
    func getEventCount(forEvent event: AnalyticsEvent) -> Int
    func cleanCount(forEvent event: AnalyticsEvent)
}

class AnalyticsUseCaseImpl: AnalyticsUseCase {

    private var eventsCount = [String: Int]()

    func track(event: AnalyticsEvent, parameters: [String: Any]?, shouldCount: Bool = false) {
        Analytics.logEvent(event.tag, parameters: parameters)

        guard shouldCount else { return }
        eventsCount[event.tag] = (eventsCount[event.tag] ?? 0) + 1
    }

    func getEventCount(forEvent event: AnalyticsEvent) -> Int {
        return eventsCount[event.tag] ?? 0
    }

    func cleanCount(forEvent event: AnalyticsEvent) {
        eventsCount.removeValue(forKey: event.tag)
    }
}

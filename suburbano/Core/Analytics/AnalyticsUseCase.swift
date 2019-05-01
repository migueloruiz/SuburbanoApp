//
//  AnalyticsUseCase.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/28/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum AnalyticsEventType {
    case action(tag: String)
    case track(tag: String)
    case error(tag: String)

    var tag: String {
        switch self {
        case .action(let tag):
            return "Action-\(tag)"
        case .track(let tag):
            return "Track-\(tag)"
        case .error(let tag):
            return "UserError-\(tag)"
        }
    }
}

protocol AnalyticsEvent {
    var type: AnalyticsEventType { get }
    var parameters: [String: Any]? { get }
}

extension AnalyticsEvent {
    var tag: String { return type.tag }
}

protocol AnalyticsUseCase {
    func log(event: AnalyticsEvent)
}

class AnalyticsUseCaseImpl: AnalyticsUseCase {
    func log(event: AnalyticsEvent) {
        Analytics.logEvent(event.tag, parameters: event.parameters)
    }
}

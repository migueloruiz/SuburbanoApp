//
//  AnalyticsPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/28/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

protocol AnalyticsPresenter {
    var analyticsUseCase: AnalyticsUseCase? { get }
}

extension AnalyticsPresenter where Self: Presenter {
    func track(event: AnalyticsEvent, parameters: [String: Any]? = nil, shouldCount: Bool = false) {
        analyticsUseCase?.track(event: event, parameters: parameters, shouldCount: shouldCount)
    }

    func getEventCount(forEvent event: AnalyticsEvent) -> Int {
        return analyticsUseCase?.getEventCount(forEvent: event) ?? 0
    }

    func cleanCount(forEvent event: AnalyticsEvent) {
        analyticsUseCase?.cleanCount(forEvent: event)
    }
}

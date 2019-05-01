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
    func log(event: AnalyticsEvent) {
        analyticsUseCase?.log(event: event)
    }
}

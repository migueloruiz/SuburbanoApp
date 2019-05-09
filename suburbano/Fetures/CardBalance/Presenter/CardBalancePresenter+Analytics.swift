//
//  CardBalancePresenter+Analytics.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/3/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

extension CardBalancePresenterImpl: AnalyticsPresenter {

    private struct AnalyticsKeys {
        static let addCardError = ErrorEvent(name: "add_card")
        static let addCardSuccsses = ActionEvent(name: "add_card_succsses")
        static let addCardDesist = ActionEvent(name: "add_card_desist")

        static let attempts = "attempts"
    }

    internal func trackForm(error: AddCardError) {
        track(event: AnalyticsKeys.addCardError,
              parameters: ["error_type": String(describing: error) ],
              shouldCount: true)
    }

    internal func trackAddedSuccess() {
        track(event: AnalyticsKeys.addCardSuccsses,
              parameters: [AnalyticsKeys.attempts: getEventCount(forEvent: AnalyticsKeys.addCardError)])
        cleanCount(forEvent: AnalyticsKeys.addCardError)
    }

    internal func trackDesist() {
         let attemptsCount = getEventCount(forEvent: AnalyticsKeys.addCardError)
        guard attemptsCount > 0 else { return }
        track(event: AnalyticsKeys.addCardDesist,
              parameters: [AnalyticsKeys.attempts: attemptsCount])
        cleanCount(forEvent: AnalyticsKeys.addCardError)
    }

}

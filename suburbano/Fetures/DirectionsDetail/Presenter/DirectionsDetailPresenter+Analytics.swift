//
//  DirectionsDetailPresenter+Analytics.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/3/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

extension DirectionsDetailPresenterImpl: AnalyticsPresenter {

    private struct AnalyticsEvents {
        static let selectedDirections = ActionEvent(name: "selected_directios_app")
    }

    internal func trackSelected(app: DirectionsApp) {
        track(event: AnalyticsEvents.selectedDirections, parameters: ["app": app.id])
    }

}

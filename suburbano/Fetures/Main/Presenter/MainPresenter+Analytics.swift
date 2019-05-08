//
//  MainPresenter+Analytics.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/28/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

extension MainPresenterImpl: AnalyticsPresenter {

    private struct AnalyticsKeys {
        static let selectStation = ActionEvent(name: "select_station")
    }

    internal func trackSelected(station: Station?) {
        guard let station = station else { return }
        track(event: AnalyticsKeys.selectStation,
              parameters: ["station": station.name])
    }

}

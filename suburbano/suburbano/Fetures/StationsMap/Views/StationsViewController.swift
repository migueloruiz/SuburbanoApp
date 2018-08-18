//
//  StationsMapViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 06/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import Mapbox

protocol StationsMapViewControllerDelegate: class {
    func didStationSelected(station: StationMarker)
}

class StationsViewController: NavigationalViewController {
    
    private let mapBounds: MGLCoordinateBounds
    private let mapConfiguration: MapInitialConfiguration
    private let presenter: StationsMapPresenterProtocol
    private lazy var mapView: MGLMapView = MapViewFactory.create(frame: view.frame, initilConfiguration: mapConfiguration)
    private weak var delegate: StationsMapViewControllerDelegate?

    override var navgationIcon: UIImage { return #imageLiteral(resourceName: "TrainIcon") }
    
    struct Constants {
        static let railRoadColor: UIColor = Theme.Pallete.softGray
        static let railRoadWith: CGFloat = 8
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(presenter: StationsMapPresenterProtocol, mapConfiguration: MapInitialConfiguration) {
        self.presenter = presenter
        self.mapConfiguration = mapConfiguration
        self.mapBounds = MGLCoordinateBounds(sw: mapConfiguration.mapBoundsSW, ne: mapConfiguration.mapBoundsNE)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        mapView.delegate = self
    }
    
    private func configureLayout() {
        view.addSubview(mapView)
    }
}

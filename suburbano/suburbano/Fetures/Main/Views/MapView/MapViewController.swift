//
//  MapViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/18/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit
import Mapbox

protocol MapViewControllerDelegate: class {
    func didMapsCenterChange(isCenter: Bool)
    func stationSelected(station: Station)
}

class MapViewController: UIViewController {

    struct Constants {
        static let defaultEdges = UIEdgeInsets(top: 90, left: 0, bottom: 100, right: 0) // TODO suport notch
        static let detailEdges = UIEdgeInsets(top: 90, left: 0, bottom: UIDevice.screenHeight * 0.65, right: 0)
        static let routeEdges = UIEdgeInsets(top: 0, left: 40, bottom: 40, right: 40)
        static let detailZoomLevel = 11000.0
        static let tripIdentifier = "trip"
        static let railIdentifier = "rail"
        static let railRoadWith: CGFloat = 7
        static let railRoadColor = Theme.Pallete.softGray
    }

    fileprivate lazy var mapView: MGLMapView = MapViewFactory.create(frame: view.frame, initilConfiguration: mapConfiguration)
    private let mapBounds: MGLCoordinateBounds
    private let mapConfiguration: MapInitialConfiguration
    private let impactFeedback = UIImpactFeedbackGenerator()
    private lazy var defaultCamera = mapView.camera

    private weak var selectedAnotation: StationMapAnnotation?
    private var departureStaionId: String?
    private var arraivalStaionId: String?

    private let presenter: StationsMapPresenter
    weak var delegate: MapViewControllerDelegate?

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(presenter: StationsMapPresenter, mapConfiguration: MapInitialConfiguration) {
        self.mapConfiguration = mapConfiguration
        self.mapBounds = MGLCoordinateBounds(sw: mapConfiguration.mapBoundsSW, ne: mapConfiguration.mapBoundsNE)
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }

    private func configureUI() {
        automaticallyAdjustsScrollViewInsets = false // MapBox is working in no depend on this property
        mapView.delegate = self
    }

    private func configureLayout() {
        view.addSubViews([mapView])
        mapView.fillSuperview()
    }

    func centerMap() {
        mapView.setContentInset(Constants.defaultEdges, animated: true)
        mapView.set(camera: defaultCamera)
        delegate?.didMapsCenterChange(isCenter: true)
    }
}

extension MapViewController: MGLMapViewDelegate {

    func drawRailRoad(mapView: MGLMapView) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let railCoordonates = self?.presenter.getTrainRailCoordinates(),
                !railCoordonates.isEmpty else { return } // TODO: Add load error
            let railData = MapViewFactory.createRail(withIdentifier: Constants.railIdentifier, withCoordinates: railCoordonates)

            guard let polyline = railData.source.shape as? MGLPolyline else { return } // TODO: Add load error
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mapView.style?.addSource(railData.source)
                strongSelf.mapView.style?.addLayer(railData.layer)
                strongSelf.mapView.setContentInset(Constants.defaultEdges, animated: true)
                strongSelf.defaultCamera = mapView.cameraThatFitsCoordinateBounds(polyline.overlayBounds)
                strongSelf.mapView.set(camera: strongSelf.defaultCamera)
            }
        }
    }

    func draw(mapView: MGLMapView, stations: [StationMarker]) {
        let stationsMarkers = stations.map { station -> MGLPointAnnotation in
            let market = MGLPointAnnotation()
            market.coordinate = station.coordinate
            market.title = station.name
            return market
        }
        mapView.addAnnotations(stationsMarkers)
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        drawRailRoad(mapView: mapView)
        draw(mapView: mapView, stations: presenter.getMarkers())
    }

    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        delegate?.didMapsCenterChange(isCenter: newCamera == defaultCamera)
        let currentCamera = mapView.camera
        let newCameraCenter = newCamera.centerCoordinate
        mapView.camera = currentCamera
        let inside = MGLCoordinateInCoordinateBounds(newCameraCenter, mapBounds)
        return inside
    }

    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let marker = annotation as? MGLPointAnnotation,
            let title = marker.title,
            let station = presenter.getStationMarker(withName: title) else { return nil }

        guard let anotation = mapView.dequeueReusableAnnotationView(withIdentifier: station.markerIdentifier) as? StationMapAnnotation else {
            return StationMapAnnotation(station: station)
        }

        anotation.configure(with: station)
        if let departure = departureStaionId, let arraival = arraivalStaionId {
            let anotationMatch = anotation.id == departure || anotation.id == arraival
            anotation.diaplayStyle = .trip(active: anotationMatch)
        } else {
            anotation.diaplayStyle = .normal
        }
        return anotation
    }

    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return Constants.railRoadWith
    }

    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return annotation is MGLPolyline ? .clear : .blue
    }

    func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        impactFeedback.impactOccurred()
        setDetailCamera(annotationView: annotationView)
    }
}

// MARK: - Transitions

extension MapViewController {
    func setDefaultMap() {
        cleanMapDetailIfNeeded()
        cleanRouteLayerIfNeeded()
        updateMarkersToDeafult()
        centerMap()
    }

    func setDetailCamera(annotationView: MGLAnnotationView) {
        guard let marker = annotationView as? StationMapAnnotation,
            let anotation = marker.annotation,
            let title = anotation.title,
            let station = presenter.getStation(withName: title ?? "") else { return }
        selectedAnotation = marker
        mapView.setContentInset(Constants.detailEdges, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1000)) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.stationSelected(station: station)
            let tempCamera = strongSelf.mapView.camera
            tempCamera.centerCoordinate = anotation.coordinate
            strongSelf.mapView.set(camera: tempCamera) {
                marker.diaplayStyle = .detail
                let endCamera = strongSelf.mapView.camera
                endCamera.altitude = Constants.detailZoomLevel
                strongSelf.mapView.set(camera: endCamera)
            }
        }
    }

    func setRouteCamera(departure: Station, arraival: Station) {
        cleanRouteLayerIfNeeded()
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            let tripDirection = strongSelf.presenter.tripDirection(from: departure, to: arraival)
            let tripMapCordinates = strongSelf.presenter.getTrainRailCoordinates(from: departure, to: arraival, direction: tripDirection)
            let railData = MapViewFactory.createRail(withIdentifier: Constants.tripIdentifier, withCoordinates: tripMapCordinates, isRoute: true)
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mapView.style?.addSource(railData.source)
                strongSelf.mapView.style?.addLayer(railData.layer)
                strongSelf.updateMarkersForRoute(from: departure, to: arraival)
                guard let railLine = railData.source.shape else { return }
                let tempCamera = strongSelf.mapView.cameraThatFitsShape(railLine,
                                                                        direction: tripDirection.direction,
                                                                        edgePadding: Constants.routeEdges)
                strongSelf.mapView.set(camera: tempCamera)
            }
        }
    }
}

// MARK: - Helpers

extension MapViewController {
    private func cleanRouteLayerIfNeeded() {
        guard let source =  mapView.style?.source(withIdentifier: Constants.tripIdentifier),
            let layer = mapView.style?.layer(withIdentifier: Constants.tripIdentifier) else { return }
        mapView.style?.removeLayer(layer)
        mapView.style?.removeSource(source)
    }

    private func updateMarkersForRoute(from departure: Station, to arraival: Station) {
        for anomtation in mapView.annotations ?? [] {
            guard let marker = mapView.view(for: anomtation) as? StationMapAnnotation else { continue }
            marker.diaplayStyle = .trip(active: marker.id == departure.name || marker.id == arraival.name)
        }
    }

    private func updateMarkersToDeafult() {
        for anomtation in mapView.annotations ?? [] {
            guard let marker = mapView.view(for: anomtation) as? StationMapAnnotation else { continue }
            marker.diaplayStyle = .normal
        }
    }

    private func cleanMapDetailIfNeeded() {
        guard selectedAnotation != nil else { return }
        selectedAnotation?.isSelected = false
        selectedAnotation = nil
    }
}

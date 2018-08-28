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
    func stationSelected(station: StationMarker)
    func showCardBalance(id: String?)
}

class StationsViewController: NavigationalViewController {
    
    struct Constants {
        static let railRoadColor: UIColor = Theme.Pallete.softGray
        static let railRoadWith: CGFloat = 8 // TODO
    }
    
    private let mapBounds: MGLCoordinateBounds
    private let mapConfiguration: MapInitialConfiguration
    private let presenter: StationsMapPresenterProtocol
    private weak var delegate: StationsMapViewControllerDelegate?
    override var navgationIcon: UIImage { return #imageLiteral(resourceName: "TrainIcon") }
    
    private lazy var cardBalanceView = CardBalancePicker(delegate: self)
    private lazy var mapView: MGLMapView = MapViewFactory.create(frame: view.frame, initilConfiguration: mapConfiguration)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(presenter: StationsMapPresenterProtocol, mapConfiguration: MapInitialConfiguration, delegate: StationsMapViewControllerDelegate) {
        self.presenter = presenter
        self.mapConfiguration = mapConfiguration
        self.mapBounds = MGLCoordinateBounds(sw: mapConfiguration.mapBoundsSW, ne: mapConfiguration.mapBoundsNE)
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cardBalanceView.display(elements: presenter.getCards())
    }
    
    private func configureUI() {
        mapView.delegate = self
    }
    
    private func configureLayout() {
        view.addSubViews([mapView, cardBalanceView])
        cardBalanceView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.normal, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.normal)
    }
}

extension StationsViewController: MGLMapViewDelegate {
    
    func draw(mapView: MGLMapView, railRoad: AppResource) {
        DispatchQueue.global(qos: .background).async {
            guard let url = Utils.bundleUrl(forResource: railRoad),
                let data = try? Data(contentsOf: url),
                let shapeCollectionFeature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature,
                let polyline = shapeCollectionFeature?.shapes.first as? MGLPolylineFeature else { return }
            polyline.identifier = polyline.attributes["name"]
            DispatchQueue.main.async{
                mapView.addAnnotation(polyline)
                mapView.showAnnotations([polyline], edgePadding: UIEdgeInsets(top: 25, left: 0, bottom: 80, right: 0), animated: true)
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
        draw(mapView: mapView, railRoad: AppResources.Map.TrainRail)
        draw(mapView: mapView, stations: presenter.getStations())
    }
    
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        let currentCamera = mapView.camera
        let newCameraCenter = newCamera.centerCoordinate
        mapView.camera = currentCamera
        let inside = MGLCoordinateInCoordinateBounds(newCameraCenter, mapBounds)
        return inside
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        guard let marker = annotation as? MGLPointAnnotation,
            let title = marker.title else { return nil }
        
        if let anotation = mapView.dequeueReusableAnnotationView(withIdentifier: title) {
            return anotation
        } else if let station = presenter.getStation(withName: title) {
            return StationMapAnnotation(station: station)
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return Constants.railRoadWith
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return annotation is MGLPolyline ? Constants.railRoadColor : .blue
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        guard let marker = annotation as? MGLPointAnnotation,
            let station = presenter.getStation(withName: marker.title ?? "") else { return }
        delegate?.stationSelected(station: station)
        let newCamera = mapView.camera
        newCamera.centerCoordinate = annotation.coordinate
        mapView.setCamera(newCamera, withDuration: 0.2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)) {
            newCamera.altitude = 4600 // TODO
            mapView.setCamera(newCamera, withDuration: 0.5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        }
    }
}

extension StationsViewController: CardBalancePickerDelegate {
    func addCard() { delegate?.showCardBalance(id: nil) }
    
    func openCard(withId id: String) { delegate?.showCardBalance(id: id) }
}

extension StationsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let _ = presented as? CardBalanceViewController else { return nil }
        return CardBalanceTransitionIn()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let _ = dismissed as? CardBalanceViewController else { return nil }
        return CardBalanceTransitionOut()
    }
}

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
    func stationSelected(station: Station)
    func openAddCard()
    func open(card: Card)
}

class MapStationsViewController: NavigationalViewController {
    
    struct Constants {
        static let railRoadColor: UIColor = Theme.Pallete.softGray
        static let railRoadWith: CGFloat = 7 // TODO
    }
    
    private let mapBounds: MGLCoordinateBounds
    private let mapConfiguration: MapInitialConfiguration
    private let presenter: StationsMapPresenterProtocol
    private weak var delegate: StationsMapViewControllerDelegate?
    override var navgationIcon: UIImage { return #imageLiteral(resourceName: "TrainIcon") }
    
    private lazy var cardBalanceView = CardBalancePicker(delegate: self)
    private lazy var mapView: MGLMapView = MapViewFactory.create(frame: view.frame, initilConfiguration: mapConfiguration)
    private lazy var defaultCamera = mapView.camera
    private weak var selectedAnotation: StationMapAnnotation?
    
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
        cardBalanceView.display(cards: presenter.getCards())
    }
    
    private func configureUI() {
        mapView.delegate = self
    }
    
    private func configureLayout() {
        view.addSubViews([mapView, cardBalanceView])
        cardBalanceView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.normal, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.normal)
    }
}

extension MapStationsViewController: MGLMapViewDelegate {
    
    func draw(mapView: MGLMapView, railRoad: AppResource) {
        // TODO: Need Refactor
        DispatchQueue.global(qos: .background).async {
            guard let url = Utils.bundleUrl(forResource: railRoad), // TODO: get from presenter
                let data = try? Data(contentsOf: url),
                let shapeCollectionFeature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature,
                let polyline = shapeCollectionFeature?.shapes.first as? MGLPolylineFeature else { return }
            let identifier = polyline.attributes["name"] as? String ?? ""
            polyline.identifier = identifier
            
            let source = MGLShapeSource(identifier: identifier, shape: polyline, options: nil)
            let layer = MGLLineStyleLayer(identifier: identifier, source: source)
            layer.sourceLayerIdentifier = identifier
            layer.lineWidth = NSExpression(forConstantValue: Constants.railRoadWith)
            layer.lineColor = NSExpression(forConstantValue: Constants.railRoadColor)
            layer.lineCap = NSExpression(forConstantValue: "round")
            
            DispatchQueue.main.async{ [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mapView.style?.addSource(source)
                strongSelf.mapView.style?.addLayer(layer)
                strongSelf.defaultCamera = mapView.cameraThatFitsCoordinateBounds(polyline.overlayBounds,
                                                                       edgePadding: UIEdgeInsets(top: 25, left: 0, bottom: 80, right: 0))
                strongSelf.mapView.setCamera(strongSelf.defaultCamera, withDuration: 0.5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
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
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        print("End")
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
            let title = marker.title,
            let station = presenter.getStationMarker(withName: title) else { return nil }
        
        if let anotation = mapView.dequeueReusableAnnotationView(withIdentifier: station.markerIdentifier) as? StationMapAnnotation {
            anotation.configure(with: station)
            return anotation
        } else {
            return StationMapAnnotation(station: station)
        }
    }

    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        return Constants.railRoadWith
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return annotation is MGLPolyline ? .clear : .blue
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        guard let marker = annotationView as? StationMapAnnotation,
            let anotation = marker.annotation,
            let title = anotation.title,
            let station = presenter.getStation(withName: title ?? "") else { return }
        selectedAnotation = marker
        delegate?.stationSelected(station: station)

        let circularArea = polygonCircleForCoordinate(coordinate: anotation.coordinate, withMeterRadius: 500).overlayBounds
        let newCamera = mapView.cameraThatFitsCoordinateBounds(circularArea,
                                                               edgePadding: UIEdgeInsets(top: 30, left: 0, bottom: Utils.screenHeight * 0.65, right: 0))
        marker.isActive = false
        mapView.setCamera(newCamera, withDuration: 0.7, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
    }
    
    func polygonCircleForCoordinate(coordinate: CLLocationCoordinate2D, withMeterRadius: Double) -> MGLPolygon {
        let degreesBetweenPoints = 45.0
        let numberOfPoints = floor(360.0 / degreesBetweenPoints)
        let distRadians: Double = withMeterRadius / 6371000.0

        let centerLatRadians: Double = coordinate.latitude * Double.pi / 180
        let centerLonRadians: Double = coordinate.longitude * Double.pi / 180
        var coordinates = [CLLocationCoordinate2D]()

        for index in 0 ..< Int(numberOfPoints) {
            let degrees: Double = Double(index) * Double(degreesBetweenPoints)
            let degreeRadians: Double = degrees * Double.pi / 180
            let pointLatRadians: Double = asin(sin(centerLatRadians) * cos(distRadians) + cos(centerLatRadians) * sin(distRadians) * cos(degreeRadians))
            let pointLonRadians: Double = centerLonRadians + atan2(sin(degreeRadians) * sin(distRadians) * cos(centerLatRadians), cos(distRadians) - sin(centerLatRadians) * sin(pointLatRadians))
            let pointLat: Double = pointLatRadians * 180 / Double.pi
            let pointLon: Double = pointLonRadians * 180 / Double.pi
            let point: CLLocationCoordinate2D = CLLocationCoordinate2DMake(pointLat, pointLon)
            coordinates.append(point)
        }
        return MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
    }
}

extension MapStationsViewController: CardBalancePickerDelegate {
    func addCard() { delegate?.openAddCard() }
    
    func open(card: Card) { delegate?.open(card: card) }
}

extension MapStationsViewController: StationsViewDelegate {
    func update(cards: [Card]) {
        DispatchQueue.main.async { [weak self] in
            self?.cardBalanceView.display(cards: cards)
        }
    }
}

extension MapStationsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let prentableView = presented as? PresentableView else { return nil }
        return prentableView.inTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let prentableView = dismissed as? PresentableView else { return nil }
        
        if let _ = dismissed as? StationDetailViewController {
            selectedAnotation?.isActive = true
            mapView.setCamera(defaultCamera, withDuration: 0.5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
            selectedAnotation = nil
        }
        
        return prentableView.outTransition
    }
}

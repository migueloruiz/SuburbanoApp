//
//  StationsMapViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 06/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import Mapbox

protocol StationsMapFlowDelegate: class {
    func stationSelected(station: Station)
    func openAddCard()
    func open(card: Card)
    func dismissedDetail()
    func openRouteCalculator(stations: [Station], departure: Station, arraival: Station)
}

protocol RouteCameraDelegate: class {
    func setRouteCamera(departure: Station, arraival: Station)
}

class MapStationsViewController: NavigationalViewController {
    
    struct Constants {
        static let railRoadColor: UIColor = Theme.Pallete.softGray
        static let railRoadWith: CGFloat = 7 // TODO
        static let defaultEdges = UIEdgeInsets(top: 75, left: 0, bottom: 70, right: 0)
        static let detailEdges = UIEdgeInsets(top: 75, left: 0, bottom: Utils.screenHeight * 0.65, right: 0)
        static let detailZoomLevel = 11000.0
    }
    
    override var navgationIcon: String { return "TrainIcon" }
    
    private weak var flowDelegate: StationsMapFlowDelegate?
    
    private let mapBounds: MGLCoordinateBounds
    private let mapConfiguration: MapInitialConfiguration
    private let presenter: StationsMapPresenterProtocol
    private lazy var defaultCamera = mapView.camera
    
    fileprivate lazy var mapView: MGLMapView = MapViewFactory.create(frame: view.frame, initilConfiguration: mapConfiguration)
    private(set) lazy var buttonsContiner = UIStackView.with(axis: .vertical, spacing: Theme.Offset.small)
    private lazy var cardBalanceView = CardBalancePicker(delegate: self)
    private lazy var gradientView = UIView()
    private lazy var pricesButton = UIFactory.createCircularButton(image: #imageLiteral(resourceName: "money"), tintColor: .white, backgroundColor: Theme.Pallete.softRed)
    private lazy var centerMapButton = UIFactory.createCircularButton(image: #imageLiteral(resourceName: "mapCenter"), tintColor: .white, backgroundColor: Theme.Pallete.blue)
    
    private weak var selectedAnotation: StationMapAnnotation?
    private var railCordinates = [[Double]]()
    private var tripRailSource: MGLShapeSource?
    private var tripRailLayer: MGLLineStyleLayer?
    private var departureStaionId: String?
    private var arraivalStaionId: String?
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(presenter: StationsMapPresenterProtocol, mapConfiguration: MapInitialConfiguration, delegate: StationsMapFlowDelegate) {
        self.presenter = presenter
        self.mapConfiguration = mapConfiguration
        self.mapBounds = MGLCoordinateBounds(sw: mapConfiguration.mapBoundsSW, ne: mapConfiguration.mapBoundsNE)
        self.flowDelegate = delegate
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
        automaticallyAdjustsScrollViewInsets = false // MapBox is working in no depend on this property
        mapView.delegate = self
        gradientView.backgroundColor = .white
        gradientView.addDropShadow(color: .white, opacity: 1)
        
        pricesButton.addTarget(self, action: #selector(MapStationsViewController.openRouteCalculator), for: .touchUpInside)
        centerMapButton.addTarget(self, action: #selector(MapStationsViewController.centerMap), for: .touchUpInside)
        centerMapButton.isHidden = true
    }
    
    private func configureLayout() {
        view.addSubViews([mapView, cardBalanceView, gradientView, buttonsContiner])
        
        gradientView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        if Utils.isIphoneX {
            gradientView.anchor(bottom: view.safeAreaLayoutGuide.topAnchor)
        } else {
            gradientView.anchorSize(height: 20)
        }
        
        mapView.fillSuperview()
        cardBalanceView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.normal, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.normal)
        buttonsContiner.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, topConstant: Theme.Offset.small, rightConstant: Theme.Offset.normal)
        
        buttonsContiner.addArranged(subViews: [pricesButton, centerMapButton])
    }
    
    @objc func openRouteCalculator() {
        guard let departure = presenter.getStation(withName: "Buenavista"),
        let arraival = presenter.getStation(withName: "Cuautitlan") else { return }
        flowDelegate?.openRouteCalculator(stations: presenter.getStations(), departure: departure, arraival: arraival)
    }
    
    @objc func centerMap() {
        mapView.setContentInset(Constants.defaultEdges, animated: true)
        mapView.setCamera(defaultCamera, withDuration: 0.5, animationTimingFunction: CAMediaTimingFunction(name: .easeIn))
        centerMapButton.isHidden = true
    }
}

extension MapStationsViewController: MGLMapViewDelegate {
    
    func draw(mapView: MGLMapView, railRoad: AppResource) {
        // TODO: Need Refactor
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let url = Utils.bundleUrl(forResource: railRoad), // TODO: get from presenter
                let data = try? Data(contentsOf: url),
                let shapeCollectionFeature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature,
                let polyline = shapeCollectionFeature?.shapes.first as? MGLPolylineFeature else { return }
            let identifier = polyline.attributes["name"] as? String ?? ""
            polyline.identifier = identifier
            
            if let geometry = polyline.geoJSONDictionary()["geometry"] as? [String: Any],
                let cordinates = geometry["coordinates"] as? [[Double]] {
                self?.railCordinates = cordinates
                print(polyline.coordinates)
            }
            
            let source = MGLShapeSource(identifier: identifier, shape: polyline, options: nil)
            let layer = MGLLineStyleLayer(identifier: identifier, source: source)
            layer.sourceLayerIdentifier = identifier
            layer.lineWidth = NSExpression(forConstantValue: Constants.railRoadWith)
            layer.lineColor = NSExpression(forConstantValue: Constants.railRoadColor)
            layer.lineCap = NSExpression(forConstantValue: "round")
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mapView.style?.addSource(source)
                strongSelf.mapView.style?.addLayer(layer)
                strongSelf.mapView.setContentInset(Constants.defaultEdges, animated: true)
                strongSelf.defaultCamera = mapView.cameraThatFitsCoordinateBounds(polyline.overlayBounds)
                strongSelf.mapView.setCamera(strongSelf.defaultCamera, withDuration: 0.5, animationTimingFunction: CAMediaTimingFunction(name: .easeIn))
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
        draw(mapView: mapView, stations: presenter.getMarkers())
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        print("End")
    }
    
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        centerMapButton.isHidden = newCamera == defaultCamera
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
            if let departure = departureStaionId, let arraival = arraivalStaionId {
                anotation.diaplayStyle = .trip(active: anotation.id == departure || anotation.id == arraival)
            } else {
                anotation.diaplayStyle = .normal
            }
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
        setDetailCamera(annotationView: annotationView)
    }
}

extension MapStationsViewController: CardBalancePickerDelegate {
    func addCard() { flowDelegate?.openAddCard() }
    
    func open(card: Card) { flowDelegate?.open(card: card) }
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
        return prentableView.outTransition
    }
    
    func backFromDetailCamera() {
        cleanMapDetailIfNeeded()
        cleanMapFromRouteIfNeeded()
        centerMap()
    }
    
    private func cleanMapDetailIfNeeded() {
        guard selectedAnotation != nil else { return }
        selectedAnotation?.diaplayStyle = .normal
        selectedAnotation?.isSelected = false
        selectedAnotation = nil
        flowDelegate?.dismissedDetail()
    }
    
    func setDetailCamera(annotationView: MGLAnnotationView) {
        guard let marker = annotationView as? StationMapAnnotation,
            let anotation = marker.annotation,
            let title = anotation.title,
            let station = presenter.getStation(withName: title ?? "") else { return }
        selectedAnotation = marker
        mapView.setContentInset(Constants.detailEdges, animated: true)
        
        // Refactor
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1000)) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.flowDelegate?.stationSelected(station: station)
            let tempCamera = strongSelf.mapView.camera
            tempCamera.centerCoordinate = anotation.coordinate
            strongSelf.mapView.setCamera(tempCamera, withDuration: 0.3, animationTimingFunction: CAMediaTimingFunction(name: .easeIn)) {
                marker.diaplayStyle = .detail
                let endCamera = strongSelf.mapView.camera
                endCamera.altitude = Constants.detailZoomLevel
                strongSelf.mapView.setCamera(endCamera, withDuration: 0.5, animationTimingFunction: CAMediaTimingFunction(name: .easeIn))
            }
        }
    }
}

extension MapStationsViewController: RouteCameraDelegate {
    private func cleanMapFromRouteIfNeeded() {
        guard let source = tripRailSource, let layer = tripRailLayer else { return }
        mapView.style?.removeLayer(layer)
        mapView.style?.removeSource(source)
        tripRailSource = nil
        tripRailLayer = nil
        departureStaionId = nil
        arraivalStaionId = nil
        for anomtation in mapView.annotations ?? [] {
            guard let marker = mapView.view(for: anomtation) as? StationMapAnnotation else { continue }
            marker.diaplayStyle = .normal
        }
    }
    
    func setRouteCamera(departure: Station, arraival: Station) {
        if let source = tripRailSource, let layer = tripRailLayer {
            mapView.style?.removeLayer(layer)
            mapView.style?.removeSource(source)
            tripRailSource = nil
            tripRailLayer = nil
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.departureStaionId = departure.name
            strongSelf.arraivalStaionId = arraival.name
            let tripDirection = strongSelf.presenter.tripDirection(from: departure, to: arraival)
            var tripCordinates = [[Double]]()
            
            switch tripDirection {
            case .buenavistaToCuautitlan:
                tripCordinates = Array(strongSelf.railCordinates[arraival.id...departure.id])
            case .cuautitlanToBuenavista:
                tripCordinates = Array(strongSelf.railCordinates[departure.id...arraival.id])
            }
            
            let tripMapCordinates = tripCordinates.map { cordinate in
                return CLLocationCoordinate2D(latitude: cordinate.last ?? 0, longitude: cordinate.first ?? 0)
            }
            let tripLine = MGLPolyline(coordinates: tripMapCordinates, count: UInt(tripMapCordinates.count))
            let source = MGLShapeSource(identifier: "trip", shape: tripLine, options: nil)
            let layer = MGLLineStyleLayer(identifier: "trip", source: source)
            layer.sourceLayerIdentifier = "trip"
            layer.lineWidth = NSExpression(forConstantValue: Constants.railRoadWith)
            layer.lineColor = NSExpression(forConstantValue: Theme.Pallete.blue)
            layer.lineCap = NSExpression(forConstantValue: "round")
            
            strongSelf.tripRailSource = source
            strongSelf.tripRailLayer = layer
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mapView.style?.addSource(source)
                strongSelf.mapView.style?.addLayer(layer)
                
                for anomtation in strongSelf.mapView.annotations ?? [] {
                    guard let marker = strongSelf.mapView.view(for: anomtation) as? StationMapAnnotation else { continue }
                    marker.diaplayStyle = .trip(active: marker.id == departure.name || marker.id == arraival.name)
                }
                
                let menuOffset = Utils.screenHeight - strongSelf.mapView.frame.height
                let tempCamera = strongSelf.mapView.cameraThatFitsShape(tripLine,
                                                             direction: tripDirection.direction,
                                                             edgePadding: UIEdgeInsets(top: 0, left: 20, bottom: Utils.screenHeight * 0.6 - menuOffset, right: 20))
                strongSelf.mapView.setCamera(tempCamera, withDuration: 0.5, animationTimingFunction: CAMediaTimingFunction(name: .easeIn))
            }
        }
    }
}

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
}

class MapStationsViewController: NavigationalViewController {
    
    struct Constants {
        static let railRoadColor: UIColor = Theme.Pallete.softGray
        static let railRoadWith: CGFloat = 7 // TODO
        static let defaultEdges = UIEdgeInsets(top: 75, left: 0, bottom: 70, right: 0)
        static let detailEdges = UIEdgeInsets(top: 75, left: 0, bottom: Utils.screenHeight * 0.65, right: 0)
        static let detailZoomLevel = 11000.0
    }
    
    private let mapBounds: MGLCoordinateBounds
    private let mapConfiguration: MapInitialConfiguration
    private let presenter: StationsMapPresenterProtocol
    private weak var flowDelegate: StationsMapFlowDelegate?
    override var navgationIcon: UIImage { return #imageLiteral(resourceName: "TrainIcon") }
    private lazy var defaultCamera = mapView.camera
    private weak var selectedAnotation: StationMapAnnotation?
    
    private lazy var cardBalanceView = CardBalancePicker(delegate: self)
    private lazy var mapView: MGLMapView = MapViewFactory.create(frame: view.frame, initilConfiguration: mapConfiguration)
    private lazy var gradientView = UIView()
    
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
        mapView.delegate = self
        gradientView.backgroundColor = .white
        gradientView.addDropShadow(color: .white, opacity: 1)
    }
    
    private func configureLayout() {
        view.addSubViews([mapView, cardBalanceView, gradientView])
        
        gradientView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        if Utils.isIphoneX {
            gradientView.anchor(bottom: view.safeAreaLayoutGuide.topAnchor)
        } else {
            gradientView.anchorSize(height: 20)
        }
        
        mapView.fillSuperview()
        
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
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mapView.style?.addSource(source)
                strongSelf.mapView.style?.addLayer(layer)
                strongSelf.mapView.setContentInset(Constants.defaultEdges, animated: true)
                strongSelf.defaultCamera = mapView.cameraThatFitsCoordinateBounds(polyline.overlayBounds)
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
        mapView.setContentInset(Constants.detailEdges, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1000)) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.flowDelegate?.stationSelected(station: station)
            let tempCamera = mapView.camera
            tempCamera.centerCoordinate = anotation.coordinate
            mapView.setCamera(tempCamera, withDuration: 0.3, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)) {
                marker.isActive = false
                let endCamera = mapView.camera
                endCamera.altitude = Constants.detailZoomLevel
                mapView.setCamera(endCamera, withDuration: 0.5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
            }
        }
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
        
        if let _ = dismissed as? StationDetailViewController {
            selectedAnotation?.isActive = true
            mapView.setContentInset(Constants.defaultEdges, animated: true)
            mapView.setCamera(defaultCamera, withDuration: 0.5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
            selectedAnotation?.isSelected = false
            selectedAnotation = nil
            flowDelegate?.dismissedDetail()
        }
        
        return prentableView.outTransition
    }
}

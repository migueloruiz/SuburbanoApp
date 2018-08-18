//
//  StationsMapViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 06/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import Mapbox

struct StationsMap: MapInitialConfiguration {
    let style: AppResource = AppResources.Map.StyleFile
    let maxZoomLevel: Double = 20
    let minZoomLevel: Double = 8
    let mapBoundsNE: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 19.858455, longitude: -98.935441)
    let mapBoundsSW: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 19.191602, longitude: -99.421277)
}

protocol StationsMapViewControllerDelegate: class {
    func didStationSelected(station: StationMarker)
}

class StationsMapViewController: NavigationalViewController {
    
    lazy var mapView: MGLMapView = MapViewFactory.create(frame: view.frame, initilConfiguration: mapConfiguration)
    let mapBounds: MGLCoordinateBounds
    let mapConfiguration: MapInitialConfiguration
    let presenter: StationsMapPresenterProtocol
    weak var delegate: StationsMapViewControllerDelegate?
    
    let initialZoom: Double = 10.5
    let stationZoom: Double = 10

    override var navgationIcon: UIImage { return #imageLiteral(resourceName: "TrainIcon") }
    
    struct Constants {
        static let railRoadColor: UIColor = Theme.Pallete.softGray
        static let railRoadWith: CGFloat = 8
    }
    
    init(presenter: StationsMapPresenterProtocol, mapConfiguration: MapInitialConfiguration) {
        self.presenter = presenter
        self.mapConfiguration = mapConfiguration
        self.mapBounds = MGLCoordinateBounds(sw: mapConfiguration.mapBoundsSW, ne: mapConfiguration.mapBoundsNE)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func draw(mapView: MGLMapView, railRoad: AppResource) {
        DispatchQueue.global(qos: .background).async {
            guard let url = Utils.bundleUrl(forResource: railRoad),
                let data = try? Data(contentsOf: url),
                let shapeCollectionFeature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature,
                let polyline = shapeCollectionFeature?.shapes.first as? MGLPolylineFeature else { return }
            polyline.identifier = polyline.attributes["name"]
            DispatchQueue.main.async{
                mapView.addAnnotation(polyline)
                mapView.showAnnotations([polyline], edgePadding: UIEdgeInsets(top: 100, left: 0, bottom: 40, right: 0), animated: true)
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
}

extension StationsMapViewController: MGLMapViewDelegate {
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
            return StationAnnotation(station: station)
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
        delegate?.didStationSelected(station: station)
//        let point = mapView.convert(annotation.coordinate, toPointTo: view)
//        print("didSelect market: \(point)")
        let newCamera = mapView.camera
        newCamera.centerCoordinate = annotation.coordinate
        mapView.setCamera(newCamera, withDuration: 0.2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)) {
            newCamera.altitude = 4600
            mapView.setCamera(newCamera, withDuration: 0.5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        }
    }
}

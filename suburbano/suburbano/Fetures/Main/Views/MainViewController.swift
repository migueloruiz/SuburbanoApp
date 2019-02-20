//
//  StationsMapViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 06/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

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

class MainViewController: UIViewController {

    private weak var flowDelegate: StationsMapFlowDelegate?
    private let presenter: MainPresenter

    fileprivate lazy var mapView = MapViewController(presenter: presenter, mapConfiguration: StationsMap())
    private(set) lazy var buttonsContiner = UIStackView.with(axis: .vertical, spacing: Theme.Offset.small)
    private lazy var cardBalanceView = CardBalancePicker(delegate: self)
    private lazy var pricesButton = UIFactory.createCircularButton(image: #imageLiteral(resourceName: "money"), tintColor: .white, backgroundColor: Theme.Pallete.softRed)
    private lazy var centerMapButton = UIFactory.createCircularButton(image: #imageLiteral(resourceName: "mapCenter"), tintColor: .white, backgroundColor: Theme.Pallete.blue)
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(presenter: MainPresenter, delegate: StationsMapFlowDelegate) {
        self.presenter = presenter
        self.flowDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }

    override func viewDidLayoutSubviews() {
        gradientLayer.frame = gradientView.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        cardBalanceView.display(cards: presenter.getCards())
    }

    private func configureUI() {
        mapView.delegate = self

        pricesButton.addTarget(self, action: #selector(MainViewController.openRouteCalculator), for: .touchUpInside)
        centerMapButton.addTarget(self, action: #selector(MainViewController.centerMap), for: .touchUpInside)
        centerMapButton.isHidden = true

        gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0.8, 1]
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
    }

    private func configureLayout() {
        view.addSubViews([mapView.view, gradientView, cardBalanceView, buttonsContiner])

        gradientView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        if UIDevice.hasNotch {
            gradientView.anchor(bottom: view.safeAreaLayoutGuide.topAnchor)
        } else {
            gradientView.anchorSize(height: AppConstants.Device.normalStatusbarHeigth)
        }

        mapView.view.fillSuperview()
        cardBalanceView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, leftConstant: Theme.Offset.normal, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.normal)
        buttonsContiner.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, topConstant: Theme.Offset.small, rightConstant: Theme.Offset.normal)
        buttonsContiner.addArranged(subViews: [pricesButton, centerMapButton])
    }

    @objc func openRouteCalculator() {
        guard let departure = presenter.getStation(withName: "Buenavista"),
        let arraival = presenter.getStation(withName: "Cuautitlan") else { return }
        flowDelegate?.openRouteCalculator(stations: presenter.getStations(), departure: departure, arraival: arraival)
    }

    @objc func centerMap() {
        mapView.centerMap()
    }
}

extension MainViewController: RouteCameraDelegate {
    func setRouteCamera(departure: Station, arraival: Station) {
        mapView.setRouteCamera(departure: departure, arraival: arraival)
    }
}

extension MainViewController: CardBalancePickerDelegate {
    func addCard() { flowDelegate?.openAddCard() }

    func open(card: Card) { flowDelegate?.open(card: card) }
}

extension MainViewController: StationsViewDelegate {
    func update(cards: [Card]) {
        DispatchQueue.main.async { [weak self] in
            self?.cardBalanceView.display(cards: cards)
        }
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
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

    func setDefaultMap() {
        mapView.setDefaultMap()
    }
}

extension MainViewController: MapViewControllerDelegate {
    func didMapsCenterChange(isCenter: Bool) {
        centerMapButton.isHidden = isCenter
    }

    func stationSelected(station: Station) {
        flowDelegate?.stationSelected(station: station)
    }
}

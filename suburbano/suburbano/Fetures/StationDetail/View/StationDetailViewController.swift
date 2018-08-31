//
//  StationDetailViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class StationDetailViewController: UIViewController, PrentableView {
    
    private let station: Station
    
    private(set) lazy var containerView = UIFactory.createContainerView()
    private lazy var stationLabel = UIFactory.createLable(withTheme: UIThemes.Label.CardBalanceNavTitle)
    private let stationNameImage = UIImageView()
    private let tableView = UITableView()
    
    var inTransition: UIViewControllerAnimatedTransitioning? { return StationDetailTransitionIn() }
    var outTransition: UIViewControllerAnimatedTransitioning? { return StationDetailTransitionOut() }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        stationLabel.text = "ESTACION"
        stationNameImage.image = UIImage(named: station.markerTitleImage)
        
        containerView.backgroundColor = .white
        containerView.roundCorners(withRadius: Theme.Rounded.controller)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StationDetailViewController.close)))
    }
    
    private func configureLayout() {
        view.addSubViews([containerView])
        containerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, bottomConstant: -Theme.Offset.large)
        containerView.anchorSize(height: (Utils.screenHeight * 0.7) + Theme.Offset.large)
        
        containerView.addSubViews([stationLabel, stationNameImage])
        
        stationLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, topConstant: Theme.Offset.large, leftConstant: Theme.Offset.large)
        stationNameImage.anchor(top: stationLabel.bottomAnchor, left: containerView.leftAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.large)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

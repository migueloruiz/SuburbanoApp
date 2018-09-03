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
    private(set) lazy var backButton = UIButton()
    private lazy var stationLabel = UIFactory.createLable(withTheme: UIThemes.Label.StaionDetailStation)
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
        stationNameImage.contentMode = .scaleAspectFit
        
        backButton.set(image: #imageLiteral(resourceName: "down-arrow"), color: Theme.Pallete.darkGray)
        backButton.addTarget(self, action: #selector(StationDetailViewController.close), for: .touchUpInside)
        
        containerView.backgroundColor = .white
        containerView.roundCorners(withRadius: Theme.Rounded.controller)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StationDetailViewController.close)))
    }
    
    private func configureLayout() {
        view.addSubViews([containerView, backButton])
        containerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, bottomConstant: -Theme.Offset.large)
        containerView.anchorSize(height: (Utils.screenHeight * 0.7) + Theme.Offset.large) // TODO
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, topConstant: Theme.Offset.normal, leftConstant: Theme.Offset.large)
        backButton.anchorSize(width: 30, height: 30) // TODO
        
        containerView.addSubViews([stationLabel, stationNameImage])
        
        stationLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, topConstant: Theme.Offset.large, leftConstant: Theme.Offset.large)
        stationNameImage.anchor(top: stationLabel.bottomAnchor, left: containerView.leftAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.large)
        let sacleSize = scaleImage(actualSize: stationNameImage.image?.size ?? CGSize(width: 100, height: 28), withHeight: 28) // TOO
        stationNameImage.anchorSize(width: sacleSize.width, height: sacleSize.height)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension StationDetailViewController {
    fileprivate func scaleImage(actualSize: CGSize, withHeight height: CGFloat) -> CGSize {
        let width = (actualSize.width * height) / actualSize.height
        return CGSize(width: width, height: height)
    }
}


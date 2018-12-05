//
//  StationDetailViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol  StationDetailViewDelegate: class {
    func update()
}

class StationDetailViewController: UIViewController, PresentableView {
    
    let presenter: StationDetailPresenter
    weak var flowDelegate: StationDetailViewFlowDelegate?
    
    var inTransition: UIViewControllerAnimatedTransitioning? { return StationDetailTransitionIn() }
    var outTransition: UIViewControllerAnimatedTransitioning? { return StationDetailTransitionOut() }
    
    let containerView = UIFactory.createContainerView()
    let backButton = UIButton()
    private lazy var stationLabel = UIFactory.createLable(withTheme: UIThemes.Label.StaionDetailStation)
    private lazy var locationButton = UIFactory.createCircularButton(image: #imageLiteral(resourceName: "cursor"), tintColor: .white, backgroundColor: Theme.Pallete.blue)
    private let stationNameImage = UIImageView()
    let detailsTableView = UITableView(frame: .zero, style: .grouped)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(presenter: StationDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        configureUI()
        configureLayout()
        presenter.load()
    }
    
    private func configureUI() {
        stationLabel.text = "ESTACION" // Localize
        stationNameImage.image = UIImage(named: presenter.titleImageName)
        stationNameImage.contentMode = .scaleAspectFit
        
        backButton.set(image: #imageLiteral(resourceName: "down-arrow"), color: Theme.Pallete.darkGray)
        backButton.addTarget(self, action: #selector(StationDetailViewController.close), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(StationDetailViewController.showLocation), for: .touchUpInside)
        
        configureTable()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StationDetailViewController.close)))
    }
    
    private func configureLayout() {
        view.addSubViews([containerView, backButton])
        containerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, bottomConstant: -Theme.Offset.large)
        containerView.anchorSize(height: (Utils.screenHeight * 0.7) + Theme.Offset.large) // TODO
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.large)
        backButton.anchorSize(width: 25, height: 25) // TODO
        
        containerView.addSubViews([stationLabel, stationNameImage, locationButton, detailsTableView])
        
        stationLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, topConstant: Theme.Offset.large, leftConstant: Theme.Offset.large)
        stationNameImage.anchor(top: stationLabel.bottomAnchor, left: containerView.leftAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.large)
        let sacleSize = scaleImage(actualSize: stationNameImage.image?.size ?? CGSize(width: 100, height: 28), withHeight: 28) // TODO
        stationNameImage.anchorSize(width: sacleSize.width, height: sacleSize.height)
        
        locationButton.anchor(top: stationLabel.topAnchor, right: containerView.rightAnchor, topConstant: Theme.Offset.small, rightConstant: Theme.Offset.large)
        
        detailsTableView.anchor(top: stationNameImage.bottomAnchor, left: containerView.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: containerView.rightAnchor, topConstant: Theme.Offset.normal, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.large)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showLocation() {
        flowDelegate?.showDirectionsDetails(for: presenter.station)
    }
}

extension StationDetailViewController: StationDetailViewDelegate {
    func update() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.detailsTableView.reloadData()
        }
    }
}

extension StationDetailViewController {
    fileprivate func scaleImage(actualSize: CGSize, withHeight height: CGFloat) -> CGSize {
        let width = (actualSize.width * height) / actualSize.height
        return CGSize(width: width, height: height)
    }
}

extension StationDetailViewController: UIViewControllerTransitioningDelegate {
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
}

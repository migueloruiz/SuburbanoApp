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

    let containerView = UIView(style: .container)
    let backButton = UIButton(navigationStyle: .down)
    let detailsTableView = UITableView(frame: .zero, style: .grouped)
    private(set) lazy var detailTableHeader = DetailTableHeader(titleImageName: presenter.titleImageName, delegate: self)

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
        backButton.addTarget(self, action: #selector(StationDetailViewController.close), for: .touchUpInside)
        configureTable()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StationDetailViewController.close)))
    }

    private func configureLayout() {
        view.addSubViews([containerView, backButton])
        containerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, bottomConstant: -Theme.Offset.large)
        containerView.anchorSize(height: (UIDevice.screenHeight * Theme.ContainerPropotion.porcent70) + Theme.Offset.large)

        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.large)

        containerView.addSubViews([detailTableHeader, detailsTableView])

        detailTableHeader.anchor(top: containerView.topAnchor)
        detailTableHeader.fillHorizontal()

        detailsTableView.anchor(top: detailTableHeader.bottomAnchor)
        detailsTableView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        detailsTableView.anchor(left: containerView.leftAnchor, right: containerView.rightAnchor)
    }

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension StationDetailViewController: DetailTableHeaderDelegate {
    func tapShowLocation() {
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

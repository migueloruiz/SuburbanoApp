//
//  ActivitiesBoardViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class ActivitiesBoardViewController: NavigationalViewController {
    
    let presenter: ActivitiesBoardPresenter
    
    lazy var loadingView = LoadingView(animation: Theme.Animations.loading)
    lazy var activitiesTable: UITableView = UITableView(frame: .zero)
    lazy var titleLable: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityBoardNavTitle, text: "EVENTOS")
    lazy var selectionView: UIView = {
        let sv = UIView()
        sv.backgroundColor = Theme.Pallete.softRed
        return sv
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var navgationIcon: String { return "NewspaperIcon" }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(activitiesBoardPresenter: ActivitiesBoardPresenter) {
        presenter = activitiesBoardPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        loadingView.showNow(hiddingView: activitiesTable)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.loadData { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.activitiesTable.reloadData()
            strongSelf.loadingView.dismiss(hiddingView: strongSelf.activitiesTable, completion: nil)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureTable()
        loadingView.configure()
    }

    private func configureLayout() {
        view.backgroundColor = .white
        view.addSubViews([selectionView, activitiesTable, loadingView])
        
        selectionView.anchor(top: view.topAnchor,
                            left: view.leftAnchor,
                            bottom: activitiesTable.topAnchor,
                            right: view.rightAnchor)
        activitiesTable.anchor(top: selectionView.bottomAnchor,
                               left: view.leftAnchor,
                               bottom: view.bottomAnchor,
                               right: view.rightAnchor)
        loadingView.anchor(top: selectionView.bottomAnchor,
                           left: view.leftAnchor,
                           bottom: view.bottomAnchor,
                           right: view.rightAnchor)
        
        selectionView.addSubview(titleLable)
        titleLable.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: selectionView.leftAnchor, bottom: selectionView.bottomAnchor, right: selectionView.rightAnchor, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.large)
        titleLable.anchorSize(height: 26)
    }
}

extension ActivitiesBoardViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let _ = presented as? PopUpViewController else { return nil }
        return PopUpTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

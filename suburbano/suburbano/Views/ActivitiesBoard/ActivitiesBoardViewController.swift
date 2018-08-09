//
//  ActivitiesBoardViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class ActivitiesBoardViewController: UIViewController {
    
    let presenter: ActivitiesBoardPresenter
    
    init(activitiesBoardPresenter: ActivitiesBoardPresenter) {
        presenter = activitiesBoardPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    lazy var activitiesTable: UITableView = UITableView(frame: .zero)
    lazy var titleLable: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.NavTitle, title: "EVENTOS")
    lazy var emptyMessage: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardTitle, title: "No hay eventos")
    lazy var slectionView: UIView = {
        let sv = UIView()
        sv.backgroundColor = Theme.Pallete.softRed
        return sv
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        configureUI()
        configureTable()
        presenter.loadData { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.activitiesTable.reloadData()
            strongSelf.showEmptyMessage(enable: strongSelf.presenter.activitiesAreEmpty)
        }
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubViews([emptyMessage, slectionView, activitiesTable])
        
        slectionView.anchor(top: view.topAnchor,
                            left: view.leftAnchor,
                            bottom: activitiesTable.topAnchor,
                            right: view.rightAnchor)
        emptyMessage.anchor(top: slectionView.bottomAnchor,
                            left: view.leftAnchor,
                            bottom: view.bottomAnchor,
                            right: view.rightAnchor)
        activitiesTable.anchor(top: slectionView.bottomAnchor,
                               left: view.leftAnchor,
                               bottom: view.bottomAnchor,
                               right: view.rightAnchor)
        
        slectionView.addSubview(titleLable)
        titleLable.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: slectionView.leftAnchor, bottom: slectionView.bottomAnchor, right: slectionView.rightAnchor, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.large)
        showEmptyMessage(enable: true)
    }
}

//
//  ActivitiesBoardViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import EventKitUI

class ActivitiesBoardViewController: UIViewController {
    
    let presenter: ActivitiesBoardPresenter
    weak var delegate: PresentScheduleViewDelegate?
    
    init(activitiesBoardPresenter: ActivitiesBoardPresenter, delegate: PresentScheduleViewDelegate) {
        presenter = activitiesBoardPresenter
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var activitiesTable: UITableView = {
        let table = UITableView(frame: .zero)
        return table
    }()
    
    lazy var slectionView: UIView = {
        let sv = UIView()
        sv.backgroundColor = Theme.Pallete.softRed
        return sv
    }()
    
    lazy var titleLable: UILabel = {
        let label = UILabel()
        label.backgroundColor = Theme.Pallete.softRed
        label.text = "EVENTOS"
        let font2 = Font(size: Theme.FontSize.h1)
        label.font = font2.defaultFont
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        configureUI()
        configureTable()
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubViews([slectionView, activitiesTable])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ActivitiesBoardViewController.remove))
        slectionView.addGestureRecognizer(tap)
        slectionView.anchor(top: view.topAnchor,
                            left: view.leftAnchor,
                            bottom: activitiesTable.topAnchor,
                            right: view.rightAnchor)
        activitiesTable.anchor(top: slectionView.bottomAnchor,
                               left: view.leftAnchor,
                               bottom: view.bottomAnchor,
                               right: view.rightAnchor)
        
        slectionView.addSubview(titleLable)
        titleLable.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: slectionView.leftAnchor, bottom: slectionView.bottomAnchor, right: slectionView.rightAnchor, topConstant: Theme.Offset.normal, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.normal, rightConstant: Theme.Offset.large)
    }
    
    @objc func remove() {
        presenter.remove(index: 1)
        presenter.remove(index: 3)
        activitiesTable.beginUpdates()
        activitiesTable.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .middle)
        activitiesTable.deleteRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
        activitiesTable.endUpdates()
    }
}

extension ActivitiesBoardViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .saved:
            print("Saved")
        default:
            print("Deleted")
        }
        controller.dismiss(animated: true)
    }
}

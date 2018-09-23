//
//  ScheduleTrainCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/19/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class ScheduleTrainCell: UITableViewCell, ReusableIdentifier {
    
    private let containerView = UIFactory.createCardView()
    private let departureTitle = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let arraivalTitle = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private let depatureTime = UIFactory.createLable(withTheme: UIThemes.Label.StaionDetailStation)
    private let arraivalTime = UIFactory.createLable(withTheme: UIThemes.Label.StaionDetailStation)
    private let tripIndicator = UIFactory.createImageView(image: UIImage(named: "tripIndicator"), color: .white)

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        backgroundColor = Theme.Pallete.ligthGray
        departureTitle.text = "Salida" // Localize
        arraivalTitle.text = "Llegada" // Localize
        
        departureTitle.textAlignment = .center
        arraivalTitle.textAlignment = .center
        
        depatureTime.textColor = Theme.Pallete.darkGray
        depatureTime.textAlignment = .center
        arraivalTime.textColor = Theme.Pallete.darkGray
        arraivalTime.textAlignment = .center
        
        tripIndicator.contentMode = .scaleAspectFit
    }
    
    private func configureLayout() {
        addSubview(containerView)
        containerView.fillSuperview(verticalOffset: Theme.Offset.small, horizontalOffset: Theme.Offset.small)
        
        containerView.addSubViews([departureTitle, depatureTime, tripIndicator, arraivalTitle, arraivalTime])
        
        departureTitle.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: tripIndicator.leftAnchor, topConstant: Theme.Offset.normal)
        depatureTime.anchor(top: departureTitle.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: tripIndicator.leftAnchor, bottomConstant: Theme.Offset.normal)
        depatureTime.anchorSize(height: 30)
        
        NSLayoutConstraint.activate([
            tripIndicator.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3)
        ])
        tripIndicator.anchorCenterSuperview()
        
        arraivalTitle.anchor(top: containerView.topAnchor, left: tripIndicator.rightAnchor, right: containerView.rightAnchor, topConstant: Theme.Offset.normal)
        arraivalTime.anchor(top: arraivalTitle.bottomAnchor, left: tripIndicator.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, bottomConstant: Theme.Offset.normal)
        arraivalTime.anchorSize(height: 30)
    }
    
    func configure(with model: ScheludeViewModel) {
        depatureTime.text = model.departureTime
        arraivalTime.text = model.arraivalTime
    }
}

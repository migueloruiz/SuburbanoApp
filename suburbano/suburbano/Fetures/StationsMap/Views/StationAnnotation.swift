//
//  StationAnnotation.swift
//  suburbano
//
//  Created by Miguel Ruiz on 17/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import Mapbox

class StationAnnotation: MGLAnnotationView{
    
    private var imageView = UIImageView()
    private lazy var titleLable = UIImageView() //UIFactory.createLable(withTheme: UIThemes.Label.StationMarkerTitle)
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(station: StationMarker) {
        super.init(reuseIdentifier: station.name)
        configureUI(withStation: station)
        configureLayout(titleSide: station.titleSide)
    }
    
    private func configureLayout(titleSide: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        addSubViews([imageView, titleLable])
        imageView.anchorCenterYToSuperview(constant: -imageView.frame.height / 2)
        imageView.anchorCenterXToSuperview()
        titleLable.anchor(top: imageView.topAnchor, bottom: imageView.bottomAnchor)
        
        if !titleSide {
            titleLable.anchor(left: imageView.rightAnchor, right: rightAnchor, leftConstant: Theme.Offset.small)
        } else {
            titleLable.anchor(left: leftAnchor, right: imageView.leftAnchor, rightConstant: Theme.Offset.small)
        }
    }
    
    private func configureUI(withStation station: StationMarker) {
        imageView.image = UIImage(named: station.markerImage)
        titleLable.image = UIImage(named: station.markerTitleImage)
        titleLable.contentMode = .scaleAspectFit
//        titleLable.text = station.name.uppercased()
    }
}

//
//  StationAnnotation.swift
//  suburbano
//
//  Created by Miguel Ruiz on 17/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import Mapbox

class StationMapAnnotation: MGLAnnotationView {
    
    private var imageView = UIImageView()
    private lazy var titleView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(station: StationMarker) {
        super.init(reuseIdentifier: station.name)
        configureUI(withStation: station)
        configureLayout(titleSide: station.titleSide)
    }
    
    var isTitleVisible: Bool {
        get {
            return titleView.alpha == 1
        }
        
        set(value) {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.titleView.alpha = value ? 1 : 0
            }
        }
    }
    
    private func configureLayout(titleSide: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        let spacerView = UIView()
        addSubViews([imageView, titleView, spacerView])
        imageView.anchorCenterXToSuperview()
        imageView.anchor(top: topAnchor)
        titleView.anchor(top: imageView.topAnchor, bottom: imageView.bottomAnchor)
        spacerView.anchorSquare(size: 30)
        spacerView.anchor(top: imageView.bottomAnchor, bottom: bottomAnchor)
        
        if !titleSide {
            titleView.anchor(left: imageView.rightAnchor, right: rightAnchor, leftConstant: Theme.Offset.small)
        } else {
            titleView.anchor(left: leftAnchor, right: imageView.leftAnchor, rightConstant: Theme.Offset.small)
        }
    }
    
    private func configureUI(withStation station: StationMarker) {
        imageView.image = UIImage(named: station.markerImage)
        titleView.image = UIImage(named: station.markerTitleImage)
        titleView.contentMode = .scaleAspectFit
    }
}

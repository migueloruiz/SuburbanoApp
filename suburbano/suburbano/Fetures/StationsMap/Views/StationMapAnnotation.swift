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
    
    struct Costants {
        static let normalSize: CGFloat = 30 // TODO
        static let selectedSize: CGFloat = 60 // TODO
    }
    
    deinit {
        print("deinit")
    }
    
    private var imageView = UIImageView()
    private lazy var titleView = UIImageView()
    private var markerSizeConstaints: [NSLayoutConstraint] = []
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(station: StationMarker) {
        super.init(reuseIdentifier: station.markerIdentifier)
        configureUI()
        configureLayout(titleSide: station.titleSide)
    }
    
    var isActive: Bool {
        get {
            return titleView.alpha == 1
        }
        
        set(value) {
            for contraint in markerSizeConstaints {
                contraint.constant = value ? Costants.normalSize : Costants.selectedSize
            }
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.titleView.alpha = value ? 1 : 0
                strongSelf.layoutIfNeeded()
            }
        }
    }
    
    override var annotation: MGLAnnotation? {
        didSet {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.alpha = strongSelf.annotation == nil ? 0 : 1
            }
        }
    }
    
    private func configureLayout(titleSide: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        let spacerView = UIView()
        addSubViews([imageView, titleView, spacerView])
        imageView.anchorCenterXToSuperview()
        imageView.anchor(top: topAnchor)
        markerSizeConstaints = imageView.anchorSize(height: 30)
        imageView.anchorSize(width: imageView.heightAnchor, widthMultiplier: 0.8, height: nil)
        
        titleView.anchor(top: imageView.topAnchor, bottom: imageView.bottomAnchor)
        spacerView.anchorSize(width: imageView.widthAnchor, height: imageView.heightAnchor)
        spacerView.anchor(top: imageView.bottomAnchor, bottom: bottomAnchor)
        
        if !titleSide {
            titleView.anchor(left: imageView.rightAnchor, right: rightAnchor, leftConstant: Theme.Offset.small)
        } else {
            titleView.anchor(left: leftAnchor, right: imageView.leftAnchor, rightConstant: Theme.Offset.small)
        }
    }
    
    private func configureUI() {
        imageView.contentMode = .scaleAspectFit
        titleView.contentMode = .scaleAspectFit
    }
    
    func configure(with station: StationMarker) {
        imageView.image = UIImage(named: station.markerImage)
        titleView.image = UIImage(named: station.markerTitleImage)
    }
}

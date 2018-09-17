//
//  StationAnnotation.swift
//  suburbano
//
//  Created by Miguel Ruiz on 17/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import Mapbox

enum AnnotationDisplayStyle {
    case normal
    case detail
    case trip(active: Bool)
}

class StationMapAnnotation: MGLAnnotationView {
    
    struct Costants {
        static let normalSize: CGFloat = 30 // TODO
        static let normalOffset: CGFloat = -15 // TODO
        static let selectedSize: CGFloat = 60 // TODO
        static let selectedOffset: CGFloat = -30 // TODO
    }

    private(set) var id: String = ""
    private let imageView = UIImageView()
    private let titleView = UIImageView()
    private var markerSizeConstaints: [NSLayoutConstraint] = []
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(station: StationMarker) {
        super.init(reuseIdentifier: station.markerIdentifier)
        configureUI()
        configureLayout(titleSide: station.titleSide)
    }
    
    var diaplayStyle: AnnotationDisplayStyle = .normal {
        didSet {
            updateDisplay(with: diaplayStyle)
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
        scalesWithViewingDistance = false
        translatesAutoresizingMaskIntoConstraints = false
        addSubViews([imageView, titleView])
        imageView.anchorCenterXToSuperview()
        imageView.anchor(top: topAnchor, bottom: bottomAnchor)
        markerSizeConstaints = imageView.anchorSize(height: Costants.normalSize)
        centerOffset = CGVector(dx: 0, dy: Costants.normalOffset)
        imageView.anchorSize(width: imageView.heightAnchor, widthMultiplier: 0.8, height: nil)
        titleView.anchor(top: imageView.topAnchor, bottom: imageView.bottomAnchor)
        
        if !titleSide {
            titleView.anchor(left: imageView.rightAnchor, right: rightAnchor, leftConstant: Theme.Offset.small)
        } else {
            titleView.anchor(left: leftAnchor, right: imageView.leftAnchor, rightConstant: Theme.Offset.small)
        }
    }
    
    private func configureUI() {
        imageView.contentMode = .scaleAspectFit
        titleView.contentMode = .scaleAspectFit
        updateDisplay(with: diaplayStyle)
    }
    
    func configure(with station: StationMarker) {
        id = station.name
        imageView.image = UIImage(named: station.markerImage)
        titleView.image = UIImage(named: station.markerTitleImage)
    }
    
    private func updateDisplay(with style: AnnotationDisplayStyle) {
        var titleAlpha: CGFloat = 1
        
        switch style {
        case .normal:
            imageView.alpha = 1
            imageView.tintColor = Theme.Pallete.darkRed
            titleAlpha = 1
            for contraint in markerSizeConstaints {
                contraint.constant = Costants.normalSize
                centerOffset = CGVector(dx: 0, dy: Costants.normalOffset)
            }
        case .detail:
            imageView.alpha = 1
            imageView.tintColor = Theme.Pallete.darkRed
            titleAlpha = 0
            for contraint in markerSizeConstaints {
                contraint.constant = Costants.selectedSize
                centerOffset = CGVector(dx: 0, dy: Costants.selectedOffset)
            }
        case .trip(let active):
            imageView.alpha = active ? 1: 0.5
            titleAlpha = 0
        }
        guard titleView.alpha != titleAlpha else { return }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.titleView.alpha = titleAlpha
            strongSelf.layoutIfNeeded()
        }
    }
}

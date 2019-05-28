//
//  DetailTableHeader.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/1/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

protocol DetailTableHeaderDelegate: class {
    func tapShowLocation()
}

class DetailTableHeader: UIView {

    struct Constant {
        static let deafiltImageSize = CGSize(width: 100, height: 28)
        static let expectedImageHeigth: CGFloat = 28
    }

    private lazy var stationLabel = UILabel(fontStyle: .primary, alignment: .left, line: .oneLinne, color: .detail)
    private lazy var locationButton = UIButton(circularStyle: .secondary, image: #imageLiteral(resourceName: "cursor"))
    private let stationNameImage = UIImageView()
    private weak var delegate: DetailTableHeaderDelegate?

    init(titleImageName: String, delegate: DetailTableHeaderDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        configureUI(titleImageName: titleImageName)
        confiureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(titleImageName: String) {
        stationLabel.text = "ESTACION" // Localize
        stationNameImage.image = UIImage(named: titleImageName)
        stationNameImage.contentMode = .scaleAspectFit
        locationButton.addTarget(self, action: #selector(DetailTableHeader.showLocation), for: .touchUpInside)
    }

    private func confiureLayout() {
        let separator = UIView.createSeparator()
        addSubViews([stationLabel, stationNameImage, locationButton, separator])

        stationLabel.anchor(top: topAnchor, topConstant: Theme.Offset.large)
        stationLabel.anchor(left: leftAnchor, leftConstant: Theme.Offset.large)

        stationNameImage.anchor(top: stationLabel.bottomAnchor, topConstant: Theme.Offset.small)
        stationNameImage.anchor(left: leftAnchor, leftConstant: Theme.Offset.large)

        let sacleSize = scaleImage(actualSize: stationNameImage.image?.size ?? Constant.deafiltImageSize, withHeight: Constant.expectedImageHeigth)
        stationNameImage.anchorSize(width: sacleSize.width, height: sacleSize.height)

        locationButton.anchor(top: stationLabel.topAnchor, topConstant: Theme.Offset.small)
        locationButton.anchor(right: rightAnchor, rightConstant: Theme.Offset.large)
        locationButton.anchor(bottom: bottomAnchor, bottomConstant: Theme.Offset.large)

        separator.anchor(bottom: bottomAnchor)
        separator.fillHorizontal(offset: Theme.Offset.large)
    }

    @objc func showLocation() {
        delegate?.tapShowLocation()
    }

    fileprivate func scaleImage(actualSize: CGSize, withHeight height: CGFloat) -> CGSize {
        let width = (actualSize.width * height) / actualSize.height
        return CGSize(width: width, height: height)
    }
}

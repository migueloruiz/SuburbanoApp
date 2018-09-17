//
//  AcvtivityCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol AcvtivityCellDelegate: class {
    func sheduleActivity(withId id: String)
    func shareActivity(withId id: String)
}

struct AcvtivityCellViewModel {
    let id: String
    let title: String
    let descripcion: String
    let date: String
    let schedule: String
    let category: Category
}

class AcvtivityCell: UITableViewCell, ReusableIdentifier {
    
    struct Constants {
        static let dateIconsSize: CGFloat = Theme.IconSize.extraSmall
    }
    
    weak var delegate: AcvtivityCellDelegate?
    private var id = ""
    
    private let contanerView = UIStackView.with(axis: .vertical, distribution: .fill, spacing: Theme.Offset.normal)
    private let lineSeparator = UIView()
    private lazy var titleLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardTitle)
    private lazy var dateLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardDetails)
    private lazy var scheduleLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardDetails)
    private lazy var descripcionLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    private lazy var bottomLineImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "BottomLineCard"))
    private lazy var scheduleButton = UIFactory.createButton(withTheme: UIThemes.Button.ActivityCard)
    private lazy var shareButton = UIFactory.createButton(withTheme: UIThemes.Button.ActivityCard)

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    func configure(with activity: AcvtivityCellViewModel, delegate: AcvtivityCellDelegate) {
        id = activity.id
        titleLabel.text = activity.title
        descripcionLabel.text = activity.descripcion.firstUppercased
        dateLabel.text = activity.date.firstUppercased
        scheduleLabel.text = activity.schedule
        bottomLineImage.tintColor = color(for: activity.category)
        self.delegate = delegate
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .white
        accessibilityTraits = .notEnabled
        
        contanerView.layoutMargins = UIEdgeInsets.with(vertical: Theme.Offset.normal, horizoltal: Theme.Offset.large)
        contanerView.isLayoutMarginsRelativeArrangement = true
        contanerView.backgroundColor = .white
        
        scheduleButton.set(title: "Angendar")
        scheduleButton.addTarget(self, action: #selector(AcvtivityCell.sheduleActivity), for: .touchUpInside)
        shareButton.set(title: "Compartir")
    }
    
    private func configureLayout() {
        let cardView = UIFactory.createCardView()
        addSubViews([cardView, bottomLineImage])
        
        cardView.fillSuperview(verticalOffset: Theme.Offset.normal, horizontalOffset: Theme.Offset.normal)
        cardView.addSubview(contanerView)
        contanerView.fillSuperview()
        bottomLineImage.anchor(left: cardView.leftAnchor, bottom: cardView.bottomAnchor, right: cardView.rightAnchor)
        
        let calendarImage = UIFactory.createSquare(image: #imageLiteral(resourceName: "calendar"), size: Constants.dateIconsSize)
        let clockImage = UIFactory.createSquare(image: #imageLiteral(resourceName: "clock"), size: Constants.dateIconsSize)
        let dateStack = UIStackView.with(distribution: .fill, alignment: .fill, spacing: Theme.Offset.small)
        dateStack.addArranged(subViews: [clockImage, scheduleLabel, calendarImage, dateLabel])
        dateStack.backgroundColor = .white
        
        lineSeparator.backgroundColor = Theme.Pallete.softGray
        lineSeparator.roundCorners(withRadius: Theme.Offset.separator)
        lineSeparator.anchorSize(width: Theme.Offset.separator)
        
        let buttonsStack = UIStackView.with()
        buttonsStack.backgroundColor = .white
        buttonsStack.anchorSize(height: Theme.IconSize.small)
        buttonsStack.addArranged(subViews: [scheduleButton, lineSeparator, shareButton])
        
        contanerView.addArranged(subViews: [titleLabel, dateStack, descripcionLabel, buttonsStack])
        accessibilityElements = [titleLabel, dateLabel, scheduleLabel, descripcionLabel, scheduleButton, shareButton]
    }
    
    @objc func sheduleActivity() {
        delegate?.sheduleActivity(withId: id)
    }
}

extension AcvtivityCell {
    private func color(for category: Category) -> UIColor {
        switch category {
        case .concert: return Theme.Pallete.concert
        case .workshop: return Theme.Pallete.workshop
        case .fair: return Theme.Pallete.fair
        case .exhibition: return Theme.Pallete.exhibition
        default: return Theme.Pallete.special
        }
    }
}

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
    
    fileprivate let lineSeparator = UIView()
    fileprivate lazy var titleLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardTitle)
    fileprivate lazy var dateLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardDetails)
    fileprivate lazy var scheduleLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardDetails)
    fileprivate lazy var descripcionLabel: UILabel = UIFactory.createLable(withTheme: UIThemes.Label.ActivityCardBody)
    fileprivate lazy var bottomLineImage: UIImageView = UIImageView(image: AppImages.Strech.cardBase)

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    private func configureLayout() {
        // TODO: Add Configure UI
        selectionStyle = .none
        backgroundColor = .white
        accessibilityTraits = UIAccessibilityTraitNotEnabled
        
        let contanerView = UIStackView.with(axis: .vertical, distribution: .fill, spacing: Theme.Offset.normal)
        contanerView.layoutMargins = UIEdgeInsets.with(vertical: Theme.Offset.normal, horizoltal: Theme.Offset.large)
        contanerView.isLayoutMarginsRelativeArrangement = true
        contanerView.backgroundColor = .white
        
        let cardView = UIFactory.createCardView()
        addSubViews([cardView, bottomLineImage])
        
        cardView.fillSuperview(verticalOffset: Theme.Offset.normal, horizontalOffset: Theme.Offset.normal)
        cardView.addSubview(contanerView)
        contanerView.fillSuperview()
        bottomLineImage.anchor(left: cardView.leftAnchor, bottom: cardView.bottomAnchor, right: cardView.rightAnchor)
        
        let calendarImage = UIImageView(image: #imageLiteral(resourceName: "calendar"))
        calendarImage.anchorSquare(size: Constants.dateIconsSize)
        let clockImage = UIImageView(image: #imageLiteral(resourceName: "clock"))
        clockImage.anchorSquare(size: Constants.dateIconsSize)
        
        let dateStack = UIStackView.with(distribution: .fill, alignment: .fill, spacing: Theme.Offset.small)
        dateStack.addArranged(subViews: [clockImage, scheduleLabel, calendarImage, dateLabel])
        dateStack.backgroundColor = .white
        
        let scheduleButton = UIFactory.createButton(withTheme: UIThemes.Button.ActivityCard, title: "Angendar")
        scheduleButton.addTarget(self, action: #selector(AcvtivityCell.sheduleActivity), for: .touchUpInside)
        let shareButton = UIFactory.createButton(withTheme: UIThemes.Button.ActivityCard, title: "Compartir")
        
        // TODO Separator factory
        lineSeparator.backgroundColor = Theme.Pallete.softGray
        lineSeparator.roundCorners(withRadius: Theme.Offset.separator)
        lineSeparator.anchorSize(height: Theme.Offset.separator)
        
        let buttonsStack = UIStackView.with()
        buttonsStack.backgroundColor = .white
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

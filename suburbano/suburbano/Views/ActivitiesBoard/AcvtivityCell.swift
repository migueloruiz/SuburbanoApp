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
    
    weak var delegate: AcvtivityCellDelegate?
    
    private let titleLabel = UILabel()
    private let descripcionLabel = UILabel()
    private let dateLabel = UILabel()
    private let scheduleLabel = UILabel()
    private let calendarImage = UIImageView()
    private let clockImage = UIImageView()
    private let bottomLineImage = UIImageView()
    private let lineSeparator = UIView()
    private let scheduleButton = UIButton()
    private let shareButton = UIButton()
    private var id = ""

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
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
        accessibilityTraits = UIAccessibilityTraitNotEnabled
        
        let contanerView = UIStackView.with(axis: .vertical, distribution: .fill, spacing: Theme.Offset.normal)
        contanerView.backgroundColor = .red
        contanerView.layoutMargins = UIEdgeInsets.with(vertical: Theme.Offset.normal, horizoltal: Theme.Offset.large)
        contanerView.isLayoutMarginsRelativeArrangement = true
        
        let shadowView = UIView()
        shadowView.roundCorners()
        shadowView.backgroundColor = .white
        shadowView.dropShadow(color: .black, offSet: CGSize(width: 2, height: 2))
        
        addSubViews([shadowView, bottomLineImage])
        shadowView.fillSuperview(verticalOffset: Theme.Offset.normal, horizontalOffset: Theme.Offset.normal)
        shadowView.addSubview(contanerView)
        contanerView.fillSuperview()
        bottomLineImage.anchor(left: shadowView.leftAnchor, bottom: shadowView.bottomAnchor, right: shadowView.rightAnchor)
        bottomLineImage.image = #imageLiteral(resourceName: "BottomLineCard").resizableImage(withCapInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        
        let font = Font()
        titleLabel.font = font.defaultFont
        titleLabel.textColor = Theme.Pallete.darkGray
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        
        calendarImage.image = #imageLiteral(resourceName: "calendar")
        calendarImage.anchor(widthConstant: 15, heightConstant: 15)
        let font3 = Font(size: Theme.FontSize.p, name: .openSansCondensed, style: .bold)
        dateLabel.numberOfLines = 0
        dateLabel.font = font3.defaultFont
        dateLabel.textColor = Theme.Pallete.darkGray
        clockImage.image = #imageLiteral(resourceName: "clock")
        clockImage.anchor(widthConstant: 15, heightConstant: 15)
        scheduleLabel.numberOfLines = 0
        scheduleLabel.font = font3.defaultFont
        scheduleLabel.textColor = Theme.Pallete.darkGray
        
        let dateStack = UIStackView.with(distribution: .fill, alignment: .center, spacing: Theme.Offset.small)
        dateStack.addArranged(subViews: [calendarImage, dateLabel, clockImage, scheduleLabel])
        
        descripcionLabel.numberOfLines = 0
        let font2 = Font(size: Theme.FontSize.p)
        descripcionLabel.font = Font.getScaledFont(forFont: Theme.FontName.montserrat.rawValue, textStyle: .body)
        descripcionLabel.minimumScaleFactor = 10
        descripcionLabel.textColor = Theme.Pallete.softGray
        descripcionLabel.adjustsFontSizeToFitWidth = true
        descripcionLabel.adjustsFontForContentSizeCategory = true
        
        scheduleButton.setTitle("Angendar", for: .normal)
        scheduleButton.setTitle("Angendar", for: .focused)
        scheduleButton.setTitleColor(Theme.Pallete.darkGray, for: .normal)
        scheduleButton.titleLabel?.textColor = Theme.Pallete.softGray
        scheduleButton.titleLabel?.font = font2.defaultFont
        scheduleButton.addTarget(self, action: #selector(AcvtivityCell.sheduleActivity), for: .touchUpInside)
        
        lineSeparator.backgroundColor = Theme.Pallete.softGray.withAlphaComponent(0.5)
        lineSeparator.roundCorners(withRadius: 1)
        lineSeparator.anchor(widthConstant: 1)
        
        shareButton.setTitle("Compartir", for: .normal)
        shareButton.setTitle("Compartir", for: .focused)
        shareButton.setTitleColor(Theme.Pallete.darkGray, for: .normal)
        shareButton.titleLabel?.textColor = Theme.Pallete.softGray
        shareButton.titleLabel?.font = font2.defaultFont
        
        let buttonsStack = UIStackView.with()
        buttonsStack.addArranged(subViews: [scheduleButton, lineSeparator, shareButton])
        
        contanerView.addArranged(subViews: [titleLabel, dateStack, descripcionLabel, buttonsStack])
        
        accessibilityElements = [titleLabel, dateLabel, scheduleLabel, descripcionLabel, scheduleButton, shareButton]
    }
    
    @objc func sheduleActivity() {
        delegate?.sheduleActivity(withId: id)
    }
}

extension AcvtivityCell {
//    private func image(for category: Category) -> UIImage {
//        switch category {
//        case .concert: return AppImages.Activity.concert
//        case .workshop: return AppImages.Activity.workshop
//        case .fair: return AppImages.Activity.fair
//        case .exhibition: return AppImages.Activity.exhibition
//        default: return AppImages.Activity.special
//        }
//    }
 
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

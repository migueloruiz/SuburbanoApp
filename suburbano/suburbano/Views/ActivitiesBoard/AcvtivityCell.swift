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
        static let largePadding: CGFloat = 20
        static let generalPadding: CGFloat = 10
        static let smallPadding: CGFloat = 5
    }
    
    weak var delegate: AcvtivityCellDelegate?
    
    private let contanerView = UIView()
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
        
        backgroundColor = .clear
        
        contanerView.backgroundColor = .white
        
        addSubViews([contanerView])
        contanerView.roundCorners()
        contanerView.dropShadow(color: .black, offSet: CGSize(width: 2, height: 2))
        contanerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: Constants.generalPadding, leftConstant: Constants.generalPadding, bottomConstant: Constants.generalPadding, rightConstant: Constants.generalPadding)
        
        calendarImage.image = #imageLiteral(resourceName: "calendar")
        clockImage.image = #imageLiteral(resourceName: "clock")
        contanerView.addSubViews([titleLabel, descripcionLabel, dateLabel, scheduleLabel, calendarImage, clockImage, bottomLineImage, lineSeparator, scheduleButton, shareButton])
        
        titleLabel.anchor(top: contanerView.topAnchor, left:  contanerView.leftAnchor, right: contanerView.rightAnchor, topConstant: Constants.generalPadding, leftConstant: Constants.largePadding, rightConstant: Constants.largePadding)
        
        let font = Font()
        titleLabel.font = font.defaultFont
        titleLabel.textColor = Theme.Pallete.darkGray
        titleLabel.numberOfLines = 0
        
        let font3 = Font(size: Theme.FontSize.p, name: .openSansCondensed, style: .bold)
        calendarImage.anchor(left: titleLabel.leftAnchor, widthConstant: 15, heightConstant: 15)
        dateLabel.center(x: nil, y: calendarImage.centerYAnchor)
        dateLabel.anchor(top: titleLabel.bottomAnchor, left: calendarImage.rightAnchor, topConstant: Constants.smallPadding, leftConstant: Constants.smallPadding)
        dateLabel.numberOfLines = 0
        dateLabel.font = font3.defaultFont
        dateLabel.textColor = Theme.Pallete.darkGray
        
        clockImage.center(x: nil, y: calendarImage.centerYAnchor)
        clockImage.anchor(left: dateLabel.rightAnchor, leftConstant: Constants.generalPadding, widthConstant: 15, heightConstant: 15)
        scheduleLabel.center(x: nil, y: calendarImage.centerYAnchor)
        scheduleLabel.anchor(left: clockImage.rightAnchor, leftConstant: Constants.smallPadding)
        scheduleLabel.numberOfLines = 0
        scheduleLabel.font = font3.defaultFont
        scheduleLabel.textColor = Theme.Pallete.darkGray
        
        descripcionLabel.anchor(top: dateLabel.bottomAnchor, left: titleLabel.leftAnchor, right: titleLabel.rightAnchor, topConstant: Constants.generalPadding, bottomConstant: Constants.largePadding)
        descripcionLabel.numberOfLines = 0
        let font2 = Font(size: Theme.FontSize.p)
        descripcionLabel.font = font2.defaultFont
        descripcionLabel.textColor = Theme.Pallete.softGray
        
        scheduleButton.setTitle("Angendar", for: .normal)
        scheduleButton.setTitle("Angendar", for: .focused)
        scheduleButton.setTitleColor(Theme.Pallete.darkGray, for: .normal)
        scheduleButton.titleLabel?.textColor = Theme.Pallete.softGray
        scheduleButton.titleLabel?.font = font2.defaultFont
        scheduleButton.anchor(top: descripcionLabel.bottomAnchor, left: contanerView.leftAnchor, bottom: contanerView.bottomAnchor, right: lineSeparator.leftAnchor, topConstant: Constants.generalPadding, leftConstant: Constants.generalPadding, bottomConstant: Constants.generalPadding)
        scheduleButton.addTarget(self, action: #selector(AcvtivityCell.sheduleActivity), for: .touchUpInside)
        
        lineSeparator.backgroundColor = Theme.Pallete.softGray.withAlphaComponent(0.5)
        lineSeparator.center(x: contanerView.centerXAnchor, y: nil)
        lineSeparator.roundCorners(withRadius: 1)
        lineSeparator.anchor(top: scheduleButton.topAnchor, bottom: scheduleButton.bottomAnchor, widthConstant: 0.7)
        
        shareButton.setTitle("Compartir", for: .normal)
        shareButton.setTitle("Compartir", for: .focused)
        shareButton.setTitleColor(Theme.Pallete.darkGray, for: .normal)
        shareButton.titleLabel?.textColor = Theme.Pallete.softGray
        shareButton.titleLabel?.font = font2.defaultFont
        shareButton.anchor(top: descripcionLabel.bottomAnchor, left: lineSeparator.rightAnchor, bottom: contanerView.bottomAnchor, right: titleLabel.rightAnchor, topConstant: Constants.generalPadding, bottomConstant: Constants.generalPadding)
        
        bottomLineImage.anchor(left: contanerView.leftAnchor, bottom: contanerView.bottomAnchor, right: contanerView.rightAnchor)
        bottomLineImage.image = #imageLiteral(resourceName: "BottomLineCard").resizableImage(withCapInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
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

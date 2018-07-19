//
//  AcvtivityCell.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

//protocol ActivityEntity {
//    var id: String { get }
//    var title: String { get }
//    var descripcion: String { get }
//    var startDate: String { get }
//    var endDate: String? { get }
//    var schedule: String { get }
//    var category: String { get }
//    var loaction: String { get }
//}

import UIKit

class AcvtivityCell: UITableViewCell, ReusableIdentifier {
    
    let titleLabel = UILabel()
    let descripcionLabel = UILabel()
    let dateLabel = UILabel()
    let scheduleLabel = UILabel()
    let loactionLabel = UILabel()
    let categoryLabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .green
        addSubViews([titleLabel, descripcionLabel, dateLabel, scheduleLabel, loactionLabel, categoryLabel])
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor)
        descripcionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor)
        dateLabel.anchor(top: descripcionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor)
        scheduleLabel.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor)
        loactionLabel.anchor(top: scheduleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor)
        categoryLabel.anchor(top: loactionLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    func configure(with activity: Activity) {
        titleLabel.text = activity.title
        descripcionLabel.text = activity.descripcion
        dateLabel.text = "\(activity.startDate) \(activity.endDate ?? "")"
        scheduleLabel.text = activity.schedule
        loactionLabel.text = activity.loaction
        categoryLabel.text = activity.category
    }
}

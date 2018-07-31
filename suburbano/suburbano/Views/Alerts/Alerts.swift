//
//  Alerts.swift
//  suburbano
//
//  Created by Miguel Ruiz on 20/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class AlertFactory {
    
    static func schedule(complition: @escaping ((Calendar) -> Void)) -> UIAlertController {
        let shedulAction = UIAlertController(title: nil, message: "Agendar actividad", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        let appleCalendarAction = UIAlertAction(title: "Agendar en Calendar", style: .default, handler: { _ in complition(.apple) })
        shedulAction.addAction(appleCalendarAction)
        shedulAction.addAction(cancelAction)
        return shedulAction
    }
    
}

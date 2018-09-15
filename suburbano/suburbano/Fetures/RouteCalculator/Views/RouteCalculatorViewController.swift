//
//  RouteCalculatorViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 13/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class RouteCalculatorViewController: UIViewController, PresentableView {
    
    var inTransition: UIViewControllerAnimatedTransitioning? = RouteCalculatorTransitionIn()
    var outTransition: UIViewControllerAnimatedTransitioning? = RouteCalculatorTransitionOut()
    
    private let pickerData = [#imageLiteral(resourceName: "CuautitlanMarkerTitle"), #imageLiteral(resourceName: "TultitlanMarkerTitle"), #imageLiteral(resourceName: "LecheriaMarkerTitle"), #imageLiteral(resourceName: "SanRafaelMarkerTitle"), #imageLiteral(resourceName: "TalnepantlaMarkerTitle"), #imageLiteral(resourceName: "FortunaMarkerTitle"), #imageLiteral(resourceName: "BuenavistaMarkerTitle")]
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    let pickerContainer = UIFactory.createContainerView()
    private let resultsContainer = UIFactory.createContainerView()
    private let departurePicker = UIPickerView()
    private let departureLabel = UIFactory.createLable(withTheme: UIThemes.Label.StaionDetailStation)
    private let arrivalPicker = UIPickerView()
    private let arrivalLabel = UIFactory.createLable(withTheme: UIThemes.Label.StaionDetailStation)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StationDetailViewController.close)))
        
        departureLabel.text = "SALIDA"
        arrivalLabel.text = "LLEGADA"
        
        departurePicker.delegate = self
        departurePicker.dataSource = self
        departurePicker.backgroundColor = .white
        arrivalPicker.delegate = self
        arrivalPicker.dataSource = self
        arrivalPicker.backgroundColor = .white
        
        departurePicker.reloadAllComponents()
        arrivalPicker.reloadAllComponents()
    }
    
    private func configureLayout() {
        view.addSubViews([pickerContainer])
        pickerContainer.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, bottomConstant: -Theme.Offset.normal)
        
        pickerContainer.addSubViews([departurePicker, arrivalPicker, departureLabel, arrivalLabel])
        
        departurePicker.anchor(left: pickerContainer.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.centerXAnchor, bottomConstant: Theme.Offset.large)
        departurePicker.anchorSize(height: 90)
        arrivalPicker.anchor(top: departurePicker.topAnchor, left: view.centerXAnchor, bottom: departurePicker.bottomAnchor, right: pickerContainer.rightAnchor)
        
        departureLabel.anchor(top: pickerContainer.topAnchor, bottom: departurePicker.topAnchor, topConstant: Theme.Offset.normal, bottomConstant: -Theme.Offset.normal)
        departureLabel.center(x: departurePicker.centerXAnchor, y: nil)
        
        arrivalLabel.anchor(top: departureLabel.topAnchor, bottom: departureLabel.bottomAnchor)
        arrivalLabel.center(x: arrivalPicker.centerXAnchor, y: nil)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension RouteCalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let image = UIImageView(image: pickerData[row])
        image.tintColor = Theme.Pallete.darkGray
        return image
    }
}

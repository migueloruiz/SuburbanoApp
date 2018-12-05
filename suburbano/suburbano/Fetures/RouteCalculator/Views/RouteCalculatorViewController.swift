//
//  RouteCalculatorViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 13/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class RouteCalculatorViewController: UIViewController, PresentableView {
    
    struct Constants {
        static let DeparturePickerTag = 0
        static let ArrivalPickerTag = 1
        static let PickerHeigth: CGFloat = 110
    }
    
    var inTransition: UIViewControllerAnimatedTransitioning? = RouteCalculatorTransitionIn()
    var outTransition: UIViewControllerAnimatedTransitioning? = RouteCalculatorTransitionOut()
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    let containerView = UIFactory.createContainerView()
    let backButton = UIButton()
    
    private let presenter: RouteCalculatorPresenter
    private let resultsContainer = UIFactory.createContainerView()
    private let departurePicker = UIPickerView()
    private let departureLabel = UIFactory.createLable(withTheme: UIThemes.Label.InfoTitle)
    private let arrivalPicker = UIPickerView()
    private let backView = UIView()
    private let arrivalLabel = UIFactory.createLable(withTheme: UIThemes.Label.InfoTitle)
    private let routeInfoView = RouteInfoView()
    
    weak var routeCameraDelegate: RouteCameraDelegate?
    
    init(presenter: RouteCalculatorPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        presenter.load()
    }
    
    private func configureUI() {
        departureLabel.text = "SALIDA" //Localize
        arrivalLabel.text = "LLEGADA" //Localize
        
        departurePicker.delegate = self
        departurePicker.dataSource = self
        departurePicker.tag = Constants.DeparturePickerTag
        departurePicker.backgroundColor = .white
        arrivalPicker.delegate = self
        arrivalPicker.dataSource = self
        arrivalPicker.tag = Constants.ArrivalPickerTag
        arrivalPicker.backgroundColor = .white
        routeInfoView.roundCorners()
        
        departurePicker.reloadAllComponents()
        arrivalPicker.reloadAllComponents()
        
        backButton.set(image: #imageLiteral(resourceName: "down-arrow"), color: Theme.Pallete.darkGray)
        backButton.addTarget(self, action: #selector(StationDetailViewController.close), for: .touchUpInside)
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StationDetailViewController.close)))
    }
    
    private func configureLayout() {
        view.addSubViews([containerView, backView, backButton])
        backView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: containerView.topAnchor, right: view.rightAnchor)

        containerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, bottomConstant: -Theme.Offset.large)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.large)
        backButton.anchorSquare(size: Theme.IconSize.button)
        
        containerView.addSubViews([departurePicker, arrivalPicker, departureLabel, arrivalLabel, routeInfoView])
        
        routeInfoView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor)
        
        departureLabel.anchor(top: routeInfoView.bottomAnchor, topConstant: Theme.Offset.large)
        departureLabel.center(x: departurePicker.centerXAnchor, y: nil)
        arrivalLabel.anchor(top: departureLabel.topAnchor, bottom: departureLabel.bottomAnchor)
        arrivalLabel.center(x: arrivalPicker.centerXAnchor, y: nil)
        
        departurePicker.anchor(top: departureLabel.bottomAnchor, left: containerView.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.centerXAnchor, topConstant: Theme.Offset.normal, bottomConstant: Theme.Offset.large)
        departurePicker.anchorSize(height: Constants.PickerHeigth)
        arrivalPicker.anchor(top: departurePicker.topAnchor, left: view.centerXAnchor, bottom: departurePicker.bottomAnchor, right: containerView.rightAnchor)
    }
    
    private func setSelectedStations() {
        let selectedItems = presenter.selectedElements()
        departurePicker.selectRow(selectedItems.departureItem, inComponent: 0, animated: false)
        arrivalPicker.selectRow(selectedItems.arraivalItem, inComponent: 0, animated: false)
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension RouteCalculatorViewController: RouteCalculatorViewDelegate {
    func update(route: Route) {
        departurePicker.reloadAllComponents()
        arrivalPicker.reloadAllComponents()
        setSelectedStations()
        routeCameraDelegate?.setRouteCamera(departure: route.departure, arraival: route.arraival)
        routeInfoView.update(with: route.information)
    }
}

extension RouteCalculatorViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter.elementsFor(pickerId: pickerView.tag)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let image = presenter.getImage(forPicker: pickerView.tag, at: row)
        let imageView = UIImageView(image: UIImage(named: image))
        imageView.tintColor = Theme.Pallete.darkGray
        return imageView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter.didChange(selcteItem: row, atPicker: pickerView.tag)
    }
}

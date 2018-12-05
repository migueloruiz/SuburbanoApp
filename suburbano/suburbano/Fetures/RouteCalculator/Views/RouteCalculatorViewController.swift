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
    private let daySelector = DaySelectorView()
    private let waitTimeDetail = WaitTimeDetail()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        waitTimeDetail.reload()
    }
    
    private func configureUI() {
        departureLabel.text = "SALIDA" //Localize
        arrivalLabel.text = "LLEGADA" //Localize
        
        departurePicker.delegate = self
        departurePicker.dataSource = self
        departurePicker.tag = 0
        departurePicker.backgroundColor = .white
        arrivalPicker.delegate = self
        arrivalPicker.dataSource = self
        arrivalPicker.tag = 1
        arrivalPicker.backgroundColor = .white
        
        daySelector.configure(items: presenter.getWeekDays())
        daySelector.delegate = self
        
        departurePicker.reloadAllComponents()
        arrivalPicker.reloadAllComponents()
    
        backButton.addTarget(self, action: #selector(StationDetailViewController.close), for: .touchUpInside)
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StationDetailViewController.close)))
    }
    
    private func configureLayout() {
        view.addSubViews([containerView, backView, backButton])
        backView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: containerView.topAnchor, right: view.rightAnchor)

        containerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, bottomConstant: -Theme.Offset.large)
        containerView.anchorSize(height: (Utils.screenHeight * 0.7) + Theme.Offset.large) // TODO
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.large)
        backButton.anchorSquare(size: 25) // TODO
        
        containerView.addSubViews([departurePicker, arrivalPicker, departureLabel, arrivalLabel, routeInfoView, daySelector, waitTimeDetail])
        
        departureLabel.anchor(top: containerView.topAnchor, bottom: departurePicker.topAnchor, topConstant: Theme.Offset.normal, bottomConstant: -Theme.Offset.normal)
        departureLabel.center(x: departurePicker.centerXAnchor, y: nil)
        
        arrivalLabel.anchor(top: departureLabel.topAnchor, bottom: departureLabel.bottomAnchor)
        arrivalLabel.center(x: arrivalPicker.centerXAnchor, y: nil)
        
        departurePicker.anchor(left: containerView.leftAnchor, right: view.centerXAnchor, bottomConstant: Theme.Offset.large)
        departurePicker.anchorSize(height: 90) // TODO
        arrivalPicker.anchor(top: departurePicker.topAnchor, left: view.centerXAnchor, bottom: departurePicker.bottomAnchor, right: containerView.rightAnchor)
        
        routeInfoView.anchor(top: arrivalPicker.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor)
        
        daySelector.anchor(top: routeInfoView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor, topConstant: Theme.Offset.small)
        waitTimeDetail.anchor(top: daySelector.bottomAnchor, left: containerView.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: containerView.rightAnchor, topConstant: Theme.Offset.small, leftConstant: Theme.Offset.large, bottomConstant: Theme.Offset.large, rightConstant: Theme.Offset.large)
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
    
    func update(waitTimes: [WaitTimeDetailModel]) {
        waitTimeDetail.configure(items: waitTimes)
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

extension RouteCalculatorViewController: DaySelectorDelegate {
    func didChange(daySelected: Int) {
        presenter.didChange(daySelected: daySelected)
    }
}

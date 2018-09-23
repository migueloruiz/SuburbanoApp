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
    private let departureLabel = UIFactory.createLable(withTheme: UIThemes.Label.StaionDetailStation)
    private let arrivalPicker = UIPickerView()
    private let backView = UIView()
    private let arrivalLabel = UIFactory.createLable(withTheme: UIThemes.Label.StaionDetailStation)
    private let routeInfoView = RouteInfoView()
    private let scheduleSelctor = MenuView(menuItemCase: .text, selectorStyle: .bottom, itemHeigth: Theme.IconSize.normal)
    fileprivate let scheduleTable = UITableView()
    
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
        departureLabel.textColor = Theme.Pallete.darkGray
        arrivalLabel.text = "LLEGADA" //Localize
        arrivalLabel.textColor = Theme.Pallete.darkGray
        
        departurePicker.delegate = self
        departurePicker.dataSource = self
        departurePicker.tag = 0
        departurePicker.backgroundColor = .white
        arrivalPicker.delegate = self
        arrivalPicker.dataSource = self
        arrivalPicker.tag = 1
        arrivalPicker.backgroundColor = .white
        
        departurePicker.reloadAllComponents()
        arrivalPicker.reloadAllComponents()
        
        scheduleSelctor.configure(items: presenter.daysItems())
        scheduleSelctor.delegate = self
        configureScheduleTable()
        
        backButton.set(image: #imageLiteral(resourceName: "down-arrow"), color: Theme.Pallete.darkGray)
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
        
        containerView.addSubViews([departurePicker, arrivalPicker, departureLabel, arrivalLabel, routeInfoView, scheduleSelctor, scheduleTable, scheduleTable])
        
        departureLabel.anchor(top: containerView.topAnchor, bottom: departurePicker.topAnchor, topConstant: Theme.Offset.normal, bottomConstant: -Theme.Offset.normal)
        departureLabel.center(x: departurePicker.centerXAnchor, y: nil)
        
        arrivalLabel.anchor(top: departureLabel.topAnchor, bottom: departureLabel.bottomAnchor)
        arrivalLabel.center(x: arrivalPicker.centerXAnchor, y: nil)
        
        departurePicker.anchor(left: containerView.leftAnchor, right: view.centerXAnchor, bottomConstant: Theme.Offset.large)
        departurePicker.anchorSize(height: 90) // TODO
        arrivalPicker.anchor(top: departurePicker.topAnchor, left: view.centerXAnchor, bottom: departurePicker.bottomAnchor, right: containerView.rightAnchor)
        
        routeInfoView.anchor(top: arrivalPicker.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor)
        
        scheduleSelctor.anchor(top: routeInfoView.bottomAnchor, left: containerView.leftAnchor, right: containerView.rightAnchor)
        
        scheduleTable.anchor(top: scheduleSelctor.bottomAnchor, left: containerView.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: containerView.rightAnchor)
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
    
    func updateSchedule() {
        scheduleTable.reloadData()
    }
    
    func showScheduleLoader() {
        
    }
}

extension RouteCalculatorViewController: MenuDelegate {
    func itemSelected(at index: Int) {
        presenter.did(selecteDay: index)
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
        presenter.did(selcteItem: row, atPicker: pickerView.tag)
    }
}

extension RouteCalculatorViewController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func configureScheduleTable() {
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        scheduleTable.backgroundColor = Theme.Pallete.ligthGray
        scheduleTable.separatorStyle = .none
        scheduleTable.allowsSelection = false
        scheduleTable.register(ScheduleTrainCell.self, forCellReuseIdentifier: ScheduleTrainCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfScheduleItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: ScheduleTrainCell.reuseIdentifier) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let scheduleCell = cell as? ScheduleTrainCell else { return }
        scheduleCell.configure(with: presenter.scheduleModel(at: indexPath.row))
    }
}

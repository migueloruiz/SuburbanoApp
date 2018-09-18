//
//  MainNavigationViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 13/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class NavigationalViewController: UIViewController {
    var navgationIcon: String { return "" }
}

class MainNavigationViewController: UIViewController {
    
    struct Constants {
        static let menuItemHeigth: CGFloat = Theme.IconSize.large
    }
    
    private let menuContainer = UIView()
    private let menuView = MenuView(menuItemCase: .image, selectorStyle: .top, itemHeigth: Constants.menuItemHeigth)
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    private var viewControllers: [NavigationalViewController] = []
    private var pageIndex = 0
    private var statusBarStyle: UIStatusBarStyle = .default
    override var preferredStatusBarStyle: UIStatusBarStyle { return statusBarStyle }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        menuContainer.backgroundColor = .white
        menuContainer.addDropShadow()
        menuView.delegate = self
    }
    
    private func configureLayout() {
        view.addSubViews([pageViewController.view, menuContainer])
        addChild(pageViewController)
        pageViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: menuContainer.topAnchor, right: view.rightAnchor)
        
        menuContainer.anchor(top: pageViewController.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        menuContainer.addSubViews([menuView])
        menuView.anchor(top: menuContainer.topAnchor, left: menuContainer.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: menuContainer.rightAnchor)
    }
    
    func setNavigation(viewControllers: [NavigationalViewController], startIndex: Int) {
        self.viewControllers = viewControllers
        menuView.configure(items: viewControllers.map { $0.navgationIcon }, selected: startIndex)
        setView(at: startIndex)
    }
    
    func selectedViewController() -> UIViewController {
        return viewControllers[pageIndex]
    }
    
    fileprivate func setView(at index: Int) {
        let direction: UIPageViewController.NavigationDirection = index > pageIndex ? .forward : .reverse
        pageIndex = index
        let controller = viewControllers[pageIndex]
        statusBarStyle = controller.preferredStatusBarStyle
        setNeedsStatusBarAppearanceUpdate()
        pageViewController.setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
}

extension MainNavigationViewController: MenuDelegate {
    func itemSelected(at index: Int) {
        setView(at: index)
    }
}

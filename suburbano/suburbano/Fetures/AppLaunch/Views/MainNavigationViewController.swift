//
//  MainNavigationViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 13/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class NavigationalViewController: UIViewController {
    var navgationIcon: UIImage { return UIImage() }
}

class MainNavigationViewController: UIViewController {
    
    struct Constants {
        static let menuItemHeigth: CGFloat = 49
        static let menuSelectorHeigth: CGFloat = 2
    }
    
    fileprivate let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    fileprivate var viewControllers: [NavigationalViewController] = []
    fileprivate var pageIndex = 0
    fileprivate lazy var menuItemSize = CGSize(width: view.frame.width / CGFloat(viewControllers.count), height: Constants.menuItemHeigth)
    fileprivate var menuSelectorSideConstraint: NSLayoutConstraint?
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return statusBarStyle }
    var statusBarStyle: UIStatusBarStyle = .default
    
    fileprivate lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var menuSelector: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Pallete.softRed
        return view
    }()
    
    fileprivate lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout:  layout)
        collection.backgroundColor = .white
        return collection
    }()
    
    override func viewDidLoad() {
        configureMenu()
        view.addSubViews([pageViewController.view, menuView])
        addChildViewController(pageViewController)
        pageViewController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: menuView.topAnchor, right: view.rightAnchor)
        
        menuView.anchor(top: pageViewController.view.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        menuView.addSubViews([menuCollectionView, menuSelector])
        menuCollectionView.anchor(top: menuView.topAnchor, left: menuView.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: menuView.rightAnchor, heightConstant: Constants.menuItemHeigth)
        
        let anchors = menuSelector.anchor(top: menuView.topAnchor, left: menuView.leftAnchor, widthConstant: menuItemSize.width, heightConstant: Constants.menuSelectorHeigth)
        menuSelectorSideConstraint = anchors.first(where: { $0.hasIdentifier(.left) })
    }
    
    func setNavigation(viewControllers: [NavigationalViewController], startIndex: Int) {
        self.viewControllers = viewControllers
        setView(at: startIndex)
        menuCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let strongSelf = self else { return }
            let indexPath = IndexPath(row: startIndex, section: 0)
            guard let _ = strongSelf.menuCollectionView.cellForItem(at: indexPath) else { return }
            strongSelf.menuCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            strongSelf.menuSelectorSideConstraint?.constant = CGFloat(startIndex) * strongSelf.menuItemSize.width
        }
    }
    
    fileprivate func setView(at index: Int) {
        let direction: UIPageViewControllerNavigationDirection = index > pageIndex ? .forward : .reverse
        pageIndex = index
        let controller = viewControllers[pageIndex]
        statusBarStyle = controller.preferredStatusBarStyle
        setNeedsStatusBarAppearanceUpdate()
        pageViewController.setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    fileprivate func setSelector(at index: Int) {
        guard let sideConstraint = menuSelectorSideConstraint else { return }
        sideConstraint.constant = CGFloat(index) * menuItemSize.width
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension MainNavigationViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    fileprivate func configureMenu() {
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.isScrollEnabled = false
        menuCollectionView.register(MenuItemView.self, forCellWithReuseIdentifier: MenuItemView.reuseIdentifier)
        menuCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuItemView.reuseIdentifier, for: indexPath) as? MenuItemView else {
            return UICollectionViewCell()
        }
        cell.configure(image: viewControllers[indexPath.row].navgationIcon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return menuItemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setView(at: indexPath.row)
        setSelector(at: indexPath.row)
    }
}

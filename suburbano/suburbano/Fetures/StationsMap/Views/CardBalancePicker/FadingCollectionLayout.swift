//
//  FadingCollectionLayout.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class FadingCollectionLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    private var previousOffset: CGFloat = 0
    private var currentPage = 0
    private let selectionFeedback = UISelectionFeedbackGenerator()
    
    override func prepare() {
        scrollDirection = .horizontal
        itemSize = CGSize(width: CardBalancePikerConstas.itemWidth, height: Theme.IconSize.normal)
        minimumLineSpacing = 0
        super.prepare()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool { return true }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesSuper: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: attributesSuper, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }
        
        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        for attribute in attributes {
            guard attribute.frame.intersects(rect) else { continue }
            let distance = abs(visibleRect.midX - attribute.center.x)
            attribute.alpha = fadeParabole(distance: distance)
        }
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return defultAlpha(at: itemIndexPath)
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return defultAlpha(at: itemIndexPath)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView,
            let itemsCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) else { return .zero }
        
        if (previousOffset > collectionView.contentOffset.x) && (velocity.x < 0) {
            currentPage = max(currentPage - 1, 0)
        } else if (previousOffset < collectionView.contentOffset.x) && (velocity.x > 0.0) {
            currentPage = min(currentPage + 1, itemsCount - 1)
        }
        
        let itemEdgeOffset = (collectionView.frame.width - itemSize.width -  minimumLineSpacing * 2) / 2
        let updatedOffset = (itemSize.width + minimumLineSpacing) * CGFloat(currentPage) - (itemEdgeOffset + minimumLineSpacing)
        previousOffset = updatedOffset
        selectionFeedback.selectionChanged()
        return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
    }
}

extension FadingCollectionLayout {
    fileprivate func defultAlpha(at index: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = layoutAttributesForItem(at: index)
        attributes?.alpha = CardBalancePikerConstas.defaultAlpha
        return attributes
    }
    
    fileprivate func fadeParabole(distance: CGFloat) -> CGFloat {
        return distance >= CardBalancePikerConstas.itemWidth ? CardBalancePikerConstas.defaultAlpha :
            abs((0.00005 * distance * distance * -1) + 1)
    }
}

//
//  CollectionViewPulledCardFlowLayout.swift
//  HIT
//
//  Created by Nathan Melehan on 1/15/16.
//  Copyright © 2016 Nathan Melehan. All rights reserved.
//

import Foundation

class CollectionViewPulledCardFlowLayout: CardFlowLayout
{
    var pulledCard: NSIndexPath?
    var pulledCardYOrigin: CGFloat = -50
    
    var retractedCardStackHeight: CGFloat = 50
    var retractedCardGap: CGFloat = 5
    
    var cardCache = [Int : UICollectionViewLayoutAttributes]()
    
    override func prepareLayout() {
        super.prepareLayout()
        
        print(cardCache)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElementsInRect(rect) else {
            return nil
        }
        
        print("in rect, bounds: \(self.collectionView!.bounds)")
        
        // filter for item attributes
        
        var attributes = superAttributes.map { (superAttributes) -> UICollectionViewLayoutAttributes in
            switch superAttributes.representedElementCategory
            {
            case .Cell:
                return layoutAttributesForItemAtIndexPath(superAttributes.indexPath)!
            default:
                return superAttributes
            }
        }
        
        if let pulledCard = pulledCard {
            attributes.append(layoutAttributesForItemAtIndexPath(pulledCard)!)
        }
        
        return attributes
    }
    
    func setYCoordinateForAttributes(attributes: UICollectionViewLayoutAttributes)
    {
        if attributes.indexPath == pulledCard
        {
            attributes.frame.origin.y = self.collectionView!.bounds.origin.y + pulledCardYOrigin
        }
        else if let cardAtTopOfStack = cardAtTopOfStack
                where attributes.indexPath.item >= cardAtTopOfStack.item
        {
            var n = CGFloat(attributes.indexPath.item - cardAtTopOfStack.item)
            if  let pulledCard = pulledCard
                where attributes.indexPath.item > pulledCard.item
            {
                n -= 1
            }
            
            let distanceFromTopToRetractedStack = self.collectionView!.bounds.height - retractedCardStackHeight
            attributes.frame.origin.y = self.collectionView!.bounds.origin.y + distanceFromTopToRetractedStack + n * retractedCardGap
        }
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let superAttributes = super.calculateLayoutAttributesForItemAtIndexPath(indexPath)!.copy() as! UICollectionViewLayoutAttributes
        
        setYCoordinateForAttributes(superAttributes)
        if indexPath == pulledCard {
            superAttributes.alpha = 1
        }
        
        return superAttributes
    }

    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        super.shouldInvalidateLayoutForBoundsChange(newBounds)
        
        return true
    }
    
    
    override func invalidationContextForBoundsChange(newBounds: CGRect)
        
        -> UICollectionViewLayoutInvalidationContext
    {
        let context = super.invalidationContextForBoundsChange(newBounds)
        
        var indexPathsToInvalidate = [NSIndexPath]()
        
        let bounds = self.collectionView!.bounds
        let attributesInOldBounds = super.layoutAttributesForElementsInRect(bounds)
        indexPathsToInvalidate += attributesInOldBounds?
            .map { (attributes) -> NSIndexPath in return attributes.indexPath }
            ?? []
        
        let attributesInNewBounds = super.layoutAttributesForElementsInRect(newBounds)
        indexPathsToInvalidate += attributesInNewBounds?
            .map { (attributes) -> NSIndexPath in return attributes.indexPath }
            ?? []
        
//        let items = indexPathsToInvalidate
//            .map { (path) -> Int in return path.item }
//            .sort()
        
        context.invalidateItemsAtIndexPaths(indexPathsToInvalidate)
        if let pulledCard = pulledCard {
            print("invalidating pulled card")
            context.invalidateItemsAtIndexPaths([pulledCard])
        }
        
        return context
    }
}
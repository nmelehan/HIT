//
//  PullableCardFlowLayout.swift
//  HIT
//
//  Created by Nathan Melehan on 1/20/16.
//  Copyright © 2016 Nathan Melehan. All rights reserved.
//

import UIKit

class PullableCardFlowLayout: CollectionViewCardFlowLayout
{
    
    
    //
    //
    //
    //
    // Properties
    
    lazy private var animator: UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    
    //
    // State information
    
    private var cardCache = [Int : UICollectionViewLayoutAttributes]()
    private var stackIsRetracted = false
    var pulledCard: NSIndexPath?
    var itemsInRetractedStack = [Int]() {
        didSet {
            itemsInRetractedStack = itemsInRetractedStack.sort()
        }
    }
    
    //
    // Metrics
    
    var pulledCardYOrigin: CGFloat = -50
    var retractedCardStackHeight: CGFloat = 50
    var retractedCardGap: CGFloat = 5
    
    
    
    //
    //
    //
    //
    // MARK: - Card pulling mechanism
    
    func frameForIndexPath(indexPath: NSIndexPath)
        
        -> CGRect
    {
        var frame = CGRect(
            origin: CGPoint(x: sectionInset.left, y: self.collectionView!.bounds.origin.y),
            size: cardSize)
        
        let item = indexPath.item
        
        if indexPath == pulledCard
        {
            frame.origin.y += pulledCardYOrigin
        }
        else if itemsInRetractedStack.contains(item)
        {
            var stackCardIndex = CGFloat(item - itemsInRetractedStack.first!)
            
            if  let pulledCard = pulledCard
                where itemsInRetractedStack.contains(item)
                    && item > pulledCard.item
            {
                stackCardIndex -= 1
            }
            
            let distanceFromTopToRetractedStack
            = self.collectionView!.bounds.height
                - retractedCardStackHeight
            
            frame.origin.y
                += distanceFromTopToRetractedStack
                + stackCardIndex * retractedCardGap
        }
        
        return frame
    }
    
    func setupAttachmentBehaviorForIndexPath(indexPath: NSIndexPath)
    {
        if cardCache[indexPath.item] == nil
        {
            
            let superAttributes = super.layoutAttributesForItemAtIndexPath(indexPath)!
                .copy() as! UICollectionViewLayoutAttributes
            
            let finalFrame = frameForIndexPath(indexPath)
            let finalCenter = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            let behavior = UIAttachmentBehavior(item: superAttributes,
                attachedToAnchor: finalCenter)
            
            print(behavior)
            
            behavior.length = 0.0
            behavior.damping = 1.0
            behavior.frequency = 2.0
            
            //            let pushBehavior = UIPushBehavior(items: [startingAttributes], mode: .Instantaneous)
            //            pushBehavior.angle = CGFloat(M_PI/4)
            //            pushBehavior.magnitude = 1.0
            //            animator?.addBehavior(pushBehavior)
            
            animator.addBehavior(behavior)
            cardCache[indexPath.item] = superAttributes
        }
    }
    
    func pullCardAtIndexPath(indexPath: NSIndexPath)
    {
        if !stackIsRetracted
        {
            itemsInRetractedStack
                = super.layoutAttributesForElementsInRect(self.collectionView!.bounds)!
                    .filter { $0.representedElementCategory == .Cell }
                    .map { $0.indexPath.item }
            
            stackIsRetracted = true
            
            pulledCard = indexPath
            for item in itemsInRetractedStack
            {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                setupAttachmentBehaviorForIndexPath(indexPath)
            }
        }
    }
    
    
    
    //
    //
    //
    //
    // MARK: - UIDynamicAnimatorDelegate
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        animator.removeAllBehaviors()
    }
    
    
    
    //
    //
    //
    //
    // MARK: - UICollectionViewLayout subclassing
    
    override func prepareLayout() {
        super.prepareLayout()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        //        print("in rect: \(rect)")
        guard let superAttributes = super.layoutAttributesForElementsInRect(rect) else {
            return nil
        }
        
        if !stackIsRetracted
        {
            return superAttributes
        }
        
        // filter for item attributes
        let cardSuperAttributes = superAttributes
            .filter { $0.representedElementCategory == .Cell }
        
        let allOtherSuperAttributes = superAttributes
            .filter { $0.representedElementCategory != .Cell }
        
        let cardFlowAttributes = cardSuperAttributes
            .filter { !itemsInRetractedStack.contains($0.indexPath.item) }
        
        let retractedAndPulledCardAttributes = itemsInRetractedStack
            .map { cardCache[$0]! }
        
        return cardFlowAttributes + retractedAndPulledCardAttributes + allOtherSuperAttributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        //        print("layout attributes for item at index path: \(indexPath), card at top is: \(cardAtTopOfStack)")
        
        return cardCache[indexPath.item] ?? super.layoutAttributesForItemAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool
    {
        if stackIsRetracted {
            return false
        }
        else {
            return super.shouldInvalidateLayoutForBoundsChange(newBounds)
        }
    }
}
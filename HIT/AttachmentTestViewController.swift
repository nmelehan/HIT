//
//  AttachmentTestViewController.swift
//  HIT
//
//  Created by Nathan Melehan on 12/25/15.
//  Copyright © 2015 Nathan Melehan. All rights reserved.
//

import UIKit

class AttachmentTestViewController: UIViewController, UIDynamicAnimatorDelegate {
    
    
    
    //
    //
    //
    //
    // MARK: - Properties
    
    var animator: UIDynamicAnimator?
    var attachmentBehavior: UIAttachmentBehavior?
    
    
    
    //
    //
    //
    //
    // MARK: - Outlets
    
    @IBOutlet weak var attachedView: UIView!
    @IBOutlet weak var attachedView2: UIView!
    
    
    
    //
    //
    //
    //
    // MARK: - Actions
    
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(view)
        attachedView.center = CGPoint(x: attachedView.center.x, y: location.y)
        animator?.updateItemUsingCurrentState(attachedView)
    }
    
    @IBAction func handlePanGestureRecognizer(sender: UIPanGestureRecognizer) {
        // run animator
        // add attachment behavior
        // drop constraints
        
        let translation = sender.translationInView(self.view)
        if sender.state == .Began {
            let anchor = CGPoint(x: attachedView.center.x, y: attachedView.center.y + translation.y)
            attachmentBehavior = UIAttachmentBehavior(item: attachedView,
                attachedToAnchor: anchor)
//            attachmentBehavior = UIAttachmentBehavior.slidingAttachmentWithItem(
//                attachedView,
//                attachmentAnchor: anchor,
//                axisOfTranslation: CGVector(dx: 1, dy: 0))
            attachmentBehavior?.damping = 1
            attachmentBehavior?.frequency = 0.5
            attachmentBehavior?.length = 0
            animator?.addBehavior(attachmentBehavior!)
        }
        else if sender.state == .Changed {
            
            //            print("\(NSDate()): \(sender.state.rawValue)\n")
            
            let anchor = attachmentBehavior!.anchorPoint
            let newAnchor = CGPoint(x: anchor.x,
                y: anchor.y + translation.y)
            attachmentBehavior?.anchorPoint = newAnchor
        }
        else {
            print("\(NSDate()): \(sender.state.rawValue)\n")
                
            animator?.removeBehavior(self.attachmentBehavior!)
            attachmentBehavior = nil
            
        }
        
        sender.setTranslation(CGPointZero, inView: self.view)
    }
    
    
    
    //
    //
    //
    //
    // MARK: - UIDynamicAnimatorDelegate
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        // condition ensures that animation didn't pause
        // just because user hasn't moved their finger
//        print("animator paused")
//        
//        if attachmentBehavior == nil {
//            print("and attachment is nil")
//            
//            animator.removeAllBehaviors()
//            addConstraints()
//        }
    }
    
    
    
    //
    //
    //
    //
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: self.view)
        animator?.delegate = self
        
        animator?.debugEnabled = true
        
        let springBehavior = UIAttachmentBehavior(
            item: attachedView2,
            attachedToAnchor: CGPoint(x: view.bounds.width/2, y: view.bounds.height - attachedView2.bounds.size.height))
        animator?.addBehavior(springBehavior)
        springBehavior.length = 0
        springBehavior.damping = 1
        springBehavior.frequency = 2.0
        
//        let attachedViewOriginX = attachedView.frame.origin.x
//        springBehavior.action = {
//            if self.attachedView.frame.origin.x != attachedViewOriginX {
//                var newFrame = self.attachedView.frame
//                newFrame.origin.x = attachedViewOriginX
//                self.attachedView.frame = newFrame
//                self.animator?.updateItemUsingCurrentState(self.attachedView)
//            }
//        }
        
        let tetherBehavior = UIAttachmentBehavior(
            item: attachedView,
            attachedToItem: attachedView2)
        animator?.addBehavior(tetherBehavior)
        tetherBehavior.length = 150
        tetherBehavior.damping = 1.0
        tetherBehavior.frequency = 2.0
        
//        let attachedView2OriginX = attachedView2.frame.origin.x
//        tetherBehavior.action = {
//            if self.attachedView2.frame.origin.x != attachedView2OriginX {
//                var newFrame = self.attachedView2.frame
//                newFrame.origin.x = attachedView2OriginX
//                self.attachedView2.frame = newFrame
//                self.animator?.updateItemUsingCurrentState(self.attachedView2)
//            }
//        }
    }

}

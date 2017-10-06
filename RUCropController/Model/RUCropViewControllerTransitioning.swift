//
//  RUCropViewControllerTransitioning.swift
//  RUCropController
//
//  Created by Roman Ustiantcev on 06/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class RUCropViewControllerTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    /* State Tracking */
    var isDismissing = false
    // Whether this animation is presenting or dismissing
    var image: UIImage?
    // The image that will be used in this animation
    /* Destination/Origin points */
    var fromView: UIView?
    // The origin view who's frame the image will be animated from
    var toView: UIView?
    // The destination view who's frame the image will animate to
    var fromFrame = CGRect.zero
    // An origin frame that the image will be animated from
    var toFrame = CGRect.zero
    // A destination frame the image will aniamte to
    /* A block called just before the transition to perform any last-second UI configuration */
    var prepareForTransitionHandler: (() -> Void)?
    /* Empties all of the properties in this object */
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.45 as TimeInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get the master view where the animation takes place
        let containerView: UIView? = transitionContext.containerView
        // Get the origin/destination view controllers
        let fromViewController: UIViewController? = transitionContext.viewController(forKey: .from)
        let toViewController: UIViewController? = transitionContext.viewController(forKey: .to)
        // Work out which one is the crop view controller
        let cropViewController: UIViewController? = (isDismissing == false) ? toViewController : fromViewController
        let previousController: UIViewController? = (isDismissing == false) ? fromViewController : toViewController
        // Just in case, match up the frame sizes
        cropViewController?.view.frame = containerView?.bounds ?? CGRect.zero
        if isDismissing {
            previousController?.view.frame = containerView?.bounds ?? CGRect.zero
        }
        // Add the view layers beforehand as this will trigger the initial sets of layouts
        if isDismissing == false {
            containerView?.addSubview((cropViewController?.view)!)
            //Force a relayout now that the view is in the view hierarchy (so things like the safe area insets are now valid)
            cropViewController?.viewDidLayoutSubviews()
        } else {
            containerView?.insertSubview((previousController?.view)!, belowSubview: (cropViewController?.view)!)
        }
        // Perform any last UI updates now so we can potentially factor them into our calculations, but after
        // the container views have been set up
        if (prepareForTransitionHandler != nil) {
            prepareForTransitionHandler!()
        }
        // If origin/destination views were supplied, use them to supplant the
        // frames
        if !(isDismissing && (fromView != nil)) {
            fromFrame = (fromView?.superview?.convert((fromView?.frame)!, to: containerView))!
        }
        else if isDismissing && (toView != nil) {
            toFrame = (toView?.superview?.convert((toView?.frame)!, to: containerView))!
        }
        var imageView: UIImageView? = nil
        if (isDismissing && !toFrame.isEmpty) || (!isDismissing && !fromFrame.isEmpty) {
            imageView = UIImageView(image: image)
            imageView?.frame = fromFrame
            containerView?.addSubview(imageView!)
        }
        cropViewController?.view.alpha = isDismissing ? 1.0 : 0.0
        if imageView != nil {
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.7, options: [], animations: {() -> Void in
                imageView?.frame = self.toFrame
            }, completion: {(_ complete: Bool) -> Void in
                UIView.animate(withDuration: 0.25, animations: {() -> Void in
                    imageView?.alpha = 0.0
                }, completion: {(_ complete: Bool) -> Void in
                    imageView?.removeFromSuperview()
                })
            })
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {() -> Void in
            cropViewController?.view.alpha = self.isDismissing ? 0.0 : 1.0
        }, completion: {(_ complete: Bool) -> Void in
            self.reset()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func reset() {
        image = nil
        toView = nil
        fromView = nil
        fromFrame = CGRect.zero
        toFrame = CGRect.zero
        prepareForTransitionHandler = nil
    }
}


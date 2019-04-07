//
//  CustomAnimatedTransitioning.swift
//  WisdomTimer onGit
//
//  Created by 田中惇貴 on 2019/01/03.
//  Copyright © 2019 田中惇貴. All rights reserved.
//

import Foundation
import UIKit

class CustomAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresent: Bool
    
    init(isPresent: Bool) {
        self.isPresent = isPresent
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            animatePresentTransition(transitionContext: transitionContext)
        } else {
            animateDissmissalTransition(transitionContext: transitionContext)
        }
    }
    
    func animatePresentTransition(transitionContext: UIViewControllerContextTransitioning) {
        let presentingController: UIViewController! = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let presentedController: UIViewController! = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView: UIView! = transitionContext.containerView
        containerView.insertSubview(presentedController.view, belowSubview: presentingController.view)
        
        presentingController.view.alpha = 0.1
        
        //適当にアニメーション
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            presentedController.view.frame.origin.x -= containerView.bounds.size.width
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
        })
    }
    
    func animateDissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController: UIViewController! = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let containerView: UIView! = transitionContext.containerView
        //適当にアニメーション
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            presentedController.view.frame.origin.x = containerView.bounds.size.width
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
        })
    }
    
}

//
//  PhotoTypeAnimationController.swift
//  MiniRumbl
//
//  Created by Anshu Vij on 16/05/21.
//

import UIKit

class PhotoTypeAnimationController: NSObject {
    
    let animator: ZoomAnimator
    let interactionController: ZoomDismissalInteractionController
    var isInteractive: Bool = false

    weak var fromDelegate: ZoomAnimatorDelegate?
    weak var toDelegate: ZoomAnimatorDelegate?
    
    override init() {
        animator = ZoomAnimator()
        interactionController = ZoomDismissalInteractionController()
        super.init()
    }
    
    func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        self.interactionController.didPanWith(gestureRecognizer: gestureRecognizer)
    }
}

extension PhotoTypeAnimationController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresenting = true
        self.animator.fromDelegate = fromDelegate
        self.animator.toDelegate = toDelegate
        return self.animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isPresenting = false
        let tmp = self.fromDelegate
        self.animator.fromDelegate = self.toDelegate
        self.animator.toDelegate = tmp
        return self.animator
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !self.isInteractive {
            return nil
        }
        
        self.interactionController.animator = animator
        return self.interactionController
    }

}

extension PhotoTypeAnimationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            self.animator.isPresenting = true
            self.animator.fromDelegate = fromDelegate
            self.animator.toDelegate = toDelegate
        } else {
            self.animator.isPresenting = false
            let tmp = self.fromDelegate
            self.animator.fromDelegate = self.toDelegate
            self.animator.toDelegate = tmp
        }
        
        return self.animator
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if !self.isInteractive {
            return nil
        }
        
        self.interactionController.animator = animator
        return self.interactionController
    }

}


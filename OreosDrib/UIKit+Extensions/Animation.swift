//
//  Animation.swift
//  OreosDrib
//
//  Created by P36348 on 20/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import Foundation
import UIKit


/// 卡片下落动画协议
protocol CardDismissable: UIViewControllerTransitioningDelegate {
    
    var card: UIView { get }
    
    var cardSnapShot: UIView { get }
    
    var background: UIView { get }
}

private var presentTransition: PresentTransition = PresentTransition()

private var dismissTransition: DismissTransition = DismissTransition()

extension CardDismissable where Self: UIViewController {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}

private let animationDuration: Double = 0.30
private let dismissDestinationCenter: CGPoint = CGPoint(x: kScreenWidth/2, y: kScreenHeight + 64)

private class PresentTransition: NSObject , UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let sourceViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let dishCardViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! CardDismissable
        let containerView = transitionContext.containerView
        
        
        containerView.backgroundColor = UIColor.clear
        
        let sourceView = sourceViewController.view
        let toView = dishCardViewController.background
        let card = dishCardViewController.card
        
        containerView.addSubview(toView)
        
        card.frame = CGRect(x: 0, y: kScreenHeight, width: card.bounds.size.width, height: card.bounds.size.height)
        card.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        card.alpha = 0
        toView.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        let animations: (() -> Void) = {
            card.transform = CGAffineTransform(scaleX: 1, y: 1)
            card.frame = CGRect(x: 0, y: 58, width: card.bounds.size.width, height: card.bounds.size.height)
            card.alpha = 1
            toView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
        
        let completion: (Bool)-> Void = { finished in
            
            guard finished else { return }
            sourceView!.transform = CGAffineTransform.identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: animationDuration, animations: animations, completion: completion)
    }
    
}

private class DismissTransition: NSObject , UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let dishCardViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? CardDismissable else {
            return transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        let cardContainer = dishCardViewController.cardSnapShot
        let destinationCenter = dismissDestinationCenter
        
        let animations: (() -> Void) = {
            cardContainer.center = destinationCenter
            cardContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            dishCardViewController.background.alpha = 0.0
        }
        
        let completion: (Bool)-> Void = { finished in
            dishCardViewController.background.alpha = 1
            cardContainer.transform = CGAffineTransform(scaleX: 1, y: 1)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: animationDuration, animations: animations, completion: completion)
        
    }
}

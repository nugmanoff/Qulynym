 /*
* Qulynym
* Animator.swift
*
* Created by: Metah on 5/10/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
 */

import UIKit
import QuartzCore

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK:- Properties
    weak var containerView: UIView!
    weak var toView: UIView!
    var bubbleClipView: UIView!
    
    private let duration = 0.7
    
    
    // MARK:- Protocol Methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        setupViews(context: transitionContext)
        
        AudioPlayer.setupExtraAudio(with: "bubbles", audioPlayer: .effects)
        
        containerView.addSubview(toView)
        
        initBubbleView()
        setupBeginningValues()
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, animations: {
            self.callKeyframes()
        }, completion: { _ in
            transitionContext.completeTransition(true)
            self.bubbleClipView.removeFromSuperview()
        })
    }
    
    
    // MARK: Helper Methods
    private func setupViews(context: UIViewControllerContextTransitioning) {
        containerView = context.containerView
        toView = context.viewController(forKey: .to)!.view
    }
    
    private func initBubbleView() {
        bubbleClipView = UIView(frame: containerView.frame.offsetBy(dx: 0, dy: 0))
        bubbleClipView.clipsToBounds = true
        let bubbleView = BubbleView(frame: bubbleClipView.frame)
        bubbleClipView.addSubview(bubbleView)
        containerView.addSubview(bubbleClipView)
    }
    
    private func setupBeginningValues() {
        toView.alpha = 0
        bubbleClipView.alpha = 0
    }
    
    private func callKeyframes() {
        let halfOfDuration = self.duration * 0.5
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: halfOfDuration, animations: {
            self.bubbleClipView.alpha = 1
        })
        UIView.addKeyframe(withRelativeStartTime: halfOfDuration, relativeDuration: halfOfDuration, animations: {
            self.setupEndingValues()
        })
    }
    
    private func setupEndingValues() {
        bubbleClipView.alpha = 0
        toView.alpha = 1
    }
}

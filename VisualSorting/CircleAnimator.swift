//
//  CircleAnimator.swift
//  Algo
//
//  Created by Filippo Tosetto on 20/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import UIKit

protocol CircleAnimatorDelegate {
    func didFinishAnimation()
}


class CircleAnimator: NSObject  {
    
    var delegate: CircleAnimatorDelegate?
    let fromCircle: CircleView, toCircle: CircleView
    
    let animationDuration = 0.5
    
    init(delegate: CircleAnimatorDelegate, fromCircle: CircleView, toCircle: CircleView) {
        self.fromCircle = fromCircle
        self.toCircle = toCircle
        self.delegate = delegate
    }
    
    func animateCircles() {
        let fromCircleStartPosition = fromCircle.position
        let toCircleStartPosition = toCircle.position
        
        fromCircle.position = CGPointMake(toCircleStartPosition.x, toCircleStartPosition.y)
        toCircle.position = CGPointMake(fromCircleStartPosition.x, fromCircleStartPosition.y)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.delegate = self
        animation.duration  = animationDuration
        animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        
        animation.path = self.getBezier(fromCircleStartPosition, endPoint: toCircleStartPosition, up: true)
        fromCircle.addAnimation(animation, forKey: "position")
        
        animation.path = self.getBezier(toCircleStartPosition, endPoint: fromCircleStartPosition, up: false)
        toCircle.addAnimation(animation, forKey: "position")
        
        
        animateCirclePath(fromCircle.superlayer!,
                          fromPosition: fromCircleStartPosition,
                            toPosition: toCircleStartPosition,
                                    up: true,
                                 color: fromCircle.circleColor)
        
        animateCirclePath(toCircle.superlayer!,
                          fromPosition: toCircleStartPosition,
                            toPosition: fromCircleStartPosition,
                                    up: false,
                                 color: toCircle.circleColor)
        
        fromCircle.animateColor()
        toCircle.animateColor()
    }

    private func animateCirclePath(superlayer: CALayer, fromPosition: CGPoint, toPosition: CGPoint, up: Bool, color: CGColorRef) {
    
        let path = CAShapeLayer()
        path.fillColor = UIColor.clearColor().CGColor
        path.strokeColor = color
        path.lineWidth = 1.0
        path.fillMode = kCAFillModeForwards
        path.path = self.getBezier(fromPosition, endPoint: toPosition, up: up)
        superlayer.insertSublayer(path, atIndex: 0)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = animationDuration
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeForwards
        path.addAnimation(animation, forKey: "strokeEnd")
    }
    
    private func getBezier(startPoint: CGPoint, endPoint: CGPoint, up: Bool) -> CGPathRef {
        let aPath = UIBezierPath()
        aPath.moveToPoint(startPoint)
        
        let x = startPoint.x + (endPoint.x - startPoint.x) / 2
        let y = up ? startPoint.y - (endPoint.x - startPoint.x) / 2 : startPoint.y + (startPoint.x - endPoint.x) / 2
        
        aPath.addQuadCurveToPoint(endPoint, controlPoint: CGPointMake(x, y))
        return aPath.CGPath
    }
    
    
    // Animation Delegate
    override func animationDidStop(anim: CAAnimation, finished flag: Bool){

        if let del = delegate {
            fromCircle.animateColor(true)
            toCircle.animateColor(true)

            del.didFinishAnimation()
        }
        delegate = nil
    }
}

//
//  CircleView.swift
//  Algo
//
//  Created by Filippo Tosetto on 11/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import UIKit

let StartColor = UIColor(red: 134/255.0, green: 134/255.0, blue: 134/255.0, alpha: 1.0)
let EndColor = UIColor(red: 20/255.0, green: 103/255.0, blue: 143/255.0, alpha: 0.8)
let ActiveColor = UIColor(red: 255/255.0, green: 0.0, blue: 158/255.0, alpha: 0.8).CGColor


class CircleView: CAShapeLayer {

    var number: Int = 0
    
    
    
    var circleColor: CGColorRef {
        didSet {
            self.fillColor = circleColor
        }
    }
    
    override init() {
        self.circleColor = UIColor.grayColor().CGColor
        super.init()
    }

    override init(layer: AnyObject){
        self.circleColor = UIColor.grayColor().CGColor
        super.init(layer: layer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func createCircle(position position: CGPoint, radius: CGFloat, number: Int) -> CircleView {
        let shape = CircleView()
        shape.number = number
        shape.circleColor = shape.setColor(number)
        shape.frame = CGRectMake(0, 0, radius, radius)
        shape.position = position
        shape.path = UIBezierPath(ovalInRect: shape.bounds).CGPath
        shape.fillMode = kCAFillModeForwards
        return shape
    }
    
    func animateColor(reverse: Bool = false) {

        let fromColor = (!reverse) ? setColor(number) : ActiveColor
        let toColor = (!reverse) ? ActiveColor : setColor(number)
        
        circleColor = toColor
        
        let animation = CABasicAnimation(keyPath: "fillColor")
        animation.duration = 0.3;
        animation.fromValue = fromColor
        animation.toValue = toColor
        self.addAnimation(animation, forKey: "fillColor")
    }
    
    private func setColor(number: Int) -> CGColorRef {
        return colorBasedOnPercentage(fromColor: StartColor,
                                        toColor: EndColor,
                                     percentage: CGFloat(number) / 10.0).CGColor
    }

    // MARK: Utility
    private func colorBasedOnPercentage(fromColor fromColor: UIColor, toColor: UIColor, percentage: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0.0
        var fromGreen: CGFloat = 0.0
        var fromBlue: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0.0, toGreen: CGFloat = 0.0
        var toBlue: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let newRed:CGFloat   = (1.0 - percentage) * fromRed   + percentage * toRed
        let newGreen:CGFloat = (1.0 - percentage) * fromGreen + percentage * toGreen
        let newBlue:CGFloat  = (1.0 - percentage) * fromBlue  + percentage * toBlue
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

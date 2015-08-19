//
//  PlayPayseButton.swift
//  Algo
//
//  Created by Filippo Tosetto on 27/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import UIKit

@IBDesignable
class PlayPauseButton: UIButton {

    var shapePath: CGPathRef?
    var showPlay = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        switchButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        switchButton()
    }
    
    override func drawRect(rect: CGRect) {
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextAddPath(ctx, shapePath)
        CGContextSetStrokeColorWithColor(ctx, UIColor(white: 0.75, alpha: 1.0).CGColor)
        CGContextSetFillColorWithColor(ctx, UIColor(white: 0.75, alpha: 1.0).CGColor)
        CGContextFillPath(ctx)
        CGContextStrokePath(ctx)
    }
    
    
    override func prepareForInterfaceBuilder() {
        shapePath = pathForPlayButton()
        self.setNeedsDisplay()
    }
    
    func switchButton() {
        shapePath = (showPlay) ? pathForPlayButton() : pathForPauseButton()
        showPlay = !showPlay
        self.setNeedsDisplay()
    }
    
    private func pathForPlayButton() -> CGPathRef {
        let point1 = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds))
        let point2 = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds))
        let point3 = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds))

        let path:CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, point1.x, point1.y)
        CGPathAddLineToPoint(path, nil, point2.x, point2.y)
        CGPathAddLineToPoint(path, nil, point3.x, point3.y)
        CGPathCloseSubpath(path)

        return path
    }
    
    private func pathForPauseButton() -> CGPathRef {
        let shapeWidth:CGFloat = 10
        let point0 = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds))
        let point1 = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds))
        let point2 = CGPointMake(CGRectGetMinX(self.bounds) + shapeWidth, CGRectGetMaxY(self.bounds))
        let point3 = CGPointMake(CGRectGetMinX(self.bounds) + shapeWidth, CGRectGetMinY(self.bounds))
        let point4 = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds))
        
        let point5 = CGPointMake(CGRectGetMinX(self.bounds) + shapeWidth + 5, CGRectGetMaxY(self.bounds))
        let point6 = CGPointMake(CGRectGetMinX(self.bounds) + shapeWidth + 5, CGRectGetMinY(self.bounds))
        let point7 = CGPointMake(CGRectGetMinX(self.bounds) + shapeWidth + 5 + shapeWidth, CGRectGetMinY(self.bounds))
        let point8 = CGPointMake(CGRectGetMinX(self.bounds) + shapeWidth + 5 + shapeWidth, CGRectGetMaxY(self.bounds))
        
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, point0.x, point0.y)
        CGPathAddLineToPoint(path, nil, point1.x, point1.y)
        CGPathAddLineToPoint(path, nil, point2.x, point2.y)
        CGPathAddLineToPoint(path, nil, point3.x, point3.y)
        CGPathAddLineToPoint(path, nil, point4.x, point4.y)
        
        CGPathMoveToPoint(path, nil, point5.x, point5.y)
        CGPathAddLineToPoint(path, nil, point6.x, point6.y)
        CGPathAddLineToPoint(path, nil, point7.x, point7.y)
        CGPathAddLineToPoint(path, nil, point8.x, point8.y)
        
        CGPathCloseSubpath(path)
        
        return path
    }


}

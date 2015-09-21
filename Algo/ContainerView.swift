//
//  ContainerView.swift
//  Algo
//
//  Created by Filippo Tosetto on 10/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import UIKit

class ContainerView: UIView {

    var pause = true
    let numberOfCircles: CGFloat = 10
    var maxCircleRadius: CGFloat = 0
    var swapsArray = [(Int, Int)]()

    @IBOutlet weak var titleLabel: UILabel!
    
    
    //Need to mark it as final otherwise swap doesn't work
    final var circles = [CircleView]()

    
    func setupViewWithNumbers(numbers: [Int], swaps: [(Int, Int)]) {

        maxCircleRadius = self.frame.size.width / CGFloat(numberOfCircles + (numberOfCircles + 1)/2)
        
        cleanupLayers()

        
        for (index, number) in EnumerateGenerator(numbers.generate()) {
            
            let radius = maxCircleRadius * (CGFloat(number)/10.0) + 10
            let x = ((maxCircleRadius + maxCircleRadius / 2) * CGFloat(index)) + maxCircleRadius

            let circle = CircleView.createCircle( position: CGPointMake(x, self.bounds.size.height/2),
                                                    radius: radius,
                                                    number: number)
            self.layer.addSublayer(circle)
            circles.append(circle)
        }
        swapsArray = swaps        
    }
    
    
    func stop() {
        swapsArray.removeAll(keepCapacity: false)
    }
    
    func pauseAnimation() {
        pause = true
    }
    
    func playAimaiton() {
        pause = false
        pushSwap()
    }
    
    private func pushSwap() {
        if swapsArray.count > 0 && !pause {
            let swapUnit: (Int, Int) = swapsArray[0]
            let animator = CircleAnimator(delegate: self,
                                        fromCircle: circles[swapUnit.0],
                                          toCircle: circles[swapUnit.1])
            animator.animateCircles()

            swap(&circles[swapUnit.0], &circles[swapUnit.1])
            
            swapsArray.removeAtIndex(0)
        }
    }
    
    
    func cleanupLayers(){
        if (self.layer.sublayers != nil) {
            for layer in self.layer.sublayers! where layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
        circles.removeAll(keepCapacity: true)
    }
}

// MARK: - CircleAnimatorDelegate
extension ContainerView: CircleAnimatorDelegate {
    func didFinishAnimation() {
        pushSwap()
    }
}

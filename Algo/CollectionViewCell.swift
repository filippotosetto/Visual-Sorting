//
//  collectionViewCell.swift
//  Algo
//
//  Created by Filippo Tosetto on 30/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    private var numberOFSwaps = [(Int, Int)]()
    private var data = [Int]()
    private var sorting: () -> () = {}// Sort function

    @IBOutlet weak var containerView: ContainerView!

    func setup(dataToSort: [Int], function: SortFunctionType) {
        self.data = dataToSort

        sorting = {
            self.numberOFSwaps.removeAll(keepCapacity: false)
            self.containerView.titleLabel.text = function.rawValue
            self.numberOFSwaps = execute(function, data: self.data)
        }

        sorting()
        containerView.setupViewWithNumbers(dataToSort, swaps: numberOFSwaps)
    }
    
    func playPause() {
        (containerView.pause) ? containerView.playAimaiton() : containerView.pauseAnimation()
    }
}

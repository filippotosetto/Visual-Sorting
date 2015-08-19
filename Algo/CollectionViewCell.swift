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

    func setup(dataToSort: [Int], function: SortFunction) {
        self.data = dataToSort

        sorting = {
            self.numberOFSwaps.removeAll(keepCapacity: false)
            self.containerView.titleLabel.text = function.rawValue
            SortFunction.getSortFunction(function, data: &self.data, swaps: &self.numberOFSwaps)
        }

        sorting()
        containerView.setupViewWithNumbers(dataToSort, swaps: numberOFSwaps)
    }
    
    func playPause() {
        (containerView.pause) ? containerView.playAimaiton() : containerView.pauseAnimation()
    }
}

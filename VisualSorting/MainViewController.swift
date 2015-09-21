//
//  ViewController.swift
//  Algo
//
//  Created by Filippo Tosetto on 10/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [Int]()
    var cellCollection = [CollectionViewCell]()
        
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        restartAction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func restartAction() {
        data.removeAll(keepCapacity: true)
        
        for _ in 1...10 {
            let n = Int(arc4random() % 9) + 1
            data.append(n)
        }
    
        cellCollection.removeAll(keepCapacity: false)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footerCell", forIndexPath: indexPath) as! CollectionFooter
        cell.actionsDelegate = self
        return cell
    }

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        
        if indexPath.row == 0 {
            cell.setup(data, function: SortFunctionType.QuickSort)
        } else if indexPath.row == 1 {
            cell.setup(data, function: SortFunctionType.HeapSort)
        } else if indexPath.row == 2 {
            cell.setup(data, function: SortFunctionType.InsertionSort)
        } else {
            cell.setup(data, function: SortFunctionType.MergeSort)
        }
        cellCollection.append(cell)
        
        return cell
    }
}


extension MainViewController: CollectionFooterDelegate {

    func willToggleAction() {
        for cell in cellCollection {
            cell.playPause()
        }
    }
    
    func willShuffleData() {
        willToggleAction()
        restartAction()
    }

}


//
//  ViewController.swift
//  Algo
//
//  Created by Filippo Tosetto on 10/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var playPauseButton: PlayPauseButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [Int]()
    var cellCollection = [CollectionViewCell]()
        
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        restartAction(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playPauseAction(sender: AnyObject) {
        
        
        playPauseButton.switchButton()
        
        for cell in cellCollection {
            cell.playPause()
        }
    }
    
    @IBAction func restartAction(sender: AnyObject) {
        
        if self.playPauseButton.showPlay {
            playPauseAction(self)
        }
        
        data.removeAll(keepCapacity: true)
        
        for _ in 1...10 {
            let n = Int(arc4random() % 9) + 1
            data.append(n)
        }
        
        cellCollection.removeAll(keepCapacity: false)
        collectionView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let vc = segue.destinationViewController as! AlgorithmSelectorViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        vc.popoverPresentationController!.delegate = self
        vc.delegate = self
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {

        let restore = { () -> Bool in
            return coordinator.animateAlongsideTransition(nil, completion: { (context) -> Void in
                    UIView.animateWithDuration(0.3,
                        animations: { () -> Void in
                            self.restartAction(self)

                            self.collectionView.alpha = 1.0
                    })
                })
        }
        
        
        UIView.animateWithDuration(0.3,
            animations: { () -> Void in
              self.collectionView.alpha = 0.0
        }) { (complete) -> Void in
            restore()
        }
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
}


// MARK: - UIPopoverPresentationControllerDelegate
extension MainViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}

// MARK: - AlgorithmSelectorDelegate
extension MainViewController: AlgorithmSelectorDelegate {
    func didSelectAlgorithm(functionName: SortFunction) {
        restartAction(self)
        
//        sorting = {
//            SortFunction.getSortFunction(functionName, data: &self.data, swaps: &self.numberOFSwaps)
//        }
    }
}


// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        
        if indexPath.row == 0 {
            cell.setup(data, function: SortFunction.QuickSort)
        } else if indexPath.row == 1 {
            cell.setup(data, function: SortFunction.HeapSort)
        } else {
            cell.setup(data, function: SortFunction.InsertionSort)
        }
        cellCollection.append(cell)
        
        return cell
    }
}

// MARK: - UICollectionViewFlowLayoutDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if( UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight) {
            let width = self.view.frame.size.width/2
            return CGSize(width: width, height: width / 2 + 20)
        } else {
            let width = self.view.frame.size.width
            return CGSize(width: width, height: width / 2 + 50)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

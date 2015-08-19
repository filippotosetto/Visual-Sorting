//
//  AlgorithSelectorViewController.swift
//  Algo
//
//  Created by Filippo Tosetto on 26/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import UIKit

protocol AlgorithmSelectorDelegate {
    func didSelectAlgorithm(functionName: SortFunction)
}


class AlgorithmSelectorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items: [SortFunction] = [SortFunction.HeapSort, SortFunction.QuickSort]
    var delegate: AlgorithmSelectorDelegate?
}


// MARK: - UITableViewDataSource
extension AlgorithmSelectorViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! 
        
        cell.textLabel?.text = self.items[indexPath.row].rawValue
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AlgorithmSelectorViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (delegate != nil) {
            delegate?.didSelectAlgorithm(self.items[indexPath.row])
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
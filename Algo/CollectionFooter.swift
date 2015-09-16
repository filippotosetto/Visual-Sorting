//
//  CollectionFooter.swift
//  Algo
//
//  Created by Filippo Tosetto on 16/09/2015.
//  Copyright © 2015 Conjure. All rights reserved.
//

import UIKit

protocol CollectionFooterDelegate {
    func willToggleAction()
    func willShuffleData()
}


class CollectionFooter: UICollectionReusableView {
        
    @IBOutlet weak var actionButton: PlayPauseButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    var actionsDelegate: CollectionFooterDelegate?
    var isPlaying = false
    
    
    @IBAction func shuffleAction(sender: AnyObject) {
        if let aDelegate = actionsDelegate {
            aDelegate.willShuffleData()
            actionButton.switchButton()
        }
    }
    
    @IBAction func playPauseAction(sender: AnyObject) {
        if let aDelegate = actionsDelegate {
            aDelegate.willToggleAction()
            actionButton.switchButton()
        }
    }

}

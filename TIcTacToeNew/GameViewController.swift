//
//  GameViewController.swift
//  TIcTacToeNew
//
//  Created by Hieu Vo on 4/27/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scence = GameScene(size: self.view.bounds.size)
        scence.scaleMode = .aspectFill
        let skView = view as! SKView!
        skView?.ignoresSiblingOrder = true
        skView?.presentScene(scence)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

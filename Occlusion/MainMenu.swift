//
//  MainMenu.swift
//  Occlusion
//
//  Created by Tobby Lie on 11/26/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    override func didMove(to view: SKView) {
        print("Inside Main Menu")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                print("Going to Gameplay scene")
            }
        }
    }
    
//    var playButton: BDButton = {
//       var button = BDButton(imageNamed: "ButtonPlay", buttonAction: {
//        ACTManager.shared.transitioin(
//        })
//    }()
//
//    lazy var playButton: BDButton = {
//        var button = BDButton(imageNamed: "ButtonPlay", buttonAction: {
//
//            let chance = CGFloat.random(1, max: 10)
//            if chance <= 5 {
//                self.showAds()
//            } else {
//                self.startGameplay()
//            }
//        })
//        button.zPosition = 1
//        return button
//    }()
//
//    override func didMove(to view: SKView) {
//        setupNodes()
//        addNodes()
//    }
//
//    func setupNodes() {
//
//    }
//
//    func addNodes() {
//
//    }
}

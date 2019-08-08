/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit
import GameplayKit

class TutorialState: GKState {
    unowned let gameScene: GameScene
    
    init(scene: SKScene) {
        self.gameScene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        setupExplanation()
    }
    
    override func willExit(to nextState: GKState) {
        gameScene.worldNode.enumerateChildNodes(withName: "Tutorial", using: { node, stop in
            node.run(SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.5),
                SKAction.removeFromParent()
                ]))
        })
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    func setupExplanation() {
        gameScene.setupBackground()
        gameScene.setupForeground()
        gameScene.setupPlayer()
        gameScene.setupScoreLabel()
        
        let tutorial = SKSpriteNode(imageNamed: "tutorial")
        tutorial.position = CGPoint(x: gameScene.size.width * 0.5, y: gameScene.playableHeight * 0.4 + gameScene.playableStart)
        tutorial.name = "Tutorial"
        tutorial.zPosition = Layer.ui.rawValue
        gameScene.worldNode.addChild(tutorial)
    }
}

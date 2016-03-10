import SpriteKit
import GameplayKit

class LevelScore: GKEntity {
    var scoreLabel: SKLabelNode!
    var renderComponent:RenderComponent {
        return componentForClass(RenderComponent)!
    }
    var displayScore: Int = 0 // The score that is currently being displayed (may be in transition)
    
    override init() {
        super.init()
        levelStats.addObserver(self, forKeyPath: "score", options: .New, context: &Util.scoreContext)
        
        let renderComponent = RenderComponent(entity: self)
        renderComponent.node.name = "levelScore"
        renderComponent.node.zPosition = 100
        
        addComponent(renderComponent)
        
        setupScore()
    }
    
    deinit {
        levelStats.removeObserver(self, forKeyPath: "score", context: &Util.scoreContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &Util.scoreContext {
            if let newValue = change?[NSKeyValueChangeNewKey] {
                transitionScore(Int(newValue as! NSNumber))
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func setupScore() {
        scoreLabel = SKLabelNode(fontNamed: Util.fontRegular)
        scoreLabel.text = "000000"
        scoreLabel.name = Util.levelScore
        scoreLabel.fontSize = 22
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        scoreLabel.zPosition = 100
        renderComponent.node.addChild(scoreLabel)
        updateScore()
    }
    
    func transitionScore(score: Int = 0) {
        renderComponent.node.removeActionForKey("incrementScore")
        let scoreDifference = score - displayScore
        let increment = max(Int(scoreDifference/100), 1)
        let incrementScore = SKAction.runBlock({
            var newScore = self.displayScore + increment
            if newScore >= score {
                newScore = score
                self.renderComponent.node.removeActionForKey("incrementScore")
            }
            self.updateScore(newScore)
        })
        let incrementScoreAction = SKAction.repeatActionForever(SKAction.sequence([incrementScore, SKAction.waitForDuration(0.01)]))
        renderComponent.node.runAction(incrementScoreAction, withKey: "incrementScore")
    }
    
    func updateScore(score: Int = 0) {
        displayScore = score
        let scoreString = String(score)
        let numLeadingZeros = 6 - scoreString.characters.count
        var leadingZeros = ""
        for _ in 1...numLeadingZeros {
            leadingZeros = leadingZeros + "0"
        }
        scoreLabel.text = leadingZeros + scoreString
    }
}
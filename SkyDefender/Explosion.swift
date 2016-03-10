import UIKit
import SpriteKit

class Explosion: SKNode {
    var damage: CGFloat = 20
    var size: CGFloat = 30
    var id: Int = 0
    init(position: CGPoint, size: CGFloat = 0.2, damage: CGFloat = 20) {
        super.init()
        
        self.damage = damage
        self.size = size
        self.position = position
        
        var firePath = "fire"
        if size >= 1 {
            firePath = "spark"
        }
        let emitterNodePath = NSBundle.mainBundle().pathForResource(firePath, ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterNodePath as String) as! SKEmitterNode
        emitterNode.zPosition = 8
        addChild(emitterNode)
        
        self.runAction(SKAction.waitForDuration(2), completion: { emitterNode.removeFromParent() })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getDamage() -> Int {
        return Int(damage * (1 - (xScale * 0.5 / size)))
    }
}

import SpriteKit
import GameplayKit

class HealthComponent: GKComponent {
    var hp: CGFloat = 0
    var maxHp: CGFloat = 0
    var node: SKShapeNode!
    var healthBar: SKShapeNode!
    let height:CGFloat = 4
    
    init(hp: CGFloat) {
        super.init()
        self.hp = hp
        self.maxHp = hp
    }
    
    func hit(damage: CGFloat) {
        hp -= damage
        hp = max(hp, 0)

        healthBar.xScale = hp/maxHp
        
        if self.isAlive() {
            let doFadeIn = SKAction.fadeInWithDuration(0.1)
            let doWait = SKAction.waitForDuration(5)
            let doFadeOut = SKAction.fadeOutWithDuration(0.4)
            let doSequence = SKAction.sequence([doFadeIn, doWait, doFadeOut])
            node.removeActionForKey("fade")
            node.runAction(doSequence, withKey: "fade")
        } else {
            let doFadeOut = SKAction.fadeOutWithDuration(0.4)
            node.removeActionForKey("fade")
            node.runAction(doFadeOut, withKey: "fade")
        }
    }
    
    func isAlive() -> Bool {
        return hp > 0
    }
    
    func getHealthBarOfWidth(width: CGFloat) -> SKNode {
        node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 1)
        node.zPosition = 11
        node.lineWidth = 0
        node.position = CGPoint(x: width / 2 * -1, y: 20)
        node.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)

        healthBar = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 1)
        healthBar.zPosition = 12
        healthBar.fillColor = Util.redColor
        healthBar.lineWidth = 0
        healthBar.position = CGPoint(x: 0, y: 0)
        node.addChild(healthBar)
        
        node.runAction(SKAction.fadeOutWithDuration(0))

        return node
    }
    
}
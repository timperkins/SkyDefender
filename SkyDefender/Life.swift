import UIKit
import SpriteKit

class Life: SKNode {
    var healthBarContainer: SKShapeNode?
    var healthBar: SKShapeNode?
    var size = CGSize(width: 0, height: 0)
    dynamic var health = 100
    var totalHealth = 100
    var hitByExplosions = [Explosion]()
    var hideHealthBar = false
    var explosionSize: CGFloat = 5
    var explosionDamage: CGFloat = 10
    var explosion: Explosion?
    init(size: CGSize, hideHealthBar: Bool = false, health: Int = 100, totalHealth: Int = 100, explosionSize: CGFloat = 0.2, explosionDamage: CGFloat = 10) {
        super.init()
        
        self.size = size
        self.hideHealthBar = hideHealthBar
        self.health = health < totalHealth ? health : totalHealth
        self.totalHealth = totalHealth
        self.explosionSize = explosionSize
        self.explosionDamage = explosionDamage
        
        if !hideHealthBar {
            setupHealthBar()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupHealthBar() {
        let barWidth = abs(size.width)
        healthBarContainer = SKShapeNode(rect: CGRect(x: 0, y: 0, width: barWidth, height: 8), cornerRadius: 1)
        healthBarContainer?.zPosition = 6
        healthBarContainer?.lineWidth = 0
        healthBarContainer?.position = CGPoint(x: barWidth / 2 * -1, y: size.height + 3)
        healthBarContainer?.fillColor = SKColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.addChild(healthBarContainer!)
        
        let healthBarWidth = Int(barWidth * CGFloat(self.health) / CGFloat(totalHealth))
        healthBar = SKShapeNode(rect: CGRect(x: 0, y: 0, width: healthBarWidth, height: 8), cornerRadius: 1)
        healthBar?.zPosition = 7
        healthBar?.fillColor = Util.redColor
        healthBar?.lineWidth = 0
        healthBar?.position = CGPoint(x: 0, y: 0)
        healthBarContainer?.addChild(healthBar!)
        
        let doFadeOut = SKAction.fadeOutWithDuration(0)
        healthBarContainer?.runAction(doFadeOut)
    }
    
    func hit(explosion: Explosion, position: CGPoint) {
        if hitByExplosions.indexOf(explosion) == nil {
            didHit(position)
            hitByExplosions.append(explosion)
            self.health = self.health - explosion.getDamage()
            if self.isAlive() {
                if hideHealthBar { return }
                let healthBarWidth = CGFloat(self.health) / CGFloat(totalHealth)
                healthBar?.xScale = healthBarWidth
                let doFadeIn = SKAction.fadeInWithDuration(0.1)
                let doWait = SKAction.waitForDuration(5)
                let doFadeOut = SKAction.fadeOutWithDuration(0.4)
                let doSequence = SKAction.sequence([doFadeIn, doWait, doFadeOut])
                healthBarContainer?.removeActionForKey("fade")
                healthBarContainer?.runAction(doSequence, withKey: "fade")
            } else {
                explode()
            }
        }
    }
    
    func explode() -> Explosion {
        if explosion != nil { return explosion! }
        
        explosion = Explosion(position: self.position, size: explosionSize, damage: explosionDamage)
        parent?.addChild(explosion!)
        removeFromParent()
        didExplode()
        return explosion!
    }
    
    func leaveGame() {
        removeFromParent()
        didLeaveGame()
    }
    
    func didHit(position: CGPoint) {}
    
    func didExplode() {}
    
    func didLeaveGame() {}
    
    func isAlive() -> Bool {
        return health > 0
    }
}

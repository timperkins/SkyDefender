import UIKit
import SpriteKit

class Base: Life {
    let theTexture = SKTexture(imageNamed: "base")
    var baseNode: SKSpriteNode?
    init() {
        super.init(size: theTexture.size(), hideHealthBar: true)
        
        explosionSize = 80
        explosionDamage = 1
        
        setupBaseNode()
//        initPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupBaseNode() {
        baseNode = SKSpriteNode(texture: theTexture)
        baseNode!.size = size
        baseNode!.zPosition = 4
        baseNode!.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.addChild(baseNode!)
    }
    
//    func initPhysics() {
//        physicsBody = SKPhysicsBody(rectangleOfSize: theTexture.size(), center: CGPoint(x: 0, y: -theTexture.size().height/2))
//        physicsBody?.dynamic = true
//        physicsBody?.usesPreciseCollisionDetection = true
//        physicsBody?.categoryBitMask = CollisionCategories.Base
//        physicsBody?.contactTestBitMask = CollisionCategories.Bomb | CollisionCategories.Explosion
//        physicsBody?.collisionBitMask = 0
//    }
}

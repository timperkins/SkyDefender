import UIKit
import SpriteKit

class Plane: Life, PointTrait {
    var theTexture: SKTexture!
    var planeNode: SKSpriteNode?
    var color: SKColor!
    var angle: CGFloat = 0
    var points: Int = 100
    var hit = false
    var movingSpeed: CGFloat = 60 {
        didSet {
            if movingSpeed > 0 {
                xScale = 1
            } else {
                xScale = -1
            }
        }
    }
    
    init(theTexture: SKTexture, movingSpeed: CGFloat = 60, points: Int = 100, color: SKColor = SKColor.blackColor(), totalHealth: Int = 100) {
        super.init(size: theTexture.size(), totalHealth: totalHealth, hideHealthBar: true, explosionSize: 1.3)
        
        self.theTexture = theTexture
        self.movingSpeed = movingSpeed
        self.points = points
        self.color = color
        
        zPosition = 5
        
        setupPlaneNode()
        initPhysics()
        
        Util.movingBodies.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupPlaneNode() {
        planeNode = SKSpriteNode(texture: theTexture)
        planeNode!.size = size
        self.addChild(planeNode!)
    }
    
    private var canFlip = true
    func flip() {
        if canFlip {
            movingSpeed = -movingSpeed
            physicsBody?.velocity.dx = -(physicsBody?.velocity.dx)!
            canFlip = false
        }
        
        removeActionForKey(Util.resumeFlipping)
        let doResumeFlipping = SKAction.runBlock({
            self.canFlip = true
        })
        let doWait = SKAction.waitForDuration(1)
        let doSequence = SKAction.sequence([doWait, doResumeFlipping])
        runAction(doSequence, withKey: Util.resumeFlipping)
    }
    
    func initPhysics() {
        physicsBody = SKPhysicsBody(texture: self.theTexture, size:planeNode!.size)
        physicsBody?.velocity = CGVector(dx: movingSpeed, dy: 0)
        physicsBody?.dynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.allowsRotation = false
        physicsBody?.density = 15
        physicsBody?.linearDamping = 0
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = CollisionCategories.Plane
        physicsBody?.contactTestBitMask = CollisionCategories.Bg | CollisionCategories.Explosion
        physicsBody?.collisionBitMask = 0
    }
    
    override func didHit(position: CGPoint) {
        if !hit {
            hit = true
            physicsBody?.affectedByGravity = true
            
            
            runAction(SKAction.waitForDuration(0.2), completion: {
                var rotateAngle = -M_PI_2
                if self.movingSpeed < 0 {
                    rotateAngle = M_PI_2
                }
                var rotate = SKAction.rotateToAngle(CGFloat(rotateAngle), duration: 5)
                self.runAction(rotate)
                
                let emitterNodePath:NSString = NSBundle.mainBundle().pathForResource("smoke", ofType: "sks")!
                let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterNodePath as String) as! SKEmitterNode
                emitterNode.position = position
                emitterNode.position.y += 5
                emitterNode.zPosition = 8
                
                // Rotate the smoke opposite the plane rotation so it is always vertical
                rotate = SKAction.rotateToAngle(CGFloat(M_PI_2), duration: 5)
                emitterNode.runAction(rotate)
                
                self.planeNode?.addChild(emitterNode)
            })
        }
    }
    
    override func didExplode() {
        super.didExplode()
        levelStats.score += points
        levelStats.planesHit++;
    }
    
    override func didLeaveGame() {
        super.didLeaveGame()
        levelStats.planesMissed++;
    }
}

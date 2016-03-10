import SpriteKit
import GameplayKit
import AVFoundation

class Plane: GKEntity, ContactNotifiableType {
    var velocity = CGVector(dx: 50, dy: 0)
    var points = 0
    var physicsBody: SKPhysicsBody!
    var scene: SKScene!
    var contactObjects = [GKEntity]()
    var didExplode = false
    var isFalling = false
    var isFlipped = false
    var planeHitSound: AVAudioPlayer!
    var planeCrashSound: AVAudioPlayer!
    var planeExhaust: SKEmitterNode!
    private var _node:SKNode!

    var renderComponent:RenderComponent {
        return componentForClass(RenderComponent)!
    }
    
    init(position: CGPoint, scene: SKScene) {
        super.init()
        
        self.scene = scene
        points = 500
        
        let renderComponent = RenderComponent(entity: self)
        renderComponent.node.position = position
        renderComponent.node.name = "plane"
        addComponent(renderComponent)
        
        let texture = SKTexture(imageNamed: "enemy-bomber-plane")
        let planeNode = SKSpriteNode(texture: texture)
        planeNode.zPosition = 11
        renderComponent.node.addChild(planeNode)

        physicsBody = SKPhysicsBody(texture: texture, size:texture.size())
        physicsBody.dynamic = true
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.density = 50
        physicsBody.linearDamping = 0
        physicsBody.affectedByGravity = false
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .Plane)
        addComponent(physicsComponent)
        renderComponent.node.physicsBody = physicsComponent.physicsBody
        
        if position.x > 0 {
            // Flip
            isFlipped = true
            velocity.dx = -velocity.dx
            renderComponent.node.xScale = -renderComponent.node.xScale
        }
        
        let movementComponent = MovementComponent(velocity: velocity)
        addComponent(movementComponent)
        renderComponent.node.physicsBody?.velocity = movementComponent.velocity
        
        let healthComponent = HealthComponent(hp: 100)
        addComponent(healthComponent)
        renderComponent.node.addChild(healthComponent.getHealthBarOfWidth(texture.size().width))
        
        let emitterNodePath = NSBundle.mainBundle().pathForResource("PlaneExhaust", ofType: "sks")!
        planeExhaust = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterNodePath as String) as! SKEmitterNode
        planeExhaust.position = CGPoint(x: -texture.size().width/2, y: -3)
        planeExhaust.zPosition = 15
        renderComponent.node.addChild(planeExhaust)
        
        let planeHitSoundFile = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("plane-hit", ofType: "wav")!)
        do {
            planeHitSound = try AVAudioPlayer(contentsOfURL: planeHitSoundFile)
            planeHitSound.volume = 0.6
            planeHitSound.prepareToPlay()
        } catch {
            print("Error getting the audio file")
        }
        
        let planeCrashSoundFile = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("plane-crash", ofType: "mp3")!)
        do {
            planeCrashSound = try AVAudioPlayer(contentsOfURL: planeCrashSoundFile)
            planeCrashSound.volume = 0.5
            planeCrashSound.prepareToPlay()
        } catch {
            print("Error getting the audio file")
        }
    }
    
    func explode(point: CGPoint) {
        let emitterNodePath = NSBundle.mainBundle().pathForResource("BigSquareExplosion", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterNodePath as String) as! SKEmitterNode
        emitterNode.position = point
        emitterNode.zPosition = 15
        scene.addChild(emitterNode)
        
        scene.runAction(SKAction.waitForDuration(1.0), completion: {
            emitterNode.removeFromParent()
        })
        
        planeCrashSound.play()
    }
    
    func hitByMissle(missle: Missle, contactPointInNode: CGPoint) {
        missle.renderComponent.node.removeFromParent()
        let healthComponent = self.componentForClass(HealthComponent)!
        
        let damage = min(missle.componentForClass(DamageComponent)!.damage, healthComponent.hp)
        healthComponent.hit(damage)
        
        if !healthComponent.isAlive() {
            fall(contactPointInNode)
        }
        
        renderComponent.node.runAction(SKAction.waitForDuration(0.05), completion: {
            let node = self.renderComponent.node
            node.physicsBody?.velocity = self.velocity
            node.physicsBody?.angularVelocity = 0
            node.runAction(SKAction.rotateToAngle(0, duration: 0.2))
        })
        
        let emitterNodePath = NSBundle.mainBundle().pathForResource("SquareExplosion", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterNodePath as String) as! SKEmitterNode
        emitterNode.position = contactPointInNode
        emitterNode.zPosition = 15
        renderComponent.node.addChild(emitterNode)
        
        planeHitSound.play()
        
        levelStats.score += Int(damage)
    }
    
    func fall(contactPointInNode: CGPoint) {
        isFalling = true
        self.physicsBody.density = 1000000 // We don't want anything (e.g., a missle) to move the plane while it's falling
        planeExhaust.runAction(SKAction.fadeAlphaTo(0, duration: 0.3))
        renderComponent.node.runAction(SKAction.waitForDuration(0.3), completion: {
            self.physicsBody.affectedByGravity = true
            
            var rotateAngle = -M_PI_2
            if self.velocity.dx < 0 {
                rotateAngle = M_PI_2
            }
            var rotate = SKAction.rotateToAngle(CGFloat(rotateAngle), duration: 5)
            self.renderComponent.node.runAction(rotate)
            
            self.planeExhaust.removeFromParent()
            
            let emitterNodePath = NSBundle.mainBundle().pathForResource("SquareSmoke", ofType: "sks")!
            let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterNodePath as String) as! SKEmitterNode
            emitterNode.position = contactPointInNode
            emitterNode.zPosition = 15
            
            // Rotate the smoke opposite the plane rotation so it is always vertical
            rotate = SKAction.rotateToAngle(CGFloat(M_PI_2), duration: 5)
            emitterNode.runAction(rotate)
            self.renderComponent.node.addChild(emitterNode)
        })
    }
    
    func contactWithEntityDidBegin(entity: GKEntity, contactPoint: CGPoint) {
        if contactPoint.y < 3 && !didExplode {
            didExplode = true
            var point = contactPoint
            point.y = 0
            explode(point)
        }
        
        if contactObjects.contains(entity) { return }
        contactObjects.append(entity)
        
        let contactPointInNode = renderComponent.node.convertPoint(contactPoint, fromNode: scene)
        
        if let background = entity as? Background {
            if isFalling {
                levelStats.score += points
                if let levelScene = scene as? LevelScene {
                    levelScene.planeCrashed()
                }
            }
            renderComponent.node.runAction(SKAction.waitForDuration(2), completion: {
                let position = self.renderComponent.node.position
                if position.x < 0 || position.x > Util.deviceSize.width || position.y < 0 {
                    self.renderComponent.node.removeFromParent()
                } else {
                    // Remove the background from 'contactObjects' so we can detect it when 
                    // this goes off screen
                    self.contactObjects.removeObject(background)
                }
            })
        }
        
        if let missle = entity as? Missle {
            // Let missles pass by if this is falling
            if isFalling { return }
            
            hitByMissle(missle, contactPointInNode: contactPointInNode)
        }
    }
    
    func contactWithEntityDidEnd(entity: GKEntity, contactPoint: CGPoint) {}
    
    class func loadAssets() {
        ColliderType.requestedContactNotifications[.Plane] = [.Background, .Missle]
        ColliderType.definedCollisions[.Plane] = [.Missle]
    }
}
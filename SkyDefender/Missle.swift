import SpriteKit
import GameplayKit

class Missle: GKEntity, ContactNotifiableType {
    let rect = CGRect(origin: CGPoint(x: 0, y: -8), size: CGSize(width: 1, height: 8))
    let movingSpeed = CGFloat(400)
    var contactObjects = [GKEntity]()
    var renderComponent:RenderComponent {
        return componentForClass(RenderComponent)!
    }
    
    init(position: CGPoint, angle: CGFloat = 0) {
        super.init()
        
        
        
        let renderComponent = RenderComponent(entity: self)
        renderComponent.node.zPosition = 12
        renderComponent.node.name = "missle"
        renderComponent.node.position = position
        renderComponent.node.zRotation = CGFloat(M_PI) - angle
        addComponent(renderComponent)
        
        let damageComponent = DamageComponent(damage: 50)
        addComponent(damageComponent)
        
        let missleNode = SKShapeNode()
        missleNode.path = CGPathCreateWithRect(rect, nil)
        missleNode.lineWidth = 0
        missleNode.fillColor = UIColor(red: 1, green: 1, blue: 0.8, alpha: 1)
        renderComponent.node.addChild(missleNode)
        
        let physicsBody = SKPhysicsBody(rectangleOfSize: rect.size)
        physicsBody.dynamic = true
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.allowsRotation = false
        physicsBody.linearDamping = 0
        physicsBody.affectedByGravity = false
        let vx = sin(angle) * movingSpeed
        let vy = cos(angle) * movingSpeed
        physicsBody.velocity = CGVector(dx: vx, dy: vy)
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .Missle)
        addComponent(physicsComponent)
        renderComponent.node.physicsBody = physicsComponent.physicsBody
    }
    
    func contactWithEntityDidBegin(entity: GKEntity, contactPoint: CGPoint) {
        if contactObjects.contains(entity) { return }
        contactObjects.append(entity)
        if let _ = entity as? Background {
            renderComponent.node.removeFromParent()
        }
    }
    
    func contactWithEntityDidEnd(entity: GKEntity, contactPoint: CGPoint) {}
    
    class func loadAssets() {
        ColliderType.requestedContactNotifications[.Missle] = [.Plane, .Background]
    }
}
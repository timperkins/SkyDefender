import SpriteKit
import GameplayKit

class Background: GKEntity {
    private var _node:SKNode!
    var sky: SKSpriteNode!
    var backHill: SKSpriteNode!
    var frontHill: SKSpriteNode!
    
    var renderComponent:RenderComponent {
        return componentForClass(RenderComponent)!
    }
    
    enum State {
        case Sky
        case Shake
    }
    var state: State! = .Sky
    var prevState: State! = .Sky
    
    init(name: String) {
        super.init()
        
        
        let renderComponent = RenderComponent(entity: self)
        renderComponent.node.name = "background"
        addComponent(renderComponent)
        
        let texture = SKTexture(imageNamed: "\(name)a")
        sky = SKSpriteNode(texture: texture)
        sky.zPosition = 1
        sky.anchorPoint = CGPoint(x: 0, y: 0)
        sky.position = CGPoint(x: 0, y: 0)
        sky.hidden = true
        renderComponent.node.addChild(sky)
        
        backHill = SKSpriteNode(imageNamed: "\(name)b")
        backHill.zPosition = 2
        backHill.anchorPoint = CGPoint(x: 0, y: 0)
        backHill.position = CGPoint(x: 0, y: 0)
        sky.addChild(backHill)
        
        frontHill = SKSpriteNode(imageNamed: "\(name)c")
        frontHill.zPosition = 3
        frontHill.anchorPoint = CGPoint(x: 0, y: 0)
        frontHill.position = CGPoint(x: 0, y: 0)
        sky.addChild(frontHill)
        
        let physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: texture.size().width, height: texture.size().height))
        physicsBody.affectedByGravity = false
        let physicsComponent = PhysicsComponent(physicsBody: physicsBody, colliderType: .Background)
        addComponent(physicsComponent)
        renderComponent.node.physicsBody = physicsComponent.physicsBody
    }
    
    func setPosition(state: State) {
        self.prevState = self.state
        self.state = state
        switch state {
        case .Sky:
            transitionToSky(0)
        case .Shake:
            shake()
//        case .Middle:
//        case .Low:
        }
    }
    
    func transitionToSky(duration: CGFloat) {
        sky.hidden = false
    }
    
    func shake() {
//        let moveUp = SKAction.moveToY(2, duration: 0.1)
//        var moveDown = SKAction.moveToY(-2, duration: 0.1)
        let moveToOrigin = SKAction.moveToY(0, duration: 0.1)
//        backHill.runAction(SKAction.sequence([moveUp, moveDown, moveToOrigin]))
        
        let moveDown = SKAction.moveToY(-2, duration: 0.1)
        let moveDownSmall = SKAction.moveToY(-1, duration: 0.1)
        frontHill.runAction(SKAction.sequence([moveDown, moveToOrigin, moveDownSmall, moveToOrigin]))
        
        // TODO go back to previous state
    }
}
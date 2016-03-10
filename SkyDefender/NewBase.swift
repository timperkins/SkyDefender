import SpriteKit
import GameplayKit

class NewBase: GKEntity {
    var gunNode: Gun!
    let tiltSensitivity: CGFloat = 1.7
    var angle: CGFloat = 30 {
        didSet {
            self.gunNode.zRotation = angle * -1 + CGFloat(M_PI_2)
            if angle < 0 {
                self.gunNode.yScale = -1
            } else {
                self.gunNode.yScale = 1
            }
        }
    }
    var renderComponent:RenderComponent {
        return componentForClass(RenderComponent)!
    }
    
    override init() {
        super.init()
        
        let texture = SKTexture(imageNamed: "base")
        let renderComponent = RenderComponent(entity: self)
        renderComponent.node.zPosition = 10
        renderComponent.node.name = "base"
        renderComponent.node.position = CGPoint(x: Util.deviceSize.width/2, y: texture.size().height)
        addComponent(renderComponent)
        
        
        let baseNode = SKSpriteNode(texture: texture)
        baseNode.anchorPoint = CGPoint(x: 0.5, y: 1)
        renderComponent.node.addChild(baseNode)
        
        gunNode = Gun()
        baseNode.addChild(gunNode)
        gunNode.angle = 1
        
        
    }
}
import SpriteKit
import GameplayKit

class RenderComponent: GKComponent {
    let node = EntityNode()
    init(entity: GKEntity) {
        node.entity = entity
    }
}

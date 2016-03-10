import SpriteKit
import GameplayKit

class PhysicsComponent: GKComponent {
    var physicsBody: SKPhysicsBody

    init(physicsBody: SKPhysicsBody, colliderType: ColliderType) {
        self.physicsBody = physicsBody
        self.physicsBody.categoryBitMask = colliderType.categoryMask
        self.physicsBody.collisionBitMask = colliderType.collisionMask
        self.physicsBody.contactTestBitMask = colliderType.contactMask
    }
}
import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
    let velocity: CGVector
    
    init(velocity: CGVector) {
        self.velocity = velocity
    }
}
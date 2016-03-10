import SpriteKit
import GameplayKit

class DamageComponent: GKComponent {
    let damage: CGFloat
    
    init(damage: CGFloat) {
        self.damage = damage
    }
    
}
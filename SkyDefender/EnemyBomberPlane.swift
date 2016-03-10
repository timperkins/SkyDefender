import UIKit
import SpriteKit

class EnemyBomberPlane: Plane {
    init() {
        let theTexture = SKTexture(imageNamed: "enemy-bomber-plane")
        let movingSpeed:CGFloat = 60
        let points = 350
        let color = SKColor(red: 192/255, green: 0, blue: 0, alpha: 1)
        let totalHealth = 100
        super.init(theTexture: theTexture, movingSpeed: movingSpeed, points: points, color: color, totalHealth: totalHealth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

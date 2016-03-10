import UIKit
import SpriteKit

class SupplyPlane: Plane {
    init() {
        let theTexture = SKTexture(imageNamed: "supply-plane")
        let movingSpeed:CGFloat = 20
        let points = -500
        let color = SKColor(red: 24/255, green: 143/255, blue: 170/255, alpha: 1)
        super.init(theTexture: theTexture, movingSpeed: movingSpeed, points: points, color: color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didExplode() {
        super.didExplode()
        levelStats.lostLevel("You destroyed a supply plane.")
    }
}

import UIKit
import SpriteKit

class LevelPlane {
    var plane: String?
    var delay: Int?
    var position: CGPoint!
    
    init(plane: String, delay: Int, position: CGPoint) {
        self.plane = plane
        self.delay = delay
        self.position = position
    }
    
    func createPlane() -> Plane {
        var planeInstance: Plane!
        if plane == "SupplyPlane" {
            planeInstance = SupplyPlane()
        } else if plane == "EnemyBomberPlane" {
            planeInstance = EnemyBomberPlane()
        }
        
        let planeXPosition: CGFloat = position.x == 0 ? -50 : Util.deviceSize.width + 50
        let planeYPosition: CGFloat = position.y * Util.deviceSize.height + 100
        planeInstance.position = CGPoint(x: planeXPosition, y: planeYPosition)
        
        if planeXPosition > 0 {
            planeInstance.flip()
        }
        
        return planeInstance
    }
}

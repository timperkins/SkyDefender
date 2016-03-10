import SpriteKit
import GameplayKit

protocol ContactNotifiableType {
    func contactWithEntityDidBegin(entity: GKEntity, contactPoint: CGPoint)
    func contactWithEntityDidEnd(entity: GKEntity, contactPoint: CGPoint)
}

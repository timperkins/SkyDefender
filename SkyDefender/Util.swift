import Foundation
import SpriteKit

class Util {
    static let darkBlue = SKColor(red: 66/255, green: 77/255, blue: 89/255, alpha: 1)
    
    static let deviceSize = UIScreen.mainScreen().bounds.size
    static let backgroundAnchorHeight: CGFloat = 80.0
    static let backgroundLength: CGFloat = Util.deviceSize.width
    
    static let levels = [Level(
        background: SKSpriteNode(imageNamed: "bg-1a"),
        backgroundLayer2: SKSpriteNode(imageNamed: "bg-1b"),
        backgroundLayer3: SKSpriteNode(imageNamed: "bg-1c"),
        title: "Level 1",
        levelPlanes: [
            LevelPlane(plane: "SupplyPlane", delay: 0, position: CGPoint(x: 0, y: 0.5)),
            LevelPlane(plane: "EnemyBomberPlane", delay: 0, position: CGPoint(x: 1, y: 0.4)),
            LevelPlane(plane: "EnemyBomberPlane", delay: 0, position: CGPoint(x: 1, y: 0.3)),
            LevelPlane(plane: "SupplyPlane", delay: 0, position: CGPoint(x: 1, y: 0.7)),
            LevelPlane(plane: "EnemyBomberPlane", delay: 2, position: CGPoint(x: 0, y: 0.6)),
            LevelPlane(plane: "EnemyBomberPlane", delay: 2, position: CGPoint(x: 0, y: 0.2)),
            LevelPlane(plane: "EnemyBomberPlane", delay: 2, position: CGPoint(x: 1, y: 0.35)),
            LevelPlane(plane: "EnemyBomberPlane", delay: 2, position: CGPoint(x: 1, y: 0.75)),
            LevelPlane(plane: "EnemyBomberPlane", delay: 2, position: CGPoint(x: 0, y: 0.25)),
            LevelPlane(plane: "EnemyBomberPlane", delay: 2, position: CGPoint(x: 1, y: 0.65)),
            LevelPlane(plane: "EnemyBomberPlane", delay: 2, position: CGPoint(x: 0, y: 0.55 ))
        ]
    )]
    
    static var healthContext = 0
    static var scoreContext = 1
    static var gameOverContext = 2
    
    static let redColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1)
    static let yellowColor = SKColor(red: 1, green: 206/255, blue: 0, alpha: 1)
    static let greenColor = SKColor(red: 0, green: 137/255, blue: 23/255, alpha: 1)
    
    static let fontLight = "AvenirNext-UltraLight"
    static let fontRegular = "AvenirNext-Regular"
    static let fontFat = "AvenirNext-Heavy"
    
    static var movingBodies = [SKNode]()
    
    static let background = "background"
    static let baseHealthBar = "baseHealthBar"
    static let cliffs = "cliffs"
    static let closeModalButton = "closeModalButton"
    static let levelScore = "levelScore"
    static let listButton = "listButton"
    static let missleRepeat = "missleRepeat"
    static let offTouch = "offTouch"
    static let onBaseHealthChange = "onBaseHealthChange"
    static let onTouch = "onTouch"
    static let pauseButton = "pauseButton"
    static let pauseModal = "pauseModal"
    static let restartButton = "restartButton"
    static let resumeFlipping = "resumeFlipping"
    static let shootMissle = "shootMissle"
}

extension Array where Element : Equatable {
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}
import SpriteKit
class Level {
    var background: SKSpriteNode!
    var backgroundLayer2: SKSpriteNode!
    var backgroundLayer3: SKSpriteNode!
    var title: String
    var levelPlanes = [LevelPlane]()
    
    init(background: SKSpriteNode, backgroundLayer2: SKSpriteNode, backgroundLayer3: SKSpriteNode, title: String, levelPlanes: [LevelPlane]) {
        self.background = background
        self.backgroundLayer2 = backgroundLayer2
        self.backgroundLayer3 = backgroundLayer3
        self.title = title
        self.levelPlanes = levelPlanes
    }
}
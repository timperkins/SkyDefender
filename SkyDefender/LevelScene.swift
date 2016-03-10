import SpriteKit
import GameplayKit

class LevelScene: SKScene, SKPhysicsContactDelegate {
//    var background: SKSpriteNode!
//    var backgroundLayer2: SKSpriteNode!
//    var backgroundLayer3: SKSpriteNode!
    var aimAnchorPoint: CGPoint!
    var aimAnchorAngle: CGFloat!
    var aimGuideCircle: SKSpriteNode!
    var aimGuideLine: SKSpriteNode!
//    var playButton: SKSpriteNode!
//    var previousLevelButton: SKSpriteNode!
//    var nextLevelButton: SKSpriteNode!
//    var levelLabel: SKLabelNode!
//    var levelInProgress = false
    var base: NewBase!
    var gun: Gun!
    var levelData: [[String: AnyObject]]!
    var pauseButton: ButtonNode!
    var levelScore: LevelScore!
    var planes = [NewPlane]()
    var backgroundMusic: SKAudioNode!
    
    var newBackground: Background!
    enum State {
        case Playing
    }
    var state: State = .Playing
    
    override func didMoveToView(view: SKView) {
        anchorPoint = CGPoint(x: 0, y: 0)
        
        backgroundMusic = SKAudioNode(fileNamed: "background-music.m4a")
        addChild(backgroundMusic)
        
        NewPlane.loadAssets()
        NewMissle.loadAssets()
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0, -0.3)
        
        let url = NSBundle.mainBundle().URLForResource("LevelData", withExtension: "plist")!
        levelData = NSArray(contentsOfURL: url) as! [[String: AnyObject]]
        
        newBackground = Background(name: levelData[0]["background"] as! String)
        addChild(newBackground.renderComponent.node)
        newBackground.setPosition(.Sky)
        
        levelScore = LevelScore()
        levelScore.renderComponent.node.position = CGPoint(x: 12, y: size.height - 12)
        addChild(levelScore.renderComponent.node)
        
        let pauseTexture = SKTexture(imageNamed: "pause-button")
        pauseButton = ButtonNode(texture: pauseTexture, onTouch: pause)
        pauseButton.position = CGPoint(x: size.width - 20, y: size.height - 20)
        pauseButton.zPosition = 20
        addChild(pauseButton)
        
        let planesData = levelData[0]["planes"] as! [[String: AnyObject]]
        let noFlyZoneTop:CGFloat = 20
        let noFlyZoneBottom:CGFloat = 100
        
        var steps = [SKAction]()
        
        for planeData in planesData {
            var posX:CGFloat = -50
            if planeData["positionX"] as! Int == 1 {
                posX = size.width + 50
            }
            let posY:CGFloat = planeData["positionY"] as! CGFloat * (size.height - noFlyZoneTop - noFlyZoneBottom) + noFlyZoneBottom
            let position = CGPoint(x: posX, y: posY)
            let doAddPlane = SKAction.runBlock({
                let plane = NewPlane(position: position, scene: self)
                self.addChild(plane.renderComponent.node);
                self.planes.append(plane)
            })
            
            let doDelay = SKAction.waitForDuration(planeData["delay"] as! Double)
            steps.append(doDelay)
            steps.append(doAddPlane)
        }
        runAction(SKAction.sequence(steps))
        
        base = NewBase()
        addChild(base.renderComponent.node)
        
        state = .Playing
        initAimGuides()
    }
    
    func pause() {
        for plane in planes {
            plane.renderComponent.node.paused = true
        }
        pauseButton.hidden = true
        levelScore.renderComponent.node.hidden = true
        runAction(SKAction.waitForDuration(0.001), completion: {
            
        })
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        handleContact(contact) { (ContactNotifiableType: ContactNotifiableType, otherEntity: GKEntity, contactPoint: CGPoint) in
            ContactNotifiableType.contactWithEntityDidBegin(otherEntity, contactPoint: contactPoint)
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        handleContact(contact) { (ContactNotifiableType: ContactNotifiableType, otherEntity: GKEntity, contactPoint: CGPoint) in
            ContactNotifiableType.contactWithEntityDidEnd(otherEntity, contactPoint: contactPoint)
        }
    }
    
    private func handleContact(contact: SKPhysicsContact, contactCallback: (ContactNotifiableType, GKEntity, CGPoint) -> Void) {
        let colliderTypeA = ColliderType(rawValue: contact.bodyA.categoryBitMask)
        let colliderTypeB = ColliderType(rawValue: contact.bodyB.categoryBitMask)
        
        let aWantsCallback = colliderTypeA.notifyOnContactWithColliderType(colliderTypeB)
        let bWantsCallback = colliderTypeB.notifyOnContactWithColliderType(colliderTypeA)

        let entityA = (contact.bodyA.node as? EntityNode)?.entity
        let entityB = (contact.bodyB.node as? EntityNode)?.entity

        if let notifiableEntity = entityA as? ContactNotifiableType, otherEntity = entityB where aWantsCallback {
            contactCallback(notifiableEntity, otherEntity, contact.contactPoint)
        }
        
        if let notifiableEntity = entityB as? ContactNotifiableType, otherEntity = entityA where bWantsCallback {
            contactCallback(notifiableEntity, otherEntity, contact.contactPoint)
        }
    }
    
    func planeCrashed() {
        newBackground.setPosition(.Shake)
    }
    
    func initTitleLogo() {
        let titleLogo = SKSpriteNode(imageNamed: "title-logo")
        titleLogo.position = CGPoint(x: size.width/2, y: size.height/2)
        titleLogo.zPosition = 2
//        background.addChild(titleLogo)
        let delay = SKAction.waitForDuration(1)
        let move = SKAction.moveTo(CGPoint(x: size.width/2, y: size.height*1.5), duration: 2.5)
        let sequence = SKAction.sequence([delay, move])
        titleLogo.runAction(sequence)
    }
    
//    func initLevelSelectOptions() {
//        let delay = SKAction.waitForDuration(4)
//        let initOpts = SKAction.runBlock({
//            self.playButton = SKSpriteNode(imageNamed: "play-button")
//            self.playButton.zPosition = 4
//            self.playButton.alpha = 0
//            self.playButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2-40)
//            self.background.addChild(self.playButton)
//            var fadeIn = SKAction.fadeInWithDuration(0.5)
//            self.playButton.runAction(fadeIn)
//            
//            self.levelLabel = SKLabelNode(fontNamed: Util.fontLight)
//            self.levelLabel.text = "Level label goes here"
//            self.levelLabel.fontSize = 50
//            self.levelLabel.alpha = 0
//            self.levelLabel.fontColor = SKColor.whiteColor()
//            self.levelLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2+80)
//            self.levelLabel.zPosition = 4
//            self.background.addChild(self.levelLabel)
//            fadeIn = SKAction.fadeInWithDuration(0.5)
//            self.levelLabel.runAction(fadeIn)
//            
//            self.previousLevelButton = SKSpriteNode(imageNamed: "left-chevron")
//            self.previousLevelButton.zPosition = 4
//            self.previousLevelButton.alpha = 0
//            self.previousLevelButton.position = CGPoint(x: 40, y: self.size.height/2)
//            self.background.addChild(self.previousLevelButton)
//            fadeIn = SKAction.fadeAlphaTo(0.2, duration: 0.5)
//            self.previousLevelButton.runAction(fadeIn)
//            
//            self.nextLevelButton = SKSpriteNode(imageNamed: "right-chevron")
//            self.nextLevelButton.zPosition = 4
//            self.nextLevelButton.alpha = 0
//            self.nextLevelButton.position = CGPoint(x: self.size.width-40, y: self.size.height/2)
//            self.background.addChild(self.nextLevelButton)
//            fadeIn = SKAction.fadeAlphaTo(0.2, duration: 0.5)
//            self.nextLevelButton.runAction(fadeIn)
//        })
//        let sequence = SKAction.sequence([delay, initOpts])
//        runAction(sequence)
//    }
    
    func initAimGuides() {
        aimGuideCircle = SKSpriteNode(imageNamed: "aim-guide-circle")
        aimGuideCircle.zPosition = 5
        aimGuideCircle.hidden = true
        newBackground.renderComponent.node.addChild(aimGuideCircle)
        
        aimGuideLine = SKSpriteNode(imageNamed: "aim-guide-line")
        aimGuideLine.zPosition = 5
        aimGuideLine.hidden = true
        newBackground.renderComponent.node.addChild(aimGuideLine)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)

        switch state {
        case .Playing:
            if location.x >= size.width/2 {
                // Fire
                if let missle = base.gunNode.fireMissle() {
                    addChild(missle.renderComponent.node)
                }
            } else {
                // Set anchor point for aim
                aimAnchorPoint = location
                aimAnchorAngle = base.gunNode.angle
                
                aimGuideCircle.hidden = false
                aimGuideCircle.position = location
                aimGuideLine.hidden = false
                aimGuideLine.position = location
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        
        switch state {
        case .Playing:
            if location.x < size.width/2 {
                aimGuideCircle.hidden = true
                aimGuideLine.hidden = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        
        if location.x < size.width/2 && aimAnchorPoint != nil {
            let deltaX = location.x - aimAnchorPoint.x
            let deltaAngle = deltaX*base.gunNode.tiltSensitivity/100
            let rotateAngle = aimAnchorAngle + deltaAngle
            if rotateAngle < -2 {
                base.gunNode.angle = -2
            } else if rotateAngle > 2 {
                base.gunNode.angle = 2
            } else {
                base.gunNode.angle = rotateAngle
            }
            
            aimGuideCircle.position = location
            aimGuideLine.position.y = location.y
        }
    }
}

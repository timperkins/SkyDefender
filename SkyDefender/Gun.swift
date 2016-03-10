import UIKit
import SpriteKit
import AVFoundation

class Gun: SKSpriteNode {
    let theTexture = SKTexture(imageNamed: "gun")
    let tiltSensitivity: CGFloat = 1.7
    let fireDelay = 0.3
    var readyToFire = true
    var automaticInterval = 0.2
    var audioPlayer: AVAudioPlayer!
    var angle: CGFloat = 0 {
        didSet {
            self.zRotation = angle * -1 + CGFloat(M_PI_2)
            if angle < 0 {
                self.yScale = -1
            } else {
                self.yScale = 1
            }
        }
    }
    init() {
        super.init(texture: theTexture, color: SKColor.clearColor(), size: theTexture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func fireMissle() -> NewMissle? {
        if !readyToFire { return nil }
        
        readyToFire = false
        let waitForFireReady = SKAction.waitForDuration(fireDelay)
        let enableFire = SKAction.runBlock({
          self.readyToFire = true
        })
        runAction(SKAction.sequence([waitForFireReady, enableFire]))

        let adj = size.width/2 - 8
        let gunTipX = CGFloat(sin(self.angle)) * adj
        let gunTipY = CGFloat(cos(self.angle)) * adj
        let missleX = gunTipX + Util.deviceSize.width/2
        let missleY = gunTipY + parent!.frame.size.height
        let missle = NewMissle(position: CGPoint(x: missleX, y: missleY), angle: self.angle)

        let emitterNodePath = NSBundle.mainBundle().pathForResource("SmallSquareExplosion", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(emitterNodePath as String) as! SKEmitterNode
        emitterNode.position = CGPoint(x: texture!.size().width/2 + 2, y: 0)
        emitterNode.zPosition = 5
        addChild(emitterNode)
        
        runAction(SKAction.waitForDuration(0.2), completion: {
            emitterNode.removeFromParent()
        })
        
        let gunKickPosition = CGPoint(x: -sin(angle)*5, y: -cos(angle)*5)
        runAction(SKAction.moveTo(gunKickPosition, duration: 0.05), completion: {
            self.runAction(SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 0.3))
        })
        
        let gunSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gun-fire", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL:gunSound)
            audioPlayer.volume = 0.5
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Error getting the audio file")
        }

        return missle
    }
}

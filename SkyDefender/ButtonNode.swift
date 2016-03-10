import SpriteKit

class ButtonNode: SKSpriteNode {
    let onTouch: ()->()
    
    init(texture: SKTexture, onTouch: ()->()) {
        self.onTouch = onTouch
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        onTouch()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let scene = LoadingScene(size: view.bounds.size)
        
        // TODO: remove below and swap for loadingscene
        let scene = LevelScene(size: view.bounds.size)
        scene.userData = NSMutableDictionary()
//        let level = Util.levels[0]
//        scene.userData?.setObject(level, forKey: "level")
        
        let skView = view as! SKView
        skView.showsFPS = true
//        skView.showsPhysics = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft, UIInterfaceOrientationMask.LandscapeRight]
    }
}

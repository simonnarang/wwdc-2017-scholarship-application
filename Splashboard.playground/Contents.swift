import PlaygroundSupport
import SpriteKit
import Darwin
var balloonSize = 100;

func explodeBalloon() {
    
}
func shrinkBalloon() {
    while(balloonSize<50){
        balloonSize = balloonSize - 1
    }
}
class BiTreeView: SKView {

}

class BiTreeScene: SKScene {
    
    func createPaintball(at point: CGPoint){
        
        let wwdcColors = [
            SKColor(red: 0.97, green: 0.97, blue:  0.97, alpha: 1.00),
            SKColor(red: 0.00, green: 0.66, blue:  0.58, alpha: 1.00),
            SKColor(red: 0.88, green: 0.68, blue:  0.04, alpha: 1.00),
            SKColor(red: 0.07, green: 0.69, blue:  0.80, alpha: 1.00),
            SKColor(red: 0.90, green: 0.31, blue:  0.27, alpha: 1.00),
            SKColor(red: 0.23, green: 0.36, blue:  0.44, alpha: 1.00)
        ]
        let color = wwdcColors[Int(arc4random_uniform(5) + 1)]
        let colorChoice = SKShapeNode(rectOf: CGSize(width: 100, height: 50))
        colorChoice.position = CGPoint(x: 50, y: 100)
        colorChoice.fillColor = color
        let paintball = SKShapeNode(circleOfRadius: CGFloat(balloonSize) )
        paintball.position = CGPoint(x:point.x, y: point.y)
        paintball.glowWidth = 2.0
        paintball.fillColor = color
        
        self.scene?.addChild(paintball)
        self.scene?.addChild(colorChoice)
        shrinkBalloon()
        
        let moveNodeUp = SKAction.scale(by: CGFloat(0.4), duration: 0.2)
        let moveNodeDown = SKAction.moveBy(x: CGFloat(0), y: CGFloat(-50), duration: 0.2)
        
        let imageNode = SKSpriteNode(imageNamed: "money.png")
        imageNode.position = CGPoint(x:point.x, y: point.y)
        imageNode.size = CGSize(width: 200, height: 200)
        let sound = SKAction.playSoundFileNamed("splash.mp3", waitForCompletion: false)
        
        paintball.run(moveNodeUp)
        paintball.run(moveNodeDown) { () -> Void in
            paintball.removeFromParent()
            
            self.scene?.addChild(imageNode)
            paintball.run(sound)
            
        }
        
        print(self.scene?.children ?? "No children")
        
    }
    override func sceneDidLoad() {
        
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = "splashboard"
        label.fontColor = SKColor.black
        label.fontSize = 45
        label.position = CGPoint(x:1300,y:50)
        self.addChild(label)
    }
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let location = touch.location(in: self)
            createPaintball(at: location)
            
        }
    }

    
    

}

let scene = BiTreeScene()
scene.scaleMode = .aspectFit
scene.size = CGSize(width: 1500, height: 2500)
scene.backgroundColor = SKColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
let view = BiTreeView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))


view.presentScene(scene)
PlaygroundPage.current.liveView = view

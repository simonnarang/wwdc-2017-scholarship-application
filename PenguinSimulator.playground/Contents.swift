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
class SplashboardView: SKView {

}

class SplashboardScene: SKScene {

    func createPaintball(at point: CGPoint){
        
        let wwdcColors = [
            SKColor(red: 0.02, green: 0.44, blue:  1.00, alpha: 1.00),
            SKColor(red: 1.00, green: 0.00, blue:  0.00, alpha: 1.00),
            SKColor(red: 0.00, green: 0.77, blue:  0.44, alpha: 1.00),
            SKColor(red: 0.44, green: 0.00, blue:  0.84, alpha: 1.00),
            SKColor(red: 0.65, green: 0.53, blue:  0.29, alpha: 1.00),
            SKColor(red: 0.00, green: 1.00, blue:  0.80, alpha: 1.00)
        ]
        let colorNumber = Int(arc4random_uniform(6))
        let color = wwdcColors[colorNumber]
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
        let imageName = String(Int(colorNumber + 1))
        let imageSize = Int(arc4random_uniform(5) + 3) * 50
        let imageNode = SKSpriteNode(imageNamed: imageName)
        imageNode.position = CGPoint(x:point.x, y: point.y)
        imageNode.size = CGSize(width: imageSize, height: imageSize)
        imageNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: imageSize, height: imageSize))
        imageNode.physicsBody?.affectedByGravity = false
        imageNode.physicsBody?.mass = 5
        let sound = SKAction.playSoundFileNamed("splash.mp3", waitForCompletion: false)
        
        paintball.run(moveNodeUp)
        paintball.run(moveNodeDown) { () -> Void in
            paintball.removeFromParent()
            
            self.scene?.addChild(imageNode)
            paintball.run(sound)
            
        }
        print(self.scene?.children ?? "No children")
    }
    override func didMove(to view: SKView) {
        let randomx = Int(arc4random_uniform(25))-12
        let randomy = Int(arc4random_uniform(25))-12
        addPenguin(xMove: randomx, yMove: randomy)
        addSceneWalls()
    }
    func addPenguin(xMove: Int, yMove: Int){
        let randomMove = SKAction.moveBy(x: CGFloat(xMove), y: CGFloat(yMove), duration: 0.1)
        let penguin = SKSpriteNode(imageNamed: "penguin")
        penguin.size = CGSize(width: 200, height: 200)
        penguin.position = CGPoint(x: 500, y:500)
        penguin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 200))
        penguin.physicsBody?.affectedByGravity = false
        let moveRepeat = SKAction.repeatForever(randomMove)
        penguin.run(moveRepeat)
        self.scene?.addChild(penguin)
    }
    func addSceneWalls() {
        
        let wallLeftPath:CGMutablePath = CGMutablePath()
        wallLeftPath.move(to: CGPoint(x: 0, y: 0))
        wallLeftPath.addLine(to: CGPoint(x: 0, y: 500))
        
        let wallLeft = SKShapeNode()
        wallLeft.path = wallLeftPath
        wallLeft.physicsBody = SKPhysicsBody(edgeLoopFrom: wallLeftPath)
        wallLeft.strokeColor = SKColor.clear
        wallLeft.lineWidth = 30
        wallLeft.name = "wallLeft"
        self.addChild(wallLeft)
        
        let wallRightPath:CGMutablePath = CGMutablePath()
        wallRightPath.move(to: CGPoint(x: 300, y: 0))
        wallRightPath.addLine(to: CGPoint(x: 300, y: 500))
        
        let wallRight = SKShapeNode()
        wallRight.path = wallRightPath
        wallRight.physicsBody = SKPhysicsBody(edgeLoopFrom: wallRightPath)
        wallRight.strokeColor = SKColor.clear
        wallRight.lineWidth = 30
        wallRight.name = "wallRight"
        self.addChild(wallRight)
        
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

let scene = SplashboardScene()
scene.scaleMode = .aspectFit
scene.size = CGSize(width: 1500, height: 2500)
scene.backgroundColor = SKColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
let view = SplashboardView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))


view.presentScene(scene)
PlaygroundPage.current.liveView = view

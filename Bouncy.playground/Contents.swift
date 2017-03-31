import PlaygroundSupport
import SpriteKit
import Darwin

class BiTreeView: SKView {

}

class BiTreeScene: SKScene {
    
    var nodeCount = 0
    
    var depth = 0
    
    func createBall(at point: CGPoint){
        
        nodeCount += 1;

        let node = SKShapeNode(circleOfRadius: 10 )
        node.position = CGPoint(x: point.x, y: point.y)
        node.strokeColor = SKColor.orange
        node.glowWidth = 0.1
        node.fillColor = SKColor(red: 0.88, green: 0.68, blue: 0.04, alpha: 1.00)
        node.name = "node\(nodeCount)"
        node.physicsBody = SKPhysicsBody(circleOfRadius: 9)
        node.physicsBody?.affectedByGravity = true
        node.physicsBody?.allowsRotation = true
        node.physicsBody?.isDynamic = true;
        node.physicsBody?.linearDamping = 0.00001
        node.physicsBody?.angularDamping = 0.75
        self.scene?.addChild(node)
        
        self.scene?.physicsWorld.gravity = CGVector(dx: 0.0, dy: -8.0)
        
    }
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let location = touch.location(in: self)
            createBall(at: location)
            
        }
    }
    let wwdcColors = [
            SKColor(red: 0.97, green: 0.97, blue:  0.97, alpha: 1.00),
            SKColor(red: 0.00, green: 0.66, blue:  0.58, alpha: 1.00),
            SKColor(red: 0.88, green: 0.68, blue:  0.04, alpha: 1.00),
            SKColor(red: 0.07, green: 0.69, blue:  0.80, alpha: 1.00),
            SKColor(red: 0.90, green: 0.31, blue:  0.27, alpha: 1.00),
            SKColor(red: 0.23, green: 0.36, blue:  0.44, alpha: 1.00)
    ]
    
    func addRandomObstacle(heightLevel: Int) {
        
        let randomXVal = Int(arc4random_uniform(260) + 20)
        var randomYVal = Int()
        let randomWidth = Int(arc4random_uniform(100) + 40)
        let randomHeight = Int(arc4random_uniform(30) + 10)
        switch heightLevel {
        case 0:
                randomYVal = Int(arc4random_uniform(50) + 40)
            case 1:
                randomYVal = Int(arc4random_uniform(40) + 25)
            default:
                randomYVal = Int(arc4random_uniform(12) + 10)
        
        }
        
        print(randomYVal)
        
        let randomSize = CGSize(width: randomWidth, height: randomHeight)
        
        let obstacle = SKShapeNode(rectOf: randomSize)
        obstacle.fillColor = wwdcColors[Int(arc4random_uniform(5) + 1)]
        obstacle.position = CGPoint(x: randomXVal, y: randomYVal * 5)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: randomSize)
        obstacle.physicsBody?.isDynamic = false
        self.addChild(obstacle)
        
        let randomDircection = Int(arc4random_uniform(1))
        let randomAngle = Int(arc4random_uniform(6))
        
        let rotateAction = SKAction.rotate(byAngle: CGFloat(randomAngle - 3), duration: 1)
        let repeatAction = SKAction.repeatForever(rotateAction)
        obstacle.run(repeatAction)
        
    }
    
    func addRandomFloor() {
        let floorPath = SKShapeNode(rectOf: CGSize(width: 180, height:50))
        floorPath.position=(CGPoint(x: 0, y: 0))
        floorPath.fillColor = wwdcColors[1]
        floorPath.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 180, height: 50))
        floorPath.physicsBody?.isDynamic = false
        let floorPath2 = SKShapeNode(rectOf: CGSize(width: 180, height:50))
        floorPath2.position=(CGPoint(x: 300, y: 0))
        floorPath2.fillColor = wwdcColors[1]
        floorPath2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 180, height: 50))
        floorPath2.physicsBody?.isDynamic = false
        self.addChild(floorPath)
        self.addChild(floorPath2)

    
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
        
        addRandomObstacle(heightLevel: 0)
        addRandomObstacle(heightLevel: 1)
        addRandomObstacle(heightLevel: 2)
        addRandomObstacle(heightLevel: 0)
        addRandomObstacle(heightLevel: 1)
        addRandomObstacle(heightLevel: 2)
        addRandomObstacle(heightLevel: 0)
        addRandomObstacle(heightLevel: 1)
        addRandomObstacle(heightLevel: 2)
        addRandomObstacle(heightLevel: 0)
        addRandomObstacle(heightLevel: 1)
        addRandomObstacle(heightLevel: 2)
        addRandomFloor()
        addSceneWalls()

        
    }
}


let scene = BiTreeScene()
scene.scaleMode = .aspectFit
scene.size = CGSize(width: 300, height: 500)
scene.backgroundColor = SKColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
let view = BiTreeView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
view.showsNodeCount = true
view.showsFPS = true
view.showsDrawCount = true


view.presentScene(scene)
PlaygroundPage.current.liveView = view


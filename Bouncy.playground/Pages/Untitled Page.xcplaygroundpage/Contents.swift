/*: Simon Narang's WWDC 2017 Application Playground
 
 # Bouncy
 
 */


import PlaygroundSupport
import SpriteKit
import Darwin

class BiTreeScene: SKScene {
    
    let wwdcColors = [
        SKColor(red: 0.97, green: 0.97, blue:  0.97, alpha: 1.00),
        SKColor(red: 0.88, green: 0.68, blue:  0.04, alpha: 1.00),
        SKColor(red: 0.00, green: 0.66, blue:  0.58, alpha: 1.00),
        SKColor(red: 0.07, green: 0.69, blue:  0.80, alpha: 1.00),
        SKColor(red: 0.90, green: 0.31, blue:  0.27, alpha: 1.00),
        SKColor(red: 0.23, green: 0.36, blue:  0.44, alpha: 1.00),
        SKColor(red: 0.91, green: 0.49, blue:  0.61, alpha: 1.00),
        SKColor(red: 0.55, green: 0.55, blue:  0.55, alpha: 1.00),
        SKColor(red: 0.94, green: 0.56, blue:  0.48, alpha: 1.00)
    ]
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.7)
        
        addRotatingObstacle(heightSection: 0, widthSection: 1)
        addRotatingObstacle(heightSection: 1, widthSection: 0)
        addRotatingObstacle(heightSection: 2, widthSection: 1)
        addRotatingObstacle(heightSection: 0, widthSection: 0)
        addRotatingObstacle(heightSection: 1, widthSection: 1)
        addRotatingObstacle(heightSection: 2, widthSection: 0)
        addRotatingObstacle(heightSection: 0, widthSection: 1)
        addRotatingObstacle(heightSection: 1, widthSection: 0)
        addRotatingObstacle(heightSection: 2, widthSection: 1)
        
        addFloor()
        addSceneWalls()
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            
            let location = touch.location(in: self)
            createBall(at: location)
            
        }
    }
    
    func createBall(at point: CGPoint) {
        
        if point.y > 350 {
            
            while childNode(withName: "ball") != nil {
                    
                    self.childNode(withName: "ball")?.removeFromParent()
            
            }
        
            let ball = SKShapeNode(circleOfRadius: 10 )
            ball.position = CGPoint(x: point.x, y: point.y)
            ball.strokeColor = SKColor.orange
            ball.glowWidth = 0.05
            ball.fillColor = wwdcColors[1]
            ball.name = "ball"
        
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 9)
            ball.physicsBody?.affectedByGravity = true
            ball.physicsBody?.allowsRotation = true
            ball.physicsBody?.isDynamic = true;
            ball.physicsBody?.linearDamping = 0.00001
            ball.physicsBody?.angularDamping = 0.75
        
            addChild(ball)
            
        } else {
            
            print("You need to drop the ball from higher up 😜")
        
        }
        
    }
    
    func addRotatingObstacle(heightSection: Int, widthSection: Int) {
        
        var randomXVal = Int()
        var randomYVal = Int()
        let randomWidth = Int(arc4random_uniform(100) + 40)
        let randomHeight = Int(arc4random_uniform(30) + 10)
        
        switch heightSection {
        case 0:
            randomYVal = Int(arc4random_uniform(50) + 50)
        case 1:
            randomYVal = Int(arc4random_uniform(40) + 30)
            default:
            randomYVal = Int(arc4random_uniform(3) + 10)
        }
        
        switch widthSection {
        case 0:
            randomXVal = Int(arc4random_uniform(100) + 10)
        default:
            randomXVal = Int(arc4random_uniform(125) + 150)
        }
        
        let randomSize = CGSize(width: randomWidth, height: randomHeight)
        
        let obstacle = SKShapeNode(rectOf: randomSize)
        obstacle.fillColor = wwdcColors[Int(arc4random_uniform(6) + 3)]
        obstacle.position = CGPoint(x: randomXVal, y: randomYVal * 5)

        obstacle.physicsBody = SKPhysicsBody(rectangleOf: randomSize)
        obstacle.physicsBody?.isDynamic = false
        self.addChild(obstacle)
        let randomAngle = Int(arc4random_uniform(6))
        var rotate = SKAction();
        
        if randomAngle == 0 {
            
             rotate = SKAction.rotate(byAngle: CGFloat(randomAngle - 3), duration: 2)
            
        } else {
            
            rotate = SKAction.rotate(byAngle: CGFloat(randomAngle), duration: 2)
        
        }
        
        
        let repeatRoatate = SKAction.repeatForever(rotate)
        obstacle.run(repeatRoatate)
        
    }
    
    func addFloor() {
        
        let leftFloorWidth = CGFloat(arc4random_uniform(135) + 90)
        
        let leftFloor = SKShapeNode(rectOf: CGSize(width: leftFloorWidth, height: 30))
        leftFloor.position = (CGPoint(x: 0, y: 0))
        leftFloor.fillColor = wwdcColors[2]
        leftFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leftFloorWidth, height: 30))
        leftFloor.physicsBody?.isDynamic = false
        
        let rightFloor = SKShapeNode(rectOf: CGSize(width: 250, height: 30))
        rightFloor.position=(CGPoint(x: 300, y: 0))
        rightFloor.fillColor = wwdcColors[2]
        rightFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 250, height: 30))
        rightFloor.physicsBody?.isDynamic = false
        
        self.addChild(leftFloor)
        self.addChild(rightFloor)
    
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
}


let scene = BiTreeScene()
scene.scaleMode = .aspectFit
scene.size = CGSize(width: 300, height: 500)
scene.backgroundColor = SKColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
let view = SKView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))


view.presentScene(scene)
PlaygroundPage.current.liveView = view
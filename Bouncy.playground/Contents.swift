// Simon Narang's WWDC 2017 Scholarship Application Playground
import PlaygroundSupport
import SpriteKit
import Darwin

class BouncyScene: SKScene {
    
    // Array of colors to match WWDC theme
    let wwdcColors = [
        SKColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00),
        SKColor(red: 0.88, green: 0.68, blue: 0.04, alpha: 1.00),
        SKColor(red: 0.00, green: 0.66, blue: 0.58, alpha: 1.00),
        SKColor(red: 0.07, green: 0.69, blue: 0.80, alpha: 1.00),
        SKColor(red: 0.90, green: 0.31, blue: 0.27, alpha: 1.00),
        SKColor(red: 0.23, green: 0.36, blue: 0.44, alpha: 1.00),
        SKColor(red: 0.91, green: 0.49, blue: 0.61, alpha: 1.00),
        SKColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1.00),
        SKColor(red: 0.94, green: 0.56, blue: 0.48, alpha: 1.00),
        SKColor(red: 0.83, green: 0.69, blue: 0.57, alpha: 1.00)
    ]
    
    // Set up scene
    override func didMove(to view: SKView) {
        
        print("Welcome 👋 Your goal is to drop a ball into the hole at the bottom. Good luck!")
        print("If it's too hard or too easy, rerun this playground to generate a new and unique scene!")
        
        /*
         Set gravity of scene to be -9.7
         Real-life gravity is -9.8 m/s^2
         However, movement looks more smooth with a slightly lower value
         */
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.7)
        
        // Add rotating obstacles
        addRotatingObstacle(heightSection: 0, widthSection: 1)
        addRotatingObstacle(heightSection: 1, widthSection: 0)
        addRotatingObstacle(heightSection: 2, widthSection: 1)
        addRotatingObstacle(heightSection: 0, widthSection: 0)
        addRotatingObstacle(heightSection: 1, widthSection: 1)
        addRotatingObstacle(heightSection: 2, widthSection: 0)
        addRotatingObstacle(heightSection: 0, widthSection: 1)
        addRotatingObstacle(heightSection: 1, widthSection: 0)
        addRotatingObstacle(heightSection: 2, widthSection: 1)
        
        // Add sliding obstacle
        addSlidingObstacle()
        
        // Add floor and scene walls
        addFloor()
        addSceneWalls()
        
        /* 
         Add background music
         I made this background music in Garage Band for iPad
        */
        addBackgroundMusic()
        
    }
    
    // Handle user tapping or clicking
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            
            let location = touch.location(in: self)
            dropBall(at: location)
            
        }
    }
    
    // I made this background music in Garage Band for iPad
    func addBackgroundMusic() {
        
        if let backgroundMusic = Bundle.main.url(forResource: "Background Music", withExtension: "m4a") {
            
            addChild(SKAudioNode(url: backgroundMusic))
            
        }
    
    }
    
    func dropBall(at point: CGPoint) {
        
        /* 
         In order to prevent cheating:
         Don't allow user to drop ball from height <= 350
         This means user cannot drop ball directly above hole
        */
        if point.y > 350 {
            
            /* 
             In order to prevent spamming:
             As soon as user taps screen, remove any balls that were previously dropped
             This preevents user from dropping an excess of balls:
             Filling the view with balls and placing unnecessary strain on the computer
            */
            while childNode(withName: "ball") != nil {
                
                self.childNode(withName: "ball")?.removeFromParent()
                
            }
            
            // Create node to represent ball
            let ball = SKShapeNode(circleOfRadius: 10 )
            ball.position = CGPoint(x: point.x, y: point.y)
            ball.strokeColor = SKColor.black
            ball.glowWidth = 0.05
            ball.fillColor = SKColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
            ball.name = "ball"
            
            // Handle ball's physicsBody
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 9)
            ball.physicsBody?.affectedByGravity = true
            ball.physicsBody?.allowsRotation = true
            ball.physicsBody?.isDynamic = true;
            ball.physicsBody?.linearDamping = 0.00001
            ball.physicsBody?.angularDamping = 0.75
            
            // Add ball to scene
            addChild(ball)
            
            /* 
             Whenever ball is dropped, play short sound:
             This sound is located at http://soundbible.com/1950-Button-Push.html and is available under the Attribution 3.0 license
            */
            ball.run(SKAction.playSoundFileNamed("Create Ball.mp3", waitForCompletion: false))
            
        } else {

            // If user tries to drop ball from too low, remind them to drop the ball from higher up
            print("Nice try! You need to drop the ball from higher up 😜")
            
        }
        
    }
    
    func addRotatingObstacle(heightSection: Int, widthSection: Int) {
        
        // Initiate and define variables that specify the size of a new obstacle
        let randomWidth = Int(arc4random_uniform(100) + 40)
        let randomHeight = Int(arc4random_uniform(30) + 10)
        let randomSize = CGSize(width: randomWidth, height: randomHeight)
        
        // Initiate variables that will specify the position of a new obstacle
        var randomXVal = Int()
        var randomYVal = Int()
        
        /* 
         The locations of the obstacles are only PARTIALLY randomized to ensure that they don't all cluster in one location:
         To control this randomization, an obstacle has a random position within a width-height section of the scene
        */
        switch heightSection {
        case 0:
            randomYVal = Int(arc4random_uniform(50) + 50)
        case 1:
            randomYVal = Int(arc4random_uniform(40) + 30)
        default:
            randomYVal = Int(arc4random_uniform(5) + 20)
        }
        
        switch widthSection {
        case 0:
            randomXVal = Int(arc4random_uniform(90) + 20)
        default:
            randomXVal = Int(arc4random_uniform(125) + 150)
        }
        
        // Create node to represent obstacle
        let obstacle = SKShapeNode(rectOf: randomSize)
        obstacle.fillColor = wwdcColors[Int(arc4random_uniform(7) + 3)]
        obstacle.position = CGPoint(x: randomXVal, y: randomYVal * 5)
        
        // Handle obstacle's physicsBody
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: randomSize)
        obstacle.physicsBody?.isDynamic = false
        
        // Add obstacle to scene
        self.addChild(obstacle)
        
        // Initiate variables that will define the speed and direction at which the obstacle will rotate in the scene
        let randomAngle = Int(arc4random_uniform(6))
        var rotate = SKAction();
        
        /*
         In order to prevent obstacles with a rotating value of 0 not move at all in the scene:
         Determine whether or not the obstacle's angle is 0 and:
         If it is, set it to -3
        */
        if randomAngle == 0 {
            
            rotate = SKAction.rotate(byAngle: -3, duration: 2)
            
        } else {
            
            rotate = SKAction.rotate(byAngle: CGFloat(randomAngle), duration: 2)
            
        }
        
        // Rotate obstacle indefinitely
        let repeatRoatate = SKAction.repeatForever(rotate)
        obstacle.run(repeatRoatate)
        
    }
    
    func addSlidingObstacle() {
        
        // Define variables that determine the size of obstacle
        let randomWidth = Int(arc4random_uniform(60) + 50)
        let randomHeight = Int(arc4random_uniform(20) + 10)
        let randomSize = CGSize(width: randomWidth, height: randomHeight)
        
        // Create node to represent obstacle
        let obstacle = SKShapeNode(rectOf: randomSize)
        obstacle.position = CGPoint(x: 0, y: 40)
        obstacle.fillColor = wwdcColors[Int(arc4random_uniform(7) + 3)]
        
        // Handle obstacle's physicsBody
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: randomSize)
        obstacle.physicsBody?.isDynamic = false
        
        // Add obstacle to scene
        addChild(obstacle)
        
        // Define variables containing the speed and direction at which the obstacle will move back and forth
        let moveRight = SKAction.moveBy(x: frame.size.width , y: 0, duration: 2)
        let moveLeft = SKAction.moveBy(x: -frame.size.width, y: 0, duration: 2)
        
        // Move obstacle back and forth along linear path indefinitely
        let moveBackAndForth = SKAction.repeatForever(SKAction.sequence([moveRight, moveLeft]))
        obstacle.run(moveBackAndForth)

    }
    
    func addFloor() {
        
        // Define variables that determine the size of left part of the floor
        let leftFloorWidth = CGFloat(arc4random_uniform(90) + 150)
        
        // Create node to represent left part of floor
        let leftFloor = SKShapeNode(rectOf: CGSize(width: leftFloorWidth, height: 30))
        leftFloor.position = (CGPoint(x: 0, y: 0))
        leftFloor.fillColor = wwdcColors[2]
        leftFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leftFloorWidth, height: 30))
        leftFloor.physicsBody?.isDynamic = false
        
        // Create node to represent right part of floor
        let rightFloor = SKShapeNode(rectOf: CGSize(width: 250, height: 30))
        rightFloor.position=(CGPoint(x: 300, y: 0))
        rightFloor.fillColor = wwdcColors[2]
        rightFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 250, height: 30))
        rightFloor.physicsBody?.isDynamic = false
        
        // Add floor to scene
        self.addChild(leftFloor)
        self.addChild(rightFloor)
        
        // Define variables containing the speed and direction at which the floor moves back and forth
        let moveLeft = SKAction.moveBy(x: CGFloat(-50), y: 0, duration: 2)
        let moveRight = SKAction.moveBy(x: CGFloat(50), y: 0, duration: 2)
        
        // Move floor back and forth along linear path indefinitely
        let moveBackAndForth = SKAction.repeatForever(SKAction.sequence([moveLeft, moveRight]))
        leftFloor.run(moveBackAndForth)
        rightFloor.run(moveBackAndForth)
        
    }
    
    /*
     In order to prevent ball from falling of the scene:
     Add invisible "walls" that a ball can bounce off
    */
    func addSceneWalls() {
        
        // Create path for left wall node to be drawn off
        let wallLeftPath:CGMutablePath = CGMutablePath()
        wallLeftPath.move(to: CGPoint(x: 0, y: 0))
        wallLeftPath.addLine(to: CGPoint(x: 0, y: 500))
        
        // Create node to represent left wall
        let wallLeft = SKShapeNode()
        wallLeft.path = wallLeftPath
        wallLeft.physicsBody = SKPhysicsBody(edgeLoopFrom: wallLeftPath)
        wallLeft.strokeColor = SKColor.clear
        wallLeft.lineWidth = 30
        wallLeft.name = "wallLeft"
        self.addChild(wallLeft)
        
        // Create path for left wall node to be drawn off
        let wallRightPath:CGMutablePath = CGMutablePath()
        wallRightPath.move(to: CGPoint(x: 300, y: 0))
        wallRightPath.addLine(to: CGPoint(x: 300, y: 500))
        
        // Create node to represent left wall
        let wallRight = SKShapeNode()
        wallRight.path = wallRightPath
        wallRight.physicsBody = SKPhysicsBody(edgeLoopFrom: wallRightPath)
        wallRight.strokeColor = SKColor.clear
        wallRight.lineWidth = 30
        wallRight.name = "wallRight"
        self.addChild(wallRight)
        
    }
}

// Initialize scene
let scene = BouncyScene()

// Set up scene
scene.scaleMode = .aspectFit
scene.size = CGSize(width: 300, height: 500)
scene.backgroundColor = SKColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)

// Initialize view
let view = SKView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
view.presentScene(scene)

// Display scene to user
PlaygroundPage.current.liveView = view
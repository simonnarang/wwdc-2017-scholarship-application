/*
 Splashboard by William Wang for WWDC 2017
*/

import PlaygroundSupport
import SpriteKit
import Darwin

class SplashboardScene: SKScene {
    
    var balloonSize = 100;
    
    //Determine location of tap
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
            let location = touch.location(in: self)
            createPaintball(at: location)
        }
    }
    
    //Create paintball
    func createPaintball(at point: CGPoint){
        
        let paintColors = [
            SKColor(red: 0.02, green: 0.44, blue:  1.00, alpha: 1.00),
            SKColor(red: 1.00, green: 0.00, blue:  0.00, alpha: 1.00),
            SKColor(red: 0.00, green: 0.77, blue:  0.44, alpha: 1.00),
            SKColor(red: 0.44, green: 0.00, blue:  0.84, alpha: 1.00),
            SKColor(red: 0.65, green: 0.53, blue:  0.29, alpha: 1.00),
            SKColor(red: 0.00, green: 1.00, blue:  0.80, alpha: 1.00)
        ]
        
        //Randomly pick color
        let colorNumber = Int(arc4random_uniform(6))
        let color = paintColors[colorNumber]
        
        //Create paintball sprite
        let paintball = SKShapeNode(circleOfRadius: CGFloat(balloonSize) )
        paintball.position = CGPoint(x:point.x, y: point.y)
        paintball.glowWidth = 2.0
        paintball.fillColor = color
        self.scene?.addChild(paintball)
        
        //Make paintball appear as 3 dimensional
        let moveNodeUp = SKAction.scale(by: CGFloat(0.4), duration: 0.2)
        let moveNodeDown = SKAction.moveBy(x: CGFloat(0), y: CGFloat(-50), duration: 0.2)
        
        //Create paint splatter
        let imageName = String(Int(colorNumber + 1))
        let imageSize = Int(arc4random_uniform(5) + 3) * 50
        let imageNode = SKSpriteNode(imageNamed: imageName)
        imageNode.position = CGPoint(x:point.x, y: point.y)
        imageNode.size = CGSize(width: imageSize, height: imageSize)
        imageNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: imageSize, height: imageSize))
        imageNode.physicsBody?.affectedByGravity = false
        imageNode.physicsBody?.isDynamic = false
        imageNode.physicsBody?.mass = 5
        let sound = SKAction.playSoundFileNamed("splash.mp3", waitForCompletion: false)
        
        paintball.run(moveNodeUp)
        paintball.run(moveNodeDown) { () -> Void in
            paintball.removeFromParent()
            
            self.scene?.addChild(imageNode)
            paintball.run(sound)
            
        }
    }
    
    override func didMove(to view: SKView) {
        
        addPenguin()
        addSceneWalls()
        let label = SKLabelNode(fontNamed: "Arial")
        label.text = "splashboard"
        label.fontColor = SKColor.black
        label.fontSize = 60
        label.position = CGPoint(x:1300,y:50)
        self.addChild(label)
        let WWDClogo = SKSpriteNode(imageNamed: "Logo")
        WWDClogo.size = CGSize(width: 250, height: 50)
        WWDClogo.position = CGPoint(x
            : 200, y: 100)
        WWDClogo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        WWDClogo.physicsBody?.isDynamic = false
        self.addChild(WWDClogo)
    }
    
    func addPenguin(){
        // Functions to move the Penguin
        let moveRightUp = SKAction.moveBy(x: frame.size.width , y: 300, duration: 2)
        
        let moveLeftUp = SKAction.moveBy(x: -frame.size.width, y: 300, duration: 2)
        
        let moveBackAndForthUp = SKAction.sequence([moveRightUp, moveLeftUp])
        
        let moveFixedAmountUp = SKAction.repeat(moveBackAndForthUp, count: 4)
        
        let moveRightDown = SKAction.moveBy(x: frame.size.width , y: -300, duration: 2)
    
        let moveLeftDown = SKAction.moveBy(x: -frame.size.width, y: -300, duration: 2)
        
        let moveBackAndForthDown = SKAction.sequence([moveRightDown, moveLeftDown])
        
        let moveFixedAmountDown = SKAction.repeat(moveBackAndForthDown, count: 4)
        
        let movePenguin = SKAction.repeatForever(SKAction.sequence([moveFixedAmountUp, moveFixedAmountDown]))
        //Create Penguin Sprite
        let penguin = SKSpriteNode(imageNamed: "penguin")
        penguin.size = CGSize(width: 200, height: 200)
        penguin.position = CGPoint(x: 500, y:500)
        penguin.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 200))
        penguin.physicsBody?.affectedByGravity = false
        penguin.run(movePenguin)
        self.scene?.addChild(penguin)
    }
    //Create walls so the penguin doesn't leave the screen
    func addSceneWalls() {
        
        let leftWall = SKShapeNode(rectOf: CGSize(width: 50, height: 2500))
        leftWall.position = (CGPoint(x: 0, y: 1250))
        leftWall.fillColor = SKColor.clear
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 2500))
        leftWall.physicsBody?.affectedByGravity = false
        leftWall.physicsBody?.isDynamic = false
        self.scene?.addChild(leftWall)
        
        let rightWall = SKShapeNode(rectOf: CGSize(width: 50, height: 2500))
        rightWall.position = (CGPoint(x: 1500, y: 1250))
        rightWall.fillColor = SKColor.clear
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 2500))
        rightWall.physicsBody?.affectedByGravity = false
        rightWall.physicsBody?.isDynamic = false
        self.scene?.addChild(rightWall)
        
        let bottomWall = SKShapeNode(rectOf: CGSize(width: 1500, height: 50))
        bottomWall.position = (CGPoint(x: 750, y: 0))
        bottomWall.fillColor = SKColor.clear
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1500, height: 50))
        bottomWall.physicsBody?.affectedByGravity = false
        bottomWall.physicsBody?.isDynamic = false
        self.scene?.addChild(bottomWall)
        
        let topWall = SKShapeNode(rectOf: CGSize(width: 1500, height: 50))
        topWall.position = (CGPoint(x: 750, y: 2500))
        topWall.fillColor = SKColor.clear
        topWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1500, height: 50))
        topWall.physicsBody?.affectedByGravity = false
        topWall.physicsBody?.isDynamic = false
        self.scene?.addChild(topWall)
        
    }
    
}
print("Hello and welcome to Splashboard Playground!\nHere you can play with the penguin by sending paint balloons!\nThe finished 'art' has endless possibilities")
let scene = SplashboardScene()
scene.scaleMode = .aspectFit
scene.size = CGSize(width: 1500, height: 2500)
scene.backgroundColor = SKColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
let view = SKView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
view.presentScene(scene)
PlaygroundPage.current.liveView = view

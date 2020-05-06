import Foundation
import SpriteKit
import AppKit

public class WelcomeScene: SKScene {
    
    private let scissors = SKLabelNode(text: "✂️")
    private let topScreen = SKSpriteNode(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), size: CGSize(width: UIConfig.backgroundSize.width, height: UIConfig.backgroundSize.height / 2))
    private let buttomScreen = SKSpriteNode(color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), size: CGSize(width: UIConfig.backgroundSize.width, height:  UIConfig.backgroundSize.height / 2))
    private let dottedLine = SKSpriteNode(imageNamed: "dottedLine")
    private let cutIntro = SKLabelNode(text: "Pick up the scissors. Cut along the dotted line.")
    
    private let startInfo   = SKLabelNode(text: "ENJOY THE PAPER CUTTING ART")
    
    public let nextScene : SKScene = PaperCutScene()
    
    private var drag = false
    private var scissorsFixes = false
    private var welcomeFinished = false
    
    public override func didMove(to view: SKView) {
        // set the basic area size and position
        self.backgroundColor = .white
        self.anchorPoint = UIConfig.backgroundPosition
        self.size = UIConfig.backgroundSize
        
        loadTheNodes()
    }
    
    private func loadTheNodes() {

        startInfo.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 2)
        startInfo.fontSize = 30
        startInfo.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        startInfo.name = "startInfo"
        addChild(startInfo)
        
        topScreen.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 3 / 4)
        topScreen.name = "topScreen"
        addChild(topScreen)
        
        buttomScreen.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 1 / 4)
        buttomScreen.name = "buttomScrenn"
        addChild(buttomScreen)
        
        dottedLine.position = CGPoint(x: UIConfig.backgroundSize.width / 2, y: UIConfig.backgroundSize.height / 2)
        dottedLine.size = CGSize(width: UIConfig.backgroundSize.width, height:  10)
        addChild(dottedLine)
        
        let fadeInOut = SKAction.sequence([.fadeIn(withDuration: 2.0), .fadeOut(withDuration: 2.0)])
        cutIntro.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 1 / 7)
        cutIntro.fontSize = CGFloat(20)
        cutIntro.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cutIntro.name = "cutIntro"
        cutIntro.run(.repeatForever(fadeInOut))
        addChild(cutIntro)
        
        scissors.position = CGPoint(x: UIConfig.backgroundSize.width / 2, y: UIConfig.backgroundSize.height * 1 / 4)
        scissors.fontSize = 50
        scissors.zRotation = .pi / 2
        scissors.name = "scissors"
        addChild(scissors)
        
        
    }
    
    private func disLoadNodes() {
        scissors.isHidden = true
        dottedLine.isHidden = true
        cutIntro.isHidden = true
        
        let view = self.view
        
        let waitTime = SKAction.wait(forDuration: 5)
        let nextAction = SKAction.run {
            view?.presentScene(self.nextScene)
        }
        self.run(SKAction.sequence([waitTime, nextAction]))
    }
    
    public override func mouseDown(with event: NSEvent) {
        if abs(event.location(in: self).x - scissors.position.x) < 45,
            abs(event.location(in: self).y - scissors.position.y) < 45 {
            drag = true
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        if scissorsFixes == true {
            scissors.position = CGPoint(x: 45, y: UIConfig.backgroundSize.height / 2)
        }
        drag = false
    }
    
    public override func mouseDragged(with event: NSEvent) {
        guard drag else {
            return
        }
        
        let position = event.location(in: self)
        
        if scissorsFixes == false {
            let position = event.location(in: self)
            scissors.position = CGPoint(x: position.x, y:  position.y)
            
            if abs(position.y - UIConfig.backgroundSize.height / 2) < 55 {
                scissors.position = CGPoint(x: 45, y: UIConfig.backgroundSize.height / 2)
                scissors.position = CGPoint(x: 45, y: UIConfig.backgroundSize.height / 2)
                scissorsFixes = true
                drag = false
            }
        }
        else {
            scissors.position = CGPoint(x: position.x, y: UIConfig.backgroundSize.height / 2)
            
            if abs(position.x - UIConfig.backgroundSize.width) < 45 {
                let topVector = CGVector(dx: 0, dy: CGFloat(100000))
                let buttomVector = CGVector(dx: 0, dy: CGFloat(-100000))
                
                topScreen.physicsBody = SKPhysicsBody(rectangleOf: self.topScreen.frame.size)
                topScreen.physicsBody?.isDynamic = true
                topScreen.physicsBody?.affectedByGravity = false
                topScreen.physicsBody?.applyForce(topVector, at: CGPoint(x: topScreen.frame.size.width, y: UIConfig.backgroundSize.height / 2))
                
                buttomScreen.physicsBody = SKPhysicsBody(rectangleOf: self.buttomScreen.frame.size)
                buttomScreen.physicsBody?.isDynamic = true
                buttomScreen.physicsBody?.affectedByGravity = false
                buttomScreen.physicsBody?.applyForce(buttomVector, at: CGPoint(x: buttomScreen.frame.size.width, y: UIConfig.backgroundSize.height / 2))
                
                self.disLoadNodes()

            }
        }
        


    }
}

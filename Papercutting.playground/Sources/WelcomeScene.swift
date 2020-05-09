import Foundation
import SpriteKit
import AppKit

public class WelcomeScene: SKScene {
    
    private let instruct        = SKLabelNode(text: "Try to fold and cut the paper. You can unfold the paper by pressing the DONE button on the touch bar, or pressing the S key on the keyboard to see the final work. In the first two levels , you need to cut out a circle and a star, and when pressing DONE, you will get a rating for your work. You can click H for some tips. When N appears, you can click it to go to the next level.")
    private let instruct2       = SKLabelNode(text: "Click any place to start the game.")
    private let instruct3       = SKLabelNode(text: "Papercutting")
    private let instructBG      = SKSpriteNode(imageNamed: "insbg.jpg", normalMapped: false)
    
    private let scissors        = SKLabelNode(text: "✂️")
    private let topScreen       = SKSpriteNode(imageNamed: "bgu.jpg", normalMapped: false)
    private let buttomScreen    = SKSpriteNode(imageNamed: "bgd.jpg", normalMapped: false)
    private let cutIntro        = SKLabelNode(text: "Pick up the scissors. Cut along the dotted line.")
    
    private let fakePaper       = SKSpriteNode(color: UIConfig.paperColor , size: UIConfig.paperSize)
    private var fackePaperCutBoarder             = SKShapeNode(rectOf: UIConfig.paperCutBoarderSize, cornerRadius: 5)
    private var fakebg                           = SKSpriteNode(imageNamed: "bg.jpg", normalMapped: false)

        
    public let nextScene        = PaperCutScene()
    public var level            = 1
    
    private var drag            = false
    private var scissorsFixes   = false
    
    public override func didMove(to view: SKView) {
        // set the basic area size and position
        self.backgroundColor = UIConfig.paperCutBackgroundColor
        self.anchorPoint = UIConfig.backgroundPosition
        self.size = UIConfig.backgroundSize
        self.view?.layer?.cornerRadius = 5
        loadTheNodes()
    }
    
    public func loadTheNodes() {
        
        fakebg.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 2)
        fakebg.scale(to: CGSize(width: UIConfig.backgroundSize.width, height: UIConfig.backgroundSize.height))
        fakebg.name = "bg"
        addChild(fakebg)
        
        fackePaperCutBoarder.position = CGPoint(x: UIConfig.backgroundSize.width / 2,
                                           y: UIConfig.backgroundSize.height - (UIConfig.backgroundSize.height - UIConfig.paperSize.height) / 5 - UIConfig.paperSize.height / 2)
        fackePaperCutBoarder.fillColor = UIConfig.paperCutBoardBackgroudColor
        addChild(fackePaperCutBoarder)
        
        fakePaper.position = CGPoint(x: UIConfig.backgroundSize.width / 2,
                                     y: UIConfig.backgroundSize.height - (UIConfig.backgroundSize.height - UIConfig.paperSize.height) / 5 - UIConfig.paperSize.height / 2)
        addChild(fakePaper)
                
        topScreen.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 3 / 4)
        topScreen.scale(to: CGSize(width: UIConfig.backgroundSize.width, height: UIConfig.backgroundSize.height / 2))
        topScreen.name = "topScreen"
        addChild(topScreen)
        
        buttomScreen.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 1 / 4)
        buttomScreen.scale(to: CGSize(width: UIConfig.backgroundSize.width, height: UIConfig.backgroundSize.height / 2))
        buttomScreen.name = "buttomScrenn"
        addChild(buttomScreen)
        
        let fadeInOut = SKAction.sequence([.fadeIn(withDuration: 2.0), .fadeOut(withDuration: 2.0)])
        cutIntro.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 1 / 8)
        cutIntro.fontSize = CGFloat(20)
        cutIntro.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cutIntro.name = "cutIntro"
        cutIntro.fontName = "Futura Medium Italic"
        cutIntro.run(.repeatForever(fadeInOut))
        addChild(cutIntro)
        
        scissors.position = CGPoint(x: UIConfig.backgroundSize.width * 2 / 3, y: UIConfig.backgroundSize.height * 0.28 )
        scissors.fontSize = 50
        scissors.zRotation = .pi / 2
        scissors.name = "scissors"
        addChild(scissors)
        
        instructBG.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 2)
        instructBG.scale(to: CGSize(width: UIConfig.backgroundSize.width, height: UIConfig.backgroundSize.height))
        addChild(instructBG)
        
        instruct.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 4)
        instruct.fontName = "Futura Medium Italic"
        instruct.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        instruct.fontSize = CGFloat(20)
        instruct.preferredMaxLayoutWidth = CGFloat(UIConfig.backgroundSize.width * 3 / 4)
        instruct.numberOfLines = 5
        addChild(instruct)
        
        instruct2.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 8)
        instruct2.fontName = "Futura Medium Italic"
        instruct2.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        instruct2.fontSize = CGFloat(25)
        instruct2.run(.repeatForever(fadeInOut))
        addChild(instruct2)
        
        instruct3.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 0.80)
        instruct3.fontName = "Futura Medium Italic"
        instruct3.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        instruct3.fontSize = CGFloat(40)
        addChild(instruct3)
    }
    
    private func disLoadNodes() {
        scissors.isHidden = true
        cutIntro.isHidden = true
        
        nextScene.level = level
        
        let view = self.view
        
        let waitTime = SKAction.wait(forDuration: 1)
        let nextAction = SKAction.run {
            self.removeAllChildren()
            view?.presentScene(self.nextScene)
        }
        self.run(SKAction.sequence([waitTime, nextAction]))
    }
    

    public override func mouseDown(with event: NSEvent) {
        if instructBG.isHidden {
            if abs(event.location(in: self).x - scissors.position.x) < 45,
                abs(event.location(in: self).y - scissors.position.y) < 45 {
                drag = true
            }
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        if instructBG.isHidden {
            if scissorsFixes == true {
                scissors.position = CGPoint(x: 45, y: UIConfig.backgroundSize.height / 2)
            }
            drag = false
        } else {
            instructBG.isHidden = true
            instruct.isHidden = true
            instruct2.isHidden = true
            instruct3.isHidden = true
        }
    }
    
    public override func mouseDragged(with event: NSEvent) {
        guard drag else {
            return
        }
        
        let position = event.location(in: self)
        
        if scissorsFixes == false {
            let position = event.location(in: self)
            scissors.position = CGPoint(x: position.x, y:  position.y)
            
            if abs(position.y - UIConfig.backgroundSize.height / 2) < 30 {
                scissors.position = CGPoint(x: 45, y: UIConfig.backgroundSize.height / 2)
                scissors.position = CGPoint(x: 45, y: UIConfig.backgroundSize.height / 2)
                scissorsFixes = true
                drag = false
            }
        }
        else {
            scissors.position = CGPoint(x: position.x, y: UIConfig.backgroundSize.height / 2)
            
            if abs(position.x - UIConfig.backgroundSize.width) < 40 {
                let topVector = CGVector(dx: 0, dy: CGFloat(300000))
                let buttomVector = CGVector(dx: 0, dy: CGFloat(-300000))
                
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

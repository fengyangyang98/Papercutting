import Foundation
import SpriteKit
import AVFoundation

public class PaperCutScene : SKScene{
    
    private var compareImageName : String    = "circle"
    private var musicIsPlaying              = true;
    private var isPresent                   = false;
    private var scoreBoard                  = SKLabelNode(text: "Score:")
    private var finishBoard                 = SKLabelNode(text: "YOU DID IT, SHARE YOUR ART WITH YOUR FRIENDS.")
    private var paperCutBoarder             = SKShapeNode(rectOf: UIConfig.paperCutBoarderSize, cornerRadius: 5)
    private var bg                          = SKSpriteNode(imageNamed: "bg.jpg", normalMapped: false)
    
    // for hints
    private var hintButton                  = SKSpriteNode(imageNamed: "hint.png", normalMapped: false)
    private var hintBG                      = SKSpriteNode(imageNamed: "bg.jpg", normalMapped: false)
    private var starHint                    = SKSpriteNode(imageNamed: "hint-start.png", normalMapped: false)
    private var circleHint                  = SKSpriteNode(imageNamed: "hint-circle.png", normalMapped: false)
    private var hintTitle                   = SKLabelNode(text: "Papercutting Hint")
    private var goBack                      = SKLabelNode(text: "Click any place to go back to the game.")
    private var noHintInfo                  = SKLabelNode(text: "You finished all the challenges. You can create your own papercutting art works as you like.")
    
    // for level
    private var nextButton                  = SKSpriteNode(imageNamed: "next.png", normalMapped: false)
    public var level                        = 1
    private var tryTime                     = 0
    
    
    private var player : AVAudioPlayer      = {
        let backgroundMusicURL =  Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a")!
        let player = try! AVAudioPlayer(contentsOf: backgroundMusicURL)
        return player
    }()
    
    // the paper cut
    private var paperCutBoard : PaperCutBoard = {
        let point1 = CGPoint(x: 0, y: UIConfig.paperSize.height)
        let point2 = CGPoint(x: UIConfig.paperSize.width, y: UIConfig.paperSize.height)
        let point3 = CGPoint(x: UIConfig.paperSize.width, y: 0)
        let point4 = CGPoint(x: 0, y: 0)
        
        let board = PaperCutBoard(pointShape: [point1, point2, point3, point4])
        board.wantsLayer = true
        board.translatesAutoresizingMaskIntoConstraints = false
        board.layer?.backgroundColor = UIConfig.paperColor.cgColor
        return board
    }()
    
    public func setCompareImageName(level: Int)
    {
        self.level = level
    }
    
    public override func didMove(to view: SKView) {
        self.backgroundColor = UIConfig.paperCutBackgroundColor
        self.anchorPoint = UIConfig.backgroundPosition
        self.size = UIConfig.backgroundSize
        self.view?.layer?.cornerRadius = 5
        loadNodes()
    }

    private func loadNodes() {
        guard let view = self.view else {
            print("loadNodes nil")
            return
        }
        
        playBackgroundMusic()
        
        bg.removeFromParent()
        bg.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 2)
        bg.scale(to: CGSize(width: UIConfig.backgroundSize.width, height: UIConfig.backgroundSize.height))
        bg.name = "bg"
        addChild(bg)
        
        paperCutBoarder.removeFromParent()
        paperCutBoarder.position = CGPoint(x: UIConfig.backgroundSize.width / 2,
                                           y: UIConfig.backgroundSize.height - (UIConfig.backgroundSize.height - UIConfig.paperSize.height) / 5 - UIConfig.paperSize.height / 2)
        paperCutBoarder.fillColor = UIConfig.paperCutBoardBackgroudColor
        addChild(paperCutBoarder)
        
        view.addSubview(self.paperCutBoard)
        self.paperCutBoard.heightAnchor.constraint(equalToConstant: UIConfig.paperSize.height).isActive = true
        self.paperCutBoard.widthAnchor.constraint(equalToConstant: UIConfig.paperSize.width).isActive = true
        self.paperCutBoard.topAnchor.constraint(equalTo: view.topAnchor,
                                                constant: (UIConfig.backgroundSize.height - UIConfig.paperSize.height) / 5).isActive = true
        self.paperCutBoard.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: (UIConfig.backgroundSize.width - UIConfig.paperSize.width) / 2).isActive = true
        
        
        finishBoard.removeFromParent()
        finishBoard.text = ""
        finishBoard.fontSize =  CGFloat(20)
        finishBoard.fontColor = #colorLiteral(red: 0.4375018775, green: 0.5443386436, blue: 0.6065829396, alpha: 1)
        finishBoard.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 11)
        finishBoard.fontName = "Futura Medium Italic"
        finishBoard.name = "finishBoard"
        addChild(finishBoard)
        
        hintButton.removeFromParent()
        hintButton.position = UIConfig.hintButtonPosition
        hintButton.scale(to: UIConfig.hintButtonSize)
        addChild(hintButton)
        
        nextButton.removeFromParent()
        nextButton.position = UIConfig.nextButtonPosition
        nextButton.scale(to: UIConfig.nextButtonSize)
        nextButton.isHidden = true
        addChild(nextButton)
        
        scoreBoard.removeFromParent()
        scoreBoard.text = ""
        let presentAction = SKAction.run {
            SKAction.wait(forDuration: 2)
            self.scoreBoard.text = "Level-\(self.level): Cut a \"\(self.compareImageName)\"."
            self.scoreBoard.fontSize = CGFloat(20)
            self.finishBoard.text = "Push DOWN, get the rating."
            self.hintButton.isHidden = false
        }
        let fadeInOut = SKAction.sequence([.fadeOut(withDuration: 0.1), presentAction, .fadeIn(withDuration: 0.3)])
        scoreBoard.fontColor = #colorLiteral(red: 0.4375018775, green: 0.5443386436, blue: 0.6065829396, alpha: 1)
        scoreBoard.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 0.15)
        scoreBoard.name = "scoreboard"
        scoreBoard.fontName = "Futura Medium Italic"
        addChild(scoreBoard)
        scoreBoard.run(.`repeat`(fadeInOut, count: 1))
        
        hintBG.removeFromParent()
        hintBG.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 2)
        hintBG.scale(to: CGSize(width: UIConfig.backgroundSize.width, height: UIConfig.backgroundSize.height))
        hintBG.isHidden = true
        addChild(hintBG)
        
        hintTitle.removeFromParent()
        hintTitle.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 0.75)
        hintTitle.fontName = "Futura Medium Italic"
        hintTitle.fontColor = #colorLiteral(red: 0.4375018775, green: 0.5443386436, blue: 0.6065829396, alpha: 1)
        hintTitle.isHidden = true
        hintTitle.fontSize = CGFloat(40)
        hintTitle.name = "hintTitle"
        addChild(hintTitle)
        
        let goBackFadeInOut = SKAction.sequence([.fadeOut(withDuration: 2), .fadeIn(withDuration: 2)])
        goBack.removeFromParent()
        goBack.fontSize = CGFloat(20)
        goBack.fontColor = #colorLiteral(red: 0.4375018775, green: 0.5443386436, blue: 0.6065829396, alpha: 1)
        goBack.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 5)
        goBack.name = "goBack"
        goBack.fontName = "Futura Medium Italic"
        goBack.isHidden = true
        addChild(goBack)
        goBack.run(.repeatForever(goBackFadeInOut))
        
        // add hint
        starHint.removeFromParent()
        starHint.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 2)
        starHint.scale(to: UIConfig.hintImageScae)
        starHint.name = "starHint"
        starHint.isHidden = true
        addChild(starHint)
        
        circleHint.removeFromParent()
        circleHint.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 2)
        circleHint.scale(to: UIConfig.hintImageScae)
        circleHint.name = "starHint"
        circleHint.isHidden = true
        addChild(circleHint)
        
        noHintInfo.removeFromParent()
        noHintInfo.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 2)
        noHintInfo.fontColor = #colorLiteral(red: 0.4392156863, green: 0.5450980392, blue: 0.6078431373, alpha: 1)
        noHintInfo.fontName = "Futura Medium Italic"
        noHintInfo.fontSize = CGFloat(20)
        noHintInfo.preferredMaxLayoutWidth = CGFloat(UIConfig.backgroundSize.width * 3 / 4)
        noHintInfo.numberOfLines = 5
    
        noHintInfo.isHidden = true
        addChild(noHintInfo)
        
        isPresent = true

    }
    
    private func nextLevel() {
        level += 1
        switch level {
        case 1:
            compareImageName = "circle"
            break
        case 2:
            compareImageName = "start"
            break
        default:
            compareImageName = ""
            break
        }
        let presentAction = SKAction.run {
            SKAction.wait(forDuration: 2)
            if(self.level <= 2) {
                self.scoreBoard.fontSize = CGFloat(20)
                self.scoreBoard.text = "Level-\(self.level): Cut a \"\(self.compareImageName)\"."
                self.finishBoard.fontSize =  CGFloat(20)
                self.finishBoard.text = "Push DOWN, get the rating."
            } else {
                self.scoreBoard.fontSize = CGFloat(20)
                self.scoreBoard.text = "Level-\(self.level)"
                self.finishBoard.fontSize =  CGFloat(20)
                self.finishBoard.text = "Create your own papercutting art works."
            }
            self.hintButton.isHidden = false
        }
        tryTime = 0
        clear()
        let fadeInOut = SKAction.sequence([.fadeOut(withDuration: 0.1), presentAction, .fadeIn(withDuration: 0.3)])
        scoreBoard.run(.`repeat`(fadeInOut, count: 1))
    }
    
    private func showHints() {
        // set Image
        paperCutBoard.isHidden = true
        hintBG.isHidden = false
        hintTitle.isHidden = false
        goBack.isHidden = false
        switch level {
        case 2:
            starHint.isHidden = false
            break
        case 1:
            circleHint.isHidden = false
            break
        default:
            noHintInfo.isHidden = false
            break
        }
    }
    
    private func hideHints() {
        paperCutBoard.isHidden = false
        hintBG.isHidden = true
        hintTitle.isHidden = true
        goBack.isHidden = true
        
        starHint.isHidden = true
        circleHint.isHidden = true
        noHintInfo.isHidden = true
    }

    public override func mouseUp(with event: NSEvent) {
        if hintBG.isHidden {
            let position = event.location(in: self)
            if abs(position.y - UIConfig.hintButtonPosition.y ) <= UIConfig.hintButtonSize.height / 2 &&
               abs(position.x - UIConfig.hintButtonPosition.x ) <= UIConfig.hintButtonSize.width / 2 {
                showHints()
            }
            
            if nextButton.isHidden == false &&
               abs(position.y - UIConfig.nextButtonPosition.y ) <= UIConfig.nextButtonSize.height / 2 &&
               abs(position.x - UIConfig.nextButtonPosition.x ) <= UIConfig.nextButtonSize.width / 2 {
                nextLevel()
                nextButton.isHidden = true
            }
            
        } else {
            hideHints()
        }
    }
        
    
    // MARK: KEY
    override public func keyDown(with event: NSEvent) {
        switch event.keyCode {
            case 4: // H
                horizonFold()
                break;
            case 9: // V
                verticalFold()
                break
            case 37: // L
                diagonalLeftFold()
                break
            case 15: // R
                diagonalRightFold()
                break
            case 34: // I
                carve(carveWay: CarveWay.yin)
                break
            case 0: // A
                carve(carveWay: CarveWay.yang)
                break
            case 6: // 6
                undo()
                break
            case 17: // T
                clear()
                break
            case 1: // S
                show()
                break
            case 46: // M
                let _ = playOrStopBGM()
                break
            default:
                break
        }
    }
    
    // MARK: TOOLS
    
    private func playBackgroundMusic() {
        player.numberOfLoops = -1
        player.volume = 0.05
        player.prepareToPlay()
        player.play()
    }
    
    private func pauseBackgroundMusic() {
        player.pause()
    }
    
    public func playOrStopBGM() -> Bool {
        if musicIsPlaying {
            pauseBackgroundMusic()
            musicIsPlaying = false
        } else {
            playBackgroundMusic()
            musicIsPlaying = true
        }
        
        return musicIsPlaying
    }
    
    public func verticalFold() {
        paperCutBoard.verticalFold()
    }
    
    public func horizonFold() {
        paperCutBoard.horizonFold()
    }
    
    public func diagonalLeftFold() {
        paperCutBoard.diagonalLeftFold()
    }
    
    public func diagonalRightFold() {
        paperCutBoard.diagonalRightFold()
    }
    
    public func carve(carveWay : CarveWay) {
        paperCutBoard.carve(carveWay: carveWay)
        
    }
    
    public func paperColor(color : CGColor) {
        paperCutBoard.paperColor(color: color)
        self.view?.layer?.borderColor = color
    }
    
    public func clear() {
        paperCutBoard.clear()
    }
    
    public func show() {
        if isPresent == false {
            return
        }
        
        paperCutBoard.show()
        let rank = compare()
//        scoreBoard.text =
//        scoreBoard.fontSize =  CGFloat(45)
        finishBoard.fontSize = CGFloat(30)
        if rank == "🌟🌟🌟" {
            if level <= 2 {
                nextButton.isHidden = false
            }
            finishBoard.text = "\(rank)"
            
            finishBoard.isHidden = false
        } else if rank == "🌟🌟"{
            if level <= 2 {
                nextButton.isHidden = false
            }
            finishBoard.text = "\(rank)"
            finishBoard.isHidden = false
        } else {
            tryTime += 1
            if tryTime >= 3 {
                nextButton.isHidden = false
            }
            finishBoard.text = "\(rank)"
            finishBoard.isHidden = false
        }
 
    }
    
    public func undo() {
        paperCutBoard.undo()
    }
    
    public func compare() -> String {
        guard let target = NSImage(named: compareImageName) else {
            return "🌟🌟🌟"
        }
        let distance = paperCutBoard.distance(to: target)
        if distance < 19.5 {
            return "🌟🌟🌟"
        } else if (distance < 20) {
            return "🌟🌟"
        } else {
            return "🌟"
        }
    }
}


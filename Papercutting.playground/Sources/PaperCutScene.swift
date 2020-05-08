import Foundation
import SpriteKit
import AVFoundation

public class PaperCutScene : SKScene{
    
    public var compareImageName : String    = ""
    private var musicIsPlaying              = true;
    private var isPresent                   = false;
    private var scoreBoard                  = SKLabelNode(text: "Score:")
    private var finishBoard                 = SKLabelNode(text: "YOU DID IT, SHARE YOUR ART WITH YOUR FRIENDS.")
    private var paperCutBoarder             = SKShapeNode(rectOf: UIConfig.paperCutBoarderSize, cornerRadius: 5)
    private var bg                          = SKSpriteNode(imageNamed: "bg.jpg", normalMapped: false)
    
    private var player : AVAudioPlayer = {
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
    
    public func setCompareImageName(img name: String)
    {
        compareImageName = name
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
        
        view.addSubview(paperCutBoard)
        playBackgroundMusic()
        self.paperCutBoard.heightAnchor.constraint(equalToConstant: UIConfig.paperSize.height).isActive = true
        self.paperCutBoard.widthAnchor.constraint(equalToConstant: UIConfig.paperSize.width).isActive = true
        self.paperCutBoard.topAnchor.constraint(equalTo: view.topAnchor,
                                                constant: (UIConfig.backgroundSize.height - UIConfig.paperSize.height) / 5).isActive = true
        self.paperCutBoard.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                     
                                                    constant: (UIConfig.backgroundSize.width - UIConfig.paperSize.width) / 2).isActive = true
        
        
        
        scoreBoard.removeFromParent()
        
        scoreBoard.text = ""
        
        let presentAction = SKAction.run {
            SKAction.wait(forDuration: 0.5)
            
            if self.compareImageName == "" {
                self.scoreBoard.text = "🌟🌟🌟"
                self.scoreBoard.fontSize =  CGFloat(45)
            } else {
                self.scoreBoard.text = "Push SHOW, Get the rank"
                self.scoreBoard.fontSize =  CGFloat(25)
            }
            
        }
        let fadeInOut = SKAction.sequence([.fadeOut(withDuration: 0.1), presentAction, .fadeIn(withDuration: 0.3)])

        

        scoreBoard.fontColor = #colorLiteral(red: 0.4375018775, green: 0.5443386436, blue: 0.6065829396, alpha: 1)
        scoreBoard.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 7)
        scoreBoard.name = "scoreboard"
        scoreBoard.fontName = "Futura Medium Italic"
        addChild(scoreBoard)
        scoreBoard.run(.`repeat`(fadeInOut, count: 1))
        
        
        finishBoard.removeFromParent()
        finishBoard.fontSize =  CGFloat(20)
        finishBoard.fontColor = #colorLiteral(red: 0.4375018775, green: 0.5443386436, blue: 0.6065829396, alpha: 1)
        finishBoard.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 11)
        finishBoard.fontName = "Helvetica Neue Regular"
        finishBoard.name = "finishBoard"
        addChild(finishBoard)
        finishBoard.isHidden = true
        
        isPresent = true

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
        scoreBoard.text = "\(rank)"
        scoreBoard.fontSize =  CGFloat(45)
        if rank == "🌟🌟🌟" {
            finishBoard.text = "Perfect!"
            finishBoard.isHidden = false
        } else if rank == "🌟🌟"{
            finishBoard.text = "Greate!"
            finishBoard.isHidden = false
        } else {
            finishBoard.text = "Try harder!"
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


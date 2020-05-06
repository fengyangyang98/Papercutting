import Foundation
import SpriteKit
import AVFoundation

public class PaperCutScene : SKScene{
    
    public var compareImageName : String    = ""
    private var musicIsPlaying              = true;
    private var isPresent                   = false;
    private var scoreBoard                  = SKLabelNode(text: "Score:")
    private var finishBoard                 = SKLabelNode(text: "YOU DID IT, SHARE YOUR ART WITH YOUR FRIENDS.")
    
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
        board.layer?.backgroundColor = #colorLiteral(red: 0.8133277297, green: 0.09545669705, blue: 0.1514813602, alpha: 1)
        return board
    }()
    
    public func setCompareImageName(img name: String)
    {
        compareImageName = name
    }
    
    public override func didMove(to view: SKView) {
        self.anchorPoint = UIConfig.backgroundPosition
        self.size = UIConfig.backgroundSize
        self.backgroundColor = .white
        self.view?.layer?.cornerRadius = 5
        loadNodes()
    }

    private func loadNodes() {
        guard let view = self.view else {
            print("loadNodes nil")
            return
        }
        
        view.addSubview(paperCutBoard)
        playBackgroundMusic()
        self.paperCutBoard.heightAnchor.constraint(equalToConstant: UIConfig.paperSize.height).isActive = true
        self.paperCutBoard.widthAnchor.constraint(equalToConstant: UIConfig.paperSize.width).isActive = true
        self.paperCutBoard.topAnchor.constraint(equalTo: view.topAnchor,
                                                constant: (UIConfig.backgroundSize.height - UIConfig.paperSize.height) / 4).isActive = true
        self.paperCutBoard.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                     
                                                    constant: (UIConfig.backgroundSize.width - UIConfig.paperSize.width) / 2).isActive = true
        scoreBoard.removeFromParent()
        if compareImageName == "" {
            scoreBoard.text = "🌟🌟🌟"
        } else {
            scoreBoard.text = "Click SHOW, Get the rank"
        }
        scoreBoard.fontSize =  CGFloat(30)
        scoreBoard.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        scoreBoard.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height / 8)
        scoreBoard.name = "scoreboard"
        scoreBoard.fontName = "Futura Medium Italic"
        addChild(scoreBoard)
        
        finishBoard.removeFromParent()
        finishBoard.fontSize =  CGFloat(15)
        finishBoard.fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        finishBoard.position = CGPoint(x: UIConfig.backgroundSize.width / 2 , y: UIConfig.backgroundSize.height * 4 / 64)
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
                carve(carveWay: CarveWay.ying)
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
            finishBoard.text = "Perfect! Share it with your friends."
            finishBoard.isHidden = false
        } else if rank == "🌟🌟"{
            finishBoard.text = "Greate! Share it with your friends."
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
        if distance < 10 {
            return "🌟🌟🌟"
        } else if (distance < 20) {
            return "🌟🌟"
        } else {
            return "🌟"
        }
    }
}


import Foundation
import AppKit
import SpriteKit
import AVFoundation

extension NSTouchBar.CustomizationIdentifier {
    static let paperCutHelperBar = NSTouchBar.CustomizationIdentifier("paperCut.paperCutHelperBar")
}

extension NSTouchBarItem.Identifier {
    static let colorOption = NSTouchBarItem.Identifier("paperCut.colorOption")
    static let foldOption = NSTouchBarItem.Identifier("paperCut.foldOption")
    static let horizonFoldLable = NSTouchBarItem.Identifier("paperCut.horizonFoldLable")
    static let verticalFoldLable = NSTouchBarItem.Identifier("paperCut.verticalFoldLable")
    static let diagonalLeftFoldLable = NSTouchBarItem.Identifier("paperCut.diagonalLeftFoldLable")
    static let diagonalRightFoldLable = NSTouchBarItem.Identifier("paperCut.diagonalRightFoldLable")
    static let toolButton = NSTouchBarItem.Identifier("paperCut.toolButton")
    static let cutButton = NSTouchBarItem.Identifier("paperCut.cutButton")
    static let showButton = NSTouchBarItem.Identifier("paperCut.showButton")
}

public class PaperCutViewController : NSViewController {
    let NSgroupIdentifier = "paperCutFoldOtion"
    
    let sceneView = SKView(frame: CGRect(x:UIConfig.backgroundPosition.x,
                                         y:UIConfig.backgroundPosition.y,
                                         width: UIConfig.backgroundSize.width,
                                         height: UIConfig.backgroundSize.height))
    
    let showButtonItem = NSButtonTouchBarItem(identifier: NSTouchBarItem.Identifier.showButton, title: "Show", image: NSImage(named: NSImage.touchBarEnterFullScreenTemplateName)!, target: nil, action: #selector(show))
    let welcomeScene = WelcomeScene()
    
    var player : AVAudioPlayer = {
        let backgroundMusicURL =  Bundle.main.url(forResource: "backgroundMusic", withExtension: "m4a")!
        let player = try! AVAudioPlayer(contentsOf: backgroundMusicURL)
        return player
    }()
    
    public override func loadView() {
        playBackgroundMusic()
//        pauseBackgroundMusic()
        sceneView.layer?.backgroundColor = .black
        sceneView.presentScene(welcomeScene)
        self.view = sceneView
    }

    private func playBackgroundMusic() {
        player.numberOfLoops = -1
        player.volume = 0.05
        player.prepareToPlay()
        player.play()
    }
    
    private func pauseBackgroundMusic() {
        player.pause()
    }
    
}

extension PaperCutViewController: NSTouchBarDelegate  {
    
    private func foldBar() -> NSTouchBar{
        let foldBar = NSTouchBar()
        foldBar.delegate = self
        foldBar.defaultItemIdentifiers = [.horizonFoldLable, .verticalFoldLable, .diagonalLeftFoldLable, .diagonalRightFoldLable]
        foldBar.customizationAllowedItemIdentifiers = [.horizonFoldLable, .verticalFoldLable, .diagonalLeftFoldLable, .diagonalRightFoldLable]
        return foldBar
    }
    
    
    public override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .paperCutHelperBar
        touchBar.defaultItemIdentifiers = [.colorOption,.foldOption , .cutButton , .toolButton, .showButton]
        touchBar.customizationAllowedItemIdentifiers = [.colorOption,.foldOption , .cutButton , .toolButton, .showButton]
        
        return touchBar
    }
    
    public func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
            
        case NSTouchBarItem.Identifier.colorOption:
            let colorOptionItem = NSColorPickerTouchBarItem(identifier: identifier)
            let colorList = NSColorList()
            
            // preset: rainbow color
            colorList.setColor( #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), forKey: "Red")
            colorList.setColor( #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), forKey: "Orange")
            colorList.setColor( #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), forKey: "Yellow")
            colorList.setColor( #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), forKey: "Green")
            colorList.setColor( #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), forKey: "Blue")
            colorList.setColor( #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), forKey: "Violet")
            
            colorOptionItem.colorList = colorList
            colorOptionItem.isEnabled = true
            colorOptionItem.action = #selector(paperColor(sender:))
            
            return colorOptionItem
            
        case NSTouchBarItem.Identifier.horizonFoldLable:
            let horizonFoldLableIcon = NSImage(named: "horizonFold")!
            let horizonFoldButton = NSButtonTouchBarItem(identifier: identifier,title: "Horizontal" ,image: horizonFoldLableIcon, target: nil, action: #selector(paperFold(sender:)))
            return horizonFoldButton
            
        case NSTouchBarItem.Identifier.verticalFoldLable:
            let verticalFoldLableIcon = NSImage(named: "verticalFold")!
            let verticalFoldButton = NSButtonTouchBarItem(identifier: identifier,title: "Vertical"  ,image: verticalFoldLableIcon, target: nil, action: #selector(paperFold(sender:)))
            return verticalFoldButton
            
        case NSTouchBarItem.Identifier.diagonalLeftFoldLable:
            let diagonalLeftFoldLableIcon = NSImage(named: "diagonalLeftFold")!
            let diagonalLeftFoldButton = NSButtonTouchBarItem(identifier: identifier,title: "Left diagonal", image: diagonalLeftFoldLableIcon, target: nil, action: #selector(paperFold(sender:)))
            return diagonalLeftFoldButton
            
        case NSTouchBarItem.Identifier.diagonalRightFoldLable:
            let diagonalRightFoldLableIcon = NSImage(named: "diagonalRightFold")!
            let diagonalRightFoldButton = NSButtonTouchBarItem(identifier: identifier,title: "Right diagonal",image: diagonalRightFoldLableIcon, target: nil, action: #selector(paperFold(sender:)))
            return diagonalRightFoldButton

            
        case NSTouchBarItem.Identifier.foldOption:
            let foldButtonItem = NSPopoverTouchBarItem(identifier: identifier)
            foldButtonItem.collapsedRepresentationImage = NSImage(named: "fold")!
            foldButtonItem.collapsedRepresentationLabel = "Fold"
            foldButtonItem.popoverTouchBar = foldBar()
            foldButtonItem.showsCloseButton = true
            
            return foldButtonItem
            
            
        case NSTouchBarItem.Identifier.toolButton:
            let undoButtonIcon = NSImage(named: NSImage.touchBarGoBackTemplateName)!
            let undoButtonView = NSButton(image: undoButtonIcon, target: nil, action: #selector(undo))
            
            let clearButtonIcon = NSImage(named: NSImage.touchBarDeleteTemplateName)!
            let clearButtonView = NSButton(image: clearButtonIcon, target: nil, action: #selector(clear))
            
            let toolButtonStack = NSStackView(views: [undoButtonView, clearButtonView])
            toolButtonStack.spacing = 1
            
            let groupButton = NSCustomTouchBarItem(identifier: identifier)
            groupButton.view = toolButtonStack
            return groupButton
            
        case NSButtonTouchBarItem.Identifier.cutButton:
            let cutButtonItem = NSCustomTouchBarItem(identifier: identifier)
            
            let yangCutButtonIcon = NSImage(named: "yang")!
            let yingCutButtonIcon = NSImage(named: "ying")!
        
            
            let controlView = NSSegmentedControl(images: [yangCutButtonIcon, yingCutButtonIcon], trackingMode: NSSegmentedControl.SwitchTracking.selectOne, target: nil, action: #selector(carve(sender:)))
            
            controlView.setWidth(65, forSegment: 0)
            controlView.setWidth(65, forSegment: 1)
            controlView.setSelected(true, forSegment: 0)
            cutButtonItem.view = controlView
            return cutButtonItem
            
        case NSTouchBarItem.Identifier.showButton:
            self.showButtonItem.bezelColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            return self.showButtonItem
            
        default: return nil
        }
    }
    
    @objc
    func paperFold(sender: Any) {
        guard let paperCutBoard = self.welcomeScene.nextScene as? PaperCutScene, let button = sender as? NSButtonTouchBarItem else {
            return
        }
        if button.image == NSImage(named: "verticalFold") {
            paperCutBoard.verticalFold()
        } else if button.image == NSImage(named: "horizonFold") {
            paperCutBoard.horizonFold()
        } else if button.image == NSImage(named: "diagonalLeftFold") {
            paperCutBoard.diagonalLeftFold()
        } else if button.image == NSImage(named: "diagonalRightFold") {
            paperCutBoard.diagonalRightFold()
        }
    }
    
    @objc
    func carve(sender: Any) {
        guard let control = sender as? NSSegmentedControl, let paperCutBoard = self.welcomeScene.nextScene as? PaperCutScene else
        {
            return
        }
        
        let carveWay = (control.selectedSegment == 0 ? CarveWay.yang : CarveWay.ying)
        paperCutBoard.carve(carveWay: carveWay)
    }
    
    @objc
    func paperColor(sender: Any){
        guard let piker = sender as? NSColorPickerTouchBarItem, let paperCutBoard = self.welcomeScene.nextScene as? PaperCutScene else
        {
            return
        }
        
        paperCutBoard.paperColor(color: piker.color.cgColor)
        self.showButtonItem.bezelColor = piker.color
        
    }
    
    @objc
    func clear() {
        guard let paperCutBoard = self.welcomeScene.nextScene as? PaperCutScene else {
            return
        }
        paperCutBoard.clear()
    }

    
    @objc
    func show() {
        guard let paperCutBoard = self.welcomeScene.nextScene as? PaperCutScene else {
            return
        }
        paperCutBoard.show()
    }
    
    @objc
    func undo() {
        guard let paperCutBoard = self.welcomeScene.nextScene as? PaperCutScene else {
            return
        }
        paperCutBoard.undo()
    }
}

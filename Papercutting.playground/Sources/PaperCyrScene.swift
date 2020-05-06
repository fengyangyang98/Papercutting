import Foundation
import SpriteKit

public class PaperCutScene : SKScene{
    
    // the paper cut
    private var paperCutBoard : PaperCutBoard = {
        let point1 = CGPoint(x: 0, y: UIConfig.paperSize.height)
        let point2 = CGPoint(x: UIConfig.paperSize.width, y: UIConfig.paperSize.height)
        let point3 = CGPoint(x: UIConfig.paperSize.width, y: 0)
        let point4 = CGPoint(x: 0, y: 0)
        
        let board = PaperCutBoard(pointShape: [point1, point2, point3, point4])
        board.wantsLayer = true
        board.translatesAutoresizingMaskIntoConstraints = false
        board.layer?.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return board
    }()
    
    public override func didMove(to view: SKView) {
        self.anchorPoint = UIConfig.backgroundPosition
        self.size = UIConfig.backgroundSize
        self.backgroundColor = .white
        self.view?.layer?.cornerRadius = 10
        self.view?.layer?.borderColor =  #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        self.view?.layer?.borderWidth = 10.0
        loadNodes()
    }
    
    private func loadNodes() {
        guard let view = self.view else {
            return
        }
        
        view.addSubview(paperCutBoard)
        self.paperCutBoard.heightAnchor.constraint(equalToConstant: UIConfig.paperSize.height).isActive = true
        self.paperCutBoard.widthAnchor.constraint(equalToConstant: UIConfig.paperSize.width).isActive = true
        self.paperCutBoard.topAnchor.constraint(equalTo: view.topAnchor,
                                                constant: (UIConfig.backgroundSize.height - UIConfig.paperSize.height) / 2).isActive = true
        self.paperCutBoard.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: (UIConfig.backgroundSize.width - UIConfig.paperSize.width) / 2).isActive = true
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
        paperCutBoard.show()
        
        let distance = paperCutBoard.distance(to: NSImage(named: "sample-start")!)
        print(distance)
        
    }
    
    public func undo() {
        paperCutBoard.undo()
    }
    
    public func compare() {
        let distance = paperCutBoard.distance(to: NSImage(named: "sample-start")!)
        print(distance)
    }
}


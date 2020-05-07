import Foundation
import AppKit
import Vision

public enum FillOrStroke {
    case fill
    case strock
}

public enum Fold {
    case horizon
    case vertical
    case diagonal
}

public enum CarveWay {
    case yin
    case yang
}

public struct Line {
    var fillOrStroke : FillOrStroke = .strock
    var line = [CGPoint]()
}

public struct CurrentShape {
    var edgePoint = [CGPoint]()
    var lines = [Line]()
    var symmetryAxis = [CGPoint]()
}

// MARK: BASIC PAPERCUT BOARD
public class PaperCutBoard : NSView {
    
    
    private var carveWay : CarveWay = .yang
    private var currentShapeSeq = [CurrentShape]()
    private var lines = [Line]()
    
    
    init(pointShape : [CGPoint]) {
        var newShape = CurrentShape()
        
        for point in pointShape {
            newShape.edgePoint.append(point)
        }
        currentShapeSeq.append(newShape)
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        context.setLineWidth(CGFloat(2))
        context.setStrokeColor(UIConfig.paperCutBoardBackgroudColor.cgColor)
        context.setFillColor(UIConfig.paperCutBoardBackgroudColor.cgColor)
        
        lines.forEach { (line) in
            for (index, point) in line.line.enumerated() {
                if index == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            if line.fillOrStroke == .strock {
                context.strokePath()
            } else {
                context.fillPath()
            }
        }
        
    }
    
    override public func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        self.lines.append(Line())
        
        setNeedsDisplay(convert(self.frame, from: nil))
    }
    
    override public func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        
        guard var lastLine = lines.popLast()else {
            return
        }
        
        lastLine.line.append(convert(event.locationInWindow, from: nil))
        lines.append(lastLine)
        
        setNeedsDisplay(convert(self.frame, from: nil))
    }
    
    override public func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        guard var lastLine = lines.popLast(), var currentShape = self.currentShapeSeq.popLast() else {
            return
        }
        
        if self.carveWay == .yang {
            lastLine.fillOrStroke = .fill
            setNeedsDisplay(convert(self.frame, from: nil))
        }
        lines.append(lastLine)
        
        currentShape.lines.append(lastLine)
        currentShapeSeq.append(currentShape)
    }
    
    public override func rightMouseDown(with event: NSEvent) {
        self.heightAnchor.constraint(equalToConstant: self.frame.size.height / 2).isActive = true
    }
}



// MARK: TOOL FUCTION
extension PaperCutBoard {
    public func undo() {
        guard var currentShape = self.currentShapeSeq.popLast() else {
            return
        }
        
        
        if currentShape.lines.count == 0, currentShapeSeq.count > 0 {
            drawMaskLayer(pointShape: currentShapeSeq.last!.edgePoint)
        } else {
            _ = currentShape.lines.popLast()
            _ = self.lines.popLast()
            self.currentShapeSeq.append(currentShape)
            setNeedsDisplay(convert(self.frame, from: nil))
        }
        
        
    }
    
    public func clear() {
        self.lines.removeAll()
        for index in 0..<self.currentShapeSeq.count {
            self.currentShapeSeq[index].lines.removeAll()
        }
        setNeedsDisplay(convert(self.frame, from: nil))
    }
    
    private func drawMaskLayer(pointShape : [CGPoint]) {
        let bezierPath = CGMutablePath()
        bezierPath.move(to: pointShape[0])
        bezierPath.addLine(to: pointShape[1])
        bezierPath.addLine(to: pointShape[2])
        
        if pointShape.count == 3 {
            bezierPath.addLine(to: pointShape[0])
        } else {
            bezierPath.addLine(to: pointShape[3])
            bezierPath.addLine(to: pointShape[0])
        }
        
        let shapeView = CAShapeLayer()
        shapeView.path = bezierPath
        self.layer?.mask = shapeView
    }
    
    
    public func verticalFold() {
        guard let currentShape = self.currentShapeSeq.last else {
            return
        }
        
        if currentShape.edgePoint.count == 4 {
            var newShape = CurrentShape()
            newShape.edgePoint.append(currentShape.edgePoint[0])
            newShape.edgePoint.append(currentShape.edgePoint[1])
            newShape.edgePoint.append(CGPoint(x: currentShape.edgePoint[2].x,
                                              y: (currentShape.edgePoint[2].y + currentShape.edgePoint[1].y) / 2))
            newShape.edgePoint.append(CGPoint(x: currentShape.edgePoint[3].x,
                                              y: (currentShape.edgePoint[3].y + currentShape.edgePoint[0].y) / 2))
            
            newShape.symmetryAxis.append(CGPoint(x: currentShape.edgePoint[2].x,
                                                 y: (currentShape.edgePoint[2].y + currentShape.edgePoint[1].y) / 2))
            newShape.symmetryAxis.append(CGPoint(x: currentShape.edgePoint[3].x,
                                                 y: (currentShape.edgePoint[3].y + currentShape.edgePoint[0].y) / 2))
            currentShapeSeq.append(newShape)
            drawMaskLayer(pointShape: newShape.edgePoint)
            
            
        } else if currentShape.edgePoint.count == 3{
            if (currentShape.edgePoint[1].y + currentShape.edgePoint[2].y) / 2 == currentShape.edgePoint[0].y {
                var newShape = CurrentShape()
                newShape.edgePoint.append(CGPoint(x: currentShape.edgePoint[1].x,
                                                  y: (currentShape.edgePoint[1].y + currentShape.edgePoint[2].y) / 2))
                
                if currentShape.edgePoint[0].x > currentShape.edgePoint[2].x {
                    newShape.edgePoint.append(currentShape.edgePoint[2])
                    newShape.edgePoint.append(currentShape.edgePoint[0])
                } else {
                    newShape.edgePoint.append(currentShape.edgePoint[0])
                    newShape.edgePoint.append(currentShape.edgePoint[1])
                }
                
                newShape.symmetryAxis.append(CGPoint(x: currentShape.edgePoint[1].x,
                                                     y: (currentShape.edgePoint[1].y + currentShape.edgePoint[2].y) / 2))
                newShape.symmetryAxis.append(currentShape.edgePoint[0])
                
                drawMaskLayer(pointShape: currentShape.edgePoint)
                currentShapeSeq.append(newShape)
            }
        }
    }
    
    public func horizonFold() {
        guard let currentShape = self.currentShapeSeq.last else {
            return
        }
        
        if currentShape.edgePoint.count == 4 {
            var newShape = CurrentShape()
            newShape.edgePoint.append(currentShape.edgePoint[0])
            newShape.edgePoint.append(CGPoint(x: (currentShape.edgePoint[0].x + currentShape.edgePoint[1].x) / 2,
                                              y: currentShape.edgePoint[1].y))
            newShape.edgePoint.append(CGPoint(x: (currentShape.edgePoint[2].x + currentShape.edgePoint[3].x) / 2,
                                              y: currentShape.edgePoint[2].y))
            newShape.edgePoint.append(currentShape.edgePoint[3])
            
            newShape.symmetryAxis.append(CGPoint(x: (currentShape.edgePoint[0].x + currentShape.edgePoint[1].x) / 2,
                                                 y: currentShape.edgePoint[1].y))
            newShape.symmetryAxis.append(CGPoint(x: (currentShape.edgePoint[2].x + currentShape.edgePoint[3].x) / 2,
                                                 y: currentShape.edgePoint[2].y))
            
            currentShapeSeq.append(newShape)
            drawMaskLayer(pointShape: newShape.edgePoint)
            
            
        } else {
            if (currentShape.edgePoint[1].x + currentShape.edgePoint[2].x) / 2 == currentShape.edgePoint[0].x {
                var newShape = CurrentShape()
                newShape.edgePoint.append(CGPoint(x: (currentShape.edgePoint[1].x + currentShape.edgePoint[2].x) / 2,
                                                  y: currentShape.edgePoint[1].y))
                
                if currentShape.edgePoint[1].y > currentShape.edgePoint[0].y {
                    newShape.edgePoint.append(currentShape.edgePoint[0])
                    newShape.edgePoint.append(currentShape.edgePoint[1])
                } else {
                    newShape.edgePoint.append(currentShape.edgePoint[2])
                    newShape.edgePoint.append(currentShape.edgePoint[1])
                }
                
                newShape.symmetryAxis.append(CGPoint(x: (currentShape.edgePoint[1].x + currentShape.edgePoint[2].x) / 2,
                                                     y: currentShape.edgePoint[1].y))
                newShape.symmetryAxis.append(currentShape.edgePoint[0])
                
                currentShapeSeq.append(newShape)
                drawMaskLayer(pointShape: newShape.edgePoint)
                
            }
        }
    }
    
    
    public func diagonalRightFold() {
        guard let currentShape = self.currentShapeSeq.last else {
            return
        }
        if currentShape.edgePoint.count == 4 &&
            currentShape.edgePoint[1].x - currentShape.edgePoint[0].x == currentShape.edgePoint[0].y - currentShape.edgePoint[3].y{
            
            var newShape = CurrentShape()
            newShape.edgePoint.append(currentShape.edgePoint[1])
            newShape.edgePoint.append(currentShape.edgePoint[2])
            newShape.edgePoint.append(currentShape.edgePoint[0])
            
            newShape.symmetryAxis.append(currentShape.edgePoint[0])
            newShape.symmetryAxis.append(currentShape.edgePoint[2])
            
            currentShapeSeq.append(newShape)
            drawMaskLayer(pointShape: newShape.edgePoint)
            
        } else if currentShape.edgePoint.count == 3 {
            
            if max(currentShape.edgePoint[0].x, currentShape.edgePoint[1].x, currentShape.edgePoint[2].x) == currentShape.edgePoint[0].x  &&
                min(currentShape.edgePoint[0].y, currentShape.edgePoint[1].y, currentShape.edgePoint[2].y) == currentShape.edgePoint[0].y {
                
                var newShape = CurrentShape()
                newShape.edgePoint.append(CGPoint(x: (currentShape.edgePoint[1].x + currentShape.edgePoint[2].x) / 2,
                                                  y: (currentShape.edgePoint[0].y + currentShape.edgePoint[2].y) / 2))
                newShape.edgePoint.append(currentShape.edgePoint[2])
                newShape.edgePoint.append(currentShape.edgePoint[0])
                
                newShape.symmetryAxis.append(currentShape.edgePoint[0])
                newShape.symmetryAxis.append(CGPoint(x: (currentShape.edgePoint[1].x + currentShape.edgePoint[2].x) / 2,
                                                     y: (currentShape.edgePoint[0].y + currentShape.edgePoint[2].y) / 2))
                
                currentShapeSeq.append(newShape)
                drawMaskLayer(pointShape: newShape.edgePoint)
                
                
            } else if min(currentShape.edgePoint[0].x, currentShape.edgePoint[1].x, currentShape.edgePoint[2].x) == currentShape.edgePoint[0].x  &&
                max(currentShape.edgePoint[0].y, currentShape.edgePoint[1].y, currentShape.edgePoint[2].y) == currentShape.edgePoint[0].y {
                
                var newShape = CurrentShape()
                
                newShape.edgePoint.append(CGPoint(x: (currentShape.edgePoint[0].x + currentShape.edgePoint[1].x) / 2,
                                                  y: (currentShape.edgePoint[0].y + currentShape.edgePoint[2].y) / 2))
                newShape.edgePoint.append(currentShape.edgePoint[0])
                newShape.edgePoint.append(currentShape.edgePoint[1])
                
                
                newShape.symmetryAxis.append(currentShape.edgePoint[0])
                newShape.symmetryAxis.append(CGPoint(x: (currentShape.edgePoint[0].x + currentShape.edgePoint[1].x) / 2,
                                                     y: (currentShape.edgePoint[0].y + currentShape.edgePoint[2].y) / 2))
                
                currentShapeSeq.append(newShape)
                drawMaskLayer(pointShape: newShape.edgePoint)
                
            }
        }
    }
    
    public func diagonalLeftFold() {
        guard let currentShape = self.currentShapeSeq.last else {
            return
        }
        
        if currentShape.edgePoint.count == 4 &&
            currentShape.edgePoint[1].x - currentShape.edgePoint[0].x == currentShape.edgePoint[0].y - currentShape.edgePoint[3].y{
            
            var newShape = CurrentShape()
            newShape.edgePoint.append(currentShape.edgePoint[0])
            newShape.edgePoint.append(currentShape.edgePoint[1])
            newShape.edgePoint.append(currentShape.edgePoint[3])
            
            newShape.symmetryAxis.append(currentShape.edgePoint[1])
            newShape.symmetryAxis.append(currentShape.edgePoint[3])
            
            currentShapeSeq.append(newShape)
            drawMaskLayer(pointShape: newShape.edgePoint)
        } else if currentShape.edgePoint.count == 3 {
            
            if min(currentShape.edgePoint[0].x, currentShape.edgePoint[1].x, currentShape.edgePoint[2].x) == currentShape.edgePoint[0].x  &&
                min(currentShape.edgePoint[0].y, currentShape.edgePoint[1].y, currentShape.edgePoint[2].y) == currentShape.edgePoint[0].y {
                
                var newShape = CurrentShape()
                newShape.edgePoint.append(CGPoint(x: (currentShape.edgePoint[1].x + currentShape.edgePoint[2].x) / 2,
                                                  y: (currentShape.edgePoint[0].y + currentShape.edgePoint[1].y) / 2))
                newShape.edgePoint.append(currentShape.edgePoint[0])
                newShape.edgePoint.append(currentShape.edgePoint[1])
                
                newShape.symmetryAxis.append(currentShape.edgePoint[0])
                newShape.symmetryAxis.append(CGPoint(x: (currentShape.edgePoint[1].x + currentShape.edgePoint[2].x) / 2,
                                                     y: (currentShape.edgePoint[0].y + currentShape.edgePoint[1].y) / 2))
                
                currentShapeSeq.append(newShape)
                drawMaskLayer(pointShape: newShape.edgePoint)
                
                
            } else if max(currentShape.edgePoint[0].x, currentShape.edgePoint[1].x, currentShape.edgePoint[2].x) == currentShape.edgePoint[0].x  &&
                max(currentShape.edgePoint[0].y, currentShape.edgePoint[1].y, currentShape.edgePoint[2].y) == currentShape.edgePoint[0].y {
                
                var newShape = CurrentShape()
                
                newShape.edgePoint.append(CGPoint(x: (currentShape.edgePoint[0].x + currentShape.edgePoint[2].x) / 2,
                                                  y: (currentShape.edgePoint[0].y + currentShape.edgePoint[1].y) / 2))
                newShape.edgePoint.append(currentShape.edgePoint[2])
                newShape.edgePoint.append(currentShape.edgePoint[0])
                
                newShape.symmetryAxis.append(currentShape.edgePoint[0])
                newShape.symmetryAxis.append(CGPoint(x: (currentShape.edgePoint[0].x + currentShape.edgePoint[2].x) / 2,
                                                     y: (currentShape.edgePoint[0].y + currentShape.edgePoint[1].y) / 2))
                
                currentShapeSeq.append(newShape)
                drawMaskLayer(pointShape: newShape.edgePoint)
                
            }
        }
        
    }
    
    
    public func carve(carveWay : CarveWay) {
        self.carveWay = carveWay
    }
    
    public func paperColor(color : CGColor) {
        self.layer?.backgroundColor = color
    }
    
    private func pointOfSymmetry(symmetryAxis: [CGPoint], point: CGPoint) -> CGPoint {
        if symmetryAxis[0].x == symmetryAxis[1].x {
            var symmetryPoint = CGPoint()
            symmetryPoint.x = symmetryAxis[0].x * 2 - point.x
            symmetryPoint.y = point.y
            return symmetryPoint
        
        } else if symmetryAxis[0].y == symmetryAxis[1].y {
            var symmetryPoint = CGPoint()
            symmetryPoint.y = symmetryAxis[0].y * 2 - point.y
            symmetryPoint.x = point.x
            return symmetryPoint
    
        } else {
            let A =  (symmetryAxis[1].y - symmetryAxis[0].y) / (symmetryAxis[0].x - symmetryAxis[1].x)
            let B = 1
            let C = 0 - A * symmetryAxis[0].x - symmetryAxis[0].y
            
            let len = 1 + A * A
            
            let samePart = CGFloat(A) * point.x + CGFloat(B) * point.y + CGFloat(C)
            let dist = samePart / len
            
            
            var symmetryPoint = CGPoint()
            symmetryPoint.x = point.x - 2 * CGFloat(A) * dist
            symmetryPoint.y = point.y - 2 * CGFloat(B) * dist
            return symmetryPoint
        }
        

    }
    
    private func lineOfSymmetry(symmetryAxis: [CGPoint], line: Line) -> Line {
        var newLine = Line()
        for point in line.line {
            newLine.line.append(pointOfSymmetry(symmetryAxis: symmetryAxis, point: point))
        }
        newLine.fillOrStroke = line.fillOrStroke
        return newLine
    }
        
    public func show() {
        // clean the lines in the screen
        self.lines.removeAll()
        
        // symmetray operation
        while currentShapeSeq.count > 0 {
            
            guard let shape = currentShapeSeq.popLast() else {
                continue
            }
            
            let lineInShap = shape.lines
            
            for line in lineInShap {
                lines.append(line)
            }
            
            let symmetryAxis = shape.symmetryAxis
            if symmetryAxis.count == 0 { continue }
            
            let lineCount = lines.count
            for index in 0..<lineCount {
                lines.append(lineOfSymmetry(symmetryAxis: symmetryAxis, line: lines[index]))
            }
        }
        
        let point1 = CGPoint(x: 0, y: UIConfig.paperSize.height)
        let point2 = CGPoint(x: UIConfig.paperSize.width, y: UIConfig.paperSize.height)
        let point3 = CGPoint(x: UIConfig.paperSize.width, y: 0)
        let point4 = CGPoint(x: 0, y: 0)
        
        // show the whole paper
        drawMaskLayer(pointShape: [point1, point2, point3, point4])
        
        // add the new paper into the currentShapeSeq
        var newShape = CurrentShape()
        newShape.edgePoint = [point1, point2, point3, point4]
        newShape.lines = lines
        self.currentShapeSeq.append(newShape)


        setNeedsDisplay(convert(self.frame, from: nil))
    }
}



// MARK: COMPARE

extension PaperCutBoard {
    
    private func featureprintObservationForImage(atURL url: URL) -> VNFeaturePrintObservation? {
        let requestHandler = VNImageRequestHandler(url: url, options: [:])
        let request = VNGenerateImageFeaturePrintRequest()
        do {
            try requestHandler.perform([request])
            return request.results?.first as? VNFeaturePrintObservation
        } catch {
            print("Vision error: \(error)")
            return nil
        }
    }
    
    public func distance(to image: NSImage) -> Float {
        let myPaperCutImage = self.image()
        let myPaperCutFPO = featureprintObservationForImage(atURL: myPaperCutImage.pngWrite())
        
        let originalImage = image
        let originalImageFPO = featureprintObservationForImage(atURL: originalImage.pngWrite())
        
        var distance = Float(0)
        
        if let myPaperCut = myPaperCutFPO, let original = originalImageFPO {
            do {
                try myPaperCut.computeDistance(&distance, to: original)
            } catch {
                print("Ecrror computing distance between featureprints.")
            }
        }
        
        return distance
    }
}

import Foundation
import AppKit

extension NSImage {
    
    var pngData: Data? {
         guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            return nil
        }
         return bitmapImage.representation(using: .png, properties: [:])
     }
    
     func pngWrite(options: Data.WritingOptions = .atomic) -> URL {
        let baseURL = FileManager.default.temporaryDirectory
        let imageURL = baseURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")
        do {
            try pngData?.write(to: imageURL, options: options)
             return imageURL
         } catch {
             print(error)
            return imageURL
         }
     }
    
    func resize(toSize to: CGSize) -> NSImage {
        let toRect = NSRect(x: 0, y: 0, width: to.width, height: to.height)
        let fromRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let newImage = NSImage(size: toRect.size)
        newImage.lockFocus()
        draw(in: toRect, from: fromRect, operation: NSCompositingOperation.copy, fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
}




extension NSView {
    func image() -> NSImage {
        let imageRepresentation = bitmapImageRepForCachingDisplay(in: bounds)!
        cacheDisplay(in: bounds, to: imageRepresentation)
        return NSImage(cgImage: imageRepresentation.cgImage!, size: bounds.size)
    }
}

/*:
 ## Challenge
  
  At this stage, you can choose the pattern you want to challenge from the list `challengePattern`. Press the `Show` button and you will see your paper cut score. At least two stars are required.

 ## How to control?
 ![menu](menu.jpg)
 */
import Cocoa
import PlaygroundSupport
import SpriteKit


let challengePattern = [
                            "🌟": "start",
                            "🟢": "circle"
                       ]

/*:
 You can put the pattern you want to challenge here.
 */
let challenge = challengePattern["🌟"] ?? ""
let hintPath = "hint-" + challenge

let target = NSImage(named: challenge)

let paperCut = PaperCutViewController(image: challenge)
PlaygroundPage.current.liveView = paperCut.view
/*:
 If you want to get some hint, show the hint pic there.
*/
let hint = NSImage(named: hintPath)
//: [Next - Creation](@next)

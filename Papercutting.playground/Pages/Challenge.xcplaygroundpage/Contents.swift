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
                            "🌟": "sample-start"
                       ]

let challenge = challengePattern["🌟"]


let paperCut = PaperCutViewController(image: challenge ?? "")
PlaygroundPage.current.liveView = paperCut.view
//: [Next](@next)

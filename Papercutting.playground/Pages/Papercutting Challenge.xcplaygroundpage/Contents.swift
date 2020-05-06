//: [Previous](@previous)

import Cocoa
import PlaygroundSupport
import SpriteKit

let challengePattern = [
                            "🌟": "sample-start"
                       ]

let paperCut = PaperCutViewController(image: challengePattern["🌟"] ?? "")
PlaygroundPage.current.liveView = paperCut.view

//: [Next](@next)


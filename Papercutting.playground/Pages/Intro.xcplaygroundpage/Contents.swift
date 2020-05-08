/*:
 # Papercutting
 
 ## What is Papercutting?

 Papercutting is a kind of folk art in China that uses scissors or a knife to cut patterns on paper. When I was a kid, our teachers used papercutting works as rewards. Every time during the Chinese New Year, the Chinese will post window papercutting, which is also a kind of papercutting art, as decorations to accentuate the New Year's atmosphere.
 
 For me, paper-cutting is a unique memory, a memory that children receive praise from the teacher, and a memory of family reunion.
 
 ## Papercutting skills
 
 ### Folding
 
 We can fold the paper and use symmetrical beauty to cut out various patterns.
 
 ### Cutting
 
 There are two ways to cut paper. Yin carving is to engrave the outline lines that represent the structure of objects. Contrary to Yin carving, Yang carving is to cut away the blank part and keep the outline.
 
 ![carving-yin-yang](carving-yin-yang.png)
 
 ## How to control?
 
 ### Use the touch bar
 ![menu](menu.jpg)
 
 ### Use shortcut keys
 * Fold paper
     * H for horizontal folding
     * V for vertical folding
     * R for folding to the upper right corner
     * L for folding to the upper left corner
 * Choose how to cut
     * I for Yin carving
     * A for Yang carving
 * Others
     * Z for undoing the previous operation
     * T for clearing the paper
     * M for palying / turning off the backgroung music
 
 ## Let's start with a circle
 
 Try to use the skills mentioned before to cut a circle pattern on the paper. Push the `Show` button on the touch bar or push the `S` on the keyboard to show your first-try work and get a ranking. Try to get at least two 🌟, or even three.
 
 */
import Cocoa
import PlaygroundSupport
import SpriteKit

//: You can get the target pattern here:
let target = NSImage(named: "circle")

let paperCut = PaperCutViewController(image: "circle")
PlaygroundPage.current.liveView = paperCut.view
//: You can get some hints here if you want:
let hint = NSImage(named: "hint-circle")
//: [Next - Challenge](@next)

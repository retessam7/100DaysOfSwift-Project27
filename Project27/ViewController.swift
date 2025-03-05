//
//  ViewController.swift
//  Project27
//
//  Created by Aleksei Ivanov on 3/3/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawRotatedSquares()
        case 3:
            drawLines()
        case 4:
            drawImagesAndText()
        default:
            break
        }
    }
    
    // When the rendering has finished it gets placed into the image constant, which in turn gets sent to the image view for display.
    func drawRectangle() {
        // Creating the renderer doesn’t actually start any renderin
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        // To kick off rendering can call the image() function or call the pngData() and jpegData() methods to get back a Data object in PNG or JPEG format respectively.
        // a single parameter that I’ve named ctx, which is a reference to a UIGraphicsImageRendererContext to draw to. This is a thin wrapper around another data type called CGContext, which is where the majority of drawing code lives
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // insetBy() method that lets us push each edge in by a certain amount
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            // done by specifying its rectangular bounds.
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        imageView.image = img
    }
    
    // current transformation matrix is very similar to those CGAffineTransform modifications In UIKit, you rotate drawing around the center of your view, as if a pin was stuck right through the middle. In Core Graphics, you rotate around the top-left corner, so  that we've effectively moved the rotation point.
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                // we need to draw our rotated squares so they are centered on our center:
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawImagesAndText() {
        // Create a renderer at the correct size.
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // Define a paragraph style that aligns text to the center
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            // Create an attributes dictionary containing that paragraph style, and also a font.
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            // Wrap that attributes dictionary and a string into an instance of NSAttributedString.
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            // Load an image from the project and draw it to the context.
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        // Update the image view with the finished result.
        imageView.image = img
    }
}

// Let's take a look at the five new methods you'll need to use to draw our box:

// A different way of drawing rectangles is just to fill them directly with your target color:
// fill(), which skips the add path / draw path work and just fills the rectangle given as its parameter using whatever the current fill color is

// setFillColor() sets the fill color of our context, which is the color used on the insides of the rectangle we'll draw.
// setStrokeColor() sets the stroke color of our context, which is the color used on the line around the edge of the rectangle we'll draw.
// setLineWidth() adjusts the line width that will be used to stroke our rectangle. Note that the line is drawn centered on the edge of the rectangle, so a value of 10 will draw 5 points inside the rectangle and five points outside.
// addRect() adds a CGRect rectangle to the context's current path to be drawn.
// drawPath() draws the context's current path using the state you have configured.
// All five of those are called on the Core Graphics context that comes from ctx.cgContext, using a parameter that does the actual work.

// func drawCheckerboard() {
// let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

// let img = renderer.image { ctx in
//    ctx.cgContext.setFillColor(UIColor.black.cgColor)

//    for row in 0 ..< 8 {
//            for col in 0 ..< 8 {
//            if (row + col) % 2 == 0 {
//                ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
//            }
//        }
//    }
//}

//imageView.image = img
//}

// To make this happen, you need to know three new Core Graphics methods:

// translateBy() translates (moves) the current transformation matrix.
// rotate(by:) rotates the current transformation matrix.
// strokePath() strokes the path with your specified line width, which is 1 if you don't set it explicitly.

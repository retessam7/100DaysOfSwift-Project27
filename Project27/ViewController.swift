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
}

// Let's take a look at the five new methods you'll need to use to draw our box:

// setFillColor() sets the fill color of our context, which is the color used on the insides of the rectangle we'll draw.
// setStrokeColor() sets the stroke color of our context, which is the color used on the line around the edge of the rectangle we'll draw.
// setLineWidth() adjusts the line width that will be used to stroke our rectangle. Note that the line is drawn centered on the edge of the rectangle, so a value of 10 will draw 5 points inside the rectangle and five points outside.
// addRect() adds a CGRect rectangle to the context's current path to be drawn.
// drawPath() draws the context's current path using the state you have configured.
// All five of those are called on the Core Graphics context that comes from ctx.cgContext, using a parameter that does the actual work.

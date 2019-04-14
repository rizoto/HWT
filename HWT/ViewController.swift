//
//  ViewController.swift
//  HWT
//
//  Created by Lubor Kolacny on 12/4/19.
//  Copyright © 2019 Lubor Kolacny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var point = CGPoint.zero
    var drawing = false

    @IBOutlet var canvas: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension ViewController {
    // MARK: Touches stuff & logic
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            point = touch.location(in: canvas)
            drawing = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point2 = touch.location(in: canvas)
            drawLine(from: point, to: point2)
            point = point2
            drawing = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawing = false
    }
    
}

extension ViewController {
// MARK: Drawing
    func drawLine(from: CGPoint, to: CGPoint) -> Void {
        UIGraphicsBeginImageContext(canvas.bounds.size)
        if let ctx = UIGraphicsGetCurrentContext() {
            canvas.image?.draw(in: self.canvas.bounds)
            ctx.setLineCap(.round)
            ctx.setLineWidth(10.0)
            ctx.setStrokeColor(red: 0, green: 0, blue: 255, alpha: 1)
            ctx.move(to: from)
            ctx.addLine(to: to)
            ctx.strokePath()
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                canvas.image = image
            }
        }
        UIGraphicsEndImageContext()
    }
}

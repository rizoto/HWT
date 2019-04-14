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
    
    let model = ml_digits()

    @IBOutlet weak var canvas: UIImageView!
    @IBOutlet weak var textDigits: UITextField!
    
    @IBAction func testImage(_ sender: UIButton) {
        do {
            let pixels = getCVPixelBuffer(canvas.image!.cgImage!)
            let result = try model.prediction(image: pixels!)
            print("\(result.classLabel) - \(result.classLabelProbs)")
        } catch {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getCVPixelBuffer(_ image: CGImage) -> CVPixelBuffer? {
        let imageWidth = Int(image.width)
        let imageHeight = Int(image.height)
        
        let attributes : [NSObject:AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey : true as AnyObject,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true as AnyObject
        ]
        
        var pxbuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            imageWidth,
                            imageHeight,
                            kCVPixelFormatType_32ARGB,
                            attributes as CFDictionary?,
                            &pxbuffer)
        
        if let _pxbuffer = pxbuffer {
            let flags = CVPixelBufferLockFlags(rawValue: 0)
            CVPixelBufferLockBaseAddress(_pxbuffer, flags)
            let pxdata = CVPixelBufferGetBaseAddress(_pxbuffer)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            let context = CGContext(data: pxdata,
                                    width: imageWidth,
                                    height: imageHeight,
                                    bitsPerComponent: 8,
                                    bytesPerRow: CVPixelBufferGetBytesPerRow(_pxbuffer),
                                    space: rgbColorSpace,
                                    bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
            
            if let _context = context {
                _context.draw(image, in: CGRect.init(x: 0, y: 0, width: imageWidth, height: imageHeight))
            }
            else {
                CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
                return nil
            }
            
            CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
            return _pxbuffer;
        }
        
        return nil
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
            ctx.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
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

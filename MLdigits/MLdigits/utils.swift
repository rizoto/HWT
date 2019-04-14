//
//  utils.swift
//  MLdigits
//
//  Created by Lubor Kolacny on 14/4/19.
//  Copyright © 2019 Lubor Kolacny. All rights reserved.
//

import Foundation

func writeCGImage (image: CGImage, url: URL) {
    if let dest = CGImageDestinationCreateWithURL(url as CFURL, kUTTypePNG, 1, nil) {
        CGImageDestinationAddImage(dest, image, nil)
        CGImageDestinationFinalize(dest)
    }
}

func createPath(path: String) -> Bool {
    // in /tmp
    // create /tmp/training/[0..9]
    do {
        let fm = FileManager()
        for i in 0...9 {
            try fm.createDirectory(at: URL(fileURLWithPath: "\(path)/\(i)"), withIntermediateDirectories: true, attributes: nil)
        }
    } catch let error {
        print(error)
        return false
    }
    return true
}

func createImages(dataPath: String, labelsPath:String, outputPath: String) -> Bool {
    let fm = FileManager()
    if let data = fm.contents(atPath: dataPath), let labels = fm.contents(atPath: labelsPath) {
        // get labels
        let labelsArray = labels.advanced(by: 8).map({String($0)})
        
        let digitSize = 28*28
        let grayscale = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo()

        for i in 0..<labelsArray.count {
            let from = 16 + (i * digitSize)
            let to = from + digitSize - 1
            var imageData = data.subdata(in: Range(from...to))
            imageData.withUnsafeMutableBytes { (bytes) in
                for i in 0..<digitSize {
                    bytes[i] = 255 - bytes[i] // convert each byte from big to small endian
                }
            }
            // get a bitmap
            let dataProvider = CGDataProvider(data: imageData as CFData)!
            if let image = CGImage(width: 28, height: 28, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: 28, space: grayscale, bitmapInfo: bitmapInfo, provider: dataProvider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)
            {
                //save file
                let url = URL(fileURLWithPath: "\(outputPath)/\(labelsArray[i])/\(i).png")
                writeCGImage(image: image, url: url)
            }
        }
        print("Created \(labelsArray.count) files in \(outputPath)")
        return true
    } else {
        print("Run ./dl_data.sh to get source files")
    }
    return false
}

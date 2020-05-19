//
//  RotateViewController.swift
//  PhotoEditorApp
//
//  Created by Администратор on 15.05.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

public struct RGBAPixel {
    public var raw: UInt32
}

class RotateViewController: UIViewController {
    
    var inputImage: UIImage!
    
    /*func toPixel(image: UIImage) -> [RGBAPixel] {
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let bitsPerComponent = 4
        let bytesPerRow = 4 * width
        let totalBytes = height * bytesPerRow
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let mutablePointer = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: width * height)
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: mutablePointer, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        let bufferPointer = UnsafeBufferPointer<RGBAPixel>(start: mutablePointer, count: totalBytes)
        let pixelValues = Array<RGBAPixel>(bufferPointer)
        return pixelValues
    }*/
    
    func toPixel(image: UIImage) -> UnsafePointer<UInt8> {
        let imageRef = image.cgImage
        let pixelData = imageRef?.dataProvider?.data
        let data : UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        return data
    }
    
    func toImage(data: UnsafePointer<UInt8>, width: Int, height: Int) -> UIImage {
        let im = UIImage()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        let bytesPerPixel = 1
        let bitsPerPixel = bytesPerPixel * bitsPerComponent
        let bytesPerRow = bytesPerPixel * width
        let totalBytes = height * bytesPerRow
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        guard let providerRef = CGDataProvider(data: Data(bytes: data, count: totalBytes) as CFData) else {
            return im
        }
        guard let imageRef = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, provider: providerRef, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent) else {
            return im
        }
        return UIImage.init(cgImage: imageRef)
    }
    
    @IBOutlet weak var degreeDisplay: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        if ((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func rotate(_ sender: UISlider) {
        degreeDisplay.text = String(Int(sender.value))
        let degree = sender.value
        let pixelValues = toPixel(image: inputImage)
        let width = Int(inputImage.size.width)
        let height = Int(inputImage.size.height)
        var rad = Double(degree) * .pi / 180.0
        var cosf = cos(rad)
        var sinf = sin(rad)
        
        var pixelArray = Array(UnsafeBufferPointer(start: pixelValues, count: width * height))
        
        var x1 = Int(-Double(height) * sinf)
        var y1 = Int(Double(height) * cosf)
        var x2 = Int(Double(width) * cosf - Double(height) * sinf)
        var y2 = Int(Double(height) * cosf + Double(width) * sinf)
        var x3 = Int(Double(width) * cosf)
        var y3 = Int(Double(width) * sinf)
        
        var minX = min(0, min(x1, min(x2, x3)))
        var minY = min(0, min(y1, min(y2, y3)))
        var maxX = max(0, max(x1, max(x2, x3)))
        var maxY = max(0, max(y1, max(y2, y3)))
        
        var w = maxX - minX
        var h = maxY - minY
        
        var newPixelArray = pixelArray
        
        for y in 0 ..< h {
            for x in 0 ..< w {
                var sourceX = Int(Double(x + minX) * cosf + Double(y + minY) * sinf)
                var sourceY = Int(Double(y + minY) * cosf - Double(x + minX) * sinf)
                if (sourceX >= 0 && sourceX < width && sourceY >= 0 && sourceY < height) {
                    newPixelArray[y * width + x] = pixelArray[sourceY * width + sourceX]
                } else {
                    newPixelArray[y * width + x] = 0
                }
            }
        }
        let newImage: UIImage = toImage(data: UnsafePointer<UInt8>(newPixelArray), width: width, height: height)
        let dest = storyboard?.instantiateViewController(withIdentifier: "PhotoEditorController") as! PhotoEditorController
        dest.imageViewSecond.image = newImage
    }
    
    /*@IBAction func rotate(_ sender: UISlider) {
        degreeDisplay.text = String(Int(sender.value))
        var degree = sender.value
        var pixelValues = toPixel(image: inputImage)
        var width = Int(inputImage.size.width)
        var height = Int(inputImage.size.height)
        var sin = Double(1)
        var cos = Double(0)
        var x0 = 0.5 * Double(width - 1)
        var y0 = 0.5 * Double(height - 1)
        var newPixelValues = Array<RGBAPixel>(repeating: 0, count: width * height)
        for x in 0 ..< width {
            for y in 0 ..< height {
                var a = Double(x) - x0
                var b = Double(y) - y0
                var xx = Int(a * cos - b * sin + x0)
                var yy = Int(a * sin + b * cos + y0)
                if xx >= 0 && xx < width && yy >= 0 && yy < height {
                    newPixelValues[x * width + y] = pixelValues[xx * width + yy]
                }
            }
        }
        
    }*/
    
}

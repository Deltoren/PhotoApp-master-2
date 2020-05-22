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
    var degree = 0
    
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
    
    func toPixel(image: UIImage) -> UnsafeMutableBufferPointer<UInt32> {
        let cgImage = image.cgImage
        let imageData = cgImage?.dataProvider?.data as Data?
        let size = Int(image.size.width) * Int(image.size.height)
        let buffer = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: size)
        imageData?.copyBytes(to: buffer)
        return buffer
    }

    func toImage(data: UnsafeMutableBufferPointer<UInt32>, width: Int, height: Int) -> UIImage {
        let ctx = CGContext(data: data.baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        return UIImage(cgImage: ctx.makeImage()!)
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
    
    
    @IBAction func rotateDisplay(_ sender: UISlider) {
        degree = Int(sender.value)
        degreeDisplay.text = String(degree)
    }
    
    @IBAction func rotate(_ sender: UIButton) {
        let width = Int(inputImage.size.width)
        let height = Int(inputImage.size.height)
        let rad = Double(degree) * .pi / 180.0
        let cosf = cos(rad)
        let sinf = sin(rad)
        
        let pixelArray = toPixel(image: inputImage)
        
        let x1 = Int(-Double(height) * sinf)
        let y1 = Int(Double(height) * cosf)
        let x2 = Int(Double(width) * cosf - Double(height) * sinf)
        let y2 = Int(Double(height) * cosf + Double(width) * sinf)
        let x3 = Int(Double(width) * cosf)
        let y3 = Int(Double(width) * sinf)
        
        let minX = min(0, min(x1, min(x2, x3)))
        let minY = min(0, min(y1, min(y2, y3)))
        let maxX = max(0, max(x1, max(x2, x3)))
        let maxY = max(0, max(y1, max(y2, y3)))
        
        let w = maxX - minX
        let h = maxY - minY
        
        var newPixelArray = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: w * h * 4)
        
        for y in 0 ..< h {
            for x in 0 ..< w {
                let sourceX = Int(Double(x + minX) * cosf + Double(y + minY) * sinf)
                let sourceY = Int(Double(y + minY) * cosf - Double(x + minX) * sinf)
                if (sourceX >= 0 && sourceX < width && sourceY >= 0 && sourceY < height) {
                    newPixelArray[y * w + x] = pixelArray[sourceY * width + sourceX]
                } else {
                    newPixelArray[y * w + x] = 0
                }
            }
        }
        let newImage: UIImage = toImage(data: newPixelArray, width: w, height: h)
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

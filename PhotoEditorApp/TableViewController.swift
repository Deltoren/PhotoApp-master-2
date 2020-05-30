//
//  TableViewController.swift
//  PhotoEditorApp
//
//  Created by Администратор on 13.05.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit
import CoreImage

class TableViewController: UITableViewController {
    
    var inputImage: UIImage!
    
    var nImage: UIImage!
    
    var original: UIImage!
    
    var mode: String!
    
    var degree: Int!
    
    let array = ["Sepia",
                 "Monochrome",
                 "Negative",
                 "Red",
                 "Blue",
                 "Green",
                 "Original Image"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
    }
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let textData = array[indexPath.row]
        cell.textLabel?.text = textData

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = storyboard?.instantiateViewController(withIdentifier: "PhotoEditorController") as! PhotoEditorController
        if array[indexPath.row] == "Monochrome" {
            mode = "monochrome"
            dest.newImage = filterImage(image: nImage)
            dest.inputImage = filterImage(image: inputImage)
            dest.originalImage = original
            dest.angle = degree
            self.present(dest, animated: false, completion: nil)
        }
        if array[indexPath.row] == "Sepia" {
            mode = "sepia"
            dest.newImage = filterImage(image: nImage)
            dest.inputImage = filterImage(image: inputImage)
            dest.originalImage = original
            dest.angle = degree
            self.present(dest, animated: false, completion: nil)
        }
        if array[indexPath.row] == "Negative" {
            mode = "negative"
            dest.newImage = filterImage(image: nImage)
            dest.inputImage = filterImage(image: inputImage)
            dest.originalImage = original
            dest.angle = degree
            self.present(dest, animated: false, completion: nil)
        }
        if array[indexPath.row] == "Red" {
            mode = "red"
            dest.newImage = filterImage(image: nImage)
            dest.inputImage = filterImage(image: inputImage)
            dest.originalImage = original
            dest.angle = degree
            self.present(dest, animated: false, completion: nil)
        }
        if array[indexPath.row] == "Blue" {
            mode = "blue"
            dest.newImage = filterImage(image: nImage)
            dest.inputImage = filterImage(image: inputImage)
            dest.originalImage = original
            dest.angle = degree
            self.present(dest, animated: false, completion: nil)
        }
        if array[indexPath.row] == "Green" {
            mode = "green"
            dest.newImage = filterImage(image: nImage)
            dest.inputImage = filterImage(image: inputImage)
            dest.originalImage = original
            dest.angle = degree
            self.present(dest, animated: false, completion: nil)
        }
        if array[indexPath.row] == "Original Image" {
            rotate()
        }
}
    
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
    
    func filterImage(image: UIImage) -> UIImage {
       
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let pixelArray = toPixel(image: image)
       
        for y in 0 ..< height {
            for x in 0 ..< width {
                let pixelInfo: Int = ((y * width) + x)
                let hexNumber = pixelArray[pixelInfo]
               
                let r = CGFloat(Int(hexNumber >> 16) & 0xFF)
                let g = CGFloat(Int(hexNumber >> 8) & 0xFF)
                let b = CGFloat(Int(hexNumber) & 0xFF)
                let a = CGFloat(1.0)
               
                let color = UIColor(red: r, green: g, blue: b, alpha: a)
               
                if mode == "monochrome" {
                    let avg = 0.3 * r + 0.59 * g + 0.11 * b
                    let newHexCode = UInt32(255.0) << 24 | UInt32(avg) << 16 | UInt32(avg) << 8 | UInt32(avg)
                    pixelArray[pixelInfo] = newHexCode
                }
               
                if mode == "sepia" {
                    var tr = CGFloat(0.393 * r + 0.769 * g + 0.189 * b)
                    var tg = CGFloat(0.349 * r + 0.686 * g + 0.168 * b)
                    var tb = CGFloat(0.272 * r + 0.534 * g + 0.131 * b)
                   
                    if tr > 255 {tr = CGFloat(255)}
                    if tg > 255 {tg = CGFloat(255)}
                    if tb > 255 {tb = CGFloat(255)}
                   
                    let newHexCode = UInt32(255.0) << 24 | UInt32(tb) << 16 | UInt32(tg) << 8 | UInt32(tr)
                    pixelArray[pixelInfo] = newHexCode
                }
                
                if mode == "negative" {
                    let newHexCode = UInt32(255.0) << 24 | UInt32(255.0 - b) << 16 | UInt32(255.0 - g) << 8 | UInt32(255.0 - r)
                    pixelArray[pixelInfo] = newHexCode
                }
                
                if mode == "red" {
                    let avg = 0.3 * r + 0.59 * g + 0.11 * b
                    let newHexCode = UInt32(255.0) << 24 | UInt32(r) << 16 | UInt32(g) << 8 | UInt32(255.0)
                    pixelArray[pixelInfo] = newHexCode
                }
                
                if mode == "green" {
                    let avg = 0.3 * r + 0.59 * g + 0.11 * b
                    let newHexCode = UInt32(255.0) << 24 | UInt32(r) << 16 | UInt32(255.0) << 8 | UInt32(b)
                    pixelArray[pixelInfo] = newHexCode
                }
                
                if mode == "blue" {
                    let avg = 0.3 * r + 0.59 * g + 0.11 * b
                    let newHexCode = UInt32(255.0) << 24 | UInt32(255.0) << 16 | UInt32(g) << 8 | UInt32(b)
                    pixelArray[pixelInfo] = newHexCode
                }
            }
        }
       
        let newImage: UIImage = toImage(data: pixelArray, width: width, height: height)
        return newImage
    }
    
    func rotate() {
        let width = Int(original.size.width)
        let height = Int(original.size.height)
        let rad = Double(degree) * .pi / 180.0
        let cosf = cos(rad)
        let sinf = sin(rad)
        
        let pixelArray = toPixel(image: original)
        
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
        dest.newImage = newImage
        dest.inputImage = original
        dest.originalImage = original
        dest.angle = degree
        self.present(dest, animated: false, completion: nil)
    }
}

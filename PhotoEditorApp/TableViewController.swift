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
    
    let array = ["Sepia",
                 "Black&White",
                 "Someone"]

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
        if array[indexPath.row] == "Sepia" {
            let cgimg = (inputImage?.ciImage)
            let gimage = cgimg?.applyingFilter("CISepiaTone")
            dest.newImage = UIImage(ciImage: gimage!)
            dest.inputImage = inputImage
            self.present(dest, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func filter(image: UIImage) -> UIImage {
        let mode = "monochrome"
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let pixelArray = toPixel(image: image)
        
        for y in 0 ..< width {
            for x in 0 ..< height {
                let pixelInfo: Int = ((y * width) + x)
                let hexNumber: UInt32 = pixelArray[pixelInfo]
                
                var r = CGFloat((hexNumber & 0xff000000) >> 16) / 255
                var g = CGFloat((hexNumber & 0x00ff0000) >> 8) / 255
                var b = CGFloat(hexNumber & 0x0000ff00) / 255
                
                if mode == "monochrome" {
                    let v = 0.3 * r + 0.59 * g + 0.11 * b
                    let newHexCode = UInt32(v * 255.0) << 16 | UInt32(v * 255.0) << 8 | UInt32(v * 255.0)
                    pixelArray[pixelInfo] = newHexCode
                }
                
                if mode == "sepia" {
                    let tr = 0.393 * r + 0.769 * g + 0.189 * b
                    let tg = 0.349 * r + 0.686 * g + 0.168 * b
                    let tb = 0.272 * r + 0.534 * g + 0.131 * b
                    var new_r, new_g, new_b : CGFloat
                    
                    let newHexCode = UInt32(tr * 255.0) << 16 | UInt32(tg * 255.0) << 8 | UInt32(tb * 255.0)
                    pixelArray[pixelInfo] = newHexCode
                }
                
                if mode == "negative" {
                    let newHexCode = UInt32((255.0 - r) * 255.0) << 16 | UInt32((255.0 - g) * 255.0) << 8 | UInt32((255.0 - b) * 255.0)
                    pixelArray[pixelInfo] = newHexCode
                }
            }
        }
        
        let newImage: UIImage = toImage(data: pixelArray, width: width, height: height)
        return newImage
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

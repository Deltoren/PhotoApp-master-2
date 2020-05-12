//
//  PhotoEditorController.swift
//  PhotoEditorApp
//
//  Created by Sergio Ramos on 03/05/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

class PhotoEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageViewSecond: UIImageView!
    
    var newImage: UIImage!
    
    @IBOutlet weak var userInfo: UIView!
    
    @IBOutlet weak var userInfoLabel: UILabel!
    
    @IBOutlet weak var userInfoText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewSecond.image = newImage
        view.setGradientBackground(colorOne: UIColor(red: 45.0/255.0, green: 0.0/255.0, blue: 95.0/255.0, alpha: 1.0), colorTwo: UIColor(red: 75.0/255.0, green: 40.0/255.0, blue: 85.0/255.0, alpha: 1.0))
        userInfo.isHidden = true
    }
    
    @IBAction func turnButton(_ sender: UIButton) {
        userInfo.isHidden = false
        userInfoLabel.text = "Введите нужный градус"
    }
    
    
    
    // дальше инструкции для всех кнопок
    
    @IBAction func okButton(_ sender: UIButton) {
        if userInfoText.text != "" {
            let angle = userInfoText.text
            var corner: CGFloat = CGFloat((angle as! NSString).doubleValue)
            corner *= .pi / 180
            imageViewSecond.image = imageViewSecond.image?.rotate(radians: Float(corner))
            userInfo.isHidden = true
        }
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        context.rotate(by: CGFloat(radians))
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

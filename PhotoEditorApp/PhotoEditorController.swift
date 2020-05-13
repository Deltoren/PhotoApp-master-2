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
    
    @IBOutlet weak var filter: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewSecond.image = newImage
        view.setGradientBackground(colorOne: UIColor(red: 45.0/255.0, green: 0.0/255.0, blue: 95.0/255.0, alpha: 1.0), colorTwo: UIColor(red: 75.0/255.0, green: 40.0/255.0, blue: 85.0/255.0, alpha: 1.0))
        
        // TableView
        setupGesture()
    }
    
    // TableView
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.numberOfTapsRequired = 1
        filter.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func tapped() {
        guard let tableVC = storyboard?.instantiateViewController(withIdentifier: "tableVC") else {return}
        tableVC.modalPresentationStyle = .popover
        let tableOverVC = tableVC.popoverPresentationController
        tableOverVC?.delegate = self
        tableOverVC?.sourceView = self.filter
        tableOverVC?.sourceRect = CGRect(x: self.filter.bounds.midX, y:self.filter.bounds.minY, width: 0, height: 0)
        tableVC.preferredContentSize = CGSize(width: 250, height: 61)
        self.present(tableVC, animated: true)
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


// TableView
extension PhotoEditorController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

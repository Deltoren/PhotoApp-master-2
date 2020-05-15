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
    
    
    @IBAction func backToStartPage(_ sender: UIButton) {
        if ((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    @IBAction func savePhoto(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(imageViewSecond.image!, nil, nil, nil)
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
        tableVC.preferredContentSize = CGSize(width: 250, height: 100)
        self.present(tableVC, animated: true)
    }
}


// TableView
extension PhotoEditorController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

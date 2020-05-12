//
//  ViewController.swift
//  PhotoEditorApp
//
//  Created by Sergio Ramos on 29/04/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var seg: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seg.isEnabled = false;
        view.setGradientBackground(colorOne: UIColor(red: 45.0/255.0, green: 0.0/255.0, blue: 95.0/255.0, alpha: 1.0), colorTwo: UIColor(red: 75.0/255.0, green: 40.0/255.0, blue: 85.0/255.0, alpha: 1.0))
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel",
        style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style:
           .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true,
                completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let photoLibraryAction = UIAlertAction(title: "Gallery", style: .default, handler: { action in
                        imagePicker.sourceType = .photoLibrary
                        self.present(imagePicker, animated: true,
                        completion: nil)
                    })
                    alertController.addAction(photoLibraryAction)
                }
        present(alertController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let selectedImage =
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            seg.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditorPage" {
            let dvc = segue.destination as! PhotoEditorController
            dvc.newImage = imageView.image!
        }
    }
}


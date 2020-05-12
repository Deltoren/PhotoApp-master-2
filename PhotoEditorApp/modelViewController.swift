//
//  modelViewController.swift
//  PhotoEditorApp
//
//  Created by Sergio Ramos on 05/05/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class modelViewController: UIViewController, ARSCNViewDelegate {
    
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    func setUpBox() {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let colours = [UIColor.purple, .blue, .red, .green, .orange, .yellow]
        let boxMaterials = colours.map({ (colour) -> SCNMaterial in
            let material = SCNMaterial()
            material.diffuse.contents = colour
            return material
        })
        box.materials = boxMaterials
        let boxNode = SCNNode(geometry: box)
        let rotateOnce = SCNAction.rotateBy(x: 0, y: 2*CGFloat.pi, z: 0, duration: 3)
        let rotateForever = SCNAction.repeatForever(rotateOnce)
        boxNode.position = SCNVector3(0, 0, -0.5)
        boxNode.runAction(rotateForever)
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
}

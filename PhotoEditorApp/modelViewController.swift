//
//  modelViewController.swift
//  PhotoEditorApp
//
//  Created by Sergio Ramos on 05/05/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit
import SceneKit

class modelViewController: UIViewController {
    
    @IBOutlet weak var sceneView: SCNView!
    
    var geometryNode: SCNNode = SCNNode()
    
    var currentAngle: Float = 0.0
    
    
    override func viewDidLoad() {
        let scene = SCNScene()
        sceneView.scene = scene
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(0, 0, 15)
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        var geometries = [
            SCNBox(width: 4.0, height: 4.0, length: 4.0, chamferRadius: 0.3),
        ]
        var materials = [SCNMaterial]()
        for i in 0...6 {
            let material = SCNMaterial()
            if i == 1 {material.diffuse.contents = UIImage(named: "count1")}
            if i == 2 {material.diffuse.contents = UIImage(named: "count2")}
            if i == 3 {material.diffuse.contents = UIImage(named: "count3")}
            if i == 4 {material.diffuse.contents = UIImage(named: "count4")}
            if i == 5 {material.diffuse.contents = UIImage(named: "count5")}
            if i == 0 {material.diffuse.contents = UIImage(named: "count6")}
            materials.append(material)
        }
        for i in 0..<geometries.count {
            let geometry = geometries[i]
            let node = SCNNode(geometry: geometry)
            node.geometry?.materials = materials
            node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 2, y: 2, z: 1, duration: 5)))
            node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 1, y: 2, z: 0, duration: 15)))
            scene.rootNode.addChildNode(node)
        }
    }
    func panGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!)
        var newAngle = (Float)(translation.x)*(Float)(M_PI)/180.0
        newAngle += currentAngle
        geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
        if (sender.state == UIGestureRecognizer.State.ended) {
            currentAngle = newAngle
        }
    }
}

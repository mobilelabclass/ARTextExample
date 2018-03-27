//
//  ViewController.swift
//  ARTextExample
//
//  Created by Sebastian Buys on 3/26/18.
//  Copyright © 2018 mobilelab. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, UITextFieldDelegate, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // Actually not using this, but it's called whenever the text field changes value
    @IBAction func didChangeTextField(_ sender: UITextField) {
    }
    
    // Delegate method implementing the UITextFieldDelegate UITextFieldDelegate
    // This method is called when the user presses "Done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        if let text = textField.text {
            createTextNode(text)
        }
        
        // Clear out the text
        textField.text = ""
        
        return false
    }
    
    func createTextNode(_ text: String) {
        // Create text geometry
        let textGeometry = SCNText(string: text, extrusionDepth: 0.0)

        // 1 text unit is 1 scene unit, so scale text down later according to the size here
        textGeometry.font = UIFont (name: "Helvetica", size: 10.0)
        textGeometry.flatness = 0.0
        
        // Double sided material
        textGeometry.firstMaterial?.isDoubleSided = true
       
        // Get point of view
        guard let pov = sceneView.pointOfView else {
            print("Unable to get pov")
            return
        }
        
        // Create node from geometry
        let textNode = SCNNode(geometry: textGeometry)

        // Position the text just in front of the camera
        textNode.simdPosition = pov.simdPosition + pov.simdWorldFront * 0.5
        textNode.simdRotation = pov.simdRotation
        
        // Scale down the text
        textNode.scale = SCNVector3Make(0.01, 0.01, 0.01)
        
        // Change pivot point of text so that it is centered
        // See: https://stackoverflow.com/questions/45168896/scenekit-scntext-centering-incorrectly
        let (minVec, maxVec) = textNode.boundingBox
        textNode.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)

        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

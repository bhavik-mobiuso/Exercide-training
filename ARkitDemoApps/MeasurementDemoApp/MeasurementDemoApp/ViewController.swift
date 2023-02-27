//
//  ViewController.swift
//  MeasurementDemoApp
//
//  Created by Bhavik on 16/02/23.
//

import UIKit
import ARKit
import RealityKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneKitView: ARSCNView!
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    var meterValue: Double?
    let configuration =  ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneKitView.delegate = self
        sceneKitView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = ARWorldTrackingConfiguration()
        sceneKitView.session.run(config)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneKitView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodes.count > 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
        }
        
        if let touchLocation = touches.first?.location(in: sceneKitView) {
            let hitTestResuts = sceneKitView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult =  hitTestResuts.first {
                addDot(at: hitResult)
            }
            
//            let estimatePlan: ARRaycastQuery.Target = .estimatedPlane
//            let alignment: ARRaycastQuery.TargetAlignment = .any
//            
//            let query: ARRaycastQuery? = sceneKitView.raycastQuery(from: touchLocation, allowing: estimatePlan, alignment: alignment)
//            
//            if let nonOptQuery: ARRaycastQuery = query {
//                var result: [ARRaycastResult] = sceneKitView.session.raycast(nonOptQuery)
//                
//                
//                guard let rayCast: ARRaycastResult = result.first
//                else { return }
//
//                addDot(at: rayCast)
//
//            }
        }
    }
    
    func addDot(at hitResult:  ARHitTestResult) {
        let dotGeometry     = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        
        
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x ,hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.z )
        sceneKitView.scene.rootNode.addChildNode(dotNode)
        dotNodes.append(dotNode)
        
        if dotNodes.count > 2 {
            calculate()
        }
        
    }
    
    func calculate() {
        
        let startNode = dotNodes[0]
        let endNode = dotNodes[1]
        
        print(startNode)
        print(endNode)
        
        let distance  = sqrt(
            pow(endNode.position.x - startNode.position.x, 2) +
                             pow(endNode.position.y - startNode.position.x, 2) +
                             pow(endNode.position.z - startNode.position.x, 2)
        )
        
        meterValue = Double(abs(distance))
        
        let heightMeter =  Measurement(value: meterValue ?? 0 , unit: UnitLength.meters)
        
        let heightCentimeter = heightMeter.converted(to: UnitLength.centimeters)
        
        let value = "\(heightCentimeter)"
        
        let finalMeasurement = String(value.prefix(6))
        
        updateText(text:"\(finalMeasurement)cm",atPosition: endNode.position)
        
        
    }
    
    func  updateText(text: String, atPosition position:SCNVector3) {
        textNode.removeFromParentNode()
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        textNode = SCNNode(geometry: textGeometry)
        textNode.position  = SCNVector3(x: position.x, y: position.y + 0.01, z: position.z)
        textNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        sceneKitView.scene.rootNode.addChildNode(textNode)
        
    }
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        
        restartSession()
        
    }
    @IBAction func calculateBtnTapped(_ sender: UIButton) {
        
        calculate()
        
    }
    
    func restartSession() {
        self.sceneKitView.session.pause()
        sceneKitView.scene.rootNode.enumerateChildNodes {   (node, _) in
            node.removeFromParentNode()
            
        }
        self.sceneKitView.session.run(configuration, options: [.resetTracking,.removeExistingAnchors])
    }
}


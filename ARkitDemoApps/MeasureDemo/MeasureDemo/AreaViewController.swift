//
//  AreaViewController.swift
//  MeasureDemo
//
//  Created by Bhavik on 28/02/23.
//

import UIKit
import ARKit

class AreaViewController: MeasureViewController {

    
    var lengthNodes = NSMutableArray()
    var lineNodes = NSMutableArray()
    var startNode: SCNNode?
    var lineNode: SCNNode?
    
    var isStartPointSelected: Bool = false
    
    var allPointNodes: [Any] {
        get {
            return lengthNodes as! [Any]
        }
    }
    @IBOutlet weak var areaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    //New updated code
    
    func hitResult() -> SCNVector3? {
        
        let results = sceneView.hitTest(view.center, types: .existingPlaneUsingExtent)
        
        
        for result in results {
            let hitPosition = self.positionFromTransform(result.worldTransform)
            return hitPosition
        }
        return SCNVector3()
    }
    
    func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3{
        return SCNVector3Make(transform.columns.3.x,
                              transform.columns.3.y,
                              transform.columns.3.z)
    }
    
    func nodeWithPosition(_ position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: 0.003)
        
        sphere.firstMaterial?.diffuse.contents = UIColor.white
        sphere.firstMaterial?.lightingModel = .constant
        sphere.firstMaterial?.isDoubleSided = true
        
        
        let node = SCNNode(geometry: sphere)
        node.position = position
        
        return node
    }
    
    
    //MARK: - IBActions
    
    @IBAction func addPoint(_ sender: UIButton) {
        print("Add Button Tapped")
        if let position: SCNVector3 = self.hitResult()  {
            let node = self.nodeWithPosition(position)
            sceneView.scene.rootNode.addChildNode(node)
                
            
            if !isStartPointSelected {
                startNode = node
                isStartPointSelected = true
            }
            else {
                guard let curretPosition = self.hitResult(), let start = self.startNode else {
                    return
                }
                self.lineNode = self.getDrawnLineFrom(pos1: curretPosition,pos2: start.position)
                self.sceneView.scene.rootNode.addChildNode(self.lineNode!)
                startNode = nil
                isStartPointSelected = false
            }
        }
        
    }
    @IBAction func resetButtonTap(_ sender: UIButton) {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
        node.removeFromParentNode() }
        
        self.lineNode?.removeFromParentNode()

    }
    
    @IBAction func calculateBtnTap(_ sender: Any) {
        
    }
    
}

extension AreaViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        DispatchQueue.main.async {
            
            guard let curretPosition = self.hitResult(), let start = self.startNode else {
                return
            }
            self.lineNode?.removeFromParentNode()
            self.lineNode = self.getDrawnLineFrom(pos1: curretPosition,pos2: start.position)
            self.sceneView.scene.rootNode.addChildNode(self.lineNode!)
            
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
    }
}

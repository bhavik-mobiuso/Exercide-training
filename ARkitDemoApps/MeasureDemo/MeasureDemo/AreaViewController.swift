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
    var endNode: SCNNode?
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
    
    func hitResult(forPoint point: CGPoint) -> SCNVector3? {
        let hitTestResults = sceneView.hitTest(point, types: .featurePoint)
        if let result = hitTestResults.first {
            let vector = result.worldTransform.columns.3
            return SCNVector3(vector.x, vector.y, vector.z)
        } else {
            return nil
        }
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
        let pointLocation = view.convert(screenCenterPoint, to: sceneView)
        if let position: SCNVector3 = sceneView.hitResult(forPoint: pointLocation)  {
            let node = self.nodeWithPosition(position)
            sceneView.scene.rootNode.addChildNode(node)
                
            
            if !isStartPointSelected {
                startNode = node
                isStartPointSelected = true
            }
            else {
                endNode = node
                let distance = getDistanceStringBetween(pos1: startNode!.position, pos2: endNode!.position)
                print(distance)
                
                addText(text: distance, pos: startNode!.position)
                guard let curretPosition = sceneView.hitResult(forPoint: pointLocation), let start = self.startNode else {
                    return
                }
                self.lineNode = self.getDrawnLineFrom(pos1: curretPosition,pos2: start.position)
                self.sceneView.scene.rootNode.addChildNode(self.lineNode!)
                startNode = nil
                isStartPointSelected = false
                
            }
        }
        
    }
    @IBAction func resetBtnTap(_ sender: UIButton) {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
        node.removeFromParentNode() }
        self.lineNode?.removeFromParentNode()

    }
    
    @IBAction func capturePhotoBtnTap(_ sender: UIButton) {
        
        print("CapturePhotoBtnTap")
        
        let renderedImg = self.sceneView.snapshot()
        UIImageWriteToSavedPhotosAlbum(renderedImg, nil, nil, nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.showToast(message: "Photo saved to cameraroll")
        })
        
    }
    
}

extension AreaViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let dotNodes = allPointNodes as! [SCNNode]
        if dotNodes.count > 0, let currentCameraPosition = self.sceneView.pointOfView {
            updateScaleFromCameraForNodes(dotNodes, fromPointOfView: currentCameraPosition)
        }
        
        DispatchQueue.main.async {
            let pointLocation = self.view.convert(self.screenCenterPoint, to: self.sceneView)
            
            guard let curretPosition = self.hitResult(forPoint: pointLocation), let start = self.startNode else {
                return
            }
            self.lineNode?.removeFromParentNode()
            self.lineNode = self.getDrawnLineFrom(pos1: curretPosition,pos2: start.position)
            self.sceneView.scene.rootNode.addChildNode(self.lineNode!)
            
        }
        
    }
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
            case .normal:
                break
            default:
                break
        }
    }
}

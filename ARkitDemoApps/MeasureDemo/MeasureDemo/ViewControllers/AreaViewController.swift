//
//  AreaViewController.swift
//  MeasureDemo
//
//  Created by Bhavik on 28/02/23.
//

import UIKit
import ARKit

class AreaViewController: MeasureViewController {
    
    fileprivate lazy var vectorZero = SCNVector3()
    fileprivate lazy var startValue = SCNVector3()
    fileprivate lazy var endValue = SCNVector3()
    fileprivate var currentLine: Line?
    fileprivate lazy var unit: DistanceUnit = .meter
    fileprivate lazy var lines: [Line] = []
    fileprivate lazy var startNodes: [SCNNode]  = []
    fileprivate lazy var endNodes: [SCNNode]  = []
    var planes = [ARPlaneAnchor: Plane]()
    var isMeasuring: Bool = false
    var statusLabel = UILabel()
    var trackingState: ARCamera.TrackingState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        addPointBtn.isHighlighted = true
        addPointBtn.isEnabled = false
        changeBtnMode(isEnabled: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
    }
    //MARK: - IBActions
    
    @IBAction func addPoint(_ sender: UIButton) {
        
        statusLabel.removeFromSuperview()
            if !isMeasuring {
                isMeasuring = true
            }
            else {
                if let line = currentLine {
                    lines.append(line)
                    currentLine = nil
                }
                changeBtnMode(isEnabled: true)
                startValue = SCNVector3()
                isMeasuring = false
            }
    }
    
    @IBAction func undoBtnTap(_ sender: UIButton){
        if lines.count > 0 {
            let lastLine = lines.last
            lines.removeLast()
            sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
                if let lastLine = lastLine {
                    lastLine.removeFromParentNode()
                }
            }
            
            if lines.isEmpty {
                changeBtnMode(isEnabled: false)
            }
            else {
                changeBtnMode(isEnabled: true)
            }
           
        }
    }
    
    @IBAction func clearBtnTap(_ sender: UIButton) {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
        node.removeFromParentNode() }
        self.currentLine?.removeFromParentNode()
        changeBtnMode(isEnabled: false)
    }
    
    @IBAction func capturePhotoBtnTap(_ sender: UIButton) {
        
        print("CapturePhotoBtnTap")
        if lines.count > 0 {
            let renderedImg = self.sceneView.snapshot()
            UIImageWriteToSavedPhotosAlbum(renderedImg, nil, nil, nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.showToast(message: "Photo saved to cameraroll")
            })
        }
    }
    
    @IBAction func unitBtnTap(_ sender: UIButton) {
        
        let alertVC = UIAlertController(title: "Settings", message: "Please select distance unit options", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: DistanceUnit.centimeter.title, style: .default) { [weak self] _ in
            self?.unit = .centimeter
        })
        alertVC.addAction(UIAlertAction(title: DistanceUnit.inch.title, style: .default) { [weak self] _ in
            self?.unit = .inch
        })
        alertVC.addAction(UIAlertAction(title: DistanceUnit.meter.title, style: .default) { [weak self] _ in
            self?.unit = .meter
        })
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    fileprivate func detectObjects() {
        
        let pointLocation = view.convert(screenCenterPoint, to: sceneView)
        if let position: SCNVector3 = sceneView.hitResult(forPoint: pointLocation){
            if isMeasuring {
                if startValue == vectorZero {
                    startValue = position
                    currentLine = Line(sceneView: sceneView, startVector: startValue, unit: unit)
                }
                endValue = position
                currentLine?.update(to: endValue)
                //messageLabel.text = currentLine?.distance(to: endValue) ?? "Calculating…"
            }
        }
        
    }
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = Plane(anchor)
        planes[anchor] = plane
        node.addChildNode(plane)
        DispatchQueue.main.async {
            self.statusLabel.removeFromSuperview()
            self.addPointBtn.isHighlighted = false
            self.addPointBtn.isEnabled = true
            self.showStatusMsg(text: "Ready to measure")
            
        }
    }
    
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
            plane.update(anchor)
        }
    }
    
    func changeBtnMode(isEnabled: Bool) {
        DispatchQueue.main.async {
            self.clearBtn.isHighlighted = !isEnabled
            self.clearBtn.isEnabled = isEnabled
            self.captureBtn.isHighlighted = !isEnabled
            self.captureBtn.isEnabled = isEnabled
            self.undoBtn.isHighlighted = !isEnabled
            self.undoBtn.isEnabled = isEnabled
        }
    }
    
    func showStatusMsg(text: String) {
        statusLabel.removeFromSuperview()
        statusLabel.text = text
        statusLabel.numberOfLines = 5
        statusLabel.clipsToBounds = true
        statusLabel.layer.cornerRadius = 2
        statusLabel.textColor = .white
        statusLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        statusLabel.textAlignment = .center
        self.view.addSubview(statusLabel)
        let maxSize = CGSize(width: 150, height: 300)
        let size = statusLabel.sizeThatFits(maxSize)
        statusLabel.frame = CGRect(origin: CGPoint(x: 10, y: view.bounds.minY + 200), size: size)
        statusLabel.center.x = view.center.x
    }
    
    func describeStates() {
        if let tState = trackingState {
            switch tState {
                case .normal:
                    print("Noraml scenario")
                    showStatusMsg(text: "Move your phone on surface")
                case .notAvailable:
                    print("Tracking unavailable")
                    showStatusMsg(text: "Tracking is unavailable")
                    
                case .limited(let reason):
                    
                    switch reason {
                    case .excessiveMotion:
                        print("To much camera movement")
                        showStatusMsg(text: "Please stable your camera")
                    case .insufficientFeatures:
                        print("Not enough surface detail")
                        showStatusMsg(text: "Not Enough surface detaill")
                    case .initializing:
                        print("Intializing")
                        statusLabel.removeFromSuperview()
                        
                    default :
                        break
                }
            }
        }
    }
    
}
extension AreaViewController: ARSCNViewDelegate, ARSessionDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async { [weak self] in
            self?.detectObjects()
        }
    }
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        trackingState = camera.trackingState
        self.describeStates()
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.updatePlane(anchor: planeAnchor)
            }
            else {
                print("not detected")
            }
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        addPlane(node: node, anchor: anchor as! ARPlaneAnchor)
    }
}

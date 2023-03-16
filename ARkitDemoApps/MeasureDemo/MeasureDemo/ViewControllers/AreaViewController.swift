//
//  AreaViewController.swift
//  MeasureDemo
//
//  Created by Bhavik on 28/02/23.
//

import UIKit
import ARKit

class AreaViewController: MeasureViewController {
    
    lazy var vectorZero = SCNVector3()
    lazy var startValue = SCNVector3()
    lazy var endValue = SCNVector3()
    var currentLine: Line?
    lazy var unit: DistanceUnit = .meter
    lazy var lines: [Line] = []
    lazy var startNodes: [SCNNode]  = []
    lazy var endNodes: [SCNNode]  = []
    var planes = [ARPlaneAnchor: Plane]()
    var isMeasuring: Bool = false
    var statusLabel = UILabel()
    var trackingState: ARCamera.TrackingState!
    let coachingOverlay = ARCoachingOverlayView()
    let virtualObjectLoader = VirtualObjectLoader()
    var focusSquare = FocusSquare()
    let updateQueue = DispatchQueue(label: "com.mobiuso.VisionDem1.serialSceneKitQueue")
    var session: ARSession {
        return sceneView.session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        addPointBtn.isHighlighted = true
        addPointBtn.isEnabled = false
        changeBtnMode(isEnabled: false)
        setupCoachingOverlay()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func detectObjects() {
        
        let pointLocation = view.convert(screenCenterPoint, to: sceneView)
        if let position: SCNVector3 = sceneView.hitResult(forPoint: pointLocation){
            self.addPointBtn.isHighlighted = false
            self.addPointBtn.isEnabled = true
            self.statusLabel.removeFromSuperview()
            self.showStatusMsg(text: "Surface is Detected press + to start")
            if isMeasuring {
                if startValue == vectorZero {
                    self.statusLabel.removeFromSuperview()
                    startValue = position
                    currentLine = Line(sceneView: sceneView, startVector: startValue, unit: unit)
                }
                endValue = position
                currentLine?.update(to: endValue)
                //messageLabel.text = currentLine?.distance(to: endValue) ?? "Calculating…"
            }
        }
        else {
            self.addPointBtn.isHighlighted = true
            self.addPointBtn.isEnabled = false
            self.showStatusMsg(text: "Surface Not Detect please move your phone surface")
        }
        
    }
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = Plane(anchor)
        planes[anchor] = plane
        print(plane.planeAnchor.alignment)
        node.addChildNode(plane)
        DispatchQueue.main.async {
            self.statusLabel.removeFromSuperview()
            self.addPointBtn.isHighlighted = false
            self.addPointBtn.isEnabled = true
        }
    }
    
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
            plane.update(anchor)
        }
    }
}
extension ARSCNView {
    /**
     Type conversion wrapper for original `unprojectPoint(_:)` method.
     Used in contexts where sticking to SIMD3<Float> type is helpful.
     */
    func unprojectPoint(_ point: SIMD3<Float>) -> SIMD3<Float> {
        return SIMD3<Float>(unprojectPoint(SCNVector3(point)))
    }
    
    // - Tag: CastRayForFocusSquarePosition
    func castRay(for query: ARRaycastQuery) -> [ARRaycastResult] {
        return session.raycast(query)
    }

    // - Tag: GetRaycastQuery
    func getRaycastQuery(for alignment: ARRaycastQuery.TargetAlignment = .any) -> ARRaycastQuery? {
        return raycastQuery(from: screenCenter, allowing: .estimatedPlane, alignment: alignment)
    }
    
    var screenCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
}

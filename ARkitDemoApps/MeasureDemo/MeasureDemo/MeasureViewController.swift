//
//  MeasureViewController.swift
//  MeasureDemo
//
//  Created by Bhavik on 28/02/23.
//

import UIKit
import ARKit

class MeasureViewController: UIViewController {

    @IBOutlet weak var centerPointImageView: UIImageView!
    @IBOutlet weak var sceneView: MeasureSCNView!
    
    lazy var screenCenterPoint: CGPoint = {
        return centerPointImageView.center
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.pause()
        super.viewWillDisappear(animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Helper methods

    func getDrawnLineFrom(pos1: SCNVector3, pos2: SCNVector3) -> SCNNode {
        let line = generateLine(startPoint: pos1, endPoint: pos2)
        let lineInBetween1 = SCNNode(geometry: line)
        return lineInBetween1
    }
    
//    func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
//
//        let indices : [Int32] = [0,1]
//        let source = SCNGeometrySource(vertices: [vector1,vector2])
//        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
//
//        return SCNGeometry(sources: [source], elements: [element])
//    }
    
    func generateLine( startPoint: SCNVector3, endPoint: SCNVector3) -> SCNGeometry {
            
            let vertices: [SCNVector3] = [startPoint, endPoint]
            let data = NSData(bytes: vertices, length: MemoryLayout<SCNVector3>.size * vertices.count) as Data
            
            let vertexSource = SCNGeometrySource(data: data,
                                                 semantic: .vertex,
                                                 vectorCount: vertices.count,
                                                 usesFloatComponents: true,
                                                 componentsPerVector: 3,
                                                 bytesPerComponent: MemoryLayout<Float>.size,
                                                 dataOffset: 0,
                                                 dataStride: MemoryLayout<SCNVector3>.stride)
            
            let indices: [Int32] = [ 0, 1]
            
            let indexData = NSData(bytes: indices, length: MemoryLayout<Int32>.size * indices.count) as Data
            
            let element = SCNGeometryElement(data: indexData,
                                             primitiveType: .line,
                                             primitiveCount: indices.count/2,
                                             bytesPerIndex: MemoryLayout<Int32>.size)
            
            return SCNGeometry(sources: [vertexSource], elements: [element])
            
        }
    
    
    func getDistanceStringBetween(pos1: SCNVector3, pos2: SCNVector3) -> String {
        
        let d = self.distanceBetweenPoints(A: pos1, B: pos2)
        var result = ""
                
        let meter = stringValue(v: Float(d), unit: "meters")
        result.append(meter)
        result.append("\n")
        
        let f = self.foot_fromMeter(m: Float(d))
        let feet = stringValue(v: Float(f), unit: "feet")
        result.append(feet)
        result.append("\n")
        
        let inch = self.Inch_fromMeter(m: Float(d))
        let inches = stringValue(v: Float(inch), unit: "inch")
        result.append(inches)
        result.append("\n")
        
        let cm = self.CM_fromMeter(m: Float(d))
        let cms = stringValue(v: Float(cm), unit: "cm")
        result.append(cms)
        
        return result
    }
    
    /**
     Distance between 2 points
     */
    func distanceBetweenPoints(A: SCNVector3, B: SCNVector3) -> CGFloat {
        let l = sqrt(
                    (A.x - B.x) * (A.x - B.x) +
                    (A.y - B.y) * (A.y - B.y) +
                    (A.z - B.z) * (A.z - B.z)
        )
        return CGFloat(l)
    }
    
    /**
     String with float value and unit
     */
    func stringValue(v: Float, unit: String) -> String {
        let s = String(format: "%.1f %@", v, unit)
        return s
    }
    
    /**
     Inch from meter
     */
    func Inch_fromMeter(m: Float) -> Float {
        let v = m * 39.3701
        return v
    }
    
    /**
     centimeter from meter
     */
    func CM_fromMeter(m: Float) -> Float {
        let v = m * 100.0
        return v
    }
    
    /**
     feet from meter
     */
    func foot_fromMeter(m: Float) -> Float {
        let v = m * 3.28084
        return v
    }
    
    
    func addText(text: String,pos: SCNVector3) {
        let text = SCNText(string: text, extrusionDepth: 2)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        text.materials = [material]
        let node = SCNNode()
        node.position = SCNVector3(x:0, y:0.02, z:-0.1)
        node.scale = SCNVector3(x:0.01, y:0.01, z:0.01)
        node.geometry = text
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    func updateScaleFromCameraForNodes(_ nodes: [SCNNode], fromPointOfView pointOfView: SCNNode){
        
        nodes.forEach { (node) in
            
            //1. Get The Current Position Of The Node
            let positionOfNode = SCNVector3ToGLKVector3(node.worldPosition)
            
            //2. Get The Current Position Of The Camera
            let positionOfCamera = SCNVector3ToGLKVector3(pointOfView.worldPosition)
            
            //3. Calculate The Distance From The Node To The Camera
            let distanceBetweenNodeAndCamera = GLKVector3Distance(positionOfNode, positionOfCamera)
            
            //4. Animate Their Scaling & Set Their Scale Based On Their Distance From The Camera
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            switch distanceBetweenNodeAndCamera {
            case 0 ... 0.5:
                node.simdScale = simd_float3(0.25, 0.25, 0.25)
            case 0.5 ... 1.5:
                node.simdScale = simd_float3(0.5, 0.5, 0.5)
            case 1.5 ... 2.5:
                node.simdScale = simd_float3(1, 1, 1)
            case 2.5 ... 3:
                node.simdScale = simd_float3(1.5, 1.5, 1.5)
            case 3 ... 3.5:
                node.simdScale = simd_float3(2, 2, 2)
            case 3.5 ... 5:
                node.simdScale = simd_float3(2.5, 2.5, 2.5)
            default:
                node.simdScale = simd_float3(3, 3, 3)
            }
            SCNTransaction.commit()
        }
        
    }
}

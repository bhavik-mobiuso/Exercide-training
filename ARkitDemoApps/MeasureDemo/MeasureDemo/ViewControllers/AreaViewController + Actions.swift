//
//  AreaViewController + Actionns.swift
//  MeasureDemo
//
//  Created by Bhavik on 15/03/23.
//

import Foundation
import UIKit
import ARKit

extension AreaViewController {
    
    //MARK: Actions
    
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
            for line in lines {
                line.removeFromParentNode()
            }
        }
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
        alertVC.addAction(UIAlertAction(title: DistanceUnit.meter.title, style: .default) { [weak self] _ in
            self?.unit = .meter
        })
        alertVC.addAction(UIAlertAction(title: DistanceUnit.inch.title, style: .default) { [weak self] _ in
            self?.unit = .inch
        })
        alertVC.addAction(UIAlertAction(title: DistanceUnit.foot.title, style: .default) { [weak self] _ in
            self?.unit = .foot
        })
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // status message
    
    func showStatusMsg(text: String) {
        statusLabel.removeFromSuperview()
        statusLabel.text = text
        statusLabel.numberOfLines = 5
        statusLabel.clipsToBounds = true
        statusLabel.layer.cornerRadius = 10
        statusLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        statusLabel.textColor = .lightGray
        statusLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        statusLabel.textAlignment = .center
        self.view.addSubview(statusLabel)
        let maxSize = CGSize(width: 150, height: 300)
        var size = statusLabel.sizeThatFits(maxSize)
        size.width = size.width + 15.0
        size.height = size.height + 10.0
        statusLabel.frame = CGRect(origin: CGPoint(x: 10, y: view.bounds.minY + 200), size: size)
        statusLabel.center.x = view.center.x
    }
    
    func describeStates() {
        if let tState = trackingState {
            switch tState {
                case .normal:
                    print("Noraml scenario")
                    //self.showStatusMsg(text: "Ready to measure")
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
    
    func updateFocusSquare(isObjectVisible: Bool) {
        if isObjectVisible || coachingOverlay.isActive {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
            //statusViewController.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
        }
        
        // Perform ray casting only when ARKit tracking is in a good state.
        if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
            let query = sceneView.getRaycastQuery(),
            let result = sceneView.castRay(for: query).first {
            
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(raycastResult: result, camera: camera)
            }
            if !coachingOverlay.isActive {
                addPointBtn.isEnabled = true
                addPointBtn.isHighlighted = false
            }
            //statusViewController.cancelScheduledMessage(for: .focusSquare)
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            addPointBtn.isEnabled = false
            addPointBtn.isHighlighted = true
        }
    }
}

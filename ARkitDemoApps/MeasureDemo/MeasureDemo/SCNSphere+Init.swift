//
//  SCNSphere.swift
//  MeasureDemo
//
//  Created by Bhavik on 28/02/23.
//

import Foundation
import SceneKit

extension SCNSphere {
    convenience init(color: UIColor, radius: CGFloat) {
        self.init(radius: radius)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        materials = [material]
    }
}

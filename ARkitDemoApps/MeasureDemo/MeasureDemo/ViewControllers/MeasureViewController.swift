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
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var captureBtn: UIButton!
    @IBOutlet weak var undoBtn: UIButton!
    @IBOutlet weak var addPointBtn: UIButton!
    
    lazy var screenCenterPoint: CGPoint = {
        return centerPointImageView.center
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearBtn.layer.cornerRadius = 10
        undoBtn.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.pause()
        super.viewWillDisappear(animated)
    }
}

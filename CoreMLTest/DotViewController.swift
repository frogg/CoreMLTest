//
//  ViewController.swift
//  CoreMLTest
//
//  Created by Supphawit Getmark on 7/30/2560 BE.
//  Copyright © 2560 Supphawit Getmark. All rights reserved.
//

import UIKit
import CoreML

struct DotPosition: Hashable{
    
    var x:UInt32
    var y:UInt32

    var hashValue: Int{
        return x.hashValue * y.hashValue &* 16777619
    }

    static func ==(lhs: DotPosition, rhs: DotPosition) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

}

@available(iOS 11.0, *)
class DotViewController: UIViewController {
    
    //MARK:- Propreties
    let generateRandomCircle = true
    let cameraController = CameraController()
    static let circleRadius: CGFloat = 20
    
    
    var currentDotPosition: Int = 0
    var isSpawnRandom: Bool = false
    var dotCount: UInt = 0
    var dotPosition: DotPosition = DotPosition(x: 0, y: 0)
    var isProcessing: Bool = false
    var gazeLogic: EyeGazeLogic?
    var result: [DotPosition: [PredictPoint]] = [:]
    lazy var circleDrawTimer: Timer = Timer.init()
    
    
    
    //MARK:- ViewAction
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cameraController.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraController.prepare(completionHandler: {(error) in
            if let error = error{
                print(error)
            }
        })
        self.drawCircle()
        DispatchQueue.global().async {
            self.gazeLogic = EyeGazeLogic()
            self.cameraController.delegate = self
        }
        if(self.generateRandomCircle){
            self.circleDrawTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.drawCircle), userInfo: nil, repeats: true)
        }
    }
    
    @objc func drawCircle(){
        let screenRect = UIScreen.main.bounds
        if(isSpawnRandom){
            self.dotPosition.x = arc4random_uniform(UInt32(screenRect.width-DotViewController.circleRadius)) + UInt32(DotViewController.circleRadius)
            self.dotPosition.y = arc4random_uniform(UInt32(screenRect.height-DotViewController.circleRadius)) + UInt32(DotViewController.circleRadius)
        }
        else{
            print(self.dotCount)
            print(" \(self.dotCount / 3 + 1) \(self.dotCount % 3 + 1)")
            self.dotPosition.x = UInt32(UIScreen.main.bounds.width / 4 * CGFloat(self.dotCount / 3 + 1) )
            self.dotPosition.y = UInt32(UIScreen.main.bounds.height / 4 * CGFloat(self.dotCount % 3 + 1))
        }
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: Double(self.dotPosition.x)
            , y: Double(self.dotPosition.y))
            , radius: DotViewController.circleRadius
            , startAngle: CGFloat(0)
            , endAngle: CGFloat(Double.pi*2)
            , clockwise: true)
        let shapelayer = CAShapeLayer()
        shapelayer.path = circlePath.cgPath
        shapelayer.fillColor = UIColor.red.cgColor
        shapelayer.strokeColor = UIColor.red.cgColor
        shapelayer.lineWidth = 3.0
        guard let layerCount = self.view.layer.sublayers?.count else {
            self.view.layer.addSublayer(shapelayer)
            return
        }
        if(layerCount == 1){
            self.view.layer.sublayers?.removeLast()
        }
        self.view.layer.addSublayer(shapelayer)
        dotCount += 1
        if(dotCount > 9){
            self.circleDrawTimer.invalidate()
            self.performSegue(withIdentifier: "showPredictResultSegue", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showPredictResultSegue"){
            let destination  = segue.destination as! ShowResultViewController
            destination.predictResults = result
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension DotViewController: CameraControllerDelegate{
    
    //MARK:- DelegateMethod
    func didCaptureVideoFrame(image: CIImage) {
        if(!isProcessing){
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    
                }
                catch{
                    print(error)
                }
            }
        }
    }
    
}

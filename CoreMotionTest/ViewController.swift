//
//  ViewController.swift
//  CoreMotionTest
//
//  Created by novastar on 2024/8/9.
//

import UIKit
import CoreMotion
import CoreLocation
//import QVEditor

class ViewController: UIViewController,CLLocationManagerDelegate {

    var cl:CLLocationManager!
    var cm:CMMotionManager!
    var motionBtn:UIButton!
    var autoMotionBtn:UIButton!
    var accelerationBtn:UIButton!
    var textView:UITextView!
    var textView2:UITextView!
    var baseMagneticField: Double = 0.0
    var imageV:UIImageView!
    //原始角度
    var rotationAngle = 0.0
//    var editorConfig:QVEditorConfiguration!
    //MARK: 生命週期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataInit()
        self.createView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cl.startUpdatingHeading()
//        editorConfig = QVEditorConfiguration()
//        editorConfig.licensePath = Bundle.main.path(forResource: "LICENSE", ofType: "txt")!
//        editorConfig.defaultTemplateVersion = 1
//        editorConfig.corruptImgPath = Bundle.main.path(forResource: "error", ofType: "jpeg")!
//        QVEditor.initialize(withConfig: editorConfig, delegate: self)
    }

    //MARK: 自訂方法
    func dataInit(){
        view.backgroundColor = .white
        cm = CMMotionManager()
        cl = CLLocationManager()
        // 設置位置管理器
        cl.delegate = self
        cl.startUpdatingHeading()
        cl.requestWhenInUseAuthorization()
        
    }
    func createView(){
        motionBtn = UIButton(frame: .zero)
        motionBtn.translatesAutoresizingMaskIntoConstraints = false
        motionBtn.setTitle("手動偵測磁場狀態", for: .normal)
        motionBtn.setTitleColor(.white, for: .normal)
        motionBtn.backgroundColor = .darkGray
        motionBtn.addTarget(self, action: #selector(self.btnAction), for: .touchUpInside)
        self.view.addSubview(motionBtn)
        self.btnLayoutCons()
        autoMotionBtn = UIButton(frame: .zero)
        autoMotionBtn.translatesAutoresizingMaskIntoConstraints = false
        autoMotionBtn.setTitle("自動偵測磁場狀態", for: .normal)
        autoMotionBtn.setTitleColor(.red, for: .normal)
        autoMotionBtn.backgroundColor = .darkGray
        autoMotionBtn.addTarget(self, action: #selector(self.autoMotion), for: .touchUpInside)
        self.view.addSubview(autoMotionBtn)
        self.autoBtnLayoutCons()
        textView = UITextView(frame: .zero)
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.isSelectable = false
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        textViewLayoutCons()
        accelerationBtn = UIButton(frame: .zero)
        accelerationBtn.translatesAutoresizingMaskIntoConstraints = false
        accelerationBtn.setTitle("自動偵測加速度狀態", for: .normal)
        accelerationBtn.setTitleColor(.red, for: .normal)
        accelerationBtn.backgroundColor = .darkGray
        accelerationBtn.addTarget(self, action: #selector(self.accelerationMotion), for: .touchUpInside)
        self.view.addSubview(accelerationBtn)
        self.accelerationBtnLayoutCons()
        textView2 = UITextView(frame: .zero)
        textView2.backgroundColor = .white
        textView2.textColor = .black
        textView2.isSelectable = false
        textView2.isEditable = false
        textView2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView2)
        textView2LayoutCons()
        imageV = UIImageView(frame: .zero)
        imageV.contentMode = .scaleAspectFit
        imageV.image = UIImage(named: "compass")?.withRenderingMode(.alwaysTemplate)
        imageV.tintColor = .red
        imageV.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageV)
        imageVLayoutCons()
    }
    
    func btnLayoutCons(){
        let leading = NSLayoutConstraint(item: self.motionBtn, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 10)
        let bottom = NSLayoutConstraint(item: self.motionBtn, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -10)
        let trailing = NSLayoutConstraint(item: self.motionBtn, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -10)
        let height = NSLayoutConstraint(item: self.motionBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 80)
        NSLayoutConstraint.activate([leading,bottom,trailing,height])
    }
    func autoBtnLayoutCons(){
        let leading = NSLayoutConstraint(item: self.autoMotionBtn, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 10)
        let bottom = NSLayoutConstraint(item: self.autoMotionBtn, attribute: .bottom, relatedBy: .equal, toItem: self.motionBtn, attribute: .top, multiplier: 1.0, constant: -10)
        let trailing = NSLayoutConstraint(item: self.autoMotionBtn, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -10)
        let height = NSLayoutConstraint(item: self.autoMotionBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 80)
        NSLayoutConstraint.activate([leading,bottom,trailing,height])
    }
    func textViewLayoutCons(){
        let leading = NSLayoutConstraint(item: self.textView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 10)
        let bottom = NSLayoutConstraint(item: self.textView, attribute: .bottom, relatedBy: .equal, toItem: self.autoMotionBtn, attribute: .top, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint(item: self.textView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -10)
        let height = NSLayoutConstraint(item: self.textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50)
        NSLayoutConstraint.activate([leading,bottom,trailing,height])
    }
    func accelerationBtnLayoutCons(){
        let leading = NSLayoutConstraint(item: self.accelerationBtn, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 10)
        let bottom = NSLayoutConstraint(item: self.accelerationBtn, attribute: .bottom, relatedBy: .equal, toItem: self.textView, attribute: .top, multiplier: 1.0, constant: -10)
        let trailing = NSLayoutConstraint(item: self.accelerationBtn, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -10)
        let height = NSLayoutConstraint(item: self.accelerationBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 80)
        NSLayoutConstraint.activate([leading,bottom,trailing,height])
    }
    func textView2LayoutCons(){
        let leading = NSLayoutConstraint(item: self.textView2, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 10)
        let bottom = NSLayoutConstraint(item: self.textView2, attribute: .bottom, relatedBy: .equal, toItem: self.accelerationBtn, attribute: .top, multiplier: 1.0, constant: 0)
        let trailing = NSLayoutConstraint(item: self.textView2, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -10)
        let height = NSLayoutConstraint(item: self.textView2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50)
        NSLayoutConstraint.activate([leading,bottom,trailing,height])
    }
    func imageVLayoutCons(){
        let lead = NSLayoutConstraint(item: self.imageV, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 10)
        let trailing = NSLayoutConstraint(item: self.imageV, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -10)
        let top = NSLayoutConstraint(item: self.imageV, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: self.view.safeAreaLayoutGuide.layoutFrame.origin.y + 40)
        let height = NSLayoutConstraint(item: self.imageV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        NSLayoutConstraint.activate([lead,trailing,top,height])
//        self.imageV.transform = CGAffineTransform(rotationAngle: 180)
    }
    //MARK: 按鈕方法
    @objc func btnAction(){
        self.cm.startMagnetometerUpdates()
        if let cmData = self.cm.magnetometerData{
            let field = cmData.magneticField
            if !self.textView.text.isEmpty{
                self.textView.text = ""
            }
//            print("x位置:\(field.x),y位置:\(field.y),x位置:\(field.z)")
            let heading = self.calculateHeading(x: field.x, y: field.y)
//            print("Heading: \(heading) degrees")
            self.textView.text = "Heading: \(heading) degrees"
//            self.imageV.transform = CGAffineTransform(rotationAngle: heading)
        }
    }
    
    @objc func autoMotion(){
        self.cm.magnetometerUpdateInterval = 0.1
        let queue = OperationQueue.current
        self.cm.startMagnetometerUpdates(to: OperationQueue.main) {
            cmData, error in
            if error != nil{
                print("autoMotion error:\(error?.localizedDescription)")
            }else{
                let field = cmData!.magneticField
                if !self.textView.text.isEmpty{
                    self.textView.text = ""
                }
//                print("x位置:\(field.x),y位置:\(field.y),x位置:\(field.z)")
                let heading = self.calculateHeading(x: field.x, y: field.y)
                self.updateCompass(heading: heading)
                //計算磁場強度
                let totalFieldStrength = self.calculateFieldStrength(x: field.x, y: field.y, z: field.z)
                print("磁場強度: \(totalFieldStrength) µT")
                self.textView.text = "磁場強度: \(totalFieldStrength) µT"
//                    if abs(totalFieldStrength - self.baseMagneticField) > 20 { // Detecting change
//                        print("Metal detected! Field strength: \(totalFieldStrength)")
//                        self.textView.text = "Metal detected! Field strength: \(totalFieldStrength)"
//                        // Trigger an action, like sound or UI change.
//                    } else {
//                        print("No metal nearby")
//                        self.textView.text = "Metal detected! totalFieldStrength: \(totalFieldStrength)"
//                    }
            }
        }
    }
    @objc func accelerationMotion(){
        self.cm.startAccelerometerUpdates()
        self.cm.accelerometerUpdateInterval = 1.0
        let queue = OperationQueue.main
        self.cm.startAccelerometerUpdates(to: queue) {
            cmData, err in
            if !self.textView2.text.isEmpty{
                self.textView2.text = ""
            }
            self.textView2.text = "x:\(cmData!.acceleration.x),y:\(cmData!.acceleration.y),z:\(cmData!.acceleration.z)"
        }
    }

    //MARK: QVEngineDataSourceProtocol
//    func languageCode() -> String {
//        return "zh-Tw"
//    }
//    func textPrepare(_ textPrepareMode: QVTextPrepareMode) -> QVTextPrepareModel {
//        var textModel = QVTextPrepareModel()
//        if QVTextPrepareMode.location == textPrepareMode{
//            textModel.location = languageCode()
//        }
//        return textModel
//    }
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        if newHeading.headingAccuracy > 0 {
//            // 方向數據
//            let magneticHeading = newHeading.magneticHeading
//            updateCompass(heading: magneticHeading)
//        }
    }
    func calculateHeading(x: Double, y: Double) -> Double {
        // Using only x and y for a 2D compass-like behavior
        let heading = atan2(y, x) * 180 / .pi
        let resultHeading = heading >= 0 ? heading : heading + 360
        print("calculateHeading resultHeading:\(resultHeading)")
        return resultHeading
    }
    func calculateFieldStrength(x: Double, y: Double, z: Double) -> Double {
        // Calculate total magnetic field strength
        return sqrt(x * x + y * y + z * z)
    }
    func updateCompass(heading: CLLocationDirection){
        // 這裡可以將指南針的UI旋轉到對應角度
        let updateRotationAngle = CGFloat(heading / 180.0 * .pi)
        self.rotationAngle = updateRotationAngle
        self.imageV.transform = CGAffineTransform(rotationAngle: self.rotationAngle)
    }
}


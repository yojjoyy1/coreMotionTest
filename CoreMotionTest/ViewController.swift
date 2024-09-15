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
    var hitImgV:UIImageView!
    var maximumAcceleration = 0.0
    //原始角度
    var rotationAngle = 0.0
    var startMagnetometerBool = false
    var startAccelerometerBool = false
    var startCompassBool = false
    var bossImgV:UIImageView!
    var gameStatusLabel:UILabel!
    var blood = 10
    var isHit = false
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
        motionBtn.setTitle("啟動指北針狀態", for: .normal)
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
        hitImgV = UIImageView(frame: .zero)
//        hitImgV.contentMode = .scaleAspectFill
        hitImgV.image = UIImage(named: "hit")
        hitImgV.alpha = 0
        hitImgV.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hitImgV)
        self.view.bringSubviewToFront(hitImgV)
        self.hitImgVLayoutCons()
        bossImgV = UIImageView(frame: .zero)
        bossImgV.image = UIImage(named: "boss")
        bossImgV.alpha = 1
        bossImgV.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bossImgV)
        self.bossImgVLayoutCons()
        gameStatusLabel = UILabel(frame: .zero)
        gameStatusLabel.alpha = 0
        gameStatusLabel.textColor = .red
        gameStatusLabel.font = UIFont.boldSystemFont(ofSize: 60)
        gameStatusLabel.text = "你贏了!!"
        gameStatusLabel.textAlignment = .center
        gameStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gameStatusLabel)
        self.gameStatusLayoutCons()
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
    func hitImgVLayoutCons(){
        let leading = NSLayoutConstraint(item: self.hitImgV, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 5)
        let trailing = NSLayoutConstraint(item: self.hitImgV, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -5)
        let top = NSLayoutConstraint(item: self.hitImgV, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 10)
        let bottom = NSLayoutConstraint(item: self.hitImgV, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -5)
        NSLayoutConstraint.activate([leading,trailing,top,bottom])
    }
    func bossImgVLayoutCons(){
        let top = NSLayoutConstraint(item: self.bossImgV, attribute: .top, relatedBy: .equal, toItem: self.hitImgV, attribute: .top, multiplier: 1.0, constant: 40)
        let centerx = NSLayoutConstraint(item: self.bossImgV, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let width = NSLayoutConstraint(item: self.bossImgV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300)
        let height = NSLayoutConstraint(item: self.bossImgV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300)
        NSLayoutConstraint.activate([top,centerx,width,height])
    }
    func gameStatusLayoutCons(){
        let top = NSLayoutConstraint(item: self.gameStatusLabel, attribute: .top, relatedBy: .equal, toItem: self.hitImgV, attribute: .top, multiplier: 1.0, constant: 10)
        let centerx = NSLayoutConstraint(item: self.gameStatusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let width = NSLayoutConstraint(item: self.gameStatusLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.size.width)
        let height = NSLayoutConstraint(item: self.gameStatusLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300)
        NSLayoutConstraint.activate([top,centerx,width,height])
    }
    //MARK: 按鈕方法
    @objc func btnAction(){
        if !startCompassBool{
            startCompassBool = true
            self.cm.deviceMotionUpdateInterval = 0.1
            self.cm.startDeviceMotionUpdates(to: OperationQueue.main) {
                (data, error) in
                if let validData = data {
                    let attitude = validData.attitude
                    let heading = self.calculateHeading(attitude: attitude)
                    print("Heading: \(heading) degrees")
                    self.imageV.transform = CGAffineTransform(rotationAngle: CGFloat(heading * .pi / 180))
                }
            }
        }else{
            self.cm.stopDeviceMotionUpdates()
            startCompassBool = false
        }
    }
    
    @objc func autoMotion(){
        if !startMagnetometerBool{
            startMagnetometerBool = true
            self.cm.magnetometerUpdateInterval = 0.1
            self.cm.startMagnetometerUpdates(to: OperationQueue.main, withHandler: { tometerData, error in
                if error != nil{
                    print("autoMotion error:\(error?.localizedDescription)")
                }else{
                    let field = tometerData!.magneticField
                    if !self.textView.text.isEmpty{
                        self.textView.text = ""
                    }
                    let x = field.x
                    let y = field.y
                    let z = field.z
                    print("x強度:\(x),y強度:\(y),z強度:\(z)")
                    //計算磁場強度
                    let totalFieldStrength = self.calculateFieldStrength(x: x , y: y, z: z)
                    print("磁場強度: \(totalFieldStrength) µT")
                    self.textView.text = "磁場強度: \(totalFieldStrength) µT"
                }
            })
        }else{
            self.cm.stopMagnetometerUpdates()
            startMagnetometerBool = false
        }
    }
    @objc func accelerationMotion(){
        if !startAccelerometerBool{
            startAccelerometerBool = true
            self.cm.startAccelerometerUpdates()
            self.cm.accelerometerUpdateInterval = 0.1
            let queue = OperationQueue.main
            
            self.cm.startAccelerometerUpdates(to: queue) {
                cmData, err in
                if !self.textView2.text.isEmpty{
                    self.textView2.text = ""
                }
                let acceleration = self.calculateAcceleration(x: cmData!.acceleration.x, y: cmData!.acceleration.y, z: cmData!.acceleration.z)
                print("加速度: \(acceleration) m/s²")
                self.textView2.text = "加速度: \(acceleration) m/s² 最高紀錄: \(self.maximumAcceleration) m/s²"
                if !self.isHit{
                    if acceleration > 5{
                        self.blood -= 1
                        if self.blood > 0{
                            UIView.animate(withDuration: 1) {
                                self.isHit = true
                                self.hitImgV.alpha = 1
                                self.bossImgV.image = UIImage(named: "bosshit")
                            } completion: { b in
                                self.isHit = false
                                self.hitImgV.alpha = 0
                                self.bossImgV.image = UIImage(named: "boss")
                            }

                        }else{
                            self.isHit = false
                            self.hitImgV.alpha = 0
                            self.bossImgV.alpha = 0
                            self.gameStatusLabel.alpha = 1
                            self.cm.stopAccelerometerUpdates()
                            self.startAccelerometerBool = false
                        }
                    }
                }
            }
        }else{
            self.cm.stopAccelerometerUpdates()
            startAccelerometerBool = false
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
    func calculateHeading(attitude: CMAttitude) -> Double {
        // 獲取設備的方向（yaw），並轉換為角度
        let yaw = attitude.yaw * 180 / .pi
        // 確保角度在 0 到 360 之間
        let heading = yaw >= 0 ? yaw : yaw + 360
        return heading
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
    //計算加速度
    func calculateAcceleration(x: Double, y: Double, z: Double) -> Double {
        let gForce = sqrt(x * x + y * y + z * z)
        let result = gForce
        if maximumAcceleration < result{
            maximumAcceleration = result
        }
        return result // 將 g-force 轉換為 m/s²
    }
}


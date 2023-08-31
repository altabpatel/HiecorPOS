//
//  BarCodeScannerVC.swift
//  HieCOR
//
//  Created by Ankit Jain on 15/12/22.
//  Copyright © 2022 HyperMacMini. All rights reserved.
//

import UIKit
import AVFoundation

typealias CompletionHandler2 = (String, CodeType) -> Void

class BarCodeScannerVC: UIViewController {
    
    @IBOutlet weak var view_cameraNotFound: UIView!
    @IBOutlet weak var cameraView: CameraView!
    
    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target: nil)
    var completionHandler: CompletionHandler2?
    var isAllowPermistion = true
    var isFirstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCameraView()
        self.updateViewForOrientation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionQueue.async {
//            guard let videoDeviceInput = try?AVCaptureDeviceInput(device: AVCaptureDevice.default(for: AVMediaType.video)!) else {
//                return
//            }
            if self.isAllowPermistion == false {
                return
            }
            self.session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionQueue.async {
            if self.isAllowPermistion == false {
                return
            }
            self.session.stopRunning()
        }
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        isFirstTime = false
        // Update camera orientation
        self.updateViewForOrientation()
        if UIDevice.current.orientation.isPortrait {
            cameraView.frame.size = CGSize(width: 200, height: 200)
        }else{
            cameraView.frame.size = size
        }
        
    }
    
    //MARK:- IBAction Method
    @IBAction func btnClose_action(_ sender: Any) {
        //self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnGoToSettting_action(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    //MARK: Setup UI
    func setupCameraView() {
        session.beginConfiguration()
        
        if let videoDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            guard let videoDeviceInput = try?AVCaptureDeviceInput(device: videoDevice) else {
                isAllowPermistion = false
               // view_cameraNotFound.isHidden = false
                failed()
                return
            }
            //view_cameraNotFound.isHidden = true
            isAllowPermistion = true
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (session.canAddOutput(metadataOutput)) {
                session.addOutput(metadataOutput)
                metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.itf14, AVMetadataObject.ObjectType.dataMatrix, AVMetadataObject.ObjectType.interleaved2of5, AVMetadataObject.ObjectType.qr]
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            }
            
            session.commitConfiguration()
            cameraView.layer.session = session
            cameraView.layer.videoGravity = AVLayerVideoGravity.resize
        }
        
        //self.focusImageView.image = self.focusImageView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        // self.focusImageView.tintColor = UIColor.black
        //  self.cameraView.bringSubviewToFront(focusImageView)
        self.cameraView.layer.cornerRadius = 10;
    }
    
    func updateViewForOrientation() {
        if isFirstTime {
            var videoOrientation: AVCaptureVideoOrientation!
            switch UIApplication.shared.statusBarOrientation {
            case .portrait:
                videoOrientation = .portrait
            case .portraitUpsideDown:
                videoOrientation = .portraitUpsideDown
            case .landscapeLeft:
                videoOrientation = .landscapeLeft
            case .landscapeRight:
                videoOrientation = .landscapeRight
            default:
                videoOrientation = .portrait
            }
//            if  UIDevice.current.orientation.isPortrait {
//                cameraView.layer.connection?.videoOrientation = .portrait
//            }else{
//                cameraView.layer.connection?.videoOrientation = .landscapeLeft
//            }
            cameraView.layer.connection?.videoOrientation = videoOrientation
        }else{
            cameraView.layer.connection?.videoOrientation = AVCaptureVideoOrientation(rawValue:  UIDevice.current.orientation.rawValue)!
        }
        cameraView.layer.cornerRadius = 8.0
        cameraView.layer.masksToBounds = true
//        cameraView.sizeToFit()
    }
    func failed() {
        let alert = UIAlertController(title: "Cannot access camera", message: "You have denied this app permission to access to the camera. Please go to settings and enable camera access permission to be able to scan bar codes", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                  UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
//                  //UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
//                }))
        present(alert, animated: true)
        //  captureSession = nil
    }
    
    //MARK: Open View Controller
    
    static func scanCode(fromController vc: UIViewController, completionHandler: @escaping CompletionHandler2) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BarCodeScannerVC") as! BarCodeScannerVC
        controller.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        controller.modalPresentationStyle = .overCurrentContext
        controller.completionHandler = completionHandler
        vc.present(controller, animated: false, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension BarCodeScannerVC:  AVCaptureMetadataOutputObjectsDelegate  {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            let codeType: CodeType = metadataObject.type == AVMetadataObject.ObjectType.qr ? CodeType.qr : CodeType.barcode
            if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
                found(code: object.stringValue ?? "")
                self.dismiss(animated: true, completion: {
                    if let completion = self.completionHandler {
                        completion(object.stringValue ?? "", codeType)
                    }
                })
            }
        }
    }

    func found(code: String) {
        print(code)
    }
}

class CameraView: UIView {
    override class var layerClass: AnyClass {
        get {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    override var layer: AVCaptureVideoPreviewLayer {
        get {
            return super.layer as! AVCaptureVideoPreviewLayer
        }
    }
}

enum CodeType {
    case qr
    case barcode
}

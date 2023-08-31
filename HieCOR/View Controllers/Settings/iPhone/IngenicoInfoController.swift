//
//  IngenicoInfoController.swift
//  HieCOR
//
//  Created by Hiecor on 23/09/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import Foundation

import UIKit

class IngenicoInfoController: BaseViewController {

    
    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblDeviceBetteryLife: UILabel!
    @IBOutlet weak var lblDeviceSerialNumber: UILabel!
    @IBOutlet weak var lblDeviceFirmwareId: UILabel!
    @IBOutlet weak var lblPosEntryMode: UILabel!
    
    var strBetteryLife = 0
    var strPOSentryMode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFirmwareInfo()
        getDeviceSerialnumber()
        lblDeviceBetteryLife.text = "\(strBetteryLife)%"
        lblDeviceName.text = appDelegate.strIngenicoShowDeviceName
        lblPosEntryMode.text = strPOSentryMode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func Back_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ForgetDisconnnect_Action(_ sender: Any) {
        updateFirmware()
    }
    
    @IBAction func Update_Action(_ sender: UIButton) {
        //checkFirmwareUpdate()
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        checkDeviceFirmwareUpdateInfo()

    }
    
    func checkDeviceFirmwareUpdateInfo() {
        if !getIsDeviceConnected() {
            appDelegate.showToast(message: "Device not connected.")
        }else {
            appDelegate.showToast(message: "Checking for firmware update...")
            Ingenico.sharedInstance()?.paymentDevice.checkFirmwareUpdate({ (error, updateAction, firmwareInfo) in
                if  error != nil {
                    appDelegate.showToast(message: "Check firmware update failed")
                    self.consoleLog("Check firmware update failed: \((error! as NSError).code)")
                }
                else {
                    switch updateAction {
                    case .FirmwareUpdateActionUnknown:
                        appDelegate.showToast(message: "Check firmware update failed")
                        self.consoleLog("Check firmware update failed")
                    case .FirmwareUpdateActionRequired:
                        appDelegate.showToast(message: "Firmware update required")
                        self.consoleLog( "Firmware update required")
                    case .FirmwareUpdateActionOptional:
                        appDelegate.showToast(message: "Firmware update optional")
                        self.consoleLog( "Firmware update optional")
                    case .FirmwareUpdateActionNo:
                        appDelegate.showToast(message: "Firmware update not required")
                        self.consoleLog( "Firmware update not required")
                    default:
                        break
                    }
                }
            })
        }
    }
    
    func getFirmwareInfo() {
        Ingenico.sharedInstance()?.paymentDevice.getFirmwarePackageInfo({ (error, firmwarePackageInfo) in
            if (error == nil) {
                //self.showSucess( "getFirmwarePackageInfo success")
                self.consoleLog("getFirmwarePackageInfo:\(firmwarePackageInfo!.description)")
                self.lblDeviceFirmwareId.text = firmwarePackageInfo?.packageName ?? ""
            }
            else {
                //self.showError("getFirmwarePackageInfo failed")
                self.consoleLog("getFirmwarePackageInfo failed with error: \((error! as NSError).code)")
            }
        })
    }

    func getDeviceSerialnumber() {
        Ingenico.sharedInstance()?.paymentDevice.getSerialNumber({ (serialNumber, error) in
            if error == nil{
                //self.showSucess( "getDeviceSerialnumber success")
                self.consoleLog("getDeviceSerialnumber success")
                self.consoleLog("serial number:\(serialNumber ?? "")")
                self.lblDeviceSerialNumber.text = serialNumber ?? ""
            }else {
                //self.showError("getDeviceSerialnumber failed")
                self.consoleLog("getDeviceSerialnumber failed with error: \((error! as NSError).code)")
            }
        })
    }
    
}

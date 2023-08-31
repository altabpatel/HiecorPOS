//
//  CardReaderViewController.swift
//  HieCOR
//
//  Created by Hiecor on 26/03/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//


import UIKit
import CoreData
import CoreBluetooth
import CoreBluetooth.CBService
import MobileCoreServices
import IQKeyboardManagerSwift
import ExternalAccessory

class CardReaderViewController: BaseViewController, SWRevealViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, RUAPairingListener, UNUserNotificationCenterDelegate, ingenicoCancelViewControllerDelegate {
    func didTapOnCancelButton() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.isError = false
            self.performSegue(withIdentifier: "error_cancel_segue", sender: self)

        })
    }
    
    //MARK: - RUAPairingListener
    
    func onPairConfirmation(_ readerPasskey: String!, mobileKey mobilePasskey: String!) {
        UNUserNotificationCenter.current().delegate = self
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = String(format: "Passkey: %@", readerPasskey)
        notificationContent.badge = NSNumber(value: 1)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "PairingPasskey", content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func onPairSucceeded() {
       //self.showSucess( "Pairing Success")
        Indicator.sharedInstance.hideIndicator()
        appDelegate.showToast(message: "Pairing Success")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            Indicator.sharedInstance.showIndicator()
            self.loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password)
        }

    }
    
    func onPairNotSupported() {
        //self.showError("Pairing not supported")
        Indicator.sharedInstance.hideIndicator()
        appDelegate.showToast(message: "Pairing not supported")
    }
    
    func  onPairFailed() {
        //self.showError("Pairing Failed")
        Indicator.sharedInstance.hideIndicator()
        connectingDevice = nil
        ingenico.setLogging(false)
        DataManager.RUADeviceTypeValueDataSet = 9
        Indicator.sharedInstance.hideIndicator()
        Ingenico.sharedInstance()?.paymentDevice.release()
        Ingenico.sharedInstance()?.paymentDevice.stopSearch()
        self.cardReaderMainView.isHidden = true
        
        self.cardReaderViewShowHideDelegate?.cardReaderViewShowHide?(with: true)
        isConnected = false
        isError = false
        //appDelegate.showToast(message: "Pairing Failed")
        self.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: "error_cancel_segue", sender: self)
        }
        
    }
    
    
    override func onConnected() {
        super.onConnected()
        isConnected = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //Indicator.sharedInstance.showIndicator()
            if !self.isAudioJack {
                self.loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password)

            }
        }
        if isAudioJack {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.ingenico.paymentDevice.stopSearch()
                self.ingenico.paymentDevice.requestPairing(self)
                let alertController:UIAlertController = UIAlertController.init(title: "", message: "Pairing process in progress.\nPlease go to Settings-> Bluetooth app in your iOS device and select the RP450c device to complete the pairing process.", preferredStyle: .alert)
                let goToSettingAction:UIAlertAction  = UIAlertAction.init(title: "Go To Settings", style:.cancel, handler: { (action: UIAlertAction) in
                    UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(goToSettingAction)
                self.present(alertController, animated:true, completion: nil)
            }
        }
    }
    
    override func onDisconnected() {
        super.onDisconnected()
        isConnected = false
    }
    
    override func onError(_ message:String) {
        super.onError(message)
        setDeviceConneced(false)
        connectingDevice = nil
        DataManager.RUADeviceTypeValueDataSet = 9
        Indicator.sharedInstance.hideIndicator()
        ingenico.setLogging(false)
        Ingenico.sharedInstance()?.paymentDevice.release()
        Ingenico.sharedInstance()?.paymentDevice.stopSearch()
        self.cardReaderMainView.isHidden = true
        
        self.cardReaderViewShowHideDelegate?.cardReaderViewShowHide?(with: true)
        isConnected = false
        isError = true
        self.performSegue(withIdentifier: "error_cancel_segue", sender: self)
        
        //if "Landi OpenDevice Error::-2" == message {
        //    self.showAlert(message: "Please try again for pairing , after click on pair button then click MOBY device power button within 30 second.")
        //} else {
        //appDelegate.showToast(message: "\(message)")
        //}
    }
    
    
    fileprivate var ingenico:Ingenico!
    fileprivate var deviceList:[RUADevice] = []
    let ClientVersion:String  = "4.2.3"
    var isConnected = false
    var isAudioJack = false
    var ledSequence:[Any] = []
    var confirmationCallback: RUALedPairingConfirmationCallback?
    var isError = false
    var strDeviceName = ""
    
    
    func onLedPairSequenceConfirmation(_ ledSequence: [Any]!, confirmationCallback: RUALedPairingConfirmationCallback!) {
        //Indicator.sharedInstance.showIndicator()
//        self.ledSequence = ledSequence
//        self.confirmationCallback = confirmationCallback
//        self.confirmationCallback?.confirm()
        
        self.ledSequence = ledSequence
        self.confirmationCallback = confirmationCallback
        self.performSegue(withIdentifier: "led_pair_segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "led_pair_segue") {
            if UI_USER_INTERFACE_IDIOM() == .phone {
                Indicator.sharedInstance.hideIndicator()
            }
            let vc:LedPairingViewController = segue.destination as! LedPairingViewController
            vc.ledSequence = self.ledSequence
            vc.confirmationCallback = self.confirmationCallback
            vc.delegateCallvalue = self
        } else if (segue.identifier == "error_cancel_segue") {
            let vc:CancelErrorViewcontroller = segue.destination as! CancelErrorViewcontroller
            vc.isErrorShow = isError
            vc.strName = strDeviceName
        }
    }
    
    @IBOutlet weak var tbl_CardReaderDevice: UITableView!
    @IBOutlet weak var cardReaderMainView: UIView!
    @IBOutlet weak var cardReaderDeviceViewWidth: NSLayoutConstraint!
    @IBOutlet weak var cardReaderDeviceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblMessageIngenicoDevice: UILabel!
    
    var cardReaderViewShowHideDelegate: SettingViewControllerDelegate?
   
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbl_CardReaderDevice.dataSource = self
        tbl_CardReaderDevice.delegate = self
        cardReaderMainView.isHidden = false
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        if UI_USER_INTERFACE_IDIOM() == .pad {
            cardReaderDeviceViewWidth.constant = displayWidth * 0.5
        }else{
            cardReaderDeviceViewWidth.constant = displayWidth - 40
        }
        //cardReaderDeviceViewHeight.constant = displayHeight/2
        
    }
        
    @IBAction func btn_cardReaderCancelBtnAction(_ sender: Any) {
        cardReaderViewShowHideDelegate?.cardReaderViewShowHide?(with: true)
    }
    
    func loginWithUserName( _ uname : String, andPW pw : String){
        
        self.view.endEditing(true)
        //SVProgressHUD.show(withStatus: "Logging")
        Ingenico.sharedInstance()?.user.loginwithUsername(uname, andPassword: pw) { (user, error) in
            //SVProgressHUD.dismiss()
            if (error == nil) {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.setLoggedIn(true)
                
                //Indicator.sharedInstance.hideIndicator()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.checkFirmwareUpdate()
                    self.cardReaderMainView.isHidden = true
                    self.tbl_CardReaderDevice.reloadData()
                    if self.getIsDeviceConnected() {
                        appDelegate.showToast(message: "Device Connected")
                    }
                    //self.performSegue(withIdentifier:"loginsuccess" , sender: nil)
                    self.cardReaderViewShowHideDelegate?.cardReaderViewShowHide?(with: true)
                }
                
            }else{
                self.callAPIToGetIngenico()
                Indicator.sharedInstance.hideIndicator()
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                let nserror = error as NSError?
                let alertController:UIAlertController  = UIAlertController.init(title: "Failed", message: "Login failed, please try again later \(self.getResponseCodeString((nserror?.code)!))", preferredStyle: .alert)
                let okAction:UIAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tbl_CardReaderDevice.dequeueReusableCell(withIdentifier: "CardReaderDeviceCell", for: indexPath) as! CardReaderDeviceCell
        //cell.deviceNameLbl.text = "device name\([indexPath.row])"
        
        let device:RUADevice = deviceList[(indexPath as NSIndexPath).row]
        if device.name != nil{
            cell.deviceNameLbl.text =  String.init(format: "Name: %@", device.name)
        }
        //cell.identifierLabel.text = String.init(format: "ID: %@", device.identifier)
        // cell.communicationLabel.text = self.getStringFromCommunication(device.communicationInterface)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("enter")
        if  deviceList.count > 0 {
            
            //                        ingenico.paymentDevice.stopSearch()
            //                        connectingDevice = deviceList[(indexPath as NSIndexPath).row]
            //                        ingenico.paymentDevice.select(connectingDevice!)
            //                        //let loginVC:LoginViewController  = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            //                        ingenico.paymentDevice.initialize(self)
            //                        if (HomeVM.shared.ingenicoData[0].str_url != nil) {
            //                            UserDefaults.standard.setValue(HomeVM.shared.ingenicoData[0].str_url, forKey: "DefaultURL")
            //                            UserDefaults.standard.synchronize()
            //                        }
            //                        ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
            //                                            apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
            //                                            clientVersion: ClientVersion)
            //                        ingenico.setLogging(true)
            //                        //ingenico.setCustomLogger(self)
            //                        if (connectingDevice?.communicationInterface == RUACommunicationInterfaceBluetooth) {
            //                            //continueToLogin(loginVC)
            //                        }
            
            ////
            
            let device:RUADevice = deviceList[(indexPath as NSIndexPath).row]
            strDeviceName = device.name
            appDelegate.strIngenicoShowDeviceName = strDeviceName
            if device.name.contains("AUDIO") {
                isAudioJack = true
                Indicator.sharedInstance.showIndicator()
                
                ingenico.paymentDevice.stopSearch()
                connectingDevice = deviceList[(indexPath as NSIndexPath).row]
                ingenico.paymentDevice.select(connectingDevice!)
                ingenico.paymentDevice.initialize(self, ledPairingListener: self as RUAPairingListener)
                ingenico.setLogging(true)
                if (connectingDevice?.communicationInterface == RUACommunicationInterfaceBluetooth) {
                    //continueToLogin(loginVC)
                    ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                        apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                        clientVersion: ClientVersion)
                    ingenico.setLogging(true)
                }
                
            } else {
                isAudioJack = false
                if device.name.contains("MOB") {
                    Indicator.sharedInstance.showIndicatorforMoby()
                } else {
                    Indicator.sharedInstance.showIndicator()
                }
                
                connectingDevice = deviceList[(indexPath as NSIndexPath).row]
                ingenico.paymentDevice.select(connectingDevice!)
                DataManager.RUADeviceConnectValueDataSet = connectingDevice?.name
                //ingenico.paymentDevice.initialize(self)
                ingenico.paymentDevice.initialize(self, ledPairingListener: self as RUAPairingListener)
                //ingenico.paymentDevice.stopSearch()
                //                if (baseURLTextField.text != nil) {
                //                    UserDefaults.standard.setValue(baseURLTextField.text, forKey: "DefaultURL")
                //                    UserDefaults.standard.synchronize()
                //                }
                ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                clientVersion: ClientVersion)
                
//                ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
//                                    apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
//                                    clientVersion: ClientVersion)
                ingenico.setLogging(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    //self.loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password)
                }
            }
        }
    }
    
    func datavalue() {
        ingenico.paymentDevice.stopSearch()
        if (isConnected) {
            ingenico.paymentDevice.requestPairing(self)
            
        }
        else {
            let alertController:UIAlertController  = UIAlertController.init(title: "", message: "Please make sure that the card reader is connected first.", preferredStyle:.alert)
            let gotoSettingsAction:UIAlertAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(gotoSettingsAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}

//MARK: IngenicoInfoViewControllerDelegate
extension CardReaderViewController: SettingViewControllerDelegate {
    func IngenicoDeviceDataDelegate() {
        print("call back one")
        ingenico = Ingenico.sharedInstance()
        ingenico.setLogging(false)
    }
    
    func IngenicoDeviceDataDelegateData(with data: [RUADevice]) {
        print("call back two")
        ingenico = Ingenico.sharedInstance()
        ingenico.setLogging(false)
        deviceList.removeAll()
        if appDelegate.strIngenicoDeviceName.contains("MOB") {
            self.lblMessageIngenicoDevice.text = """
1. Turn the reader on by pressing Power button until the Red LED is on.  
2. Wait for the reader to go into Discoverable mode, indicated by flashing Blue LED.  
3. Select your reader from "Available Readers" list below. 
4. When prompted by the system for "Bluetooth Pairing Request", select "Pair" option. 
5. When "Confirm LED Pairing Sequence" screen shows a pattern of upto 4 LEDs, match that with the pattern on the reader.
-To repeat LED pattern, select "Restart" option.
-Select "Confirm" option to finish pairing.
-Select "Cancel" option to abort reader set up.
"""
        } else {
            self.lblMessageIngenicoDevice.text = """
1. Press and hold the button on your reader until the blue light starts flashing.

2. Select your reader from the list below.
"""
        }
        
        for value in data {
            let name = value.name
            if name!.contains(appDelegate.strIngenicoDeviceName) ||  name!.contains("AUDIOJACK") {
                print(name)
                deviceList.append(value)
            }
        }
        
        cardReaderMainView.isHidden = false
        tbl_CardReaderDevice.reloadData()
    }
}

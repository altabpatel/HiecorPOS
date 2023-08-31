//
//  BaseVC.swift
//  HieCOR
//
//  Created by Deftsoft on 17/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//


import UIKit
import CoreLocation

protocol SeetingControllerDelegate:class {
    func reloadTableViewForIngenicoCheckBox()
}

class BaseViewController: UIViewController, RUADeviceStatusHandler, DeviceManagementDelegate, CLLocationManagerDelegate {
    
    //MARK: - RUADeviceStatus Implementation
    func onConnected()  {
        print("Devices Connected")
        setDeviceConneced(true)
        DataManager.isIngenicoConnected = true
        //appDelegate.showToast(message: "Device Connected")
        //IMSBaseViewController.currentVC.deviceStatusBarButton?.customView = getDeviceStatusImage()
        DeviceManagementHelper.shared.stopScan()
        checkFirmwareUpdate()
        if(connectingDevice != nil && connectingDevice?.communicationInterface == RUACommunicationInterfaceBluetooth) {
            DeviceManagementHelper.shared.saveDevice(device: connectingDevice!, ofType: (Ingenico.sharedInstance()?.paymentDevice.getType())!)
        }
        
        delegateCall?.reloadTableViewForIngenicoCheckBox()
        
    }
    
    func onDisconnected() {
        setDeviceConneced(false)
        DataManager.isIngenicoConnected = false
        print("Devices Disconnected")
        //IMSBaseViewController.currentVC.deviceStatusBarButton?.customView = getDeviceStatusImage()
        connectingDevice = nil
        //DeviceManagementHelper.shared.startScan()
        //delegateCall?.reloadTableViewForIngenicoCheckBox()
    }
    
    func onError(_ message:String)  {
        //print("An error occured \(message)")
        //IMSBaseViewController.currentVC.deviceStatusBarButton?.customView = getDeviceStatusImage()
        print("On Error")
        connectingDevice = nil
        Ingenico.sharedInstance()?.paymentDevice.stopSearch()
        Ingenico.sharedInstance()?.paymentDevice.release()
        //DeviceManagementHelper.shared.startScan()
    }
    
    func connectPairedDevice(device: RUADevice, ofType deviceType: RUADeviceType) {
        if (!getIsDeviceConnected()) {
            Ingenico.sharedInstance()?.paymentDevice.setDeviceType(deviceType)
            Ingenico.sharedInstance()?.paymentDevice.select(device)
            Ingenico.sharedInstance()?.paymentDevice.initialize(self)
            
        }
    }
    
    func setLoggedIn(_ loggedIn:Bool){
        BaseViewController.isLoggedIn=loggedIn
    }
    
    func setDeviceConneced(_ deviceConnected:Bool){
        BaseViewController.isDeviceConnected=deviceConnected
    }
    
    func getIsLoggedIn() -> Bool{
        return BaseViewController.isLoggedIn
    }
    
    func getIsDeviceConnected() -> Bool{
        return BaseViewController.isDeviceConnected
    }
    
    func getLastTransactionType() -> IMSTransactionType?{
        return BaseViewController.lastTransactionType
    }
    
    func setLastTransactionType(_ type:IMSTransactionType){
        BaseViewController.lastTransactionType = type
    }
    
    func setLastTransactionID(_ id:String)  {
        BaseViewController.lastTransactionID=id
    }
    
    func setLastTokenID(_ id:String)  {
        BaseViewController.lastTokenId = id
    }
    func getLastTokenID() -> String? {
        return BaseViewController.lastTokenId
    }
    func setLastClientTransactionID(_ id:String)  {
        BaseViewController.lastClientTransactionId = id
    }
    func getLastClientTransactionID() -> String? {
        return BaseViewController.lastClientTransactionId
    }
        
    func getLastTransactionID() -> String? {
        return BaseViewController.lastTransactionID
    }
    
    func getResponseCodeString(_ code:Int) -> String {
        print("responce code data 11")
        let responseCode:IMSResponseCode = IMSResponseCode(rawValue: UInt(code))!
        switch (responseCode) {
        case .Success:
            return "Success";
        case .PaymentDeviceNotAvailable:
            return "Payment Device Not Available";
        case .PaymentDeviceError:
            return "Payment Device Not Error";
        case .PaymentDeviceTimeout:
            return "Payment Device Timeouts";
        case .NotSupportedByPaymentDevice:
            return "Not Supported by Payment Device";
        case .CardBlocked:
            return "Card Blocked";
        case .ApplicationBlocked:
            return "Application Blocked";
        case .InvalidCard:
            return "Invalid Card";
        case .InvalidApplication:
            return "Invalid Card Application";
        case .TransactionCancelled:
            return "Transaction Cancelled";
        case .CardReaderGeneralError:
            return "Card Reader General Error";
        case .CardInterfaceGeneralError:
            return "Card Not Accepted";
        case .BatteryTooLowError:
            return "Battery Too Low";
        case .BadCardSwipe:
            return "Bad Card Swipe";
        case .TransactionDeclined:
            return "Transaction Declined";
        case .TransactionReversalCardRemovedFailed:
            return "Transaction Reversal Card Removed Failed";
        case .TransactionReversalCardRemovedSuccess:
            return "Transaction Reversal Card Removed Success";
        case .TransactionReversalChipDeclineFailed:
            return "Transaction Reversal Chip Decline  Failed";
        case .TransactionReversalChipDeclineSuccess:
            return "Transaction Reversal Chip Decline Success";
//        case .TransactionRefusedBecauseOfTransactionWithPendingSignature:
//            return "Transaction Refused Because Of Transaction With Pending Signature";
        case .UserNameValidationError:
            return "UserName Validation Error";
        case .NetworkError:
            return "Network Error";
        default:
            return String(format: "response Code:\(responseCode.rawValue)")
        }
    }
    func isValidUrl(urlString: String?) -> Bool {
     guard let urlString1 = urlString else {return false}
      guard let url = NSURL(string: urlString1) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}

      //
      let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
      let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: urlString)
    }
    
    func updateFirmware() {
        appDelegate.showToast(message: "Downloading firmware start.")
        Ingenico.sharedInstance()?.paymentDevice.updateFirmware(downloadProgress: { (downloaded, total) in
            appDelegate.showToast(message: "Downloading firmware....")
//            self.showProgressPercent(Float(downloaded)/Float(total), message: "Downloading firmware...") {
//                Ingenico.sharedInstance()?.paymentDevice.cancelFirmwareUpdate()
//            }
        }, andFirmwareUpdateProgress: { (current, total) in
            appDelegate.showToast(message: "Updating firmware...")
//            self.showProgressPercent(Float(current)/Float(total), message: "Updating firmware...") {
//                Ingenico.sharedInstance()?.paymentDevice.cancelFirmwareUpdate()
//            }
        }, andOnDone: { (error) in
            if error == nil {
                appDelegate.showToast(message: "Firmware update succeeded")
                //self.showProgressMessage( "Firmware update succeeded")
            }
            else {
                appDelegate.showToast(message: "Firmware update failed")
                //self.showError("Firmware update failed")
            }
        })
    }

    
    func checkFirmwareUpdate(){
        if getIsLoggedIn() && getIsDeviceConnected() {
            
            Ingenico.sharedInstance()?.paymentDevice.checkFirmwareUpdate({ (error, updateAction, firmwareInfo) in
                print("Firmware Update: \(updateAction)")
                //appDelegate.showToast(message: "Firmware Update: \(updateAction)")
                //appDelegate.showToast(message: "firmware action ")
                Indicator.sharedInstance.hideIndicator()
                if (error != nil) {
                    appDelegate.showToast(message: "Check firmware update failed")
                }
                else if(updateAction == .FirmwareUpdateActionRequired || updateAction == .FirmwareUpdateActionOptional) {
                    //appDelegate.showIncreaseTimeToast(message: "Firmware update of the card reader is required to continue processing transactions. \(updateAction.rawValue)")
                    let alert = UIAlertController(title: "Firmware Update", message: "Firmware update is \(updateAction == .FirmwareUpdateActionRequired ? "required":"optional")", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        if (updateAction == .FirmwareUpdateActionOptional) {
                            self.checkDeviceSetup()
                        }
                    })
                    let update = UIAlertAction(title: "Update", style: .default, handler: { (action) in
                        self.updateFirmware()
                    })
                    alert.addAction(update)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                } else if (updateAction == .FirmwareUpdateActionNo) {
                    Indicator.sharedInstance.hideIndicator()
                    self.checkDeviceSetup()
                    //appDelegate.showIncreaseTimeToast(message: "No firmware update is available at this time. \(updateAction.rawValue)")
                } else if (updateAction == .FirmwareUpdateActionUnknown) {
                    Indicator.sharedInstance.hideIndicator()
                    self.checkDeviceSetup()
                    //appDelegate.showIncreaseTimeToast(message: "Unable to determine if there is a firmware update available or not. \(updateAction.rawValue)")
                }
                else {
                    Indicator.sharedInstance.hideIndicator()
                    self.checkDeviceSetup()
                }
            })
            
            ///////////
            
//            Ingenico.sharedInstance()?.paymentDevice.checkFirmwareUpdate({ (error, updateAction, firmwareInfo) in
//                print("Firmware Update: \(updateAction)")
//                appDelegate.showToast(message: "Firmware Update: \(updateAction)")
//                Indicator.sharedInstance.hideIndicator()
//                //SVProgressHUD.dismiss()
//                if (error != nil) {
//                    //SVProgressHUD.showError(withStatus: "Check firmware update failed")
//                    //appDelegate.showToast(message: "Check firmware update failed")
//                    appDelegate.showToast("Check firmware update failed")
//                    Indicator.sharedInstance.hideIndicator()
//                    //return
//                }
//                else if(updateAction == .FirmwareUpdateActionRequired || updateAction == .FirmwareUpdateActionOptional) {
//
//                    let alert = UIAlertController(title: "Firmware Update", message: "Firmware update is \(updateAction == .FirmwareUpdateActionRequired ? "required":"optional")", preferredStyle: .alert)
//                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//                        if (updateAction == .FirmwareUpdateActionOptional) {
//                            self.checkDeviceSetup()
//                        }
//                    })
//                    let update = UIAlertAction(title: "Update", style: .default, handler: { (action) in
//                        //SVProgressHUD.show(withStatus: "Downloading firmware...")
//                        appDelegate.showToast(message: "Downloading firmware...")
//                        Ingenico.sharedInstance()?.paymentDevice.updateFirmware(downloadProgress: { (downloaded, total) in
//                            //SVProgressHUD.showProgress(Float(downloaded/total), status: "Downloading firmware...")
//                            appDelegate.showToast(message: "Downloading firmware...")
//                        }, andFirmwareUpdateProgress: { (current, total) in
//                            let progress = Float(current)/Float(total)
//                            //SVProgressHUD.showProgress(progress, status: "Updating firmware...")
//                            appDelegate.showToast(message: "Updating firmware..")
//                        }, andOnDone: { (error) in
//                            //SVProgressHUD.dismiss()
//                            if error == nil {
//                                appDelegate.showToast(message: "Firmware update succeeded")
//                                //SVProgressHUD.showSuccess(withStatus: "Firmware update succeeded")
//                            }
//                            else {
//                                appDelegate.showToast(message: "Firmware update failed")
//                                //SVProgressHUD.showError(withStatus: "Firmware update failed")
//                            }
//                         })
//                    })
//                    alert.addAction(update)
//                    alert.addAction(cancel)
//                    self.present(alert, animated: true, completion: nil)
//                }
//                else {
//                    Indicator.sharedInstance.hideIndicator()
//                    self.checkDeviceSetup()
//                }
//            })
        } else {
            self.delegateCall?.reloadTableViewForIngenicoCheckBox()
            //Indicator.sharedInstance.hideIndicator()
        }
    }
    
    
    func checkDeviceSetup() {
        //SVProgressHUD.dismiss()
        Indicator.sharedInstance.showIndicator()
        if getIsLoggedIn() && getIsDeviceConnected() {
            Ingenico.sharedInstance()?.paymentDevice.checkSetup({ (error, isSetupRequired) in
                        if error != nil {
                            Indicator.sharedInstance.hideIndicator()
                            //SVProgressHUD.showError(withStatus: "Check device setup failed")
                        }
                        else if isSetupRequired {
                            
                            appDelegate.showToast(message: "Setting up device...")
                            Ingenico.sharedInstance()?.paymentDevice.setup(progressHandler: { (current, total) in
                                let progress = Float(current)/Float(total)
                                Indicator.sharedInstance.showIndicator()
                                //appDelegate.showToast(message: "Setting up device...")
                                //SVProgressHUD.showProgress(progress, status: "Setting up device...")
                            }, andOnDone: { (error) in
                                //SVProgressHUD.dismiss()
                                if error == nil {
                                    Indicator.sharedInstance.hideIndicator()
                                    self.delegateCall?.reloadTableViewForIngenicoCheckBox()
                                    appDelegate.showToast(message: "Device setup succeeded")
                                    //SVProgressHUD.showSuccess(withStatus: "Device setup succeeded")
                                }
                                else {
                                    Indicator.sharedInstance.hideIndicator()
                                    appDelegate.showToast(message: "Device setup failed")
                                     self.delegateCall?.reloadTableViewForIngenicoCheckBox()
                                    //SVProgressHUD.showError(withStatus: "Device setup failed")
                                }
                            })
                            
                            
            //                Ingenico.sharedInstance()?.paymentDevice.setup(progressHandler: { (current, total) in
            //                    let progress = Float(current)/Float(total)
            //                    Indicator.sharedInstance.showIndicator()
            //                    //SVProgressHUD.showProgress(progress, status: "Setting up device...")
            //                }, andOnDone: { (error) in
            //                    //SVProgressHUD.dismiss()
            //                    if error == nil {
            //                        Indicator.sharedInstance.hideIndicator()
            //                        //let settingController = SettingsViewController()
            //                        //settingController.tbl_Settings.reloadData()
            //                        //SVProgressHUD.showSuccess(withStatus: "Device setup succeeded")
            //                    }
            //                    else {
            //                        //SVProgressHUD.showError(withStatus: "Device setup failed")
            //                    }
            //                })
                           /* Indicator.sharedInstance.hideIndicator()
                            let alert = UIAlertController(title: "Device Setup", message: "Device setup is required", preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
                            let update = UIAlertAction(title: "Setup", style: .default, handler: { (action) in
                                //SVProgressHUD.show(withStatus: "Setting up device...")
                                appDelegate.showToast(message: "Setting up device...")
                                Ingenico.sharedInstance()?.paymentDevice.setup(progressHandler: { (current, total) in
                                    let progress = Float(current)/Float(total)
                                    Indicator.sharedInstance.showIndicator()
                                    //appDelegate.showToast(message: "Setting up device...")
                                    //SVProgressHUD.showProgress(progress, status: "Setting up device...")
                                }, andOnDone: { (error) in
                                    //SVProgressHUD.dismiss()
                                    if error == nil {
                                        Indicator.sharedInstance.hideIndicator()
                                        appDelegate.showToast(message: "Device setup succeeded")
                                        self.delegateCall?.reloadTableViewForIngenicoCheckBox()
                                        //SVProgressHUD.showSuccess(withStatus: "Device setup succeeded")
                                    }
                                    else {
                                        appDelegate.showToast(message: "Device setup failed")
                                         self.delegateCall?.reloadTableViewForIngenicoCheckBox()
                                        //SVProgressHUD.showError(withStatus: "Device setup failed")
                                    }
                                })
                            })
                            alert.addAction(update)
                            //alert.addAction(cancel)
                            self.present(alert, animated: true, completion: nil)*/
                        } else {
                            Indicator.sharedInstance.hideIndicator()
                            self.delegateCall?.reloadTableViewForIngenicoCheckBox()
                }
            })
        } else {
            Indicator.sharedInstance.hideIndicator()
            appDelegate.showToast(message: "Initial Device setup failed")
        }
        
    }
    
    func consoleLog (_ data:String){
        let formatter:DateFormatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm:ss"
        let dateStr:String = formatter.string(from: Date())
       // (self.tabBarController as! TabBarViewController).logString.append("[\(dateStr)]:\(data)\n")
    }
    
    //MARK:  Variables
    var pickerView = UIPickerView()
    var datePickerView = UIDatePicker()
    var pickerTextfield : UITextField!
    var pickerDelegate: HieCORPickerDelegate?
    var pickerArray = [String]()
    var pickervalueChanged = false
    var onSelectionCallback: ((String) -> ())? = nil
    var isCountrySelected = false
    var recentTextField: UITextField?
    var recentUIVIewController: UIViewController? = nil
    var isContactSourceSelected = false
    var customerStatusArrayData = DataManager.customerStatusType
    static var isDeviceConnected :Bool = false
    static var currentVC:BaseViewController!
    var connectingDevice : RUADevice?
    static var isLoggedIn:Bool = false
    static var lastTransactionType:IMSTransactionType?
    static var lastTransactionID:String?
    static var lastTokenId:String?
    static var lastClientTransactionId:String?
    var isSerialNumberSelected = false
    weak var delegateCall: SeetingControllerDelegate?
    var arraySourceList = [String]()
    var searchedContactArray = [String]()
    var locm:CLLocationManager?
    var location:CLLocation?
    var isCustomerStatusSelected = false

    var isInvoiceTamplate = false
    var onInvoiceTamplateSelectionCallback: ((String,Int) -> ())? = nil
    //Transition
    var transition: CATransition {
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 0.2
        return transition
    }
    
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            return
        }

        if locm == nil {
            locm = CLLocationManager()
            locm?.delegate = self
        }
        locm?.requestWhenInUseAuthorization();
        locm?.startUpdatingLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BaseViewController.currentVC=self;
       // IMSBaseViewController.currentVC.deviceStatusBarButton?.customView = getDeviceStatusImage()
        DeviceManagementHelper.shared.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint("********** MEMORY WARNING **********")
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    func callAPIToGetIngenico() {
        if DataManager.allowIngenicoPaymentMethod == "false" {
            return
        }
        var nameSource = ""
        if let name = DataManager.deviceNameText {
            nameSource = name

        }else {
            let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
            nameSource = nameDevice
        }
        HomeVM.shared.getIngenicoData(source: nameSource) { (success, message, error) in
            if success == 1 {
                //...Hiecor`s iPad (4)
            } else {
                if !Indicator.isEnabledIndicator {
                    return
                }
                if message != nil {
                    if message != "No Coupons Found." {
//                        self.showAlert(message: message!)
                        appDelegate.showToast(message: message!)
                    }
                }else {
                    if NetworkConnectivity.isConnectedToInternet() && !DataManager.isOffline{
                        self.showErrorMessage(error: error)
                    }
                }
            }
        }
    }
}

//MARK: Set Data Pickers DataSource and Delegate Methods
extension BaseViewController: UIPickerViewDelegate , UIPickerViewDataSource {
    
    func setPickerView(textField: UITextField, array: [String]) {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerArray = array
        pickerTextfield = textField
        pickervalueChanged = false
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.pickerViewDoneAction))
        doneButton.tintColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.pickerViewCancelAction))
        cancelButton.tintColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        //Set Picker View to Textfield
        textField.tintColor = UIColor.clear
        textField.inputView = pickerView
        pickerView.reloadAllComponents()
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    @objc func pickerViewDoneAction() {
        if pickerArray.count != 0 && !pickervalueChanged {
            pickerDelegate?.didSelectPickerViewAtIndex?(index: 0)
        }
        pickerDelegate?.didClickOnPickerViewDoneButton?()
        view.endEditing(true)
    }
    
    @objc func pickerViewCancelAction() {
        pickerDelegate?.didClickOnPickerViewCancelButton?()
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickervalueChanged = true
        if pickerArray.count == 0 {
            return
        }
        pickerDelegate?.didSelectPickerViewAtIndex?(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    //MARK: Custom Date Picker
    func setDatePicker(textField: UITextField, datePickerMode: UIDatePickerMode, maximunDate: Date?, minimumDate: Date?) {
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        if textField.text == "" {
            datePickerView.setDate(Date(), animated: true)
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateCur = dateFormatter.date(from: textField.text!)
            
            datePickerView.setDate(dateCur!, animated: true)
        }
        textField.inputView = datePickerView
        pickerTextfield = textField
      //  pickerTextfield.text = Date().stringFromDate(format: .mdyDate, type: .local)
        datePickerView.datePickerMode = datePickerMode
        datePickerView.timeZone = NSTimeZone.local
        
        //datePickerView.backgroundColor = UIColor.lightGray
        datePickerView.maximumDate = maximunDate
        datePickerView.minimumDate = minimumDate
        datePickerView.addTarget(self, action: #selector(self.didDatePickerViewValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func datePickerDoneAction() {
        pickerDelegate?.didClickOnDatePickerViewDoneButton?()
        view.endEditing(true)
    }
    
    @objc func didDatePickerViewValueChanged(sender: UIDatePicker) {
        pickerTextfield.text = sender.date.stringFromDate(format: .mdyDate, type: .local)
        pickerDelegate?.didSelectDatePicker?(date: sender.date)
    }
}

//MARK: Alert Methods
extension BaseViewController {
    
    func showAlert(title:String? = kAlert , message : String) {
//        appDelegate.showToast(message: message)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: nil))
        self.present(alert,animated: true)
    }
    
    func showErrorMessage(error: NSError?) {
            if error != nil {
                appDelegate.showErrorToast(message: error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg)
    //            let alert = UIAlertController(title: error!.domain, message: error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg, preferredStyle: .alert)
    //            alert.addAction(UIAlertAction(title: kOkay, style: .cancel, handler: nil))
    //            present(alert, animated: true, completion: nil)
            } else {
                appDelegate.showErrorToast(message: kUnableRequestMsg)
    //            let alert = UIAlertController(title: kAlert, message: kUnableRequestMsg, preferredStyle: .alert)
    //            alert.addAction(UIAlertAction(title: kOkay, style: .cancel, handler: nil))
    //            present(alert, animated: true, completion: nil)
            }
        }
    
    func closeAlert(title:String?,message: String?,cancelTitle: String, cancelAction: ((UIAlertAction)-> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: cancelAction))
        present(alert, animated: true, completion: nil)
    }
    //end anand
    func showAlert(title:String? = kAlert,message: String?, otherButtons:[String:((UIAlertAction)-> ())]? = nil, cancelTitle: String = kOkay, cancelAction: ((UIAlertAction)-> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if otherButtons != nil {
            for key in otherButtons!.keys {
                alert.addAction(UIAlertAction(title: key, style: .default, handler: otherButtons![key]))
            }
        }
        alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: cancelAction))
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage(error: NSError?, otherButtons:[String:((UIAlertAction)-> ())]? = nil, cancelTitle: String = kOkay, cancelAction: ((UIAlertAction)-> ())? = nil) {
        if error != nil {
            let alert = UIAlertController(title: error!.domain, message: error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg, preferredStyle: .alert)
            if otherButtons != nil {
                for key in otherButtons!.keys {
                    alert.addAction(UIAlertAction(title: key, style: .default, handler: otherButtons![key]))
                }
            }
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: cancelAction))
            present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: kAlert, message: kUnableRequestMsg, preferredStyle: .alert)
            if otherButtons != nil {
                for key in otherButtons!.keys {
                    alert.addAction(UIAlertAction(title: key, style: .default, handler: otherButtons![key]))
                }
            }
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: cancelAction))
            present(alert, animated: true, completion: nil)
        }
    }
    
}

//MARK: UIPopoverControllerDelegate
extension BaseViewController: UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.view.endEditing(true)
        self.recentTextField?.resignFirstResponder()
        self.recentTextField = nil
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

//MARK: Other Functions
extension BaseViewController {
    
    func formattedZIPCodeNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        //let mask = "+X (XXX) XXX-XXXX"
        let mask = "XXXXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func formattedPhoneNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var mask = ""
        if cleanPhoneNumber.count > 0 && cleanPhoneNumber.count < 8 {
            mask = "XXX-XXXX"
        } else if cleanPhoneNumber.count > 7 && cleanPhoneNumber.count < 11 {
            mask = "(XXX) XXX-XXXX"
        } else if cleanPhoneNumber.count > 10 {
            mask = "X (XXX) XXX-XXXXX"
        }
        
        //
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func phoneNumberFormateRemoveText(number: String) -> String {
        var result = ""
        
        if number != "" {
            result = number.replacingOccurrences(of: "[ |()-]", with: "", options: [.regularExpression])
        }        
        return result
    }
    
    func formattedCreditCardNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        //let mask = "+X (XXX) XXX-XXXX"
        let mask = "XXXX-XXXX-XXXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func setRootViewControllerForIphone() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let vc1 = storyboard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        let vc2 = storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        let nav = UINavigationController(rootViewController: vc1)
        nav.setNavigationBarHidden(true, animated: true)
        
        if !NetworkConnectivity.isConnectedToInternet() {
            var navStackArray : [UIViewController] = nav.viewControllers
            navStackArray.append(vc2)
            nav.setViewControllers(navStackArray, animated:false)
        }
        
        controller.setFront(nav, animated: true)
        appDelegate.window?.rootViewController = controller
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func setRootOrderHistoryViewControllerForIphone(orderId: String="") {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        let vc1 = storyboard.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
        if  orderId != "" {
            vc1.orderId = orderId
        }
        //let vc2 = storyboard.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        let nav = UINavigationController(rootViewController: vc1)
        nav.setNavigationBarHidden(true, animated: true)
        
        
        controller.setFront(nav, animated: true)
        appDelegate.window?.rootViewController = controller
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func showCustomTableView(_ viewController: UIViewController, sourceView: UITextField, countryName: String, callback: @escaping ((String) -> ())) {
        sourceView.resignFirstResponder()
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        isInvoiceTamplate = false
        //Offline
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            //            self.showAlert(title: "Oops!", message: "\(countryName != "" ? "Regions" : "Countries") are not avalable in the offline mode!")
            appDelegate.showToast(message:"\(countryName != "" ? "Regions" : "Countries") are not avalable in the offline mode!")
            return
        }
        
        //Country
        if (HomeVM.shared.countryDetail.count == 0 && countryName == "" ) {
            HomeVM.shared.getCountryList(country: "") { (success, message, error) in
                if success == 1 {
                    self.isCountrySelected = true
                    self.isCustomerStatusSelected = false
                    self.recentTextField = sourceView
                    self.onSelectionCallback = callback
                    self.showCustomView(viewController, array: HomeVM.shared.countryDetail.compactMap({$0.name}), sourceView: sourceView)
                }else {
                    if !Indicator.isEnabledIndicator {
                        return
                    }
                    if message != nil {
//                        self.showAlert(message: message!)
                        appDelegate.showToast(message: message!)
                    }else {
                        self.showErrorMessage(error: error)
                    }
                }
            }
            return
        }
        
        //Region
        if (HomeVM.shared.regionsList.count == 0 && countryName != "") || (self.recentTextField != sourceView && countryName != "") {
            HomeVM.shared.isAllDataLoaded = [false, false, false]
            HomeVM.shared.getRegionList(countryName: countryName, responseCallBack: { (success, message, error) in
                if success == 1 {
                    self.isContactSourceSelected = false
                    self.isCustomerStatusSelected = false
                    self.isCountrySelected = false
                    self.recentTextField = sourceView
                    self.onSelectionCallback = callback
                    self.showCustomView(viewController, array: HomeVM.shared.regionsList.compactMap({$0.str_regionName}), sourceView: sourceView)
                }else {
                    if !Indicator.isEnabledIndicator {
                        return
                    }
                    if message != nil {
//                        self.showAlert(message: message!)
                        appDelegate.showToast(message: message!)
                    }else {
                        self.showErrorMessage(error: error)
                    }
                }
            })
            return
        }
        //If Data Available
        if countryName == "" {
            //Country
            self.isContactSourceSelected = false
            self.isCountrySelected = true
            self.isCustomerStatusSelected = false
            self.recentTextField = sourceView
            self.onSelectionCallback = callback
            self.showCustomView(viewController, array: HomeVM.shared.countryDetail.compactMap({$0.name}), sourceView: sourceView)
        }else {
            //Region
            self.isContactSourceSelected = false
            self.isCountrySelected = false
            self.isCustomerStatusSelected = false
            self.recentTextField = sourceView
            self.onSelectionCallback = callback
            self.showCustomView(viewController, array: HomeVM.shared.regionsList.compactMap({$0.str_regionName}), sourceView: sourceView)
        }
    }
    
    func showContactSourceCustomTableView(_ viewController: UIViewController, sourceView: UITextField, contactSource: String, callback: @escaping ((String) -> ())) {
        sourceView.resignFirstResponder()
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        isInvoiceTamplate = false
        HomeVM.shared.getContactSources(responseCallBack: { (success, message, error) in
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                self.arraySourceList.removeAll()
                for data in HomeVM.shared.contactSourcesList {
                    self.arraySourceList.append(data)
                }
//                for i in (0...HomeVM.shared.contactSourcesList.count-1){
//                    self.arraySourceList.append(HomeVM.shared.contactSourcesList[i])
//                }
                self.isContactSourceSelected = true
               // self.isCountrySelected = false
                self.recentTextField = sourceView
                self.onSelectionCallback = callback
                self.showCustomView(viewController, array: self.arraySourceList.compactMap({$0}), sourceView: sourceView)
            }
        })
    }
    
    func customerStatus(_ viewController: UIViewController, sourceView: UITextField, contactSource: String, callback: @escaping ((String) -> ())) {
        sourceView.resignFirstResponder()
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        self.isCustomerStatusSelected = true
        isContactSourceSelected = false
        isInvoiceTamplate = false
        self.recentTextField = sourceView
        self.onSelectionCallback = callback
        self.showCustomView(viewController, array: (self.customerStatusArrayData?.compactMap({$0}))!, sourceView: sourceView)
    }
    func showInvoiceTamplate(_ viewController: UIViewController, sourceView: UITextField, contactSource: String, callback: @escaping ((String,Int) -> ())) {
        sourceView.resignFirstResponder()
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        self.isCustomerStatusSelected = false
        isContactSourceSelected = false
        isInvoiceTamplate = true
        self.recentTextField = sourceView
     //   self.onSelectionCallback = callback
        self.onInvoiceTamplateSelectionCallback = callback
        let array = HomeVM.shared.objInvoiceTemplateModel.aryTemplatesSettings.compactMap({$0.template_name})
        self.showCustomView(viewController, array: array, sourceView: sourceView)
    }
    func showCustomView(_ viewController: UIViewController, array: [String], sourceView: UITextField) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectCountryPopupVC") as! SelectCountryPopupVC
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        if isContactSourceSelected == true{
            vc.preferredContentSize = CGSize(width: sourceView.bounds.width, height: 185)
        }else{
            vc.preferredContentSize = CGSize(width: sourceView.bounds.width, height: 321)
        }
        vc.delegate = self
        vc.nameArray = array
        self.recentUIVIewController = vc
        if (isContactSourceSelected == true) || isInvoiceTamplate{
            vc.selectContactSource = true
        } else if isSerialNumberSelected {
            vc.selectContactSource = false
            vc.selectSerialNumber = true
        } else{
            vc.selectContactSource = false
        }
        let popController = vc.popoverPresentationController
        popController!.permittedArrowDirections = .init(rawValue: 0)
        popController!.backgroundColor = UIColor.white
        popController!.delegate = self
        popController!.sourceView = sourceView
        if isContactSourceSelected == true{
            popController!.sourceRect = CGRect(x: 0, y: sourceView.bounds.maxY , width: sourceView.bounds.width, height: 185)
        }else{
            popController!.sourceRect = CGRect(x: 0, y: sourceView.bounds.maxY , width: sourceView.bounds.width, height: 321)
        }
        viewController.present(vc, animated: true, completion: {
            vc.view.superview?.layer.cornerRadius = 0
            vc.view.superview?.borderColor = #colorLiteral(red: 0.8509055972, green: 0.8510283828, blue: 0.8508786559, alpha: 1)
            vc.view.superview?.borderWidth = 1.0
        })
    }
    // By Altab 18 Aug 2022
    func showSerialNumberTableView(_ viewController: UIViewController, sourceView: UITextField, productId: String, callback: @escaping ((String) -> ())) {
        sourceView.resignFirstResponder()
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        isInvoiceTamplate = false
        if  HomeVM.shared.SerialNumberDataListAry.count == 0 {
            HomeVM.shared.getSerialNumberApi(productId: productId) { (success, message, error) in
                if success == 1 {
                    //self.dismiss(animated: true, completion: nil)
                    self.isContactSourceSelected = false
                    self.isSerialNumberSelected = true
                    print("Featch serial number")
                    print(HomeVM.shared.SerialNumberDataListAry)
                    let optionArray = HomeVM.shared.SerialNumberDataListAry.map { String("\($0.serial_number.uppercased()) - \($0.location_name.uppercased())") }
    //                self.table.reloadData()
                    self.recentTextField = sourceView
                    self.onSelectionCallback = callback
                    self.showCustomView(viewController, array: optionArray, sourceView: sourceView)
                    
                }else {
                    self.isContactSourceSelected = false
                    self.isSerialNumberSelected = true
                    let obj = SerialNumberDataModel()
                    obj.serial_number = ""
                    obj.location_name = ""
                    HomeVM.shared.SerialNumberDataListAry.append(obj)
                    self.recentTextField = sourceView
                    self.onSelectionCallback = callback
                    self.showCustomView(viewController, array: [], sourceView: sourceView)
                    if message != nil {
                        appDelegate.showToast(message: message!)
                    }else {
                       // self.showErrorMessage(error: error)
                    }
                }
            }
        }else {
            self.isContactSourceSelected = false
            isSerialNumberSelected = true
            print("Featch serial number")
            print(HomeVM.shared.SerialNumberDataListAry)
            let optionArray = HomeVM.shared.SerialNumberDataListAry.map { String("\($0.serial_number.uppercased()) - \($0.location_name.uppercased())") }
//                self.table.reloadData()
            self.recentTextField = sourceView
            self.onSelectionCallback = callback
            self.showCustomView(viewController, array: optionArray, sourceView: sourceView)
        }

    }
    
    // MARK: CLLocationManager delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Failed to get current location:\(String(format: "%@", error.localizedDescription))")
        location = nil
        manager.delegate = nil
        manager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            NSLog("Location services was denied")
            location = nil
            manager.delegate = nil
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        NSLog("Deferred updates failed with error: \(error?.localizedDescription ?? "")")
        location = nil
        manager.delegate = nil
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastUpdateInterval:TimeInterval  = Date().timeIntervalSince((manager.location?.timestamp)!)
        if lastUpdateInterval > 60 {
            return
        }
        location = manager.location
        manager.delegate = nil
        manager.stopUpdatingLocation()
    }
    
    func getLongitude()->String?{
        return String(format: "%f", self.location?.coordinate.longitude ?? 0)
    }
    
    func getLatitude()->String?{
        return String(format: "%f", self.location?.coordinate.latitude ?? 0)
    }
    
}

//MARK: SelectCountryPopupVCDelegate
extension BaseViewController: SelectCountryPopupVCDelegate {
    func customContactSourceData(string: String) {
        self.recentTextField?.resignFirstResponder()
        self.onSelectionCallback?(string)
    }
    
    func didSelectValue(string: String, index: Int) {
        self.recentTextField?.resignFirstResponder()
        self.recentTextField = nil
        
        if isCountrySelected {
            //country
            let array = HomeVM.shared.countryDetail.compactMap({$0.abbreviation})
            self.onSelectionCallback?(array[index])
            HomeVM.shared.regionsList.removeAll()
            return
        }else{
            if isContactSourceSelected{
                //contact source
//                let array = arraySourceList.compactMap({$0})
                self.onSelectionCallback?(string)
                
            }else if isSerialNumberSelected {
                self.onSelectionCallback?(string)
            }else if isInvoiceTamplate{
                self.onInvoiceTamplateSelectionCallback?(string,index)
            } else{
                if isCustomerStatusSelected{
                    //Customer Status
                    let array = DataManager.customerStatusType?.compactMap({$0})
                    self.onSelectionCallback?(array?[index] ?? " ")
                }else{
                    //Region
                    let array = HomeVM.shared.regionsList.compactMap({$0.str_regionAbv})
                    self.onSelectionCallback?(array[index])
                }
               
            }
        }
        //end anand
        //Region
        //let array = HomeVM.shared.regionsList.compactMap({$0.str_regionAbv})
        //self.onSelectionCallback?(array[index])
    }
}

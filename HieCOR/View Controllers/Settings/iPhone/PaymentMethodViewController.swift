//
//  PaymentMethodViewController.swift
//  HieCOR
//
//  Created by Hiecor on 19/02/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth
import CoreBluetooth.CBService
import MobileCoreServices
import IQKeyboardManagerSwift

class PaymentMethodViewController: BaseViewController, SWRevealViewControllerDelegate, RUADeviceSearchListener, RUAAudioJackPairingListener, SeetingControllerDelegate, SettingViewControllerDelegate {
    func reloadTableViewForIngenicoCheckBox() {
        tbl_Settings.reloadData()
    }
    
    func paymentScreenReloadDelegate(){
        print("call")
        self.tbl_Settings.reloadData()
    }
    
    
    func isReaderSupported(_ reader: RUADevice) -> Bool{
        if (reader.name == nil){
            return false
        }
        print(reader.name)
        return reader.name.lowercased().hasPrefix("rp") || reader.name.lowercased().hasPrefix("mob") || reader.name.uppercased().hasPrefix("AUDIOJACK")
    }
    
    func discoveredDevice(_ reader: RUADevice!) {
        var isIncluded:Bool = false
        for device:RUADevice in deviceList {
            if device.identifier == reader.identifier {
                isIncluded = true
                break
            }
        }
        if !isIncluded {
            if isReaderSupported(reader){
                deviceList.append(reader)
            }
            
        }
        
        print(deviceList)
    }
    
    func discoveryComplete() {
        print(deviceList)
        isDiscoveryComplete = true
    }
    
    
    //MARK: - RUARadioJackPairingListener
    
    func onPairConfirmation(_ readerPasskey: String!, mobileKey mobilePasskey: String!) {
        DispatchQueue.main.async {
            let passKey:String = readerPasskey
            let message : String = String.init(format: "Passkey : %@", passKey)
            let notification:UILocalNotification  = UILocalNotification()
            notification.alertBody = message
            notification.fireDate = Date.init(timeIntervalSinceNow: 1)
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = TimeZone.current
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    func onPairSucceeded() {
        //   isPaired = true;
        DispatchQueue.main.async {
            //self.deviceStatusLabel.text = "Device Status: Pairing completed.\n Remove reader from  audio jack to test Bluetooth connection.\n Make sure reader is powered on."
        }
    }
    
    func onPairNotSupported() {
        //self.deviceStatusLabel.text = "Device Status: Pairing not supported"
    }
    
    func  onPairFailed() {
        //self.deviceStatusLabel.text = "Device Status: Pairing Failed"
    }
    
    func loginWithUserName( _ uname : String, andPW pw : String){
        
        self.view.endEditing(true)
        //SVProgressHUD.show(withStatus: "Logging")
        Ingenico.sharedInstance()?.user.loginwithUsername(uname, andPassword: pw) { (user, error) in
            //SVProgressHUD.dismiss()
            if (error == nil) {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.setLoggedIn(true)
                
                Indicator.sharedInstance.showIndicator()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.checkFirmwareUpdate()
                    self.cardReaderViewShowHideDelegate?.cardReaderViewShowHide?(with: true)
                    // self.cardReaderMainView.isHidden = true // Need sudama for new setting
                    self.tbl_Settings.reloadData()
                    //self.performSegue(withIdentifier:"loginsuccess" , sender: nil)
                }
                
            }else{
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
    
    func getPosEntryModeString(entryModes:[NSNumber])->String{
        
        if entryModes.count > 0 {
            let result:NSMutableString = NSMutableString()
            for pos in entryModes {
                switch IMSPOSEntryMode(rawValue: UInt(pos.intValue))! {
                case .POSEntryModeKeyed:
                    result.append("Keyed \n")
                case .POSEntryModeContactEMV:
                    result.append("ContactEMV \n")
                case .POSEntryModeContactlessEMV:
                    result.append("Contactless EMV \n")
                case .POSEntryModeContactlessMSR:
                    result.append("Contactless MSR \n")
                case .POSEntryModeMagStripe:
                    result.append("MagStripe \n")
                default:
                    break
                }
            }
            return result as String
        }
        else{
            return "No allowed pos entry mode"
        }
        
    }
    
    func getBatteryLevel() {
        if !getIsDeviceConnected(){
            //showDeviceNotConnectedErrorMessage()
        }else {
            //self.showProgressMessage("Getting Battery Level")
            ingenico?.paymentDevice.getBatteryLevel({ (batteryLevel, error) in
                if error == nil{
                    //self.showSucess( "Get Battery Level: \(batteryLevel)")
                

                        let posList:[NSNumber] = self.ingenico?.paymentDevice.allowedPOSEntryModes() as! [NSNumber]
                        //self.showSucess( "Get allowed POS Entry Modes Succeeded")
                        //appDelegate.showToast(message: "Get allowed POS Entry Modes Succeeded")
                        self.consoleLog("Allowed POS Entry Modes: \n \(self.getPosEntryModeString(entryModes: posList)) \n")
                    
                    self.consoleLog("Get Battery Level: \(batteryLevel)")
                    if DataManager.isIngenicoConnected {
                        
                        if self.getIsDeviceConnected() && self.getIsLoggedIn() {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IngenicoInfoController") as? IngenicoInfoController
                            vc?.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                            vc?.modalPresentationStyle = .overCurrentContext
                            vc?.strBetteryLife = batteryLevel ?? 0
                            //var Value = "\(self.getPosEntryModeString(entryModes: posList))"
                            //
                            
                            let aString = "\(self.getPosEntryModeString(entryModes: posList))"
                            let newString = aString.replacingOccurrences(of: "\n", with: " ", options: .literal, range: nil)
                            vc?.strPOSentryMode = newString
                            self.present(vc!, animated: true, completion: nil)

                        } else {
                            appDelegate.showToast(message: "login fail.")
                        }
                    }
                }else {
                    //self.showError("Get Battery Level Failed")
                    self.consoleLog("Get Battery Level Failed")
                }
            })
        }
    }

    

    
    //MARK: IBOutlet
    @IBOutlet var tbl_Settings: UITableView!
    
    //MARK: Variables
    private var array_PaymentMethods = Array<Any>()
    private var array_iconsList = Array<Any>()
    private var payment_Switch: UISwitch?
    private var isPaxSelected = false
    private var arraySelectedPaymet = [String]()
    private var selectedPaymentMethodIndex = Int()
    fileprivate var ingenico:Ingenico!
    fileprivate var deviceList:[RUADevice] = []
    private var isDiscoveryComplete = false;
    private weak var timer: Timer?
    let ClientVersion:String  = "4.2.3"
    var versionOb = Int()
    var strSelectNAME = ""
    
    
    //MARK: Delegate
    var paymentMethodSettingDelegate: SettingViewControllerDelegate?
    var cardReaderViewShowHideDelegate: SettingViewControllerDelegate?
    var paymentToMainiPadIngenicoDelegate: SettingViewControllerDelegate?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        versionOb = Int(DataManager.appVersion)!
        tbl_Settings.rowHeight = 50
        //  updatePaymentArray()
        
        strSelectNAME = DataManager.strIngenicoDeviceName ?? ""
        
        ingenico = Ingenico.sharedInstance()
        ingenico.setLogging(false)
        deviceList = [RUADevice]()
        delegateCall = self
        // timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(SearchAgainIngenicoData), userInfo: nil, repeats: true)
        
        if DataManager.isIngenicoConnected {
            if getIsDeviceConnected() {
                
            } else {
                SearchAgainIngenicoData()
            }
        } else {
            SearchAgainIngenicoData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DataManager.selectedPayment = arraySelectedPaymet
        //timer?.invalidate()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.loadData()
        
    }
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ingenico"
        {
            let vc = segue.destination as! CardReaderViewController
            paymentToMainiPadIngenicoDelegate = vc
            
        }
    }
    
    private func loadData() {
        arraySelectedPaymet = ["CREDIT"]
        if DataManager.selectedPayment != nil
        {
            arraySelectedPaymet = DataManager.selectedPayment!
        }
        self.updatePaymentArray()
        self.automaticallyAdjustsScrollViewInsets = false
        tbl_Settings.contentInset = UIEdgeInsets.zero
        tbl_Settings.tableFooterView = UIView()
        tbl_Settings.reloadData()
    }
    
    private func removePaymentData(method: String) {
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String {
            if method == key || method == "MULTI CARD" {
                PaymentsViewController.paymentDetailDict.removeAll()
            }
        }
    }
    
    @objc func SearchAgainIngenicoData() {
        if HomeVM.shared.ingenicoData.count > 0 {
            ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                clientVersion: ClientVersion)
            
            //if communicationSegment.selectedSegmentIndex == 1 {
            // doSearching()
            
            //self.ingenico.paymentDevice.setDeviceType(RUADeviceTypeRP45BT)
            self.ingenico.paymentDevice.setDeviceType(RUADeviceType(rawValue: DataManager.RUADeviceTypeValueDataSet))
            
            self.ingenico.paymentDevice.search(self)
        }
    }
    
    @IBAction func paymentBackAction(_ sender: Any) {
        paymentMethodSettingDelegate?.didMoveToNextScreen?(with: "Checkout Options")
    }
    
    private func updatePaymentArray() {
        if DataManager.showTerminalIntregationSettings == "true" {
            self.isPaxSelected = arraySelectedPaymet.contains("PAX PAY")
        }else {
            self.isPaxSelected = false
        }
        
        
        if isPaxSelected {
            //array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY", "     CREDIT", "     DEBIT", "     GIFT" ,"INTERNAL GIFT CARD"]
            if versionOb < 4 {
                array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "CHECK", "EXTERNAL", "PAX PAY", "     CREDIT", "     DEBIT", "     GIFT"]
            }else{
                if DataManager.allowIngenicoPaymentMethod == "true" {
                    if DataManager.isCardReader {
                        array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY", "     CREDIT", "     DEBIT", "     GIFT" , "CARD READER", "RP45BT", "MOBY5500", "RP450C", "INTERNAL GIFT CARD",]
                    }else{
                        array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY", "     CREDIT", "     DEBIT", "     GIFT" , "CARD READER" ,"INTERNAL GIFT CARD"]
                    }
                } else {
                    array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY", "     CREDIT", "     DEBIT", "     GIFT" ,"INTERNAL GIFT CARD"]
                }
            }
        }else {
            // array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY","INTERNAL GIFT CARD"]
            if versionOb < 4 {
                array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "CHECK", "EXTERNAL", "PAX PAY"]
            }else{
                if DataManager.allowIngenicoPaymentMethod == "true" {
                    if DataManager.isCardReader {
                        array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY", "CARD READER", "RP45BT", "MOBY5500", "RP450C", "INTERNAL GIFT CARD"]
                    } else {
                        array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY", "CARD READER", "INTERNAL GIFT CARD"]
                    }
                } else {
                    array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY","INTERNAL GIFT CARD"]
                }
            }
        }
        if DataManager.ShowHeartlandGiftcardsMethod == "false" {
            array_PaymentMethods = array_PaymentMethods.filter { $0 as! String != "GIFT CARD" }
            arraySelectedPaymet = arraySelectedPaymet.filter{ $0 != "GIFT CARD"}
            DataManager.isGiftCard = false
        }

        if DataManager.ShowPaxHeartlandGiftcardsMethod == "false" {
            array_PaymentMethods = array_PaymentMethods.filter { $0 as! String != "     GIFT" }
            arraySelectedPaymet = arraySelectedPaymet.filter{ $0 != "     GIFT"}
            DataManager.selectedPAX = DataManager.selectedPAX.filter { $0 != "GIFT" }

            DataManager.isPaxPayGiftCard = false
        }

        if DataManager.showTerminalIntregationSettings == "false" || DataManager.showTerminalIntregationSettings == "" {
            for i in 0..<array_PaymentMethods.count-1 {
                if  array_PaymentMethods[i] as! String == "PAX PAY" {
                    array_PaymentMethods.remove(at: i)
                }else if  array_PaymentMethods[i] as! String == "     CREDIT" {
                    array_PaymentMethods.remove(at: i)
                }else if  array_PaymentMethods[i] as! String == "     DEBIT" {
                    array_PaymentMethods.remove(at: i)
                }else if  array_PaymentMethods[i] as! String == "     GIFT" {
                    array_PaymentMethods.remove(at: i)
                }
            }
            
            for i in 0..<arraySelectedPaymet.count-1{
                if  arraySelectedPaymet[i] == "PAX PAY" {
                    arraySelectedPaymet.remove(at: i)
                }else if  arraySelectedPaymet[i] == "     CREDIT" {
                    arraySelectedPaymet.remove(at: i)
                }else if  arraySelectedPaymet[i] == "     DEBIT" {
                    arraySelectedPaymet.remove(at: i)
                }else if  arraySelectedPaymet[i] == "     GIFT" {
                    arraySelectedPaymet.remove(at: i)
                }
            }
        }

        print(array_PaymentMethods)
        DataManager.selectedPayment = arraySelectedPaymet
        tbl_Settings.reloadData()
    }
}
//MARK: UITableViewDataSource, UITableViewDelegate
extension PaymentMethodViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_PaymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_Settings.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! SettingsTableCell
        
        // let lbl_Name = cell.contentView.viewWithTag(1) as? UILabel
        let switchBtn = cell.contentView.viewWithTag(111) as? UISwitch
        let nameLb = array_PaymentMethods[indexPath.row] as? String
        if nameLb == "RP45BT" || nameLb == "RP450C" || nameLb == "MOBY5500" || nameLb == "RP750X" || nameLb == "MOBY3000" || nameLb == "MOBY8500" {
            cell.label?.text = "     \(nameLb!)"
        }else{
            cell.label?.text = nameLb?.capitalized
        }
        //cell.label?.text = nameLb?.capitalized
        
        cell.switchButton.removeTarget(self, action: #selector(btn_PaymentAction(sender:)), for: .allEvents)
        if array_PaymentMethods[indexPath.row] as? String == "MULTI CARD" {
            cell.label?.text = "SPLIT PAYMENT"
        }
        
        if array_PaymentMethods[indexPath.row] as? String == "GIFT CARD" {
            cell.label?.text = "HEARTLAND GIFT CARD"
        }
        
        cell.switchButton.tag = indexPath.row
        cell.switchButton.setOn(arraySelectedPaymet.contains(array_PaymentMethods[indexPath.row] as? String ?? ""), animated: false)
        //payment_Switch = paySwitch
        
        cell.switchButton.isHidden = false
        
        if isPaxSelected && (nameLb == "     CREDIT" || nameLb == "     DEBIT" || nameLb == "     GIFT") {
            if nameLb == "     GIFT" {
                cell.switchButton.setOn(DataManager.isPaxPayGiftCard, animated: false)
            }
            let selectedPaymentName = (array_PaymentMethods[indexPath.row] as! String).replacingOccurrences(of: " ", with: "")
            cell.switchButton.setOn(DataManager.selectedPAX.contains(selectedPaymentName), animated: false)
        }
        
        if nameLb == "GIFT CARD" {
            cell.switchButton.setOn(DataManager.isGiftCard, animated: false)
        }
        
        
        if isPaxSelected && nameLb == "PAX PAY" {
            // cell.viewLineLeadingConstrant.constant = 50
            cell.switchButton.setOn(true, animated: false)
            
        }else{
            cell.viewLineLeadingConstrant.constant = 20
        }
        
        /*if DataManager.isCardReader {
            if !isPaxSelected && indexPath.row == 12 {
                cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
            }
            if isPaxSelected && indexPath.row == 15 {
                cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
            }
        }else{
            if !isPaxSelected && indexPath.row == 11 {
                cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
            }
            if isPaxSelected && indexPath.row == 14 {
                cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
            }
        }
        
        if isPaxSelected && indexPath.row == 13 {
            cell.switchButton.setOn(DataManager.isCardReader, animated: false)
        }
        
        
        if !isPaxSelected && indexPath.row == 10 {
            cell.switchButton.setOn(DataManager.isCardReader, animated: false)
        }*/
        
        if DataManager.allowIngenicoPaymentMethod == "true" {
              if DataManager.isCardReader {
                  if !isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                      cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
                  }
                  if isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                      cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
                  }
              }else{
                  if !isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                      cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
                  }
                  if isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                      cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
                  }
              }
              if isPaxSelected && nameLb == "CARD READER" {
                  cell.switchButton.setOn(DataManager.isCardReader, animated: false)
              }
              
              
              if !isPaxSelected && nameLb == "CARD READER" {
                  cell.switchButton.setOn(DataManager.isCardReader, animated: false)
              }
          }else{
              
                  if !isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                      cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
                  }
                  if isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                      cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
                  }
        
          }
        
        if isPaxSelected && nameLb == "     CREDIT" {
            cell.viewLineLeadingConstrant.constant = 35
            
        }
        if isPaxSelected && nameLb == "     DEBIT" {
            cell.viewLineLeadingConstrant.constant = 35
            
        }
        if isPaxSelected && nameLb == "     GIFT" {
            cell.viewLineLeadingConstrant.constant = 35
            
        }
        
        
        if DataManager.isCardReader {
            if !isPaxSelected && (nameLb == "RP45BT" || nameLb == "RP450C" || nameLb == "MOBY5500" || nameLb == "RP750X" || nameLb == "MOBY3000" || nameLb == "MOBY8500") {
                cell.viewLineLeadingConstrant.constant = 35
                
            }
            
            if isPaxSelected && (nameLb == "RP45BT" || nameLb == "RP450C" || nameLb == "MOBY5500" || nameLb == "RP750X" || nameLb == "MOBY3000" || nameLb == "MOBY8500"){
                cell.viewLineLeadingConstrant.constant = 35
                
            }
        }
        cell.button.addTarget(self, action: #selector(btn_CheckIngenicoSetup(sender:)), for: .touchUpInside)
        cell.btnInfo.addTarget(self, action: #selector(btn_CheckIngenicoInfo(sender:)), for: .touchUpInside)

        if nameLb == "RP45BT" || nameLb == "RP450C" || nameLb == "MOBY5500" || nameLb == "RP750X" || nameLb == "MOBY3000" || nameLb == "MOBY8500" {
            cell.switchButton.isHidden = true
            cell.switchButton.setOn(DataManager.isCardReader, animated: false)
            if strSelectNAME == nameLb {
                if self.getIsDeviceConnected() {
                    cell.accessoryType =  .checkmark
                    cell.backgroundColor = UIColor.yellow
                    cell.button.isHidden = true
                    cell.button.setTitle("Setup", for: .normal)
                    cell.btnInfo.isHidden = false
                    
                } else {
                    cell.backgroundColor = UIColor.white
                    cell.accessoryType =  .none
                    cell.button.isHidden = true
                    cell.btnInfo.isHidden = true
                }
                cell.setEditing(false, animated: false)
            } else {
                cell.accessoryType =  .none
                cell.backgroundColor = UIColor.white
                cell.accessoryView = nil
                cell.button.isHidden = true
                cell.btnInfo.isHidden = true
            }
            
        } else {
            cell.accessoryType =  .none
            cell.backgroundColor = UIColor.white
            cell.accessoryView = nil
            cell.button.isHidden = true
            cell.btnInfo.isHidden = true
        }
        
        //  payment_Switch?.tag = indexPath.row
        print("indexPath.row--\(indexPath.row)")
        
        cell.switchButton?.addTarget(self, action:#selector(btn_PaymentAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameLb = self.array_PaymentMethods[indexPath.row] as? String

        if nameLb == "RP45BT" || nameLb == "RP450C" || nameLb == "MOBY5500" || nameLb == "RP750X" || nameLb == "MOBY3000" || nameLb == "MOBY8500"{
            if getIsDeviceConnected() {
                let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure want to Disconnect?", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                                
                    Ingenico.sharedInstance()?.user.logoff { (error) in
                        self.setLoggedIn(false)
                    }
                    DataManager.RUADeviceTypeValueDataSet = RUADeviceTypeUnknown.rawValue
                    Ingenico.sharedInstance()?.paymentDevice.release()
                    Ingenico.sharedInstance()?.paymentDevice.stopSearch()
                    self.connectingDevice = nil
                    self.strSelectNAME = ""
                    //DataManager.strIngenicoDeviceName = ""
                    self.cardReaderViewShowHideDelegate?.cardReaderViewShowHide?(with: true)
                    self.tbl_Settings.reloadData()
                    appDelegate.showToast(message: "Device disconnected.")
                    return
                    
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                present(refreshAlert, animated: true, completion: nil)
            } else {
                let nameLb = self.array_PaymentMethods[indexPath.row] as? String
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    DataManager.strIngenicoDeviceName = nameLb ?? ""
                    self.strSelectNAME = nameLb ?? ""
                    
                    if DataManager.isCardReader {
                        
                        if nameLb == "RP45BT" || nameLb == "RP450C" || nameLb == "MOBY5500" || nameLb == "RP750X" || nameLb == "MOBY3000" || nameLb == "MOBY8500"{
                            if nameLb == "RP45BT" {
                                appDelegate.strIngenicoDeviceName = "RP45BT"
                                DataManager.RUADeviceTypeValueDataSet = RUADeviceTypeRP45BT.rawValue
                            } else if nameLb == "RP450C" {
                                appDelegate.strIngenicoDeviceName = "RP450"
                                DataManager.RUADeviceTypeValueDataSet = RUADeviceTypeRP450c.rawValue
                            } else if nameLb == "MOBY5500" {
                                appDelegate.strIngenicoDeviceName = "MOB55"
                                DataManager.RUADeviceTypeValueDataSet = RUADeviceTypeMOBY5500.rawValue
                            } else if nameLb == "RP750X" {
                                DataManager.RUADeviceTypeValueDataSet = RUADeviceTypeRP750x.rawValue
                            } else if nameLb == "MOBY3000" {
                                DataManager.RUADeviceTypeValueDataSet = RUADeviceTypeMOBY3000.rawValue
                            } else {
                                DataManager.RUADeviceTypeValueDataSet = RUADeviceTypeMOBY8500.rawValue
                            }
                            
                            if DataManager.isIngenicoConnected {
                                //appDelegate.showToast(message: "Device Setup Inside")
                                if self.getIsDeviceConnected() {
                                    Indicator.sharedInstance.showIndicator()
                                    Ingenico.sharedInstance()?.paymentDevice.checkSetup({ (error, isSetupRequired) in
                                        if error != nil {
                                            //SVProgressHUD.showError(withStatus: "Check device setup failed")
                                            print("setup error")
                                            //appDelegate.showToast(message: "Device Setup error")
                                            self.loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password)
                                            Indicator.sharedInstance.hideIndicator()
                                        }
                                        else if isSetupRequired {
                                            print("setup required")
                                            //appDelegate.showToast(message: "Device Setup required")
                                            Indicator.sharedInstance.hideIndicator()
                                            self.checkDeviceSetup()
                                        } else {
                                            print("setup Done")
                                            appDelegate.showToast(message: "Device Setup Already Completed")
                                            Indicator.sharedInstance.hideIndicator()
                                            self.tbl_Settings.reloadData()
                                        }
                                    })
                                    return
                                }
                            }
                            // let IngenicoModelObj = IngenicoModel()
                            self.ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                                     apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                                     clientVersion: self.ClientVersion)
                            
                            //if communicationSegment.selectedSegmentIndex == 1 {
                            // doSearching()
                            
                            //self.ingenico.paymentDevice.setDeviceType(RUADeviceTypeRP45BT)
                            self.ingenico.paymentDevice.setDeviceType(RUADeviceType(rawValue: DataManager.RUADeviceTypeValueDataSet))
                            
                            self.ingenico.paymentDevice.search(self)
                            // cardReaderMainView.isHidden = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                self.paymentToMainiPadIngenicoDelegate?.IngenicoDeviceListDelegate?()
                                self.paymentToMainiPadIngenicoDelegate?.IngenicoDeviceDataDelegateData?(with: self.deviceList)
                                self.cardReaderViewShowHideDelegate?.cardReaderViewShowHide?(with: false)
                            }            //  moveToSyncScreen()
                        }
                        
                    }
                }
            }
        }
        
    }
    
    @objc func btn_CheckIngenicoSetup(sender: UIButton)
    {
//        if DataManager.isIngenicoConnected {
//            appDelegate.showToast(message: "Device Setup Inside")
//
//            self.loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password)
//
//
//            if self.getIsDeviceConnected() && self.getIsLoggedIn() {
//                Indicator.sharedInstance.showIndicator()
//                appDelegate.showToast(message: "start setup")
//                checkFirmwareUpdate()
//            } else {
//                appDelegate.showToast(message: "login fail.")
//            }
//        }
    }
    
    @objc func btn_CheckIngenicoInfo(sender: UIButton)
    {
        
        getBatteryLevel()
    }
    
    @objc func btn_PaymentAction(sender: UISwitch)
    {
        
        let nameLb = array_PaymentMethods[sender.tag] as? String
        
        if !sender.isOn {
            removePaymentData(method: array_PaymentMethods[sender.tag] as? String ?? "")
        }
                
        if isPaxSelected && (nameLb == "     CREDIT" || nameLb == "     DEBIT" || nameLb == "     GIFT") {
            
            if nameLb == "     GIFT"{
                DataManager.isPaxPayGiftCard = sender.isOn
            }
            
            let selectedPaymentName = (array_PaymentMethods[sender.tag] as! String).replacingOccurrences(of: " ", with: "")
            
            if DataManager.selectedPAX.contains((selectedPaymentName))
            {
                if DataManager.selectedPAX.count < 2 {
                    self.updatePaymentArray()
                    return
                }
                let index = DataManager.selectedPAX.index(of: (selectedPaymentName))
                DataManager.selectedPAX.remove(at: index!)
            }
            else
            {
                DataManager.selectedPAX.append(selectedPaymentName)
            }
            
            self.updatePaymentArray()
            return
        }
        
        if arraySelectedPaymet.contains(array_PaymentMethods[sender.tag] as! String)
        {
            //Sudama
            if arraySelectedPaymet.contains("MULTI CARD") && (nameLb == "MULTI CARD") {
                print("splite payment option off")
            }else{
                if arraySelectedPaymet.contains("MULTI CARD") {
                    if arraySelectedPaymet.count < 3 {
                        self.updatePaymentArray()
                        return
                    }
                }
            }
            //Sudama
            if arraySelectedPaymet.count < 2 {
                self.updatePaymentArray()
                return
            }
            let index = arraySelectedPaymet.index(of: array_PaymentMethods[sender.tag] as! String)
            arraySelectedPaymet.remove(at: index!)
        }
        else
        {
            selectedPaymentMethodIndex = sender.tag
            arraySelectedPaymet.append(array_PaymentMethods[selectedPaymentMethodIndex] as! String)
        }
        
        if nameLb == "GIFT CARD" {
            DataManager.isGiftCard = sender.isOn
        }
        
        /*if isPaxSelected && sender.tag == 13 {
            DataManager.isCardReader = sender.isOn
            self.tbl_Settings.scrollToBottom()
        }
        if !isPaxSelected && sender.tag == 10 {
            DataManager.isCardReader = sender.isOn
            self.tbl_Settings.scrollToBottom()
        }
        
        if DataManager.isCardReader {
            if !isPaxSelected && sender.tag == 12 {
                DataManager.isInternalGift = sender.isOn
            }
            if isPaxSelected && sender.tag == 15 {
                DataManager.isInternalGift = sender.isOn
            }
            
        }else {
            if !isPaxSelected && sender.tag == 11 {
                DataManager.isInternalGift = sender.isOn
            }
            if isPaxSelected && sender.tag == 14 {
                DataManager.isInternalGift = sender.isOn
            }
        }*/
        
        if DataManager.allowIngenicoPaymentMethod == "true" {
            if DataManager.isCardReader {
                if !isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                    DataManager.isInternalGift = sender.isOn
                }
                if isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                    DataManager.isInternalGift = sender.isOn
                }
                
            }else {
                if !isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                    DataManager.isInternalGift = sender.isOn
                }
                if isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                    DataManager.isInternalGift = sender.isOn
                }
            }
            if isPaxSelected && nameLb == "CARD READER" {
                
                if getIsDeviceConnected() {
                    //let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure want to Disconnect?", preferredStyle: UIAlertControllerStyle.alert)
                    
                    //refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                                    
                        Ingenico.sharedInstance()?.user.logoff { (error) in
                            self.setLoggedIn(false)
                        }
                        DataManager.RUADeviceTypeValueDataSet = RUADeviceTypeUnknown.rawValue
                        self.connectingDevice = nil
                        Ingenico.sharedInstance()?.paymentDevice.release()
                        Ingenico.sharedInstance()?.paymentDevice.stopSearch()
                        
                        self.strSelectNAME = ""
                        //DataManager.strIngenicoDeviceName = ""
                        self.cardReaderViewShowHideDelegate?.cardReaderViewShowHide?(with: true)
                        //self.tbl_Settings.reloadData()
                        DataManager.isCardReader = sender.isOn
                        self.tbl_Settings.scrollToBottom()
                        appDelegate.showToast(message: "Device disconnected.")
                        
                    //}))
                    
                    //refreshAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (action: UIAlertAction!) in
                        
                    //}))
                    //present(refreshAlert, animated: true, completion: nil)
                } else {
                    DataManager.isCardReader = sender.isOn
                    self.tbl_Settings.scrollToBottom()
                }
            }
            if !isPaxSelected && nameLb == "CARD READER" {
                if getIsDeviceConnected() {
                    //let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure want to Disconnect?", preferredStyle: UIAlertControllerStyle.alert)
                    
                    //refreshAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
                                    
                        Ingenico.sharedInstance()?.user.logoff { (error) in
                            self.setLoggedIn(false)
                        }
                        DataManager.RUADeviceTypeValueDataSet = RUADeviceTypeUnknown.rawValue
                        Ingenico.sharedInstance()?.paymentDevice.release()
                        Ingenico.sharedInstance()?.paymentDevice.stopSearch()
                        self.connectingDevice = nil
                        self.strSelectNAME = ""
                        //DataManager.strIngenicoDeviceName = ""
                        self.cardReaderViewShowHideDelegate?.cardReaderViewShowHide?(with: true)
                        self.tbl_Settings.reloadData()
                        DataManager.isCardReader = sender.isOn
                        self.tbl_Settings.scrollToBottom()
                        appDelegate.showToast(message: "Device disconnected.")
                        
                    //}))
                    
                    //refreshAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (action: UIAlertAction!) in
                        
                    //}))
                    //present(refreshAlert, animated: true, completion: nil)
                } else {
                    DataManager.isCardReader = sender.isOn
                    self.tbl_Settings.scrollToBottom()
                }
            }
        }else{
         
                if !isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                    DataManager.isInternalGift = sender.isOn
                }
                if isPaxSelected && nameLb == "INTERNAL GIFT CARD" {
                    DataManager.isInternalGift = sender.isOn
                }
            
        }
        self.updatePaymentArray()
        
    }
}



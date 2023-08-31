//
//  SettingsViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 12/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth
import CoreBluetooth.CBService
import MobileCoreServices
import IQKeyboardManagerSwift
import ExternalAccessory

class SettingsViewController: BaseViewController, RUADeviceSearchListener, RUAAudioJackPairingListener, SeetingControllerDelegate {
    enum CellParamIndex: Int {
        case portName = 0
        case modelName
        case macAddress
    }
    func reloadTableViewForIngenicoCheckBox() {
        tbl_Settings.reloadData()
    }
    
    
    func isReaderSupported(_ reader: RUADevice) -> Bool{
        if (reader.name == nil){
            return false
        }
        print(reader.name)
        return reader.name.lowercased().hasPrefix("rp") || reader.name.lowercased().hasPrefix("mob")
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
            
            
            /*
             let frame:CGRect = searchView.frame
             let screenFrame:CGRect = self.view.frame
             
             let heightVal: CGFloat = (screenFrame.size.height - CGFloat(40.0))
             if (heightVal >= CGFloat(80 * deviceList.count)){
             searchTableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: CGFloat(80*deviceList.count))
             }else{
             searchTableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: screenFrame.size.height-40)
             }
             */
            tbl_CardReaderDevice.reloadData()
        }
//        else {
//            if deviceList.count > 0 {
//                self.cardReaderMainView.isHidden = false
//                tbl_CardReaderDevice.reloadData()
//            } else {
//                self.cardReaderMainView.isHidden = true
//                appDelegate.showToast(message: "Device not found")
//            }
//        }
        print(deviceList)
    }
    
    func discoveryComplete() {
        print(deviceList)
        isDiscoveryComplete = true
//        if deviceList.count > 0 {
//            self.cardReaderMainView.isHidden = false
//            tbl_CardReaderDevice.reloadData()
//        } else {
//            self.cardReaderMainView.isHidden = true
//            appDelegate.showToast(message: "Device not found")
//        }
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
                    self.cardReaderMainView.isHidden = true
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
    
    //MARK: IBOutlet
    @IBOutlet var btn_Menu: UIButton!
    @IBOutlet var tbl_Settings: UITableView!
    @IBOutlet weak var posLabel: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var lockLineView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoutLineView: UIView!
    
    @IBOutlet weak var tbl_CardReaderDevice: UITableView!
    @IBOutlet weak var cardReaderMainView: UIView!
    @IBOutlet weak var cardReaderDeviceViewWidth: NSLayoutConstraint!
    @IBOutlet weak var cardReaderDeviceViewHeight: NSLayoutConstraint!
    //MARK: Variables
    private var sectionArray = [String]()
    private var array_PaymentMethods = Array<Any>()
    private var array_SignatureAndReceipt = Array<Any>()
    private var taxes_Switch: UISwitch?
    private var selectedPaymentMethodIndex = Int()
    private var arraySelectedPaymet = [String]()
    private var array_Printer = Array<Any>()
    private var str_DeviceName = String()
    private var connectedPrinterUUID = String()
    private var selectedIndex = [Int]()
    private var selectedRowIndex = [Int]()
    private var isShowAlert = true
    private var isPaxSelected = false
    private weak var timer: Timer?
    var versionOb = Int()
    
    //MARK: PrinterManager
    static var printerManager: PrinterManager?
    static var printerArray = [PrinterStruct]()
    static var printerUUID: UUID? = nil
    
    static var centeralManager: CBCentralManager?
    
    fileprivate var ingenico:Ingenico!
    fileprivate var deviceList:[RUADevice] = []
    let ClientVersion:String  = "4.2.3"
    private var isDiscoveryComplete = false;
    
    var isSearch = false
    var isBluetoothOn = false
    var isPaperWidth = false
    var arrPaperWidthSize = ["58","80"]
    // Star printer
    var startPrntArray: NSMutableArray!
    var startArr = [PortInfo]()
    var currentSetting: PrinterSetting? = nil
    var manager = EAAccessoryManager.shared()
    
    var portName:     String!
    var portSettings: String!
    var modelName:    String!
    var macAddress:   String!
    var paperSizeIndex: PaperSizeIndex? = nil
    
    var emulation: StarIoExtEmulation!
    
    var selectedModelIndex: ModelIndex?
      var selectedPrinterIndex: Int = 0
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startPrntArray = NSMutableArray()
        LoadStarPrinter.settingManager.load()
        SettingsViewController.centeralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)

        ingenico = Ingenico.sharedInstance()
        ingenico.setLogging(false)
        deviceList = [RUADevice]()
        delegateCall = self
                
//        if (DataManager.selectedPayment != nil) {
//            arraySelectedPaymet = DataManager.selectedPayment!
//        }
        
        tbl_CardReaderDevice.dataSource = self
        tbl_CardReaderDevice.delegate = self
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        if UI_USER_INTERFACE_IDIOM() == .pad {
            cardReaderDeviceViewWidth.constant = displayWidth * 0.5
        }else{
             cardReaderDeviceViewWidth.constant = displayWidth - 40
        }
       
        cardReaderDeviceViewHeight.constant = displayHeight/2
        if DataManager.isBluetoothPrinter {
            loadPrinter()
        }
        versionOb = Int(DataManager.appVersion)!
        loadSWRevealView()
        self.callAPItoGetCountryList()
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(SearchAgainIngenicoData), userInfo: nil, repeats: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //OfflineDataManager Delegate
        OfflineDataManager.shared.settingDelegate = self
        //Disable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        self.loadData()
        //Hide POS Label
        if UI_USER_INTERFACE_IDIOM() == .pad {
            posLabel.isHidden = false
            //Update Name
            if let name = DataManager.deviceNameText {
                posLabel.text = name
            }else {
                posLabel.text = "POS"
            }
            buttonsView.isHidden = false
        }else {
            buttonsView.isHidden = true
            posLabel.isHidden = true
        }
        self.lockLineView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.lockButton.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.logoutButton.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.logoutLineView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        SwipeAndSearchVC.shared.isEnable = false
        loadStarPrint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        OfflineDataManager.shared.settingDelegate = nil
        //Disable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = true
        //Save Data
        DataManager.selectedPayment = arraySelectedPaymet
        //Invalidate Timer
        isShowAlert = false
        timer?.invalidate()
    }
    
    //MARK Private Functions
    private func loadSWRevealView() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            btn_Menu.setImage(#imageLiteral(resourceName: "menu-blue"), for: .normal)
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as? SWRevealViewController
            if (vc != nil)
            {
                vc!.delegate = self
                btn_Menu?.addTarget(vc, action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }else {
            btn_Menu.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
            if (self.revealViewController() != nil)
            {
                revealViewController().delegate = self
                btn_Menu?.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
    }
    
    private func removePaymentData(method: String) {
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String {
            if method == key || method == "MULTI CARD" {
                PaymentsViewController.paymentDetailDict.removeAll()
            }
        }
    }
    
    private func loadData() {
        isShowAlert = true
        selectedIndex.removeAll()
        
//        if versionOb < 4 {
//            sectionArray = ["Taxes", "Offline Mode","Products SYNC", "Customer Management", "Payment Method", "Signature and Receipt", "PIN Login Every Transaction", "Device Name", "Printers", "Cash Drawers", "Barcode Scanners", "Collect Tips", "Enable Auth","Coupons List", "Show Country", "Split Row", "Discount Options", "Line Item Tax Exempt","Edit Product","Swipe To Pay"]
//        } else {
            sectionArray = ["Taxes", "Offline Mode","Products SYNC", "Customer Management", "Payment Method", "Signature and Receipt", "PIN Login Every Transaction", "Device Name", "USB/Headphone Jack Card Reader", "Printers", "Cash Drawers", "Barcode Scanners", "Collect Tips", "Enable Auth","Coupons List", "Show Country", "Split Row", "Discount Options", "Line Item Tax Exempt","Edit Product","Swipe To Pay"] //"Prompt Add Customer"
        //}
        
        
        // MARK Hide for V5
        // array_SignatureAndReceipt = ["Signature on Receipt","Signature on Screen", "Receipt"
        
        //array_SignatureAndReceipt = ["Signature on Screen", "Receipt"]
        
        array_SignatureAndReceipt = ["Signature on Screen", "Signature on EMV Reader", "Receipt"]
        
        arraySelectedPaymet = ["CREDIT"]
        array_Printer = ["Google printer", "Bluetooth Printer"]
        
        for i in 0..<sectionArray.count
        {
            if i == 7
            {
                if DataManager.deviceName {
                    selectedIndex.append(i)
                    selectedRowIndex.append(i + 1)
                }
            }
            else if i == 9
            {
                if DataManager.isBluetoothPrinter
                {
                    selectedIndex.append(i)
                    selectedRowIndex.append(i + 1)
                    //Enable CBCentralManager
                    if SettingsViewController.centeralManager == nil {
                        SettingsViewController.centeralManager = CBCentralManager()
                        SettingsViewController.centeralManager!.delegate = self
                    }
                }
            }
            else if i == 17
            {
                if DataManager.isDiscountOptions
                {
                    selectedIndex.append(i)
                    selectedRowIndex.append(i + 1)
                }
            }
            
        }
        
        if DataManager.selectedPayment != nil
        {
            arraySelectedPaymet = DataManager.selectedPayment!
        }
        
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        
        self.updatePaymentArray()
        self.automaticallyAdjustsScrollViewInsets = false
        tbl_Settings.contentInset = UIEdgeInsets.zero
        tbl_Settings.tableFooterView = UIView()
        tbl_Settings.reloadData()
    }
    
    private func updatePaymentArray() {
        self.isPaxSelected = arraySelectedPaymet.contains("PAX PAY")
        
        if isPaxSelected {
            //array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY", "     CREDIT", "     DEBIT", "     GIFT" ,"INTERNAL GIFT CARD"]
            if versionOb < 4 {
                array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "CHECK", "EXTERNAL", "PAX PAY", "     CREDIT", "     DEBIT", "     GIFT"]
            }else{
                if DataManager.allowIngenicoPaymentMethod == "true" {
                    if DataManager.isCardReader {
                        array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY", "     CREDIT", "     DEBIT", "     GIFT" ,"INTERNAL GIFT CARD", "CARD READER", "RP45BT"]
                    }else{
                        array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY", "     CREDIT", "     DEBIT", "     GIFT" ,"INTERNAL GIFT CARD", "CARD READER"]
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
                        array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY","INTERNAL GIFT CARD", "CARD READER", "RP45BT"]
                    } else {
                        array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY","INTERNAL GIFT CARD", "CARD READER"]
                    }
                } else {
                    array_PaymentMethods = ["CREDIT", "CASH", "INVOICE", "ACH CHECK", "GIFT CARD", "EXTERNAL GIFT CARD", "MULTI CARD", "CHECK", "EXTERNAL", "PAX PAY","INTERNAL GIFT CARD"]
                }
            }
        }
        DataManager.selectedPayment = arraySelectedPaymet
        tbl_Settings.reloadData()
    }
    
    private func moveToSyncScreen() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SyncVC") as! SyncVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Get Star print
    func loadStarPrint() {
        
        self.startPrntArray?.removeAllObjects()
                
               // self.selectedIndexPath = nil
        
                
                var searchPrinterResult: [PortInfo]? = nil

                do {
                        // Bluetooth
                        searchPrinterResult = try SMPort.searchPrinter(target: "BT:")  as? [PortInfo]
                    DataManager.isStarPrinterConnected = true

                }
                catch {
                    // do nothing
                    DataManager.isStarPrinterConnected = false
                }

                guard let portInfoArray: [PortInfo] = searchPrinterResult else {
                  //  self.tableView.reloadData()
                    return
                }

        print("Star portInfoArray \(portInfoArray)")
                let portName:   String = currentSetting?.portName ?? ""
                let modelName:  String = currentSetting?.portSettings ?? ""
                let macAddress: String = currentSetting?.macAddress ?? ""

                var row: Int = 0

                for portInfo: PortInfo in portInfoArray {
                    print(portInfo)
                    startArr.append(portInfo)
                    self.startPrntArray.add([portInfo.portName, portInfo.modelName, portInfo.macAddress])

                    if portInfo.portName   == portName  &&
                        portInfo.modelName  == modelName &&
                        portInfo.macAddress == macAddress {
                       // self.selectedIndexPath = IndexPath(row: row, section: 0)
                    }

                    row += 1
                    if startArr.count > 0 {
                         modelSelect1AlertClickedButtonAt(buttonIndex: 5)
                    }
                }
        
       
        
    }
    
    func modelSelect1AlertClickedButtonAt(buttonIndex: Int?) {
           if buttonIndex != 0 {   // Not cancel
            let cellParam: [String] = self.startPrntArray[0] as! [String]
                      
                      self.portName   = cellParam[CellParamIndex.portName  .rawValue]
                      self.modelName  = cellParam[CellParamIndex.modelName .rawValue]
                      self.macAddress = cellParam[CellParamIndex.macAddress.rawValue]
                      
            let modelIndex: ModelIndex = ModelCapability.modelIndex(at: 0)
                      
                      self.portSettings = ModelCapability.portSettings(at: modelIndex)
                      self.emulation = ModelCapability.emulation(at: modelIndex)
                      self.selectedModelIndex = modelIndex
                      
                      let supportedExternalCashDrawer = ModelCapability.supportedExternalCashDrawer(at: modelIndex)!
                      switch self.emulation {
                      case .escPos?:
                          self.paperSizeIndex = .escPosThreeInch
                      case .starDotImpact?:
                          self.paperSizeIndex = .dotImpactThreeInch
                      default:
                          self.paperSizeIndex = nil
                      }
                      
                      if (selectedPrinterIndex != 0) {
                          self.paperSizeIndex = LoadStarPrinter.settingManager.settings[0]?.selectedPaperSize
                      }
               
                       self.saveParams(portName: self.portName,
                                       portSettings: self.portSettings,
                                       modelName: self.modelName,
                                       macAddress: self.macAddress,
                                       emulation: self.emulation,
                                       isCashDrawerOpenActiveHigh: true,
                                       modelIndex:  ModelIndex.tsp650II,
                                       paperSizeIndex: .threeInch)

           }
       }
       
       fileprivate func saveParams(portName: String,
                                   portSettings: String,
                                   modelName: String,
                                   macAddress: String,
                                   emulation: StarIoExtEmulation,
                                   isCashDrawerOpenActiveHigh: Bool,
                                   modelIndex: ModelIndex?,
                                   paperSizeIndex: PaperSizeIndex?) {
           if let modelIndex = modelIndex,
               let paperSizeIndex = paperSizeIndex {
               let allReceiptsSetting = LoadStarPrinter.settingManager.settings[selectedPrinterIndex]?.allReceiptsSettings ?? 0x07
               
               LoadStarPrinter.settingManager.settings[selectedPrinterIndex] = PrinterSetting(portName: portName,
                                                                                          portSettings: portSettings,
                                                                                          macAddress: macAddress,
                                                                                          modelName: modelName,
                                                                                          emulation: emulation,
                                                                                          cashDrawerOpenActiveHigh: isCashDrawerOpenActiveHigh,
                                                                                          allReceiptsSettings: allReceiptsSetting,
                                                                                          selectedPaperSize: paperSizeIndex,
                                                                                          selectedModelIndex: modelIndex)
               
               LoadStarPrinter.settingManager.save()
           } else {
               fatalError()
           }
       }
    
    //MARK: IBAction
    @IBAction func btn_HomeAction(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController")
                appDelegate.window?.rootViewController = vc
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func btn_LockAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "iPad", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "iPad_AccessPINViewController") as! iPad_AccessPINViewController
        if #available(iOS 13.0, *) {
            controller.modalPresentationStyle = .fullScreen
        }
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btn_LogOutAction(_ sender: Any) {
        alertForLogOut()
    }
    @IBAction func btn_cardReaderCancelBtnAction(_ sender: Any) {
        cardReaderMainView.isHidden = true
    }
    
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == tbl_Settings {
            return sectionArray.count
        }else{
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tbl_CardReaderDevice {
            return deviceList.count
        }
        if selectedIndex.count == 0 {
            return 0
        }
        
        switch section {
        case 4:
            return array_PaymentMethods.count
        case 5:
            return array_SignatureAndReceipt.count
        case 7:
            return 1
        case 9:
            var row = array_Printer.count
            if DataManager.isBluetoothPrinter {
                if SettingsViewController.printerArray.count>0 {
                    row = SettingsViewController.printerArray.count + array_Printer.count + 1 + startArr.count
                }else {
                    row = array_Printer.count + 1
                }
            }else{
                
                row = array_Printer.count
            }
            
            
            return row //(DataManager.printers) ? (SettingsViewController.printerArray.count>0 ? SettingsViewController.printerArray.count + 1 : 1) : 0
        case 17:
            return DataManager.isDiscountOptions ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let cell = tbl_Settings.dequeueReusableCell(withIdentifier: "cell")
        cell?.contentView.viewWithTag(1001)?.isHidden = !selectedRowIndex.contains(section == 11 ? 10 : section)
        
        let lbl_Title = cell?.contentView.viewWithTag(1) as? UILabel
        lbl_Title?.text = sectionArray[section]
        
        let lbl_ = cell?.contentView.viewWithTag(2) as? UILabel
        taxes_Switch = cell?.contentView.viewWithTag(3) as? UISwitch
        taxes_Switch?.isUserInteractionEnabled = true
        
        let img_Dropdown = cell?.contentView.viewWithTag(4) as? UIImageView
        let btn_SYNC = cell?.contentView.viewWithTag(5) as? UIButton
        
        let newTextField = cell?.contentView.viewWithTag(100) as? UITextField
        
        if section < 10 {
            cell?.contentView.viewWithTag(50)?.backgroundColor = section % 2 != 0 ? #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1) : UIColor.white
        }else {
            cell?.contentView.viewWithTag(50)?.backgroundColor = section % 2 == 0 ? #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1) : UIColor.white
        }
        
        cell?.contentView.viewWithTag(51)?.backgroundColor = #colorLiteral(red: 0.9489292502, green: 0.9765258431, blue: 0.9998806119, alpha: 1)
        cell?.contentView.viewWithTag(51)?.isHidden = true
        let bottomView = cell?.contentView.viewWithTag(10)
        bottomView?.isHidden = false
        newTextField?.isHidden = true
        
        if section == 2 || section == 4 || section == 5 || section == 10 || section == 9
        {
            btn_SYNC?.isHidden = section != 2
            img_Dropdown?.isHidden = section == 2
            taxes_Switch?.isHidden = true
            //Add gesture
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom))
            cell?.contentView.tag = section
            cell?.contentView.addGestureRecognizer(tapGestureRecognizer)
        }
        else
        {
            btn_SYNC?.isHidden = section != 2
            img_Dropdown?.isHidden = true
            taxes_Switch?.isHidden = false
        }
        
        if section == 0
        {
            lbl_?.text = "Checkout Options"
            lbl_?.isHidden = false
            cell?.contentView.viewWithTag(51)?.isHidden = false
            taxes_Switch?.setOn(DataManager.isTaxOn, animated: false)
        }else if(section == 1)
        {
            lbl_?.isHidden = true
            taxes_Switch?.setOn(DataManager.isOffline, animated: false)
        }
        else if(section == 2)
        {
            lbl_?.isHidden = true
            taxes_Switch?.isHidden = true
            taxes_Switch?.setOn(DataManager.isProductsSYNC, animated: false)
        }
        else if (section == 3)
        {
            lbl_?.isHidden = true
            taxes_Switch?.setOn(DataManager.isCustomerManagementOn, animated: false)
        }
        else if (section == 6)
        {
            lbl_?.text = "Device Config"
            lbl_?.isHidden = false
            cell?.contentView.viewWithTag(51)?.isHidden = false
            taxes_Switch?.setOn(DataManager.pinloginEveryTransaction, animated: false)
        }
            //        else if (section == 9)
            //        {
            //            lbl_?.isHidden = true
            //            taxes_Switch?.setOn(DataManager.printers, animated: false)
            //        }
        else if(section == 7)
        {
                lbl_?.text = "Hardware"
                lbl_?.isHidden = false
                cell?.contentView.viewWithTag(51)?.isHidden = false
                taxes_Switch?.setOn(DataManager.deviceName, animated: false)
            
        }
        else
        {
            lbl_?.isHidden = true
        }
        
        if section == 8 {
            taxes_Switch?.setOn(DataManager.cardReaders, animated: false)
        }
        
        if section == 11 {
            taxes_Switch?.setOn(DataManager.isBarCodeReaderOn, animated: false)
        }
        
        if section == 12 {
            taxes_Switch?.setOn(DataManager.collectTips, animated: false)
        }
        
        if section == 13 {
            taxes_Switch?.setOn(DataManager.isAuthentication, animated: false)
        }
        
        //        if section == 14 {
        //            newTextField?.isHidden = false
        //            newTextField?.placeholder = "Select Category"
        //            newTextField?.setDropDown()
        //            newTextField?.addLeftSidePadding()
        //            newTextField?.delegate = self
        //            newTextField?.superview?.tag = 1002
        //            newTextField?.isUserInteractionEnabled = DataManager.isDefaultCategory
        //            newTextField?.alpha = DataManager.isDefaultCategory ? 1.0 : 0.5
        //            taxes_Switch?.setOn(DataManager.isDefaultCategory, animated: false)
        //        }
        
        if section == 14 {
            taxes_Switch?.setOn(DataManager.isCouponList, animated: false)
        }
        
        if section == 15 {
            newTextField?.isHidden = false
            newTextField?.placeholder = "Select Country"
            newTextField?.addLeftSidePadding()
            newTextField?.setDropDown()
            newTextField?.delegate = self
            newTextField?.superview?.tag = 1003
            
            newTextField?.isUserInteractionEnabled = DataManager.isShowCountry && NetworkConnectivity.isConnectedToInternet()
            taxes_Switch?.isUserInteractionEnabled = DataManager.isShowCountry || NetworkConnectivity.isConnectedToInternet()
            newTextField?.alpha = DataManager.isShowCountry ? 1.0 : 0.5
            newTextField?.text = DataManager.selectedCountry
            taxes_Switch?.setOn(DataManager.isShowCountry, animated: false)
        }
        
        if section == 16 {
            taxes_Switch?.setOn(DataManager.isSplitRow, animated: false)
        }
        
        if section == 17 {
            bottomView?.isHidden = DataManager.isDiscountOptions
            taxes_Switch?.setOn(DataManager.isDiscountOptions, animated: false)
            
            
            
        }
        
        if section == 18 {
            taxes_Switch?.setOn(DataManager.isLineItemTaxExempt, animated: false)
        }
        
        if section == 19 {
            taxes_Switch?.setOn(DataManager.isProductEdit, animated: false)
        }
        
        if section == 20 {
            taxes_Switch?.setOn(DataManager.isSwipeToPay, animated: false)
        }
         // for Prompt Add Customer
        if (section == 21)
        {
            lbl_?.isHidden = true
            taxes_Switch?.setOn(DataManager.isPromptAddCustomer, animated: false)
        }
        
        //Add Target
        btn_SYNC?.addTarget(self, action:#selector(btn_SYNCAction(sender:)), for: .touchUpInside)
        btn_SYNC?.tag = section
        taxes_Switch?.addTarget(self, action:#selector(btn_switchAction(sender:)), for: .touchUpInside)
        taxes_Switch?.tag = section
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tbl_CardReaderDevice {
            let cell = tbl_CardReaderDevice.dequeueReusableCell(withIdentifier: "CardReaderDeviceCell", for: indexPath) as! CardReaderDeviceCell
            //cell.deviceNameLbl.text = "device name\([indexPath.row])"
            
            if DataManager.cardReaders {
                 let device:RUADevice = deviceList[(indexPath as NSIndexPath).row]
                           if device.name != nil{
                               cell.deviceNameLbl.text =  String.init(format: "Name: %@", device.name)
                           }
            }
            
           
            //cell.identifierLabel.text = String.init(format: "ID: %@", device.identifier)
           // cell.communicationLabel.text = self.getStringFromCommunication(device.communicationInterface)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        }
        let cell = tbl_Settings.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! SettingsTableCell
        
        let lbl_Title = cell.label
        
        cell.textfield.delegate = self
        cell.redTextfield.delegate = self
        cell.blueTextfield.delegate = self
        cell.greenTextfield.delegate = self
        cell.button.isHidden = true
        cell.textfield.isHidden = true
        cell.discountView.isHidden = true
        cell.switchButton.isHidden = true
        cell.redTextfield.tag = 1004
        cell.blueTextfield.tag = 1005
        cell.greenTextfield.tag = 1006
        cell.redTextfield.text = ""
        cell.blueTextfield.text = ""
        cell.greenTextfield.text = ""
        cell.switchButton.removeTarget(self, action: #selector(btn_PaymentAction(sender:)), for: .allEvents)
        cell.switchButton.removeTarget(self, action: #selector(btn_ReceiptAction(sender:)), for: .allEvents)
        cell.contentView.backgroundColor = UIColor.white
        cell.accessoryType = .none
        cell.accessoryView = nil
        cell.paperSizeTextfield.isHidden = true
        cell.paperSizeTextfield.hideAssistantBar()
        cell.lblLeadingConstant.constant = 31
        switch indexPath.section {
        case 4:
            var isSetUp = false
            lbl_Title?.isHidden = false

            lbl_Title?.text = array_PaymentMethods[indexPath.row] as? String
            
            if array_PaymentMethods[indexPath.row] as? String == "MULTI CARD" {
                lbl_Title?.text = "SPLIT PAYMENT"
            }
            
            if array_PaymentMethods[indexPath.row] as? String == "GIFT CARD" {
                lbl_Title?.text = "HEARTLAND GIFT CARD"
            }
            
            cell.accessoryType = .none
            cell.accessoryView = nil
            cell.switchButton.tag = indexPath.row
            cell.switchButton.isHidden = false
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1) : UIColor.white
            cell.switchButton.setOn(arraySelectedPaymet.contains(array_PaymentMethods[indexPath.row] as? String ?? ""), animated: false)
            //            if isPaxSelected && (indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12) {
            //                let selectedPaymentName = (array_PaymentMethods[indexPath.row] as! String).replacingOccurrences(of: " ", with: "")
            //                cell.switchButton.setOn(DataManager.selectedPAX.contains(selectedPaymentName), animated: false)
            //            }
            if isPaxSelected && (indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12) {
                if indexPath.row == 12 {
                    cell.switchButton.setOn(DataManager.isPaxPayGiftCard, animated: false)
                }
                let selectedPaymentName = (array_PaymentMethods[indexPath.row] as! String).replacingOccurrences(of: " ", with: "")
                cell.switchButton.setOn(DataManager.selectedPAX.contains(selectedPaymentName), animated: false)
            }
            
            if indexPath.row == 4 {
                cell.switchButton.setOn(DataManager.isGiftCard, animated: false)
            }
            
            if isPaxSelected && indexPath.row == 9 {
                cell.switchButton.setOn(true, animated: false)
            }
            
            if !isPaxSelected && indexPath.row == 10 {
                cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
            }
            
            if isPaxSelected && indexPath.row == 13 {
                cell.switchButton.setOn(DataManager.isInternalGift, animated: false)
            }
            if isPaxSelected && indexPath.row == 14 {
                cell.switchButton.setOn(DataManager.isCardReader, animated: false)
            }
            if !isPaxSelected && indexPath.row == 11 {
                cell.switchButton.setOn(DataManager.isCardReader, animated: false)
            }
            
            if array_PaymentMethods[indexPath.row] as? String == "RP45BT" {
                 cell.switchButton.isHidden = true
                var isSetUp = false
                  cell.switchButton.setOn(DataManager.isCardReader, animated: false)
                  if self.getIsDeviceConnected() {
                      cell.accessoryType =  .checkmark
                  } else {
                      cell.accessoryType =  .none
                  }
                  cell.setEditing(false, animated: false)
            } else {
                cell.accessoryType =  .none
                cell.accessoryView = nil
                
            }
            
            cell.switchButton.addTarget(self, action:#selector(btn_PaymentAction(sender:)), for: .touchUpInside)
            break
            
        case 5:
            lbl_Title?.isHidden = false
            lbl_Title?.text = array_SignatureAndReceipt[indexPath.row] as? String
            cell.switchButton.isHidden = false
            cell.button.isHidden = true
            cell.accessoryType = .none
            cell.accessoryView = nil
            // MARK Hide for V5
//            if indexPath.row == 0{
//                cell.switchButton.setOn(DataManager.signatureOnReceipt, animated: false)
//                cell.switchButton.addTarget(self, action:#selector(btn_SignatureOnReceiptAction(sender:)), for: .touchUpInside)
//            } else
            if indexPath.row == 0 {
                cell.switchButton.setOn(DataManager.signature, animated: false)
                cell.switchButton.addTarget(self, action:#selector(btn_SignatureAction(sender:)), for: .touchUpInside)
            } else if indexPath.row == 1 {
                cell.switchButton.setOn(DataManager.isSingatureOnEMV, animated: false)
                cell.switchButton.addTarget(self, action:#selector(btn_SignatureOnEMVReader(sender:)), for: .touchUpInside)
            } else {
                cell.switchButton.setOn(DataManager.receipt, animated: false)
                cell.switchButton.addTarget(self, action:#selector(btn_ReceiptAction(sender:)), for: .touchUpInside)
            }
            
            
            /*if indexPath.row == 0{
             cell.switchButton.setOn(DataManager.signature, animated: false)
             cell.switchButton.addTarget(self, action:#selector(btn_SignatureAction(sender:)), for: .touchUpInside)
             }else {
             cell.switchButton.setOn(DataManager.receipt, animated: false)
             cell.switchButton.addTarget(self, action:#selector(btn_ReceiptAction(sender:)), for: .touchUpInside)
             }*/
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1) : UIColor.white
            break
            
        case 7:
            
            cell.textfield.tag = 1000
            cell.textfield.placeholder = "Enter Device Name"
            cell.textfield.isHidden = false
            cell.textfield.keyboardType = .asciiCapable
            cell.textfield.delegate = self
            cell.textfield.text = DataManager.deviceNameText
            cell.switchButton.isHidden = true
            cell.accessoryType = .none
            lbl_Title?.isHidden = true
            
            if DataManager.isDrawerOpen{
                cell.textfield.isUserInteractionEnabled = false
                cell.switchButton.isUserInteractionEnabled = false
            }else{
                cell.textfield.isUserInteractionEnabled = true
                cell.switchButton.isUserInteractionEnabled = true
            }
          
            break
            
        case 9:
            lbl_Title?.isHidden = false
            cell.switchButton.isHidden = false
            cell.button.isHidden = true
            cell.accessoryType = .none
            cell.accessoryView = nil
            // MARK Hide for V5
            if indexPath.row == 0{
                lbl_Title?.text = array_Printer[indexPath.row] as? String
                cell.switchButton.setOn(DataManager.isGooglePrinter, animated: false)
                cell.switchButton.addTarget(self, action:#selector(btn_GooglePrinter(sender:)), for: .touchUpInside)
            } else if indexPath.row == 1 {
                lbl_Title?.text = array_Printer[indexPath.row] as? String
                cell.switchButton.setOn(DataManager.isBluetoothPrinter, animated: false)
                cell.switchButton.addTarget(self, action:#selector(btn_BluetoothPrinter(sender:)), for: .touchUpInside)
            }else{
                
                cell.button.isHidden = true
                cell.switchButton.isHidden = true
                cell.accessoryType = .none
                cell.accessoryView = nil
                lbl_Title?.isHidden = false
                cell.button.addTarget(self, action: #selector(btn_SearchBleAction(sender:)), for: .touchUpInside)
                if isSearch {
                    cell.activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    cell.activity.startAnimating()
                    cell.accessoryView = cell.activity
                    cell.button.setTitle("Stop", for: .normal)
                } else {
                    cell.activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    cell.activity.stopAnimating()
                    cell.accessoryView = .none
                    cell.button.setTitle("Search for printer", for: .normal)
                }
                cell.lblLeadingConstant.constant = 41
                if SettingsViewController.printerArray.count == 0
                {
                    //                    lbl_Title?.text = "No printer found."
                    //                    let v = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                    //                    v.startAnimating()
                    //                    cell.accessoryView = v
                    cell.paperSizeTextfield.tag = 104
                    cell.accessoryType = .none
                    lbl_Title?.isHidden = false
                    lbl_Title?.text = "Printer paper width:"
                    // cell.textfield.isHidden = false
                    cell.paperSizeTextfield.isHidden = false
                    cell.paperSizeTextfield?.placeholder = "Paper width"
                    cell.paperSizeTextfield.addLeftSidePadding()
                    cell.paperSizeTextfield.setDropDown()
                    cell.paperSizeTextfield.delegate = self
                    
                    cell.paperSizeTextfield.keyboardType = .decimalPad
                    cell.button.isHidden = false
                    //  cell.button.setTitle("Search for printer", for: .normal)
                    cell.lblLeadingConstant.constant = 41
                    cell.paperSizeTextfield.text = String(describing: DataManager.paperSize)
                }else {
                    //                    lbl_Title?.text = "No printer found."
                    
                    if indexPath.row == 2 {
                        cell.paperSizeTextfield.tag = 104
                        cell.accessoryType = .none
                        lbl_Title?.isHidden = false
                        lbl_Title?.text = "Printer paper width:"
                        // cell.textfield.isHidden = false
                        cell.paperSizeTextfield.isHidden = false
                        cell.paperSizeTextfield?.placeholder = "Paper width"
                        cell.paperSizeTextfield.addLeftSidePadding()
                        cell.paperSizeTextfield.setDropDown()
                        cell.paperSizeTextfield.delegate = self
                        
                        cell.paperSizeTextfield.keyboardType = .decimalPad
                        cell.button.isHidden = false
                        //  cell.button.setTitle("Search for printer", for: .normal)
                        cell.lblLeadingConstant.constant = 41
                        cell.paperSizeTextfield.text = String(describing: DataManager.paperSize)
                    }else {
                        guard (indexPath.row - 3) < SettingsViewController.printerArray.count else {
                            if startArr.count > 0 {
                                lbl_Title?.text = startArr[0].portName
                            }
                            if startArr[0].portName == LoadStarPrinter.settingManager.settings[self.selectedPrinterIndex]?.portName {
                                cell.accessoryType = .checkmark
                            }
                            return cell
                        }
                        //
                        let printer = SettingsViewController.printerArray[indexPath.row - 3]
                        
                        lbl_Title?.text = printer.name ?? printer.identifier.description
                        cell.accessoryType = printer.state == .connected ? .checkmark : .none
                        cell.contentView.isUserInteractionEnabled = printer.state == .connecting ? false : true
                        if printer.isConnecting {
                            let v = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                            v.startAnimating()
                            cell.accessoryView = v
                        } else {
                            cell.accessoryView = nil
                            cell.setEditing(false, animated: false)
                        }
                    }
                }
            }
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1) : UIColor.white
            
            break
            
        case 17:
            cell.accessoryType = .none
            cell.accessoryView = nil
            cell.discountView.backgroundColor = UIColor.white
            cell.discountView.isHidden = !DataManager.isDiscountOptions
            cell.redTextfield.tag = 101
            cell.blueTextfield.tag = 102
            cell.greenTextfield.tag = 103
            cell.redTextfield.setPadding()
            cell.blueTextfield.setPadding()
            cell.greenTextfield.setPadding()
            cell.redTextfield.setRightPadding()
            cell.blueTextfield.setRightPadding()
            cell.greenTextfield.setRightPadding()
            cell.redTextfield.keyboardType = .decimalPad
            cell.blueTextfield.keyboardType = .decimalPad
            cell.greenTextfield.keyboardType = .decimalPad
            cell.redTextfield.text = "\(DataManager.seventyDiscountValue.newValue)%"
            cell.blueTextfield.text = "\(DataManager.twentyDiscountValue.newValue)%"
            cell.greenTextfield.text = "\(DataManager.tenDiscountValue.newValue)%"
            break
            
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView == tbl_CardReaderDevice {
            return 0
        }
        if versionOb < 4 {
            return (section == 1 || section == 2 || section == 8 || section == 10 || section == 21 || section == 19) ? 0 : ((section == 0 || section == 6 || section == 7) ? 85 : 55)

        } else {
            return (section == 1 || section == 2 || section == 10 || section == 19) ? 0 : ((section == 0 || section == 6 || section == 7) ? 85 : 55)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tbl_CardReaderDevice {
            return 50
        }
        return selectedIndex.contains(indexPath.section) ? (indexPath.section == 17 && DataManager.isDiscountOptions) ? 75 : 50 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if tableView == tbl_CardReaderDevice {
            if  deviceList.count > 0 {
                Indicator.sharedInstance.showIndicator()
                connectingDevice = deviceList[(indexPath as NSIndexPath).row]
                ingenico.paymentDevice.select(connectingDevice!)
                ingenico.paymentDevice.initialize(self)
                //ingenico.paymentDevice.stopSearch()
//                if (baseURLTextField.text != nil) {
//                    UserDefaults.standard.setValue(baseURLTextField.text, forKey: "DefaultURL")
//                    UserDefaults.standard.synchronize()
//                }
                ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                    apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                    clientVersion: ClientVersion)
                ingenico.setLogging(false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password)
                }
                
            }
        } else{
            if indexPath.section == 9 {
                tableView.deselectRow(at: indexPath, animated: true)
                
                if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2{
                    return
                }
                
                guard indexPath.row - 3 < SettingsViewController.printerArray.count else {
                    return
                }
                
                let p = SettingsViewController.printerArray[indexPath.row - 3]
                
                
                if p.state == .connected {
                    UserDefaults.standard.set("", forKey: "auto.connect.uuid")
                    SettingsViewController.printerManager?.disconnect(p)
                    SettingsViewController.printerUUID = nil
                } else {
                    let show = SettingsViewController.printerArray.filter({$0.state == .connecting})
                    if show.count > 0 {
                        return
                    } else {
                        if let uuid = UserDefaults.standard.object(forKey:"auto.connect.uuid") as? String {
                            if SettingsViewController.printerArray.contains(where: {$0.identifier.uuidString == uuid.description}) {
                                if let index = SettingsViewController.printerArray.firstIndex(where: {$0.identifier.uuidString == uuid.description}) {
                                    let indexValue =   SettingsViewController.printerArray[index]
                                    print(indexValue)
                                    SettingsViewController.printerManager?.disconnect(indexValue)
                                    SettingsViewController.printerUUID = nil
                                }
                                
                            }
                            
                        }
                        
                        UserDefaults.standard.set("", forKey: "auto.connect.uuid")
                        SettingsViewController.printerManager?.connect(p)
                        if p.name == nil {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                if SettingsViewController.printerArray.contains(where: {$0.identifier.uuidString == p.identifier.description}) {
                                    if let index = SettingsViewController.printerArray.firstIndex(where: {$0.identifier.uuidString == p.identifier.description}) {
                                        //                                             let indexValue =   SettingsViewController.printerArray[index]
                                        //                                                print(indexValue)
                                        //                                                SettingsViewController.printerManager?.disconnect(indexValue)
                                        SettingsViewController.printerArray[index].state = .disconnected
                                        self.tbl_Settings.reloadData()
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
                    if indexPath.section == 4 {
                        if isPaxSelected && indexPath.row == 15 {
                            
                            if DataManager.isIngenicoConnected {
                                if getIsDeviceConnected() {
                                    //appDelegate.showToast(message: "Device Setup Inside")
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
                                        appDelegate.showToast(message: "Device Setup required")
                                        Indicator.sharedInstance.hideIndicator()
                                            self.checkDeviceSetup()
                                    } else {
                                        print("setup Done")
                                        
                                        appDelegate.showToast(message: "Device Setup Already Completed")
                                        Indicator.sharedInstance.hideIndicator()
                                        }
                                    })
                                    return
                                }
                            }
                           // let IngenicoModelObj = IngenicoModel()
                            ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                                apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                                clientVersion: ClientVersion)
                            
                            //if communicationSegment.selectedSegmentIndex == 1 {
                               // doSearching()
                                
                            self.ingenico.paymentDevice.setDeviceType(RUADeviceType(rawValue: DataManager.RUADeviceTypeValueDataSet))

                            self.ingenico.paymentDevice.search(self)
            //                }else{
            //                    let devicesList: [NSNumber] = [ NSNumber.init(value: RUADeviceTypeRP450c.rawValue as UInt32),
            //                                                    NSNumber.init(value: RUADeviceTypeRP350x.rawValue as UInt32),
            //                                                    NSNumber.init(value: RUADeviceTypeG4x.rawValue as UInt32),
            //                                                    NSNumber.init(value: RUADeviceTypeRP750x.rawValue as UInt32)];
            //                    ingenico.paymentDevice.setDeviceTypes(devicesList)
            //                    let loginVC:LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            //                    self.navigationController?.pushViewController(loginVC, animated: false)
            //                    ingenico.paymentDevice.initialize(self)
            //                }
                             cardReaderMainView.isHidden = false
                         // moveToSyncScreen()
                        }
                        if !isPaxSelected && indexPath.row == 12 {
                            if DataManager.isIngenicoConnected {
                                //appDelegate.showToast(message: "Device Setup Inside")
                                 if getIsDeviceConnected() {
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
                                         }
                                     })
                                     return
                                 }
                             }
                            // let IngenicoModelObj = IngenicoModel()
                             ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                                 apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                                 clientVersion: ClientVersion)
                             
                             //if communicationSegment.selectedSegmentIndex == 1 {
                                // doSearching()
                                 
                             self.ingenico.paymentDevice.setDeviceType(RUADeviceType(rawValue: DataManager.RUADeviceTypeValueDataSet))

                             self.ingenico.paymentDevice.search(self)
                             cardReaderMainView.isHidden = false
                         //  moveToSyncScreen()
                        }
                    }
                    
                    tbl_Settings.reloadData()
        }
    }
    
    @objc func btn_switchAction(sender: UISwitch)
    {
        if sender.tag == 1 {
            DataManager.isOffline = sender.isOn
        }
        if sender.tag == 2 {
            DataManager.isProductsSYNC = sender.isOn
        }
        if sender.tag == 0 {
            DataManager.isTaxOn = sender.isOn
        }
        if sender.tag == 3 {
            DataManager.isCustomerManagementOn = sender.isOn
             // for Prompt Add Customer
            if !DataManager.isCustomerManagementOn{
              DataManager.isPromptAddCustomer = false
            }
        }
        if sender.tag == 6 {
            DataManager.pinloginEveryTransaction = sender.isOn
        }
        if sender.tag == 9 {
            if let index = selectedRowIndex.index(where: {$0 == sender.tag + 1}) {
                selectedRowIndex.remove(at: index)
            }else {
                selectedRowIndex.append(sender.tag + 1)
            }
            //
            if let index = selectedIndex.index(where: {$0 == sender.tag}) {
                selectedIndex.remove(at: index)
            }else {
                selectedIndex.append(sender.tag)
            }
            
            DataManager.isBluetoothPrinter = sender.isOn
            if DataManager.isBluetoothPrinter
            {
                self.loadPrinter()
                return
            }else {
                SettingsViewController.printerManager?.disconnectAllPrinter()
                SettingsViewController.printerManager = nil
                SettingsViewController.printerUUID = nil
            }
            tbl_Settings.reloadData()
        }
        if sender.tag == 7
        {
            if DataManager.isDrawerOpen {
                DataManager.deviceName = !sender.isOn
                tbl_Settings.reloadData()
                return
            }
            
            if let index = selectedRowIndex.index(where: {$0 == sender.tag + 1}) {
                selectedRowIndex.remove(at: index)
            }else {
                selectedRowIndex.append(sender.tag + 1)
            }
            //
            if let index = selectedIndex.index(where: {$0 == sender.tag}) {
                selectedIndex.remove(at: index)
            }else {
                selectedIndex.append(sender.tag)
            }
            
            tbl_Settings.reloadData()
            
            DataManager.deviceName = sender.isOn
            if !DataManager.deviceName {
                DataManager.deviceNameText = nil
            }
            
            //Update Name
            if let name = DataManager.deviceNameText {
                posLabel.text = name
            }else {
                posLabel.text = "POS"
            }
//            if  DataManager.isDrawerOpen{
//                print("open drawer")
////                if let index = selectedRowIndex.index(where: {$0 == sender.tag + 1}) {
////                    selectedRowIndex.remove(at: index)
////                }
//                tbl_Settings.reloadData()
//            }else{
//
//
//            }
        }
        
        if sender.tag == 8 {
            DataManager.cardReaders = sender.isOn
        }
        
        if sender.tag == 11 {
            DataManager.isBarCodeReaderOn = sender.isOn
        }
        
        if sender.tag == 12 {
            DataManager.collectTips = sender.isOn
            DataManager.tempCollectTips = sender.isOn
        }
        
        if sender.tag == 13 {
            DataManager.isAuthentication = sender.isOn
        }
        
        if sender.tag == 14 {
            DataManager.isCouponList = sender.isOn
        }
        
        if sender.tag == 15 {
            DataManager.isShowCountry = sender.isOn
            if !DataManager.isShowCountry {
                DataManager.selectedCountry = "US"
            }
            tbl_Settings.reloadData()
        }
        
        if sender.tag == 16 {
            DataManager.isSplitRow = sender.isOn
        }
        
        if sender.tag == 17 {
            DataManager.isDiscountOptions = sender.isOn
            if let index = selectedIndex.index(where: {$0 == sender.tag}) {
                selectedIndex.remove(at: index)
            }else {
                selectedIndex.append(sender.tag)
            }
            
            if let index = selectedRowIndex.index(where: {$0 == sender.tag + 1}) {
                selectedRowIndex.remove(at: index)
            }else {
                selectedRowIndex.append(sender.tag + 1)
            }
            
            self.tbl_Settings.reloadData()
        }
        
        if sender.tag == 18 {
            DataManager.isLineItemTaxExempt = sender.isOn
        }
        if sender.tag == 19 {
            DataManager.isProductEdit = sender.isOn
        }
        
        if sender.tag == 20 {
            DataManager.isSwipeToPay = sender.isOn
        }
         // for Prompt Add Customer
        if sender.tag == 21 {
            DataManager.isPromptAddCustomer = sender.isOn
            if !DataManager.isCustomerManagementOn {
              DataManager.isCustomerManagementOn = sender.isOn
            }

        }
        
    }
    
    @objc func SearchAgainIngenicoData() {
        if DataManager.isIngenicoConnected {
            ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                clientVersion: ClientVersion)
            
            //if communicationSegment.selectedSegmentIndex == 1 {
               // doSearching()
                
            self.ingenico.paymentDevice.setDeviceType(RUADeviceType(rawValue: DataManager.RUADeviceTypeValueDataSet))

            self.ingenico.paymentDevice.search(self)
        }
    }
    
    @objc func handleTapFrom(sender: UITapGestureRecognizer)
    {
        if sender.view!.tag == 2 {
            moveToSyncScreen()
            return
        }
        
        if let index = selectedRowIndex.index(where: {$0 == sender.view!.tag + 1}) {
            selectedRowIndex.remove(at: index)
        }else {
            selectedRowIndex.append(sender.view!.tag + 1)
        }
        
        if let index = selectedIndex.index(where: {$0 == sender.view!.tag}) {
            selectedIndex.remove(at: index)
        }else {
            selectedIndex.append(sender.view!.tag)
        }
        tbl_Settings.reloadData()
    }
    
    @objc func btn_SignatureAction(sender: UISwitch)
    {
        DataManager.signature = sender.isOn
    }
    
    @objc func btn_SignatureOnReceiptAction(sender: UISwitch)
    {
        DataManager.signatureOnReceipt = sender.isOn
    }
    
    @objc func btn_SignatureOnEMVReader(sender: UISwitch)
    {
        DataManager.isSingatureOnEMV = sender.isOn
    }
    
    @objc func btn_GooglePrinter(sender: UISwitch)
    {
        DataManager.isGooglePrinter = sender.isOn
        DataManager.isBluetoothPrinter = false
        DataManager.isStarPrinterConnected = false
        tbl_Settings.reloadData()
    }
    @objc func btn_BluetoothPrinter(sender: UISwitch)
    {
        DataManager.isBluetoothPrinter = sender.isOn
        DataManager.isGooglePrinter = false
        tbl_Settings.reloadData()
    }
    
    
    @objc func btn_PaymentAction(sender: UISwitch)
    {
        if !sender.isOn {
            removePaymentData(method: array_PaymentMethods[sender.tag] as? String ?? "")
        }
        
        if sender.tag == 4 {
            DataManager.isGiftCard = sender.isOn
        }
        
        if !isPaxSelected && sender.tag == 10 {
            DataManager.isInternalGift = sender.isOn
        }
        
        if isPaxSelected && sender.tag == 13 {
            DataManager.isInternalGift = sender.isOn
        }
        if isPaxSelected && sender.tag == 14 {
            DataManager.isCardReader = sender.isOn
        }
        if !isPaxSelected && sender.tag == 11 {
            DataManager.isCardReader = sender.isOn
        }
        
        if isPaxSelected && (sender.tag == 10 || sender.tag == 11 || sender.tag == 12) {
            
            if sender.tag == 12 {
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
        
        self.updatePaymentArray()
        
    }
    
    @objc func btn_ReceiptAction(sender: UISwitch)
    {
        DataManager.receipt = sender.isOn
    }
    
    @objc func btn_SYNCAction(sender: UISwitch)
    {
        if sender.tag == 2 {
            moveToSyncScreen()
        }
    }
    
        @objc func btn_SearchBleAction(sender: UIButton)
        {
            if !isBluetoothOn {
                self.moveToSettings()
                return
            }
            if isSearch {
                sender.isUserInteractionEnabled = true
                self.isSearch.toggle()
                SettingsViewController.centeralManager?.stopScan()
                self.tbl_Settings.reloadData()
              //  SettingsViewController.printerManager?.stopScan()
                return
            }
            isSearch.toggle()
            sender.isUserInteractionEnabled = false
            self.tbl_Settings.reloadData()
            self.loadPrinter()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isSearch.toggle()
                self.tbl_Settings.reloadData()
                sender.isUserInteractionEnabled = true
            }
        }

    
}

//MARK: UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.superview?.tag == 1003 {
            isPaperWidth = false
            if HomeVM.shared.countryDetail.count == 0 {
                textField.resignFirstResponder()
                self.callAPItoGetCountryList(textField: textField)
            }else {
                let array = HomeVM.shared.countryDetail.compactMap({$0.name})
                self.pickerDelegate = self
                textField.text = HomeVM.shared.countryDetail.first?.abbreviation
                DataManager.selectedCountry = HomeVM.shared.countryDetail.first?.abbreviation ?? ""
                setPickerView(textField: textField, array: array)
            }
            return
        }
        if textField.tag == 104 {
            isPaperWidth = true
            self.pickerDelegate = self
            textField.text = "58"
            DataManager.paperSize = 58
            self.setPickerView(textField: textField, array: arrPaperWidthSize)
        }
        
        if textField.tag == 101 || textField.tag == 102 || textField.tag == 103 {
            textField.selectAll(nil)
        }
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneAction))
        doneButton.tintColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1001 {
            let paperSize = Int(textField.text ?? "0") ?? 0
            if paperSize < 58 || paperSize > 210 {
                textField.text = ""
                textField.resignFirstResponder()
//                self.showAlert(message: "Please enter paper size between 58mm to 210mm.")
                appDelegate.showToast(message: "Please enter paper size between 58mm to 210mm.")
                return
            }
            DataManager.paperSize = paperSize
            return
        }
        
        if textField.tag == 100 {
            self.tbl_Settings.reloadData()
            return
        }
        
        if textField.tag == 101 || textField.tag == 102 || textField.tag == 103 {
            let value = (Double(textField.text ?? "") ?? 0.0)
            if textField.tag == 101 {
                DataManager.seventyDiscountValue = value
            }
            
            if textField.tag == 102 {
                DataManager.twentyDiscountValue = value
            }
            
            if textField.tag == 103 {
                DataManager.tenDiscountValue = value
            }
            
            self.tbl_Settings.reloadData()
            return
        }
        
        if textField.tag == 1000 {
            //Update Name
            if var name = textField.text, name != "" {
                name = name.trimmingCharacters(in: .whitespaces)
                name = name == "" ? "POS" : name
                posLabel.text = name
                DataManager.deviceNameText = name
            }else {
                posLabel.text = "POS"
                DataManager.deviceNameText = nil
            }
            textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }
        
        if textField.tag == 1001 {
            let cs = CharacterSet.decimalDigits.inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            if string == filtered {
                return charactersCount < 4
            }
            return false
        }
        
        if textField.tag == 1000 {
            
            if textField.isEmpty && string == " " {
                return false
            }
            
            return charactersCount < 51
        }
        
        if textField.tag == 101 || textField.tag == 102 || textField.tag == 103 {
            let replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            let amount = Double(replacementText) ?? 0.0
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
        }
        
        return charactersCount < 21
    }
    
    @objc func doneAction() {
        self.view.endEditing(true)
    }
}

//MARK: SWRevealViewControllerDelegate
extension SettingsViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionRight {
            self.view.alpha = 0.5
            self.view.endEditing(true)
            
        }
        else if position == FrontViewPositionLeft {
            self.view.alpha = 1.0
        }
        //Hide Keyboard
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
}

//MARK: PrinterManagerDelegate
extension SettingsViewController: PrinterManagerDelegate {
    
    func loadPrinter() {
        SettingsViewController.printerManager = PrinterManager()
        SettingsViewController.printerManager?.delegate = self
        SettingsViewController.printerArray = SettingsViewController.printerManager!.nearbyPrinters
        SettingsViewController.printerUUID = nil
        self.tbl_Settings.reloadData()
    }
    
    public func nearbyPrinterDidChange(_ change: NearbyPrinterChange) {
        switch change {
        case let .add(p):
            if SettingsViewController.printerArray.contains(where: {$0.identifier == p.identifier}) == false {
                          SettingsViewController.printerArray.append(p)
                      }
           // SettingsViewController.printerArray.append(p)
        case let .update(p):
            guard let row = (SettingsViewController.printerArray.index() { $0.identifier == p.identifier } ) else {
                return
            }
            if p.state == .connected {
                DataManager.receipt = true
                SettingsViewController.printerUUID = p.identifier
            }
            else if p.state == .disconnected {
                SettingsViewController.printerUUID = nil
            }
            SettingsViewController.printerArray[row] = p
            print(p.state)
        case let .remove(identifier):
            guard let row = (SettingsViewController.printerArray.index() { $0.identifier == identifier } ) else {
                return
            }
            
            if SettingsViewController.printerUUID == SettingsViewController.printerArray[row].identifier {
                SettingsViewController.printerUUID = nil
            }
            SettingsViewController.printerArray.remove(at: row)
        }
        
        self.tbl_Settings.reloadData()
    }
    
    func moveToSettings() {
        if !isShowAlert {
            
            return
        }
//        self.showAlert(title: "Alert", message: "Please enable the bluetooth from Settings.", otherButtons: nil, cancelTitle: kOkay) { (action) in
////            guard let url = URL(string: "App-Prefs:root=Bluetooth") else {return}
////            if #available(iOS 10.0, *) {
////                UIApplication.shared.open(url, options: [:], completionHandler: nil)
////            } else {
////                UIApplication.shared.openURL(url)
////            }
//        }
        self.showAlert(title:"Alert", message: "Please enable the bluetooth from Settings.", otherButtons: ["Settings":{ (_) in
              //...
        guard let url = URL(string: "App-Prefs:root=Bluetooth") else {return}
                   if #available(iOS 10.0, *) {
                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                   } else {
                       UIApplication.shared.openURL(url)
                   }
              }], cancelTitle:kOkay) { (_) in
          }
    }
}

//MARK: CBCentralManagerDelegate, CBPeripheralDelegate
extension SettingsViewController : CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
      //  if DataManager.isBluetoothPrinter {
            if central.state == .poweredOn {
                //Scan For Printer
                
                isBluetoothOn = true
                if DataManager.isBluetoothPrinter {
                    self.loadPrinter()
                }
                
             //  SettingsViewController.centeralManager?.scanForPeripherals(withServices: nil, options: nil)
                
            }else {
                isShowAlert = true
                isBluetoothOn = false
                if DataManager.isBluetoothPrinter {
                   
                    self.moveToSettings()
                }
                SettingsViewController.printerUUID = nil
                SettingsViewController.printerArray.removeAll()
                SettingsViewController.printerManager?.disconnectAllPrinter()
                SettingsViewController.printerManager = nil
                self.tbl_Settings.reloadData()
              
            }
      //  }
    }
}

//MARK: API Methods
extension SettingsViewController {
    func callAPItoGetCountryList(textField: UITextField? = nil) {
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            return
        }
        
        HomeVM.shared.getCountryList(country: "") { (success, message, error) in
            if success == 1 {
                if textField != nil {
                    textField!.becomeFirstResponder()
                }
                self.tbl_Settings.reloadData()
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
}

//MARK: HieCORPickerDelegate
extension SettingsViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        if isPaperWidth {
            DataManager.paperSize = Int(arrPaperWidthSize[index]) ?? 58
            pickerTextfield.text = arrPaperWidthSize[index]
            return
        }
        let array = HomeVM.shared.countryDetail.compactMap({$0.abbreviation})
        pickerTextfield.text = array[index]
    }
    
    func didClickOnPickerViewDoneButton() {
        if isPaperWidth {
            isPaperWidth = false
           // DataManager.paperSize = Int(arrPaperWidthSize[index]) ?? 58
                DataManager.paperSize = Int(pickerTextfield.text ?? "58") ?? 58
                pickerTextfield.resignFirstResponder()
            
             
            return
        }
        DataManager.selectedCountry = pickerTextfield.text ?? ""
        pickerTextfield.resignFirstResponder()
        HomeVM.shared.regionsList.removeAll()
    }
    
    func didClickOnPickerViewCancelButton() {
        if isPaperWidth {
            isPaperWidth = false
            DataManager.paperSize =  58
            pickerTextfield.text = "58"
             pickerTextfield.resignFirstResponder()
           // tbl_Settings.reloadData()
            return
        }
        pickerTextfield.text = "US"
        DataManager.selectedCountry = "US"
        pickerTextfield.resignFirstResponder()
        HomeVM.shared.regionsList.removeAll()
    }
}

//MARK: OfflineDataManagerDelegate
extension SettingsViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        self.lockLineView.isHidden = !isOn
        self.lockButton.isHidden = !isOn
        self.logoutButton.isHidden = !isOn
        self.logoutLineView.isHidden = !isOn
        self.tbl_Settings.reloadData()
    }
}



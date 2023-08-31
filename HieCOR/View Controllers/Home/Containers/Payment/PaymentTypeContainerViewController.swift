//
//  PaymentTypeContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 19/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PaymentTypeContainerViewController: BaseViewController, RUADeviceSearchListener, RUAAudioJackPairingListener {
       
    func isReaderSupported(_ reader: RUADevice) -> Bool{
        if (reader.name == nil){
            return false
        }
        print(reader.name)
        return reader.name.lowercased().hasPrefix("rp") || reader.name.lowercased().hasPrefix("mob")
    }
    
    func discoveredDevice(_ reader: RUADevice) {
        var isIncluded:Bool = false
        print("enterhgashdgfahgsd11")
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
        }
        
        print(deviceList)
    }
    
    func discoveryComplete() {
        print(deviceList)
        isDiscoveryComplete = true
        
        if deviceList.count > 0 {
                        if  isDiscoveryComplete == true{
                            for one in deviceList {
                                let name = one.name
                                if name == DataManager.RUADeviceConnectValueDataSet {
                                    connectingDevice = one
                                }
                            }
                            
                            if connectingDevice == nil {
                                Indicator.sharedInstance.hideIndicator()
                                appDelegate.showToast(message: "Device is powered off, please power on.")
                                return
                            }
                            
                            print("enterhgashdgfahgsd12")
                            ingenico.paymentDevice.select(connectingDevice!)
                            ingenico.paymentDevice.initialize(self)
                            //ingenico.paymentDevice.stopSearch()
            //                if (baseURLTextField.text != nil) {
            //                    UserDefaults.standard.setValue(baseURLTextField.text, forKey: "DefaultURL")
            //                    UserDefaults.standard.synchronize()
            //                }
                            
//                            Ingenico.sharedInstance()?.user.logoff { (error) in
//                                self.setLoggedIn(false)
//                                if error == nil {
//                                    //SVProgressHUD.showSuccess(withStatus: "Logoff Succeeded")
//                                    //_ = self.navigationController?.popViewController(animated: true)
//                                }else{
//                                    //SVProgressHUD.showError(withStatus: "Logoff Failed")
//                                }
//                            }
                            
                            print("enterhgashdgfahgsd13")
                            ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                                apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                                clientVersion: ClientVersion)
                            print("enterhgashdgfahgsd14")
                            ingenico.setLogging(false)
                            print("enterhgashdgfahgsd15")
                            loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password)
                            
                            //let loginVC:LoginViewController  = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                            //self.navigationController?.pushViewController(loginVC, animated: false)
                        }
        } else {
            if !getIsDeviceConnected() {
                Indicator.sharedInstance.hideIndicator()
                appDelegate.showToast(message: "Device is powered off, please power on.")
                return
            }
        }

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
            print("Device Status: Pairing completed.\n Remove r")
            //self.deviceStatusLabel.text = "Device Status: Pairing completed.\n Remove reader from  audio jack to test Bluetooth connection.\n Make sure reader is powered on."
        }
    }
    
    func onPairNotSupported() {
        print("Device Status: Pairing not supported")
        //self.deviceStatusLabel.text = "Device Status: Pairing not supported"
    }
    
    func  onPairFailed() {
        print("Device Status: Pairing Failed")
        //self.deviceStatusLabel.text = "Device Status: Pairing Failed"
    }
    
    func loginWithUserName( _ uname : String, andPW pw : String){
                
        self.view.endEditing(true)
        print("asdkaskdfjaklsdfj16")
        //SVProgressHUD.show(withStatus: "Logging")
        print("\(uname)")
        print("\(pw)")
        print("\(String(describing: Ingenico.sharedInstance()?.user.self))")
        print(ingenico)
        Ingenico.sharedInstance()?.user.loginwithUsername(uname, andPassword: pw) { (user, error) in
            //SVProgressHUD.dismiss()
            //self.ingenico.paymentDevice.stopSearch()
            print("asdfkajsdfkasdfk17")
            if (error == nil) {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.setLoggedIn(true)
                self.checkFirmwareUpdate()
                //appDelegate.showToast(message: "Device Connected")
                Indicator.sharedInstance.hideIndicator()
                self.delegate?.didSelectPaymentMethod?(with: "CARD READER")
                //self.cardReaderMainView.isHidden = true
                //self.tbl_Settings.reloadData()
                //self.performSegue(withIdentifier:"loginsuccess" , sender: nil)
                
            }else{
                print("asdfasdfsaf18")
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
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Variables
    var sectionArray = [String]()
    var totalAmount = Double()
    var CustomerObj = CustomerListModel()
    var cartProductsArray = Array<Any>()
    var str_ShippingANdHandling = String()
    var str_AddDiscount = String()
    var str_AddCouponName = String() //Coupon code
    var str_AddNote = String()
    var SubTotalPrice = Double()
    var str_TaxAmount = String()
    var str_RegionName = String()  //custom_tax_ID
    var isCreditCardNumberDetected = false
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var orderType: OrderType = .newOrder
    var orderInfoObj = OrderInfoModel()
    var isOpenToOrderHistory = false
    var versionOb = Int()
    
    fileprivate var ingenico:Ingenico!
    fileprivate var deviceList:[RUADevice] = []
    let ClientVersion:String  = "4.2.3"
    private var isDiscoveryComplete = false;

    
    //    - 0 : "CASH"
    //    - 1 : "ACH CHECK"
    //    - 2 : "EXTERNAL"
    //    - 3 : "EXTERNAL GIFT CARD"
    //    - 4 : "INVOICE"
    //    - 5 : "MULTI CARD"
    //    - 6 : "CHECK"
    //    - 7 : "PAX PAY"
    //    - 8 : "INTERNAL GIFT CARD"
    //    - 9 : "CREDIT"
    
    //"HEARTLAND GIFT CARD"
    //"Heartland Gift Card"
    
    var tempArr = ["CASH", "CREDIT", "CHECK", "ACH CHECK", "INVOICE", "PAX PAY", "INTERNAL GIFT CARD", "GIFT CARD", "EXTERNAL", "EXTERNAL GIFT CARD", "CARD READER"]
    var paymentOrder = [""]
    
    //MARK: Private Variables
    private var ACCEPTABLE_CHARACTERS = "0123456789"
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        
        versionOb = Int(DataManager.appVersion)!
        ingenico = Ingenico.sharedInstance()
        ingenico.setLogging(false)
        deviceList = [RUADevice]()

        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            
            // by sudama offline
            if DataManager.offlineccProcess {
                tempArr = ["CASH", "CREDIT"]
            }else{
                tempArr = ["CASH"]
            }
            
        } else {
            if versionOb < 4 {
                tempArr = ["CASH", "CREDIT", "CHECK", "ACH CHECK", "INVOICE", "PAX PAY", "INTERNAL GIFT CARD", "GIFT CARD", "EXTERNAL", "EXTERNAL GIFT CARD"]
                
            } else {
                tempArr = ["CASH", "CREDIT", "CHECK", "ACH CHECK", "INVOICE", "PAX PAY", "INTERNAL GIFT CARD", "GIFT CARD", "EXTERNAL", "EXTERNAL GIFT CARD", "CARD READER"]
                
            }
        }
  
        super.viewDidLoad()
        appDelegate.strPaymentType = ""
        self.loadData()
        //OfflineDataManager Delegate
        OfflineDataManager.shared.paymentTypeDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SwipeAndSearchVC.shared.isProductSearching = false
        SwipeAndSearchVC.shared.imagReadLib?.start()
        self.enableCardReader()
        updatePaymentMethods()
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.loadData()
            if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
                if DataManager.isBalanceDueData {
                    singanPaymentMethodMoveInMobile()
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        if UI_USER_INTERFACE_IDIOM() == .pad {
            delegate?.didSelectPaymentMethod?(with: appDelegate.strPaymentType)
           // delegate?.checkPayButtonColorChange?(isCheck: false, text : "restButton")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //MARK: Private Functions
    private func loadData() {
        self.updatePaymentMethods()
        if UI_USER_INTERFACE_IDIOM() == .pad && self.sectionArray.count == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                //self.delegate?.didSelectPaymentMethod?(with: self.sectionArray[0])
            }
        }
    }
    
    private func updatePaymentMethods() {
        if DataManager.selectedPayment != nil {
            if orderType == .newOrder {
                sectionArray = DataManager.selectedPayment!
            }else {
                sectionArray.removeAll()
                DataManager.isSplitPayment = false
                for method in DataManager.selectedPayment! {
                    if refundPaymentMethods.contains(method) {
                        sectionArray.append(method)
                    }
                }
            }
        }else{
            sectionArray = ["CREDIT"]
        }
        //MARK hide for offline mode to show only cash
        /*
         if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
         var tempArray = [String]()
         tempArr = ["CASH"]
         for method in sectionArray {
         let temp = method.uppercased() == "EXTERNAL GIFT CARD" ? "EXTERNAL_GIFT" : method.uppercased()
         if offlinePaymentArray.contains(temp) {
         tempArray.append(method)
         }
         }
         sectionArray = tempArray
         }
         */
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            // by sudama offline
            if DataManager.offlineccProcess {
                tempArr = ["CASH", "CREDIT"]
            }else{
                tempArr = ["CASH"]
            }
        } else {
            if versionOb < 4 {
                tempArr = ["CASH", "CREDIT", "CHECK", "ACH CHECK", "INVOICE", "PAX PAY", "INTERNAL GIFT CARD", "GIFT CARD", "EXTERNAL", "EXTERNAL GIFT CARD"]
                
            } else {
                tempArr = ["CASH", "CREDIT", "CHECK", "ACH CHECK", "INVOICE", "PAX PAY", "INTERNAL GIFT CARD", "GIFT CARD", "EXTERNAL", "EXTERNAL GIFT CARD", "CARD READER"]
                if isOpenToOrderHistory == true || (DataManager.isBalanceDueData && DataManager.isOpenPayNowInApp == false) {
                    var ind = tempArr.count + 1
                    for i in 0..<tempArr.count {
                        if tempArr[i] == "INVOICE" {
                            ind = i
                            tempArr.remove(at: i)
                            break
                        }
                    }

                }
            }
        }
        if DataManager.showTerminalIntregationSettings == "false" || DataManager.showTerminalIntregationSettings == ""{
            for i in 0..<tempArr.count-1 {
                if  tempArr[i] == "PAX PAY" {
                    tempArr.remove(at: i)
                }else if  tempArr[i] == "     CREDIT" {
                    tempArr.remove(at: i)
                }else if  tempArr[i] == "     DEBIT" {
                    tempArr.remove(at: i)
                }else if  tempArr[i] == "     GIFT" {
                    tempArr.remove(at: i)
                }
            }
        }
        // Order Payment Method
        paymentOrder.removeAll()
        for arrVal in tempArr {
            for arrData in sectionArray {
                if arrVal == arrData {
                    paymentOrder.append(arrVal)
                }
            }
        }
        
        self.collectionView.reloadData()
    }
    
    private func moveToCreditCardScreen(isSwiped: Bool = false) {
        PaymentsViewController.paymentDetailDict.removeAll()
        SwipeAndSearchVC.delegate = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
        controller.paymentName = "CREDIT"
        controller.totalAmount = self.totalAmount
        controller.CustomerObj = self.CustomerObj
        controller.cartProductsArray = self.cartProductsArray
        controller.str_AddNote = self.str_AddNote
        controller.str_AddDiscount = self.str_AddDiscount
        controller.str_AddCouponName = self.str_AddCouponName
        controller.str_ShippingANdHandling = self.str_ShippingANdHandling
        controller.SubTotalPrice = self.SubTotalPrice
        controller.str_TaxAmount = self.str_TaxAmount
        controller.str_RegionName = self.str_RegionName
        controller.isCreditCardNumberDetected = self.isCreditCardNumberDetected
        controller.orderType = self.orderType
        controller.orderInfoObj = self.orderInfoObj
        controller.isSwiped = isSwiped
        //controller.delegate = se
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func moveToPreviousSavedScreen() {
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key != "" {
            SwipeAndSearchVC.delegate = nil
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
            controller.paymentName = key.uppercased()
            controller.totalAmount = self.totalAmount
            controller.CustomerObj = self.CustomerObj
            controller.cartProductsArray = self.cartProductsArray
            controller.str_AddNote = self.str_AddNote
            controller.str_AddDiscount = self.str_AddDiscount
            controller.str_AddCouponName = self.str_AddCouponName
            controller.str_ShippingANdHandling = self.str_ShippingANdHandling
            controller.SubTotalPrice = self.SubTotalPrice
            controller.str_TaxAmount = self.str_TaxAmount
            controller.str_RegionName = self.str_RegionName
            controller.isCreditCardNumberDetected = self.isCreditCardNumberDetected
            controller.orderType = self.orderType
            controller.orderInfoObj = self.orderInfoObj
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func updateSavedData(paymentName: String) {
        
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String {
            
            if key.lowercased() == paymentName {
                return
            }
            
            if var data = PaymentsViewController.paymentDetailDict["data"] as? JSONDictionary {
                
                if key.lowercased() == "credit" {
                    data["tip"] = 0
                    data["tipType"] = 0
                }
                
                if key.lowercased() == "pax pay" {
                    data["tip"] = "0"
                    data["tipType"] = "0"
                }
                PaymentsViewController.paymentDetailDict["data"] = data
            }
            
            if let data = PaymentsViewController.paymentDetailDict["data"] as? [[String:AnyObject]] {
                if key.lowercased() == "multi card" {
                    var newDictArray = [[String:AnyObject]]()
                    
                    for dict in data {
                        var newDict = [String:AnyObject]()
                        newDict = dict
                        if let _ = newDict["tip"] as? String {
                            newDict["tip"] = "" as AnyObject
                        }
                        newDictArray.append(newDict)
                    }
                    PaymentsViewController.paymentDetailDict["data"] = newDictArray
                }
                
                PaymentsViewController.paymentDetailDict["data"] = data
            }
            
        }
    }
    
    func singanPaymentMethodMoveInMobile() {
            let paymentName = self.paymentOrder.first?.uppercased()
            // by sudama add sub
          // by sudama add sub
            var isAddSubscription = false
            if self.cartProductsArray.count > 0 {
                for i in 0..<self.cartProductsArray.count {
                    let addSubcriptionCheck = (self.cartProductsArray[i] as AnyObject).value(forKey: "addSubscription") as? Bool ?? false
                    if addSubcriptionCheck {
                        isAddSubscription = true
                    }
                }
            }
            print(isAddSubscription)
            
            if isAddSubscription {
                if paymentName != ""{
                    if paymentName != "PAX PAY" && paymentName != "CREDIT" {
                        appDelegate.strPaymentType = ""
                        PaymentsViewController.paymentDetailDict["key"] = ""
    //                        showAlert(message: "Please select Credit payment type because cart having subscription product.")
                        appDelegate.showToast(message: "Please select Credit payment type because cart having subscription product.")
                        return
                    }
                    if DataManager.paxTokenizationEnable != "true" && paymentName != "CREDIT"{
                       PaymentsViewController.paymentDetailDict["key"] = ""
                        appDelegate.strPaymentType = ""
    //                        showAlert(message: "Please select Credit payment type because cart having subscription product.")
                        appDelegate.showToast(message: "Please select Credit payment type because cart having subscription product.")
                        return
                    }
                }
            }
            //
            
           
            self.updateSavedData(paymentName: paymentName ?? "")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
            controller.paymentName = self.paymentOrder.first!
            controller.totalAmount = self.totalAmount
            controller.CustomerObj = self.CustomerObj
            controller.cartProductsArray = self.cartProductsArray
            controller.str_AddNote = self.str_AddNote
            controller.str_AddDiscount = self.str_AddDiscount //Manual Discount
            controller.str_AddCouponName = self.str_AddCouponName
            controller.str_ShippingANdHandling = self.str_ShippingANdHandling
            controller.SubTotalPrice = self.SubTotalPrice
            controller.str_TaxAmount = self.str_TaxAmount
            controller.str_RegionName = self.str_RegionName
            controller.orderType = self.orderType
            controller.orderInfoObj = self.orderInfoObj
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PaymentTypeContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return paymentOrder.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let lbl = cell.contentView.viewWithTag(10)as? UILabel
        let backView = cell.contentView.viewWithTag(11)
        var name = self.paymentOrder[indexPath.row].lowercased().capitalized
        backView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if name == "Credit" {
            name = "Credit Card"
        }
        
        if name == "Pax Pay" {
            name = "Pax"
        }
        
        if name == "Ach Check" {
            name = "ACH Check"
        }
        
        if name == "Multi Card" {
            name = "Split Payment"
        }
        
        if name == "Gift Card" {
            name = "Heartland Gift Card"
        }
        if name == "External" {
            name = "External Financing"
        }
        if name == "Invoice" {
            name = "Invoice / Estimate"
        }
        
        lbl?.text = name
        cell.isUserInteractionEnabled = true
        cell.contentView.alpha = 1.0
        
        //Add Shadow
        backView?.layer.shadowColor = UIColor.lightGray.cgColor
        backView?.layer.shadowOffset = CGSize.zero
        backView?.layer.shadowOpacity = 0.5
        backView?.layer.shadowRadius = 3
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath)
        let backView = cell?.contentView.viewWithTag(11)
        UIView.animate(withDuration: 0.0,
                       animations: {
                        //Fade-out
                       // cell?.alpha = 0.3
                        backView?.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
                        
        }) { (completed) in
            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    backView?.backgroundColor = .white
                }
                appDelegate.strPaxMode = ""
                appDelegate.isErrorCreateOrderCase = false
                if self.paymentOrder[indexPath.row] == "CARD READER" {
                    
                    //DeviceManagementHelper.shared.startScan()
                    
                    if DataManager.isIngenicoConnected {
                        //appDelegate.showToast(message: "Device Connected")
        //                ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
        //                                    apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
        //                                    clientVersion: ClientVersion)
        //                ingenico.setLogging(true)
        //
        //                loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password)

                        //delegate?.didSelectPaymentMethod?(with: paymentOrder[indexPath.row])
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            
                            if !self.getIsDeviceConnected() {
                                Indicator.sharedInstance.showIndicator()
                                appDelegate.showToast(message: "Connecting to device")
                                self.ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                                    apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                                    clientVersion: self.ClientVersion)

                                //if communicationSegment.selectedSegmentIndex == 1 {
                                   // doSearching()

                                //self.ingenico.paymentDevice.setDeviceType(RUADeviceTypeRP45BT)
                                self.ingenico.paymentDevice.setDeviceType(RUADeviceType(rawValue: DataManager.RUADeviceTypeValueDataSet))

                                self.ingenico.paymentDevice.search(self)
                                return
                            }
                            
                            self.delegate?.didSelectPaymentMethod?(with: self.paymentOrder[indexPath.row])
                        } else {
                            let paymentName = self.paymentOrder[indexPath.row].uppercased()
                                    // by sudama add sub
                                  // by sudama add sub
                                    var isAddSubscription = false
                                    if self.cartProductsArray.count > 0 {
                                        for i in 0..<self.cartProductsArray.count {
                                            let addSubcriptionCheck = (self.cartProductsArray[i] as AnyObject).value(forKey: "addSubscription") as? Bool ?? false
                                            if addSubcriptionCheck {
                                                isAddSubscription = true
                                            }
                                        }
                                    }
                                    print(isAddSubscription)
                                    
                                    if isAddSubscription {
                                        if paymentName != ""{
                                            if paymentName != "PAX PAY" && paymentName != "CREDIT" {
                                                appDelegate.strPaymentType = ""
                                                PaymentsViewController.paymentDetailDict["key"] = ""
                        //                        showAlert(message: "Please select Credit payment type because cart having subscription product.")
                                                appDelegate.showToast(message: "Please select Credit payment type because cart having subscription product.")
                                                return
                                            }
                                            if DataManager.paxTokenizationEnable != "true" && paymentName != "CREDIT"{
                                               PaymentsViewController.paymentDetailDict["key"] = ""
                                                appDelegate.strPaymentType = ""
                        //                        showAlert(message: "Please select Credit payment type because cart having subscription product.")
                                                appDelegate.showToast(message: "Please select Credit payment type because cart having subscription product.")
                                                return
                                            }
                                        }
                                    }
                                    //
                                    
                                   
                                    self.updateSavedData(paymentName: paymentName)
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let controller = storyboard.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
                            controller.paymentName = self.paymentOrder[indexPath.row]
                                    controller.totalAmount = self.totalAmount
                                    controller.CustomerObj = self.CustomerObj
                                    controller.cartProductsArray = self.cartProductsArray
                                    controller.str_AddNote = self.str_AddNote
                                    controller.str_AddDiscount = self.str_AddDiscount //Manual Discount
                                    controller.str_AddCouponName = self.str_AddCouponName
                                    controller.str_ShippingANdHandling = self.str_ShippingANdHandling
                                    controller.SubTotalPrice = self.SubTotalPrice
                                    controller.str_TaxAmount = self.str_TaxAmount
                                    controller.str_RegionName = self.str_RegionName
                                    controller.orderType = self.orderType
                                    controller.orderInfoObj = self.orderInfoObj
                                    
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }
                        
                    } else {
                        if DataManager.RUADeviceTypeValueDataSet == 9 {
                            appDelegate.showToast(message: "Device Not Connected. First connect device from setting page")
                        } else {
                            appDelegate.showToast(message: "Connecting to device")
                            self.ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                                apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                                clientVersion: self.ClientVersion)

                            //if communicationSegment.selectedSegmentIndex == 1 {
                               // doSearching()

                            //self.ingenico.paymentDevice.setDeviceType(RUADeviceTypeRP45BT)
                            self.ingenico.paymentDevice.setDeviceType(RUADeviceType(rawValue: DataManager.RUADeviceTypeValueDataSet))

                            self.ingenico.paymentDevice.search(self)
                        }
                    
                    }
                    return
                }
                appDelegate.strPaymentType = self.paymentOrder[indexPath.row]
                self.disableCardReader()
                SwipeAndSearchVC.delegate = nil
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    if self.orderInfoObj.cardDetail?.number != nil {
                        var number  = self.orderInfoObj.cardDetail!.number
                        if number != "" {
                            number = "************"+number!
                        }
                        PaymentsViewController.paymentDetailDict["data"] = ["cardnumber":"************"+number!,"mm":self.orderInfoObj.cardDetail?.month, "yyyy":self.orderInfoObj.cardDetail?.year, "cvv": ""]
                    }
                    if self.orderType == .refundOrExchangeOrder {
                        PaymentsViewController.paymentDetailDict["key"] = self.paymentOrder[indexPath.row]

                    }
                    //PaymentsViewController.paymentDetailDict["data"] = ["cardnumber":"************"+number!,"mm":orderInfoObj.cardDetail?.month, "yyyy":orderInfoObj.cardDetail?.year, "cvv": ""]
                    self.delegate?.didSelectPaymentMethod?(with: self.paymentOrder[indexPath.row])
                }
                else
                {
                    let paymentName = self.paymentOrder[indexPath.row].uppercased()
                    // by sudama add sub
                  // by sudama add sub
                    var isAddSubscription = false
                    if self.cartProductsArray.count > 0 {
                        for i in 0..<self.cartProductsArray.count {
                            let addSubcriptionCheck = (self.cartProductsArray[i] as AnyObject).value(forKey: "addSubscription") as? Bool ?? false
                            if addSubcriptionCheck {
                                isAddSubscription = true
                            }
                        }
                    }
                    print(isAddSubscription)
                    
                    if isAddSubscription {
                        if paymentName != ""{
                            if paymentName != "PAX PAY" && paymentName != "CREDIT" {
                                appDelegate.strPaymentType = ""
                                PaymentsViewController.paymentDetailDict["key"] = ""
        //                        showAlert(message: "Please select Credit payment type because cart having subscription product.")
                                appDelegate.showToast(message: "Please select Credit payment type because cart having subscription product.")
                                return
                            }
                            if DataManager.paxTokenizationEnable != "true" && paymentName != "CREDIT"{
                               PaymentsViewController.paymentDetailDict["key"] = ""
                                appDelegate.strPaymentType = ""
        //                        showAlert(message: "Please select Credit payment type because cart having subscription product.")
                                appDelegate.showToast(message: "Please select Credit payment type because cart having subscription product.")
                                return
                            }
                        }
                    }
                    //
                    
                   
                    self.updateSavedData(paymentName: paymentName)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
                    controller.paymentName = self.paymentOrder[indexPath.row]
                    controller.totalAmount = self.totalAmount
                    controller.CustomerObj = self.CustomerObj
                    controller.cartProductsArray = self.cartProductsArray
                    controller.str_AddNote = self.str_AddNote
                    controller.str_AddDiscount = self.str_AddDiscount //Manual Discount
                    controller.str_AddCouponName = self.str_AddCouponName
                    controller.str_ShippingANdHandling = self.str_ShippingANdHandling
                    controller.SubTotalPrice = self.SubTotalPrice
                    controller.str_TaxAmount = self.str_TaxAmount
                    controller.str_RegionName = self.str_RegionName
                    controller.orderType = self.orderType
                    controller.orderInfoObj = self.orderInfoObj
                    controller.isOpenToOrderHistory = self.isOpenToOrderHistory
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //var cellWidth = CGFloat((collectionView.frame.size.width/2)-10)
        var cellWidth = CGFloat((collectionView.frame.size.width/2))
        
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            // cellWidth = CGFloat((collectionView.frame.size.width/3)-15)
            cellWidth = CGFloat((collectionView.frame.size.width/3))
        }
        
        return CGSize(width: CGFloat(cellWidth), height: CGFloat(100))
    }
}

//MARK: READER
extension PaymentTypeContainerViewController {
    
    func disableCardReader() {
        //        SwipeAndSearchVC.delegate = nil
    }
    
    func enableCardReader() {
        SwipeAndSearchVC.delegate = nil
        SwipeAndSearchVC.delegate = self
        SwipeAndSearchVC.shared.enableTextField()
    }
}

//MARK: SwipeReaderVCVCDelegate
extension PaymentTypeContainerViewController: SwipeAndSearchDelegate {
    func didGetCardDetail(number: String, month: String, year: String) {
        if !paymentOrder.contains("CREDIT") {
//            self.showAlert(message: "Please add payment method credit card from Settings.")
            appDelegate.showToast(message: "Please add payment method credit card from Settings.")
            return
        }
        
        isCreditCardNumberDetected = true
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.didGetCardDetail?()
        }else {
            self.moveToCreditCardScreen(isSwiped: true)
        }
    }
    
    func noCardDetailFound() {
        isCreditCardNumberDetected = false
        self.delegate?.noCardDetailFound?()
    }
    
    func didUpdateDevice() {
        isCreditCardNumberDetected = false
        self.delegate?.didUpdateDevice?()
    }
}

//MARK: PaymentTypeContainerViewControllerDelegate
extension PaymentTypeContainerViewController: PaymentTypeContainerViewControllerDelegate {
    func disableCardReaders() {
        self.disableCardReader()
    }
    
    func enableCardReaders() {
        self.enableCardReader()
    }
}


//MARK: OfflineDataManagerDelegate
extension PaymentTypeContainerViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        self.updatePaymentMethods()
    }
}

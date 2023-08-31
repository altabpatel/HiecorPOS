//
//  OrderInfoViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 05/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SafariServices
import CoreBluetooth
import CoreBluetooth.CBService
import FirebaseCore
import FirebaseAnalytics
import Crashlytics
import Alamofire
import SocketIO
class OrderInfoViewController: BaseViewController, TipViewCellDelegate, RUADeviceSearchListener, RUAAudioJackPairingListener {
    
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
                
                print("enterhgashdgfahgsd13")
                ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                    apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                    clientVersion: ClientVersion)
                print("enterhgashdgfahgsd14")
                ingenico.setLogging(false)
                print("enterhgashdgfahgsd15")
                loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password, isSearch: true)
                
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
    
    func loginWithUserName( _ uname : String, andPW pw : String, isSearch: Bool){
        
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
                //appDelegate.showToast(message: "Device Connected")
                //Indicator.sharedInstance.hideIndicator()
                if isSearch {
                    appDelegate.showToast(message: "Device connected")
                } else {
                    self.promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
                }
                
      //          self.delegate?.didSelectPaymentMethod?(with: "CARD READER")
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

    func didFinishTask() {
        callAPItoGetOrderInfo()
    }
    
    
    let tipCustomView = TipCustomView()
    //MARK: IBOutlets
    @IBOutlet weak var tipButton: UIButton!
    
    @IBOutlet weak var tvAddressBilling: UITextView!
    @IBOutlet weak var tvAddressCustomer: UITextView!
    @IBOutlet weak var tvAddressShipping: UITextView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnClearHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var btnRefundHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewFooterUpLine: UIView!
    @IBOutlet var viewAdminComment: UIView!
    // @IBOutlet var viewHeightConstraintRefundExchngeView: NSLayoutConstraint!
    // @IBOutlet var viewLineAdminTop: UIView!
    @IBOutlet var labelHeadAdminComment: UILabel!
    @IBOutlet var stackViewCust: UIStackView!
    @IBOutlet weak var labelUserId: UILabel!
    @IBOutlet weak var viewAddressSeparator: UIView!
    @IBOutlet weak var viewAddressSeparatorOne: UIView!
    @IBOutlet weak var CustomerAddressLabel: UILabel!
    @IBOutlet weak var CustomerHeadLabel: UILabel!
    @IBOutlet weak var billingHeadLabel: UILabel!
    @IBOutlet weak var shippingHeadLabel: UILabel!
    @IBOutlet weak var refundButton: UIButton!
    @IBOutlet weak var receiptButton: UIButton!
    @IBOutlet weak var orderIDlabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var orderSummaryButton: UIButton!
    @IBOutlet weak var transactionButton: UIButton!
    @IBOutlet weak var orderSummaryLineView: UIView!
    @IBOutlet weak var transactionLineView: UIView!
    @IBOutlet weak var orderDetailView: UIView!
    @IBOutlet weak var orderAddressDetailView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var labelAdminComment: UILabel!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var totalFooterLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var saleLocationLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var lblPaymentStatus: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblCompanyHeader: UILabel!
    @IBOutlet weak var shippingAddressLabel: UILabel!
    @IBOutlet weak var billingAddressLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var addressBackView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableBackView: UIView!
    @IBOutlet var tableViewheight: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var totalLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet var totalLabelStackViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableBackgroundTopImageView: UIImageView!
    @IBOutlet weak var tableBackgroundBottomImageView: UIImageView!
    
    @IBOutlet weak var viewDueDateIphone: UIView!
    @IBOutlet weak var ViewDueDate: UIStackView!
    @IBOutlet weak var lblPaymentTerms: UILabel!
    @IBOutlet weak var viewPaymentTerms: UIView!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblHeaderDueDate: UILabel!
  
    @IBOutlet var saleLocationView: UIView!
    @IBOutlet var companyNameView: UIView!
    @IBOutlet var refundExchangeButtonView: UIStackView!
    @IBOutlet var totalLabelConstraint: NSLayoutConstraint!
    @IBOutlet var noTransactionFoundImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var addressviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var orderDetailBackView: UIView!
    @IBOutlet var btnClear: UIButton!
    
    @IBOutlet var adminViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userContainer: UIView!
    
    @IBOutlet weak var refundSummaryHeightContraints: NSLayoutConstraint!
    @IBOutlet weak var lblRefundSumarryType: UILabel!
    @IBOutlet weak var lblRefundSummaryAmount: UILabel!
    @IBOutlet weak var ViewRefundsumarryAmontConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewRefundSummaryTypeConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnPayNow: UIButton!
    @IBOutlet weak var viewUserComment: UIView!
    @IBOutlet weak var lblUserComment: UILabel!
    @IBOutlet weak var lblHeadUserComment: UILabel!
    @IBOutlet weak var constantUserCommentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnCustomerPickup: UIButton!
    @IBOutlet weak var viewPoNumber: UIView!
    @IBOutlet weak var viewInvoiceTitle: UIView!
    @IBOutlet weak var vieeRepresentativeName: UIView!
    @IBOutlet weak var lblPoNumber: UILabel!
    @IBOutlet weak var lblInvoiceTitle: UILabel!
    @IBOutlet weak var lblRepresentativeName: UILabel!
    @IBOutlet weak var btnAllInOne: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var stackViewBouttomButtonHeader: UIStackView!
    @IBOutlet weak var view_scheduleDate: UIView!
    @IBOutlet weak var stackViewScheduledDate: UIStackView!
    @IBOutlet weak var lblScheduledDate: UILabel!
    @IBOutlet weak var btnPayIngenico: UIButton!
    @IBOutlet weak var view_paymentStatus: UIView!
    @IBOutlet weak var headerViewHieghtConstForIphone: NSLayoutConstraint!
    @IBOutlet weak var constantCompanyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constantPaymentTermViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constantPoNumberViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constantInvoiceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constantRepresentativeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constantPaymentStatusViewHeight: NSLayoutConstraint!
    
    //MARK: Variables
    var orderInfoModelObj = OrderInfoModel()
    var receiptModel = ReceiptContentModel()
    var transactionInfoArray = [TransactionsDetailModel]()
    var isTapOnTransactionButton = Bool()
    var isOrderSummery = Bool()
    var orderID = String()
    var transactionID = String()
    var status = String()
    var isLandscape = true
    var selectedIndex = Int()
    var index = IndexPath()
    var refundOrder: JSONDictionary?
    var versionOb = Int()
    var defualtViewFlag = false
    var tableFooterViewHeight = 0.0
    var refundAmoutTotal = 0.0
    var arrTransactionData : NSMutableArray = []
    var uncheckedRefund = true
    
    fileprivate var ingenico:Ingenico!
    fileprivate var deviceList:[RUADevice] = []
    let ClientVersion:String  = "4.2.3"
    private var isDiscoveryComplete = false;
    var myTextField:UITextField!
    var clerkIDTF:UITextField!
    var tapGesture : UITapGestureRecognizer?
    
    var staticDataArray = [[String: [String]]] ()
    var response:IMSTransactionResponse?
    var clerkID:String?
    var doneCallback:TransactionOnDone?
    var progressCallback:UpdateProgress?
    var applicationSelectionCallback:ApplicationSelectionHandler?
    var isViewController = false
    var sceViewController : IMSSecureCardEntryViewController?
    static var Transaction_Message:String = "Provide normalized transaction amount and clerkID"
    static var RefundTransaction_Message:String = "Provide normalized refund transaction amount and clerkID"
    var IngenicoDataResponce = IMSTransactionResponse()
    var canEnrollToken = false
    var checkIfCardPresent = false
    var canUpdateToken = false
    var tokenEnrollCheckBox = true
    var transactionType = IMSTransactionType.TransactionTypeUnknown

    //MARK: Delegate
    var orderInfoDelegate : OrderInfoViewControllerDelegate?
    var catAndProductDelegate: CatAndProductsViewControllerDelegate?
    
    var userDetailDelegate : UserDetailsDelegate?
    var delegateForCustomer: CustomerPickupDelegete?
    
    
    //MARK: PrinterManager
    static var printerManager: PrinterManager?
    static var printerArray = [PrinterStruct]()
    static var printerUUID: UUID? = nil
    
    static var centeralManager: CBCentralManager?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         LoadStarPrinter.settingManager.load()
        versionOb = Int(DataManager.appVersion)!
        tableView.dataSource = self
        tableView.delegate = self
        isLandscape = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        //loadPrinter()
        ingenico = Ingenico.sharedInstance()
        ingenico.setLogging(false)
        deviceList = [RUADevice]()

        if DataManager.isBluetoothPrinter {
            loadPrinter()
        }
        customizeUI()
        //Call API
        //Crashlytics.sharedInstance().crash()
        
        //btnClear.backgroundColor = UIColor.gray
        //btnClear.borderColor = UIColor.gray
        //btnClear.isUserInteractionEnabled = false
        //refundButton.isUserInteractionEnabled = false
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            callAPItoGetOrderInfo()
        }
        
        doneCallback = { (response, error) in
            //SVProgressHUD.dismiss()
            self.consoleLog(String.init(format: "Transaction Response:\n%@", self.getStringFromResponse(response)))
            self.IngenicoDataResponce = response!
            if response?.transactionID != nil && error == nil {
                self.setLastTransactionID((response?.transactionID)!)
                //SVProgressHUD.showSuccess(withStatus: "Transaction Approved")
                appDelegate.showToast(message: "Transaction Approved")
                DispatchQueue.main.async {
                    Indicator.sharedInstance.lblIngenico.text = ""
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                         MainSocketManager.shared.onPaymentMessage(paymentMesssage: "")
                    }
                }
                appDelegate.strIngenicoErrorMsg = ""
                print(response)
                if DataManager.isIngenicPaymentMethodCancelAndMessage {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                         MainSocketManager.shared.onPaymentMessage(paymentMesssage: "Transaction Approved")
                    }
                }
                
                Indicator.sharedInstance.hideIndicator()
                //self.IngenicoDataResponce = response!
                self.getSignatureOrUpdateTransaction(response!)
            }else {
                let nserror = error as NSError?
                Indicator.sharedInstance.hideIndicator()
                if response?.transactionID != nil && response?.transactionResponseCode.rawValue == 2{
                    //self.isPayButtonSelected = true
                    Indicator.sharedInstance.hideIndicator()
                    //self.placeOrder(isAuth: false, isSwiped: false)
                    
                }
                
                //appDelegate.strIngenicoErrorMsg = self.getResponseCodeString((nserror!.code))
                //SVProgressHUD.showError(withStatus: "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))")
                //appDelegate.showIncreaseTimeToast(message: "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))")
                //self.consoleLog( "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))")
                if DataManager.isIngenicPaymentMethodCancelAndMessage {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                            //MainSocketManager.shared.onPaymentError(errorMessage: "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))")
                    }
                }
                
                Indicator.sharedInstance.hideIndicator()
                //if  "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))" == "Transaction Failed with error code: Transaction Cancelled" {
//                    self.placeOrder(isAuth: false, isSwiped: false)
                //}
            }
        }
        
        progressCallback = {(message, extraMessage) in
            let stringMessage = self.getProgressStrFromMessage(message)
            if stringMessage != nil {
                if DataManager.isIngenicPaymentMethodCancelAndMessage {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        MainSocketManager.shared.onPaymentMessage(paymentMesssage: stringMessage)
                    }
                }
                
                DispatchQueue.main.async {
                    Indicator.sharedInstance.lblIngenico.text = stringMessage
                }
                
                //appDelegate.showToastForCleanBGColor(message: stringMessage ?? "")
                //appDelegate.showIncreaseTimeToast(message: stringMessage ?? "")
                //Indicator.sharedInstance.hideIndicator()
                //SVProgressHUD.show(withStatus: stringMessage)
            }
        }
        
        applicationSelectionCallback = { ( list, error, response) in
            //SVProgressHUD.dismiss()
            
            let applicationList = list as! [RUAApplicationIdentifier]
            let viewcontroller:UIAlertController = UIAlertController.init(title: "Select application for your card", message: "Make your choice", preferredStyle: .actionSheet)
            for appID in applicationList {
                let okAction:UIAlertAction = UIAlertAction.init(title: appID.applicationLabel, style: .default, handler: { (action) in
                    //SVProgressHUD.show(withStatus: "Processing Card Transaction")
                    appDelegate.showToast(message: "Processing Card Transaction")
                    viewcontroller.dismiss(animated: true, completion: nil)
                    response!(appID)
                })
                viewcontroller.addAction(okAction)
            }
            self.present(viewcontroller, animated: true, completion: nil)
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UI_USER_INTERFACE_IDIOM() == .pad ? .default : .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if appDelegate.orderDataClear {// for pay invoice on payment method
            DataManager.cartData = nil
            DataManager.cartProductsArray = nil
            DataManager.customerObj = nil
            appDelegate.orderDataClear = false
          //  appDelegate.isOpenToOrderHistory = false
            HomeVM.shared.coupanDetail.code = ""
            HomeVM.shared.tipValue = 0.0
            DataManager.customerId = ""
            DataManager.isCheckUncheckShippingBilling = true
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                MainSocketManager.shared.connect()
                let socketConnectionStatus = MainSocketManager.shared.socket.status
                
                switch socketConnectionStatus {
                case SocketIOStatus.connected:
                    print("socket connected")
                    MainSocketManager.shared.onreset()
                case SocketIOStatus.connecting:
                    print("socket connecting")
                case SocketIOStatus.disconnected:
                    print("socket disconnected")
                case SocketIOStatus.notConnected:
                    print("socket not connected")
                }
            }
            UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
        }
        
        self.isLandscape = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        self.scrollView.alpha = 0
        self.reloadTableData(animate: false)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.reloadTableData(animate: true)
        }
        
        if appDelegate.strIphoneApi == true {
            callAPItoGetOrderInfo()
            appDelegate.strIphoneApi = false
        }
        
       // self.btnPayIngenico.isHidden = (DataManager.isCardReader == false) ? true : false
        
        self.updateView()
        DispatchQueue.main.async(){
            self.updateUI()
        }
        if DataManager.isBluetoothPrinter {
            self.checkPrinterConnection()
        }
        //self.checkPrinterConnection()
        DataManager.collectTips = DataManager.collectTips ? DataManager.collectTips : DataManager.tempCollectTips
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("Data Is value ")
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.isLandscape = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
            self.scrollView.alpha = 0
            self.reloadTableData(animate: false)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.reloadTableData(animate: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transactioninfo" {
            let vc = segue.destination as! TransactionsInfoViewController
            vc.transactionInfo = transactionInfoArray[selectedIndex]
        }
        
        if segue.identifier == "cart" {
            let vc = segue.destination as! CartViewController
            
            if DataManager.isCaptureButton {
                vc.orderType = .newOrder
            } else {
                vc.orderType = .refundOrExchangeOrder
            }
            
            vc.refundOrder = self.refundOrder
        }
        
        if segue.identifier == "UserDetailViewController" {
            let vc = segue.destination as! UserDetailViewController
            vc.userDetailDelegate = self
            vc.orderInfoDetail = orderInfoModelObj
            userDetailDelegate = vc
        }
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        self.tableView.isScrollEnabled = false
        self.scrollView.isScrollEnabled = true
        isOrderSummery = true
        self.scrollView.alpha = 0
        receiptButton.isUserInteractionEnabled = DataManager.receipt
        receiptButton.alpha = DataManager.receipt ? 1.0 : 0.5
        //Orientationsds
        isLandscape = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        
        //Offline
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            blurView.backgroundColor = UIColor.white
            blurView.isHidden = false
        }
        
        //Add Shadow
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.addressBackView.layer.shadowColor = UIColor.darkGray.cgColor
            self.addressBackView.layer.shadowOffset = CGSize.zero
            self.addressBackView.layer.shadowOpacity = 0.3
            self.addressBackView.layer.shadowRadius = 2
            
            self.viewAdminComment.layer.shadowColor = UIColor.darkGray.cgColor
            self.viewAdminComment.layer.shadowOffset = CGSize.zero
            self.viewAdminComment.layer.shadowOpacity = 0.3
            self.viewAdminComment.layer.shadowRadius = 2
        } else {
            self.orderDetailBackView.layer.shadowColor = UIColor.darkGray.cgColor
            self.orderDetailBackView.layer.shadowOffset = CGSize.zero
            self.orderDetailBackView.layer.shadowOpacity = 0.5
            self.orderDetailBackView.layer.shadowRadius = 5
            
            self.viewAdminComment.layer.shadowColor = UIColor.darkGray.cgColor
            self.viewAdminComment.layer.shadowOffset = CGSize.zero
            self.viewAdminComment.layer.shadowOpacity = 0.5
            self.viewAdminComment.layer.shadowRadius = 5
        }
    }
    
    private func checkPrinterConnection() {
        if PrintersViewController.centeralManager == nil || PrintersViewController.printerManager == nil {
            return
        }
        
        if let manager = PrintersViewController.printerManager, !manager.canPrint {
            if let index = PrintersViewController.printerArray.firstIndex(where: {$0.identifier == PrintersViewController.printerUUID}) {
                DispatchQueue.main.async {
                    PrintersViewController.printerManager?.connect(PrintersViewController.printerArray[index])
                }
            }
        }
    }
    
    private func handleOrderSummaryButtonAction() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            //             if orderInfoModelObj.isBillingSame == 0{
            //              self.addressviewHeightConstraint.constant = 220 //220
            //            }
            transactionLineView.backgroundColor = #colorLiteral(red: 0.9371728301, green: 0.9373074174, blue: 0.9371433854, alpha: 1)
        } else {
            transactionLineView.isHidden = true
            orderSummaryLineView.isHidden = false
        }
        isOrderSummery = true
        self.tableView.isScrollEnabled = false
        self.scrollView.isScrollEnabled = true
        noTransactionFoundImageView.isHidden = true
        orderDetailView.isHidden = false
        tableFooterView.isHidden = false
        //  orderAddressDetailView.isHidden = false
        
        
        transactionButton.setTitleColor(#colorLiteral(red: 0.5489655137, green: 0.5647396445, blue: 0.603846848, alpha: 1), for: .normal)
        orderSummaryButton.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
        orderSummaryLineView.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
        var height = 0
        if orderInfoModelObj.invoiceterms != "" {
            height = 20
        }
        if orderInfoModelObj.paymentStatus == "INVOICE" {
            tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(170+height))
            if UI_USER_INTERFACE_IDIOM() == .phone {
                if orderInfoModelObj.scheduled_date != "" &&  orderInfoModelObj.po_number !=  "" && orderInfoModelObj.invoiceterms != "" && orderInfoModelObj.companyName != ""{
                    tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(280))
                }else if orderInfoModelObj.scheduled_date != "" &&  orderInfoModelObj.po_number !=  "" && orderInfoModelObj.invoiceterms != "" {
                    tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(250))
                }else if orderInfoModelObj.scheduled_date != "" &&  orderInfoModelObj.po_number != "" {
                    tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(210))
                }else if orderInfoModelObj.po_number != "" &&  orderInfoModelObj.invoiceDate != "" {
                    tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(190))
                }
            }
        } else {
            if UI_USER_INTERFACE_IDIOM() == .phone {
                if orderInfoModelObj.scheduled_date != "" {
                    tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(170))
                }else {
                    tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(150))
                }
            }else {
                tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(150))
            }
        }
        scrollView.alpha = 0
        reloadTableData(animate: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.reloadTableData(animate: true)
        }
    }
    
    private func updateView() {
        
//        if UI_USER_INTERFACE_IDIOM() == .pad {
//
//            //            if orderInfoModelObj.isBillingSame == 0{
//            //                self.addressviewHeightConstraint.constant = 350 //220
//            //            }
//            if isLandscape {
//                totalLabelWidthConstraint.isActive = true
//                totalLabelStackViewRightConstraint.isActive = false
//                //ViewRefundsumarryAmontConstraint.isActive = true
//                if isOrderSummery {
//                    tableViewTopConstraint.constant = 30
//                    tableViewLeftConstraint.constant = 15
//                    tableViewRightConstraint.constant = 15
//                    //  tableViewBottomConstraint.constant = 30
//                    tableBackgroundTopImageView.isHidden = false
//                    tableBackgroundBottomImageView.isHidden = false
//                }else {
//                    tableViewTopConstraint.constant = 0
//                    tableViewLeftConstraint.constant = 0
//                    tableViewRightConstraint.constant = 0
//                    //tableViewBottomConstraint.constant = 0
//                    tableBackgroundTopImageView.isHidden = true
//                    tableBackgroundBottomImageView.isHidden = true
//                }
//            }else {
//                tableViewTopConstraint.constant = 0
//                tableViewLeftConstraint.constant = 0
//                tableViewRightConstraint.constant = 0
//                // tableViewBottomConstraint.constant = 0
//                totalLabelWidthConstraint.isActive = false
//                totalLabelStackViewRightConstraint.isActive = true
//                tableBackgroundTopImageView.isHidden = true
//                tableBackgroundBottomImageView.isHidden = true
//                //                if ViewRefundsumarryAmontConstraint.isActive {
//                //                    ViewRefundsumarryAmontConstraint.isActive = false
//                //                }
//
//            }
//        }
        self.updateUI()
    }
    
    func resetAllValues() {
        
        for i in 0..<orderInfoModelObj.productsArray.count {
            orderInfoModelObj.productsArray[i].isExchangeSelected = false
            orderInfoModelObj.productsArray[i].isRefundSelected = false
        }
        
        for i in 0..<orderInfoModelObj.transactionArray.count {
            orderInfoModelObj.transactionArray[i].isPartialRefundSelected = false
            orderInfoModelObj.transactionArray[i].isFullRefundSelected = false
            orderInfoModelObj.transactionArray[i].isVoidSelected = false
            orderInfoModelObj.transactionArray[i].partialAmount = ""
        }
        
        tableView.reloadData()
    }
    
    private func updateUI() {
        
        arrTransactionData.removeAllObjects()
        self.btnCustomerPickup.isHidden = true
        if UI_USER_INTERFACE_IDIOM() == .pad {
            userContainer.isHidden = true
        }
        if UI_USER_INTERFACE_IDIOM() == .phone {
            headerViewHieghtConstForIphone.constant = 160
        }
        if orderInfoModelObj.showPosCustomerPickup {
            self.btnCustomerPickup.isHidden = false
        }
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if orderInfoModelObj.showPosCustomerPickup || orderInfoModelObj.showPayNow == "true" {
                headerViewHieghtConstForIphone.constant = 160
            }else{
                headerViewHieghtConstForIphone.constant = 110
            }
        }
        btnUpdate.isHidden =  orderInfoModelObj.updateInvoiceURL == ""
        stackViewBouttomButtonHeader.isHidden = false
        if !orderInfoModelObj.showPosCustomerPickup && orderInfoModelObj.updateInvoiceURL == "" {
            //stackViewBouttomButtonHeader.isHidden = true
            btnUpdate.isHidden = true
        }
        if orderInfoModelObj.status.uppercased() == "CANCELED"{ // for hide update button
            btnUpdate.isHidden = true
        }
        //self.btnCapture.isHidden = true
        //hide for this release
                if orderInfoModelObj.paymentStatus == "AUTH" {
                    self.btnCapture.isHidden = true
                }else{
                    self.btnCapture.isHidden = true
                }
        
        
        if versionOb < 4 {
            if UI_USER_INTERFACE_IDIOM() == .phone {
                //self.refundButton.isHidden = true
                //self.btnClear.isHidden = true
                //self.btnClearHeightConstraint.constant = 0
                //self.btnRefundHeightConstraint.constant = 0
                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 30)
                view.layoutIfNeeded()
            }else{
                //self.refundButton.isHidden = true
                //self.btnClear.isHidden = true
                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 110)
            }
        }else{
            //self.refundButton.isHidden = false
            //self.btnClear.isHidden = false
            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 0)

//            if UI_USER_INTERFACE_IDIOM() == .phone {
//                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 70)
//            }else{
//                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 0)
//            }
            // tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 120)
            //tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund) ? 40 : 250))
        }
        if defualtViewFlag {
            orderInfoDelegate?.didUpdateHeaderText?(with: "Orders")
        }else{
            orderInfoDelegate?.didUpdateHeaderText?(with: "#\(orderInfoModelObj.orderID)")
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newDate = dateFormatter.date(from: orderInfoModelObj.orderDate) ?? Date()
        
        orderDateLabel.text = newDate.stringFromDate(format:orderInfoModelObj.paymentStatus == "INVOICE" ? .InvoiceyDate : .mdyDateTime, type: .local)
        orderIDlabel.text = "#\(orderInfoModelObj.orderID)"
        orderIdLabel.text = "#\(orderInfoModelObj.orderID)"
        //transactionTypeLabel.text = orderInfoModelObj.transactionType
        saleLocationLabel.text = orderInfoModelObj.saleLocation
        companyNameLabel.text = orderInfoModelObj.companyName
        //totalFooterLabel.text = orderInfoModelObj.total.currencyFormat
        lblPaymentStatus.text = orderInfoModelObj.paymentStatus
        lblOrderStatus.text = orderInfoModelObj.status == "" ? "  " : orderInfoModelObj.status
        view_paymentStatus.isHidden = orderInfoModelObj.paymentStatus == ""
        if UI_USER_INTERFACE_IDIOM() == .phone {
            constantPaymentStatusViewHeight.constant = view_paymentStatus.isHidden == true ? 0 : 39
        }
        if lblPaymentStatus.text == "INVOICE" {
            if orderInfoModelObj.invoiceDueDate == "" {
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    viewDueDateIphone.isHidden = true
                }else{
                    ViewDueDate.isHidden = true
                }
                lblDueDate.isHidden = true
                lblHeaderDueDate.isHidden = true
                view.setNeedsLayout()
                view.setNeedsDisplay()
                view.layoutIfNeeded()
            }else{
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    viewDueDateIphone.isHidden = false
                }else{
                    ViewDueDate.isHidden = false
                }
                lblDueDate.isHidden = false
                lblHeaderDueDate.isHidden = false
                lblDueDate?.text = orderInfoModelObj.invoiceDueDate
                view.setNeedsLayout()
                view.setNeedsDisplay()
                view.layoutIfNeeded()
            }
            if orderInfoModelObj.invoiceterms == ""{
                //            if UI_USER_INTERFACE_IDIOM() == .phone {
                //                viewDueDateIphone.isHidden = true
                //            }else{
                //                ViewDueDate.isHidden = true
                //            }
                viewPaymentTerms.isHidden = true
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    constantPaymentTermViewHeight.constant = 0
                }
                view.setNeedsLayout()
                view.setNeedsDisplay()
                view.layoutIfNeeded()
                
            }else{
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    viewDueDateIphone.isHidden = false
                }else{
                    ViewDueDate.isHidden = false
                }
                viewPaymentTerms.isHidden = false
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    constantPaymentTermViewHeight.constant = 39
                }
                lblPaymentTerms.text = orderInfoModelObj.invoiceterms
                view.setNeedsLayout()
                view.setNeedsDisplay()
                view.layoutIfNeeded()
            }
        } else {
            if UI_USER_INTERFACE_IDIOM() == .phone {
                viewDueDateIphone.isHidden = true
            }else{
                ViewDueDate.isHidden = true
            }
            viewPaymentTerms.isHidden = true
            if UI_USER_INTERFACE_IDIOM() == .phone {
                constantPaymentTermViewHeight.constant = 0
            }
        }
        
        let orderRefund : [RefundTransactionList] = orderInfoModelObj.refundTransactionList
        print(orderRefund)
        btnPayNow.isHidden = true
        if orderRefund.count > 0 {
            print(orderRefund[0].amount)
            var amount = ""
            var type = ""
            var changeDueAmt = ""
            refundAmoutTotal = 0.0
            var isCashPaid = false
            
            if orderRefund.count == 1 {
                //refundSummaryHeightContraints.constant = 40
            } else {
                //refundSummaryHeightContraints.constant = CGFloat(orderRefund.count * 65)
            }
            
            for i in 0..<orderRefund.count {
                
                if orderRefund[i].card_type  == "Paid by Cash" || orderRefund[i].card_type  == "Paid by cash" {
                    isCashPaid = true
                }
                
                let val = Double(orderRefund[i].amount)!
                refundAmoutTotal += val
                
                if orderRefund.count == 1 {
                    amount = "\(val.currencyFormat)"
                    type = "\(orderRefund[i].card_type)"
                } else {
                    amount = "\(amount) \n \(val.currencyFormat)\n"
                    type = "\(type) \n \(orderRefund[i].card_type)\n"
                }
                
                let responseMessages = ["amount": "\(val.currencyFormat)",
                                        "type": "\(orderRefund[i].card_type)",
                                        "date": "\(orderRefund[i].date)",
                                        "txn_id": "\(orderRefund[i].txn_id)",
                                        "isTypeEVM": "\(orderRefund[i].is_txn_type_EMV)",
                                        "cardNumber": "\(orderRefund[i].card_number)",
                                        "isTipBtn": "\(orderRefund[i].show_tip_button)",
                                    "isShowPaxDevice": "\(orderRefund[i].show_pax_device)"]
                
                arrTransactionData.add(responseMessages)
            }
            
            print(amount)
            print(type)
            print(refundAmoutTotal)
            
            if isCashPaid {
                
                let hh = orderInfoModelObj.changeDue.replacingOccurrences(of: ",", with: "")
                
                if hh != "" {
                    //let jk = Float(hh)
                    let chnageDueVal : Double = Double(hh)!
                    
                    if chnageDueVal > 0{
                        
                        if orderRefund.count == 1 {
                            //refundSummaryHeightContraints.constant += 30
                        }
                        changeDueAmt = "\(chnageDueVal.currencyFormat)"
                        amount = "\(amount) \n \(changeDueAmt)\n"
                        type = "\(type) \nChange\n"
                        
                        if changeDueAmt != "$0.00" {
                            let responseMessages = ["amount": "\(chnageDueVal.currencyFormat)",
                                "type": "Change",
                                "date": "---",
                                "isTipBtn": false] as [String : Any]
                            
                            arrTransactionData.add(responseMessages)
                        }
                    }
                }
            }
            
            //                        amount = "\(amount) \n \(refundAmoutTotal.currencyFormat)\n"
            //                        type = "\(type) \n Total Refund Amount\n"
            
            let balDue = orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")
            
            if balDue != "" {
                //let jk = Float(hh)
                let balDueVal : Double = Double(balDue)!
                
                if balDueVal > 0 {
                    print(balDue)
                    //refundSummaryHeightContraints.constant += 30
                    btnPayNow.isHidden = false
                    amount = "\(amount) \n \(balDueVal.currencyFormat)"
                    //changeDueAmt = "\(balDueVal.currencyFormat)"
                    type = "\(type) \nBalance Due\n"
                    
                    let responseMessages = ["amount": "\(balDueVal.currencyFormat)",
                        "type": "Balance Due",
                        "date": "---",
                        "isTipBtn": false] as [String : Any]
                    
                    arrTransactionData.add(responseMessages)
                    
                    
                    tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 46)
                    btnPayNow.isHidden = false
                }
            }
            
            //lblRefundSumarryType.text = type
            //lblRefundSummaryAmount.text = "\(amount)"
            
        } else {
            //refundSummaryHeightContraints.constant = 0

            let balDue = orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")
            
            var balData = ""
            var typeDue = ""
            
            if balDue != "" {
                //let jk = Float(hh)
                let balDueVal : Double = Double(balDue)!
                
                if balDueVal > 0 {
                    print(balDue)
                    btnPayNow.isHidden = false
                    //refundSummaryHeightContraints.constant = 50
                    balData = "\(balDueVal.currencyFormat)"
                    typeDue = "Balance Due"
                    
                    let responseMessages = ["amount": "\(balDueVal.currencyFormat)",
                        "type": "Balance Due",
                        "date": "---",
                        "isTipBtn": false] as [String : Any]
                    
                    arrTransactionData.add(responseMessages)
                }
            }
            
            //lblRefundSumarryType.text = typeDue
            //lblRefundSummaryAmount.text = balData
        }
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if orderInfoModelObj.admin_comments == ""{
                labelAdminComment.isHidden = true
                labelHeadAdminComment.isHidden = true
                viewAdminComment.isHidden = true
                adminViewHeightConstraint.constant = 0
                view.setNeedsLayout()
                view.setNeedsDisplay()
                view.layoutIfNeeded()
            }else{
                viewAdminComment.isHidden = false
                labelAdminComment.isHidden = false
                labelHeadAdminComment.isHidden = false
                labelAdminComment.text = orderInfoModelObj.admin_comments
                //                adminViewHeightConstraint.constant = 128
                //                view.setNeedsLayout()
                //                view.setNeedsDisplay()
            }
            
            if orderInfoModelObj.user_comments == ""{
                lblUserComment.isHidden = true
                lblHeadUserComment.isHidden = true
                viewUserComment.isHidden = true
                constantUserCommentHeight.constant = 0
                view.setNeedsLayout()
                view.setNeedsDisplay()
                view.layoutIfNeeded()
                
            }else{
                viewUserComment.isHidden = false
                lblUserComment.isHidden = false
                lblHeadUserComment.isHidden = false
                lblUserComment.text = orderInfoModelObj.user_comments
                //                adminViewHeightConstraint.constant = 128
                //                view.setNeedsLayout()
                //                view.setNeedsDisplay()
            }
        }else{
            if orderInfoModelObj.admin_comments == ""{
                labelAdminComment.isHidden = true
                labelHeadAdminComment.isHidden = true
                viewAdminComment.isHidden = true
                adminViewHeightConstraint.constant = 0
                view.setNeedsLayout()
                view.setNeedsDisplay()
                view.layoutIfNeeded()
                
            }else{
                viewAdminComment.isHidden = false
                labelAdminComment.isHidden = false
                labelHeadAdminComment.isHidden = false
                labelAdminComment.text = orderInfoModelObj.admin_comments
                //                adminViewHeightConstraint.constant = 128
                //                view.setNeedsLayout()
                //                view.setNeedsDisplay()
            }
            
            if orderInfoModelObj.user_comments == ""{
                lblUserComment.isHidden = true
                lblHeadUserComment.isHidden = true
                viewUserComment.isHidden = true
                constantUserCommentHeight.constant = 0
                view.setNeedsLayout()
                view.setNeedsDisplay()
                view.layoutIfNeeded()
                
            }else{
                viewUserComment.isHidden = false
                lblUserComment.isHidden = false
                lblHeadUserComment.isHidden = false
                lblUserComment.text = orderInfoModelObj.user_comments
                //                adminViewHeightConstraint.constant = 128
                //                view.setNeedsLayout()
                //                view.setNeedsDisplay()
            }
        }
        //saleLocationView.isHidden = saleLocationLabel.text == ""
        
        companyNameView.isHidden = companyNameLabel.text == ""
        if UI_USER_INTERFACE_IDIOM() == .phone {
            constantCompanyViewHeight.constant = companyNameView.isHidden == true ? 0 : 36
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if companyNameLabel.text == "" {
                lblCompanyHeader.text = "Sale Location:"
                companyNameLabel.text = orderInfoModelObj.saleLocation
            } else {
                lblCompanyHeader.text = "Company:"
            }
        }
       // if UI_USER_INTERFACE_IDIOM() == .pad {
        if orderInfoModelObj.agent == "" {
            self.vieeRepresentativeName.isHidden = true
            if UI_USER_INTERFACE_IDIOM() == .phone {
                constantRepresentativeViewHeight.constant = 0
            }
        }else {
            self.vieeRepresentativeName.isHidden = false
            if UI_USER_INTERFACE_IDIOM() == .phone {
                constantRepresentativeViewHeight.constant = 38
            }
            lblRepresentativeName.text = orderInfoModelObj.agent
        }
        if orderInfoModelObj.po_number == "" {
            self.viewPoNumber.isHidden = true
            if UI_USER_INTERFACE_IDIOM() == .phone {
                constantPoNumberViewHeight.constant = 0
            }
        }else {
            self.viewPoNumber.isHidden = false
            lblPoNumber.text = orderInfoModelObj.po_number
            if UI_USER_INTERFACE_IDIOM() == .phone {
                constantPoNumberViewHeight.constant = 39
            }
        }
        if orderInfoModelObj.title == "" {
            self.viewInvoiceTitle.isHidden = true
            if UI_USER_INTERFACE_IDIOM() == .phone {
                constantInvoiceViewHeight.constant = 0
            }
        }else {
            self.viewInvoiceTitle.isHidden = false
            if UI_USER_INTERFACE_IDIOM() == .phone {
                constantInvoiceViewHeight.constant = 39
            }
            lblInvoiceTitle.text = orderInfoModelObj.title
        }
        //}
        tableView.reloadData()
        var shipping = String()
        var billing = String()
        var custInfo = String()
        var custBillingInfo = String()
        
        let custfsname = orderInfoModelObj.str_first_name
        let custlsname = orderInfoModelObj.str_last_name
        let custphone = orderInfoModelObj.str_phone
        let custemail = orderInfoModelObj.str_email
        
        if custfsname.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            custInfo += custfsname
        }
        
        if custlsname.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            custInfo += " " + custlsname + "\n"
        }
        
        if custlsname == "" {
            custInfo += "\n"
        }
        
        if custphone.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            custInfo += formattedPhoneNumber(number: custphone) + "\n"
        }
        
        if custemail.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            custInfo += custemail
        }
        
        //MARK: Shipping
        
        //let name = orderInfoModelObj.shippingFirstName + " " + orderInfoModelObj.shippingLastName
        let fsname = orderInfoModelObj.shippingFirstName
        let lsname = orderInfoModelObj.shippingLastName
        let address1 = orderInfoModelObj.shippingAddressLine1
        let address2 = orderInfoModelObj.shippingAddressLine2
        let city = orderInfoModelObj.shippingCity
        let region = orderInfoModelObj.shippingRegion
        let country = orderInfoModelObj.shippingCountry
        let postalCode = orderInfoModelObj.shippingPostalCode
        let phone = orderInfoModelObj.shippingPhone
        let email = orderInfoModelObj.shippingEmail
        
        //        if name.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
        //            shipping += name + "\n"
        //        }
        
        
        if fsname.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            shipping += fsname + " "
        }
        if lsname.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            shipping += lsname + "\n"
        }
        //        if phone.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
        //            shipping += phone + "\n"
        //        }
        //        if email.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
        //            shipping += email + "\n"
        //        }
        
        if address2 == ""{
            if address1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                shipping += address1  +  "\n"
            }
        }else{
            if address1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                shipping +=  address1 +  "\n"
            }
        }
        
        if address2.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            shipping +=   address2 + "\n"
        }
        
        if city.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            shipping +=  city
        }
        
        if region.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            shipping += ", " + region
        }
        
        if country.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            shipping += ", " + country
        }
        
        if postalCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            shipping +=  ", " + formattedZIPCodeNumber(number: postalCode)
        }
        print("shipping info ",shipping)
        //MARK: cust Billing
        
        //let billingName = orderInfoModelObj.firstName + " " +  orderInfoModelObj.lastName
        let fbillingName = orderInfoModelObj.firstName
        let lbillingName = orderInfoModelObj.lastName
        let billingAddress1 = orderInfoModelObj.addressLine1
        let billingAddress2 = orderInfoModelObj.addressLine2
        let billingCity = orderInfoModelObj.city
        let billingRegion = orderInfoModelObj.region
        let billingCountry = orderInfoModelObj.country
        let billingPostalCode = orderInfoModelObj.postalCode
        let billingPhone = orderInfoModelObj.phone
        let billingEmail = orderInfoModelObj.email
        let companyName = orderInfoModelObj.companyName
        
        
        if fbillingName != "" && lbillingName != "" && billingEmail != "" && companyName != "" && billingPhone != "" && billingCountry != ""  {
            
            if billingEmail.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                custBillingInfo +=  billingEmail + "\n"
            }
            if billingPhone.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                custBillingInfo += phoneNumberFormateRemoveText(number: billingPhone) + "\n"
            }
            if companyName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                custBillingInfo += companyName + "\n"
            }
            
            
            
        }else{
            //*priya
            if fbillingName != "" && lbillingName != "" && billingPhone != ""{
                if billingPhone.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    custBillingInfo += phoneNumberFormateRemoveText(number: billingPhone) + "\n"
                }
            }
            //            if fbillingName != "" && billingPhone != "" {
            //                if billingPhone.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            //                    custBillingInfo += phoneNumberFormateRemoveText(number: billingPhone) + "\n"
            //                }
            //            }
            //*
            if fbillingName != "" && lbillingName != "" && billingCountry != "" && companyName != "" && billingPhone != "" {
                if billingPhone.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    custBillingInfo += phoneNumberFormateRemoveText(number: billingPhone) + "\n"
                }
                if companyName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    custBillingInfo += companyName + "\n"
                }
                
            }else{
                if fbillingName != "" && lbillingName != "" && billingCountry != ""   {
                    if billingEmail.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                        custBillingInfo +=  billingEmail + "\n"
                    }
                    //*priya
                    if fbillingName != "" && lbillingName != "" && companyName != ""{
                        if companyName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                            custBillingInfo += companyName + "\n"
                        }
                    }
                    
                    if fbillingName != "" && lbillingName != "" && billingCity != ""{
                        if billingCity.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                            custBillingInfo +=  billingCity + "\n"
                        }
                    }
                    if fbillingName != "" && lbillingName != "" && billingPostalCode  != ""{
                        if billingPostalCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                            custBillingInfo += formattedZIPCodeNumber(number: billingPostalCode) + "\n"
                        }
                    }
                    
                    if fbillingName != "" && lbillingName != "" && billingRegion  != ""{
                        if billingRegion.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                            custBillingInfo +=  billingRegion + "\n"
                        }
                    }
                    
                    //*
                }else{
                    if billingEmail != "" {
                        if billingEmail.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                            custBillingInfo +=  billingEmail + "\n"
                        }
                        if companyName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                            custBillingInfo += companyName + "\n"
                        }
                    }
                    if billingPhone != "" {
                        if billingPhone.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                            custBillingInfo += phoneNumberFormateRemoveText(number: billingPhone)
                        }
                    }
                }
            }
            
        }
        
        if billingAddress2 == ""{
            if billingAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                custBillingInfo += billingAddress1 +  "\n"
            }
        }else{
            if billingAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                custBillingInfo +=  billingAddress1 +  "\n"
            }
        }
        if billingAddress2.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            custBillingInfo +=   billingAddress2 +  "\n"
        }
        
        
        //        if lbillingName != "" && billingAddress1 != "" && billingAddress2 != "" && billingCity != "" {
        //            if billingCity.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
        //                custBillingInfo +=  billingCity + ", "
        //            }
        //        }
        
        if fbillingName != "" && lbillingName != "" && companyName != "" && billingPhone != "" && billingCountry != "" && billingCity != "" && billingRegion != "" && billingPostalCode != "" {
            if billingCity.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                custBillingInfo +=  billingCity + ", "
            }
            
            if billingRegion.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                custBillingInfo +=  billingRegion + ", "
            }
            
            if billingPostalCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                custBillingInfo += formattedZIPCodeNumber(number: billingPostalCode) + "\n"
            }
            //            if billingCountry.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            //                custBillingInfo +=   "," + billingCountry
            //            }
            print("custBillingInfo info ",custBillingInfo)
            /*
             // by priya
             if fbillingName != "" && lbillingName != ""  && billingCountry != "" && billingCity != ""  && billingPostalCode != "" {
             
             if companyName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
             custBillingInfo += companyName + "\n"
             }
             if billingCity.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
             custBillingInfo +=  billingCity + ", "
             }
             if billingPostalCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
             custBillingInfo += formattedZIPCodeNumber(number: billingPostalCode)
             }
             }
             if fbillingName != "" && companyName != "" && billingPostalCode != "" && billingRegion != ""{
             if companyName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
             custBillingInfo += companyName + "\n"
             }
             if billingRegion.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
             custBillingInfo +=  billingRegion + ", "
             }
             if billingPostalCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
             custBillingInfo += formattedZIPCodeNumber(number: billingPostalCode)
             }
             
             }
             if fbillingName != "" && lbillingName != "" && billingPhone != "" && billingCountry != ""  {
             
             if billingPhone.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
             custBillingInfo += phoneNumberFormateRemoveText(number: billingPhone) + "\n"
             }
             if billingCountry.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
             custBillingInfo +=   billingCountry
             }
             }
             */
            
        }
        else{
            
            if billingAddress1 != "" && billingAddress2 != "" && billingCity != "" && billingRegion != ""{
                //            if billingAddress2 == ""{
                //                if billingAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                //                    custBillingInfo += billingAddress1 +  "\n"
                //                }
                //            }else{
                //                if billingAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                //                    custBillingInfo +=  billingAddress1 +  "\n"
                //                }
                //            }
                //            if billingAddress2.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                //                custBillingInfo +=   billingAddress2 +  "\n"
                //            }
                if billingCity.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    custBillingInfo +=  billingCity + ", "
                }
                if billingRegion.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    custBillingInfo +=  billingRegion + ", "
                }
                if billingCountry.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    custBillingInfo +=   billingCountry
                }
            }
            
            
            //            if billingCountry != ""{
            //                self.viewAddressSeparator.isHidden = true
            //                self.addressBackView.isHidden = true
            //                self.orderAddressDetailView.isHidden = true
            //                self.view.layoutIfNeeded()
            //                self.view.setNeedsLayout()
            //                self.view.setNeedsDisplay()
            //
            //            }
            
            
        }
        
        
        //        if orderInfoModelObj.str_first_name == "" && orderInfoModelObj.str_last_name == "" && orderInfoModelObj.str_phone == "" && orderInfoModelObj.str_email == "" && orderInfoModelObj.shippingAddressLine1 == "" && orderInfoModelObj.shippingAddressLine1 == ""{
        //            self.viewAddressSeparator.isHidden = true
        //            self.addressBackView.isHidden = true
        //            self.orderAddressDetailView.isHidden = true
        //
        //        }else {
        //            self.addressBackView.isHidden = false
        //            self.orderAddressDetailView.isHidden = false
        //            self.view.layoutIfNeeded()
        //            self.view.setNeedsLayout()
        //            self.view.setNeedsDisplay()
        //        }
        
        
        //Mark Billing info....
        
        if fbillingName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            billing += fbillingName + " "
        }
        if lbillingName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            billing += lbillingName + "\n"
        }
        
        if billingAddress2 == ""{
            if billingAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                billing += billingAddress1 +  "\n"
            }
        }else{
            if billingAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                billing +=  billingAddress1 +  "\n"
            }
        }
        
        if billingAddress2.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            billing +=   billingAddress2 + "\n"
        }
        
        if billingCity.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            billing += billingCity
        }
        
        if billingRegion.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            billing += ", " + billingRegion
        }
        
        if billingCountry.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            billing += ", " + billingCountry
        }
        
        if billingPostalCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            billing += ", " +  formattedZIPCodeNumber(number: billingPostalCode)
        }
        
        print("billing info ",billing)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            //totalLabelConstraint.constant = orderInfoModelObj.discount <= 0 ? 80 : 100
            totalAmountLabel.text = orderInfoModelObj.total.currencyFormat
            //viewRefundSummaryTypeConstraint.constant = orderInfoModelObj.discount <= 0 ? 130 : 150
        }
        labelUserId.text = "#\(orderInfoModelObj.userID)"
        self.addressBackView.isHidden = true
        self.orderAddressDetailView.isHidden = true
        if UI_USER_INTERFACE_IDIOM() == .pad {
            stackViewScheduledDate.isHidden = orderInfoModelObj.scheduled_date == ""
        }else{
            view_scheduleDate.isHidden = orderInfoModelObj.scheduled_date == ""
        }
        lblScheduledDate.text = orderInfoModelObj.scheduled_date
        //        if UI_USER_INTERFACE_IDIOM() == .pad {
        //            if orderInfoModelObj.isBillingSame == 0{
        //                self.addressBackView.isHidden = false
        //                self.orderAddressDetailView.isHidden = false
        //                self.shippingHeadLabel.isHidden = false
        //                self.tvAddressShipping.isHidden = false
        //
        //                self.billingHeadLabel.isHidden = false
        //                self.tvAddressBilling.isHidden = false
        //                self.viewAddressSeparator.isHidden = false
        //                self.viewAddressSeparatorOne.isHidden = false
        //
        //                self.CustomerHeadLabel.isHidden = false
        //                self.tvAddressCustomer.isHidden = false
        //                self.viewAddressSeparatorOne.isHidden = false
        //                self.stackViewCust.isHidden = false
        //                self.CustomerHeadLabel.text = " \(fbillingName.capitalized + " " + lbillingName.capitalized)"
        //                self.tvAddressCustomer.text = (custBillingInfo == "" || custBillingInfo == " \n") ? "" : custBillingInfo
        //                self.tvAddressShipping.text = (shipping == "" || shipping == " \n") ? "" : shipping //" \nUS, "
        //                self.tvAddressBilling.text = (billing == "" || billing == " \n") ? "" : billing
        //                self.tvAddressCustomer.sizeToFit()
        //                self.tvAddressShipping.sizeToFit()
        //                self.tvAddressShipping.sizeToFit()
        //
        //            }else{
        //                self.billingHeadLabel.isHidden = true
        //                self.tvAddressBilling.isHidden = true
        //                self.shippingHeadLabel.isHidden = true
        //                self.tvAddressShipping.isHidden = true
        //                self.viewAddressSeparator.isHidden = false
        //                self.orderAddressDetailView.isHidden = false
        //                self.addressBackView.isHidden = false
        //                self.CustomerHeadLabel.isHidden = false
        //                self.tvAddressCustomer.isHidden = false
        //                self.viewAddressSeparatorOne.isHidden = true
        //                self.viewAddressSeparator.isHidden = true
        //                self.stackViewCust.isHidden = false
        //                self.CustomerHeadLabel.numberOfLines = 0
        //                //self.customerHeadWidthConstraint.constant = 300
        //                self.CustomerHeadLabel.text = " \(fbillingName.capitalized + " " + lbillingName.capitalized)"
        //                self.tvAddressCustomer.text = (custBillingInfo == "" || custBillingInfo == " \n") ? "" : custBillingInfo
        //                self.tvAddressCustomer.sizeToFit()
        //                self.tvAddressShipping.sizeToFit()
        //                self.tvAddressShipping.sizeToFit()
        //
        //            }
        //
        //            if self.tvAddressShipping.text == "" &&   self.tvAddressCustomer.text == "" &&  self.tvAddressBilling.text == "" && self.CustomerHeadLabel.text == ""{
        //                self.viewAddressSeparator.isHidden = true
        //                self.addressBackView.isHidden = true
        //                self.orderAddressDetailView.isHidden = true
        //
        //                self.view.layoutIfNeeded()
        //                self.view.setNeedsLayout()
        //                self.view.setNeedsDisplay()
        //            }
        //
        //        }else{
        //            if orderInfoModelObj.isBillingSame == 0{
        //                self.addressBackView.isHidden = false
        //                self.orderAddressDetailView.isHidden = false
        //                self.CustomerHeadLabel.isHidden = false
        ////                self.CustomerAddressLabel.isHidden = false
        //                self.viewAddressSeparatorOne.isHidden = false
        //                //                self.stackViewCust.isHidden = false
        //                self.viewAddressSeparator.isHidden = false
        //                self.CustomerAddressLabel.numberOfLines = 0
        //                self.shippingAddressLabel.numberOfLines = 0
        //                self.billingAddressLabel.numberOfLines = 0
        //                self.CustomerHeadLabel.text =  fbillingName.capitalized + " " + lbillingName.capitalized
        //                self.CustomerAddressLabel.text = (custBillingInfo == "" || custBillingInfo == " \n") ? "" : custBillingInfo
        //                self.shippingAddressLabel.text = (shipping == "" || shipping == " \n") ? "" : shipping //" \nUS, "
        //                self.billingAddressLabel.text = (billing == "" || billing == " \n") ? "" : billing
        //
        //            }else{
        //                self.shippingHeadLabel.isHidden = true
        //                self.shippingAddressLabel.isHidden = true
        //                self.viewAddressSeparator.isHidden = true
        //                self.orderAddressDetailView.isHidden = false
        //                self.addressBackView.isHidden = false
        //                self.billingHeadLabel.isHidden = true
        //                self.billingAddressLabel.isHidden = true
        //                self.CustomerAddressLabel.numberOfLines = 0
        //                self.CustomerHeadLabel.isHidden = false
        //                self.CustomerAddressLabel.isHidden = false
        //                self.viewAddressSeparatorOne.isHidden = false
        //                self.CustomerHeadLabel.text =  fbillingName.capitalized + " " + lbillingName.capitalized
        //                self.CustomerAddressLabel.text = (custBillingInfo == "" || custBillingInfo == " \n") ? "" : custBillingInfo
        //            }
        //
        //
        //            if self.shippingAddressLabel.text == "" &&   self.CustomerAddressLabel.text == "" &&  self.billingAddressLabel.text == ""{
        //                self.viewAddressSeparator.isHidden = true
        //                self.addressBackView.isHidden = true
        //                self.orderAddressDetailView.isHidden = true
        //
        //                self.view.layoutIfNeeded()
        //                self.view.setNeedsLayout()
        //                self.view.setNeedsDisplay()
        //            }
        //        }
        //
        //
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if orderInfoModelObj.isBillingSame == 0{
                
                if orderInfoModelObj.str_first_name == "" && orderInfoModelObj.str_last_name == "" && orderInfoModelObj.str_phone == "" && orderInfoModelObj.str_email == ""{
                    self.viewAddressSeparator.isHidden = true
                    self.orderAddressDetailView.isHidden = true
                    self.addressBackView.isHidden = true
                    self.CustomerHeadLabel.isHidden = true
                    self.tvAddressCustomer.isHidden = true
                    self.viewAddressSeparatorOne.isHidden = true
                    self.stackViewCust.isHidden = true
                }else {
                    self.addressBackView.isHidden = false
                    self.orderAddressDetailView.isHidden = false
                    self.CustomerHeadLabel.isHidden = false
                    self.tvAddressCustomer.isHidden = false
                    self.viewAddressSeparatorOne.isHidden = false
                    self.stackViewCust.isHidden = false
                    self.CustomerHeadLabel.text = " \(fbillingName.capitalized + " " + lbillingName.capitalized)"
                    self.tvAddressCustomer.text = (custBillingInfo == "" || custBillingInfo == " \n") ? "" : custBillingInfo
                }
                
                if orderInfoModelObj.shippingAddressLine1 == "" {
                    self.viewAddressSeparatorOne.isHidden = true
                    self.viewAddressSeparator.isHidden = true
                    self.addressBackView.isHidden = true
                    self.shippingHeadLabel.isHidden = true
                    self.tvAddressShipping.isHidden = true
                } else {
                    self.viewAddressSeparatorOne.isHidden = false
                    self.addressBackView.isHidden = false
                    self.shippingHeadLabel.isHidden = false
                    self.tvAddressShipping.isHidden = false
                    self.tvAddressShipping.text = (shipping == "" || shipping == " \n") ? "" : shipping //" \nUS, "
                    
                }
                if orderInfoModelObj.addressLine1 == "" {
                    self.viewAddressSeparator.isHidden = true
                    self.viewAddressSeparatorOne.isHidden = true
                    self.addressBackView.isHidden = true
                    self.billingHeadLabel.isHidden = true
                    self.tvAddressBilling.isHidden = true
                    self.viewAddressSeparator.isHidden = true
                } else {
                    self.billingHeadLabel.isHidden = false
                    self.tvAddressBilling.isHidden = false
                    self.viewAddressSeparator.isHidden = false
                    self.viewAddressSeparatorOne.isHidden = false
                    self.tvAddressBilling.text = (billing == "" || billing == " \n") ? "" : billing
                }
                if orderInfoModelObj.str_first_name == "" && orderInfoModelObj.str_last_name == "" && orderInfoModelObj.str_phone == "" && orderInfoModelObj.str_email == "" && orderInfoModelObj.shippingAddressLine1 == "" && orderInfoModelObj.shippingAddressLine1 == ""{
                    self.viewAddressSeparator.isHidden = true
                    self.addressBackView.isHidden = true
                    self.orderAddressDetailView.isHidden = true
                    
                }else {
                    self.addressBackView.isHidden = false
                    self.orderAddressDetailView.isHidden = false
                    self.view.layoutIfNeeded()
                    self.view.setNeedsLayout()
                    self.view.setNeedsDisplay()
                }
            }else{
                if orderInfoModelObj.str_first_name == "" && orderInfoModelObj.str_last_name == "" && orderInfoModelObj.str_phone == "" && orderInfoModelObj.str_email == ""{
                    self.viewAddressSeparator.isHidden = true
                    self.orderAddressDetailView.isHidden = true
                    self.addressBackView.isHidden = true
                    self.CustomerHeadLabel.isHidden = true
                    self.tvAddressCustomer.isHidden = true
                    self.viewAddressSeparatorOne.isHidden = true
                    self.stackViewCust.isHidden = true
                    
                    if billingAddress1 != ""  && billingAddress2 != "" && billingCity != "" && billingRegion != ""{
                        self.addressBackView.isHidden = false
                        self.orderAddressDetailView.isHidden = false
                        self.CustomerHeadLabel.isHidden = false
                        self.tvAddressCustomer.isHidden = false
                        self.stackViewCust.isHidden = false
                        self.tvAddressBilling.isHidden = true
                        self.tvAddressShipping.isHidden = true
                        self.billingHeadLabel.isHidden = true
                        self.shippingHeadLabel.isHidden = true
                        self.CustomerHeadLabel.text = " \(fbillingName.capitalized + " " + lbillingName.capitalized)"
                        self.tvAddressCustomer.text = (custBillingInfo == "" || custBillingInfo == " \n") ? "" : custBillingInfo
                    }
                    
                }else {
                    self.addressBackView.isHidden = false
                    self.orderAddressDetailView.isHidden = false
                    self.CustomerHeadLabel.isHidden = false
                    self.tvAddressCustomer.isHidden = false
                    self.viewAddressSeparatorOne.isHidden = true
                    self.stackViewCust.isHidden = false
                    self.tvAddressShipping.isHidden = true
                    self.shippingHeadLabel.isHidden = true
                    self.tvAddressBilling.isHidden = true
                    self.billingHeadLabel.isHidden = true
                    self.viewAddressSeparator.isHidden = true
                    self.CustomerHeadLabel.text = " \(fbillingName.capitalized + " " + lbillingName.capitalized)"
                    self.tvAddressCustomer.text = (custBillingInfo == "" || custBillingInfo == " \n") ? "" : custBillingInfo
                    
                }
            }
        }
        else{
            if orderInfoModelObj.isBillingSame == 0{
                if orderInfoModelObj.str_first_name == "" && orderInfoModelObj.str_last_name == "" && orderInfoModelObj.str_phone == "" && orderInfoModelObj.str_email == ""{
                    self.viewAddressSeparator.isHidden = true
                    self.orderAddressDetailView.isHidden = true
                    self.addressBackView.isHidden = true
                    self.CustomerHeadLabel.isHidden = true
                    self.CustomerAddressLabel.isHidden = true
                    self.viewAddressSeparatorOne.isHidden = true
                    //                self.stackViewCust.isHidden = true
                }else {
                    self.addressBackView.isHidden = false
                    self.orderAddressDetailView.isHidden = false
                    self.CustomerHeadLabel.isHidden = false
                    self.CustomerAddressLabel.isHidden = false
                    self.viewAddressSeparatorOne.isHidden = false
                    //                self.stackViewCust.isHidden = false
                    self.CustomerAddressLabel.numberOfLines = 0
                    self.CustomerAddressLabel.text = (custBillingInfo == "" || custBillingInfo == " \n") ? "" : custBillingInfo
                }
                
                if orderInfoModelObj.shippingAddressLine1 == "" {
                    self.viewAddressSeparator.isHidden = true
                    self.addressBackView.isHidden = true
                    self.shippingHeadLabel.isHidden = true
                    self.shippingAddressLabel.isHidden = true
                } else {
                    self.viewAddressSeparatorOne.isHidden = false
                    self.addressBackView.isHidden = false
                    self.shippingHeadLabel.isHidden = false
                    self.shippingAddressLabel.isHidden = false
                    self.shippingAddressLabel.numberOfLines = 0
                    self.shippingAddressLabel.text = (shipping == "" || shipping == " \n") ? "N/A" : shipping //" \nUS, "
                    
                }
                if orderInfoModelObj.addressLine1 == "" {
                    self.viewAddressSeparator.isHidden = true
                    self.addressBackView.isHidden = true
                    self.billingHeadLabel.isHidden = true
                    self.billingAddressLabel.isHidden = true
                    self.viewAddressSeparator.isHidden = true
                } else {
                    self.billingHeadLabel.isHidden = false
                    self.billingAddressLabel.isHidden = false
                    self.billingAddressLabel.numberOfLines = 0
                    self.viewAddressSeparator.isHidden = false
                    self.billingAddressLabel.text = (billing == "" || billing == " \n") ? "N/A" : billing
                }
                if orderInfoModelObj.str_first_name == "" && orderInfoModelObj.str_last_name == "" && orderInfoModelObj.str_phone == "" && orderInfoModelObj.str_email == "" && orderInfoModelObj.shippingAddressLine1 == "" && orderInfoModelObj.shippingAddressLine1 == ""{
                    self.viewAddressSeparator.isHidden = true
                    self.addressBackView.isHidden = true
                    self.orderAddressDetailView.isHidden = true
                    
                }else {
                    self.addressBackView.isHidden = false
                    self.orderAddressDetailView.isHidden = false
                    
                }
            }else{
                if orderInfoModelObj.str_first_name == "" && orderInfoModelObj.str_last_name == "" && orderInfoModelObj.str_phone == "" && orderInfoModelObj.str_email == ""{
                    self.viewAddressSeparator.isHidden = true
                    self.orderAddressDetailView.isHidden = true
                    self.addressBackView.isHidden = true
                    self.CustomerHeadLabel.isHidden = true
                    self.billingAddressLabel.isHidden = true
                    self.viewAddressSeparatorOne.isHidden = true
                    //self.stackViewCust.isHidden = true
                    
                    if billingAddress1 != ""  && billingAddress2 != "" && billingCity != "" && billingRegion != ""{
                        self.addressBackView.isHidden = false
                        self.orderAddressDetailView.isHidden = false
                        self.CustomerHeadLabel.isHidden = false
                        self.viewAddressSeparator.isHidden = false
                        self.CustomerAddressLabel.isHidden = false
                        //self.stackViewCust.isHidden = false
                        self.billingAddressLabel.isHidden = true
                        self.shippingAddressLabel.isHidden = true
                        self.billingHeadLabel.isHidden = true
                        self.shippingHeadLabel.isHidden = true
                        self.CustomerAddressLabel.numberOfLines = 0
                        self.CustomerHeadLabel.text = "\(fbillingName.capitalized + " " + lbillingName.capitalized)"
                        self.CustomerAddressLabel.text = (custBillingInfo == "" || custBillingInfo == " \n") ? "" : custBillingInfo
                    }
                    
                }else {
                    self.addressBackView.isHidden = false
                    self.orderAddressDetailView.isHidden = false
                    self.CustomerHeadLabel.isHidden = false
                    self.CustomerAddressLabel.isHidden = false
                    self.viewAddressSeparatorOne.isHidden = true
                    self.viewAddressSeparator.isHidden = false
                    // self.stackViewCust.isHidden = false
                    self.shippingAddressLabel.isHidden = true
                    self.shippingHeadLabel.isHidden = true
                    self.billingAddressLabel.isHidden = true
                    self.billingHeadLabel.isHidden = true
                    self.CustomerAddressLabel.numberOfLines = 0
                    self.CustomerHeadLabel.text = "\(fbillingName.capitalized + " " + lbillingName.capitalized)"
                    self.CustomerAddressLabel.text = (custBillingInfo == "" || custBillingInfo == " \n") ? "" : custBillingInfo
                    
                }
            }
        }
        
        if versionOb < 4 {
            //self.refundButton.isHidden = true
            //self.btnClear.isHidden = true
            if UI_USER_INTERFACE_IDIOM() == .pad {
                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 90)
            }else{
                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 70)
            }
        }else{
            //self.refundButton.isHidden = false
            //self.btnClear.isHidden = false
            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 0)

//            if UI_USER_INTERFACE_IDIOM() == .phone {
//                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 70)
//            }else{
//                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 0)
//            }
            //tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund) ? 40 : 250))
        }
        
        if versionOb < 4 {
            //refundButton.setTitle("Refund", for: .normal)
            //refundExchangeButtonView.isHidden = false
            //btnClear.isHidden = false
            //refundButton.isHidden = false
            //refundButton.isUserInteractionEnabled = true
//            if orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund {
//                refundButton.isHidden = true
//            }
            
//            if orderInfoModelObj.showRefundButton == "true" {
//                refundButton.isHidden = false
//            } else {
//                refundButton.isHidden = true
//            }

        } else {
            
            if orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund {
                //btnClear.isHidden = true
                //refundButton.isHidden = true
            }
            
//            refundExchangeButtonView.isHidden = orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund
        }
        if orderInfoModelObj.showPayNow == "true" {
            btnPayNow.isHidden = false
            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 0)
        } else {
//            let balDue = orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")
//            if balDue != "" {
//                //let jk = Float(hh)
//                let balDueVal : Double = Double(balDue)!
//                if balDueVal > 0 {
//                    btnPayNow.isHidden = false
//                }else{
//                    btnPayNow.isHidden = true
//                }
//            }else{
                btnPayNow.isHidden = true
           // }
           
            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 0)

        }
        
        self.tableView.reloadData()
        
        //        tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund) ? 40 : 100))
        //tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund) ? 40 : 100))
        
        
        var billingAddress = String()
        var shippingAddress = String()
        var customerAddress = String()
        var customerInformation = String()
        
        let fbillingCustName = orderInfoModelObj.firstName
        let lbillingCustName = orderInfoModelObj.lastName
        let billingCustAddress1 = orderInfoModelObj.addressLine1
        let billingCustAddress2 = orderInfoModelObj.addressLine2
        let billingCustCity = orderInfoModelObj.city
        let billingCustRegion = orderInfoModelObj.region
        let billingCustCountry = orderInfoModelObj.country
        let billingCustPostalCode = orderInfoModelObj.postalCode
        let billingCustPhone = orderInfoModelObj.phone
        let billingCustEmail = orderInfoModelObj.email
        let companyCustName = orderInfoModelObj.companyName
        
        
        let shippingfsname = orderInfoModelObj.shippingFirstName
        let shippinglsname = orderInfoModelObj.shippingLastName
        let shippingaddress1 = orderInfoModelObj.shippingAddressLine1
        let shippingaddress2 = orderInfoModelObj.shippingAddressLine2
        let shippingcity = orderInfoModelObj.shippingCity
        let shippingregion = orderInfoModelObj.shippingRegion
        let shippingcountry = orderInfoModelObj.shippingCountry
        let shippingpostalCode = orderInfoModelObj.shippingPostalCode
        //        let shippingphone = orderInfoModelObj.shippingPhone
        //        let shippingemail = orderInfoModelObj.shippingEmail
        
        
        
        // customer billing
        
        if fbillingCustName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            billingAddress +=   fbillingCustName + " "
        }
        
        if lbillingCustName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            billingAddress +=   lbillingCustName
        }
        
        if billingCustAddress2 == ""{
            if billingAddress != ""{
                if billingCustAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    billingAddress += "\n" + billingCustAddress1
                }
            }else{
                if billingCustAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    billingAddress += billingCustAddress1
                }
            }
        }else{
            if billingCustAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                if billingAddress != ""{
                    billingAddress +=  "\n" + billingCustAddress1
                }else{
                    billingAddress +=  billingCustAddress1
                }
            }
        }
        
        if billingCustAddress2.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if billingAddress != ""{
                billingAddress +=   "\n" + billingCustAddress2
            }else{
                billingAddress +=   billingCustAddress2
            }
        }
        
        if billingCustCity.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if billingAddress != ""{
                billingAddress += "\n" + billingCustCity
            }else{
                billingAddress += billingCustCity
            }
        }
        
        if billingCustRegion.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if billingAddress != ""{
                billingAddress += ", " + billingCustRegion
            }else{
                billingAddress +=  billingCustRegion
            }
        }
        if billingCustPostalCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if billingAddress != ""{
                billingAddress += ", " + formattedZIPCodeNumber(number: billingCustPostalCode)
            }else{
                billingAddress +=  formattedZIPCodeNumber(number: billingCustPostalCode)
            }
        }
        if billingCustAddress1 != "" && billingCustCity != "" && billingCustRegion != "" && billingCustPostalCode != "" {
            if billingCustCountry.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                if billingAddress != ""{
                    billingAddress += "\n" + billingCustCountry
                }else{
                    billingAddress += billingCustCountry
                }
            }
        }
        if billingCustAddress1 != ""{
            if billingCustCountry.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                if billingAddress != ""{
                    billingAddress += "\n" + billingCustCountry
                }else{
                    billingAddress += billingCustCountry
                }
            }
        }
        
        
        
        // customer shipping
        
        if shippingfsname.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            shippingAddress +=   shippingfsname + " "
        }
        
        if shippinglsname.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            shippingAddress +=   shippinglsname
        }
        
        if shippingaddress2 == ""{
            if shippingaddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                if shippingAddress != ""{
                    shippingAddress += "\n" + shippingaddress1
                }else{
                    shippingAddress += shippingaddress1
                }
            }
        }else{
            if shippingaddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                if shippingAddress != ""{
                    shippingAddress +=  "\n" + shippingaddress1
                }else{
                    shippingAddress +=  shippingaddress1
                }
            }
        }
        
        if shippingaddress2.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if shippingAddress != ""{
                shippingAddress +=   "\n" + shippingaddress2
            }else{
                shippingAddress +=   shippingaddress2
            }
        }
        
        if shippingcity.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if shippingAddress != ""{
                shippingAddress += "\n" + shippingcity
            }else{
                shippingAddress +=  shippingcity
            }
        } else {
            if shippingAddress != ""{
                shippingAddress += "\n"
            }
        }
        
        if shippingregion.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            
            if shippingAddress.last == "\n" {
                if shippingAddress != ""{
                    shippingAddress += shippingregion
                }else{
                    shippingAddress +=  shippingregion
                }
            } else {
                if shippingAddress != ""{
                    shippingAddress += ", " + shippingregion
                }else{
                    shippingAddress +=  shippingregion
                }
            }
        }
        if shippingpostalCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if shippingAddress.last == "\n" {
                print("enterrrrr")
                if shippingAddress != ""{
                    shippingAddress += formattedZIPCodeNumber(number: shippingpostalCode)
                }else{
                    shippingAddress +=  formattedZIPCodeNumber(number: shippingpostalCode)
                }
            } else {
                print("enterrrrrout")
                if shippingAddress != ""{
                    if shippingregion.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                        shippingAddress += ", " + formattedZIPCodeNumber(number: shippingpostalCode)
                    }else{
                        shippingAddress += ", " + formattedZIPCodeNumber(number: shippingpostalCode)
                    }
                    
                }else{
                    shippingAddress +=  formattedZIPCodeNumber(number: shippingpostalCode)
                }
            }
            
        }
        //        if shippingaddress1 != "" && shippingcity != "" && shippingregion != "" && shippingpostalCode != "" {
        //            if shippingcountry.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
        //                if shippingAddress != ""{
        //                    shippingAddress += "\n" + shippingcountry
        //                }else{
        //                    shippingAddress +=  shippingcountry
        //                }
        //            }
        //        }
        
        if shippingaddress1 != ""{
            if shippingcountry.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                if shippingAddress.last == "\n" {
                    if shippingAddress != ""{
                        shippingAddress +=  shippingcountry
                    }else{
                        shippingAddress +=  shippingcountry
                    }
                } else {
                    if shippingAddress != ""{
                        shippingAddress += "\n" + shippingcountry
                    }else{
                        shippingAddress +=  shippingcountry
                    }
                }
            }
        }
        
        // customer information
        if billingCustPhone.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if customerAddress != ""{
                customerAddress +=  formattedPhoneNumber(number: billingCustPhone)
            }else{
                customerAddress +=  formattedPhoneNumber(number: billingCustPhone)
            }
            
        }
        
        if billingCustEmail.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if customerAddress != ""{
                customerAddress +=  "\n" + billingCustEmail
            }else{
                customerAddress +=  billingCustEmail
            }
        }
        
        if companyCustName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if customerAddress != ""{
                customerAddress += "\n" + companyCustName
            }else{
                customerAddress +=  companyCustName
            }
        }
        
        if billingCustAddress2 == ""{
            if billingCustAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                if customerAddress != ""{
                    customerAddress += "\n" + billingCustAddress1
                }else{
                    customerAddress += billingCustAddress1
                }
            }
        }else{
            if billingCustAddress1.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                if customerAddress != ""{
                    customerAddress += "\n" + billingCustAddress1
                }else{
                    customerAddress +=  billingCustAddress1
                }
            }
        }
        
        if billingCustAddress2.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if customerAddress != ""{
                customerAddress +=  "\n" + billingCustAddress2
            }else{
                customerAddress +=   billingCustAddress2
            }
        }
        
        if billingCustCity.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if customerAddress != ""{
                customerAddress += "\n" + billingCustCity
            }else{
                customerAddress +=  billingCustCity
            }
        } else {
            if customerAddress != ""{
                customerAddress += "\n"
            }
        }
        
        if billingCustRegion.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if customerAddress.last == "\n" {
                if customerAddress != ""{
                    customerAddress +=  billingCustRegion
                }else{
                    customerAddress +=  billingCustRegion
                }
            } else {
                if customerAddress != ""{
                    customerAddress += ", " + billingCustRegion
                }else{
                    customerAddress +=  billingCustRegion
                }
            }
            
            
        }
        
        if billingCustPostalCode.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            
            if customerAddress.last == "\n" {
                if customerAddress != ""{
                    customerAddress += formattedZIPCodeNumber(number: billingCustPostalCode)
                }else{
                    customerAddress +=  formattedZIPCodeNumber(number: billingCustPostalCode)
                }
            } else {
                if customerAddress != ""{
                    if billingCustRegion.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                        customerAddress += ", " + formattedZIPCodeNumber(number: billingCustPostalCode)
                    }else{
                        customerAddress += ", " + formattedZIPCodeNumber(number: billingCustPostalCode)
                    }
                    
                    
                }else{
                    customerAddress +=  formattedZIPCodeNumber(number: billingCustPostalCode)
                }
            }
            
        }
        
        //        if billingCustAddress1 != "" && billingCustCity != "" && billingCustRegion != "" && billingCustPostalCode != "" {
        //            if billingCustCountry.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
        //                if customerAddress != ""{
        //                    customerAddress += "\n" + billingCustCountry
        //                }else{
        //                    customerAddress +=  billingCustCountry
        //                }
        //            }
        //        }
        if billingCustAddress1 != ""{
            if billingCustCountry.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                
                if customerAddress.last == "\n" {
                    if customerAddress != ""{
                        customerAddress +=  billingCustCountry
                    }else{
                        customerAddress +=  billingCustCountry
                    }
                } else {
                    if customerAddress != ""{
                        customerAddress += "\n" + billingCustCountry
                    }else{
                        customerAddress +=  billingCustCountry
                    }
                }
                
                
            }
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            tvAddressBilling.isHidden = true
            billingHeadLabel.isHidden = true
            viewAddressSeparator.isHidden = true
            
            
            if fbillingCustName == "" && lbillingCustName == ""{
                CustomerHeadLabel.isHidden = true
            }else{
                CustomerHeadLabel.isHidden = false
                self.CustomerHeadLabel.text = " \(fbillingCustName.capitalized + " " + lbillingCustName.capitalized)"
            }
            
            //            if billingAddress == "" {
            //                tvAddressBilling.isHidden = true
            //                billingHeadLabel.isHidden = true
            //                viewAddressSeparator.isHidden = true
            //                viewAddressSeparatorOne.isHidden = true
            //            }
            
            if shippingAddress == "" {
                tvAddressShipping.isHidden = true
                shippingHeadLabel.isHidden = true
                viewAddressSeparator.isHidden = true
                viewAddressSeparatorOne.isHidden = true
            }
            
            if billingAddress == "" && shippingAddress == "" && customerAddress == ""{
                orderAddressDetailView.isHidden = true
                addressBackView.isHidden = true
            }
            
            if orderInfoModelObj.isBillingSame == 0 {
                //                if billingAddress == "" {
                //                    tvAddressBilling.isHidden = true
                //                    billingHeadLabel.isHidden = true
                //                    viewAddressSeparator.isHidden = true
                //                    viewAddressSeparatorOne.isHidden = true
                //                } else {
                //                    tvAddressBilling.isHidden = false
                //                    billingHeadLabel.isHidden = false
                //                    viewAddressSeparator.isHidden = false
                //                    viewAddressSeparatorOne.isHidden = false
                //                    tvAddressCustomer.text = customerAddress
                //                    tvAddressBilling.text = billingAddress
                //                }
                
                if shippingAddress == "" {
                    tvAddressShipping.isHidden = true
                    shippingHeadLabel.isHidden = true
                    // viewAddressSeparator.isHidden = true
                    viewAddressSeparatorOne.isHidden = true
                } else {
                    tvAddressShipping.isHidden = false
                    shippingHeadLabel.isHidden = false
                    tvAddressCustomer.isHidden = false
                    
                    //viewAddressSeparator.isHidden = false
                    viewAddressSeparatorOne.isHidden = false
                    tvAddressCustomer.text = customerAddress
                    // tvAddressBilling.text = billingAddress
                    tvAddressShipping.text = shippingAddress
                    orderAddressDetailView.isHidden = false
                    addressBackView.isHidden = false
                    stackViewCust.isHidden = false
                }
                if shippingAddress != "" && billingAddress == "" && customerAddress == ""{
                    tvAddressShipping.isHidden = false
                    shippingHeadLabel.isHidden = false
                    // tvAddressBilling.isHidden = true
                    // billingHeadLabel.isHidden = true
                    tvAddressCustomer.isHidden = true
                    CustomerHeadLabel.isHidden = true
                    stackViewCust.isHidden = true
                    // viewAddressSeparator.isHidden = true
                    viewAddressSeparatorOne.isHidden = true
                    tvAddressShipping.text = shippingAddress
                    
                }
                
                
                
            } else {
                
                if billingAddress == "" {
                    //   tvAddressBilling.isHidden = true
                    //   billingHeadLabel.isHidden = true
                    //  viewAddressSeparator.isHidden = true
                    viewAddressSeparatorOne.isHidden = true
                    if customerAddress != ""{
                        stackViewCust.isHidden = false
                        tvAddressBilling.isHidden = true
                        tvAddressCustomer.isHidden = false
                        tvAddressShipping.isHidden = true
                        billingHeadLabel.isHidden = true
                        shippingHeadLabel.isHidden = true
                        viewAddressSeparator.isHidden = true
                        viewAddressSeparatorOne.isHidden = true
                        tvAddressCustomer.text = customerAddress
                        orderAddressDetailView.isHidden = false
                        addressBackView.isHidden = false
                    }
                } else {
                    stackViewCust.isHidden = false
                    tvAddressBilling.isHidden = true
                    tvAddressCustomer.isHidden = false
                    tvAddressShipping.isHidden = true
                    billingHeadLabel.isHidden = true
                    shippingHeadLabel.isHidden = true
                    viewAddressSeparator.isHidden = true
                    viewAddressSeparatorOne.isHidden = true
                    tvAddressCustomer.text = customerAddress
                    orderAddressDetailView.isHidden = false
                    addressBackView.isHidden = false
                }
            }
        }else{
            
            billingAddressLabel.isHidden = true
            billingHeadLabel.isHidden = true
            viewAddressSeparator.isHidden = true
            
            if fbillingCustName == "" && lbillingCustName == ""{
                CustomerHeadLabel.isHidden = true
            }else{
                 CustomerHeadLabel.isHidden = false
                self.CustomerHeadLabel.text = "\(fbillingCustName.capitalized + " " + lbillingCustName.capitalized)"
            }
            
            if billingAddress == "" {
                billingAddressLabel.isHidden = true
                billingHeadLabel.isHidden = true
                viewAddressSeparator.isHidden = true
                viewAddressSeparatorOne.isHidden = true
            }
            
            if shippingAddress == "" {
                shippingAddressLabel.isHidden = true
                shippingHeadLabel.isHidden = true
                viewAddressSeparator.isHidden = true
                viewAddressSeparatorOne.isHidden = true
            }
            
            if billingAddress == "" && shippingAddress == "" && customerAddress == ""{
                orderAddressDetailView.isHidden = true
                addressBackView.isHidden = true
            }
            
            if orderInfoModelObj.isBillingSame == 0 {
                if billingAddress == "" {
                    billingAddressLabel.isHidden = true
                    billingHeadLabel.isHidden = true
                    viewAddressSeparator.isHidden = true
                    viewAddressSeparatorOne.isHidden = true
                } else {
                    //                    billingAddressLabel.isHidden = false
                    //                    billingHeadLabel.isHidden = false
                    viewAddressSeparator.isHidden = false
                    viewAddressSeparatorOne.isHidden = false
                    CustomerAddressLabel.numberOfLines = 0
                    //      billingAddressLabel.numberOfLines = 0
                    CustomerAddressLabel.text = customerAddress
                    //   billingAddressLabel.text = billingAddress
                }
                
                if shippingAddress == "" {
                    shippingAddressLabel.isHidden = true
                    shippingHeadLabel.isHidden = true
                    viewAddressSeparator.isHidden = true
                    viewAddressSeparatorOne.isHidden = true
                } else {
                    shippingAddressLabel.isHidden = false
                    shippingHeadLabel.isHidden = false
                    CustomerAddressLabel.isHidden = false
                    viewAddressSeparator.isHidden = false
                    viewAddressSeparatorOne.isHidden = false
                    CustomerAddressLabel.numberOfLines = 0
                    //      billingAddressLabel.numberOfLines = 0
                    shippingAddressLabel.numberOfLines = 0
                    CustomerAddressLabel.text = customerAddress
                    //       billingAddressLabel.text = billingAddress
                    shippingAddressLabel.text = shippingAddress
                    orderAddressDetailView.isHidden = false
                    addressBackView.isHidden = false
                    //stackViewCust.isHidden = false
                }
                if shippingAddress != "" && billingAddress == "" && customerAddress == ""{
                    shippingAddressLabel.isHidden = false
                    shippingHeadLabel.isHidden = false
                    billingAddressLabel.isHidden = true
                    billingHeadLabel.isHidden = true
                    CustomerAddressLabel.isHidden = true
                    CustomerHeadLabel.isHidden = true
                    // stackViewCust.isHidden = true
                    viewAddressSeparator.isHidden = true
                    viewAddressSeparatorOne.isHidden = true
                    shippingAddressLabel.numberOfLines = 0
                    shippingAddressLabel.text = shippingAddress
                    
                }
            } else {
                if billingAddress == "" {
                    billingAddressLabel.isHidden = true
                    billingHeadLabel.isHidden = true
                    viewAddressSeparator.isHidden = true
                    viewAddressSeparatorOne.isHidden = true
                    if customerAddress != ""{
                        billingAddressLabel.isHidden = true
                        CustomerAddressLabel.isHidden = false
                        shippingAddressLabel.isHidden = true
                        billingHeadLabel.isHidden = true
                        shippingHeadLabel.isHidden = true
                        viewAddressSeparator.isHidden = true
                        viewAddressSeparatorOne.isHidden = true
                        CustomerAddressLabel.numberOfLines = 0
                        CustomerAddressLabel.text = customerAddress
                        orderAddressDetailView.isHidden = false
                        addressBackView.isHidden = false
                    }
                    
                } else {
                    // stackViewCust.isHidden = false
                    billingAddressLabel.isHidden = true
                    CustomerAddressLabel.isHidden = false
                    shippingAddressLabel.isHidden = true
                    billingHeadLabel.isHidden = true
                    shippingHeadLabel.isHidden = true
                    viewAddressSeparator.isHidden = true
                    viewAddressSeparatorOne.isHidden = true
                    CustomerAddressLabel.numberOfLines = 0
                    CustomerAddressLabel.text = customerAddress
                    orderAddressDetailView.isHidden = false
                    addressBackView.isHidden = false
                }
            }
            
        }
    }
    
    private func handlePrinterAction() {
        if BluetoothPrinter.sharedInstance.isConnected() || DataManager.isStarPrinterConnected
        {
            let str_footerText = receiptModel.card_agreement_text + "<br>" + receiptModel.refund_policy_text + "<br>" + receiptModel.footer_text
            
            var add = ""
            if self.receiptModel.city == "" && self.receiptModel.region == "" && self.receiptModel.postal_code == "" {
                add = ""
            } else if self.receiptModel.city != "" && (self.receiptModel.region != "" || self.receiptModel.postal_code != "") {
                add = ","
            } else if self.receiptModel.city == "" && (self.receiptModel.region != "" || self.receiptModel.postal_code != ""){
                add = ""
            }
            
            var orderAddress = ""
            
            if self.receiptModel.address_line1 != "" {
                orderAddress = self.receiptModel.address_line1
            }
            
            if self.receiptModel.address1 != "" {
                if orderAddress == "" {
                    orderAddress =  self.receiptModel.address1
                } else {
                    orderAddress =  orderAddress +  "\n" + self.receiptModel.address1
                }
                
            }
            
            if self.receiptModel.address2 != "" {
                if orderAddress == "" {
                    orderAddress =  self.receiptModel.address2
                } else {
                    orderAddress =  orderAddress +  "\n" + self.receiptModel.address2
                }
            }
            
            let order: JSONDictionary = ["title" : self.receiptModel.packing_slip_title ,
                                         "address" : "\(orderAddress)" ,
                "addressDetail" : "\(self.receiptModel.city)\(add)\(self.receiptModel.region) \(self.receiptModel.postal_code)",
                "date" : self.receiptModel.date_added ,
                "orderid": self.receiptModel.order_id ,
                "products" : self.receiptModel.array_ReceiptContent ,
                "total" : self.receiptModel.total ,
                "tip" : self.receiptModel.tip ,
                "subtotal" : self.receiptModel.sub_total ,
                "discount" : self.receiptModel.discount ,
                "shipping" : self.receiptModel.shipping ,
                "tax" : self.receiptModel.tax ,
                "footertext" : str_footerText ,
                "card_agreement_text" : receiptModel.card_agreement_text,
                "refund_policy_text" : receiptModel.refund_policy_text,
                "footer_text" : receiptModel.footer_text,
                "transactiontype" : self.receiptModel.transaction_type,
                "paymentmode" : self.receiptModel.payment_type,
                "order_time" : self.receiptModel.order_time,
                "sale_location" : self.receiptModel.sale_location,
                "bar_code" : self.receiptModel.bar_code,
                "card_details" : self.receiptModel.array_ReceiptCardContent,
                "entry_method" : self.receiptModel.entry_method,
                "card_number" : self.receiptModel.card_number,
                "approval_code" : self.receiptModel.approval_code,
                "coupon_code" : self.receiptModel.coupon_code,
                "change_due" : self.receiptModel.change_due,
                "signature" : self.receiptModel.signature,
                "card_holder_name" : self.receiptModel.card_holder_name,
                "card_holder_label" : self.receiptModel.card_holder_label,
                "company_name" : self.receiptModel.company_name,
                "city" : self.receiptModel.city,
                "region" :self.receiptModel.region,
                "customer_service_phone" :self.receiptModel.customer_service_phone,
                "customer_service_email" :self.receiptModel.customer_service_email,
                "postal_code" :self.receiptModel.postal_code,
                "header_text" :self.receiptModel.header_text,
                "balance_due" :self.receiptModel.balance_Due,
                "payment_status" :self.receiptModel.payment_status,
                "source" :self.receiptModel.source,
                "show_company_address" : self.receiptModel.show_company_address,
                "show_all_final_transactions" :self.receiptModel.show_all_final_transactions,
                "print_all_transactions" :self.receiptModel.print_all_transactions,
                "extra_merchant_copy" :self.receiptModel.extra_merchant_copy,
                "showtipline_status" : self.receiptModel.showtipline_status,
                "total_refund_amount" : self.receiptModel.total_refund_amount,
                "notes" : self.receiptModel.notes,
                "isNotes" : self.receiptModel.isNotes,
                "lowvaluesig_status" : self.receiptModel.lowvaluesig_status,
                "ACCT" : self.receiptModel.ACCT,
                 "AID" : self.receiptModel.AID,
                 "TC" : self.receiptModel.TC,
                 "AppName" : self.receiptModel.Appname,
                 "lowvaluesig_status_setting_flag" : self.receiptModel.lowvaluesig_status_setting_flag,
                "is_signature_placeholder": self.receiptModel.is_signature_placeholder,
                "qr_code": self.receiptModel.qr_code,
                "qr_code_data": self.receiptModel.qr_code_data,
                "hide_qr_code":self.receiptModel.hide_qr_code

            ]
            
            BluetoothPrinter.sharedInstance.printContent(dict:order)
        }
        else if DataManager.isStarPrinterConnected
        {
            
            //            self.showAlert(message: "No Printer Found.")
            //  {
            //   {
//            let commands: Data
//
//            let emulation: StarIoExtEmulation = LoadStarPrinter.getEmulation()
//            print(emulation)
//
//            let width: Int = LoadStarPrinter.getSelectedPaperSize().rawValue
//
//            let paperSize: PaperSizeIndex = LoadStarPrinter.getSelectedPaperSize()
//            let language: LanguageIndex = LanguageIndex.english//LoadStarPrinter.getSelectedLanguage()
//            let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(language,
//                                                                                              paperSizeIndex: paperSize)
//            commands = PrinterFunctions.createTextReceiptApiData(emulation,utf8: true)
//
//            //self.blind = true
//
//            //  if #available(iOS 13.0, *) {
//            Communication.sendCommandsForPrintReDirection(commands,
//                                                          timeout: 10000) { (communicationResultArray) in
//                                                            // self.blind = false
//
//                                                            var message: String = ""
//
//                                                            for i in 0..<communicationResultArray.count {
//                                                                if i == 0 {
//                                                                    message += "[Destination]\n"
//                                                                }
//                                                                else {
//                                                                    message += "[Backup]\n"
//                                                                }
//
//                                                                message += "Port Name: " + communicationResultArray[i].0 + "\n"
//
//                                                                switch communicationResultArray[i].1.result {
//                                                                case .success:
//                                                                    message += "----> Success!\n\n";
//                                                                case .errorOpenPort:
//                                                                    message += "----> Fail to openPort\n\n";
//                                                                case .errorBeginCheckedBlock:
//                                                                    message += "----> Printer is offline (beginCheckedBlock)\n\n";
//                                                                case .errorEndCheckedBlock:
//                                                                    message += "----> Printer is offline (endCheckedBlock)\n\n";
//                                                                case .errorReadPort:
//                                                                    message += "----> Read port error (readPort)\n\n";
//                                                                case .errorWritePort:
//                                                                    message += "----> Write port error (writePort)\n\n";
//                                                                default:
//                                                                    message += "----> Unknown error\n\n";
//                                                                }
//                                                            }
//
//
//
//                                                            //                                                                    self.showSimpleAlert(title: "Communication Result",
//                                                            //                                                                                         message: message,
//                                                            //                                                                                         buttonTitle: "OK",
//                                                            //                                                                                         buttonStyle: .cancel)
//                                                            appDelegate.showToast(message: message)
//            }
//            //            } else {
//            //                // Fallback on earlier versions
//            //                 appDelegate.showToast(message: "#available(iOS 13.0, *)")
//            //            }
//            //  }
//            // }
//
//            if  HomeVM.shared.receiptModel.extra_merchant_copy == "true" {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    let commands: Data
//
//                    let emulation: StarIoExtEmulation = LoadStarPrinter.getEmulation()
//                    print(emulation)
//
//                    let width: Int = LoadStarPrinter.getSelectedPaperSize().rawValue
//
//                    let paperSize: PaperSizeIndex = LoadStarPrinter.getSelectedPaperSize()
//                    let language: LanguageIndex = LanguageIndex.english//LoadStarPrinter.getSelectedLanguage()
//                    let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(language,
//                                                                                                      paperSizeIndex: paperSize)
//                    commands = PrinterFunctions.createTextReceiptApiData(emulation,utf8: true)
//
//                    //self.blind = true
//
//                    //  if #available(iOS 13.0, *) {
//                    Communication.sendCommandsForPrintReDirection(commands,
//                                                                  timeout: 10000) { (communicationResultArray) in
//                                                                    // self.blind = false
//
//                                                                    var message: String = ""
//
//                                                                    for i in 0..<communicationResultArray.count {
//                                                                        if i == 0 {
//                                                                            message += "[Destination]\n"
//                                                                        }
//                                                                        else {
//                                                                            message += "[Backup]\n"
//                                                                        }
//
//                                                                        message += "Port Name: " + communicationResultArray[i].0 + "\n"
//
//                                                                        switch communicationResultArray[i].1.result {
//                                                                        case .success:
//                                                                            message += "----> Success!\n\n";
//                                                                        case .errorOpenPort:
//                                                                            message += "----> Fail to openPort\n\n";
//                                                                        case .errorBeginCheckedBlock:
//                                                                            message += "----> Printer is offline (beginCheckedBlock)\n\n";
//                                                                        case .errorEndCheckedBlock:
//                                                                            message += "----> Printer is offline (endCheckedBlock)\n\n";
//                                                                        case .errorReadPort:
//                                                                            message += "----> Read port error (readPort)\n\n";
//                                                                        case .errorWritePort:
//                                                                            message += "----> Write port error (writePort)\n\n";
//                                                                        default:
//                                                                            message += "----> Unknown error\n\n";
//                                                                        }
//                                                                    }
//
//
//
//                                                                    //                                                                    self.showSimpleAlert(title: "Communication Result",
//                                                                    //                                                                                         message: message,
//                                                                    //                                                                                         buttonTitle: "OK",
//                                                                    //                                                                                         buttonStyle: .cancel)
//                                                                    appDelegate.showToast(message: message)
//                    }
//                }
//            }
//
//            //appDelegate.showToast(message: "No Printer Found.")
        } else {
            appDelegate.showToast(message: "No Printer Found.")
        }
    }
    
    private func reloadTableData(animate: Bool = false) {
        DispatchQueue.main.async {
            if animate {
                self.scrollView.alpha = 0
            }
            //Reload Table
            self.tableView.reloadData {
                self.tableView.contentOffset = .zero
                if !self.isOrderSummery {
                    self.tableViewheight.constant = self.view.bounds.size.height - (UI_USER_INTERFACE_IDIOM() == .pad ? 120 : 190)
                }else {
                    self.tableView.layoutIfNeeded()
                    self.tableViewheight.constant = self.tableView.contentSize.height
                }
                self.scrollView.scrollToTop()
                if animate {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.scrollView.alpha = 1.0
                    })
                }
            }
            //Update Shadow
            if self.isLandscape {
                if !self.isOrderSummery {
                    //Remove Shadow
                    self.tableBackView.layer.shadowColor = UIColor.clear.cgColor
                    self.tableBackView.layer.shadowOffset = CGSize.zero
                    self.tableBackView.layer.shadowOpacity = 0
                    self.tableBackView.layer.shadowRadius = 0
                }else {
                    //Add Shadow
                    self.tableBackView.layer.shadowColor = UIColor.darkGray.cgColor
                    self.tableBackView.layer.shadowOffset = CGSize.zero
                    self.tableBackView.layer.shadowOpacity = 0.3
                    self.tableBackView.layer.shadowRadius = 2
                }
            }else {
                //Remove Shadow
                self.tableBackView.layer.shadowColor = UIColor.clear.cgColor
                self.tableBackView.layer.shadowOffset = CGSize.zero
                self.tableBackView.layer.shadowOpacity = 0
                self.tableBackView.layer.shadowRadius = 0
            }
            self.updateView()
            
        }
    }
    
    private func getProductData() -> (ProductsModel) {
        
        let obj =  ProductsModel()
        
        for product in orderInfoModelObj.productsArray {
            
            obj.variationsData = product.variationsData
            
            self.catAndProductDelegate?.didAddNewProduct?(data: obj, productDetail: obj)  //DDDD
            
        }
        
        return obj
    }
    
    private func getUpdatedData() -> (Bool, Bool, Bool, Bool, OrderInfoModel) { //1. Exchange 2. Refund 3. Transactions 4. Partial Amount 5. Updated Obj
        
        var isExchangeProductFound = false
        var isRefundProductFound = false
        var isTransactiontFound = false
        var isPartialAmountFound = false
        
        if DataManager.isCaptureButton {
            let customerObj = [
                "country": orderInfoModelObj.cust_country,
                "billingCountry": orderInfoModelObj.country,
                "shippingCountry":orderInfoModelObj.shippingCountry,
                "coupan": "",
                "str_first_name":orderInfoModelObj.cust_first_name,
                "str_last_name":orderInfoModelObj.cust_last_name,
                "str_address":orderInfoModelObj.cust_address1,
                "str_bpid":orderInfoModelObj.bpId,
                "str_city":orderInfoModelObj.cust_city,
                "str_order_id":orderInfoModelObj.orderID,
                "str_email":orderInfoModelObj.str_email,
                "str_userID":orderInfoModelObj.userID,
                "str_phone":orderInfoModelObj.str_phone,
                "str_region":orderInfoModelObj.cust_region,
                "str_address2":orderInfoModelObj.cust_address2,
                "str_Billingcity":orderInfoModelObj.city,
                "str_postal_code":orderInfoModelObj.postalCode,
                "str_Billingphone":orderInfoModelObj.phone,
                "str_Billingaddress":orderInfoModelObj.addressLine1,
                "str_Billingaddress2":orderInfoModelObj.addressLine2,
                "str_Billingregion":orderInfoModelObj.region,
                "str_Billingpostal_code":orderInfoModelObj.postalCode,
                "shippingPhone": orderInfoModelObj.shippingPhone,
                "str_company": orderInfoModelObj.companyName,
                "shippingAddress" : orderInfoModelObj.shippingAddressLine2,
                "shippingAddress2": orderInfoModelObj.shippingAddressLine1,
                "shippingCity": orderInfoModelObj.shippingCity,
                "shippingRegion" : orderInfoModelObj.shippingRegion,
                "shippingPostalCode": orderInfoModelObj.shippingPostalCode,
                "billing_first_name":orderInfoModelObj.firstName,
                "billing_last_name":orderInfoModelObj.lastName,
                "user_custom_tax":orderInfoModelObj.tax,
                "shipping_first_name":orderInfoModelObj.shippingFirstName,
                "shipping_last_name":orderInfoModelObj.shippingLastName,
                "shippingEmail": orderInfoModelObj.shippingEmail,
                "str_Billingemail": orderInfoModelObj.email,
//                "office_phone":orderInfoModelObj.str_office_phone,
//                "contact_source": orderInfoModelObj.str_contact_source,
                "customer_status": orderInfoModelObj.customer_status] as [String : Any]
            
            DataManager.customerObj = customerObj
        }
        
        let obj = OrderInfoModel()
        obj.firstName = orderInfoModelObj.firstName
        obj.lastName = orderInfoModelObj.lastName
        obj.addressLine1 = orderInfoModelObj.addressLine1
        obj.addressLine2 = orderInfoModelObj.addressLine2
        obj.city = orderInfoModelObj.city
        obj.region = orderInfoModelObj.region
        obj.country = orderInfoModelObj.country
        obj.postalCode = orderInfoModelObj.postalCode
        obj.email = orderInfoModelObj.email
        obj.phone = orderInfoModelObj.phone
        
        obj.shippingFirstName = orderInfoModelObj.shippingFirstName
        obj.shippingLastName = orderInfoModelObj.shippingLastName
        obj.shippingAddressLine1 = orderInfoModelObj.shippingAddressLine1
        obj.shippingAddressLine2 = orderInfoModelObj.shippingAddressLine2
        obj.shippingCity = orderInfoModelObj.shippingCity
        obj.shippingRegion = orderInfoModelObj.shippingRegion
        obj.shippingCountry = orderInfoModelObj.shippingCountry
        obj.shippingPostalCode = orderInfoModelObj.shippingPostalCode
        obj.shippingEmail = orderInfoModelObj.shippingEmail
        obj.shippingPhone = orderInfoModelObj.shippingPhone
        
        obj.orderDate = orderInfoModelObj.orderDate
        obj.orderID = orderInfoModelObj.orderID
        obj.merchantId = orderInfoModelObj.merchantId
        obj.transactionType = orderInfoModelObj.transactionType
        obj.cardHolderName = orderInfoModelObj.cardHolderName
        obj.saleLocation = orderInfoModelObj.saleLocation
        obj.companyName = orderInfoModelObj.companyName
        obj.invoiceterms = orderInfoModelObj.invoiceterms
        obj.invoiceDueDate = orderInfoModelObj.invoiceDueDate
        obj.appName = orderInfoModelObj.appName
        obj.approvalCode = orderInfoModelObj.approvalCode
        obj.entryMethod = orderInfoModelObj.entryMethod
        obj.userID = orderInfoModelObj.userID
        obj.bpId = orderInfoModelObj.bpId
        obj.paymentMethod = orderInfoModelObj.paymentMethod
        obj.googleReceipturl = orderInfoModelObj.googleReceipturl
        obj.showSubscriptionsCancel = orderInfoModelObj.showSubscriptionsCancel
        
        obj.couponCode = orderInfoModelObj.couponCode
        obj.couponPrice = orderInfoModelObj.couponPrice
        obj.couponId = orderInfoModelObj.couponId
        obj.couponTitle = orderInfoModelObj.couponTitle
        
        obj.total = orderInfoModelObj.total
        obj.subTotal = orderInfoModelObj.subTotal
        obj.discount = orderInfoModelObj.discount
        obj.shipping = orderInfoModelObj.shipping
        obj.tax = orderInfoModelObj.tax
        obj.customTax = orderInfoModelObj.customTax
        obj.tip = orderInfoModelObj.tip
        obj.isOrderRefund = orderInfoModelObj.isOrderRefund
        obj.isshippingRefundSelected = orderInfoModelObj.isshippingRefundSelected
        obj.isTipRefundSelected = orderInfoModelObj.isTipRefundSelected
        obj.showRefundTip = orderInfoModelObj.showRefundTip
        obj.showRefundShipping = orderInfoModelObj.showRefundShipping
        
        obj.isSubscription = orderInfoModelObj.isSubscription
        obj.isProductReturn = orderInfoModelObj.isProductReturn
        obj.refundPaymentTypeArray = orderInfoModelObj.refundPaymentTypeArray
        obj.cardDetail = orderInfoModelObj.cardDetail
        obj.Exchange_Payment_Method_arr = orderInfoModelObj.Exchange_Payment_Method_arr
        obj.refundTransactionList = orderInfoModelObj.refundTransactionList
        obj.transactionArray = orderInfoModelObj.transactionArray
        DataManager.defaultTaxID = orderInfoModelObj.customTax
        
        if DataManager.isCaptureButton {
            obj.productsArray = orderInfoModelObj.productsArray
            //DataManager.selectedPayment = obj.paymentMethod
        }
        
        for arrpax in orderInfoModelObj.paxDeviceListRefund{
            obj.paxDeviceListRefund.append(arrpax)
        }
        
        for transaction in orderInfoModelObj.transactionArray {
            if transaction.isPartialRefundSelected || transaction.isFullRefundSelected || transaction.isVoidSelected {
                if transaction.isPartialRefundSelected && transaction.partialAmount != "" {
                    isPartialAmountFound = true
                }
                if DataManager.isshippingRefundOnly {
                    obj.transactionArray.append(transaction)
                }
                isTransactiontFound = true
            }
        }
        
        for product in orderInfoModelObj.productsArray {
            if product.isExchangeSelected {
                obj.productsArray.append(product)
                isExchangeProductFound = true
            }
        }
        
        if !isExchangeProductFound {
            for product in orderInfoModelObj.productsArray {
                if product.isRefundSelected {
                    obj.productsArray.append(product)
                    isRefundProductFound = true
                }
            }
        }else {
            for product in orderInfoModelObj.productsArray {
                if product.isRefundSelected {
                    obj.productsArray.append(product)
                    isRefundProductFound = false
                }
            }
        }
        
        return (isExchangeProductFound, isRefundProductFound, isTransactiontFound, isPartialAmountFound, obj)
    }
    
    
    func ClearbButtonColorChange() {
        
        var isCheck = false
        
        for i in 0..<orderInfoModelObj.productsArray.count {
            if orderInfoModelObj.productsArray[i].isExchangeSelected {
                print(orderInfoModelObj.productsArray[i].isExchangeSelected)
                isCheck = true
            }
            
            if orderInfoModelObj.productsArray[i].isRefundSelected {
                print(orderInfoModelObj.productsArray[i].isRefundSelected)
                isCheck = true
            }
        }
        
        for i in 0..<orderInfoModelObj.transactionArray.count {
            if orderInfoModelObj.transactionArray[i].isFullRefundSelected {
                print(orderInfoModelObj.transactionArray[i].isFullRefundSelected)
                isCheck = true
            }
            
            if orderInfoModelObj.transactionArray[i].isPartialRefundSelected {
                print(orderInfoModelObj.transactionArray[i].isPartialRefundSelected)
                isCheck = true
            }
            
            if orderInfoModelObj.transactionArray[i].isVoidSelected {
                print(orderInfoModelObj.transactionArray[i].isVoidSelected)
                isCheck = true
            }
        }
        
    }
    
    func callAPIToGetIngenicoLogin() {
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
                        
                        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
                            MainSocketManager.shared.onOrderProcessignloader(paymentType: "Ingenico")
                        }
                if DataManager.isIngenicoConnected {
                    if self.getIsDeviceConnected() {
                        //                ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                        //                                                   apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                        //                                                   clientVersion: ClientVersion)
                        if DataManager.isIngenicPaymentMethodCancelAndMessage {
                            Indicator.sharedInstance.showIndicatorGif(true)
                        } else {
                            Indicator.sharedInstance.showIndicatorGif(false)
                        }
                        self.loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password, isSearch: false)
                        
                    } else {
                        self.ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                            apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                            clientVersion: self.ClientVersion)
                            
                        //if communicationSegment.selectedSegmentIndex == 1 {
                        // doSearching()
                        
                        //self.ingenico.paymentDevice.setDeviceType(RUADeviceTypeRP45BT)
                        self.ingenico.paymentDevice.setDeviceType(RUADeviceType(rawValue: DataManager.RUADeviceTypeValueDataSet))
                        
                        self.ingenico.paymentDevice.search(self)
                    }
                } else {
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
            else {
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
    
    //MARK: IBAction
    
    @IBAction func btnCustomerPickup_action(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CustomerPickupVC") as! CustomerPickupVC
        controller.modalPresentationStyle = .overCurrentContext
        controller.orderInfoModelObj = orderInfoModelObj
        controller.delegate = self
        controller.customerPickupDelegete = self
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    @IBAction func actionUserId(_ sender: Any) {
        
        // Note : -- this code is right, only disable some time
        
        //        if UI_USER_INTERFACE_IDIOM() == .pad {
        //            userDetailDelegate?.didgetUserOrderId!(with: orderID)
        //            self.userContainer.isHidden = false
        //        }else{
        //
        //            appDelegate.strIphoneApi = false
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            let vc = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        //            vc.orderIdStr = orderID
        //            self.present(vc, animated: true, completion: nil)
        //
        //        }
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        self.view.endEditing(true)
//        self.refundButton.isUserInteractionEnabled = false
//        self.refundButton.alpha = 1.0
//        btnClear.backgroundColor = UIColor.gray
//        refundButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
//        btnClear.borderColor = UIColor.gray
//        refundButton.borderColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
//        btnClear.isUserInteractionEnabled = false
        resetAllValues()
        reloadTableData()
        
        ClearbButtonColorChange()
    }
    
    @IBAction func btnPayNow_Action(_ sender: UIButton) {

        if DataManager.isOpenPayNowInApp {
            sender.backgroundColor =  #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                sender.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            }
            appDelegate.isOpenToOrderHistory = true // for payment done by payment screen 30/09/2022
            callAPItoGetOrderInfo()
        } else {
            appDelegate.inputViewController?.Alert(mesaage: "URL SEND")
            let Url = self.orderInfoModelObj.payNowUrl
            let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            if let url:NSURL = NSURL(string: str!) {
                UIApplication.shared.open(url as URL)
            }
        }
//        let Url = self.orderInfoModelObj.payNowUrl
//        let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//        if let url:NSURL = NSURL(string: str!) {
//            UIApplication.shared.open(url as URL)
//        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        if let vcs = self.navigationController?.viewControllers {
            for vc in vcs {
                if vc.isKind(of: OrdersViewController.self) {
                    self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func refundButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if versionOb < 4 {
            let dataChange = self.orderInfoModelObj.refundUrl.replacingOccurrences(of: "userID", with: "custID")
            let Url = dataChange
            let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            if let url:NSURL = NSURL(string: str!) {
                UIApplication.shared.open(url as URL)
            }
            return
        }
        
        DataManager.isCaptureButton = false
        
        if (self.revealViewController().frontViewPosition != FrontViewPositionLeft) {
            self.revealViewController()?.revealToggle(animated: true)
        }
        let updatedData = getUpdatedData()
        
        //        if !updatedData.0 && !updatedData.1 {
        //            self.showAlert(message: "Please select an item.")
        //            return
        //        }
        
        if !updatedData.0 && !updatedData.2 {
//            self.showAlert(message: "Please select refund type.")
            appDelegate.showToast(message: "Please select refund type.")
            return
        }
        
        let refundselectedArray = orderInfoModelObj.transactionArray.filter({$0.isPartialRefundSelected == true})
        let refundselectedAmountArray = orderInfoModelObj.transactionArray.filter({$0.isPartialRefundSelected == true && $0.partialAmount != ""})
        
        if !updatedData.3 && refundselectedArray.count > 0 {
//            self.showAlert(message: "Please enter partial amount.")
            appDelegate.showToast(message: "Please enter partial amount.")
            return
        }
        
        if updatedData.3 && refundselectedArray.count != refundselectedAmountArray.count {
//            self.showAlert(message: "Please enter partial amount.")
            appDelegate.showToast(message: "Please enter partial amount.")
            return
        }
        
        
        if updatedData.3 && refundselectedArray.count > 0 {
            
            var totalRefundAmount = Double()
            
            for product in orderInfoModelObj.productsArray {
                if product.isRefundSelected || product.isExchangeSelected {
                    totalRefundAmount += product.refundAmount
                }
            }
            totalRefundAmount = Double(totalRefundAmount.roundToTwoDecimal) ?? 0
            
            for transaction in orderInfoModelObj.transactionArray {
                if transaction.isPartialRefundSelected {
                    if (Double(transaction.partialAmount) ?? 0) < totalRefundAmount {
//                        self.showAlert(message: "Transaction amount must be greater than or equal to refunded amount.")
                        appDelegate.showToast(message: "Transaction amount must be greater than or equal to refunded amount.")
                        return
                    }
                    
                    if (Double(transaction.partialAmount) ?? 0) > transaction.availableRefundAmount {
//                        self.showAlert(message: "Transaction amount must be less than or equal to refunded amount $\(transaction.availableRefundAmount)")
                        appDelegate.showToast(message: "Transaction amount must be less than or equal to refunded amount $\(transaction.availableRefundAmount)")
                        return
                    }
                }
            }
            
        }
        
        if updatedData.3 && refundselectedArray.count > 0 {
            for transaction in orderInfoModelObj.transactionArray {
                if transaction.isPartialRefundSelected && (Double(transaction.partialAmount) ?? 0) > transaction.availableRefundAmount {
//                    self.showAlert(message: "Transaction amount must be less than or equal to refunded amount $\(transaction.availableRefundAmount)")
                    appDelegate.showToast(message: "Transaction amount must be less than or equal to refunded amount $\(transaction.availableRefundAmount)")
                    return
                }
            }
        }
        
        
        if updatedData.0 {
//            showAlert(message: "Feature is not available for this release.")
            appDelegate.showToast(message: "Feature is not available for this release.")
            //code comment for exchage bcoz work in going on. so that we add dialog // by sudama 14-12-2019
            /*PaymentsViewController.paymentDetailDict.removeAll()
             
             if let cardDetail = orderInfoModelObj.cardDetail {
             var number = cardDetail.number ?? ""
             
             if number.count == 4 {
             number = "************" + number
             }
             
             PaymentsViewController.paymentDetailDict["key"] = "CREDIT"
             PaymentsViewController.paymentDetailDict["data"] = ["cardnumber":number,"mm":cardDetail.month, "yyyy":cardDetail.year, "cvv": ""]
             }
             
             let dict: JSONDictionary = ["data":updatedData.4]
             
             if UI_USER_INTERFACE_IDIOM() == .pad {
             appDelegate.str_Refundvalue = "refund"
             self.orderInfoDelegate?.didMoveToCartScreen?(with: dict)
             } else {
             appDelegate.str_Refundvalue = "refund"
             self.refundOrder = dict
             self.performSegue(withIdentifier: "cart", sender: nil)
             }*/
            return
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let dict: JSONDictionary = ["show":true, "data":updatedData.4]
            self.orderInfoDelegate?.didUpdateRefundScreen?(with: dict)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RefundViewController") as! RefundViewController
            vc.orderInfoModelObj = updatedData.4
            vc.orderInfoDelegate = self
            //self.present(vc, animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func actionCapture(_ sender: Any) {
        
        
        //self.showAlert(message: "Capture under Developement")
        
        DataManager.isCaptureButton = true
        appDelegate.str_Refundvalue = "refund"
        print(orderInfoModelObj.transactionArray)
        print(OrderInfoModel.self)
        
        let update = getUpdatedData()
        
        let dict: JSONDictionary = ["data":update.4]
        
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.orderInfoDelegate?.didMoveToCartScreen?(with: dict)
        } else {
            
            //self.showAlert(message: "Capture under Developement")
            
            self.refundOrder = dict
            self.performSegue(withIdentifier: "cart", sender: nil)
        }
        
    }
    
    
    @IBAction func receiptButtonAction(_ sender: Any) {
        self.blurView.isHidden = true
        blurView.backgroundColor = UIColor.white
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let text: UIAlertAction = UIAlertAction(title: "Text", style: .default) { action -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.blurView.alpha = 0
            }) { (_) in
                self.blurView.isHidden = true
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
            controller.isReceiptText = true
            controller.orderID = self.orderID
            controller.selectedButonType = .text
            controller.userPhone = self.orderInfoModelObj.str_phone
            controller.userEmail = self.orderInfoModelObj.email
            controller.strGooglePrinterURL = self.orderInfoModelObj.googleReceipturl
            if #available(iOS 13.0, *) {
                controller.modalPresentationStyle = .fullScreen
            }
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
        
        let email: UIAlertAction = UIAlertAction(title: "Email", style: .default) { action -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.blurView.alpha = 0
            }) { (_) in
                self.blurView.isHidden = true
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
            controller.isReceiptEmail = true
            controller.orderID = self.orderID
            controller.selectedButonType = .email
            controller.userPhone = self.orderInfoModelObj.phone
            controller.strGooglePrinterURL = self.orderInfoModelObj.googleReceipturl
            controller.userEmail = self.orderInfoModelObj.email
            if #available(iOS 13.0, *) {
                controller.modalPresentationStyle = .fullScreen
            }
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
        
        let print: UIAlertAction = UIAlertAction(title: "Print", style: .default) { action -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.blurView.alpha = 0
            }) { (_) in
                self.blurView.isHidden = true
            }
            
            if !DataManager.isBluetoothPrinter && !DataManager.isGooglePrinter {
//                self.showAlert(message: "Please first enable the printer from settings")
                appDelegate.showToast(message: "Please first enable the printer from settings")
                return
            }
            
            if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter {
                
                
                self.callAPItoGetReceiptContent()
            }
            
//            if DataManager.isGooglePrinter {
//                let Url = self.orderInfoModelObj.googleReceipturl
//                //let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//                if let url:NSURL = NSURL(string: Url) {
//                    UIApplication.shared.open(url as URL)
//                }
//            }
        }
        let full_ReceiptPrint: UIAlertAction = UIAlertAction(title: "Full Receipt", style: .default) { action -> Void in
            UIView.animate(withDuration: 0.2, animations: {
                self.blurView.alpha = 0
            }) { (_) in
                self.blurView.isHidden = true
            }
            //https://perfectworld.syncpos.biz/packing_slip/?&ai_skin=full_page&full=y&order_id=1202
            let Url = "\(BaseURL)/packing_slip/?&ai_skin=full_page&full=y&order_id=\(self.orderInfoModelObj.orderID)"
            let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            if let url:NSURL = NSURL(string: str!) {
                UIApplication.shared.open(url as URL)
            }
        }
        var cancelAction = UIAlertAction()
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            cancelAction.setValue(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), forKey: "titleTextColor")
            cancelAction = UIAlertAction(title: "Cancel", style: .default) { action -> Void in
                UIView.animate(withDuration: 0.2, animations: {
                    self.blurView.alpha = 0
                }) { (_) in
                    self.blurView.isHidden = true
                }
            }
        }
        else
        {
            cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                UIView.animate(withDuration: 0.2, animations: {
                    self.blurView.alpha = 0
                }) { (_) in
                    self.blurView.isHidden = true
                }
            }
        }
        
        actionSheetController.view.tintColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        actionSheetController.addAction(text)
        actionSheetController.addAction(email)
        
        if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter {
            actionSheetController.addAction(print)
        }
        if DataManager.showFullRecieptOptionForPrint == "true" {
            actionSheetController.addAction(full_ReceiptPrint)
        }
        actionSheetController.addAction(cancelAction)
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            if let popoverController = actionSheetController.popoverPresentationController
            {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.frame.size.height, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.delegate = self
        }
        
        DispatchQueue.main.async {
            self.present(actionSheetController, animated: true, completion: {
                self.blurView.alpha = 0
                self.blurView.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.blurView.alpha = 0.4
                })
            })
        }
    }
    
    @IBAction func orderSummaryButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.scrollView.scrollToTop()
        
        if versionOb < 4 {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                //            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(orderInfoModelObj.paymentStatus.lowercased() == "invoice" ? 40 : 100))
                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund) ? 40 : 40))
                
            }else{
                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund) ? 40 : 70))
                
            }
        } else {
            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund) ? 40 : 120))

            
//            if UI_USER_INTERFACE_IDIOM() == .pad {
//                //            tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(orderInfoModelObj.paymentStatus.lowercased() == "invoice" ? 40 : 100))
//                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund) ? 40 : 120))
//
//            }else{
//                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund) ? 40 : 70))
//
//            }
        }
        
        
        self.handleOrderSummaryButtonAction()
    }
    
    @IBAction func transactionButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.tableView.contentOffset = .zero
        self.scrollView.contentOffset = .zero
        self.scrollView.scrollToTop()
        
        if versionOb < 4 {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                self.tableView.tableFooterView?.frame.size = CGSize(width: self.tableView.frame.width, height: 40)
                // self.addressviewHeightConstraint.constant = 0
                self.orderSummaryLineView.backgroundColor = #colorLiteral(red: 0.9371728301, green: 0.9373074174, blue: 0.9371433854, alpha: 1)
            } else {
                self.transactionLineView.isHidden = false
                self.orderSummaryLineView.isHidden = true
            }
        } else {
            self.tableView.tableFooterView?.frame.size = CGSize(width: self.tableView.frame.width, height: 120)

            if UI_USER_INTERFACE_IDIOM() == .pad {
                // self.addressviewHeightConstraint.constant = 0
                self.orderSummaryLineView.backgroundColor = #colorLiteral(red: 0.9371728301, green: 0.9373074174, blue: 0.9371433854, alpha: 1)
            } else {
                self.transactionLineView.isHidden = false
                self.orderSummaryLineView.isHidden = true
            }
        }
        
        
        self.isOrderSummery = false
        self.isTapOnTransactionButton = true
        self.tableView.isScrollEnabled = true
        self.scrollView.isScrollEnabled = false
        
        self.orderDetailView.isHidden = true
        self.tableFooterView.isHidden = true
        self.orderAddressDetailView.isHidden = true
        
        self.orderSummaryButton.setTitleColor(#colorLiteral(red: 0.5489655137, green: 0.5647396445, blue: 0.603846848, alpha: 1), for: .normal)
        self.transactionButton.setTitleColor(   UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
        self.transactionLineView.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
        self.tableView.tableHeaderView?.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(0))
        
        self.transactionInfoArray.removeAll()
        self.reloadTableData(animate: true)
        
        self.callAPItoGetTransactionInfo()
    }
    @IBAction func btnAllInOne_action(_ sender: Any) {
        
        let Url = "\(BaseURL)/all_in_one/?custID=\(orderInfoModelObj.userID)&orderID=\(orderInfoModelObj.orderID)"
        let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        if let url:NSURL = NSURL(string: str!) {
            UIApplication.shared.open(url as URL)
        }
    }
    @IBAction func btnUpdate_action(_ sender: Any) {
        //https://del.hiecor.biz/invoice/#!/update/156197
        //let Url = "\(BaseURL)/invoice/#!/update/\(orderInfoModelObj.orderID)"
        let Url = "\(BaseURL)/\(orderInfoModelObj.updateInvoiceURL)"
        //let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        if let url:NSURL = NSURL(string: Url) {
            UIApplication.shared.open(url as URL)
        }
        
        //moveToHomeControllerScreen()
    }
    
    @IBAction func btnPayIngenico_Action(_ sender: Any) {
        appDelegate.isOpenToOrderHistory = true
        callAPItoGetOrderInfo()// September for pay invoice on payment method
//        DispatchQueue.main.async {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.callAPIToGetIngenicoLogin()
//            }
//        }
    }
    // Get customer data for pay invoice on payment method
    private func getCustomerData() -> CustomerListModel {
        let data = CustomerListModel()
        //Shipping
        data.str_shipping_first_name = self.orderInfoModelObj.shippingFirstName
        data.str_shipping_last_name =  self.orderInfoModelObj.shippingLastName
        data.str_Shippingemail =  self.orderInfoModelObj.shippingEmail
        data.str_Shippingphone = phoneNumberFormateRemoveText(number:  self.orderInfoModelObj.shippingPhone)
        data.str_company =  self.orderInfoModelObj.companyName
        data.str_Shippingaddress = self.orderInfoModelObj.shippingAddressLine1
        data.str_Shippingaddress2 = self.orderInfoModelObj.shippingAddressLine2
        data.str_Shippingcity = self.orderInfoModelObj.shippingCity
        data.str_Shippingregion = self.orderInfoModelObj.shippingRegion
        data.str_Shippingpostal_code = self.orderInfoModelObj.shippingPostalCode
        data.shippingCountry = self.orderInfoModelObj.shippingCountry
        //Billing
        data.str_billing_first_name = self.orderInfoModelObj.firstName
        data.str_billing_last_name = self.orderInfoModelObj.lastName
        data.str_Billingemail = self.orderInfoModelObj.email
        data.str_Billingphone = phoneNumberFormateRemoveText(number: self.orderInfoModelObj.phone)
        data.str_Billingaddress = self.orderInfoModelObj.addressLine1
        data.str_Billingaddress2 = self.orderInfoModelObj.addressLine2
        data.str_Billingcity = self.orderInfoModelObj.city
        data.str_Billingregion = self.orderInfoModelObj.region
        data.str_Billingpostal_code = self.orderInfoModelObj.postalCode
        data.billingCountry = self.orderInfoModelObj.country
        //
        data.str_office_phone = phoneNumberFormateRemoveText(number: self.orderInfoModelObj.phone)
        data.str_contact_source = ""
        data.str_first_name = self.orderInfoModelObj.firstName
        data.str_last_name = self.orderInfoModelObj.lastName
        data.str_email = self.orderInfoModelObj.email
        data.str_phone = phoneNumberFormateRemoveText(number: self.orderInfoModelObj.phone)
        data.str_address = self.orderInfoModelObj.addressLine1
        data.str_address2 = self.orderInfoModelObj.addressLine2
        data.str_city = self.orderInfoModelObj.city
        data.str_region = self.orderInfoModelObj.region
        data.str_postal_code = self.orderInfoModelObj.postalCode
        data.country = self.orderInfoModelObj.country
        //
        data.userCoupan = ""
        data.userCustomTax = ""//self.orderInfoModelObj.//""
      //  data.cardDetail =  self.orderInfoModelObj.cardd //customerList.cardDetail
        data.isDataAdded = true
        data.str_bpid = self.orderInfoModelObj.bpId
        data.str_display_name = self.orderInfoModelObj.firstName
        //data.str_order_id = customerList.str_order_id
        data.str_userID = self.orderInfoModelObj.userID
        data.str_CustomText1 = self.orderInfoModelObj.cust_customer1
        data.str_CustomText2 = self.orderInfoModelObj.cust_customer2
        data.str_customer_status = self.orderInfoModelObj.customer_status
        
        UserDefaults.standard.setValue(HieCOR.encode(data: orderInfoModelObj.card_info), forKey: "SelectedCustomer")
        UserDefaults.standard.synchronize()
       // "SelectedCustomer"
        return data
    }
  //  for pay invoice on payment method
    func moveToPaymentScreen() {
        appDelegate.orderDataClear = true
        appDelegate.isOpenToOrderHistory = true
        // Get customer data (Create cutomer model object)
        let customerData = getCustomerData()
        // Parse Product from model object
        var productJsonArray = JSONArray()
        productJsonArray = getProductData()
 
        DataManager.cartProductsArray = productJsonArray
        let couponPrice =  abs( self.orderInfoModelObj.couponPrice)
        let discount = self.orderInfoModelObj.discount - couponPrice
        let cartData = ["isDefaultTaxSelected": false , "isDefaultTaxChanged" : false, "shippingRefundButtonSelected" : false,"orderInfoObj":self.orderInfoModelObj, "isShippingPriceChanged":self.orderInfoModelObj.shipping > 0, "cartArray":productJsonArray, "subTotal":self.orderInfoModelObj.subTotal, "addDiscount":discount.description, "tax":self.orderInfoModelObj.tax.description, "taxType":self.orderInfoModelObj.customTax,"taxAmountValue":self.orderInfoModelObj.tax.description, "ShippingHandling":self.orderInfoModelObj.shipping.description, "notes":"self.orderInfoModelObj.n", "taxStateName":self.orderInfoModelObj.customTax, "Total":orderInfoModelObj.total , "customerObj":customerData, "couponName":self.orderInfoModelObj.couponCode, "couponAmount":couponPrice,"balance_due":Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0,"tipAmount_due":orderInfoModelObj.tip] as [String : Any]
        
        let data =  ["balance_due": Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0, "Total_due": Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0, "MultiTipAmount_due":0.0, "tipAmount_due": orderInfoModelObj.tip,"isDefaultTaxSelected": true,"isDefaultTaxChanged": false, "isPercentageDiscountApplied":false,"str_AddDiscountPercent":"","taxType":self.orderInfoModelObj.tax , "taxTitle":self.orderInfoModelObj.customTax, "taxAmountValue":self.orderInfoModelObj.tax, "str_ShippingANdHandling":"","isShippingPriceChanged": false, "str_AddDiscount":self.orderInfoModelObj.discount, "str_TaxPercentage":"", "str_AddCoupon":self.orderInfoModelObj.couponTitle, "str_CouponDiscount":self.orderInfoModelObj.discount, "taxableCouponTotal":""] as [String : Any]
        DataManager.cartData = data
//        DataManager.isCheckUncheckShippingBilling = tvAddressShipping.text == ""
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            DataManager.customerId = orderInfoModelObj.userID
        }
//        HomeVM.shared.tipValue = self.orderInfoModelObj.tip
        if UI_USER_INTERFACE_IDIOM() == .pad {
            DataManager.isCheckUncheckShippingBilling = tvAddressShipping.text == ""
            let storyboard = UIStoryboard.init(name: "iPad", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "iPad_PaymentTypesViewController") as! iPad_PaymentTypesViewController

            vc.cartObjectData = cartData as AnyObject
            vc.orderType = .newOrder
            vc.invoiceEmail = "invoiceEmail"
            vc.isCreditCardNumberDetected = false//isCreditCardNumberDetected
            vc.delegate = self
            vc.isOpenToOrderHistory = true
            vc.str_TaxAmount = orderInfoModelObj.tax.description
            DataManager.isBalanceDueData = false
            vc.orderInfoModelObj = orderInfoModelObj
            vc.CustomerObj = customerData
           // vc.showDetailsDelegateOne = self
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            DataManager.isCheckUncheckShippingBilling = shippingAddressLabel.text == ""
            let data1 =  ["balance_due": Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0, "Total_due": Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0, "MultiTipAmount_due":0.0, "tipAmount_due": orderInfoModelObj.tip,"isDefaultTaxSelected": true,"isDefaultTaxChanged": true, "isPercentageDiscountApplied":false,"str_AddDiscountPercent":"","taxType":self.orderInfoModelObj.tax.description , "taxTitle":self.orderInfoModelObj.customTax, "taxAmountValue":self.orderInfoModelObj.tax.description, "str_ShippingANdHandling":self.orderInfoModelObj.shipping.description,"isShippingPriceChanged": true, "str_AddDiscount":discount.description, "str_TaxPercentage":"", "str_AddCoupon":self.orderInfoModelObj.couponCode, "str_CouponDiscount":couponPrice.description, "taxableCouponTotal":""] as [String : Any]
            DataManager.cartData = data1
            HomeVM.shared.TotalDue = self.orderInfoModelObj.total
            HomeVM.shared.DueShared = Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            vc.orderType = .newOrder
            vc.cartProductsArray = productJsonArray
            DataManager.isBalanceDueData = false
            vc.isOpenToOrderHistory = true
            vc.orderInfoObj = self.orderInfoModelObj
            DataManager.recentOrderID = Int(self.orderInfoModelObj.orderID)
            appDelegate.isOpenToOrderHistory = false
            HomeVM.shared.tipValue = self.orderInfoModelObj.tip
            vc.CustomerObj = customerData
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        DispatchQueue.main.async {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.callAPIToGetIngenicoLogin()
//            }
//        }
    }
    
    
    //  for update button click
      func moveToHomeControllerScreen() {
          appDelegate.orderDataClear = true
          appDelegate.isOpenToOrderHistory = true
          // Get customer data (Create cutomer model object)
          let customerData = getCustomerData()
          // Parse Product from model object
          var productJsonArray = JSONArray()
          productJsonArray = getProductData()
   
          DataManager.cartProductsArray = productJsonArray
          let couponPrice =  abs( self.orderInfoModelObj.couponPrice)
          let discount = self.orderInfoModelObj.discount - couponPrice
          let cartData = ["isDefaultTaxSelected": false , "isDefaultTaxChanged" : false, "shippingRefundButtonSelected" : false,"orderInfoObj":self.orderInfoModelObj, "isShippingPriceChanged":self.orderInfoModelObj.shipping > 0, "cartArray":productJsonArray, "subTotal":self.orderInfoModelObj.subTotal, "addDiscount":discount.description, "tax":self.orderInfoModelObj.tax.description, "taxType":self.orderInfoModelObj.customTax,"taxAmountValue":self.orderInfoModelObj.tax.description, "ShippingHandling":self.orderInfoModelObj.shipping.description, "notes":"self.orderInfoModelObj.n", "taxStateName":self.orderInfoModelObj.customTax, "Total":orderInfoModelObj.total , "customerObj":customerData, "couponName":self.orderInfoModelObj.couponCode, "couponAmount":couponPrice,"balance_due":Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0,"tipAmount_due":orderInfoModelObj.tip] as [String : Any]
          
          let data =  ["balance_due": Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0, "Total_due": Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0, "MultiTipAmount_due":0.0, "tipAmount_due": orderInfoModelObj.tip,"isDefaultTaxSelected": true,"isDefaultTaxChanged": false, "isPercentageDiscountApplied":false,"str_AddDiscountPercent":"","taxType":self.orderInfoModelObj.tax , "taxTitle":self.orderInfoModelObj.customTax, "taxAmountValue":self.orderInfoModelObj.tax, "str_ShippingANdHandling":self.orderInfoModelObj.shipping.description,"isShippingPriceChanged": false, "str_AddDiscount":self.orderInfoModelObj.discount, "str_TaxPercentage":"", "str_AddCoupon":self.orderInfoModelObj.couponTitle, "str_CouponDiscount":self.orderInfoModelObj.discount, "taxableCouponTotal":""] as [String : Any]
          DataManager.cartData = data
          
          if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
              DataManager.customerId = orderInfoModelObj.userID
          }
  //        HomeVM.shared.tipValue = self.orderInfoModelObj.tip
          if UI_USER_INTERFACE_IDIOM() == .pad {
              
              DataManager.selectedCategory = "Home"
              DataManager.isTipRefundOnly = false
              DataManager.isshippingRefundOnly = false

              DispatchQueue.main.async {
                  let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                  let controller = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as! SWRevealViewController
                  appDelegate.window?.rootViewController = controller
                  appDelegate.window?.makeKeyAndVisible()
              }
//              let storyboard = UIStoryboard.init(name: "iPad", bundle: nil)
//              let vc = storyboard.instantiateViewController(withIdentifier: "CatAndProductsViewController") as! CatAndProductsViewController
//
//              //vc.cartObjectData = cartData as AnyObject
//              vc.orderType = .newOrder
//              //vc.invoiceEmail = "invoiceEmail"
//              //vc.isCreditCardNumberDetected = false//isCreditCardNumberDetected
//              //vc.delegate = self
//              //vc.isOpenToOrderHistory = true
//              //vc.str_TaxAmount = orderInfoModelObj.tax.description
//              //DataManager.isBalanceDueData = false
//              //vc.orderInfoModelObj = orderInfoModelObj
//             // vc.showDetailsDelegateOne = self
//              self.navigationController?.pushViewController(vc, animated: true)
          }else{
              let data1 =  ["balance_due": Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0, "Total_due": Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0, "MultiTipAmount_due":0.0, "tipAmount_due": orderInfoModelObj.tip,"isDefaultTaxSelected": true,"isDefaultTaxChanged": true, "isPercentageDiscountApplied":false,"str_AddDiscountPercent":"","taxType":self.orderInfoModelObj.tax.description , "taxTitle":self.orderInfoModelObj.customTax, "taxAmountValue":self.orderInfoModelObj.tax.description, "str_ShippingANdHandling":self.orderInfoModelObj.shipping.description,"isShippingPriceChanged": true, "str_AddDiscount":discount.description, "str_TaxPercentage":"", "str_AddCoupon":self.orderInfoModelObj.couponCode, "str_CouponDiscount":couponPrice.description, "taxableCouponTotal":""] as [String : Any]
              DataManager.cartData = data1
              HomeVM.shared.TotalDue = self.orderInfoModelObj.total
              HomeVM.shared.DueShared = Double(self.orderInfoModelObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0
              let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
              let vc = storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
              vc.orderType = .newOrder
              vc.cartProductsArray = productJsonArray
              DataManager.isBalanceDueData = false
              vc.isOpenToOrderHistory = true
              vc.orderInfoObj = self.orderInfoModelObj
              vc.isOpenToOrderHistory = true
              DataManager.recentOrderID = Int(self.orderInfoModelObj.orderID)
              appDelegate.isOpenToOrderHistory = true
              HomeVM.shared.tipValue = self.orderInfoModelObj.tip
              vc.CustomerObj = customerData
              self.navigationController?.pushViewController(vc, animated: true)
          }
  //        DispatchQueue.main.async {
  //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
  //                self.callAPIToGetIngenicoLogin()
  //            }
  //        }
      }
    
    func getProductData() -> JSONArray {
        var productJsonArray = JSONArray()
        for product in orderInfoModelObj.productsArray {
            var dict = JSONDictionary()
            dict["productqty"] = (product.qty.description)
            dict["actualproductqty"] = -(product.availableQtyRefund)
            //dict["productprice"] = product.mainPrice/product.qty
            dict["productprice"] = product.price.description //product.refundAmount/product.qty
            dict["qty_allow_decimal"] = product.qtyAllowDecimal
            dict["per_product_tax"] = product.perProductTax
            dict["per_product_discount"] = product.perProductDiscount
            dict["available_qty_refund"] = -(product.availableQtyRefund)
            
            dict["qty_allow_decimal"] = product.qtyAllowDecimal
            dict["producttitle"] = product.title
            dict["productid"] = product.productID
            dict["attributeString"] = product.attribute
            dict["productCode"] = product.code
            dict["productimage"] = product.image
            dict["returnToStock"] = false
            dict["isRefundProduct"] = false
            dict["selectionInventory"] = ""
            dict["isTaxExempt"] = product.isLineTaxExempt ? "Yes" : "No"
            dict["shippingPrice"] = product.shippingPrice
            dict["salesID"] = product.salesID
            dict["productistaxable"] = product.isTaxable
            dict["payment_method"] = product.paymentMethod
            dict["selectedAttributes"] = product.selectedAttributesData
            dict["variationData"] = product.attributesData
            dict["is_taxable"] = product.isTaxable
            dict["sales_id"] = product.salesID
            dict["perProductDiscount"] = product.perProductDiscount
            dict["perProductTax"] = product.perProductTax
            dict["meta_fieldsDictionary"] = product.meta_fieldsDictionary
            print("----attributesData")
            print(product.attributesData)
            print("----selectedAttributesData")
            print(product.selectedAttributesData)
            print("----variationsData")
            print(product.variationsData)
            print("----surchagevariationsData")
            print(product.surchagevariationsData)
            let variation = getVariationValueForProduct(attributeObj: product.attributesData, variationObj: product.variationsData, surchargeObj: product.surchagevariationsData,selectData: product.selectedAttributesData)
            print(variation)
            dict["variationNewData"] = variation
            dict["isProcessInvoice"] = true
            dict["manual_description"] = product.mainDesc
            
          //  self.str_ShippingANdHandling = obj.shipping.roundToTwoDecimal
            productJsonArray.append(dict)
        }
        return productJsonArray
    }
    
    func getVariationValueForProduct(attributeObj: JSONArray, variationObj: JSONArray, surchargeObj: JSONArray,selectData: JSONArray) -> JSONArray {
        
        var arrVariation = JSONArray()
        var arrRadio = JSONArray()
        var arrSurcharge = JSONArray()
        var arrCheckbox = JSONArray()
        var AllarrVariation = JSONArray()
        var arrTempAttSlct = [String]()
        var arrTempVar = [String]()
        var radioCount = 0
        var variationsDict = JSONDictionary()
        var AllvariationsDict = JSONDictionary()
        var isVationOn = false
        var TextDict = JSONDictionary()
        var arrTextAttribute = JSONArray()

        let productDetail = ProductModel.shared.getProductDetailStructForPanyNow(jsonArray: attributeObj,selectJsonArray: selectData)
        for i in 0..<productDetail.count {      //DDD
            let arrayData  = productDetail[i].valuesAttribute as [AttributesModel] as NSArray
            let attributeModel = arrayData[0] as! AttributesModel
            let jsonArray = attributeModel.jsonArray
            if attributeModel.attribute_type == "text" {
                TextDict["attribute_id"] = attributeModel.attribute_id
                TextDict["attribute_value"] = attributeModel.attribute_value
                
                arrTextAttribute.append(TextDict)
            }
            if attributeModel.attribute_type == "text_calendar" {
                TextDict["attribute_id"] = attributeModel.attribute_id
                TextDict["attribute_value"] = attributeModel.attribute_value
                
                arrTextAttribute.append(TextDict)
            }
            if let hh = jsonArray {
                let arrayAttrData = AttributeSubCategory.shared.getAttributeForPanyNow(with: hh, attrId: attributeModel.attribute_id,selectData:selectData)
                //print(arrayAttrData)
                
                for value in arrayAttrData {
                    
                    if value.isSelect {
                        if attributeModel.attribute_type == "radio" {
                            radioCount += 1
                            arrTempAttSlct.append(value.attribute_value_id)
                            
                            AllvariationsDict["variation_id"] = "0"
                            AllvariationsDict["attribute_id"] = value.attribute_id
                            AllvariationsDict["attribute_value_id"] = value.attribute_value_id
                            
                            arrRadio.append(AllvariationsDict)
                        } else {
                            
                            AllvariationsDict["variation_id"] = "0"
                            AllvariationsDict["attribute_id"] = value.attribute_id
                            AllvariationsDict["attribute_value_id"] = value.attribute_value_id
                            
                            arrCheckbox.append(AllvariationsDict)
                            
                            let surchargeDetail = ProductModel.shared.getProductDetailSurchargeVariationStructForPayNOW(jsonArray: surchargeObj)
                            for i in 0..<surchargeDetail.count {
                                let arrayData  = surchargeDetail[i].valuesSurchargeVariation as [SurchageModel] as NSArray
                                let surchargeModel = arrayData[0] as! SurchageModel
                                
                                for data in surchargeModel.jsonArray!{
                                    
                                    let attvalueId = (data as NSDictionary).value(forKey: "attribute_value_id") as! String
                                    
                                    if attvalueId == value.attribute_value_id {
                                        
                                        variationsDict["variation_id"] = surchargeModel.variation_id
                                        variationsDict["attribute_id"] = value.attribute_id
                                        variationsDict["attribute_value_id"] = value.attribute_value_id
                                        if  attributeModel.attribute_type != "radio" {
                                          variationsDict["manualPrice"] = surchargeModel.variation_price_surchargeClone
                                        }else{
                                            variationsDict["manualPrice"] = ""
                                        }
                                        arrSurcharge.append(variationsDict)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        print("radio count == \(radioCount)")
        
        let variationDetail = ProductModel.shared.getProductDetailVariationStructForPayNOW(jsonArray: variationObj)
        for i in 0..<variationDetail.count {
            let arrayData  = variationDetail[i].valuesVariation as [VariationModel] as NSArray
            let variationModel = arrayData[0] as! VariationModel
            
            let count = variationModel.jsonArray?.count
            
            if radioCount == count {
                arrTempVar.removeAll()
                for data in variationModel.jsonArray!{
                    let attId = (data as NSDictionary).value(forKey: "attribute_value_id") as! String
                    
                    arrTempVar.append(attId)
                }
                arrTempAttSlct = arrTempAttSlct.sorted()
                arrTempVar = arrTempVar.sorted()
                
                print(arrTempAttSlct)
                print(arrTempVar)
                if arrTempAttSlct == arrTempVar {
                    variationsDict["variation_id"] = variationModel.variation_id
                    variationsDict["attribute_id"] = "0"
                    variationsDict["attribute_value_id"] = "0"
                    variationsDict["manualPrice"] = ""
                    arrVariation.append(variationsDict)
                    isVationOn = true
                }
            }
        }
        
        var arrRemovetemp = [Int]()
        
        for i in 0..<arrCheckbox.count {
            let attCId = arrCheckbox[i]["attribute_id"] as! String
            let attCValId = arrCheckbox[i]["attribute_value_id"] as! String
            
            for j in 0..<arrSurcharge.count {
                let attSId = arrCheckbox[j]["attribute_id"] as! String
                let attSValId = arrCheckbox[j]["attribute_value_id"] as! String
                
                if attCId == attSId && attCValId == attSValId {
                    arrRemovetemp.append(i)
                }
            }
        }
        
        arrCheckbox.remove(at: arrRemovetemp)
        
        print(arrCheckbox)
        
        if isVationOn {
            AllarrVariation = arrVariation + arrSurcharge + arrCheckbox + arrTextAttribute
        } else {
            AllarrVariation = arrRadio + arrSurcharge + arrCheckbox + arrTextAttribute
        }

        print(AllarrVariation)
        
        return AllarrVariation
    }
}

//MARK: UIPopoverPresentationControllerDelegate
extension OrderInfoViewController {
    override func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        UIView.animate(withDuration: 0.2, animations: {
            self.blurView.alpha = 0
        }) { (_) in
            self.blurView.isHidden = true
        }
    }
}

//MARK: UserDetailsDelegate
extension OrderInfoViewController: UserDetailsDelegate {
    func didHideUserDetailView(isRefresh: Bool) {
        
        if isRefresh {
            callAPItoGetOrderInfo()
            //orderInfoDelegate?.didGetOrderInformation?(with: orderID, defualtView: true)
        }
        userContainer.isHidden = true
    }
}


//MARK: OrderInfoViewControllerDelegate
extension OrderInfoViewController: OrderInfoViewControllerDelegate {
    func didHideRefundView(isRefresh: Bool) {
        if isRefresh {
            self.scrollView.scrollToTop()
            self.didGetOrderInformation(with: orderID, defualtView : true)
        }
    }
    
    func didGetOrderInformation(with orderId: String, defualtView : Bool) {
        isTapOnTransactionButton = false
        orderID = orderId
        orderIdLabel.text = "#\(orderID)"
        orderIDlabel.text = "#\(orderID)"
        if defualtView {
            defualtViewFlag = true
            orderInfoDelegate?.didUpdateHeaderText?(with: "Orders")
        }else{
            defualtViewFlag = false
            orderInfoDelegate?.didUpdateHeaderText?(with: "#\(orderID)")
        }
        
        
        //Offline
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            Indicator.isEnabledIndicator = true
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        //Online
        blurView.backgroundColor = UIColor.black
        blurView.isHidden = true
        callAPItoGetOrderInfo()
    }
    
    func didProductRefunded() {
        isTapOnTransactionButton = false
        callAPItoGetOrderInfo()
    }
    
    func didProductReturned() {
        isTapOnTransactionButton = false
        callAPItoGetOrderInfo()
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension OrderInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isOrderSummery ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOrderSummery {
            switch section {
            case 0: return orderInfoModelObj.productsArray.count + 1
            case 1: return 1
            case 2: return arrTransactionData.count ?? 0
            default: return orderInfoModelObj.transactionArray.count
            }
        }else {
            return transactionInfoArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isOrderSummery {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: UI_USER_INTERFACE_IDIOM() == .phone ? "ItemsDetailTableCell" : isLandscape ? "ItemsDetailTableCell" : "ItemsDetailTableCell") as! ItemsDetailTableCell
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    cell.headerView.isHidden = indexPath.row != 0
                    cell.footerView.isHidden = indexPath.row == 0
                    cell.lineView.isHidden = indexPath.row != 0
                } else {
                    cell.refundExchangeStackView.axis = UIScreen.main.bounds.width < 365 ? .vertical : .horizontal
                }
                cell.productConditionLabel.text = ""
                cell.refundButton.isSelected = false
                if versionOb < 4{
                    if isLandscape {
                        cell.labelAction.text = "      "
                    }
                    if indexPath.row > 0 {
                        //cell.crossButton.tag = indexPath.row - 1
                        //cell.crossButton.addTarget(self, action: #selector(handleCrossAction(sender:)), for: .touchUpInside)
                        //cell.exchangeButton.tag = indexPath.row - 1
                        //cell.exchangeButton.addTarget(self, action: #selector(handleExchangeAction(sender:)), for: .touchUpInside)
                        
                        cell.refundButton.tag = indexPath.row - 1
                        cell.refundButton.addTarget(self, action: #selector(handleRefundAction(sender:)), for: .touchUpInside)
                        
                        
                        if UI_USER_INTERFACE_IDIOM() == .phone {
//                            if orderInfoModelObj.productsArray[indexPath.row - 1].isExchangeSelected {
//                                cell.exchangeButton.backgroundColor = UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0)
//                                cell.exchangeButton.setTitleColor(UIColor.white, for: .normal)
//                            } else {
//                                cell.exchangeButton.backgroundColor = UIColor.white
//                                cell.exchangeButton.setTitleColor(UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0), for: .normal)
//                            }
                            
//                            if orderInfoModelObj.productsArray[indexPath.row - 1].isRefundSelected {
//                                cell.refundButton.backgroundColor = UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0)
//                                cell.refundButton.setTitleColor(UIColor.white, for: .normal)
//                            } else {
//                                cell.refundButton.backgroundColor = UIColor.white
//                                cell.refundButton.setTitleColor(UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0), for: .normal)
//                            }
                            cell.refundButton.isSelected = orderInfoModelObj.productsArray[indexPath.row - 1].isRefundSelected

                        }else {
                            //cell.exchangeButton.isSelected = orderInfoModelObj.productsArray[indexPath.row - 1].isExchangeSelected
                            cell.refundButton.isSelected = orderInfoModelObj.productsArray[indexPath.row - 1].isRefundSelected
                        }
                        
                        let title = orderInfoModelObj.productsArray[indexPath.row - 1].title
                        cell.itemNameLabel.text = title == "" ? "   " : title
                        cell.qtyLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].qty.newValue
                        cell.priceLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].mainPrice.currencyFormat
                        cell.totalLabel.text = (orderInfoModelObj.productsArray[indexPath.row - 1].qty * orderInfoModelObj.productsArray[indexPath.row - 1].price).currencyFormat
//                        cell.variationTitleLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n") + "\n" + orderInfoModelObj.productsArray[indexPath.row - 1].attribute.replacingOccurrences(of: ",", with: "\n")
                        var variationText = ""
                       // newString = didShowDetailsAtrribute(cartArray: [cartProductsArray] )
                        if orderInfoModelObj.productsArray[indexPath.row ].metaFeildsStringValue == "" {
                            if orderInfoModelObj.productsArray[indexPath.row].attribute != "" {
                                variationText =  orderInfoModelObj.productsArray[indexPath.row].attribute.replacingOccurrences(of: ",", with: "\n")
                            }
                        }else if  orderInfoModelObj.productsArray[indexPath.row].attribute == "" {
                            variationText = orderInfoModelObj.productsArray[indexPath.row ].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n")
                        } else {
                            variationText = orderInfoModelObj.productsArray[indexPath.row ].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n") + "\n" + orderInfoModelObj.productsArray[indexPath.row].attribute.replacingOccurrences(of: ",", with: "\n")
                        }
                        if variationText != "" {
                            cell.variationTitleLabel.text = variationText
                            cell.variationTitleLabel.isHidden = false
                        }else{
                            cell.variationTitleLabel.isHidden = true
                        }
                        //cell.variationTitleLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].attribute.replacingOccurrences(of: ",", with: "\n")
                        let value  =  "\(orderInfoModelObj.productsArray[indexPath.row - 1].code) \n \(orderInfoModelObj.productsArray[indexPath.row - 1].man_desc)"
                        cell.labelNotes.text = value
                        if orderInfoModelObj.showDateColumn {
                        //if let lbl = cell.lblProductRefundDate {
                        cell.lblProductRefundDate.text = "\(orderInfoModelObj.productsArray[indexPath.row - 1].date)"
                        cell.lblProductRefundDate.isHidden = false

                        }else {
                            cell.lblProductRefundDate.isHidden = true
                        }
                        if UI_USER_INTERFACE_IDIOM() == .phone {
                            if cell.variationTitleLabel.text == "" {
                                cell.variationTitleLabel.isHidden = true
                            }
                            if orderInfoModelObj.productsArray[indexPath.row - 1].code == "" && orderInfoModelObj.productsArray[indexPath.row - 1].man_desc == "" {
                                cell.labelNotes.isHidden = true
                            }
                        }
                        if !orderInfoModelObj.isOrderRefund || orderInfoModelObj.productsArray[indexPath.row - 1].isRefunded || orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged || orderInfoModelObj.paymentStatus.lowercased() == "invoice" {
//                            cell.crossButton.isHidden = true
//                            cell.exchangeButton.isHidden = true
                            cell.refundButton.isHidden = true
                            cell.refundedLabel.isHidden = true
                            cell.contentView.layoutIfNeeded()
                            // cell.refundedLabel.text = orderInfoModelObj.paymentStatus.lowercased() == "invoice" ? "No Transaction" : !orderInfoModelObj.isOrderRefund ? "No Transaction" : orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged ? "Exchanged" : "Refunded"
                            
                            if orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund {
                                cell.refundedLabel.text = " "
                            }
                            
                            if orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged || orderInfoModelObj.productsArray[indexPath.row - 1].isRefunded {
                               // cell.refundedLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged ? "   Exchanged" : "   Refunded"
                                if(UI_USER_INTERFACE_IDIOM() == .pad){
                                    cell.refundedLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged ? "   Exchanged" : "    Refunded"
                                    if orderInfoModelObj.productsArray[indexPath.row - 1].product_condition != "" {
                                        cell.productConditionLabel.text = "Product Condition: \(orderInfoModelObj.productsArray[indexPath.row - 1].product_condition)"
                                    }
                                }else{
                                    cell.refundedLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged ? "   Exchanged" : "Refunded \nProduct Condition: \(orderInfoModelObj.productsArray[indexPath.row - 1].product_condition)"
                                    if orderInfoModelObj.productsArray[indexPath.row - 1].product_condition != "" {
                                        cell.productConditionLabel.text = "Product Condition: \(orderInfoModelObj.productsArray[indexPath.row - 1].product_condition)"
                                    }
                                }
                            }
                            
                            cell.contentView.alpha = (orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund || orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged || orderInfoModelObj.productsArray[indexPath.row - 1].isRefunded) ? 0.5 : 1.0
                        }else {
                            //cell.crossButton.isHidden = true
                           // cell.exchangeButton.isHidden = true
                            cell.refundButton.isHidden = true
                            cell.refundedLabel.isHidden = true
                            cell.contentView.layoutIfNeeded()
                            
                            //cell.crossButton.isUserInteractionEnabled = orderInfoModelObj.productsArray[indexPath.row - 1].isRefundSelected || orderInfoModelObj.productsArray[indexPath.row - 1].isExchangeSelected
                            //cell.crossButton.alpha = (orderInfoModelObj.productsArray[indexPath.row - 1].isRefundSelected || orderInfoModelObj.productsArray[indexPath.row - 1].isExchangeSelected) ? 1 : 0
                            cell.contentView.alpha = 1.0
                        }
                        if indexPath.row == orderInfoModelObj.productsArray.count && UI_USER_INTERFACE_IDIOM() == .phone {
                            cell.bottomLine.isHidden = true
                        }
                    }
                }else{
                    if indexPath.row > 0 {
                        
                        cell.refundButton.tag = indexPath.row - 1
                        cell.refundButton.addTarget(self, action: #selector(handleRefundAction(sender:)), for: .touchUpInside)
                        cell.refundButton.isSelected = orderInfoModelObj.productsArray[indexPath.row - 1].isExchangeSelected

                        let title = orderInfoModelObj.productsArray[indexPath.row - 1].title
                        cell.itemNameLabel.text = title == "" ? "   " : title
                        cell.qtyLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].qty.newValue
                        cell.priceLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].mainPrice.currencyFormat
                        cell.totalLabel.text = (orderInfoModelObj.productsArray[indexPath.row - 1].qty * orderInfoModelObj.productsArray[indexPath.row - 1].price).currencyFormat
                       // cell.variationTitleLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].attribute.replacingOccurrences(of: ",", with: "\n")
//                        cell.variationTitleLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n") + "\n" + orderInfoModelObj.productsArray[indexPath.row - 1].attribute.replacingOccurrences(of: ",", with: "\n")
                        var variationText = ""
                       // newString = didShowDetailsAtrribute(cartArray: [cartProductsArray] )
                        if orderInfoModelObj.productsArray[indexPath.row - 1].metaFeildsStringValue == "" {
                            if orderInfoModelObj.productsArray[indexPath.row - 1].attribute != "" {
                                variationText =  orderInfoModelObj.productsArray[indexPath.row - 1].attribute.replacingOccurrences(of: ",", with: "\n")
                            }
                        }else if  orderInfoModelObj.productsArray[indexPath.row - 1].attribute == "" {
                            variationText = orderInfoModelObj.productsArray[indexPath.row - 1].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n")
                        } else {
                            variationText = orderInfoModelObj.productsArray[indexPath.row - 1].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n") + "\n" + orderInfoModelObj.productsArray[indexPath.row - 1].attribute.replacingOccurrences(of: ",", with: "\n")
                        }
                        if variationText != "" {
                            cell.variationTitleLabel.text = variationText
                            cell.variationTitleLabel.isHidden = false
                        }else{
                            cell.variationTitleLabel.isHidden = true
                        }
                        if orderInfoModelObj.showDateColumn {
                            cell.lblProductRefundDate.text = "\(orderInfoModelObj.productsArray[indexPath.row - 1].date)"
                            cell.lblProductRefundDate.isHidden = cell.lblProductRefundDate.text == "" ? true : false
                        }else {
                            cell.lblProductRefundDate.isHidden = true
                        }
                        let value  =  "\(orderInfoModelObj.productsArray[indexPath.row - 1].code) \n \(orderInfoModelObj.productsArray[indexPath.row - 1].man_desc)"
                        
                        
                        var dataVal = ""
                        
                        if orderInfoModelObj.productsArray[indexPath.row - 1].code != "" && orderInfoModelObj.productsArray[indexPath.row - 1].man_desc != "" {
                            dataVal = "\(orderInfoModelObj.productsArray[indexPath.row - 1].code) \n \(orderInfoModelObj.productsArray[indexPath.row - 1].man_desc)"
                        } else if orderInfoModelObj.productsArray[indexPath.row - 1].man_desc != ""{
                            dataVal = orderInfoModelObj.productsArray[indexPath.row - 1].man_desc
                        } else if orderInfoModelObj.productsArray[indexPath.row - 1].code != "" {
                            dataVal = orderInfoModelObj.productsArray[indexPath.row - 1].code
                        }
                        cell.labelNotes.text = dataVal
                        if UI_USER_INTERFACE_IDIOM() == .phone {
                            if cell.variationTitleLabel.text == "" {
                                cell.variationTitleLabel.isHidden = true
                            }
                            if orderInfoModelObj.productsArray[indexPath.row - 1].code == "" && orderInfoModelObj.productsArray[indexPath.row - 1].man_desc == "" {
                                cell.labelNotes.isHidden = true
                            }
                        }
                        if !orderInfoModelObj.isOrderRefund || orderInfoModelObj.productsArray[indexPath.row - 1].isRefunded || orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged || orderInfoModelObj.paymentStatus.lowercased() == "invoice" {
                            cell.refundButton.isHidden = true
                            cell.refundedLabel.isHidden = false
                            //                        cell.refundedLabel.text = orderInfoModelObj.paymentStatus.lowercased() == "invoice" ? "No Transaction" : !orderInfoModelObj.isOrderRefund ? "No Transaction" : orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged ? "Exchanged" : "Refunded"
                            
                            if orderInfoModelObj.paymentStatus.lowercased() == "invoice" || !orderInfoModelObj.isOrderRefund {
                                cell.refundButton.isHidden = true
                                cell.refundedLabel.text = " "
                                cell.layoutIfNeeded()
                            }
                            
                            if orderInfoModelObj.isOrderRefund == true && orderInfoModelObj.product_status == "" {
                                self.view.layoutIfNeeded()
                                cell.refundButton.isHidden = false
                                cell.refundedLabel.isHidden = true
                            }
                            if orderInfoModelObj.paymentStatus == "AUTH" {
                                cell.refundedLabel.isHidden = true
                            }
                            if orderInfoModelObj.paymentStatus == "ERROR" {
                                cell.refundedLabel.isHidden = true
                            }
                            if orderInfoModelObj.paymentStatus == "VOID" {
                                cell.refundedLabel.isHidden = true
                            }
                            
                            if orderInfoModelObj.productsArray[indexPath.row - 1].availableQtyRefund <= 0.0 {
                                cell.refundButton.isHidden = true
                                cell.refundedLabel.isHidden = true
                            }
                            if orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged || orderInfoModelObj.productsArray[indexPath.row - 1].isRefunded {
//                                cell.refundedLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged ? "   Exchanged" : "   Refunded"
                                if(UI_USER_INTERFACE_IDIOM() == .pad){
                                    cell.refundedLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged ? "   Exchanged" : "    Refunded"
                                    if orderInfoModelObj.productsArray[indexPath.row - 1].product_condition != "" {
                                        cell.productConditionLabel.text = "Product Condition: \(orderInfoModelObj.productsArray[indexPath.row - 1].product_condition)"
                                    }
                                }else{
                                    cell.refundedLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged ? "   Exchanged" : "Refunded \nProduct Condition: \(orderInfoModelObj.productsArray[indexPath.row - 1].product_condition)"
                                    if orderInfoModelObj.productsArray[indexPath.row - 1].product_condition != "" {
                                        cell.productConditionLabel.text = "Product Condition: \(orderInfoModelObj.productsArray[indexPath.row - 1].product_condition)"
                                    }
                                }
                                cell.refundedLabel.isHidden = false
                                cell.refundButton.isHidden = true
                                cell.layoutIfNeeded()
                                
                            }
                            
                            cell.contentView.alpha = ( !orderInfoModelObj.isOrderRefund || orderInfoModelObj.productsArray[indexPath.row - 1].isExchanged || orderInfoModelObj.productsArray[indexPath.row - 1].isRefunded) ? 0.5 : 1.0
                        }else {
                            self.view.layoutIfNeeded()
                            cell.refundButton.isHidden = false
                            cell.refundedLabel.isHidden = true
                            cell.contentView.alpha = 1.0
                            if orderInfoModelObj.productsArray[indexPath.row - 1].availableQtyRefund <= 0.0 {
                                cell.refundButton.isHidden = true
                                cell.refundedLabel.isHidden = true
                            }
                        }
                        
                        if indexPath.row == orderInfoModelObj.productsArray.count && UI_USER_INTERFACE_IDIOM() == .phone {
                            cell.bottomLine.isHidden = true
                        }
                    }
                }
                
                cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                
                if(UI_USER_INTERFACE_IDIOM() == .pad)
                {
                    if (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)) {
                        cell.constraintHeadItem.constant = 220
                        cell.ConstraintProductName.constant = 220
                    } else {
                        cell.constraintHeadItem.constant = 110
                        cell.ConstraintProductName.constant = 110
                    }
                }
                
                
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailTableCell") as! PaymentDetailTableCell
                
                var isRefund = false
                var isShippingRefund = false
                var isTipRefund = false
                for i in 0..<orderInfoModelObj.productsArray.count {
                    if orderInfoModelObj.productsArray[i].isExchangeSelected == true {
                        isRefund = true
                    }
                }
                if orderInfoModelObj.isshippingRefundSelected == true {
                    isShippingRefund = true
                    isRefund = true
                }
                
                if orderInfoModelObj.isTipRefundSelected == true {
                    isTipRefund = true
                    isRefund = true
                }
                
                cell.subtotalLabel.text = orderInfoModelObj.subTotal.currencyFormat
                cell.discountLabel.text =  orderInfoModelObj.discount.currencyFormat
                cell.shippingLabel.text =  orderInfoModelObj.shipping.currencyFormat
                cell.taxLabel.text = orderInfoModelObj.tax.currencyFormat
                cell.labelTotalMain.text = orderInfoModelObj.total.currencyFormat
                
                cell.discountView.isHidden = orderInfoModelObj.discount <= 0
                cell.shippingView.isHidden = orderInfoModelObj.shipping <= 0
                
                DataManager.shippingValue = orderInfoModelObj.shipping
                
                cell.taxView.isHidden = orderInfoModelObj.tax <= 0
                
                cell.couponLabel.isHidden = orderInfoModelObj.couponCode == ""
                cell.couponView.isHidden = orderInfoModelObj.couponTitle == ""
                cell.tipLabel.text = orderInfoModelObj.tip.currencyFormat
                cell.tipView.isHidden = orderInfoModelObj.tip <= 0
                
                cell.btnRefund.tag = indexPath.row - 1
                cell.btnRefund.addTarget(self, action: #selector(handleRefundProductAction(sender:)), for: .touchUpInside)

                if orderInfoModelObj.productsArray.count == 0 {
                    cell.refundShipping.tag = indexPath.row + 1
                    cell.btnTipRefund.tag = indexPath.row + 1
                } else {
                    cell.refundShipping.tag = indexPath.row
                    cell.btnTipRefund.tag = indexPath.row
                }
                //cell.refundShipping.tag = indexPath.row
                cell.refundShipping.addTarget(self, action: #selector(handleShippingRefundAction(sender:)), for: .touchUpInside)
                cell.btnTipRefund.addTarget(self, action: #selector(handelTipRefundAction(sender:)), for: .touchUpInside)

                if orderInfoModelObj.paymentStatus == "AUTH" {
                    cell.btnRefund.isHidden = true
                    cell.btnVoid.isHidden = true
                } else {
                    if isRefund {
                        cell.btnRefund.isHidden = false
                        cell.btnVoid.isHidden = false
                    } else {
                        cell.btnRefund.isHidden = true
                        cell.btnVoid.isHidden = true
                    }
                }
                
                if isShippingRefund {
                    cell.refundShipping.isSelected = true
                } else {
                    cell.refundShipping.isSelected = false
                }
                
                if isTipRefund {
                    cell.btnTipRefund.isSelected = true
                } else {
                    cell.btnTipRefund.isSelected = false
                }
                
                if versionOb < 4 {
                    cell.btnRefund.isHidden = false
                    cell.btnVoid.isHidden = false
                    cell.btnRefund.setTitle("Refund", for: .normal)
                    if orderInfoModelObj.paymentStatus == "AUTH" {
                        cell.btnRefund.isHidden = true
                        cell.btnVoid.isHidden = true
                    }
                    
//                    if orderInfoModelObj.transactionArray.count == 0 {
//                        cell.btnRefund.isHidden = true
//                        cell.btnVoid.isHidden = true
//                    }
                }

                if UI_USER_INTERFACE_IDIOM() == .pad {
                   cell.couponLabel.text = "Coupon Applied - (\(orderInfoModelObj.couponCode))"
                    //cell.subtotalWidthConstraint.isActive = true
                    //cell.subtotalStackViewRightConstraint.isActive = !isLandscape
                    
                    //cell.subtotalAmountWidthConstraint.isActive = isLandscape
                    //cell.subtotalWidthConstraint.constant = orderInfoModelObj.discount <= 0 ? 80 : 100
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
                } else {
                    // cell.couponView.isHidden = orderInfoModelObj.couponTitle == ""
                    // cell.couponLabel.text = orderInfoModelObj.couponPrice.currencyFormat
                    
//                    if orderInfoModelObj.couponTitle == ""{
//                        cell.couponView.isHidden = orderInfoModelObj.couponTitle == ""
//                    }else{
                        cell.couponView.isHidden = true
                        cell.labelTitleDiscount.text = "Manual Discount Coupon Applied - (\(orderInfoModelObj.couponCode))"
                        cell.couponLabel.text = orderInfoModelObj.couponPrice.currencyFormat
                        
                   // }
                }
                
                if  !orderInfoModelObj.isOrderRefund {
                    cell.btnRefund.isHidden = true
                    cell.btnVoid.isHidden = true
                }
                
                if orderInfoModelObj.showRefundShipping{
                    cell.refundShipping.isHidden = false
                    cell.refundShipping.setTitle("Refund", for: .normal)
                    cell.refundShipping.isUserInteractionEnabled = true
                    //cell.refundShipping.imageView?.image = #imageLiteral(resourceName: "Groupuncheck")
                    if isShippingRefund {
                        cell.refundShipping.setImage(#imageLiteral(resourceName: "Groupcheck"), for: .normal)
                    } else {
                        cell.refundShipping.setImage(#imageLiteral(resourceName: "Groupuncheck"), for: .normal)
                    }
                    
                } else {
                    cell.refundShipping.setTitle(" ", for: .normal)
                    cell.refundShipping.setImage(nil, for: .normal)
                    cell.refundShipping.isUserInteractionEnabled = false
                    //cell.refundShipping.imageView?.image = #imageLiteral(resourceName: "Groupcheck")
                }
                
                if orderInfoModelObj.showRefundTip{
                    cell.btnTipRefund.isHidden = false
                    cell.btnTipRefund.setTitle("Refund", for: .normal)
                    cell.btnTipRefund.isUserInteractionEnabled = true
                    //cell.refundShipping.imageView?.image = #imageLiteral(resourceName: "Groupuncheck")
                    if isTipRefund {
                        cell.btnTipRefund.setImage(#imageLiteral(resourceName: "Groupcheck"), for: .normal)
                    } else {
                        cell.btnTipRefund.setImage(#imageLiteral(resourceName: "Groupuncheck"), for: .normal)
                    }
                    
                } else {
                    cell.btnTipRefund.setTitle(" ", for: .normal)
                    cell.btnTipRefund.setImage(nil, for: .normal)
                    cell.btnTipRefund.isUserInteractionEnabled = false
                    //cell.refundShipping.imageView?.image = #imageLiteral(resourceName: "Groupcheck")
                }
                
                return cell
                
            case 2:
                //let cell = tableView.dequeueReusableCell(withIdentifier: UI_USER_INTERFACE_IDIOM() == .phone ? "TransactionListCell" : isLandscape ? "TransactionListCell" : "TransactionListCell")
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListCell", for: indexPath)
                
                if arrTransactionData.count == 0 {
                    return cell
                }
                
                let lbl_Name = cell.contentView.viewWithTag(701) as? UILabel
                let lbl_Amount = cell.contentView.viewWithTag(702) as? UILabel
                let lbl_Date = cell.contentView.viewWithTag(703) as? UILabel
                let tipBtn = cell.contentView.viewWithTag(704) as? UIButton
                let tipBtnView = cell.contentView.viewWithTag(705) as? UIView
                
                let data = arrTransactionData[indexPath.row] as? NSDictionary
                lbl_Name?.text = data?.value(forKey: "type") as? String
                lbl_Amount?.text = data?.value(forKey: "amount") as? String
                lbl_Date?.text = data?.value(forKey: "date") as? String
                let isTipBtnShow = data?.value(forKey: "isTipBtn") as? String
                
                
                tipBtn?.tag = indexPath.row
                tipBtn?.addTarget(self, action: #selector(handleOpenCustomAlert(sender:)), for: .touchUpInside)
                
               // if (lbl_Name?.text != nil) {
                if isTipBtnShow == "true" && DataManager.collectTips {
                        tipBtnView?.isHidden = false
                    } else {
                        tipBtnView?.isHidden = true
                    }
                //}
                
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    lbl_Amount?.textAlignment = .center
                    
                }
                
                if versionOb < 4 {
                    tipBtnView?.isHidden = true
                }
                
                return cell
            default:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: UI_USER_INTERFACE_IDIOM() == .phone ? "TransactionCell" : isLandscape ? "TransactionCell" : "TransactionCell")
                
                return cell!
            }
        }
        
        //Transactions
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier:"TransactionsCell" , for: indexPath) as! TransactionsListCell
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorColor = UIColor.lightGray
        
        
        let lbl_Status = cell.contentView.viewWithTag(503) as? UILabel
        lbl_Status?.text = transactionInfoArray[indexPath.row].approval
        lbl_Status?.layer.borderWidth = 1.0
        lbl_Status?.layer.cornerRadius = 10
        lbl_Status?.layer.masksToBounds = true
        
        let transactionPrintBtnView = cell.contentView.viewWithTag(511)
        //let printBtn = cell.contentView.viewWithTag(510) as? UIButton
        cell.btnTranxPrnt.tag = indexPath.row
        cell.btnTranxPrnt.addTarget(self, action: #selector(handleTransactionPrintBtnAction(sender: )), for: .touchUpInside)
        
        if transactionInfoArray[indexPath.row].paymentType=="AUTH_CAPTURE" && transactionInfoArray[indexPath.row].approval == "Approved" {
            transactionPrintBtnView?.isHidden = false
            cell.btnTranxPrnt.isHidden = false
        } else {
            transactionPrintBtnView?.isHidden = true
            cell.btnTranxPrnt.isHidden = true
        }
        
        if transactionInfoArray[indexPath.row].approval == "Approved" {
            transactionPrintBtnView?.isHidden = true
            lbl_Status?.layer.borderColor = UIColor.init(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0).cgColor
            lbl_Status?.backgroundColor = UIColor.init(red: 206.0/255.0, green: 245.0/255.0, blue: 213.0/255.0, alpha: 1.0)
            lbl_Status?.textColor = UIColor.init(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        }else {
            transactionPrintBtnView?.isHidden = false
            lbl_Status?.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 142.0/255.0, blue: 139.0/255.0, alpha: 1.0).cgColor
            lbl_Status?.backgroundColor = UIColor.init(red: 245.0/255.0, green: 211.0/255.0, blue: 206.0/255.0, alpha: 1.0)
            lbl_Status?.textColor = UIColor.init(red: 220.0/255.0, green: 142.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        }
        
        if versionOb < 4 {
            transactionPrintBtnView?.isHidden = true
            cell.btnTranxPrnt.isHidden = true
        }
        
        let lbl_TransactionID = cell.contentView.viewWithTag(501) as? UILabel
        lbl_TransactionID?.text = "#\(transactionInfoArray[indexPath.row].txnId)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newDate = dateFormatter.date(from: transactionInfoArray[indexPath.row].dateAdded) ?? Date()
        
        let lbl_TransactionDate = cell.contentView.viewWithTag(502) as? UILabel
        lbl_TransactionDate?.text = newDate.stringFromDate(format: .newDateTime1, type: .local)
        //
        //        501 - id
        //        502- date
        //        503- approved
        //        504- total
        //        505- card type
        //        506- payment type
        //        507- view 1
        //        508- view 2
        //        509 - view 3
        //
        
        let lbl_Total = cell.contentView.viewWithTag(504) as? UILabel
        lbl_Total?.text = "\(transactionInfoArray[indexPath.row].amount.currencyFormat)"
        
        let lbl_CardType = cell.contentView.viewWithTag(505) as? UILabel
        lbl_CardType?.text = transactionInfoArray[indexPath.row].cardType
        
        let lbl_PaymentType = cell.contentView.viewWithTag(506) as? UILabel
        lbl_PaymentType?.text = transactionInfoArray[indexPath.row].paymentType
        
        // *********
        cell.contentView.backgroundColor = transactionInfoArray[indexPath.row].test_order == 1 ? #colorLiteral(red: 0.9882352941, green: 0.9764705882, blue: 0.5843137255, alpha: 1) : UIColor.white

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isOrderSummery {
            if(UI_USER_INTERFACE_IDIOM() == .pad)
            {
                let txnData = ["show":true, "data": transactionInfoArray[indexPath.row]] as [String : Any]
                orderInfoDelegate?.didUpdateTransactionScreen?(with: txnData)
            }else
            {
                selectedIndex = indexPath.row
                self.performSegue(withIdentifier: "transactioninfo", sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .phone && isOrderSummery {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    return 0
                }
            }
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 && isOrderSummery{
                    return 40
                } else {
                    return UITableViewAutomaticDimension
                }
            default:
                print("on")
            }
            if indexPath.row == 2{
                
                //                if versionOb < 4 {
                //                    return 40
                //                }
            }
            return UITableViewAutomaticDimension
        }else{
            if indexPath.row == 2{
                return isOrderSummery ? UITableViewAutomaticDimension : UITableViewAutomaticDimension
            }
        }
//        if UIScreen.main.bounds.width >= 365 && indexPath.section == 2 && isOrderSummery && UI_USER_INTERFACE_IDIOM() == .phone && !orderInfoModelObj.transactionArray[indexPath.row].isVoid {
//            return UITableViewAutomaticDimension
//        }
        return isOrderSummery ? UITableViewAutomaticDimension : UITableViewAutomaticDimension
    }
    
    
    @objc func handleTransactionPrintBtnAction(sender: UIButton) {
        let transationID = transactionInfoArray[sender.tag].txnId
        print ("transationID =",transationID)
        
        if !DataManager.isBluetoothPrinter && !DataManager.isGooglePrinter {
            if DataManager.showFullRecieptOptionForPrint == "true" {
                let Url = "\(BaseURL)/packing_slip/?&ai_skin=full_page&full=y&order_id=\(self.orderInfoModelObj.orderID)"
                let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                if let url:NSURL = NSURL(string: str!) {
                    UIApplication.shared.open(url as URL)
                }
            } else {
                appDelegate.showToast(message: "Please first enable the printer from settings")
            }
            return
        }
        
        if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter{
            self.callAPItoGetTransactionPrintReceiptContent(transactionID: transationID)
        }
        
//        if DataManager.isGooglePrinter { 997510310000036  BKID0009975
//            let Url = transactionInfoArray[sender.tag].transactionGoogle_receipt_url
//            //let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//            if let url:NSURL = NSURL(string: Url) {
//                UIApplication.shared.open(url as URL)
//            }
//        }
        //            // for socket
        //            if DataManager.socketAppUrl != "" {
        //                MainSocketManager.shared.oncloseRecieptModal{
        //                    MainSocketManager.shared.onreset()
        //                    self.showHomeScreeen()
        //                }
        //            }
        
    }
    
    @objc func handleCrossAction(sender: UIButton) {
        self.view.endEditing(true)
        orderInfoModelObj.productsArray[sender.tag].isRefundSelected = false
        orderInfoModelObj.productsArray[sender.tag].isExchangeSelected = false
        updateRefundAmount()
        ClearbButtonColorChange()
    }
    
    @objc func handleExchangeAction(sender: UIButton) {
        self.view.endEditing(true)
        orderInfoModelObj.productsArray[sender.tag].isRefundSelected = false
        orderInfoModelObj.productsArray[sender.tag].isExchangeSelected = true
        updateRefundAmount()
        ClearbButtonColorChange()
    }
    
    @objc func handelTipRefundAction(sender: UIButton) {
        self.view.endEditing(true)
        if !sender.isSelected {
            orderInfoModelObj.isTipRefundSelected = true
        } else {
            orderInfoModelObj.isTipRefundSelected = false
        }
        tableView.reloadData()
        
        //Reload Table
        self.tableView.reloadData {
            self.tableView.contentOffset = .zero
            if !self.isOrderSummery {
                self.tableViewheight.constant = self.view.bounds.size.height - (UI_USER_INTERFACE_IDIOM() == .pad ? 120 : 190)
            }else {
                self.tableView.layoutIfNeeded()
                self.tableViewheight.constant = self.tableView.contentSize.height
            }
        }
    }
    
    @objc func handleShippingRefundAction(sender: UIButton) {
        self.view.endEditing(true)
        
        if !sender.isSelected {
            //sender.setImage(UIImage(named:"shipping-check.png"), for: .normal)
            //orderInfoModelObj.productsArray[sender.tag].isRefundSelected = false
            //orderInfoModelObj.productsArray[sender.tag].isExchangeSelected = true
            orderInfoModelObj.isshippingRefundSelected = true
//            updateRefundAmount()
        } else {
            //sender.setImage( UIImage(named:"shipping-uncheck.png"), for: .normal)
            //orderInfoModelObj.productsArray[sender.tag].isRefundSelected = false
            //orderInfoModelObj.productsArray[sender.tag].isExchangeSelected = false
            orderInfoModelObj.isshippingRefundSelected = false
//            updateRefundAmount()
        }
        tableView.reloadData()
        
        //Reload Table
        self.tableView.reloadData {
            self.tableView.contentOffset = .zero
            if !self.isOrderSummery {
                self.tableViewheight.constant = self.view.bounds.size.height - (UI_USER_INTERFACE_IDIOM() == .pad ? 120 : 190)
            }else {
                self.tableView.layoutIfNeeded()
                self.tableViewheight.constant = self.tableView.contentSize.height
            }
        }
    }
    
    @objc func handleRefundAction(sender: UIButton) {
        self.view.endEditing(true)
        
        if !sender.isSelected {
            //sender.setImage(UIImage(named:"shipping-check.png"), for: .normal)
            orderInfoModelObj.productsArray[sender.tag].isRefundSelected = false
            orderInfoModelObj.productsArray[sender.tag].isExchangeSelected = true
            updateRefundAmount()
        } else {
            //sender.setImage( UIImage(named:"shipping-uncheck.png"), for: .normal)
            orderInfoModelObj.productsArray[sender.tag].isRefundSelected = false
            orderInfoModelObj.productsArray[sender.tag].isExchangeSelected = false
            updateRefundAmount()
        }
    }
    
    @objc func handlePaymentCrossAction(sender: UIButton) {
        self.view.endEditing(true)
        orderInfoModelObj.transactionArray[sender.tag].isFullRefundSelected = false
        orderInfoModelObj.transactionArray[sender.tag].isPartialRefundSelected = false
        orderInfoModelObj.transactionArray[sender.tag].isVoidSelected = false
        orderInfoModelObj.transactionArray[sender.tag].partialAmount = ""
        tableView.reloadData()
        ClearbButtonColorChange()
    }
    
    @objc func handlePartialRefundAction(sender: UIButton) {
        self.view.endEditing(true)
        orderInfoModelObj.transactionArray[sender.tag].isFullRefundSelected = false
        orderInfoModelObj.transactionArray[sender.tag].isPartialRefundSelected = true
        orderInfoModelObj.transactionArray[sender.tag].isVoidSelected = false
        tableView.reloadData()
        ClearbButtonColorChange()
    }
    
    @objc func handleRefundProductAction(sender: UIButton) {
        self.view.endEditing(true)
        self.view.endEditing(true)
        sender.backgroundColor =  #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sender.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
        }
        appDelegate.str_Refundvalue = "refund"
        let tag = sender.tag + 1
        let isrefundShipping = orderInfoModelObj.isshippingRefundSelected
        let isRefundTip = orderInfoModelObj.isTipRefundSelected
        var isrefundOnly = false

        for i in 0..<orderInfoModelObj.productsArray.count {
            if orderInfoModelObj.productsArray[i].isExchangeSelected == true {
                isrefundOnly = true
            }
        }
    
        appDelegate.shippingRefundOnly = orderInfoModelObj.refundShippingAmount
        appDelegate.tipRefundOnly = orderInfoModelObj.tip
        if isrefundOnly && isrefundShipping {
            DataManager.isshippingRefundOnly = false
        } else if isrefundShipping {
            DataManager.isshippingRefundOnly = true
        } else {
            DataManager.isshippingRefundOnly = false
        }
        
        
        if isrefundOnly {
            DataManager.isshippingRefundOnly = false
            DataManager.isTipRefundOnly = false
        } else if isrefundShipping && isRefundTip {
            DataManager.isshippingRefundOnly = true
            DataManager.isTipRefundOnly = true
            appDelegate.shippingRefundOnly = orderInfoModelObj.refundShippingAmount
            appDelegate.tipRefundOnly = orderInfoModelObj.tip
        } else if isrefundShipping && !isRefundTip {
            DataManager.isshippingRefundOnly = true
            DataManager.isTipRefundOnly = false
            appDelegate.shippingRefundOnly = orderInfoModelObj.refundShippingAmount
            appDelegate.tipRefundOnly = orderInfoModelObj.tip
        } else if !isrefundShipping && isRefundTip {
            DataManager.isshippingRefundOnly = false
            DataManager.isTipRefundOnly = true
            appDelegate.shippingRefundOnly = orderInfoModelObj.shipping
            appDelegate.tipRefundOnly = orderInfoModelObj.tip
        }
        
        if versionOb < 4 {
            let dataChange = self.orderInfoModelObj.refundUrl.replacingOccurrences(of: "userID", with: "custID")
            let Url = dataChange
            let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            if let url:NSURL = NSURL(string: str!) {
                UIApplication.shared.open(url as URL)
            }
            return
        }
        
        DataManager.isCaptureButton = false
        
        if (self.revealViewController().frontViewPosition != FrontViewPositionLeft) {
            self.revealViewController()?.revealToggle(animated: true)
        }
        let updatedData = getUpdatedData()
        
        //        if !updatedData.0 && !updatedData.1 {
        //            self.showAlert(message: "Please select an item.")
        //            return
        //        }
        
        if !updatedData.0 && !updatedData.2 {
//            self.showAlert(message: "Please select refund type.")
            //appDelegate.showToast(message: "Please select refund type.")
            //return
        }
        
        let refundselectedArray = orderInfoModelObj.transactionArray.filter({$0.isPartialRefundSelected == true})
        let refundselectedAmountArray = orderInfoModelObj.transactionArray.filter({$0.isPartialRefundSelected == true && $0.partialAmount != ""})
        
        if !updatedData.3 && refundselectedArray.count > 0 {
//            self.showAlert(message: "Please enter partial amount.")
            appDelegate.showToast(message: "Please enter partial amount.")
            return
        }
        
        if updatedData.3 && refundselectedArray.count != refundselectedAmountArray.count {
//            self.showAlert(message: "Please enter partial amount.")
            appDelegate.showToast(message: "Please enter partial amount.")
            return
        }
        
        
        if updatedData.3 && refundselectedArray.count > 0 {
            
            var totalRefundAmount = Double()
            
            for product in orderInfoModelObj.productsArray {
                if product.isRefundSelected || product.isExchangeSelected {
                    totalRefundAmount += product.refundAmount
                }
            }
            totalRefundAmount = Double(totalRefundAmount.roundToTwoDecimal) ?? 0
            
            for transaction in orderInfoModelObj.transactionArray {
                if transaction.isPartialRefundSelected {
                    if (Double(transaction.partialAmount) ?? 0) < totalRefundAmount {
//                        self.showAlert(message: "Transaction amount must be greater than or equal to refunded amount.")
                        //appDelegate.showToast(message: "Transaction amount must be greater than or equal to refunded amount.")
                        //return
                    }
                    
                    if (Double(transaction.partialAmount) ?? 0) > transaction.availableRefundAmount {
//                        self.showAlert(message: "Transaction amount must be less than or equal to refunded amount $\(transaction.availableRefundAmount)")
                        //appDelegate.showToast(message: "Transaction amount must be less than or equal to refunded amount $\(transaction.availableRefundAmount)")
                        //return
                    }
                }
            }
            
        }
        
        if updatedData.3 && refundselectedArray.count > 0 {
            for transaction in orderInfoModelObj.transactionArray {
                if transaction.isPartialRefundSelected && (Double(transaction.partialAmount) ?? 0) > transaction.availableRefundAmount {
//                    self.showAlert(message: "Transaction amount must be less than or equal to refunded amount $\(transaction.availableRefundAmount)")
                    appDelegate.showToast(message: "Transaction amount must be less than or equal to refunded amount $\(transaction.availableRefundAmount)")
                    return
                }
            }
        }
        
        
        if updatedData.0 {
            //showAlert(message: "Feature is not available for this release.")
            //code comment for exchage bcoz work in going on. so that we add dialog // by sudama 14-12-2019
            PaymentsViewController.paymentDetailDict.removeAll()
            
            if let cardDetail = orderInfoModelObj.cardDetail {
                var number = cardDetail.number ?? ""
                
                if number.count == 4 {
                    number = "************" + number
                }
                
                PaymentsViewController.paymentDetailDict["key"] = "CREDIT"
                PaymentsViewController.paymentDetailDict["data"] = ["cardnumber":number,"mm":cardDetail.month, "yyyy":cardDetail.year, "cvv": ""]
            }
            
            let dict: JSONDictionary = ["data":updatedData.4]
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                appDelegate.str_Refundvalue = "refund"
                self.orderInfoDelegate?.didMoveToCartScreen?(with: dict)
            } else {
                appDelegate.str_Refundvalue = "refund"
                self.refundOrder = dict
                self.performSegue(withIdentifier: "cart", sender: nil)
            }
            return
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let dict: JSONDictionary = ["data":updatedData.4]
            self.orderInfoDelegate?.didMoveToCartScreen?(with: dict)
            //self.orderInfoDelegate?.didUpdateRefundScreen?(with: dict)
        } else {
            let dict: JSONDictionary = ["data":updatedData.4]
            appDelegate.str_Refundvalue = "refund"
            self.refundOrder = dict
            self.performSegue(withIdentifier: "cart", sender: nil)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RefundViewController") as! RefundViewController
//            vc.orderInfoModelObj = updatedData.4
//            vc.orderInfoDelegate = self
//            //self.present(vc, animated: true, completion: nil)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func handleOpenCustomAlert(sender: UIButton){
        sender.backgroundColor = #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
//        if sender.tag ==
        let dataTransfer = arrTransactionData[sender.tag] as? NSDictionary
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(handleOpenCustomAlert))
//        let CustomMenu = tipCustomView.alert(title: "String") { [weak self] in
//            //self!.callAPItoGetOrderInfo()
//
//       // self!.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-black"), style: .plain, target: self, action: #selector(self!.handleOpenCustomAlert))
//        }
        
        let storyboard = UIStoryboard(name: "iPad", bundle: nil)
        let CustomMenu = storyboard.instantiateViewController(withIdentifier: "TipViewController") as! TipViewController
        // self.navigationController?.pushViewController(controller, animated: false)
        //self.navigationController?.present(controller, animated: true, completion: nil)
     //   self.transactionID = "#\(transactionInfoArray[indexPath.row].txnId)"
        CustomMenu.delegateTipView = self
        CustomMenu.transactionID = dataTransfer?.value(forKey: "txn_id") as? String ?? ""
        CustomMenu.cardNumber = dataTransfer?.value(forKey: "cardNumber") as? String ?? ""
        CustomMenu.orderId = self.orderID
        CustomMenu.arrTransactionData = dataTransfer as! [String : Any] as NSDictionary //as! NSMutableArray
        self.navigationController?.present(CustomMenu, animated: true, completion: nil)
        //present(CustomMenu, animated: true)
    }
    
    
    private func showHomeScreeen() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as! SWRevealViewController
            appDelegate.window?.rootViewController = controller
            appDelegate.window?.makeKeyAndVisible()
        }else {
            self.setRootViewControllerForIphone()
        }
    }
    
    @objc func handleFullRefundAction(sender: UIButton) {
        self.view.endEditing(true)
        orderInfoModelObj.transactionArray[sender.tag].isFullRefundSelected = true
        orderInfoModelObj.transactionArray[sender.tag].isPartialRefundSelected = false
        orderInfoModelObj.transactionArray[sender.tag].isVoidSelected = false
        orderInfoModelObj.transactionArray[sender.tag].partialAmount = ""
        tableView.reloadData()
        ClearbButtonColorChange()
    }
    
    @objc func handleVoidAction(sender: UIButton) {
        self.view.endEditing(true)
        orderInfoModelObj.transactionArray[sender.tag].isFullRefundSelected = false
        orderInfoModelObj.transactionArray[sender.tag].isPartialRefundSelected = false
        orderInfoModelObj.transactionArray[sender.tag].isVoidSelected = true
        orderInfoModelObj.transactionArray[sender.tag].partialAmount = ""
        tableView.reloadData()
        ClearbButtonColorChange()
    }
    
    func updateRefundAmount() {
        //refundButton.isUserInteractionEnabled = true
        //refundButton.alpha = 1.0
        
        var totalRefundAmount = Double()
        var isForExchange = false
        
        for product in orderInfoModelObj.productsArray {
            if product.isExchangeSelected {
                isForExchange = true
            }
            if product.isRefundSelected || product.isExchangeSelected {
                totalRefundAmount += product.refundAmount
            }
            totalRefundAmount = Double(totalRefundAmount.roundToTwoDecimal) ?? 0
        }
        
        for i in 0..<orderInfoModelObj.transactionArray.count {
            orderInfoModelObj.transactionArray[i].partialAmount = ""
            orderInfoModelObj.transactionArray[i].isPartialRefundSelected = false
            orderInfoModelObj.transactionArray[i].isFullRefundSelected = false
            orderInfoModelObj.transactionArray[i].isVoidSelected = false
        }
        
        var isTransactionFound = false
        
        if totalRefundAmount > 0 {
            for i in 0..<orderInfoModelObj.transactionArray.count {
                if totalRefundAmount < orderInfoModelObj.transactionArray[i].availableRefundAmount {
                    orderInfoModelObj.transactionArray[i].partialAmount = totalRefundAmount.roundToTwoDecimal
                    orderInfoModelObj.transactionArray[i].isPartialRefundSelected = true
                    isTransactionFound = true
                    break
                }
                
                if totalRefundAmount == orderInfoModelObj.transactionArray[i].availableRefundAmount {
                    orderInfoModelObj.transactionArray[i].partialAmount = ""
                    orderInfoModelObj.transactionArray[i].isPartialRefundSelected = false
                    orderInfoModelObj.transactionArray[i].isVoidSelected = false
                    orderInfoModelObj.transactionArray[i].isFullRefundSelected = true
                    isTransactionFound = true
                    break
                }
            }
        }
        
        //        if !isForExchange && !isTransactionFound && totalRefundAmount > 0 {
        //            refundButton.isUserInteractionEnabled = false
        //            refundButton.alpha = 0.5
        //            self.showAlert(message: "No transaction found of refunded amount \(totalRefundAmount.currencyFormat)")
        //        }
        
        
        tableView.reloadData()
        
        //Reload Table
        self.tableView.reloadData {
            self.tableView.contentOffset = .zero
            if !self.isOrderSummery {
                self.tableViewheight.constant = self.view.bounds.size.height - (UI_USER_INTERFACE_IDIOM() == .pad ? 120 : 190)
            }else {
                self.tableView.layoutIfNeeded()
                self.tableViewheight.constant = self.tableView.contentSize.height
            }
        }
    }
}

extension OrderInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return replacementText.isValidDecimal(maximumFractionDigits: 2)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.orderInfoModelObj.transactionArray[textField.tag].partialAmount = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: API Methods
extension OrderInfoViewController {
    func promptForAmountAndClerkID(_ transactiontype:IMSTransactionType, andIsKeyed isKeyed:Bool, andIsWithReader isWithReader:Bool) {
        
        let myamount = "50"
        let clerkIDTF = ""
        
        
        //Indicator.sharedInstance.showIndicator()
        let request:AnyObject? = self.getSampleTransactionRequestwithTotalAmount((orderInfoModelObj.total * 100), andClerkID: clerkIDTF , andType: transactiontype, andIsKeyed: isKeyed, andIsWithReader: isWithReader)
        guard let transactionRequest = request
            else{
                return
        }
        //SVProgressHUD.show(withStatus: "Processing Transaction")
        //appDelegate.showToast(message: "Processing Transaction")
        DispatchQueue.main.async {
            Indicator.sharedInstance.lblIngenico.text = "Processing Transaction"
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                 MainSocketManager.shared.onPaymentMessage(paymentMesssage: "Processing Transaction")
            }
        }
        
        self.myTextField = nil
        self.clerkIDTF = nil
        self.setLastTransactionType(transactiontype)
        self.setLastTransactionID("")
        switch transactiontype{
        case .TransactionTypeCashSale:
            self.ingenico?.payment.processCashTransaction(transactionRequest as! IMSCashSaleTransactionRequest,
                                                          andOnDone: self.doneCallback!)
        case .TransactionTypeCreditSale:
            if isKeyed {
                self.ingenico?.payment.processKeyedTransaction(transactionRequest as! IMSKeyedCardSaleTransactionRequest,
                                                               andOnDone: self.doneCallback!)
            }else if isWithReader {
                self.ingenico?.payment.processCreditSaleTransaction(withCardReader: transactionRequest as! IMSCreditSaleTransactionRequest,
                                                                    andUpdateProgress: self.progressCallback!,
                                                                    andSelectApplication: self.applicationSelectionCallback! ,
                                                                    andOnDone: self.doneCallback!)
            }
            else {
                //SVProgressHUD.dismiss()
                if IMSSecureCardEntryViewController(creditAuthTransactionRequest: transactionRequest as! IMSSCECreditAuthTransactionRequest,
                                                    andUpdateProgress: self.progressCallback!,
                                                    andOnDone: self.doneCallback!) != nil {
                    
                    //appDelegate.showToast(message: "payment inter value")
                    //                            if self.isViewController {
                    //                                let navigationController = IMSNavigationViewController(rootViewController: secureCardEntryViewController)
                    //                                self.present(navigationController, animated: true, completion: nil)
                    //                            }
                    //                            else {
                    //                                self.sceViewController = secureCardEntryViewController
                    //                                self.sceViewController?.view.frame = CGRect(x: 0, y: 0, width: (self.view.bounds.size.width * 90) / 100, height: (self.view.bounds.size.height * 90) / 100)
                    //                                self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissModalView))
                    //                                self.tapGesture?.numberOfTapsRequired = 1
                    //                                self.view.addGestureRecognizer(self.tapGesture!)
                    //                                self.sceViewController?.didMove(toParentViewController: self)
                    //                                self.sceViewController?.view.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
                    //                                self.sceViewController?.view.layer.borderWidth = 1
                    //                                self.sceViewController?.view.layer.borderColor = UIColor.darkGray.cgColor
                    //                                self.addChildViewController(self.sceViewController!)
                    //                                self.view.addSubview((self.sceViewController?.view)!)
                    //                            }
                }
            }
            
        case .TransactionTypeCreditAuth:
            if isKeyed {
                self.ingenico?.payment.processKeyedCreditAuthTransaction(transactionRequest as! IMSKeyedCreditAuthTransactionRequest,
                                                                         andOnDone: self.doneCallback!)
            }else {
                self.ingenico?.payment.processCreditAuthTransaction(withCardReader: transactionRequest as! IMSCreditAuthTransactionRequest ,
                                                                    andUpdateProgress: self.progressCallback!,
                                                                    andSelectApplication: self.applicationSelectionCallback! ,
                                                                    andOnDone: self.doneCallback!)
            }
            
        case .TransactionTypeDebitSale:
            self.ingenico?.payment.processDebitSaleTransaction(withCardReader: transactionRequest as! IMSDebitSaleTransactionRequest,
                                                               andUpdateProgress: self.progressCallback!,
                                                               andSelectApplication: self.applicationSelectionCallback!,
                                                               andOnDone: self.doneCallback!)
        case .TransactionTypeCashRefund:
            self.ingenico?.payment.processCashRefundTransaction(transactionRequest as! IMSCashRefundTransactionRequest,
                                                                andOnDone: self.doneCallback!)
            
        case .TransactionTypeCreditRefund:
            if isKeyed {
                self.ingenico?.payment.processCreditRefundAgainstTransaction(transactionRequest as! IMSCreditRefundTransactionRequest,
                                                                             andOnDone: self.doneCallback!)
            }else{
                self.ingenico?.payment.processCreditRefund(withCardReader: transactionRequest as! IMSCreditCardRefundTransactionRequest,
                                                           andUpdateProgress: self.progressCallback!,
                                                           andSelectApplication: self.applicationSelectionCallback!,
                                                           andOnDone: self.doneCallback!)
            }
            
        case .TransactionTypeCreditAuthCompletion:
            self.ingenico?.payment.processCreditAuthCompleteTransaction(transactionRequest as! IMSCreditAuthCompleteTransactionRequest,
                                                                        andOnDone: self.doneCallback!)
        default:
            break
        }
    }
        
    func getSampleTransactionRequestwithTotalAmount(_ total:Double, andClerkID cID:String?, andType type:IMSTransactionType, andIsKeyed isKeyed:Bool, andIsWithReader isWithReader:Bool)->AnyObject?{
        var clerkID:String?
        
        if(cID == ""){
            clerkID = nil
        }else {
            clerkID = cID
        }
        let taxVal = Double(0.0)
        var totalAmount = orderInfoModelObj.total * 100
        let subTotalVal = orderInfoModelObj.subTotal * 100

        var amount = IMSAmount()
        amount = IMSAmount.init(total: Int(totalAmount), andSubtotal: Int(subTotalVal), andTax: 0, andDiscount: 0, andDiscountDescription: "", andTip: Int(0 * 100), andCurrency: "USD")
        let reverseAmount:IMSAmount = IMSAmount.init(total: Int(totalAmount), andSubtotal: -1, andTax: -1, andDiscount: -1, andDiscountDescription: nil, andTip: -1, andCurrency: "USD")
        
        let card:IMSCard = IMSCard.init(number: "5424180000005550", andExpirationDate: "0123", andCVV: "123", andAVS: "82560", andPOSEntryMode:.POSEntryModeKeyed )
        let products:[IMSProduct] = getSampleProducts()
        
    
        switch type {
        case .TransactionTypeCashSale:
            return IMSCashSaleTransactionRequest.init(amount: amount,
                                                      andProducts: nil,
                                                      andClerkID: clerkID,
                                                      andLongitude: getLongitude(),
                                                      andLatitude: getLatitude(),
                                                      andTransactionGroupID: nil)
            
        case .TransactionTypeCreditSale:
            if isKeyed {
                return IMSKeyedCardSaleTransactionRequest.init(card: card,
                                                               andAmount: amount,
                                                               andProducts: nil,
                                                               andClerkID: clerkID,
                                                               andLongitude: getLongitude(),
                                                               andLatitude: getLatitude(),
                                                               andTransactionGroupID: nil)
            } else if isWithReader {
                if tokenEnrollCheckBox {
                    return IMSCreditSaleTransactionRequest.init(type: .TransactionTypeSale, andAmount: amount, andProducts: nil, andClerkID: clerkID, andLongitude: getLongitude(), andLatitude: getLatitude(), andTransactionGroupID: nil, andTransactionNotes: nil, andMerchantInvoiceID: nil, andShowNotesAndInvoiceOnReceipt: false, andTokenRequestParameters: getTokenRequestParams())

                } else {
                    return IMSCreditSaleTransactionRequest.init(amount: amount,
                                                                andProducts: nil,
                                                                andClerkID: clerkID,
                                                                andLongitude: getLongitude(),
                                                                andLatitude: getLatitude(),
                                                                andTransactionGroupID: nil)
                }
            }
            else {
                return IMSSCECreditAuthTransactionRequest.init(amount: amount,
                                                     andProducts: nil,
                                                     andClerkID: clerkID,
                                                     andLongitude: getLongitude(),
                                                     andLatitude: getLatitude(),
                                                     andTransactionGroupID: nil,
                                                     andTransactionNotes: nil,
                                                     andMerchantInvoiceID: nil,
                                                     andShowNotesAndInvoiceOnReceipt: true,
                                                     andTokenRequestParameters: nil,
                                                     andCustomReference: nil,
                                                     andIsCompleted: false)
            }
        case .TransactionTypeDebitSale:
            return IMSDebitSaleTransactionRequest.init(amount: amount,
                                                       andProducts: nil,
                                                       andClerkID: clerkID,
                                                       andLongitude: getLongitude(),
                                                       andLatitude: getLatitude(),
                                                       andTransactionGroupID: nil)
        case .TransactionTypeCreditAuth:
            if isKeyed {
                return IMSKeyedCreditAuthTransactionRequest.init(card: card,
                                                                 andAmount: amount,
                                                                 andProducts: products,
                                                                 andClerkID: clerkID,
                                                                 andLongitude: getLongitude(),
                                                                 andLatitude: getLatitude(),
                                                                 andTransactionGroupID: nil)
            }else {
                return IMSCreditAuthTransactionRequest.init(amount: amount,
                                                            andProducts: products,
                                                            andClerkID: clerkID,
                                                            andLongitude: getLongitude(),
                                                            andLatitude: getLatitude(),
                                                            andTransactionGroupID: nil)
            }
        case .TransactionTypeCreditAuthCompletion:
            return IMSCreditAuthCompleteTransactionRequest.init(originalSaleTransactionID: getLastTransactionID(),
                                                                andAmount: reverseAmount,
                                                                andProducts: products,
                                                                andClerkID:clerkID,
                                                                andLongitude: getLongitude(),
                                                                andLatitude: getLatitude(),
                                                                andTransactionGroupID: nil)
            
        case .TransactionTypeCashRefund:
            return IMSCashRefundTransactionRequest.init(originalSaleTransactionID: getLastTransactionID(), andAmount: reverseAmount, andClerkID: clerkID, andLongitude: getLongitude(), andLatitude: getLatitude())
            
        case .TransactionTypeCreditRefund:
            if isKeyed {
                return IMSCreditRefundTransactionRequest.init(originalSaleTransactionID: getLastTransactionID(),
                                                              andAmount: reverseAmount,
                                                              andClerkID: clerkID,
                                                              andLongitude: getLongitude(),
                                                              andLatitude: getLatitude())
            }else{
                return IMSCreditCardRefundTransactionRequest.init(amount:reverseAmount,
                                                                  andClerkID: clerkID,
                                                                  andLongitude: getLongitude(),
                                                                  andLatitude: getLatitude())
            }
            
        default:
            return nil
        }
        
        
    }
        
    func getProgressStrFromMessage(_ message:IMSProgressMessage) -> String{
            switch message {
            case .PleaseInsertCard:
                let allowedPOS = Ingenico.sharedInstance()?.paymentDevice.allowedPOSEntryModes()
                if let allowedPOS = allowedPOS as? [Int] {
                    if (allowedPOS.contains(where: {$0 == IMSPOSEntryMode.POSEntryModeContactlessMSR.rawValue}) || allowedPOS.contains(where: {$0 == IMSPOSEntryMode.POSEntryModeContactlessEMV.rawValue})) {
                        if allowedPOS.contains(where: {$0 == IMSPOSEntryMode.POSEntryModeContactEMV.rawValue}) {
                            return "Please insert/tap/swipe card"
                        } else {
                            return "Please tap or swipe card"
                        }
                    } else {
                        return "Please insert or swipe card";
                    }
                }
                return "Please swipe card"
            case .CardInserted:
                return "Card inserted";
            case .ICCErrorSwipeCard:
                return "ICCError swipe card please";
            case .ApplicationSelectionStarted:
                return "Application selection started";
            case .ApplicationSelectionCompleted:
                return "Application selection completed";
            case .FirstPinEntryPrompt:
                return "First Pin prompt";
            case .LastPinEntryPrompt:
                return "Last Pin prompt";
            case .PinEntryFailed:
                return "Pin entry failed";
            case .PinEntryInProgress:
                return "Pin entry in progress";
            case .PinEntrySuccessful:
                return "Pin entry in progress";
            case .RetrytPinEntryPrompt:
                return "Retry Pin entry prompt";
            case .WaitingforCardSwipe:
                return "Waiting for card swipe";
            case .PleaseSeePhone:
                return "Please see phone";
            case .SwipeDetected:
                return "Swipe detected";
            case .SwipeErrorReswipeMagStripe:
                return "Reswipe please";
            case .TapDetected:
                return "Tap detected";
            case .UseContactInterfaceInsteadOfContactless:
                return "Use contact interface instead of contactless";
            case .ErrorReadingContactlessCard:
                return "Error reading contactless card";
            case .DeviceBusy:
                return "Device busy";
            case .CardHolderPressedCancelKey:
                return "Cancel key pressed";
            case .RecordingTransaction:
                return "Recording transaction";
            case .UpdatingTransaction:
                return "Updating transaction";
            case .PleaseRemoveCard:
                return "Please remove card";
            case .RestartingContactlessInterface:
                return "Restarting contactless interface";
            case .GettingOnlineAuthorization:
                return "Getting Online Authorization";
            case .TryContactInterface:
                return "Try contact interface";
            case .ReinsertCard:
                return "Reinsert Card properly";
            case .RestartingTransactionDueToIncorrectPin:
                return "Restarting Transaction Due To Incorrect Pin";
            case .Unknown:
                return "Uknown"
            case .PresentCardAgain:
                return "PresentCardAgain"
            case .CardRemoved:
                return "CardRemoved"
            case .ChipCardSwipFailed:
                //return "ChipCardSwipFailed"
                return "Cannot swipe chip card. Please insert card instead"
            case .ContactlessInterfaceFailedTryContact:
                return "ContactlessInterfaceFailedTryContact"
            case .CardWasBlocked:
                return "CardWasBlocked"
            case .NotAuthorized:
                return "NotAuthorized"
            case .TransactionCompleteRemoveCard:
                return "TransactionCompleteRemoveCard"
            case .RemoveCard:
                return "RemoveCard"
            case .InsertOrSwipeCard:
                return "InsertOrSwipeCard"
            case .TransactionVoid:
                return "TransactionVoid"
            case .CardReadOkRemoveCard:
                return "CardReadOkRemoveCard"
            case .ProcessingTransaction:
                return "ProcessingTransaction"
            case .CardHolderBypassedPIN:
                return "CardHolderBypassedPIN"
            case .NotAccepted:
                return "NotAccepted"
            case .ProcessingDoNotRemoveCard:
                return "ProcessingDoNotRemoveCard"
            case .Authorizing:
                return "Authorizing"
            case .NotAcceptedRemoveCard:
                return "NotAcceptedRemoveCard"
            case .CardError:
                return "CardError"
            case .CardErrorRemoveCard:
                return "CardErrorRemoveCard"
            case .Cancelled:
                return "Cancelled"
            case .CancelledRemoveCard:
                return "CancelledRemoveCard"
            case .TransactionVoidRemoveCard:
                return "TransactionVoidRemoveCard"
            case .UnknownAID:
                return "UnknownAID"
            case .MultipleContactlessCardsDetected:
                return "MultipleContactlessCardsDetected"
            case .SendingReversal:
                return "SendingReversal"
            case .GettingCardVerification:
                return "GettingCardVerification"
            case .FetchingSecureCardEntryContent:
                return "FetchingSecureCardEntryContent"
            case .LoadingSecureCardEntryContent:
                return "LoadingSecureCardEntryContent"
            case .RetrievingDeviceLog:
                return "RetrievingDeviceLog"
            case .WaitingforChipCard:
                return "Waiting for Chip Card";
            case .WaitingforSwipeCard:
                return "Waiting for Swipe Card";
            case .WaitingforChipAndSwipe:
                return "Waiting for Chip And Swipe";
            case .WaitingforTapCard:
                return "Waiting for Tap Card";
            case .WaitingforChipAndTap:
                return "Waiting for Chip And Tap";
            case .WaitingforSwipeAndTap:
                return "Waiting for Swipe And Tap";
            case .WaitingforChipSwipeTap:
                return "Waiting for Chip Swipe Tap";
            case .WaitingforFallbackSwipe:
                return "Waiting for Fallback Swipe";
            case .WaitingforFallbackChip:
                return "Waiting for Fallback Chip";
            case .UpdatingFirmware:
                return "Updating firmware";
            case .SettingUpDevice:
                return "Setting up device";
            case .DownloadingFirmware:
                return "Downloading firmware";
            case .CheckingFirmwareUpdate:
                return "Checking for Firmware Update";
            case .CheckingDeviceSetup:
                return "Checking for Device Setup"
            default:
                return ""
            }
        }
    
    
    func getStrFromPOSEntryMode(_ entryMode: IMSPOSEntryMode)-> String{
        switch (entryMode) {
        case .POSEntryModeKeyed:
            return "Keyed";
        case .POSEntryModeContactEMV:
            return "ContactEMV";
        case .POSEntryModeContactlessEMV:
            return "ContactlessEMV";
        case .POSEntryModeContactlessMSR:
            return "ContactlessMSR";
        case .POSEntryModeMagStripe:
            return "MagStripe";
        case .POSEntryModeMagStripeEMVFail:
            return "MagStripeEMVFail";
        case .POSEntryModeVirtualTerminal:
            return "VirtualTerminal";
        case .POSEntryModeToken:
            return "Token";
        case .POSEntryModeKeyedSwipeFail:
            return "KeyedSwipeFail";
        case .POSEntryModeUnKnown:
            return "Unknown";
        }
    }
    
    func getStrFromCVM(_ cvm:IMSCardVerificationMethod) -> String{
        switch (cvm) {
        case .CardVerificationMethodPin:
            return "Pin";
        case .CardVerificationMethodSignature:
            return "Signature";
        case .CardVerificationMethodPinAndSignature:
            return "PinAndSignature";
        case .CardVerificationMethodNone:
            return "None";
        }
        
    }
    
    func getTokenRequestParams() -> IMSTokenRequestParameters? {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yy-MM-dd HH:mm:ss"
        let timestamp = format.string(from: date)
        
        let strName = timestamp.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        let newString = strName.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let newName = newString.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
        appDelegate.strRefId = "\(newName)"
        let builder = IMSTokenRequestParametersBuilder()
        builder.tokenReferenceNumber = newName
        builder.tokenFeeInCents = 0 //Int(tokenFeeTF!.text ?? "") ?? 0
        //builder.cardholderLastName = "appleseed"
        //builder.cardholderFirstName = "john"
        //builder.billToEmail = "john.appleseed@example.com"
        //builder.billToAddress1 = "1 Federal St"
        //builder.billToAddress2 = "Suite 1"
        //builder.billToCity = "Boston"
        //builder.billToState = "MA"
        //builder.billToCountry = "USA"
        //builder.billToZip = "02110"
        builder.ignoreAVSResult = true
        if ((transactionType == .TransactionTypeTokenEnrollment && canEnrollToken) || tokenEnrollCheckBox == true ) {
            return builder.createTokenEnrollmentRequestParameters()
        }
        return nil
    }

    
    func getSignatureOrUpdateTransaction(_ response: IMSTransactionResponse){
//        self.placeOrder(isAuth: false, isSwiped: false)
        Indicator.sharedInstance.hideIndicator()
        //placeOrder()
        sendIngenicoCardData(with: "authcapture", isIPad: true, data: IngenicoDataResponce)
    }
    
    func sendIngenicoCardData(with key: String, isIPad: Bool, data: Any) {
        
        print(data)
        let ingenicoData = data as! IMSTransactionResponse
        //txfAmount.text = "\(ingenicoData.submittedAmount.total)"
        let numnber = ingenicoData.redactedCardNumber
        var expYear = ""
        var expmounth = ""
        let hh = ingenicoData.transactionType
        
        if ingenicoData.cardExpirationDate == "" || ingenicoData.cardExpirationDate == nil {
            expYear = ""
            expmounth = ""
        } else {
            expYear = "\(ingenicoData.cardExpirationDate.prefix(2))"
            expmounth = "\(ingenicoData.cardExpirationDate.suffix(2))"
        }
        
        let amt = Double(ingenicoData.submittedAmount.total - ingenicoData.submittedAmount.tip)/100
        var transaction : [String:Any]
        var transactionCode = ""
        if ingenicoData.transactionResponseCode.rawValue == 2  {
            transactionCode = "declined"
        } else if ingenicoData.transactionResponseCode.rawValue == 1 {
            transactionCode = "approved"
        }
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = format.string(from: date)
        
        let strName = timestamp.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        let newString = strName.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let newName = newString.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
        var entryMode = ""
        var strBPID = ""
        let transactionTokendata = ["token_response_code":ingenicoData.tokenResponseParameters.responseCode.rawValue ,
                                    "token_id":ingenicoData.tokenResponseParameters.tokenIdentifier ?? "",//"IdToken-\(newName)",//ingenicoData.tokenResponseParameters.tokenIdentifier ?? "",
                                    "source":ingenicoData.tokenResponseParameters.tokenSource ?? "",
                                    "tokensourcedata":ingenicoData.tokenResponseParameters.tokenSourceData ?? "",
                                    "tokenfeeincents":ingenicoData.tokenResponseParameters.tokenFeeInCents,
                                    "systemtokenRefId":appDelegate.strRefId] as? [String : Any]
        
        if ingenicoData.posEntryMode == .POSEntryModeToken {
            entryMode = "POSEntryModeToken"
            strBPID = appDelegate.strIngenicoBPID
        }
        let cardTypeData = self.getStringFromCardType(type: ingenicoData.cardType)
        
        transaction = [ "authorization_code": ingenicoData.authCode ?? "",
                        "authorized_amount": Double(ingenicoData.authorizedAmount)/100 ,
                        "avs_response": "Unknown",
        "batch_number": ingenicoData.batchNumber ?? "",
        "card_type": cardTypeData,
        "clerk_display": ingenicoData.clerkDisplay ?? "",
        "client_transaction_id": ingenicoData.clientTransactionID ?? "",
        "currency_code": ingenicoData.submittedAmount.currency ?? "",
        "customer_display": ingenicoData.customerDisplay ?? "",
        "cvd_response": "Unknown",
        "expiration_date": ingenicoData.cardExpirationDate ?? "",
        "mcm_transaction_id": ingenicoData.transactionID ?? "",
        "original_amount": Double(ingenicoData.submittedAmount.total)/100,
        "primary_account_number_masked": ingenicoData.redactedCardNumber ?? "" ,
        "request_transaction_code": "CreditSale",
        "sequence_no": ingenicoData.sequenceNumber ?? "",
        "transaction_amount": Double(ingenicoData.submittedAmount.total)/100,
        "transaction_code":transactionCode,
        "transaction_group_id": ingenicoData.transactionGroupID ?? "",
        "transaction_id": ingenicoData.transactionGUID ?? "",
        "cardholderName": ingenicoData.cardholderName ?? "",
        "error_code": appDelegate.strIngenicoErrorMsg,
        "entry_Mode": entryMode,
        "token_bill_id": strBPID,
        "token_service_response": transactionTokendata ?? [:]]

        let transactiondata = ["transaction":transaction]
        
        let Obj = ["cardnumber":numnber,"mm":expmounth, "yyyy":expYear, "amount": amt, "cvv":"", "auth":"AUTH_CAPTURE", "orig_txn_response":ingenicoData.description, "merchant": "ingenico", "txn_response": transactiondata] as [String : Any]
        //delegate?.getPaymentData?(with: Obj)

        self.dataSetOnOrderAPI(with: Obj)
        if UI_USER_INTERFACE_IDIOM() == .pad {
          //  self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func getStringFromCardType(type:IMSCardType)->String{
        
        let typeString :String
        switch type {
        case .CardTypeAMEX:
            typeString = "amx"
        case .CardTypeDiners:
            typeString = "dine"
        case .CardTypeDiscover:
            typeString = "disc"
        case .CardTypeJCB:
            typeString = "jcb"
        case .CardTypeMasterCard:
            typeString = "mast"
        case .CardTypeVISA:
            typeString = "visa"
        case .CardTypeMaestro:
            typeString = "mast"
        default:
            typeString = ""
        }
        return typeString as String
    }
    
    func dataSetOnOrderAPI(with dict: JSONDictionary) {
        var total = orderInfoModelObj.total
        if UI_USER_INTERFACE_IDIOM() == .phone {
//            switch paymentName {
//            case "credit":
//                total += tipAmountCreditCard
//                break
//            case "multi_card":
//                total += tipAmountMulticard
//                break
//            case "pax_pay":
//                total += (Double(paxtip) ?? 0.0)
//                break
//            default: break
//            }
        }
        
        var str_CreditCardNumber = dict["cardnumber"]as? String ?? ""
        var str_MM = dict["mm"] as? String ?? ""
        var str_YYYY = dict["yyyy"] as? String ?? ""
        var str_CVV = dict["cvv"] as? String ?? ""
        var str_Auth = dict["auth"] as? String ?? ""
        var strSplitPayAmount = "\(dict["amount"] as? Double ?? 0)"
        var orig_txn_response = dict["orig_txn_response"] as? String ?? ""
        var merchant = dict["merchant"] as? String ?? ""
        var txn_response = dict["txn_response"] as? JSONDictionary ?? JSONDictionary()
        let datacardholderName = txn_response["transaction"] as? JSONDictionary ?? JSONDictionary()
        var cardholderName = datacardholderName["cardholderName"] as? String ?? ""
        
        //Prepare Parameters For Create Order
        var parameters = Parameters()
        
//        if !str_CreditCardNumber.contains("*")   && !self.isBillingProfileIDSetError {
//            CustomerObj.str_bpid = ""
//        } else {
//            if merchant == "" {
//                if paymentName == "credit"{
//                    if DataManager.CardCount > 1 {
//                        if !str_CreditCardNumber.contains("*") {
//                            if isBillingProfileIDSetError {
//                                CustomerObj.str_bpid = DataManager.ErrorBbpid
//                            } else {
//                                CustomerObj.str_bpid = ""
//                            }
//                            //CustomerObj.str_bpid = ""
//                        } else {
//                            CustomerObj.str_bpid = DataManager.Bbpid
//                        }
//
//                    } else {
//                        if str_CreditCardNumber.contains("*") {
//                            CustomerObj.str_bpid =  CustomerObj.str_bpid
//                        } else {
//                            if isBillingProfileIDSetError {
//                                CustomerObj.str_bpid = DataManager.ErrorBbpid
//                            } else {
//                                CustomerObj.str_bpid = ""
//                            }
//
//                        }
//                        //CustomerObj.str_bpid = DataManager.Bbpid
//                    }
//
//                } else {
//                    if isBillingProfileIDSetError {
//                        if paymentName == "credit"{
//                            CustomerObj.str_bpid = DataManager.Bbpid
//                        } else {
//                            // if DataManager.customerId == "" {
//                            CustomerObj.str_bpid = DataManager.ErrorBbpid
//                            // } else {
//                            //CustomerObj.str_bpid = ""
//                            // }
//
//                        }
//                        //CustomerObj.str_bpid = DataManager.Bbpid
//                    } else {
//                        CustomerObj.str_bpid = ""
//                    }
//                }
//                //CustomerObj.str_bpid = DataManager.Bbpid
//            } else {
//                if str_CreditCardNumber.contains("X") {
//                    CustomerObj.str_bpid = DataManager.Bbpid
//                } else if str_CreditCardNumber.contains("*") {
//                    if self.isBillingProfileIDSetError {
//                        CustomerObj.str_bpid = DataManager.Bbpid
//                    } else {
//                        CustomerObj.str_bpid = ""
//                    }
//                } else {
//                    CustomerObj.str_bpid = ""
//                }
//            }
//        }
        var nameSource = ""
        
        if let name = DataManager.deviceNameText {
            nameSource = name

        }else {
            let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
            nameSource = nameDevice
        }
        
        let starMacAddrs = DataManager.isGooglePrinter ? DataManager.starCloudMACaAddress ?? "" : ""

        parameters = [
            "cust_id": orderInfoModelObj.userID,
            "customer_status": "",
            "customer_info": [
                "first_name": orderInfoModelObj.firstName,
                "last_name": orderInfoModelObj.lastName,
                "email": orderInfoModelObj.str_email,
                "phone": orderInfoModelObj.str_phone,
                "company":orderInfoModelObj.companyName,
                "address": orderInfoModelObj.addressLine1,
                "address2": orderInfoModelObj.addressLine2,
                "city": orderInfoModelObj.city,
                "state": orderInfoModelObj.region,
                "zip":orderInfoModelObj.postalCode,
                "country": orderInfoModelObj.country,
                "office_phone":orderInfoModelObj.str_phone,
                "contact_source": "",
            ],
            "bill_profile_id": "",
            "billing_info": [
                "bill_first_name": orderInfoModelObj.str_first_name,
                "bill_last_name": orderInfoModelObj.str_last_name,
                "bill_address_1": orderInfoModelObj.addressLine1,
                "bill_address_2": orderInfoModelObj.addressLine2,
                "bill_city": orderInfoModelObj.city,
                "bill_region": orderInfoModelObj.region,
                "bill_country": orderInfoModelObj.country,
                "bill_postal_code": orderInfoModelObj.postalCode,
                "bill_email": orderInfoModelObj.email,
                "bill_phone": orderInfoModelObj.str_phone,
                "bill_company":orderInfoModelObj.companyName
            ],
            "shipping_info": [
                "ship_first_name": orderInfoModelObj.shippingFirstName,
                "ship_last_name": orderInfoModelObj.shippingLastName,
                "ship_address_1": orderInfoModelObj.shippingAddressLine1,
                "ship_address_2": orderInfoModelObj.shippingAddressLine2,
                "ship_city": orderInfoModelObj.shippingCity,
                "ship_region": orderInfoModelObj.shippingRegion,
                "ship_country": orderInfoModelObj.shippingCountry,
                "ship_postal_code": orderInfoModelObj.shippingPostalCode,
                "ship_email": orderInfoModelObj.shippingEmail,
                "ship_phone": orderInfoModelObj.shippingPhone
            ],
            "is_billing_same": DataManager.isCheckUncheckShippingBilling,
            "cart_info": [
                "coupon": orderInfoModelObj.couponTitle,
                "products": orderInfoModelObj.newProductArray,
                "subtotal": orderInfoModelObj.subTotal.roundToTwoDecimal,
                "discount": "",
                "manual_discount":orderInfoModelObj.discount,
                "shipping_handling": "",
                "tax": "",
                "custom_tax_id": orderInfoModelObj.customTax,
                "total": "\(total)",
                "reward_points" : DataManager.finalLoyaltyDiscount
            ],
            "merchant_id": "",
            "payment_type": "credit",
            "payment_method": "AUTH_CAPTURE",
            "custom_text_1": orderInfoModelObj.cust_customer1,
            "custom_text_2": orderInfoModelObj.cust_customer2,
            "isSplitPayment" : DataManager.isSplitPayment,
            "credit": [
                "amount": orderInfoModelObj.total,
                "cc_account": str_CreditCardNumber,
                "cc_exp_mo": str_MM,
                "cc_exp_yr": str_YYYY,
                "cc_cvv": str_CVV,
                "tip": "",
                "total": orderInfoModelObj.total,
                "digital_signature": "",
                "orig_txn_response": orig_txn_response,
                "merchant": merchant,
                "merchant_id": "",
                "txn_response": txn_response
            ],
            "cash": [
                "amount": "",
                "tip": "",
                "total": "",
                "digital_signature": ""
            ],
            "invoice": [
                "po_number": "",
                "terms": "",
                "rep": "",
                "invoice_date": "",
                "tip": "",
                "total": "",
                "notes": ""
            ],
            "ach_check": [
                "routing_number": "",
                "account_number": "",
                "dl_number": "",
                "amount": "",
                "dl_state": "",
                "check_type": "",
                "sec_code": "",
                "account_type": "",
                "tip": "",
                "total": "",
                "digital_signature": ""
            ],
            "gift_card": [
                "gift_card_number": "",
                "gift_card_pin": "",
                "amount": "",
                "tip": "",
                "total": "",
                "digital_signature": ""
            ],
            "external_gift": [
                "gift_card_number": "",
                "amount": "",
                "tip": "",
                "total": "",
                "digital_signature": ""
            ],
            "internal_gift_card": [
                "gift_card_number": "",
                "amount": "",
                "tip": "",
                "total": "",
                "digital_signature": ""
            ],
            "multi_card": "",
            "check": [
                "amount": "",
                "check_number": "",
                "tip": "",
                "total": "",
                "digital_signature": ""
            ],
            "external": [
                "amount": "",
                "tip": "",
                "total": "",
                "digital_signature": "",
                "external_approval_number": ""
            ],
            "pax_pay": [
                "pax_payment_type": "",
                "pax_url": "",
                "device_name": "",
                "tip": "",
                //"amount": paxTotal,
                "pax_pay_receipt" : DataManager.isSingatureOnEMV,
                "use_token" : "",
                "user_pax_token" : "",
                "amount": "",
                "digital_signature": ""
            ],
            "order_source": nameSource,
            "digital_signature": "", //self.signatureImage?.base64(format: .png) ?? "",
            "orderId": orderInfoModelObj.orderID,
            "notes": "",
            "campaign_code": "",
            "sub_id": "",
            "crm_partner_order_id": "",
            "enable_split_row": DataManager.isSplitRow,
            
            "order_shipment": [
                "carrier" : DataManager.selectedCarrierName ?? "",
                "service" :  DataManager.selectedServiceName ?? "",
                "service_id" : DataManager.selectedServiceId ?? "",
                "fulfillment_id" : DataManager.selectedFullfillmentId ?? "",
                "length" : DataManager.shippingLength,
                "width" : DataManager.shippingWidth,
                "height" :   DataManager.shippingHeight,
                "weight" :  DataManager.shippingWeight,
            ],
            "isOfflineTransction" : false,   // by sudama offline
            "cloud_printer_app_status" : DataManager.isGooglePrinter,
            "cloud_printer_address" : starMacAddrs
        ]
                
        print("****************************************************** Order Parameters Start ******************************************************")
        print(parameters)
        print("****************************************************** Order Parameters End ******************************************************")
        
        //Call API To Make Order
        self.callAPIToCreateOrder(parameters: parameters, isInvoice: false, isAllManualProducts: false)
    }
    
    func callAPIToCreateOrder(parameters: JSONDictionary, isInvoice: Bool, isAllManualProducts: Bool) {
        Indicator.sharedInstance.hideIndicator()
        Indicator.sharedInstance.showIndicator()
        
        Indicator.sharedInstance.hideIndicator()
        Indicator.isEnabledIndicator = false
        
        Indicator.sharedInstance.showIndicatorGif(false)
        
        //Indicator.sharedInstance.showIndicator()
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            
            let selectedPayment = (parameters["payment_type"] as? String ?? "").uppercased()
            // by sudama offline
            //            if !offlinePaymentArray.contains(selectedPayment) {
            //                self.delegate?.didOpenErrorAlert?(identifier: selectedPayment)
            //                return
            //            }
        }
        
        //Save Order For Future Check
//        let recentOrder = parameters.filter({$0.key == "cust_id" || $0.key == "customer_info" || $0.key == "bill_profile_id" || $0.key == "billing_info" || $0.key == "shipping_info" || $0.key == "is_billing_same" || $0.key == "cart_info" || $0.key == "order_source" || $0.key == "notes" })
//        DataManager.recentOrder = recentOrder
//
//        var isMulticard = false
//
//        if let key = parameters["payment_type"] as? String , key == "multi_card" {
//            isMulticard = true
//        }
        
        
//        if DataManager.isSplitPayment {
//            if DataManager.allowZeroDollarTxn  == "true"{
//                if let key = parameters["payment_type"] as? String , key == "cash" {
//                    if totalAmount > 0 && (Double(str_Cash.replacingOccurrences(of: "$", with: "")) ?? 0 > 0) {
//
//                    } else if totalAmount == 0 && (Double(str_Cash.replacingOccurrences(of: "$", with: "")) ?? 0 >= 0) {
//
//                    } else {
//                        appDelegate.showToast(message: "Please Enter valid Amount")
//                        Indicator.sharedInstance.hideIndicator()
//                        return
//                    }
//
//                } else if let key = parameters["payment_type"] as? String , key == "invoice" {
//                    if totalAmount > 0  {
//
//                    } else if totalAmount == 0  {
//
//                    } else {
//                        appDelegate.showToast(message: "Please Enter valid Amount")
//                        Indicator.sharedInstance.hideIndicator()
//                        return
//                    }
//                } else {
//                    if totalAmount > 0 && (Double(strSplitAmount) ?? 0 > 0) {
//
//                    } else if totalAmount == 0 && (Double(strSplitAmount) ?? 0 >= 0) {
//
//                    } else {
//                        appDelegate.showToast(message: "Please Enter valid Amount")
//                        Indicator.sharedInstance.hideIndicator()
//                        return
//                    }
//                }
//
//
//            }else{
//
//                if let key = parameters["payment_type"] as? String , key == "cash" {
//                    if (Double(str_Cash.replacingOccurrences(of: "$", with: "")) ?? 0 > 0) {
//
//                    }else{
//                        appDelegate.showToast(message: "Please Enter Amount greater than 0")
//                        Indicator.sharedInstance.hideIndicator()
//                        return
//                    }
//                }else{
//                    if (Double(strSplitAmount) ?? 0 > 0) {
//
//                    }else{
//                        appDelegate.showToast(message: "Please Enter Amount greater than 0")
//                        Indicator.sharedInstance.hideIndicator()
//                        return
//                    }
//                }
//
//
//            }
//        } else {
//
//            if DataManager.allowZeroDollarTxn  == "true" {
//                if let key = parameters["payment_type"] as? String , key == "cash" {
//                    if (Double(str_Cash.replacingOccurrences(of: "$", with: "")) ?? 0 >= 0) {
//
//                    }
//                }else{
//                    if totalAmount >= 0 {
//
//                    }
//                }
//
//
//            } else {
//                if totalAmount == 0 {
//                    appDelegate.showToast(message: "Order cann't be processed with zero total.")
//                    Indicator.sharedInstance.hideIndicator()
//                    return
//                }
//            }
//        }
        
//        if orderType == .newOrder {
//            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
//
//                var selectedPaymentType = (parameters["payment_type"] as? String ?? "").uppercased()
//                if (merchant == "ingenico" && paymentName == "credit"){
//                    selectedPaymentType = "Ingenico"
//                }
//                if selectedPaymentType == "PAX PAY" || selectedPaymentType == "pax pay" || selectedPaymentType == "pax_pay" || selectedPaymentType == "PAX_PAY"{
//                    selectedPaymentType = "pax_pay"
//                }
//                MainSocketManager.shared.onOrderProcessignloader(paymentType: selectedPaymentType)
//
//            }
//        }
        //Call API
        
        HomeVM.shared.createOrder(parameters: parameters, isInvoice: false,isMulticard: false) { (success, message, error) in
            
            if DataManager.tempSignature {
                DataManager.signature = true
                DataManager.tempSignature = false
            }
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                appDelegate.isErrorCreateOrderCase = false
                //self.isBillingProfileIDSetError = false
                HomeVM.shared.errorTip = 0.0
//                if !HomeVM.shared.userData.isEmpty {
//                    self.OrderedData = HomeVM.shared.userData
//
//                    if DataManager.isBalanceDueData == false {
//                        HomeVM.shared.userData.removeAll()
//                    }
//                }
                
//                if self.paymentName == "pax_pay" {
//                    DataManager.selectedPaxDeviceName = self.paxDevice
//                }
                
//                if DataManager.isBalanceDueData == false {
//                    PaymentsViewController.paymentDetailDict.removeAll()
//                    self.resetAllCartData()
//                    //DataManager.selectedPaxDeviceName = ""
//                } else {
//                    if self.paymentName == "pax_pay" {
//                        DataManager.selectedPaxDeviceName = self.paxDevice
//                    }
//                }
                if UI_USER_INTERFACE_IDIOM() == .phone {
//                    if self.str_AUTH == "AUTH"{
//                        let storyboard = UIStoryboard.init(name: "iPad", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "AuthorizeViewController") as! AuthorizeViewController
//                        vc.Orderedobj = self.OrderedData
//                        self.present(vc, animated: true, completion: nil)
//                    }else{
//                        self.performSegue(withIdentifier: "order", sender: nil)
//                    }
                    
                }else{
                    
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
                    vc.total = self.orderInfoModelObj.total
                    vc.subTotal = self.orderInfoModelObj.subTotal
                    vc.OrderedData = HomeVM.shared.userData
                    vc.paymentType = "credit"
                    //vc.tax = str_TaxAmount.toDouble()?.rounded(toPlaces: 2) ?? 0.0
                    vc.discountV = self.orderInfoModelObj.discount.roundToTwoDecimal
                    vc.tip = 0.0
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    //self.delegate?.didMoveToSuccessScreen?(totalAmount: self.paymentName == "multi_card" ? Double(self.tipAmountMulticard + self.totalAmount) : self.totalAmount, orderedData: self.OrderedData, paymentName: self.paymentName)
                }
            } else {
//                DataManager.isBalanceDueData = true
//               // self.isBillingProfileIDSetError = true
//                if UI_USER_INTERFACE_IDIOM() == .pad {
//                    appDelegate.isErrorCreateOrderCase = true
//                    appDelegate.strErrorMsg = message ?? ""
//                    if self.paymentName.lowercased() == "credit" {
//                        self.delegate?.enableCreditCardDelegate?()
//                    }
//                    self.delegate?.gettingErrorDuringPayment?(isMulticard: isMulticard, message: message, error: error)
//                }else {
//                    if let obj = DataManager.cartData!["balance_due"] as? Double{
//                        self.totalAmount = obj
//                        let ob =  DataManager.cartData!["balance_due"] as! Double
//                        self.multiCardTotalLabel.text = "$" + String(obj)
//                        self.payButton.setTitle("Charge" + "$" + String(obj) , for: .normal)
//                        if appDelegate.amount > 0  { // for iphone error SSUU
//                            self.multicardDelegate?.didUpdateRemainingAmt?(RemainingAmt: appDelegate.amount)
//                            self.creditcardiPhoneDelegate?.didUpdateRemainingAmt?(RemainingAmt: appDelegate.amount )
//                            self.ingenicoDelegate?.didUpdateRemainingAmt?(RemainingAmt: appDelegate.amount)
//                            self.payButton.setTitle("Charge" + "$" + String(appDelegate.amount) , for: .normal)
//                        }else{
//                            self.ingenicoDelegate?.didUpdateRemainingAmt?(RemainingAmt: DataManager.cartData!["balance_due"] as! Double)
//                            self.multicardDelegate?.didUpdateRemainingAmt?(RemainingAmt: DataManager.cartData!["balance_due"] as! Double )
//                            self.creditcardiPhoneDelegate?.didUpdateRemainingAmt?(RemainingAmt: DataManager.cartData!["balance_due"] as! Double )
//                            self.payButton.setTitle("Charge" + "$" + String(obj) , for: .normal)
//                        }
//                        //  self.multicardDelegate?.didUpdateRemainingAmt?(RemainingAmt: DataManager.cartData!["balance_due"] as! Double )
//                        // self.creditcardiPhoneDelegate?.didUpdateRemainingAmt?(RemainingAmt: DataManager.cartData!["balance_due"] as! Double )
//                    }
//
//                    print("call here delegate")
//                    if self.paymentName.lowercased() == "credit" {
//                        self.creditCardDelegate?.enableCreditCardDelegate?()
//                    }
//
//                    if isMulticard {
//                        self.multicardDelegate?.gettingErrorDuringPayment?(isMulticard: isMulticard, message: message, error: error)
//                    }else {
//                        if message != nil {
//                            //                            self.showAlert(message: message!)
//                            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
//                                MainSocketManager.shared.onPaymentError(errorMessage: message!)
//                            }
//
//                            appDelegate.showToast(message: message!)
//                        }else {
//                            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
//                                MainSocketManager.shared.onPaymentError(errorMessage: error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg)
//                            }
//                            self.showErrorMessage(error: error)
//                        }
//
//                    }
//                }
            }
        }
    }
    
    func getStringFromResponse(_ resp: IMSTransactionResponse?) ->String {
        guard  let response = resp else {
            return "Response is empty"
        }
        return response.description
    }
    
    func getSampleProducts()->[IMSProduct]{
        
        let image = UIImage.init(named: "product_image.png")
        return [IMSProduct.init()]
    }
    
    
    func getSampleCardholderInfo()->IMSCardholderInfo{
        return IMSCardholderInfo.init(firstName: "ingenico",
                                      andLastName: "mobilesolution",
                                      andMiddleName: "ims",
                                      andEmail: "ims@ims",
                                      andPhone: nil,
                                      andAddress1: nil,
                                      andAddress2: nil,
                                      andCity: nil,
                                      andState: nil,
                                      andPostalCode: nil)
    }
    
    
    func showAmountAlertControllerWithAction(_ action:UIAlertAction, andMessage message:String){
        
        let alertController:UIAlertController = UIAlertController.init(title: "Input Amount", message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Normalized Amount"
            self.myTextField = textField
        }
        alertController.addTextField { (textField) in
            textField.keyboardType = .default
            textField.placeholder = "ClerkID(Optional)"
            self.clerkIDTF = textField
        }
        alertController.addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func updateTranasctionWithTransactionResponse(_ response: IMSTransactionResponse){
        
        ingenico?.user.updateTransaction(withTransactionID: response.transactionID, andCardholderInfo:getSampleCardholderInfo(), andTransactionNote: nil, andIsCompleted: true, andDisplayNotesAndInvoice: true, andOnDone: { (error) in
            if error == nil{
                self.consoleLog(String("Update transaction succeeded"))
            } else {
                let nserror = error as NSError?
                self.consoleLog(String("Update transaction Failed with error\(self.getResponseCodeString((nserror?.code)!))"))
            }
            //self.sendReceipt(response.transactionID)
        })
    }
    
    func sendReceipt(_ transactionID:String){
        
        ingenico?.user.sendEmailReceipt(transactionID, andEmailAddress: "ims@ims.com", andOnDone: { (error) in
            if error == nil {
                self.consoleLog( "send email receipt succeeded\n")
            }else {
                let nserror = error as NSError?
                self.consoleLog("send email receipt failed with error:\(self.getResponseCodeString((nserror?.code)!))")
            }
        })
    }
    
    func doVoidTransaction() {
        if ((self.getLastTransactionType() != .TransactionTypeCreditSale &&
            self.getLastTransactionType() != .TransactionTypeDebitSale &&
            self.getLastTransactionType() != .TransactionTypeCreditAuth &&
            self.getLastTransactionType() != .TransactionTypeCreditAuthCompletion) || self.getLastTransactionID() == nil) {
            self.showErrorMessage("Please do a Credit/Debit/Auth/authComplete Transaction First", andErrorTitle: "Error")
        }
        else {
            let okAction:UIAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
                if (self.clerkIDTF.text?.count)! > 4{
                    self.showErrorMessage("ClerkID is up-to 4 alphanumerics", andErrorTitle: "Error")
                }else {
                    self.view.endEditing(true)
                    let clerkID:String? = (self.clerkIDTF.text == "") ? nil: self.clerkIDTF.text;
                    //SVProgressHUD.show(withStatus: "Processing Transaction")
                    //appDelegate.showToast(message: "Processing Transaction")
                    DispatchQueue.main.async {
                        Indicator.sharedInstance.lblIngenico.text = "Processing Transaction"
                        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                             MainSocketManager.shared.onPaymentMessage(paymentMesssage: "Processing Transaction")
                        }
                    }
                    let transactionRequest:IMSVoidTransactionRequest = IMSVoidTransactionRequest.init(
                        originalSaleTransactionID: self.getLastTransactionID(),
                        andClerkID: clerkID ,
                        andLongitude: self.getLongitude(),
                        andLatitude: self.getLatitude())
                    self.setLastTransactionType(.TransactionTypeUnknown)
                    self.clerkIDTF = nil
                    self.ingenico?.payment.processVoidTransaction(transactionRequest, andOnDone: self.doneCallback!)
                }
            })
            
            let alertController:UIAlertController = UIAlertController.init(title: "Enter ClerkID", message: "Please provide clerkID", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.keyboardType = .default
                textField.placeholder = "ClerkID(Optional)"
                self.clerkIDTF = textField
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showErrorMessage (_ errorMessage:String, andErrorTitle errortitle:String){
        
        let controller:UIAlertController = UIAlertController.init(title: errortitle, message: errorMessage, preferredStyle: .alert)
        let action:UIAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func dismissModalView() {
        sceViewController?.view.removeFromSuperview()
        sceViewController?.removeFromParentViewController()
        sceViewController = nil;
        if (tapGesture != nil) {
            self.view.removeGestureRecognizer(tapGesture!)
            tapGesture = nil
        }
    }
    
    
    func doTestTransactionWihtNumber(_ number:Int) {
        self.view.endEditing(true)
        let request:IMSCreditSaleTransactionRequest = getSampleTransactionRequestwithTotalAmount(100,
                                                                                                 andClerkID: nil,
                                                                                                 andType:.TransactionTypeCreditSale,
                                                                                                 andIsKeyed: false, andIsWithReader: true) as! IMSCreditSaleTransactionRequest
        ingenico?.payment.processCreditSaleTransaction(withCardReader: request, andUpdateProgress: { (message, extraMessage) in
            
        }, andSelectApplication: { (applicationList, error, appResponse) in
            appResponse!(applicationList?[0] as? RUAApplicationIdentifier)
        }, andOnDone: { (response, error) in
            if error == nil {
                self.consoleLog("Card Transaction  number \(number) Response:\n\(self.getStringFromResponse(response!))")
                if response?.transactionID != nil{
//                    self.ingenico?.payment.signatureCapturedElseWhere((response?.transactionID)!)
                }else {
                    let nserror = error as NSError?
                    self.consoleLog("Card Transaction failed with error code \((self.getResponseCodeString((nserror?.code)!)))")
                }
                if number < 100 {
                    let newNumber:Int = number + 1
                    Thread.sleep(forTimeInterval: 5.0)
                    self.doTestTransactionWihtNumber(newNumber)
                }
            }else {
                let nserror = error as NSError?
                //SVProgressHUD.showError(withStatus: "Failed with error: \(self.getResponseCodeString((nserror?.code)!))")
                appDelegate.showToast(message: "Failed with error: \(self.getResponseCodeString((nserror?.code)!))")
            }
            
        })
        
    }
    
    
    func getPendingSignatureTransaction(){
        ingenico?.payment.getPendingTransactions({ transactions, error in
            if (error == nil) {
                let pendingTransactions = transactions as! [IMSPendingTransaction]
//                self.consoleLog("getPendingTransactions success")
            }
            else {
            }
        })
//        if let txnID:String = (ingenico?.payment.getReferenceForTransactionWithPendingSignature()){
//            let controller:UIAlertController = UIAlertController.init(title: "Select Action", message: String.init(format: "Please select action for pending signature transaction: %@", txnID), preferredStyle: .alert)
//            let uploadAction:UIAlertAction = UIAlertAction.init(title: "Upload Signature", style: .default, handler: { (action) in
//                
//                self.uploadSignature()
//                
//            })
//            let elsedaction:UIAlertAction = UIAlertAction.init(title: "SignatureCapturedElseWhere", style: .default, handler: { (action) in
//                self.ingenico?.payment.signatureCapturedElseWhere(txnID)
//                //SVProgressHUD.showError(withStatus: "Clear pending signature transaction succeeded")
//                appDelegate.showToast(message: "Clear pending signature transaction succeeded")
//                self.consoleLog("Clear pending Signature transaction succeeded")
//            })
//            let voidAction:UIAlertAction = UIAlertAction.init(title: "Void", style: .default, handler: { (action) in
//                self.setLastTransactionID(txnID)
//                self.doVoidTransaction()
//            })
//            let dismissAction:UIAlertAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
//            controller.addAction(voidAction)
//            controller.addAction(uploadAction)
//            controller.addAction(elsedaction)
//            controller.addAction(dismissAction)
//            self.present(controller, animated: true, completion: nil)
//        }
    }
    
    
    func uploadSignature(){
        self.consoleLog("Uploading signature Succeeded")
    }
}

//MARK: API Methods
extension OrderInfoViewController {
    func callAPItoGetOrderInfo() {
        
        DataManager.isCaptureButton = false
        
        if orderID == "" {
            return
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            Indicator.isEnabledIndicator = false
            Indicator.sharedInstance.showIndicator()
        }
        
        self.noTransactionFoundImageView.isHidden = true
        //self.refundButton.isUserInteractionEnabled = true
        //self.refundButton.alpha = 1.0
        let addKey = "/?source=web"
        //Call API
        OrderVM.shared.getOrderInfo(orderId: "\(orderID)\(addKey)") { (success, message, error) in
            if success == 1 {
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    self.scrollView.scrollToTop()
                }
                DataManager.isshippingRefundOnly = false
                DataManager.isTipRefundOnly = false
                self.orderInfoModelObj = OrderVM.shared.orderInfo
                
                DataManager.OrderDataModel?.removeAll()
                
                if self.orderInfoModelObj.paymentStatus == "AUTH" {
                    
                    var CardNumber = ""
                    var CardYear = ""
                    var CardMonth = ""
                    //appDelegate.authOrderIdForOrderHistory = ""
                    
                    if let val = self.orderInfoModelObj.cardDetail?.number {
                        CardNumber = val
                    }
                    
                    if let val = self.orderInfoModelObj.cardDetail?.year {
                        CardYear = val
                    }
                    
                    if let val = self.orderInfoModelObj.cardDetail?.month {
                        CardMonth = val
                    }
                    
                    
                    let disValue = self.orderInfoModelObj.discount
                    var discountValue = ""
                    if disValue > 0 {
                        discountValue = "\(disValue + self.orderInfoModelObj.couponPrice)"
                        print("Discount data value \(discountValue)")
                    }
                    
                    let dataval = ["str_paymentMethod": self.orderInfoModelObj.paymentMethod,
                                   "str_cardNumber": CardNumber,
                                   "str_cardYear": CardYear,
                                   "str_cardMonth": CardMonth,
                                   "str_OrderId": self.orderInfoModelObj.orderID,
                                   "str_TipAmount": self.orderInfoModelObj.tip,
                                   "str_CouponId": self.orderInfoModelObj.couponId,
                                   "str_CouponCode": self.orderInfoModelObj.couponCode,
                                   "str_CouponPrice": self.orderInfoModelObj.couponPrice,
                                   "str_CouponTitle": self.orderInfoModelObj.couponCode,
                                   "str_Tax": self.orderInfoModelObj.tax,
                                   "str_CustomTaxId": self.orderInfoModelObj.customTax,
                                   "str_ShippingRate": self.orderInfoModelObj.shipping,
                                   "str_DiscountPrize": discountValue] as [String : Any]
                    DataManager.OrderDataModel = dataval
                }
                
                DispatchQueue.main.async(){
                    self.updateUI()
                    
                }
                
                self.handleOrderSummaryButtonAction()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        Indicator.isEnabledIndicator = true
                        Indicator.sharedInstance.hideIndicator()
                        //self.tableView.reloadData()
                        self.updateUI()
                        self.reloadTableData()
                        self.handleOrderSummaryButtonAction()
                    }
                })
                self.reloadTableData()
                
                if appDelegate.isOpenToOrderHistory {
                    self.moveToPaymentScreen()
                }
            }else {
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                }
                
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
                
                self.reloadTableData()
            }
        }
    }
    
    func callAPItoGetTransactionPrintReceiptContent(transactionID: String)
    {
        if orderID == "" {
            Indicator.isEnabledIndicator = true
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        //Call API
        HomeVM.shared.getTransactionPrintReceiptContent(transactionID: transactionID, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.receiptModel = HomeVM.shared.receiptModel
                self.handlePrinterAction()
            }else {
                if message != nil {
                    //                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func callAPItoGetReceiptContent()
    {
        if orderID == "" {
            Indicator.isEnabledIndicator = true
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        //Call API
        HomeVM.shared.getReceiptContent(orderID: orderID, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.receiptModel = HomeVM.shared.receiptModel
                self.handlePrinterAction()
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func callAPItoGetTransactionInfo() {
        if orderID == "" {
            Indicator.isEnabledIndicator = true
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        
        //Call API
        OrderVM.shared.getTransactionInfo(orderId: orderID) { (success, message, error) in
            Indicator.isEnabledIndicator = true
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                self.scrollView.scrollToTop()
                self.tableView.scrollToTop()
                self.transactionInfoArray = OrderVM.shared.transactionInfoArray
                self.noTransactionFoundImageView.isHidden = self.transactionInfoArray.count != 0
                self.reloadTableData()
            }else {
                self.noTransactionFoundImageView.isHidden = false
                if message != nil {
                    //...
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
}


//MARK: PrinterManagerDelegate
extension OrderInfoViewController: PrinterManagerDelegate {
    
    func loadPrinter() {
        PrintersViewController.printerManager = PrinterManager()
        PrintersViewController.printerManager?.delegate = self
        PrintersViewController.printerArray = PrintersViewController.printerManager!.nearbyPrinters
        PrintersViewController.printerUUID = nil
        //self.tbl_Settings.reloadData()
    }
    public func nearbyPrinterDidChange(_ change: NearbyPrinterChange) {
        switch change {
        case let .add(p):
            PrintersViewController.printerArray.append(p)
        case let .update(p):
            guard let row = (PrintersViewController.printerArray.index() { $0.identifier == p.identifier } ) else {
                return
            }
            if p.state == .connected {
                DataManager.receipt = true
                PrintersViewController.printerUUID = p.identifier
            }
            else if p.state == .disconnected {
                PrintersViewController.printerUUID = nil
            }
            PrintersViewController.printerArray[row] = p
            print(p.state)
        case let .remove(identifier):
            guard let row = (PrintersViewController.printerArray.index() { $0.identifier == identifier } ) else {
                return
            }
            
            if PrintersViewController.printerUUID == PrintersViewController.printerArray[row].identifier {
                PrintersViewController.printerUUID = nil
            }
            PrintersViewController.printerArray.remove(at: row)
        }
        
        //self.tbl_Settings.reloadData()
    }
    
    func moveToSettings() {
        //        if !isShowAlert {
        //            return
        //        }
        self.showAlert(title: "Alert", message: "Please enable the bluetooth from Settings.", otherButtons: nil, cancelTitle: kOkay) { (action) in
            guard let url = URL(string: "App-Prefs:root=Bluetooth") else {return}
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension  OrderInfoViewController: CustomerPickupDelegete {
    func didMoveToOrderInfoForCustomerPickup() {
        delegateForCustomer?.reloadDataByCustomerPickUp?()
    }
}
//MARK: iPad_PaymentTypesViewControllerDelegate
extension OrderInfoViewController: iPad_PaymentTypesViewControllerDelegate {
    
    func didupdateOrderHistoryInfo() {
        callAPItoGetOrderInfo()
    }
}


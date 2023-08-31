//
//  PaymentsViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 20/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire
import SocketIO
import CoreLocation

class PaymentsViewController: BaseViewController, RUADeviceSearchListener, RUAAudioJackPairingListener  {
    
    
    //MARK: IBOutlet
    @IBOutlet weak var lbl_TotalTitle: UILabel!
    @IBOutlet weak var lbl_PaymentName: UILabel!
    @IBOutlet weak var lbl_TotalAmonut: UILabel!
    @IBOutlet weak var containerViewMultiCard: UIView!
    @IBOutlet weak var containerViewPax: UIView!
    @IBOutlet weak var containerViewNotes: UIView!
    @IBOutlet weak var containerViewInvoice: UIView!
    @IBOutlet weak var containerViewGiftCard: UIView!
    @IBOutlet weak var containerViewExternal: UIView!
    @IBOutlet weak var containerViewCheck: UIView!
    @IBOutlet weak var containerViewCash: UIView!
    @IBOutlet weak var containerViewAchCheck: UIView!
    @IBOutlet weak var containerViewCreditCard: UIView!
    @IBOutlet weak var containerViewExternalGiftCard: UIView!
    @IBOutlet weak var containerViewInternalGiftCard: UIView!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var amountRemainTitleLabel: UILabel!
    @IBOutlet weak var amountTotalTitleLabel: UILabel!
    @IBOutlet weak var multiCardStackView: UIView!
    @IBOutlet weak var multiCardTotalLabel: UILabel!
    @IBOutlet weak var multiCardRemainLabel: UILabel!
    @IBOutlet weak var multiCardHeightConstraint: NSLayoutConstraint!
    @IBOutlet var viewCollection: [UIView]!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var amountDetailStackView: UIStackView!
    @IBOutlet var amountDetailBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblChangeDue: UILabel!
    @IBOutlet weak var viewAmountPaid: UIView!
    @IBOutlet weak var constTopViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var lblTipAmount: UILabel!
    @IBOutlet weak var ViewTipAmount: UIView!
    @IBOutlet weak var lblCrTipAmount: UILabel!
    @IBOutlet weak var lblHeaderTip: UILabel!
    @IBOutlet weak var viewTempTip: UIView!
    @IBOutlet weak var constViewTipTRaling: NSLayoutConstraint!
    @IBOutlet weak var constViewTipLeading: NSLayoutConstraint!
    @IBOutlet weak var containerViewIngenico: UIView!
    @IBOutlet weak var btn_back: UIButton!
    
    //MARK: Variables
    var OrderedData = [String:AnyObject]()
    var paymentName = String()
    var depositeAmount = Double()
    var totalAmount = Double()
    var invoiceEmail = String()
    var CustomerObj = CustomerListModel()
    var orderInfoObj = OrderInfoModel()
    var orderType: OrderType = .newOrder
    var cartProductsArray = Array<Any>()
    var str_ShippingANdHandling = String()
    var str_BalanceDue = Double()
    var str_AddDiscount = String()
    var str_AddCouponName = String()
    var str_AddNote = String()
    var SubTotalPrice = Double()
    var str_TaxAmount = String()
    var str_RegionName = String()
    var str_AUTH = String()
    var isCardFileSelected = Bool()
    var str_Tip = String()
    var str_userPaxToken = String()
    var str_CreditCardNumber = String()
    var str_MM = String()
    var str_YYYY = String()
    var str_CVV = String()
    var str_Cash = String()
    var str_NotesInvoice = String()
    var str_Rep = String()
    var str_invoiceTitle = String()
    var str_Terms = String()
    var str_DueDate = String()
    var str_Ponumber = String()
    var str_RoutingNumber = String()
    var str_AccountNumber = String()
    var str_DLState = String()
    var str_DLNumber = String()
    var str_CheckNumber = String()
    var str_CheckAmount = String()
    var str_CardPin = String()
    var str_GiftCardNumber = String()
    var str_ExternalGiftCardNumber = String()
    var str_InternalGiftCardNumber = String()
    var str_ExternalAmount = String()
    var str_externalAprrovalNumber = String()
    var str_SignatureData = String()
    var str_Notes = String()
    var signatureImage: UIImage? = nil
    var tipAmountCreditCard = Double()
    var tipAmountMulticard = Double()
    var isplaceOrderCalled = Bool()
    var multicardData = JSONDictionary()
    var multicardTotal = Double()
    var paxPaymentType = String()
    var paxDevice = String()
    var paxUrl = String()
    var paxtip = String()
    var paxTotal = String()
    var invoiceCardNumber = String()
    var invoiceCardMonth = String()
    var invoiceCardYear = String()
    var invoiceDate = String()
    var isSaveInvoice = Bool()
    var isCreditCardNumberDetected = false
    var isSwiped = false
    var isOderPlaced = false
    static var isPayButtonSelected = false
    static var paymentDetailDict = JSONDictionary()
    var arrCardData = NSMutableArray()
    var arrlistingData = JSONArray()
    var strSplitAmount = String()
    var tipAmountValue = 0.0
    var orig_txn_response = String()
    var merchant = String()
    var txn_response = JSONDictionary()
    var cardholderName = String()
    var merchant_Id = String()
    var invoiceTemplateId = ""
    var isOpenToOrderHistory = false
    //"orig_txn_response":ingenicoData, "merchant": "ingenico", "txn_response": ""
    
    //MARK: Delegate
    var delegate: PaymentTypeDelegate?
    var creditCardDelegate: PaymentTypeDelegate?
    var cashDelegate: PaymentTypeDelegate?
    var invoiceDelegate: PaymentTypeDelegate?
    var achCheckDelegate: PaymentTypeDelegate?
    var checkDelegate: PaymentTypeDelegate?
    var giftCardDelegate: PaymentTypeDelegate?
    var externalGiftCardDelegate: PaymentTypeDelegate?
    var externalCardDelegate: PaymentTypeDelegate?
    var notesDelegate: PaymentTypeDelegate?
    var multicardDelegate: PaymentTypeDelegate?
    var paxDelegate: PaymentTypeDelegate?
    var internalGiftCardDelegate: PaymentTypeDelegate?
    var ingenicoDelegate: PaymentTypeDelegate?
    var delegatePaymentTypeContainer : PaymentTypeContainerViewControllerDelegate?
    var creditcardiPhoneDelegate: PaymentTypeDelegate?
    var isBillingProfileIDSetError = false
    
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
                
                loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password, islogin: true)
                
                //let loginVC:LoginViewController  = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                //self.navigationController?.pushViewController(loginVC, animated: false)
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
            //self.deviceStatusLabel.text = "Device Status: Pairing completed.\n Remove reader from  audio jack to test Bluetooth connection.\n Make sure reader is powered on."
        }
    }
    
    func onPairNotSupported() {
        //self.deviceStatusLabel.text = "Device Status: Pairing not supported"
    }
    
    func  onPairFailed() {
        //self.deviceStatusLabel.text = "Device Status: Pairing Failed"
    }
    
    func loginWithUserName( _ uname : String, andPW pw : String, islogin:Bool){
        
        self.view.endEditing(true)
        //SVProgressHUD.show(withStatus: "Logging")
        Ingenico.sharedInstance()?.user.loginwithUsername(uname, andPassword: pw) { (user, error) in
            //SVProgressHUD.dismiss()
            if (error == nil) {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.setLoggedIn(true)
                //self.checkFirmwareUpdate()
                //self.cardReaderMainView.isHidden = true
                //self.tbl_Settings.reloadData()
                //self.performSegue(withIdentifier:"loginsuccess" , sender: nil)
                if islogin {
                    self.promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
                }
                
            }else{
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                let nserror = error as NSError?
                let alertController:UIAlertController  = UIAlertController.init(title: "Failed", message: "Login failed, please try again later \(self.getResponseCodeString((nserror?.code)!))", preferredStyle: .alert)
                let okAction:UIAlertAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
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
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingenico = Ingenico.sharedInstance()
        ingenico.setLogging(false)
        deviceList = [RUADevice]()
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
                
                if DataManager.isBalanceDueData {
                    btn_back.isHidden = true
                } else {
                    btn_back.isHidden = false
                }
            } else {
                btn_back.isHidden = false
            }
        }
        
        let staticDictionary1:[String: [String]] = ["Cash Transaction APIs": ["Cash Sale", "Cash Refund"]]
        staticDataArray.append(staticDictionary1)
        let staticDictionary2:[String: [String]] = ["Basic Transaction APIs": [ "Keyed Transaction", "Debit Card Transaction", "Credit Card Transaction", "Credit Refund", "Card Refund", "Void"]]
        staticDataArray.append(staticDictionary2)
        let staticDictionary3:[String: [String]] = ["Authorization APIs": [  "Keyed Auth Transaction",  "Auth Transaction", "Auth Complete"]]
        staticDataArray.append(staticDictionary3)
        let staticDictionary4:[String: [String]] = ["Other APIs and Stress Test": ["Get Pending Signature Transaction", "Transaction Load Test"]]
        staticDataArray.append(staticDictionary4)
        let staticDictionary5:[String: [String]] = ["Secure card entry": ["Modal View", "View Controller"]]
        staticDataArray.append(staticDictionary5)
        
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
                    self.idleChargeButton()
                    Indicator.sharedInstance.hideIndicator()
                    //self.placeOrder(isAuth: false, isSwiped: false)
                    
                }
                
                appDelegate.strIngenicoErrorMsg = self.getResponseCodeString((nserror!.code))
                //SVProgressHUD.showError(withStatus: "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))")
                appDelegate.showIncreaseTimeToast(message: "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))")
                self.consoleLog( "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))")
                if DataManager.isIngenicPaymentMethodCancelAndMessage {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                            MainSocketManager.shared.onPaymentError(errorMessage: "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))")
                    }
                }
                if self.getResponseCodeString(nserror!.code) == "4934" {
                    Ingenico.sharedInstance()?.payment.ignorePendingReversalsBeforeNextTransaction()
                }
                Indicator.sharedInstance.hideIndicator()
                //if  "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))" == "Transaction Failed with error code: Transaction Cancelled" {
                    self.placeOrder(isAuth: false, isSwiped: false)
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
        
//        loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
        self.idleChargeButton()
        if DataManager.isBalanceDueData {
            authButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "order"
        {
            let vc = segue.destination as! OrderViewController
            vc.total = paymentName == "multi_card" ? Double(tipAmountMulticard + totalAmount) : totalAmount + tipAmountCreditCard
            vc.OrderedData = OrderedData
            vc.paymentType = paymentName
            //vc.total = totalAmount
            vc.subTotal = SubTotalPrice
            vc.tax = str_TaxAmount.toDouble()?.rounded(toPlaces: 2) ?? 0.0
            vc.paxDevice = paxDevice
            //vc.discountV = str_AddDiscount
            vc.tip = tipAmountCreditCard
        }
        
        //        if segue.identifier == "signatureSegue"
        //        {
        //            if let vc = segue.destination as? SignatureViewController
        //            {
        //                vc.signatureDelegateone = self
        //            }
        //        }
        
        if segue.identifier == "multicard"
        {
            let vc = segue.destination as! MultiCardContainerViewController
            vc.totalAmount = self.totalAmount
            multicardDelegate = vc
            vc.customerData = CustomerObj
            vc.delegate = self
        }
        
        if segue.identifier == "creditcard"
        {
            let vc = segue.destination as! CreditCardContainerViewController
            creditCardDelegate = vc
            vc.delegate = self
            vc.total = self.totalAmount
            creditcardiPhoneDelegate = vc
            vc.totalAmount = self.totalAmount
            //appDelegate.strPaymentType = "CREDIT"
            vc.isCreditCardNumberDetected = self.isCreditCardNumberDetected
        }
        
        if segue.identifier == "ingenico"
        {
            let vc = segue.destination as! IngenicoViewControllerVC
            ingenicoDelegate = vc
            vc.delegate = self
            vc.totalAmount = self.totalAmount
            //appDelegate.strPaymentType = "CREDIT"
        }
        
        if segue.identifier == "cash"
        {
            let vc = segue.destination as! CashViewController
            cashDelegate = vc
            vc.delegate = self
            vc.totalCashAmount = self.totalAmount.roundToTwoDecimal
        }
        
        if segue.identifier == "achcheck"
        {
            let vc = segue.destination as! ACHcheckContainerViewController
            vc.total = totalAmount
            achCheckDelegate = vc
            vc.delegate = self
        }
        
        if segue.identifier == "paxpay"
        {
            let vc = segue.destination as! PaxPayContainerViewController
            paxDelegate = vc
            vc.totalAmount = totalAmount
            vc.delegate = self
            vc.total = "\(self.totalAmount)"
        }
        
        if segue.identifier == "check"
        {
            let vc = segue.destination as! CheckContainerViewController
            checkDelegate = vc
            vc.totalAmount = totalAmount
            vc.total = totalAmount
            vc.delegate = self
        }
        
        if segue.identifier == "giftcard"
        {
            let vc = segue.destination as! GiftCardContainerViewController
            giftCardDelegate = vc
            vc.total = totalAmount
            vc.delegate = self
        }
        
        if segue.identifier == "externalGiftCard"
        {
            let vc = segue.destination as! ExternalGiftCardContainerViewController
            externalGiftCardDelegate = vc
            vc.total = totalAmount
            vc.delegate = self
        }
        
        if segue.identifier == "internalGiftCard"
        {
            let vc = segue.destination as! InternalGiftCardViewController
            internalGiftCardDelegate = vc
            vc.total = self.totalAmount
            vc.total = totalAmount
            vc.delegate = self
        }
        
        if segue.identifier == "external"
        {
            let vc = segue.destination as! ExternalContainerViewController
            externalCardDelegate = vc
            vc.totalAmount = totalAmount
            vc.total = totalAmount
            vc.delegate = self
        }
        
        if segue.identifier == "invoice"
        {
            let vc = segue.destination as! InvoiceContainerViewController
            if UI_USER_INTERFACE_IDIOM() == .pad {
                vc.invoiceEmail = self.invoiceEmail
            }else {
                vc.invoiceEmail = self.CustomerObj.str_email
            }
            vc.total = totalAmount
            vc.customerObj = self.CustomerObj
            invoiceDelegate = vc
            vc.delegate = self
        }
    }
    
    //MARK: Private Functions
    private func idleChargeButton(by time: Double = 1.5) {
        if NetworkConnectivity.isConnectedToInternet() {
            self.payButton.isUserInteractionEnabled = false
            self.authButton.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                self.payButton.isUserInteractionEnabled = true
                self.authButton.isUserInteractionEnabled = true
            }
        }else {
            self.payButton.isUserInteractionEnabled = true
            self.authButton.isUserInteractionEnabled = true
        }
    }
    
    private func placeOrder(isAuth: Bool,isSwiped: Bool) {
        PaymentsViewController.isPayButtonSelected = true
        
        //Load all data from containers
        getAllDataForPayment(isAuth: isAuth)
        //Validate Data
        if !validatePaymentData() {
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        //Return If Multicard
        if paymentName ==  "MULTI CARD" || paymentName == "multi_card" {
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        if DataManager.isSplitPayment {
            //strSplitAmount = dict["spliteAmount"] as? String ?? ""
        } else {
            strSplitAmount = "\(totalAmount)"
        }
        
        //Order
        if paymentName == "CREDIT" || paymentName == "credit" || paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
            //            if !isSwiped && str_AUTH.uppercased() != "AUTH"
            //            {
            //                if UI_USER_INTERFACE_IDIOM() == .pad {
            //                    self.delegate?.didPerformSegueWith?(identifier: "signatureSegue")
            //                }else {
            //                    self.performSegue(withIdentifier: "signatureSegue", sender: nil)
            //                }
            
            if DataManager.collectTips || DataManager.signature {
                
                if paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
                    self.arrCardData.removeAllObjects()
                    //let last4 = str_CreditCardNumber.suffix(4)
                    let datavalue = ["card_number": "****",
                                     "txn_id": "1",
                                     "total": "\(SubTotalPrice)",
                        "TotalAmount": "\(strSplitAmount)",
                        "tipAmount": "\(HomeVM.shared.errorTip)"]
                    self.arrCardData.add(datavalue)
                } else {
                    self.arrCardData.removeAllObjects()
                    let last4 = str_CreditCardNumber.suffix(4)
                    let datavalue = ["card_number": last4,
                                     "txn_id": "1",
                                     "total": "\(SubTotalPrice)",
                        "TotalAmount": "\(strSplitAmount)",
                        "tipAmount": "\(HomeVM.shared.errorTip)"]
                    self.arrCardData.add(datavalue)
                }
                
                //                    arrCardData.removeAllObjects()
                //                    let last4 = str_CreditCardNumber.suffix(4)
                //                    let datavalue = ["card_number": last4,
                //                                     "txn_id": "1",
                //                                     "total": "\(SubTotalPrice)",
                //                    "TotalAmount": "\(totalAmount)"]
                //                    self.arrCardData.add(datavalue)
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    self.delegate?.sendSignatureScreen?(arrcardData: arrCardData)
                    Indicator.sharedInstance.hideIndicator()
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MultipleSignatureViewController") as! MultipleSignatureViewController
                    vc.arrCardData = arrCardData
                    vc.signatureDelegate = self
                    present(vc, animated: true, completion: nil)
                    //prepareForPlaceOrder()
                }
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
                    MainSocketManager.shared.onOpenSignature(signArry: self.arrCardData, subTotal: Double(strSplitAmount) ?? 0.00, total: Double(strSplitAmount) ?? 0.00, paxLoader: paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" ? true : false )
                }
                
            } else {
                prepareForPlaceOrder()
            }
            //            }
            //            else
            //            {
            //                prepareForPlaceOrder()
            //            }
        }else if paymentName == "CARD READER" && UI_USER_INTERFACE_IDIOM() == .phone {
            prepareForPlaceOrder()
        } else{
            // prepareForPlaceOrder()
            if paymentName == "INVOICE" || paymentName == "invoice" {
                
                prepareForPlaceOrder()
            }else{
                var total = ""
                
                if (paymentName == "MULTI CARD") || (paymentName == "multi_card"){
                    
                }
                if (paymentName == "CHECK") || (paymentName == "check"){
                    total = "\(str_CheckAmount)"
                }
                if (paymentName == "ACH CHECK") || (paymentName == "ach_check"){
                    total = "\(strSplitAmount)"
                }
                if (paymentName == "GIFT CARD") || (paymentName == "gift_card"){
                    total = "\(strSplitAmount)"
                }
                if (paymentName == "EXTERNAL GIFT CARD") || (paymentName == "external_gift_card" || paymentName == "external_gift") {
                    total = "\(strSplitAmount)"
                }
                if (paymentName == "INTERNAL GIFT CARD") || (paymentName == "internal_gift_card")
                {
                    total = "\(strSplitAmount)"
                }
                if (paymentName == "EXTERNAL") || (paymentName == "external"){
                    total = str_ExternalAmount
                }
                if (paymentName == "CASH") || (paymentName == "cash"){
                    total = str_Cash.replacingOccurrences(of: "$", with: "")
                }else{
                    //total = "\(totalAmount)"
                }
                self.arrCardData.removeAllObjects()
                let datavalue = ["card_number": paymentName.capitalized,
                                 "txn_id": "1",
                                 "total": "",
                                 "TotalAmount": "\(total)",
                                 "tipAmount": ""]
                self.arrCardData.add(datavalue)
                if DataManager.signature  && DataManager.posCollectSignatureOnEveryOrder {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    self.delegate?.sendSignatureScreen?(arrcardData: arrCardData)
                    Indicator.sharedInstance.hideIndicator()
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MultipleSignatureViewController") as! MultipleSignatureViewController
                    vc.arrCardData = arrCardData
                    vc.signatureDelegate = self
                    present(vc, animated: true, completion: nil)
                    
                }
                }else{
                    prepareForPlaceOrder()
                }
            }
        }
    }
    
    private func loadData() {
        if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
            if (DataManager.selectedPayment!.contains("CARD READER")) {
                self.paymentName = "CARD READER"
            }
        }
        let paymentname = self.paymentName.replacingOccurrences(of: "_", with: " ").uppercased()
        
        if HomeVM.shared.DueShared > 0{
            totalAmount = HomeVM.shared.DueShared
        }
        //Set Shadow
        for view in viewCollection {
            view.clipsToBounds = false
            view.layer.cornerRadius = 4.0
            view.layer.shadowColor = UIColor.darkGray.cgColor
            view.layer.shadowOffset = CGSize.zero
            view.layer.shadowOpacity = 0.5
            view.layer.shadowRadius = 2
        }
        //Reset Values
        if paymentname == "MULTI CARD" {
            multiCardTotalLabel.text = "$0.00"
            multiCardRemainLabel.text = "$0.00"
            lblChangeDue.text = "$0.00"
        }
        
        lbl_TotalAmonut.text = "$0.00"
        resetButton.isHidden = true//orderType == .refundOrExchangeOrder    //Temp.
        amountRemainTitleLabel.isHidden = true
        amountTotalTitleLabel.isHidden = true
        multiCardStackView.isHidden = true
        amountDetailStackView.isHidden = true
        //multiCardHeightConstraint.constant = 0.0
        //amountDetailBottomConstraint.constant = 15
        lbl_TotalAmonut.isHidden = false
        lbl_TotalTitle.isHidden = false
        self.authButton.isHidden = true
        self.authButton.setTitle("Auth", for: .normal)
        //self.payButton.setTitle(paymentName == "INVOICE" ? "Send Invoice" : "Charge \("$" + totalAmount.roundToTwoDecimal)", for: .normal)
        self.payButton.setTitle(paymentName == "INVOICE" ? "Done" : "Charge \("$" + totalAmount.roundToTwoDecimal)", for: .normal)
        
        if DataManager.isBalanceDueData {
            viewAmountPaid.isHidden = false
        } else {
            viewAmountPaid.isHidden = true
            ViewTipAmount.isHidden = true
        }
        
        if paymentname == "CASH" {
            // MARK Hide for V5
            
            if HomeVM.shared.DueShared > 0{
                self.payButton.setTitle("Tender" + " $" + (HomeVM.shared.DueShared).roundToTwoDecimal, for: .normal)
            }else{
                self.payButton.setTitle("Tender" + " $" + (totalAmount).roundToTwoDecimal, for: .normal)
            }
            
        }
        
        if HomeVM.shared.DueShared > 0{
            //self.payButton.setTitle(paymentName == "INVOICE" ? "Send Invoice" : "Charge \("$" + HomeVM.shared.DueShared.roundToTwoDecimal)", for: .normal)
            self.payButton.setTitle(paymentName == "INVOICE" ? "Done" : "Charge \("$" + HomeVM.shared.DueShared.roundToTwoDecimal)", for: .normal)
            
            self.lbl_TotalAmonut.text = "$\(totalAmount.roundToTwoDecimal)"
            
        }else{
            //self.payButton.setTitle(paymentName == "INVOICE" ? "Send Invoice" : "Charge \("$" + totalAmount.roundToTwoDecimal)", for: .normal)
            self.payButton.setTitle(paymentName == "INVOICE" ? "Done" : "Charge \("$" + totalAmount.roundToTwoDecimal)", for: .normal)
            
            self.lbl_TotalAmonut.text = "$\(totalAmount.roundToTwoDecimal)"
            
            if UI_USER_INTERFACE_IDIOM() == .phone {
                if paymentName == "CHECK"{
                    checkDelegate?.didUpdateTotal?(amount: totalAmount, subToal: 0.0)
                }
                if paymentName == "EXTERNAL"{
                    externalCardDelegate?.didUpdateTotal?(amount: totalAmount, subToal: 0.0)
                    
                }
                if paymentName == "CASH" || paymentName == "cash"{
                    cashDelegate?.didUpdateTotal?(amount: totalAmount, subToal: 0.0)
                }
                
            }
        }
        
        
        
        str_AUTH = "AUTH_CAPTURE"
        
        if isCreditCardNumberDetected {
            DispatchQueue.main.async {
                self.paymentName = "CREDIT"
                if DataManager.isBalanceDueData {
                    self.authButton.isHidden = true
                } else {
                    self.authButton.isHidden = !DataManager.isAuthentication || self.orderType == .refundOrExchangeOrder
                }
                self.containerViewCash.isHidden = true
                self.containerViewCheck.isHidden = true
                self.containerViewNotes.isHidden = true
                self.containerViewInvoice.isHidden = true
                self.containerViewAchCheck.isHidden = true
                self.containerViewExternal.isHidden = true
                self.containerViewGiftCard.isHidden = true
                self.containerViewCreditCard.isHidden = false
                self.containerViewPax.isHidden = true
                self.containerViewMultiCard.isHidden = true
                self.containerViewExternalGiftCard.isHidden = true
                self.containerViewInternalGiftCard.isHidden = true
                self.containerViewIngenico.isHidden = true
                self.lbl_PaymentName.text = "Credit Card"
                DispatchQueue.main.async {
                    self.creditCardDelegate?.enableCardReader?()
                    if self.isSwiped {
                        self.creditCardDelegate?.placeOrder?(isIpad: false)
                    }
                }
            }
            return
        }
        
        if paymentname == "CASH" || paymentname == "cash"{
            if DataManager.isBalanceDueData {
                ViewTipAmount.isHidden = true
                viewAmountPaid.isHidden = false
                constTopViewHeight.constant = 275
                lblAmountPaid.text = HomeVM.shared.amountPaid.currencyFormat
                if HomeVM.shared.tipValue == 0 {
                    lblHeaderTip.isHidden = true
                    viewTempTip.isHidden = true
                    constViewTipLeading.constant = 95
                    constViewTipTRaling.constant = 95
                } else {
                    lblHeaderTip.isHidden = false
                    viewTempTip.isHidden = false
                    lblTipAmount.text = HomeVM.shared.tipValue.currencyFormat
                }
                
            } else {
                viewAmountPaid.isHidden = true
                ViewTipAmount.isHidden = true
                constTopViewHeight.constant = 190
            }
        } else {
            if DataManager.isBalanceDueData {
                viewAmountPaid.isHidden = false
                constTopViewHeight.constant = 190
                lblTipAmount.text = HomeVM.shared.DueShared.currencyFormat
                lblAmountPaid.text = HomeVM.shared.amountPaid.currencyFormat
                lblHeaderTip.text = "Balance Due"
                if HomeVM.shared.tipValue > 0 {
                    ViewTipAmount.isHidden = false
                    constTopViewHeight.constant = 275
                    lblCrTipAmount.text = HomeVM.shared.tipValue.currencyFormat
                } else {
                    ViewTipAmount.isHidden = true
                }
            } else {
                viewAmountPaid.isHidden = true
                ViewTipAmount.isHidden = true
                constTopViewHeight.constant = 140
            }
        }
        
        if paymentname == "CREDIT"{
            // by sudama offline
            if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                authButton.isHidden = true
            }else{
                if DataManager.isBalanceDueData {
                    self.authButton.isHidden = true
                } else {
                    self.authButton.isHidden = !DataManager.isAuthentication || orderType == .refundOrExchangeOrder
                    
                }
            }
            //            if DataManager.isBalanceDueData {
            //                viewAmountPaid.isHidden = false
            //                constTopViewHeight.constant = 190
            //                lblTipAmount.text = HomeVM.shared.DueShared.currencyFormat
            //                lblAmountPaid.text = HomeVM.shared.amountPaid.currencyFormat
            //
            //                if HomeVM.shared.tipValue > 0 {
            //                    ViewTipAmount.isHidden = false
            //                    constTopViewHeight.constant = 275
            //                    lblCrTipAmount.text = HomeVM.shared.tipValue.currencyFormat
            //                } else {
            //                    ViewTipAmount.isHidden = false
            //                }
            //            } else {
            //                viewAmountPaid.isHidden = true
            //                ViewTipAmount.isHidden = true
            //                constTopViewHeight.constant = 140
            //            }
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            containerViewAchCheck.isHidden = true
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = false
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            self.containerViewIngenico.isHidden = true
            self.lbl_PaymentName.text = "Credit Card"
            DispatchQueue.main.async {
                self.creditCardDelegate?.reset?()
                self.creditCardDelegate?.enableCardReader?()
            }
        }
        else if paymentname == "CASH" || paymentname == "cash"{
            containerViewCash.isHidden = false
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            containerViewAchCheck.isHidden = true
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            amountRemainTitleLabel.isHidden = false
            amountTotalTitleLabel.isHidden = false
            multiCardStackView.isHidden = false
            //multiCardHeightConstraint.constant = 55.0
            multiCardStackView.clipsToBounds = false
            amountTotalTitleLabel.text = "Change Due"
            amountRemainTitleLabel.text = "Total Due"
            self.lbl_PaymentName.text = "Cash"
            //amountDetailBottomConstraint.constant = 30
            amountDetailStackView.isHidden = false
            cashDelegate?.reset?()
        }
        else if paymentname == "INVOICE"{
            self.authButton.setTitle("Save Invoice", for: .normal)
            self.authButton.isHidden = true  // code for done button client changes
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = false
            containerViewAchCheck.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            self.lbl_PaymentName.text = "Invoice / Estimate"
            DispatchQueue.main.async {
                self.invoiceDelegate?.loadClassData?()
                self.invoiceDelegate?.enableCardReader?()
            }
        }
        else if paymentname == "ACH CHECK"{
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewAchCheck.isHidden = false
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            self.lbl_PaymentName.text = "ACH Check"
            
            DispatchQueue.main.async {
                self.achCheckDelegate?.loadClassData?()
            }
        }
        else if paymentname == "GIFT CARD"{
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewAchCheck.isHidden = true
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = false
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            self.lbl_PaymentName.text = "Heartland Gift Card"
            
            DispatchQueue.main.async {
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    self.giftCardDelegate?.reset?()
                }
                self.giftCardDelegate?.enableCardReader?()
            }
        }
        else if paymentname == "EXTERNAL GIFT CARD"{
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            containerViewAchCheck.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewExternalGiftCard.isHidden = false
            containerViewInternalGiftCard.isHidden = true
            self.lbl_PaymentName.text = "External Gift Card"
            DispatchQueue.main.async {
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    self.externalGiftCardDelegate?.reset?()
                }
                self.externalGiftCardDelegate?.enableCardReader?()
            }
        }
        else if paymentname == "INTERNAL GIFT CARD"{
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            containerViewAchCheck.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            containerViewInternalGiftCard.isHidden = false
            self.lbl_PaymentName.text = "Internal Gift Card"
            DispatchQueue.main.async {
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    self.internalGiftCardDelegate?.reset?()
                }
                self.internalGiftCardDelegate?.enableCardReader?()
            }
        }
        else if paymentname == "CHECK"{
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = false
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            containerViewAchCheck.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            self.lbl_PaymentName.text = "Check"
            if UI_USER_INTERFACE_IDIOM() == .phone {
                self.checkDelegate?.reset?()
            }
        }
        else if paymentname == "EXTERNAL"{
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            containerViewAchCheck.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewExternal.isHidden = false
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            self.lbl_PaymentName.text = "External Payment"

        }
        else if paymentname == "PAX PAY"{
            if DataManager.isBalanceDueData {
                self.authButton.isHidden = true
                
            } else {
                self.authButton.isHidden = !DataManager.isAuthentication || orderType == .refundOrExchangeOrder
                
            }
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewAchCheck.isHidden = true
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = false
            containerViewMultiCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            self.lbl_PaymentName.text = "PAX"
            DispatchQueue.main.async {
                self.paxDelegate?.reset?()
                self.paxDelegate?.loadClassData?()
            }
        }
        else if paymentname == "MULTI CARD"{
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            containerViewAchCheck.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = false
            containerViewExternalGiftCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            self.lbl_PaymentName.text = "Split Payment"
            amountRemainTitleLabel.isHidden = false
            amountTotalTitleLabel.isHidden = false
            multiCardStackView.isHidden = false
            //multiCardHeightConstraint.constant = 55.0
            multiCardStackView.clipsToBounds = false
            amountTotalTitleLabel.text = "Total Due"
            amountRemainTitleLabel.text = "Change Due"
            lbl_TotalAmonut.isHidden = false
            lbl_TotalAmonut.text = "$256"
            //            lbl_TotalTitle.text = ""
            //            lbl_TotalAmonut.isHidden = true
            //            lbl_TotalTitle.isHidden = true
            amountDetailStackView.isHidden = false
            //amountDetailBottomConstraint.constant = 30
            DispatchQueue.main.async {
                self.multicardDelegate?.enableCardReader?()
            }
        }
        else if paymentname == "NOTES"{
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = false
            containerViewInvoice.isHidden = true
            containerViewAchCheck.isHidden = true
            self.containerViewIngenico.isHidden = true
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            self.lbl_PaymentName.text = "Notes"
        } else if paymentname == "CARD READER"{
            containerViewCash.isHidden = true
            containerViewCheck.isHidden = true
            containerViewNotes.isHidden = true
            containerViewInvoice.isHidden = true
            containerViewAchCheck.isHidden = true
            self.containerViewIngenico.isHidden = false
            containerViewExternal.isHidden = true
            containerViewGiftCard.isHidden = true
            containerViewCreditCard.isHidden = true
            containerViewPax.isHidden = true
            containerViewMultiCard.isHidden = true
            containerViewExternalGiftCard.isHidden = true
            containerViewInternalGiftCard.isHidden = true
            self.lbl_PaymentName.text = "CARD READER"
            ingenicoDelegate?.reset?()
            //            DispatchQueue.main.async {
            //                self.externalGiftCardDelegate?.enableCardReader?()
            //            }
        }
    }
    
    private func savePaymentData() {
        PaymentsViewController.paymentDetailDict.removeAll()
        PaymentsViewController.paymentDetailDict["key"] = paymentName
        switch paymentName {
        case "CREDIT":
            creditCardDelegate?.saveData?()
            break
            
        case "CASH":
            cashDelegate?.saveData?()
            break
            
        case "INVOICE":
            invoiceDelegate?.saveData?()
            break
            
        case "ACH CHECK":
            achCheckDelegate?.saveData?()
            break
            
        case "GIFT CARD":
            giftCardDelegate?.saveData?()
            break
            
        case "EXTERNAL GIFT CARD":
            externalGiftCardDelegate?.saveData?()
            break
            
        case "INTERNAL GIFT CARD":
            internalGiftCardDelegate?.saveData?()
            break
            
        case "CHECK":
            checkDelegate?.saveData?()
            break
            
        case "EXTERNAL":
            externalCardDelegate?.saveData?()
            break
            
        case "NOTES":
            notesDelegate?.saveData?()
            break
            
        case "PAX PAY":
            paxDelegate?.saveData?()
            break
            
        case "MULTI CARD":
            multicardDelegate?.saveData?()
            break
            
        default: break
        }
    }
    
    private func validateData() -> Bool {
        if strSplitAmount == ""{
            if UI_USER_INTERFACE_IDIOM() == .pad {
                delegate?.updateError?(textfieldIndex: 4, message: "Please enter amount.")
            }else {
                creditCardDelegate?.updateError?(textfieldIndex: 4, message: "Please enter amount.")
            }
            return false
        }
        
        if str_CreditCardNumber == ""{
            if UI_USER_INTERFACE_IDIOM() == .pad {
                delegate?.updateError?(textfieldIndex: 1, message: "Please enter Card Number.")
            }else {
                creditCardDelegate?.updateError?(textfieldIndex: 1, message: "Please enter Card Number.")
            }
            return false
        }
        
        if str_CreditCardNumber.count < 12 {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                delegate?.updateError?(textfieldIndex: 1, message: "Please enter valid Card Number.")
            }else {
                creditCardDelegate?.updateError?(textfieldIndex: 1, message: "Please enter valid Card Number.")
            }
            return false
        }
        
        if str_YYYY == "" {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                delegate?.updateError?(textfieldIndex: 2, message: "Please select Year.")
            }else {
                creditCardDelegate?.updateError?(textfieldIndex: 2, message: "Please select Year.")
            }
            return false
        }
        
        if str_MM == "" {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                delegate?.updateError?(textfieldIndex: 3, message: "Please select Month.")
            }else {
                creditCardDelegate?.updateError?(textfieldIndex: 3, message: "Please select Month.")
            }
            return false
        }
        
        
        return true
    }
    
    private func resetAllCartData() {
        UserDefaults.standard.removeObject(forKey: "recentOrder")
        UserDefaults.standard.removeObject(forKey: "recentOrderID")
        UserDefaults.standard.removeObject(forKey: "isCheckUncheckShippingBilling")
        UserDefaults.standard.removeObject(forKey: "cartdata")
        UserDefaults.standard.removeObject(forKey: "CustomerObj")
        UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
        UserDefaults.standard.removeObject(forKey: "cartProductsArray")
        UserDefaults.standard.removeObject(forKey: "addnotesordersummary")
        UserDefaults.standard.removeObject(forKey: "defaultTaxID")
        UserDefaults.standard.synchronize()
        DataManager.isshipOrderButton = false
    }
    
    private func validatePaymentData() -> Bool {
        if (paymentName == "CREDIT") || (paymentName == "credit")
        {
            paymentName = "credit"
            
            if !validateData() {
                return false
            }
        }
        
        if (paymentName == "CASH") || (paymentName == "cash") {
            
            paymentName = "cash"
            
            if str_Cash == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 1, message: "Please enter Cash.")
                }else {
                    cashDelegate?.updateError?(textfieldIndex: 1, message: "Please enter Cash.")
                }
                
                return false
            }
            
            let cash = str_Cash.replacingOccurrences(of: "$", with: "")
            if !DataManager.isSplitPayment {
                if HomeVM.shared.DueShared > 0{
                    if (Double(HomeVM.shared.DueShared.roundToTwoDecimal) ?? 0.0) > (Double(cash) ?? 0.0) {
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            delegate?.updateError?(textfieldIndex: 1, message: "Cash amount is less than Total.")
                        }else {
                            cashDelegate?.updateError?(textfieldIndex: 1, message: "Cash amount is less than Total.")
                        }
                        return false
                    }
                } else {
                    if (Double(totalAmount.roundToTwoDecimal) ?? 0.0) > (Double(cash) ?? 0.0) {
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            delegate?.updateError?(textfieldIndex: 1, message: "Cash amount is less than Total.")
                        }else {
                            cashDelegate?.updateError?(textfieldIndex: 1, message: "Cash amount is less than Total.")
                        }
                        return false
                    }
                }
            } else {
                if str_Cash == "" {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        delegate?.updateError?(textfieldIndex: 1, message: "Cash amount is less than Total.")
                    }else {
                        cashDelegate?.updateError?(textfieldIndex: 1, message: "Cash amount is less than Total.")
                    }
                }
            }
        }
        
        if paymentName == "INVOICE" || paymentName == "invoice" {
            
            if invoiceEmail == "" && CustomerObj.str_first_name == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 1, message: "Please enter Email or First Name.")
                }else {
                    invoiceDelegate?.updateError?(textfieldIndex: 1, message: "Please enter Email or First Name.")
                }
                return false
            }
            
            if !invoiceEmail.isValidEmail() && invoiceEmail != "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 1, message: "Please enter valid Email.")
                }else {
                    invoiceDelegate?.updateError?(textfieldIndex: 1, message: "Please enter valid Email.")
                }
                return false
            }
            
            //            if str_NotesInvoice == "" {
            //                if UI_USER_INTERFACE_IDIOM() == .pad {
            //                    delegate?.updateError?(textfieldIndex: 2, message: "Please enter Notes.")
            //                }else {
            //                    invoiceDelegate?.updateError?(textfieldIndex: 2, message: "Please enter Notes.")
            //                }
            //                return false
            //            }
        }
        
        if paymentName ==  "ACH CHECK" || paymentName == "ach check" || paymentName == "ach_check" {
            if str_RoutingNumber == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 1, message: "Please enter Routing Number.")
                }else {
                    achCheckDelegate?.updateError?(textfieldIndex: 1, message: "Please enter Routing Number.")
                }
                return false
            }
            
            if str_AccountNumber == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 2, message: "Please enter Account Number.")
                }else {
                    achCheckDelegate?.updateError?(textfieldIndex: 2, message: "Please enter Account Number.")
                }
                return false
            }
            
            if str_DLNumber == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 3, message: "Please enter DL Number.")
                }else {
                    achCheckDelegate?.updateError?(textfieldIndex: 3, message: "Please enter DL Number.")
                }
                return false
            }
            
            if str_DLState == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 4, message: "Please select DL State.")
                }else {
                    achCheckDelegate?.updateError?(textfieldIndex: 4, message: "Please select DL State.")
                }
                return false
            }
        }
        
        if paymentName ==  "GIFT CARD"  || paymentName == "gift card" || paymentName == "gift_card" {
            if str_GiftCardNumber == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 1, message: "Please enter Gift Card Number.")
                }else {
                    giftCardDelegate?.updateError?(textfieldIndex: 1, message: "Please enter Gift Card Number.")
                }
                return false
            }
        }
        
        if paymentName ==  "EXTERNAL GIFT CARD"  || paymentName == "external gift card" || paymentName == "external_gift_card" || paymentName == "external_gift" {
            if str_ExternalGiftCardNumber == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 1, message: "Please enter Gift Card Number.")
                }else {
                    externalGiftCardDelegate?.updateError?(textfieldIndex: 1, message: "Please enter Gift Card Number.")
                }
                return false
            }
        }
        
        
        if paymentName ==  "INTERNAL GIFT CARD"  || paymentName == "internal gift card" || paymentName == "internal_gift_card" {
            if str_InternalGiftCardNumber == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 1, message: "Please enter Gift Card Number.")
                }else {
                    internalGiftCardDelegate?.updateError?(textfieldIndex: 1, message: "Please enter Gift Card Number.")
                }
                return false
            }
        }
        
        if paymentName ==  "CHECK"  || paymentName == "check" {
            if str_CheckAmount == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 1, message: "Please enter Check Amount.")
                }else {
                    checkDelegate?.updateError?(textfieldIndex: 1, message: "Please enter Check Amount.")
                }
                return false
            }
            
            let cash = str_CheckAmount.replacingOccurrences(of: "$", with: "")
            if DataManager.isSplitPayment {
                if cash == "" {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        delegate?.updateError?(textfieldIndex: 1, message: "Amount is less than Total.")
                    }else {
                        checkDelegate?.updateError?(textfieldIndex: 1, message: "Amount is less than Total.")
                    }
                    return false
                }
            } else {
                if totalAmount > Double(cash) ?? 0.0 {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        delegate?.updateError?(textfieldIndex: 1, message: "Amount is less than Total.")
                    }else {
                        checkDelegate?.updateError?(textfieldIndex: 1, message: "Amount is less than Total.")
                    }
                    return false
                }
            }
            
            if str_CheckNumber == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 2, message: "Please enter Check Number.")
                }else {
                    checkDelegate?.updateError?(textfieldIndex: 2, message: "Please enter Check Number.")
                }
                return false
            }
        }
        
        if paymentName ==  "EXTERNAL"  || paymentName == "external" {
            if str_ExternalAmount == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 1, message: "Please enter Amount.")
                }else {
                    externalCardDelegate?.updateError?(textfieldIndex: 1, message: "Please enter Amount.")
                }
                return false
            } else if str_externalAprrovalNumber == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 2, message: "Please enter Approval Number.")
                }else {
                    externalCardDelegate?.updateError?(textfieldIndex: 2, message: "Please enter Approval Number.")
                }
                return false
            }
            
            let cash = str_ExternalAmount.replacingOccurrences(of: "$", with: "")
            if DataManager.isSplitPayment {
                if cash == "" {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        delegate?.updateError?(textfieldIndex: 1, message: "Amount is less than Total.")
                    }else {
                        externalCardDelegate?.updateError?(textfieldIndex: 1, message: "Amount is less than Total.")
                    }
                    return false
                }
            } else {
                if totalAmount > Double(cash) ?? 0.0 {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        delegate?.updateError?(textfieldIndex: 1, message: "Amount is less than Total.")
                    }else {
                        externalCardDelegate?.updateError?(textfieldIndex: 1, message: "Amount is less than Total.")
                    }
                    return false
                }
            }
        }
        
        if paymentName == "MULTI CARD" || paymentName == "multi card" || paymentName == "multi_card" {
            
            let amount = (totalAmount - tipAmountMulticard)
            
            if (Double(multicardTotal.roundToTwoDecimal) ?? 0.0) < (totalAmount - tipAmountMulticard).distance(to: 2) || multicardData.count == 0 {
                return false
            }
        }
        
        if  paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
            if paxDevice == "" {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    delegate?.updateError?(textfieldIndex: 1, message: "Please select Device.")
                }else {
                    paxDelegate?.updateError?(textfieldIndex: 1, message: "Please select Device.")
                }
                return false
            }
        }
        
        return true
    }
    
    private func getAllDataForPayment(isAuth: Bool) {
        if (paymentName == "CREDIT") || (paymentName == "credit")
        {
            if !isAuth
            {
                creditCardDelegate?.sendCreditCardData?(with: "authcapture", isIPad: false)
            }
            else
            {
                creditCardDelegate?.sendCreditCardData?(with: "auth", isIPad: false)
            }
        }
        if paymentName == "CASH" || paymentName == "cash"{
            cashDelegate?.sendCashData?(isIPad: false)
        }
        if (paymentName == "INVOICE") || (paymentName == "invoice") {
            invoiceDelegate?.sendInvoiceData?(isSaveInvoice: true, isIPad: false)
        }
        if paymentName == "ACH CHECK" || paymentName == "ach check" || paymentName == "ach_check" {
            achCheckDelegate?.sendACHCheckData?(isIPad: false)
        }
        if paymentName == "GIFT CARD" || paymentName == "gift card" || paymentName == "gift_card"{
            giftCardDelegate?.sendGiftCardData?(isIPad: false)
        }
        if paymentName == "EXTERNAL GIFT CARD" || paymentName == "external gift card" || paymentName == "external_gift_card" || paymentName == "external_gift" {
            externalGiftCardDelegate?.sendExternalGiftCardData?(isIPad: false)
        }
        if paymentName == "INTERNAL GIFT CARD" || paymentName == "internal gift card" || paymentName == "internal_gift_card" {
            internalGiftCardDelegate?.sendInternalGiftCardData?(isIPad: false)
        }
        if paymentName == "CHECK" || paymentName == "check" {
            checkDelegate?.sendCheckData?(isIPad: false)
        }
        if paymentName == "EXTERNAL" || paymentName == "external" {
            externalCardDelegate?.sendExternalCardData?(isIPad: false)
        }
        if paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
            if !isAuth
            {
                paxDelegate?.sendPAXData?(with: "authcapture", isIPad: false)
            }
            else
            {
                paxDelegate?.sendPAXData?(with: "auth", isIPad: false)
            }
        }
        if paymentName == "MULTI CARD" || paymentName == "multi card" || paymentName == "multi_card" {
            multicardDelegate?.sendMulticardData?(isIPad: false)
        }
        if paymentName == "NOTES" || paymentName == "notes"{
            notesDelegate?.sendNotesData?(isIPad: false)
        }
        if paymentName == "CARD READER" || paymentName == "card reader"{
            ingenicoDelegate?.sendIngenicoCardData?(with: "authcapture", isIPad: false, data: IngenicoDataResponce)
        }
    }
    
    
    func getVariationValueForProduct(attributeObj: JSONArray, variationObj: JSONArray, surchargeObj: JSONArray) -> JSONArray {
        
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
        var arrTextAttribute = JSONArray()
        var TextDict = JSONDictionary()
        var isVationOn = false
        
        let productDetail = ProductModel.shared.getProductDetailStruct(jsonArray: attributeObj)
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
                let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
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
                            
                            let surchargeDetail = ProductModel.shared.getProductDetailSurchargeVariationStruct(jsonArray: surchargeObj)
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
        
        let variationDetail = ProductModel.shared.getProductDetailVariationStruct(jsonArray: variationObj)
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
    
    func sendSignatureScreenData(arrcardData: NSMutableArray) {
        
        //        if let last4 = orderedData["last4"]as? String {
        //            //self.last4 = last4
        //
        //            var txnId = ""
        //            if let txnid = self.orderedData["txn_id"]as? String {
        //                txnId = txnid
        //            }
        //
        //            let datavalue = ["card_number": last4,
        //                             "txn_id": txnId]
        //
        //            self.arrCardData.add(datavalue)
        //        }
        
        // let hh = orderedData["last4"] as? String
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MultipleSignatureViewController") as! MultipleSignatureViewController
        vc.arrCardData = arrcardData
        vc.signatureDelegate = self
        self.present(vc, animated: true, completion: nil)
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
                Indicator.sharedInstance.delegate = self
                        if DataManager.isIngenicPaymentMethodCancelAndMessage {
                            Indicator.sharedInstance.showIndicatorGif(true)
                        } else {
                            Indicator.sharedInstance.showIndicatorGif(false)
                        }
                        
                        
                        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
                            MainSocketManager.shared.onOrderProcessignloader(paymentType: "Ingenico")
                        }
                if DataManager.isIngenicoConnected {
                    if self.getIsDeviceConnected() {
                        //                ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                        //                                                   apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                        //                                                   clientVersion: ClientVersion)
                        self.loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password, islogin: true)
                        
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
    
    func ingenicoStartOnClick() {
        callAPIToGetIngenicoLogin()
    }

    //MARK: IBAction
    @IBAction func btn_AuthAction(_ sender: Any) {
        //Prevent to place multiple order
        if isOderPlaced {
            return
        }
        isOderPlaced = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isOderPlaced = false
        }
        //Place Order
        self.idleChargeButton()
        var isGreenBtn = false
        
        if self.authButton.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        self.authButton.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
           
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.authButton.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        self.placeOrder(isAuth: true, isSwiped: false)
    }
    
    @IBAction func btn_PayAction(_ sender: Any) {
        //Prevent to place multiple order
        if isOderPlaced {
            return
        }
        isOderPlaced = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isOderPlaced = false
        }
        //Place Order
        var isGreenBtn = true
        
//        if self.payButton.backgroundColor == #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) {
//            isGreenBtn = false
//        }
//        self.payButton.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
//           
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.payButton.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
//        }
        
        if (paymentName == "CARD READER") || (paymentName == "card reader")
        {
            if !getIsDeviceConnected() {
                Indicator.sharedInstance.hideIndicator()
                appDelegate.showToast(message: "Device is powered off, please power on.")
                return
            }
            
            if ((DataManager.signature && DataManager.isSingatureOnEMV) && !DataManager.collectTips) || (HomeVM.shared.DueShared > 0 && (DataManager.signature && DataManager.isSingatureOnEMV)) || (HomeVM.shared.DueShared > 0 && !DataManager.signature && DataManager.collectTips) {
                
                if paymentName == "CARD READER" || paymentName == "card reader" {
                    if ((DataManager.signature && DataManager.isSingatureOnEMV)){
                        if DataManager.collectTips || DataManager.signature {
                            if paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
                                
                            } else {
                                var arrcard = NSMutableArray()
//                                if HomeVM.shared.DueShared > 0 {
//                                    appDelegate.CardReaderAmount = HomeVM.shared.DueShared
//                                }
                                let datavalue = ["card_number": "Ingenico",
                                                 "txn_id": "1",
                                                 "total": "\(SubTotalPrice)",
                                    "TotalAmount": "\(appDelegate.CardReaderAmount)",
                                    "tipAmount": "0.00"]
                                
                                arrcard.add(datavalue)
                                if appDelegate.strIngenicoAmount != "" {
                                    sendSignatureScreenData(arrcardData: arrcard)
                                } else {
                                    ingenicoDelegate?.updateError?(textfieldIndex: 1, message: "Please enter amount")
                                }
                            }
                        } else {
                            ingenicoStartOnClick()
                            //promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
                        }
                    } else {
                        ingenicoStartOnClick()
                        //promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
                    }
                } else {
                    ingenicoStartOnClick()
                    //promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
                }
                
            } else {
                if DataManager.collectTips || DataManager.signature {
                    if paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
                        
                    } else {
                        var arrcard = NSMutableArray()
                        
//                        if HomeVM.shared.DueShared > 0 {
//                            appDelegate.CardReaderAmount = HomeVM.shared.DueShared
//                        }
                        let datavalue = ["card_number": "Ingenico",
                                         "txn_id": "1",
                                         "total": "\(SubTotalPrice)",
                            "TotalAmount": "\(appDelegate.CardReaderAmount)",
                            "tipAmount": "0.00"]
                        
                        arrcard.add(datavalue)
                        
                        if appDelegate.strIngenicoAmount != "" {
                            sendSignatureScreenData(arrcardData: arrcard)
                        } else {
                            ingenicoDelegate?.updateError?(textfieldIndex: 1, message: "Please enter amount")
                        }
                        
                    }
                } else {
                    ingenicoStartOnClick()
                    //promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
                }
            }
            return
        } else {
            self.idleChargeButton()
            self.placeOrder(isAuth: false, isSwiped: false)
        }
        
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        PaymentsViewController.paymentDetailDict.removeAll()
        self.view.endEditing(true)
        //Payment name
        if (paymentName == "CREDIT") || (paymentName == "credit")
        {
            creditCardDelegate?.reset?()
        }
        if paymentName == "CASH" || paymentName == "cash" {
            cashDelegate?.reset?()
        }
        if (paymentName == "INVOICE") || (paymentName == "invoice")
        {
            invoiceDelegate?.reset?()
        }
        if (paymentName == "ACH CHECK") || (paymentName == "ach_check")
        {
            achCheckDelegate?.reset?()
        }
        if (paymentName == "GIFT CARD") || (paymentName == "gift_card")
        {
            giftCardDelegate?.reset?()
        }
        if (paymentName == "EXTERNAL GIFT CARD") || (paymentName == "external_gift_card") || (paymentName == "external_gift")
        {
            externalGiftCardDelegate?.reset?()
        }
        if (paymentName == "INTERNAL GIFT CARD") || (paymentName == "internal_gift_card")
        {
            internalGiftCardDelegate?.reset?()
        }
        if (paymentName == "MULTI CARD") || (paymentName == "multi_card")
        {
            multicardDelegate?.reset?()
        }
        if (paymentName == "CHECK") || (paymentName == "check")
        {
            checkDelegate?.reset?()
        }
        if (paymentName == "EXTERNAL") || (paymentName == "external")
        {
            externalCardDelegate?.reset?()
        }
        if (paymentName == "PAX PAY") || (paymentName == "pax_pay")
        {
            paxDelegate?.reset?()
        }
    }
    
    @IBAction func btn_BackAction(_ sender: Any) {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            appDelegate.localBezierPath.removeAllPoints()
        }
        if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
            //
            if DataManager.isBalanceDueData {
                
                //viewBalanceDue.isHidden = false
                //let refreshAlert = UIAlertController(title: "Alert", message: "Incomplete Split Payment,\n if continue then all data will be reset.", preferredStyle: UIAlertControllerStyle.alert)
                
                var strId = 0
                if let id = DataManager.recentOrderID {
                    strId = id
                }
                
                let refreshAlert = UIAlertController(title: "Cancel Order", message: "Navigating away from this order will \nleave the existing order #\(strId) \nwith total paid: \(HomeVM.shared.amountPaid.currencyFormat) you can \nreview and refund these \ncharges from Past Orders.", preferredStyle: UIAlertControllerStyle.alert)
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    //...
                }))
                refreshAlert.addAction(UIAlertAction(title: "Proceed", style: .destructive, handler: { (action: UIAlertAction!) in
                    //self.isDefaultTaxChanged = false
                    //self.isDefaultTaxSelected = false
                    //self.taxTitle = DataManager.defaultTaxID
                    DataManager.isBalanceDueData = false
                    PaymentsViewController.paymentDetailDict.removeAll()
                    self.resetCartData()
                    HomeVM.shared.customerUserId = ""
                    self.popViewControllerss(popViews: 4)
                    appDelegate.localBezierPath.removeAllPoints()
                    appDelegate.amount = 0.0
                    //self.navigationController?.popViewController(animated: true)
                }))
                present(refreshAlert, animated: true, completion: nil)
                
            } else {
                self.popViewControllerss(popViews: 2)
                // self.navigationController?.popViewController(animated: true)
            }
            return
        }
        if HomeVM.shared.tipValue > 0 {
            
            //            if HomeVM.shared.multicardErrorResponse.count > 0 {
            //                HomeVM.shared.DueShared = HomeVM.shared.DueShared
            //                HomeVM.shared.tipValue = 0.00
            //                HomeVM.shared.MultiTipValue = 0.00
            //            } else {
            //                if DataManager.isPartialAprrov {
            //                    HomeVM.shared.DueShared = HomeVM.shared.DueShared
            //                } else {
            //                    HomeVM.shared.DueShared = HomeVM.shared.TotalDue - HomeVM.shared.tipValue
            //                    HomeVM.shared.tipValue = 0.00
            //                    HomeVM.shared.MultiTipValue = 0.00
            //                    //self.tipLabel.text = "$0.00"
            //                }
            //            }
            //self.balanceDue = HomeVM.shared.DueShared
            //HomeVM.shared.DueShared = HomeVM.shared.DueShared - HomeVM.shared.tipValue
            
            DataManager.cartData!["tipAmount_due"] = HomeVM.shared.tipValue
            DataManager.cartData!["MultiTipAmount_due"] = HomeVM.shared.MultiTipValue
            DataManager.cartData!["balance_due"] = HomeVM.shared.DueShared
            
            //self.tipAmountDue = HomeVM.shared.tipValue
            //self.MultiTipAmountDue = HomeVM.shared.MultiTipValue
        } else {
            //self.tipLabel.text = "$0.00"
        }
        appDelegate.amount = 0.00
        HomeVM.shared.errorTip = 0.00 // For iPhone error tip
        savePaymentData()
        self.navigationController?.popViewController(animated: true)
    }
    func popViewControllerss(popViews: Int, animated: Bool = true) {
        if self.navigationController!.viewControllers.count > popViews
        {
            let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - popViews - 1]
            self.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    func resetCartData()
    {
        
        //self.delegate?.didResetCart?()
        self.cartProductsArray.removeAll()
        UserDefaults.standard.removeObject(forKey: "recentOrder")
        UserDefaults.standard.removeObject(forKey: "recentOrderID")
        UserDefaults.standard.removeObject(forKey: "isCheckUncheckShippingBilling")
        UserDefaults.standard.removeObject(forKey: "cartdata")
        UserDefaults.standard.removeObject(forKey: "CustomerObj")
        UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
        UserDefaults.standard.removeObject(forKey: "cartProductsArray")
        DataManager.selectedCarrierName = ""
        DataManager.selectedService = ""
        DataManager.selectedServiceName = ""
        DataManager.selectedServiceId = ""
        DataManager.selectedCarrier = ""
        DataManager.selectedShippingRate = ""
        DataManager.shippingWeight = 0
        DataManager.shippingWidth = 0
        DataManager.shippingLength = 0
        DataManager.shippingHeight = 0
        DataManager.selectedFullfillmentId = ""
        DataManager.cartShippingProductsArray?.removeAll()
        DataManager.isshipOrderButton = false
        appDelegate.localBezierPath.removeAllPoints()
        UserDefaults.standard.synchronize()
        PaymentsViewController.paymentDetailDict.removeAll()
        self.str_AddDiscount = ""
        self.str_AddCouponName = ""
        self.str_ShippingANdHandling = ""
        CustomerObj = CustomerListModel()
        //customerNameLabel.text = "Customer #"
        
        DataManager.duebalanceData = 0.0
        HomeVM.shared.amountPaid = 0.0
        HomeVM.shared.tipValue = 0.0
        HomeVM.shared.DueShared = 0.0
        HomeVM.shared.coupanDetail.code = ""
        
        //        self.showAlert(title: "Alert", message: "Cart items removed!", otherButtons: nil, cancelTitle: kOkay) { (action) in
        self.navigationController?.popViewController(animated: true)
        appDelegate.showToast(message: "Cart items removed!")
        //        }
    }
}

//MARK: API Methods
extension PaymentsViewController {
    func callAPIToCreateOrder(parameters: JSONDictionary, isInvoice: Bool, isAllManualProducts: Bool) {
        Indicator.sharedInstance.hideIndicator()
        Indicator.sharedInstance.showIndicator()
        if paymentName == "pax_pay" || (merchant == "ingenico" && paymentName == "credit"){
            Indicator.sharedInstance.hideIndicator()
            Indicator.isEnabledIndicator = false
            
            Indicator.sharedInstance.showIndicatorGif(false)
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
        }
        
        //Indicator.sharedInstance.showIndicator()
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            if !isAllManualProducts {
                //self.showAlert(title: <#T##String?#>, message: <#T##String#>)
                if paymentName != "credit" {//|| merchant == "ingenico"{
//                    if merchant == "ingenico" {
//                        appDelegate.arrIngenicoJsonArrayData.append(appDelegate.arrIngenicoData)
//                        DataManager.ingenicoOflineCaseData = appDelegate.arrIngenicoJsonArrayData
//                        appDelegate.isIngenicoDataFail = true
//                    } else {
//                        appDelegate.isIngenicoDataFail = false
//                    }
                    self.delegate?.didOpenErrorAlert?(identifier: "")
                    //self.showAlert(message: "Only Manual Payment Products is available in offline mode.")
                    //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    //                    self.showAlert(title: "Oops!", message: "Only Manual Payment Products is available in offline mode.")
                    //                }
                    return
                }
                
            }
            
            let selectedPayment = (parameters["payment_type"] as? String ?? "").uppercased()
            // by sudama offline
            //            if !offlinePaymentArray.contains(selectedPayment) {
            //                self.delegate?.didOpenErrorAlert?(identifier: selectedPayment)
            //                return
            //            }
        }
        
        //Save Order For Future Check
        let recentOrder = parameters.filter({$0.key == "cust_id" || $0.key == "customer_info" || $0.key == "bill_profile_id" || $0.key == "billing_info" || $0.key == "shipping_info" || $0.key == "is_billing_same" || $0.key == "cart_info" || $0.key == "order_source" || $0.key == "notes" })
        DataManager.recentOrder = recentOrder
        
        var isMulticard = false
        
        if let key = parameters["payment_type"] as? String , key == "multi_card" {
            isMulticard = true
        }
        
        
        if DataManager.isSplitPayment {
            if DataManager.allowZeroDollarTxn  == "true"{
                if let key = parameters["payment_type"] as? String , key == "cash" {
                    if totalAmount > 0 && (Double(str_Cash.replacingOccurrences(of: "$", with: "")) ?? 0 > 0) {
                        
                    } else if totalAmount == 0 && (Double(str_Cash.replacingOccurrences(of: "$", with: "")) ?? 0 >= 0) {
                        
                    } else {
                        appDelegate.showToast(message: "Please Enter valid Amount")
                        Indicator.sharedInstance.hideIndicator()
                        return
                    }
                    
                } else if let key = parameters["payment_type"] as? String , key == "invoice" {
                    if totalAmount > 0  {
                        
                    } else if totalAmount == 0  {
                        
                    } else {
                        appDelegate.showToast(message: "Please Enter valid Amount")
                        Indicator.sharedInstance.hideIndicator()
                        return
                    }
                } else {
                    if totalAmount > 0 && (Double(strSplitAmount) ?? 0 > 0) {
                        
                    } else if totalAmount == 0 && (Double(strSplitAmount) ?? 0 >= 0) {
                        
                    } else {
                        appDelegate.showToast(message: "Please Enter valid Amount")
                        Indicator.sharedInstance.hideIndicator()
                        return
                    }
                }
                
                
            }else{
                
                if let key = parameters["payment_type"] as? String , key == "cash" {
                    if (Double(str_Cash.replacingOccurrences(of: "$", with: "")) ?? 0 > 0) {
                        
                    }else{
                        appDelegate.showToast(message: "Please Enter Amount greater than 0")
                        Indicator.sharedInstance.hideIndicator()
                        return
                    }
                }else{
                    if (Double(strSplitAmount) ?? 0 > 0) {
                        
                    }else{
                        appDelegate.showToast(message: "Please Enter Amount greater than 0")
                        Indicator.sharedInstance.hideIndicator()
                        return
                    }
                }
                
                
            }
        } else {
            
            if DataManager.allowZeroDollarTxn  == "true" {
                if let key = parameters["payment_type"] as? String , key == "cash" {
                    if (Double(str_Cash.replacingOccurrences(of: "$", with: "")) ?? 0 >= 0) {
                        
                    }
                }else{
                    if totalAmount >= 0 {
                        
                    }
                }
                
                
            } else {
                if totalAmount == 0 {
                    appDelegate.showToast(message: "Order cann't be processed with zero total.")
                    Indicator.sharedInstance.hideIndicator()
                    return
                }
            }
        }
        
        if orderType == .newOrder {
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
                
                var selectedPaymentType = (parameters["payment_type"] as? String ?? "").uppercased()
                if (merchant == "ingenico" && paymentName == "credit"){
                    selectedPaymentType = "Ingenico"
                }
                if selectedPaymentType == "PAX PAY" || selectedPaymentType == "pax pay" || selectedPaymentType == "pax_pay" || selectedPaymentType == "PAX_PAY"{
                    selectedPaymentType = "pax_pay"
                }
                MainSocketManager.shared.onOrderProcessignloader(paymentType: selectedPaymentType)
                
            }
        }        
        //Call API
        
        HomeVM.shared.createOrder(parameters: parameters, isInvoice: isInvoice,isMulticard: isMulticard) { (success, message, error) in
            
            if DataManager.tempSignature {
                DataManager.signature = true
                DataManager.tempSignature = false
            }
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                Ingenico.sharedInstance()?.payment.reverseAllPendingTransactions(withRetryCounter: 10, andOnDone: { (error) in
                    if (error == nil) {
                        //self.showSucess( "Success")
                        self.consoleLog("reversePendingtransactions success")
                    }
                    else {
                        //
                        //self.showError("Failed")
                        self.consoleLog("reversePendingtransactions failed with \((error! as NSError).code)")
                    }
                })
                appDelegate.isErrorCreateOrderCase = false
                self.isBillingProfileIDSetError = false
                HomeVM.shared.errorTip = 0.0
                if !HomeVM.shared.userData.isEmpty {
                    self.OrderedData = HomeVM.shared.userData
                    
                    if DataManager.isBalanceDueData == false {
                        HomeVM.shared.userData.removeAll()
                    }
                }
                
                if self.paymentName == "pax_pay" {
                    DataManager.selectedPaxDeviceName = self.paxDevice
                }
                
                if DataManager.isBalanceDueData == false {
                    PaymentsViewController.paymentDetailDict.removeAll()
                    self.resetAllCartData()
                    //DataManager.selectedPaxDeviceName = ""
                } else {
                    if self.paymentName == "pax_pay" {
                        DataManager.selectedPaxDeviceName = self.paxDevice
                    }
                }
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    if self.str_AUTH == "AUTH"{
                        let storyboard = UIStoryboard.init(name: "iPad", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "AuthorizeViewController") as! AuthorizeViewController
                        vc.Orderedobj = self.OrderedData
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        self.performSegue(withIdentifier: "order", sender: nil)
                    }
                    
                }else{
                    
                    self.delegate?.didMoveToSuccessScreen?(totalAmount: self.paymentName == "multi_card" ? Double(self.tipAmountMulticard + self.totalAmount) : self.totalAmount, orderedData: self.OrderedData, paymentName: self.paymentName)
                }
            } else {
                DataManager.isBalanceDueData = true
                self.isBillingProfileIDSetError = true
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    appDelegate.isErrorCreateOrderCase = true
                    appDelegate.strErrorMsg = message ?? ""
                    if self.paymentName.lowercased() == "credit" {
                        self.delegate?.enableCreditCardDelegate?()
                    }
                    // Start DD 08 Nov 2022 for ingnico
                    appDelegate.isIngenicoDataFail = false
                    if error != nil {
                        let valError = error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg
                        if valError == "The Internet connection appears to be offline." && self.merchant == "ingenico" {
                            //DataManager.ingenicoOflineCaseData?.append(appDelegate.arrIngenicoData)
                            appDelegate.arrIngenicoJsonArrayData.append(appDelegate.arrIngenicoData)
                            DataManager.ingenicoOflineCaseData = appDelegate.arrIngenicoJsonArrayData
                            appDelegate.isIngenicoDataFail = true
                        } else {
                            appDelegate.isIngenicoDataFail = false
                            DataManager.ingenicoOflineCaseData = nil
                            appDelegate.arrIngenicoJsonArrayData.removeAll()
                        }
                    }// End DD 08 Nov 2022 for ingnico
                    self.delegate?.gettingErrorDuringPayment?(isMulticard: isMulticard, message: message, error: error)
                }else {
                    if let obj = DataManager.cartData!["balance_due"] as? Double{
                        self.totalAmount = obj
                        let ob =  DataManager.cartData!["balance_due"] as! Double
                        self.multiCardTotalLabel.text = "$" + String(obj)
                        self.payButton.setTitle("Charge" + "$" + String(obj) , for: .normal)
                        if appDelegate.amount > 0  { // for iphone error SSUU
                            self.multicardDelegate?.didUpdateRemainingAmt?(RemainingAmt: appDelegate.amount)
                            self.creditcardiPhoneDelegate?.didUpdateRemainingAmt?(RemainingAmt: appDelegate.amount )
                            self.ingenicoDelegate?.didUpdateRemainingAmt?(RemainingAmt: appDelegate.amount)
                            self.payButton.setTitle("Charge" + "$" + String(appDelegate.amount) , for: .normal)
                        }else{
                            self.ingenicoDelegate?.didUpdateRemainingAmt?(RemainingAmt: DataManager.cartData!["balance_due"] as! Double)
                            self.multicardDelegate?.didUpdateRemainingAmt?(RemainingAmt: DataManager.cartData!["balance_due"] as! Double )
                            self.creditcardiPhoneDelegate?.didUpdateRemainingAmt?(RemainingAmt: DataManager.cartData!["balance_due"] as! Double )
                            self.payButton.setTitle("Charge" + "$" + String(obj) , for: .normal)
                        }
                        //  self.multicardDelegate?.didUpdateRemainingAmt?(RemainingAmt: DataManager.cartData!["balance_due"] as! Double )
                        // self.creditcardiPhoneDelegate?.didUpdateRemainingAmt?(RemainingAmt: DataManager.cartData!["balance_due"] as! Double )
                    }
                    
                    print("call here delegate")
                    if self.paymentName.lowercased() == "credit" {
                        self.creditCardDelegate?.enableCreditCardDelegate?()
                    }
                    if error != nil {
                        let valError = error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg
                        if valError == "The Internet connection appears to be offline." && self.merchant == "ingenico" {
                            //DataManager.ingenicoOflineCaseData?.append(appDelegate.arrIngenicoData)
                            appDelegate.arrIngenicoJsonArrayData.append(appDelegate.arrIngenicoData)
                            DataManager.ingenicoOflineCaseData = appDelegate.arrIngenicoJsonArrayData
                            appDelegate.isIngenicoDataFail = true
                        } else {
                            appDelegate.isIngenicoDataFail = false
                            DataManager.ingenicoOflineCaseData = nil
                            appDelegate.arrIngenicoJsonArrayData.removeAll()
                        }
                    }
                    if isMulticard {
                        self.multicardDelegate?.gettingErrorDuringPayment?(isMulticard: isMulticard, message: message, error: error)
                    }else {
                        if message != nil {
                            //                            self.showAlert(message: message!)
                            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                                MainSocketManager.shared.onPaymentError(errorMessage: message!)
                            }
                            
                            appDelegate.showToast(message: message!)
                        }else {
                            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                                MainSocketManager.shared.onPaymentError(errorMessage: error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg)
                            }
                            self.showErrorMessage(error: error)
                        }
                        
                    }
                }
            }
        }
    }
}

//MARK: PaymentTypeContainerViewControllerDelegate
extension PaymentsViewController: PaymentTypeContainerViewControllerDelegate {
    
    func balanceDueRemaining(with amount: Double) {
        print(amount)
        if amount > 0 {
            if self.paymentName == "CASH" || self.paymentName == "cash"{
                payButton.setTitle("Tender \(amount.currencyFormat)", for: .normal)
            } else {
                self.payButton.setTitle(self.paymentName == "INVOICE" ? "Done" : "Charge \(amount.currencyFormat)", for: .normal)
            }
        }
        
        //balanceDueView.isHidden = false
        //labelBallanceDueAmt.isHidden = false
        var val = 0.0
        if HomeVM.shared.DueShared > 0 {
            val = HomeVM.shared.DueShared
        } else {
            val = totalAmount
        }
        
        
        if val > amount {
            print("eneter")
        }
        
        if val < amount {
            print("eneter two")
        }
        
        let balDue = val - amount
        if balDue > 0 {
            //labelBallanceDueAmt.text = balDue.currencyFormat
            authButton.isHidden = true
            
            
            
            if balDue == totalAmount {
                if self.paymentName == "CREDIT" || self.paymentName == "PAX PAY"{
                    if DataManager.isBalanceDueData {
                        authButton.isHidden = true
                    } else {
                        authButton.isHidden = !DataManager.isAuthentication || orderType == .refundOrExchangeOrder
                    }
                }
                
            } else if balDue == HomeVM.shared.DueShared {
                if self.paymentName == "CREDIT" || self.paymentName == "PAX PAY"{
                    if DataManager.isBalanceDueData {
                        authButton.isHidden = true
                    } else {
                        authButton.isHidden = !DataManager.isAuthentication || orderType == .refundOrExchangeOrder
                    }
                    
                }
            } else {
                authButton.isHidden = true
            }
            
            if amount == 0 {
                if self.paymentName == "CASH" || self.paymentName == "cash"{
                    payButton.setTitle("Tender \(balDue.currencyFormat)", for: .normal)
                } else {
                    self.payButton.setTitle(self.paymentName == "INVOICE" ? "Done" : "Charge \(balDue.currencyFormat)", for: .normal)
                }
            }
            
        } else {
            //labelBallanceDueAmt.text = "$0.00"
        }
        
    }
    
    func checkIphonePayButtonColorChange(isCheck: Bool, text: String) {
        
        if paymentName.lowercased() == text.lowercased()  {
            print("got check")
            print("paymentName",paymentName)
            payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            if isCheck{
                payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            }else{
                payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            }
        }else{
            if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
                if ((DataManager.selectedPayment?.contains("CARD READER")) != nil) {
                    if isCheck{
                        payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                    }else{
                        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    }
                }
            }
            if paymentName == "cash" {
                if isCheck{
                    payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                    authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                }else{
                    payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                }
            }
        }
        
        // payButton.isUserInteractionEnabled = true
        if DataManager.allowZeroDollarTxn  == "false"{
            if HomeVM.shared.DueShared > 0 {
                if HomeVM.shared.DueShared == 0.0 {
                    payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    // payButton.isUserInteractionEnabled = false
                }
            } else {
                if totalAmount == 0.0 {
                    payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    //    payButton.isUserInteractionEnabled = false
                }
            }
            
            //            if "CASH" == text {
            //                if payButton.titleLabel?.text == "Tender $0.00" {
            //                    payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            //                    authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            //                } else {
            //                    payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            //                    authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            //                }
            //            }
        }
        
    }
    func placeOrderWithSignature(image: UIImage) {
        self.signatureImage = image
        prepareForPlaceOrder()
    }
    
    func returnDataSignature(arrCardDataSignature: JSONArray) {
        print(arrCardDataSignature)
        
        if paymentName == "MULTI CARD" || paymentName == "multi card" || paymentName == "multi_card" {
            
            if let multiData = multicardData["credit"] as? JSONArray {
                print(multiData.count)
                var multiValue =  multicardData["credit"] as? JSONArray
                for i in 0..<arrCardDataSignature.count {
                    let arrsign = arrCardDataSignature[i]
                    
                    let cardNo = arrsign["card_number"] as? String
                    let cardval = cardNo?.suffix(4)
                    for j in 0..<multiData.count {
                        let card =  multiData[j]["cc_account"] as? String
                        
                        let card4 = card?.suffix(4)
                        if cardval == card4 {
                            let tipVal = (arrsign["tip"] as? String)?.toDouble()
                            multiValue?[j]["tip"] = tipVal ?? 0.0
                            multiValue?[j]["digital_signature"] = arrsign["signature"] as? String ?? ""
                        }
                    }
                }
                multicardData["credit"] = multiValue
            }
            
            if let multiData = multicardData["pax_pay"] as? JSONArray {
                print(multiData.count)
                var multiValue =  multicardData["pax_pay"] as? JSONArray
                
                for i in 0..<arrCardDataSignature.count {
                    let arrsign = arrCardDataSignature[i]
                    
                    let cardNo = arrsign["paxNumber"] as? String
                    let cardval = cardNo?.suffix(4)
                    for j in 0..<multiData.count {
                        let card =  "pax_pay_\(j)"
                        
                        let card4 = card.suffix(4)
                        if cardval == card4 {
                            let tipVal = (arrsign["tip"] as? String)?.toDouble()
                            multiValue?[j]["tip"] = tipVal ?? 0.0
                            multiValue?[j]["paxNumber"] = ""
                            multiValue?[j]["digital_signature"] = arrsign["signature"] as? String ?? ""
                        }
                    }
                }
                multicardData["pax_pay"] = multiValue
            }
            
        } else if paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
            for i in 0..<arrCardDataSignature.count {
                let arrsign = arrCardDataSignature[i]
                let tipVal = arrsign["tip"] as? String
                paxtip = tipVal ?? "0.00"
                
                str_SignatureData = arrsign["signature"] as? String ?? ""
            }
        } else {
            for i in 0..<arrCardDataSignature.count {
                let arrsign = arrCardDataSignature[i]
                let tipVal = (arrsign["tip"] as? String)?.toDouble()
                tipAmountCreditCard = tipVal ?? 0.0
                
                str_SignatureData = arrsign["signature"] as? String ?? ""
            }
        }
        
        for i in 0..<arrCardDataSignature.count {
            let TltVal = arrCardDataSignature[0]["TotalAmount"] as? String
            totalAmount = TltVal?.toDouble() ?? 0.0
        }
        
        prepareForPlaceOrder()
    }
    
    func placeOrder(isIpad: Bool) {
        DispatchQueue.main.async {
            Indicator.sharedInstance.showIndicator()
            let paymentTypeName = self.paymentName
            self.paymentName = "CREDIT"
            self.placeOrder(isAuth: false, isSwiped: true)
        }
    }
    
    func updateTotal(with amount: Double) {
        tipAmountCreditCard = amount
        if HomeVM.shared.DueShared > 0{
            self.lbl_TotalAmonut.text = "$\((totalAmount + amount).roundToTwoDecimal)"
            //self.payButton.setTitle(paymentName == "INVOICE" ? "Send Invoice" : "Charge \("$" + (HomeVM.shared.DueShared + amount).roundToTwoDecimal)", for: .normal)
            self.payButton.setTitle(paymentName == "INVOICE" ? "Done" : "Charge \("$" + (HomeVM.shared.DueShared + amount).roundToTwoDecimal)", for: .normal)
            
            if paymentName == "MULTI CARD" || paymentName == "multi card" || paymentName == "multi_card" {
                //self.lbl_TotalAmonut.text = ""
                //multiCardTotalLabel.text = "$\((HomeVM.shared.DueShared + amount).roundToTwoDecimal)"
            }
        } else {
            self.lbl_TotalAmonut.text = "$\((totalAmount + amount).roundToTwoDecimal)"
            //self.payButton.setTitle(paymentName == "INVOICE" ? "Send Invoice" : "Charge \("$" + (totalAmount + amount).roundToTwoDecimal)", for: .normal)
            self.payButton.setTitle(paymentName == "INVOICE" ? "Done" : "Charge \("$" + (totalAmount + amount).roundToTwoDecimal)", for: .normal)
            
            if paymentName == "MULTI CARD" || paymentName == "multi card" || paymentName == "multi_card" {
                // self.lbl_TotalAmonut.text = ""
                //multiCardTotalLabel.text = "$\((totalAmount + amount).roundToTwoDecimal)"
            }
        }
        
        
        
        if paymentName == "CASH" || paymentName == "cash" {
            // MARK Hide for V5
            
            if HomeVM.shared.DueShared > 0{
                self.payButton.setTitle("Tender" + " $" + (HomeVM.shared.DueShared + amount).roundToTwoDecimal, for: .normal)
            }else{
                self.lbl_TotalAmonut.text =  "$\((totalAmount + amount).roundToTwoDecimal)"
                self.payButton.setTitle("Tender" + " $" + (totalAmount + amount).roundToTwoDecimal, for: .normal)
            }
        }
    }
    
    func didUpdateCashValue(returnDue: String, totalDue: String) {
        
        if  paymentName == "CASH" || paymentName == "cash"{
            multiCardTotalLabel.text = returnDue
            //multiCardRemainLabel.text = totalDue
            lblChangeDue.text = totalDue
        } else {
            multiCardTotalLabel.text = totalDue
            //multiCardRemainLabel.text = totalDue
            lblChangeDue.text = returnDue
        }
    }
    
    func didUpdateAmountRemaining(amount: String) {
        multiCardRemainLabel.text = amount
        multiCardTotalLabel.text = amount
    }
    
    func didUpdateAmountChangeDue(amount: String) {
        lblChangeDue.text = amount
    }
    
    func getPaymentData(with dict: JSONDictionary) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            Indicator.sharedInstance.showIndicator()
            paymentName = dict["paymnetType"] as? String ?? ""
        }
        str_AddNote = dict["addnotes"] as? String ?? ""
        
        if paymentName == "CARD READER" || paymentName == "card reader" {
            str_CreditCardNumber = dict["cardnumber"] as? String ?? ""
            str_MM = dict["mm"] as? String ?? ""
            str_YYYY = dict["yyyy"] as? String ?? ""
            str_CVV = dict["cvv"] as? String ?? ""
            str_AUTH = dict["auth"] as? String ?? ""
            str_Tip =  ""
            orig_txn_response = dict["orig_txn_response"] as? String ?? ""
            merchant = dict["merchant"] as? String ?? ""
            merchant_Id = HomeVM.shared.ingenicoData[0].merchant_id
            txn_response = dict["txn_response"] as? JSONDictionary ?? JSONDictionary()
            let datacardholderName = txn_response["transaction"] as? JSONDictionary ?? JSONDictionary()
            cardholderName = datacardholderName["cardholderName"] as? String ?? ""

            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["spliteAmount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            } else {
                if DataManager.isSplitPayment {
                    strSplitAmount = "\(dict["amount"] as? Double ?? 0.0)"
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            }
            
            
            if let tip = dict["tipAmountCreditCard"] as? Double {
                tipAmountCreditCard = tip
            }
        }
        
        if paymentName == "CREDIT" || paymentName == "credit" {
            str_CreditCardNumber = dict["cardnumber"] as? String ?? ""
            str_MM = dict["mm"] as? String ?? ""
            str_YYYY = dict["yyyy"] as? String ?? ""
            str_CVV = dict["cvv"] as? String ?? ""
            str_AUTH = dict["auth"] as? String ?? ""
            str_Tip = dict["tip"] as? String ?? ""
            merchant =  ""
            merchant_Id = ""
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["spliteAmount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            } else {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["amount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            }
            
            
            if let tip = dict["tipAmountCreditCard"] as? Double {
                tipAmountCreditCard = tip
            }
        }
        
        if paymentName == "CASH" || paymentName == "cash" {
            str_Cash = dict["cash"] as? String ?? ""
        }
        
        if (paymentName == "INVOICE") || (paymentName == "invoice") {
            invoiceEmail = dict["email"] as? String ?? ""
            str_NotesInvoice = dict["notesInvoice"] as? String ?? ""
            str_Rep = dict["rep"] as? String ?? ""
            str_DueDate = dict["duedate"] as? String ?? ""
            str_invoiceTitle = dict["title"]as? String ?? ""
            str_Terms = dict["terms"] as? String ?? ""
            str_Ponumber = dict["ponumber"] as? String ?? ""
            invoiceCardYear = dict["YYYY"]as? String ?? ""
            invoiceCardMonth = dict["MM"]as? String ?? ""
            invoiceCardNumber = dict["cardNumber"]as? String ?? ""
            invoiceDate = dict["invoiceDate"]as? String ?? ""
            depositeAmount = dict["depositeAmount"]as? Double ?? 0
            invoiceTemplateId = dict["invoiceTemplateId"] as? String ?? "" // 08 nov 220 for invoice template by altab
            CustomerObj =  dict["customerObj"] as? CustomerListModel ?? CustomerObj
            if DataManager.isSplitPayment {
                strSplitAmount = dict["spliteAmount"] as? String ?? ""
            }
            if let issave = dict["isSaveInvoice"] as? String {
                isSaveInvoice = Bool(issave) ?? false
            } else {
                isSaveInvoice = dict["isSaveInvoice"]as? Bool ?? false
            }
            
        }
        
        if paymentName == "ACH CHECK" || paymentName == "ach check" || paymentName == "ach_check" {
            str_RoutingNumber = dict["routingnumber"] as? String ?? ""
            str_AccountNumber = dict["accountnumber"] as? String ?? ""
            str_DLState = dict["dlstate"] as? String ?? ""
            str_DLNumber = dict["dlnumber"] as? String ?? ""
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["spliteAmount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            } else {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["amount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            }
        }
        
        if paymentName == "GIFT CARD" || paymentName == "gift card" || paymentName == "gift_card"{
            str_CardPin = dict["cardpin"] as? String ?? ""
            str_GiftCardNumber = dict["giftcardnumber"] as? String ?? ""
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["spliteAmount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            } else {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["amount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            }
        }
        
        if paymentName == "EXTERNAL GIFT CARD" || paymentName == "external gift card"  || paymentName == "external_gift_card" || paymentName == "external_gift" {
            str_ExternalGiftCardNumber = dict["externalGiftCardNumber"] as? String ?? ""
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["spliteAmount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            } else {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["amount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            }
        }
        
        if paymentName == "INTERNAL GIFT CARD" || paymentName == "internal gift card"  || paymentName == "internal_gift_card"{
            str_InternalGiftCardNumber = dict["internalGiftCardNumber"] as? String ?? ""
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["spliteAmount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            } else {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["amount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            }
        }
        
        if paymentName == "CHECK" || paymentName == "check"{
            str_CheckAmount = dict["checkamount"] as? String ?? ""
            str_CheckNumber = dict["checknumber"] as? String ?? ""
            if DataManager.isSplitPayment {
                strSplitAmount = dict["checkamount"] as? String ?? ""
            }
        }
        
        if paymentName == "EXTERNAL" || paymentName == "external"{
            str_externalAprrovalNumber = dict["external_approval_number"] as? String ?? ""
            str_ExternalAmount = dict["amount"] as? String ?? ""
            if DataManager.isSplitPayment {
                strSplitAmount = dict["amount"] as? String ?? ""
            }
        }
        
        if paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
            paxPaymentType = dict["pax_payment_type"] as? String ?? ""
            paxDevice = dict["device"] as? String ?? ""
            paxUrl = dict["url"] as? String ?? ""
            paxtip = dict["tip"] as? String ?? ""
            paxTotal = dict["total"] as? String ?? ""
            signatureImage = dict["digital_signature"] as? UIImage
            str_AUTH = dict["auth"] as? String ?? ""
            isCardFileSelected = dict["use_token"] as? Bool ?? false
            str_userPaxToken = dict["user_pax_token"] as? String ?? ""
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["spliteAmount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            } else {
                if DataManager.isSplitPayment {
                    strSplitAmount = dict["amount"] as? String ?? ""
                } else {
                    strSplitAmount = "\(totalAmount)"
                }
            }
            
            if UI_USER_INTERFACE_IDIOM() == .phone {
                if PaymentsViewController.isPayButtonSelected {
                    return
                }
                prepareForPlaceOrder()
            }
        }
        
        if paymentName == "MULTI CARD" || paymentName == "multi card" || paymentName == "multi_card" {
            if let multicards = dict["multi_card"] as? JSONDictionary {
                multicardData = multicards
            }
            if let total = dict["totalAmount"] as? Double {
                multicardTotal = total
            }
            if let tip = dict["tipAmount"] as? Double {
                tipAmountMulticard = tip
            }
        }
        
        if paymentName == "NOTES" || paymentName == "notes" {
            str_Notes = dict["notes"] as? String ?? ""
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return
        }
        //Only for iphone
        if paymentName == "MULTI CARD" || paymentName == "multi card" || paymentName == "multi_card" {
            if (Double(multicardTotal.roundToTwoDecimal) ?? 0)  < (Double(totalAmount.roundToTwoDecimal) ?? 1) || multicardData.count == 0 {
                return
            }
        }
        
        if paymentName == "MULTI CARD" || paymentName == "multi card" || paymentName == "multi_card"  {
            
            if ((DataManager.signature && DataManager.isSingatureOnEMV) && !DataManager.collectTips) || (HomeVM.shared.DueShared > 0 && (DataManager.signature && DataManager.isSingatureOnEMV)) || (HomeVM.shared.DueShared > 0 && !DataManager.signature && DataManager.collectTips){
                prepareForPlaceOrder()
            } else {
                var isCredit = false
                var isPax = false
                arrCardData.removeAllObjects()
                
                if DataManager.collectTips || DataManager.signature {
                    if let multiData = multicardData["credit"] as? JSONArray {
                        print(multiData.count)
                        
                        for i in 0..<multiData.count {
                            let dataval = multiData[i]["cc_account"] as? String
                            var tipAmt = "0.00"
                            if let tip = multiData[i]["tip"] {
                                tipAmt = tip as? String ?? "0.00"
                                if tipAmt == "" {
                                    tipAmt = "0.00"
                                }
                            }
                            let last4 = dataval?.suffix(4)
                            let datavalue = ["card_number": last4 ?? "",
                                             "txn_id": "1",
                                             "total": "\(SubTotalPrice)",
                                "TotalAmount": "\(totalAmount)",
                                "tipAmount": "\(tipAmt)"] as [String : Any]
                            self.arrCardData.add(datavalue)
                            isCredit = true
                        }
                        
                    }
                    
                    if let paxpay = multicardData["pax_pay"] as? JSONArray {
                        for i in 0..<paxpay.count {
                            //let dataval = paxpay[i]["cc_account"] as? String
                            //let last4 = dataval?.suffix(4)
                            var tipAmt = "0.00"
                            if let tip = paxpay[i]["tip"] {
                                tipAmt = tip as? String ?? "0.00"
                                if tipAmt == "" {
                                    tipAmt = "0.00"
                                }
                            }
                            let datavalue = ["card_number": "****",
                                             "paxNumber": "pax_pay_\(i)",
                                "txn_id": "1",
                                "total": "\(SubTotalPrice)",
                                "TotalAmount": "\(totalAmount)",
                                "tipAmount": "\(tipAmt)"]
                            self.arrCardData.add(datavalue)
                            isPax = true
                        }
                    }
                    
                    if isCredit || isPax {
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            self.delegate?.sendSignatureScreen?(arrcardData: arrCardData)
                            Indicator.sharedInstance.hideIndicator()
                        } else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "MultipleSignatureViewController") as! MultipleSignatureViewController
                            vc.arrCardData = arrCardData
                            vc.signatureDelegate = self
                            present(vc, animated: true, completion: nil)
                            //prepareForPlaceOrder()
                        }
                        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                            MainSocketManager.shared.onOpenSignature(signArry: self.arrCardData, subTotal: Double(strSplitAmount) ?? 0.00, total: Double(strSplitAmount) ?? 0.00, paxLoader: paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" ? true : false)
                        }
                        
                    } else {
                        prepareForPlaceOrder()
                    }
                } else {
                    prepareForPlaceOrder()
                }
                
            }
        }
    }
    
    func placeOrderForIpad(with data: AnyObject) {
        Indicator.sharedInstance.showIndicator()
        self.orderType = data["orderType"] as? OrderType ?? .newOrder
        
        if self.orderType == .refundOrExchangeOrder || isOpenToOrderHistory {
            self.orderInfoObj = data["orderInfoObj"] as! OrderInfoModel
        }
        self.cartProductsArray = data["cartArray"] as! Array<Any>
        self.CustomerObj = data["customerObj"]as! CustomerListModel
        // MARK Hide for V5
        
        if HomeVM.shared.DueShared > 0 {
            self.totalAmount = HomeVM.shared.DueShared
        }else{
            self.totalAmount = data["Total"]as! Double
        }
        
        if paymentName == "CARD READER" {
            for i in 0..<appDelegate.arrIngenicoSigTip.count {
                let arrsign = appDelegate.arrIngenicoSigTip[i]
                
                let cardNo = arrsign["card_number"] as? String
                let totalSign = arrsign["TotalAmount"]
                let TltVal = appDelegate.arrIngenicoSigTip[0]["TotalAmount"] as? String
                totalAmount = TltVal?.toDouble() ?? 0.0
                str_SignatureData = arrsign["signature"] as? String ?? ""
            }
            
        }
        
        if DataManager.isSplitPayment {
            //strSplitAmount = dict["spliteAmount"] as? String ?? ""
        } else {
            strSplitAmount = "\(totalAmount)"
        }
        
        
        self.str_Notes = data["notes"]as! String
        self.str_RegionName = data["taxStateName"]as! String
        self.str_ShippingANdHandling = data["ShippingHandling"]as! String
        self.str_AddDiscount = data["addDiscount"]as! String
        self.SubTotalPrice = data["subTotal"]as! Double
        self.str_TaxAmount = data["tax"]as! String
        self.str_AddCouponName = data["couponName"]as! String
        
        //Validate Data
        if !validatePaymentData() {
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        
        
        //Order
        if paymentName == "CREDIT" || paymentName == "credit" || paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
            //if str_AUTH.uppercased() != "AUTH"
            //{
            //                if UI_USER_INTERFACE_IDIOM() == .pad {
            //                    self.delegate?.didPerformSegueWith?(identifier: "signatureSegue")
            //                }else {
            //                    self.performSegue(withIdentifier: "signatureSegue", sender: nil)
            //                }
            if (paxPaymentType == "CREDIT" || paxPaymentType == "DEBIT") && str_AUTH == "AUTH_CAPTURE" {
                appDelegate.strPaxMode = ""
            }
            
            if ((DataManager.signature && DataManager.isSingatureOnEMV) && !DataManager.collectTips) || (HomeVM.shared.DueShared > 0 && (DataManager.signature && DataManager.isSingatureOnEMV)) || (HomeVM.shared.DueShared > 0 && !DataManager.signature && DataManager.collectTips) {
                
                if paymentName == "CREDIT" || paymentName == "credit" || paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
                    if ((DataManager.signature && DataManager.isSingatureOnEMV)){
                        if DataManager.collectTips || DataManager.signature {
                            
                            if paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
                                self.arrCardData.removeAllObjects()
                                //let last4 = str_CreditCardNumber.suffix(4)
                                
                                if HomeVM.shared.MultiTipValue > 0 {
                                    
                                } 
                                
                                let datavalue = ["card_number": "****",
                                                 "txn_id": "1",
                                                 "total": "\(SubTotalPrice)",
                                    "TotalAmount": "\(strSplitAmount)",
                                    "tipAmount": "\(HomeVM.shared.errorTip)"]
                                self.arrCardData.add(datavalue)
                                
                                if ((DataManager.signature && DataManager.isSingatureOnEMV) && !DataManager.collectTips) {
                                    print("dev inter")
                                    prepareForPlaceOrder()
                                    return
                                } else if appDelegate.strPaxMode == "GIFT" && ((DataManager.signature && DataManager.isSingatureOnEMV) && DataManager.collectTips){
                                    prepareForPlaceOrder()
                                    return
                                }
                            } else {
                                self.arrCardData.removeAllObjects()
                                let last4 = str_CreditCardNumber.suffix(4)
                                let datavalue = ["card_number": last4,
                                                 "txn_id": "1",
                                                 "total": "\(SubTotalPrice)",
                                    "TotalAmount": "\(strSplitAmount)",
                                    "tipAmount": "\(HomeVM.shared.errorTip)"]
                                self.arrCardData.add(datavalue)
                            }
                            if UI_USER_INTERFACE_IDIOM() == .pad {
                                self.delegate?.sendSignatureScreen?(arrcardData: arrCardData)
                                Indicator.sharedInstance.hideIndicator()
                            } else {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "MultipleSignatureViewController") as! MultipleSignatureViewController
                                vc.arrCardData = arrCardData
                                vc.signatureDelegate = self
                                present(vc, animated: true, completion: nil)
                                //prepareForPlaceOrder()
                            }
                            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                                let socketConnectionStatus = MainSocketManager.shared.socket.status
                                
                                switch socketConnectionStatus {
                                case SocketIOStatus.connected:
                                    print("socket connected")
                                    MainSocketManager.shared.onOpenSignature(signArry: self.arrCardData, subTotal: Double(strSplitAmount) ?? 0.00, total: Double(strSplitAmount) ?? 0.00, paxLoader: paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" ? true : false)
                                case SocketIOStatus.connecting:
                                    print("socket connecting")
                                case SocketIOStatus.disconnected:
                                    print("socket disconnected")
                                case SocketIOStatus.notConnected:
                                    print("socket not connected")
                                }
                            }
                        } else {
                            prepareForPlaceOrder()
                        }
                    } else {
                        if DataManager.collectTips || DataManager.signature {
                            if paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
                                self.arrCardData.removeAllObjects()
                                //let last4 = str_CreditCardNumber.suffix(4)
                                
                                if HomeVM.shared.MultiTipValue > 0 {
                                    
                                }
                                
                                let datavalue = ["card_number": "****",
                                                 "txn_id": "1",
                                                 "total": "\(SubTotalPrice)",
                                    "TotalAmount": "\(strSplitAmount)",
                                    "tipAmount": "\(HomeVM.shared.errorTip)"]
                                self.arrCardData.add(datavalue)
                                if (appDelegate.strPaxMode == "GIFT" && (!DataManager.isSingatureOnEMV && !DataManager.signature) && DataManager.collectTips) {
                                    prepareForPlaceOrder()
                                    return
                                }
                            } else {
                                self.arrCardData.removeAllObjects()
                                let last4 = str_CreditCardNumber.suffix(4)
                                let datavalue = ["card_number": last4,
                                                 "txn_id": "1",
                                                 "total": "\(SubTotalPrice)",
                                    "TotalAmount": "\(strSplitAmount)",
                                    "tipAmount": "\(HomeVM.shared.errorTip)"]
                                self.arrCardData.add(datavalue)
                            }
                            if UI_USER_INTERFACE_IDIOM() == .pad {
                                self.delegate?.sendSignatureScreen?(arrcardData: arrCardData)
                                Indicator.sharedInstance.hideIndicator()
                            } else {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "MultipleSignatureViewController") as! MultipleSignatureViewController
                                vc.arrCardData = arrCardData
                                vc.signatureDelegate = self
                                present(vc, animated: true, completion: nil)
                                //prepareForPlaceOrder()
                            }
                            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                                let socketConnectionStatus = MainSocketManager.shared.socket.status
                                
                                switch socketConnectionStatus {
                                case SocketIOStatus.connected:
                                    print("socket connected")
                                    MainSocketManager.shared.onOpenSignature(signArry: self.arrCardData, subTotal: Double(strSplitAmount) ?? 0.00, total: Double(strSplitAmount) ?? 0.00, paxLoader: paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" ? true : false)
                                case SocketIOStatus.connecting:
                                    print("socket connecting")
                                case SocketIOStatus.disconnected:
                                    print("socket disconnected")
                                case SocketIOStatus.notConnected:
                                    print("socket not connected")
                                }
                            }
                        } else {
                            prepareForPlaceOrder()
                        }
                    }
                } else {
                    prepareForPlaceOrder()
                }
                
            } else {
                if DataManager.collectTips || DataManager.signature {
                    if paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
                        self.arrCardData.removeAllObjects()
                        //let last4 = str_CreditCardNumber.suffix(4)
                        let datavalue = ["card_number": "****",
                                         "txn_id": "1",
                                         "total": "\(SubTotalPrice)",
                            "TotalAmount": "\(strSplitAmount)",
                            "tipAmount": "\(HomeVM.shared.errorTip)"]
                        self.arrCardData.add(datavalue)
                        if appDelegate.strPaxMode == "GIFT" && ((DataManager.signature && DataManager.isSingatureOnEMV) && DataManager.collectTips){
                            prepareForPlaceOrder()
                            return
                        } else if (appDelegate.strPaxMode == "GIFT" && DataManager.isSingatureOnEMV && DataManager.collectTips) {
                            prepareForPlaceOrder()
                            return
                        } else if (appDelegate.strPaxMode == "GIFT" && (!DataManager.isSingatureOnEMV && !DataManager.signature) && DataManager.collectTips) {
                            prepareForPlaceOrder()
                            return
                        }
                    } else {
                        self.arrCardData.removeAllObjects()
                        let last4 = str_CreditCardNumber.suffix(4)
                        let datavalue = ["card_number": last4,
                                         "txn_id": "1",
                                         "total": "\(SubTotalPrice)",
                            "TotalAmount": "\(strSplitAmount)",
                            "tipAmount": "\(HomeVM.shared.errorTip)"]
                        self.arrCardData.add(datavalue)
                    }
                    
                    if orderType == .refundOrExchangeOrder {
                        prepareForPlaceOrder()
                    } else {
                        
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            self.delegate?.sendSignatureScreen?(arrcardData: arrCardData)
                            Indicator.sharedInstance.hideIndicator()
                        } else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "MultipleSignatureViewController") as! MultipleSignatureViewController
                            vc.arrCardData = arrCardData
                            vc.signatureDelegate = self
                            present(vc, animated: true, completion: nil)
                            //prepareForPlaceOrder()
                        }
                        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                            MainSocketManager.shared.onOpenSignature(signArry: self.arrCardData, subTotal: Double(strSplitAmount) ?? 0.00, total: Double(strSplitAmount) ?? 0.00, paxLoader: paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" ? true : false)
                            //main chnages right sudama for socket
                        }
                    }
                    
                } else {
                    prepareForPlaceOrder()
                }
            }
        }
        else
        {
            if paymentName == "MULTI CARD" || paymentName == "multi card" || paymentName == "multi_card" {
                
                if (HomeVM.shared.DueShared > 0 && (DataManager.signature && DataManager.isSingatureOnEMV)) || (HomeVM.shared.DueShared > 0 && !DataManager.signature && DataManager.collectTips) {
                    prepareForPlaceOrder()
                } else {
                    var isCredit = false
                    var isPax = false
                    
                    arrCardData.removeAllObjects()
                    
                    if DataManager.collectTips || DataManager.signature {
                        if let multiData = multicardData["credit"] as? JSONArray {
                            print(multiData.count)
                            
                            for i in 0..<multiData.count {
                                let dataval = multiData[i]["cc_account"] as? String
                                var tipAmt = "0.00"
                                if let tip = multiData[i]["tip"] {
                                    tipAmt = tip as? String ?? "0.00"
                                    if tipAmt == "" {
                                        tipAmt = "0.00"
                                    }
                                }
                                
                                let last4 = dataval?.suffix(4)
                                let datavalue = ["card_number": last4,
                                                 "txn_id": "1",
                                                 "total": "\(SubTotalPrice)",
                                    "TotalAmount": "\(totalAmount)",
                                    "tipAmount": "\(tipAmt)"] as [String : Any]
                                self.arrCardData.add(datavalue)
                                isCredit = true
                            }
                            
                        }
                        
                        if ((DataManager.signature && DataManager.isSingatureOnEMV) && !DataManager.collectTips) {
                            
                        } else {
                            if let paxpay = multicardData["pax_pay"] as? JSONArray {
                                for i in 0..<paxpay.count {
                                    
                                    var tipAmt = "0.00"
                                    if let tip = paxpay[i]["tip"] {
                                        tipAmt = tip as? String ?? "0.00"
                                        if tipAmt == "" {
                                            tipAmt = "0.00"
                                        }
                                    }
                                    
                                    //let dataval = paxpay[i]["cc_account"] as? String
                                    //let last4 = dataval?.suffix(4)
                                    let datavalue = ["card_number": "****",
                                                     "paxNumber": "pax_pay_\(i)",
                                        "txn_id": "1",
                                        "total": "\(SubTotalPrice)",
                                        "TotalAmount": "\(totalAmount)",
                                        "tipAmount": "\(tipAmt)"]
                                    self.arrCardData.add(datavalue)
                                    isPax = true
                                }
                            }
                        }
                        
                        if isCredit || isPax {
                            if UI_USER_INTERFACE_IDIOM() == .pad {
                                self.delegate?.sendSignatureScreen?(arrcardData: arrCardData)
                                Indicator.sharedInstance.hideIndicator()
                            } else {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "MultipleSignatureViewController") as! MultipleSignatureViewController
                                vc.arrCardData = arrCardData
                                vc.signatureDelegate = self
                                present(vc, animated: true, completion: nil)
                                //prepareForPlaceOrder()
                            }
                            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
                                MainSocketManager.shared.onOpenSignature(signArry: self.arrCardData, subTotal: Double(strSplitAmount) ?? 0.00, total: Double(strSplitAmount) ?? 0.00, paxLoader: paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" ? true : false)
                            }
                        } else {
                            prepareForPlaceOrder()
                        }
                    } else {
                        prepareForPlaceOrder()
                    }
                    
                }
                
            } else {
                
                if paymentName == "INVOICE" || paymentName == "invoice" || (paymentName == "CARD READER") || (paymentName == "card reader") {
                    
                    prepareForPlaceOrder()
                }else{
                    var total = ""
                    
                    if (paymentName == "MULTI CARD") || (paymentName == "multi_card"){
                        
                    }
                    if (paymentName == "CHECK") || (paymentName == "check"){
                        total = "\(str_CheckAmount)"
                    }
                    if (paymentName == "ACH CHECK") || (paymentName == "ach_check"){
                        total = "\(strSplitAmount)"
                    }
                    if (paymentName == "GIFT CARD") || (paymentName == "gift_card"){
                        total = "\(strSplitAmount)"
                    }
                    if (paymentName == "EXTERNAL GIFT CARD") || (paymentName == "external_gift_card" || paymentName == "external_gift") {
                        total = "\(strSplitAmount)"
                    }
                    if (paymentName == "INTERNAL GIFT CARD") || (paymentName == "internal_gift_card")
                    {
                        total = "\(strSplitAmount)"
                    }
                    if (paymentName == "EXTERNAL") || (paymentName == "external"){
                        total = str_ExternalAmount
                    }
                    if (paymentName == "CASH") || (paymentName == "cash"){
                        total = str_Cash.replacingOccurrences(of: "$", with: "")
                    }else{
                        //total = "\(totalAmount)"
                    }
                    self.arrCardData.removeAllObjects()
                    let datavalue = ["card_number": paymentName.capitalized,
                                     "txn_id": "1",
                                     "total": "",
                                     "TotalAmount": "\(total)",
                                     "tipAmount": ""]
                    self.arrCardData.add(datavalue)
                    if DataManager.signature && DataManager.posCollectSignatureOnEveryOrder {
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            self.delegate?.sendSignatureScreen?(arrcardData: arrCardData)
                            Indicator.sharedInstance.hideIndicator()
                        } else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "MultipleSignatureViewController") as! MultipleSignatureViewController
                            vc.arrCardData = arrCardData
                            vc.signatureDelegate = self
                            present(vc, animated: true, completion: nil)
                            
                        }
                    }else{
                        prepareForPlaceOrder()
                    }
                    if DataManager.signature && DataManager.posCollectSignatureOnEveryOrder {
                        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                            let socketConnectionStatus = MainSocketManager.shared.socket.status
                            
                            switch socketConnectionStatus {
                            case SocketIOStatus.connected:
                                print("socket connected")
                                MainSocketManager.shared.onOpenSignature(signArry: self.arrCardData, subTotal: Double(strSplitAmount) ?? 0.00, total: Double(total) ?? 0.00, paxLoader: paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" ? true : false)
                            case SocketIOStatus.connecting:
                                print("socket connecting")
                            case SocketIOStatus.disconnected:
                                print("socket disconnected")
                            case SocketIOStatus.notConnected:
                                print("socket not connected")
                            }
                        }
                    }
                }
            }
        }
    }
}


//MARK: Prepare Order For API
extension PaymentsViewController {
    func prepareForPlaceOrder() {
        if cartProductsArray.count == 0 {
            //            self.showAlert(message: "Please add atleast one product in cart for make payment.")
            appDelegate.showToast(message: "Please add atleast one product in cart for make payment.")
            return
        }
        let starMacAddrs = DataManager.isGooglePrinter ? DataManager.starCloudMACaAddress ?? "" : ""

        Indicator.sharedInstance.showIndicator()
        var cust_str_postal = ""
        if CustomerObj.str_postal_code != "" {
            cust_str_postal = phoneNumberFormateRemoveText(number: CustomerObj.str_postal_code)
        }
        
        var ord_str_postal = ""
        if orderInfoObj.postalCode != "" {
            ord_str_postal = phoneNumberFormateRemoveText(number: orderInfoObj.postalCode)
        }
        
        var ord_str_shippingPhone = ""
        if orderInfoObj.shippingPhone != "" {
            ord_str_shippingPhone = phoneNumberFormateRemoveText(number: orderInfoObj.shippingPhone)
        }
        
        var ord_str_shippingPostalCode = ""
        if orderInfoObj.shippingPostalCode != "" {
            ord_str_shippingPostalCode = phoneNumberFormateRemoveText(number: orderInfoObj.shippingPostalCode)
        }
        
        var ord_str_phone = ""
        if orderInfoObj.phone != "" {
            ord_str_phone = phoneNumberFormateRemoveText(number: orderInfoObj.phone)
        }
        
        var cust_str_Shippingphone = ""
        if CustomerObj.str_Shippingphone != "" {
            cust_str_Shippingphone = phoneNumberFormateRemoveText(number: CustomerObj.str_Shippingphone)
        }
        
        var cust_str_Shippingpostal_code = ""
        if CustomerObj.str_Shippingpostal_code != "" {
            cust_str_Shippingpostal_code = phoneNumberFormateRemoveText(number: CustomerObj.str_Shippingpostal_code)
        }
        
        var cust_str_Billingphone = ""
        if CustomerObj.str_Billingphone != "" {
            cust_str_Billingphone = phoneNumberFormateRemoveText(number: CustomerObj.str_Billingphone)
        }
        
        var cust_str_Billingpostal_code = ""
        if CustomerObj.str_Billingpostal_code != "" {
            cust_str_Billingpostal_code = phoneNumberFormateRemoveText(number: CustomerObj.str_Billingpostal_code)
        }
        
        var cust_str_phone = ""
        if CustomerObj.str_phone != "" {
            cust_str_phone = phoneNumberFormateRemoveText(number: CustomerObj.str_phone)
        }
        
        
        //Device Name
        var str_DeviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        
        var dict = [String: Any]()
        var productsArray = Array<Any>()
        var isAllManualProducts = [Bool]()
        var metaFieldsDict = JSONDictionary()
        
        if orderType == .newOrder {
            //Load Products
            for i in (0..<self.cartProductsArray.count)
            {
                let obj = (cartProductsArray as AnyObject).object(at: i)
                dict["product_id"] = (obj as AnyObject).value(forKey: "productid") as! String
                dict["man_price"] = Double((obj as AnyObject).value(forKey: "productprice") as! String)?.roundToTwoDecimal
                dict["qty"] = (obj as AnyObject).value(forKey: "productqty") as! String
                dict["row_id"] = i + 1
                dict["manual_description"] = (obj as AnyObject).value(forKey: "productNotes") as? String ?? ""
                let isTaxExempt = ((obj as AnyObject).value(forKey: "isTaxExempt") as? String ?? "No").lowercased()
                dict["tax_exempt"] = isTaxExempt == "no" ? false : true
                let isManualProduct = (obj as AnyObject).value(forKey: "isManualProduct") as? Bool ?? false
                isAllManualProducts.append(isManualProduct)
                // by sudama add sub
                let is_subscription = (obj as AnyObject).value(forKey: "addSubscription") as? Bool ?? false
                dict["is_subscription"] = is_subscription
                //
                
                // by sudama add sub
                let date = Date()
                let format = DateFormatter()
                format.dateFormat = "yyyy/MM/dd "
                let formattedDate = format.string(from: date)
                print(formattedDate)
                
                var addSubDict = [String: Any]()
                let  frequencySub = (obj as AnyObject).value(forKey: "frequencySub") as? String
                let  daymnth = (obj as AnyObject).value(forKey: "daymnth") as? String
                let  numberOfOcc = (obj as AnyObject).value(forKey: "numberOfOcc") as? String
                let  unlimitedCheck = (obj as AnyObject).value(forKey: "unlimitedCheck") as? Bool
                if is_subscription {
                    addSubDict["payment_period"] = frequencySub
                    addSubDict["days_or_months"] = daymnth
                    addSubDict["lifespan"] = numberOfOcc
                    addSubDict["unlimted_occurence"] = unlimitedCheck
                    addSubDict["next_order_date_subscription"] = formattedDate
                    dict["subscription_data"] = addSubDict
                }
                //                else{
                //                    addSubDict["payment_period"] = ""
                //                    addSubDict["days_or_months"] = ""
                //                    addSubDict["lifespan"] = ""
                //                    addSubDict["unlimted_occurence"] = false
                //                    addSubDict["next_order_date_subscription"] = ""
                //                    dict["subscription_data"] = addSubDict
                //                }
                //
                var variationsArray = JSONArray()
                
                var variationArrayDetails = JSONArray()
                var surchargvariationArrayDetails = JSONArray()
                var attributeArrayDetails = JSONArray()
                
                if let productvariationArray = (obj as AnyObject).value(forKey: "variationArray") as? JSONArray {
                    variationArrayDetails = productvariationArray
                }
//                if isOpenToOrderHistory {
//                    if let productvariationArray = (obj as AnyObject).value(forKey: "variationData") as? JSONArray {
//                        variationArrayDetails = productvariationArray
//                    }
//                }
                
                if let surchargevariationArray = (obj as AnyObject).value(forKey: "surchargVariationArray") as? JSONArray {
                    surchargvariationArrayDetails = surchargevariationArray
                }
                
                
                
                if let productDetailArray = (obj as AnyObject).value(forKey: "attributesArray") as? JSONArray {
                    
                    attributeArrayDetails = productDetailArray
                    
                    //                    let productDetail = ProductModel.shared.getProductDetailStruct(jsonArray: productDetailArray)
                    //                    for i in 0..<productDetail.count {      //DDD
                    //                        let arrayData  = productDetail[i].valuesAttribute as [AttributesModel] as NSArray
                    //                        let attributeModel = arrayData[0] as! AttributesModel
                    //                        let jsonArray = attributeModel.jsonArray
                    //                        if let hh = jsonArray {
                    //                            let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                    //                            //print(arrayAttrData)
                    //
                    //                            for value in arrayAttrData {
                    //
                    //                                if value.isSelect {
                    //
                    //
                    //                                    var variationsDict = JSONDictionary()
                    //                                    variationsDict["variation_id"] = "0"
                    //                                    variationsDict["attribute_id"] = value.attribute_id
                    //                                    variationsDict["attribute_value_id"] = value.attribute_value_id
                    //                                    //selectedIDArray.append(Int(value.attribute_value_id) ?? 0)
                    //                                    variationsArray.append(variationsDict)
                    //                                }
                    //                            }
                    //                        }
                    //                    }
                    
                    //                    for detail in productDetail {
                    ////                        for value in detail.values {   //DDD
                    ////                            if value.isSelected {
                    ////                                var variationsDict = JSONDictionary()
                    ////                                variationsDict["variation_id"] = value.variationId
                    ////                                variationsDict["attribute_id"] = value.attributeId
                    ////                                variationsDict["attribute_value_id"] = value.attributeValueId
                    ////                                variationsArray.append(variationsDict)
                    ////                            }
                    ////                        }
                    //                    }
                }
                if isOpenToOrderHistory {
                    if let productvariationArray = (obj as AnyObject).value(forKey: "variationNewData") as? JSONArray {
                        dict["variations"] = productvariationArray
                    }
                    dict["sales_id"] = (obj as AnyObject).value(forKey: "sales_id") as? String ?? ""
                    dict["discount"] = (obj as AnyObject).value(forKey: "perProductDiscount") as? String ?? ""
                    dict["per_product_tax"] = (obj as AnyObject).value(forKey: "perProductTax") as? String ?? ""
                   // dict["isProcessInvoice"] = (obj as AnyObject).value(forKey: "isProcessInvoice") as? Bool ?? true
                    dict["varId"] = ""
                    dict["manual_description"] = (obj as AnyObject).value(forKey: "manual_description") as? String ?? ""
                    
                    
                }else{
                    let value = getVariationValueForProduct(attributeObj: attributeArrayDetails, variationObj: variationArrayDetails, surchargeObj: surchargvariationArrayDetails)
                    dict["variations"] = value
                }
                
                
                if let dictArray = (obj as AnyObject).value(forKey: "itemMetaFieldsArray") as? JSONArray {
                    print(dictArray)
                    for dict in dictArray {
                        print(dict)
                        if let jsonArray = dict["values"] as? JSONArray {
                            for value in jsonArray {
                                //  isShowDetails = true
                                let keyMeta = value["name"] as? String ?? ""
                                let valueMeta = value["tempValue"] as? String ?? ""
                                if valueMeta != "" {
                                    //   metaFieldsDict.append("\(keyMeta): \(valueMeta)\n")
                                    metaFieldsDict[keyMeta] = valueMeta
                                }
                            }
                        }
                    }
                }
                dict["meta_fields"] = metaFieldsDict
                if isOpenToOrderHistory {
                    dict["meta_fields"] = (obj as AnyObject).value(forKey: "meta_fieldsDictionary") as? JSONDictionary
                }
                productsArray.append(dict)
            }
        }else {
            //Load Products
            for i in (0..<self.cartProductsArray.count)
            {
                let obj = (cartProductsArray as AnyObject).object(at: i)
                dict["product_id"] = (obj as AnyObject).value(forKey: "productid") as! String
                let isRefundProduct = (obj as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
                if isRefundProduct {
                    
                    let manPriceData = (Double((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0) + ((obj as AnyObject).value(forKey: "per_product_tax") as? Double ?? 0)) - ((obj as AnyObject).value(forKey: "per_product_discount") as? Double ?? 0)
                    dict["base_price"] = "\((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0)"
                    dict["price"] = Double((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0).roundToTwoDecimal
                    dict["man_price"] = manPriceData
                    dict["qty"] = (obj as AnyObject).value(forKey: "productqty") as? Double ?? 1
                    dict["title"] = (obj as AnyObject).value(forKey: "producttitle") as? String ?? ""
                    dict["is_taxable"] = (obj as AnyObject).value(forKey: "is_taxable") as? String ?? ""
                    dict["isRefunded"] = false
                    dict["is_refund_item"] = true
                    if (obj as AnyObject).value(forKey: "salesID") as? String ?? "" == "" {
                        dict["sales_id"] = ""
                        //dict["is_refund_item"] = false
                    } else {
                        dict["sales_id"] = (obj as AnyObject).value(forKey: "salesID") as? String ?? ""
                        //dict["is_refund_item"] = true
                    }
                    dict["per_product_discount"] = (obj as AnyObject).value(forKey: "per_product_discount") as? Double ?? 0
                    dict["per_product_tax"] = (obj as AnyObject).value(forKey: "per_product_tax") as? Double ?? 0
                    
                    dict["backToStock"] = (obj as AnyObject).value(forKey: "returnToStock") as? Bool ?? false
                }else {
                    dict["sales_id"] = ""
                    dict["is_refund_item"] = false
                    dict["base_price"] = Double((obj as AnyObject).value(forKey: "productprice") as! String)?.roundToTwoDecimal
                    dict["price"] = Double((obj as AnyObject).value(forKey: "productprice") as! String)?.roundToTwoDecimal
                    dict["man_price"] = Double((obj as AnyObject).value(forKey: "productprice") as! String)?.roundToTwoDecimal
                    dict["qty"] = (obj as AnyObject).value(forKey: "productqty") as! String
                }
                
                dict["row_id"] = i + 1
                dict["manual_description"] = (obj as AnyObject).value(forKey: "productNotes") as? String ?? ""
                let isTaxExempt = ((obj as AnyObject).value(forKey: "isTaxExempt") as? String ?? "No").lowercased()
                dict["tax_exempt"] = isTaxExempt == "no" ? false : true
                let isManualProduct = (obj as AnyObject).value(forKey: "isManualProduct") as? Bool ?? false
                isAllManualProducts.append(isManualProduct)
                
                var variationArrayDetails = JSONArray()
                var surchargvariationArrayDetails = JSONArray()
                var attributeArrayDetails = JSONArray()
                
                if let productvariationArray = (obj as AnyObject).value(forKey: "variationArray") as? JSONArray {
                    variationArrayDetails = productvariationArray
                }
                
                if let surchargevariationArray = (obj as AnyObject).value(forKey: "surchargVariationArray") as? JSONArray {
                    surchargvariationArrayDetails = surchargevariationArray
                }
                
                if let productDetailArray = (obj as AnyObject).value(forKey: "attributesArray") as? JSONArray {
                    attributeArrayDetails = productDetailArray
                    
                    
                    //                    let productDetail = ProductModel.shared.getProductDetailStruct(jsonArray: productDetailArray)
                    //                    for i in 0..<productDetail.count {      //DDD
                    //                        let arrayData  = productDetail[i].valuesAttribute as [AttributesModel] as NSArray
                    //                        let attributeModel = arrayData[0] as! AttributesModel
                    //                        let jsonArray = attributeModel.jsonArray
                    //                        if let hh = jsonArray {
                    //                            let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                    //                            //print(arrayAttrData)
                    //
                    //                            for value in arrayAttrData {
                    //
                    //                                if value.isSelect {
                    //
                    //                                    var variationsDict = JSONDictionary()
                    //                                    variationsDict["variation_id"] = "0"
                    //                                    variationsDict["attribute_id"] = value.attribute_id
                    //                                    variationsDict["attribute_value_id"] = value.attribute_value_id
                    //                                    //selectedIDArray.append(Int(value.attribute_value_id) ?? 0)
                    //                                    variationsArray.append(variationsDict)
                    //                                }
                    //                            }
                    //                        }
                    //                    }
                    
                    
                    //                    let productDetail = ProductModel.shared.getProductDetailStruct(jsonArray: productDetailArray)
                    //                    for detail in productDetail {
                    ////                        for value in detail.values {    //DDD
                    ////                            if value.isSelected {
                    ////                                var variationsDict = JSONDictionary()
                    ////                                variationsDict["variation_id"] = value.variationId
                    ////                                variationsDict["attribute_id"] = value.attributeId
                    ////                                variationsDict["attribute_value_id"] = value.attributeValueId
                    ////                                variationsArray.append(variationsDict)
                    ////                            }
                    ////                        }
                    //                    }
                }
                
                let value = getVariationValueForProduct(attributeObj: attributeArrayDetails, variationObj: variationArrayDetails, surchargeObj: surchargvariationArrayDetails)
                
                dict["variations"] = value
                if let dictArray = (obj as AnyObject).value(forKey: "itemMetaFieldsArray") as? JSONArray {
                    print(dictArray)
                    for dict in dictArray {
                        print(dict)
                        if let jsonArray = dict["values"] as? JSONArray {
                            for value in jsonArray {
                                //  isShowDetails = true
                                let keyMeta = value["name"] as? String ?? ""
                                let valueMeta = value["tempValue"] as? String ?? ""
                                if valueMeta != "" {
                                    //   metaFieldsDict.append("\(keyMeta): \(valueMeta)\n")
                                    metaFieldsDict[keyMeta] = valueMeta
                                }
                            }
                        }
                    }
                }
                dict["meta_fields"] = metaFieldsDict
                productsArray.append(dict)
            }
        }
        var strFName = CustomerObj.str_first_name
        var strLName = CustomerObj.str_last_name
        
        var strFNameBil = CustomerObj.str_billing_first_name
        var strLNameBil = CustomerObj.str_billing_last_name
        //Payment name
        if (paymentName == "CARD READER") || (paymentName == "card reader")
        {
            if cardholderName != "" {
                if cardholderName.contains("/") {
                    let fullN = cardholderName.components(separatedBy: "/")
                    if strFName == "" {
                        strFName = String(fullN[1])
                        strFNameBil = strFName
                    }
                    if strLName == "" {
                        strLName = fullN[0]
                        strLNameBil = strLName
                    }
                    
                } else {
                    if strFName == "" {
                        strFName = cardholderName
                        strFNameBil = strFName
                    }
                }
                
            }
            paymentName = "credit"
        }
        if (paymentName == "CREDIT") || (paymentName == "credit")
        {
            paymentName = "credit"
        }
        if (paymentName == "INVOICE") || (paymentName == "invoice")
        {
            paymentName = "invoice"
        }
        if (paymentName == "ACH CHECK") || (paymentName == "ach_check")
        {
            paymentName = "ach_check"
        }
        if (paymentName == "GIFT CARD") || (paymentName == "gift_card")
        {
            paymentName = "gift_card"
        }
        if (paymentName == "EXTERNAL GIFT CARD") || (paymentName == "external_gift_card" || paymentName == "external_gift")
        {
            paymentName = "external_gift"
        }
        if (paymentName == "INTERNAL GIFT CARD") || (paymentName == "internal_gift_card")
        {
            paymentName = "internal_gift_card"
        }
        if (paymentName == "MULTI CARD") || (paymentName == "multi_card")
        {
            paymentName = "multi_card"
        }
        if (paymentName == "CHECK") || (paymentName == "check")
        {
            paymentName = "check"
        }
        if (paymentName == "EXTERNAL") || (paymentName == "external")
        {
            paymentName = "external"
        }
        if (paymentName == "PAX PAY") || (paymentName == "pax_pay")
        {
            paymentName = "pax_pay"
        }
        
        if paymentName != "credit" && paymentName != "pax_pay" {
            self.signatureImage = nil
        }
        
        let taxID = self.str_RegionName == "Default" ? DataManager.defaultTaxID : self.str_RegionName
        
        if (paymentName == "INVOICE") || (paymentName == "invoice") {
            //Prepare Parameters For Create Invoice
            if HomeVM.shared.customerUserId != "" {
                CustomerObj.str_userID = HomeVM.shared.customerUserId
            }
                        
            var preTxnRes = [JSONDictionary]()
            
            if appDelegate.isIngenicoDataFail {
                preTxnRes = DataManager.ingenicoOflineCaseData ?? [[:]]
            } else {
                preTxnRes = [[:]]
            }
            
            var parameters: Parameters = [
                "cust_id": CustomerObj.str_userID,
                "smartlist_id": "",
                "customer_status": CustomerObj.str_customer_status,
                "previousTxnResponse": preTxnRes,
                "customer_info": [
                    "first_name": CustomerObj.str_first_name,
                    "last_name": CustomerObj.str_last_name,
                    "email": invoiceEmail == "" ? CustomerObj.str_email : invoiceEmail,
                    "phone": cust_str_phone,
                    "address": CustomerObj.str_address,
                    "address2": CustomerObj.str_address2,
                    "city": CustomerObj.str_city,
                    "state": CustomerObj.str_region,
                    "zip":cust_str_postal,
                    "company":CustomerObj.str_company,
                    "country": CustomerObj.country,
                    "office_phone":CustomerObj.str_office_phone,
                    "contact_source": CustomerObj.str_contact_source
                ],
                "bill_profile_id": CustomerObj.str_bpid,
                "billing_info": [
                    "bill_first_name": CustomerObj.str_billing_first_name,
                    "bill_last_name": CustomerObj.str_billing_last_name,
                    "bill_address_1": CustomerObj.str_Billingaddress,
                    "bill_address_2": CustomerObj.str_Billingaddress2,
                    "bill_city": CustomerObj.str_Billingcity,
                    "bill_region": CustomerObj.str_Billingregion,
                    "bill_country": CustomerObj.billingCountry,
                    "bill_postal_code": cust_str_Billingpostal_code,
                    "bill_email": CustomerObj.str_Billingemail,
                    "bill_phone": cust_str_Billingphone,
                    "bill_company":CustomerObj.str_company
                ],
                "shipping_info": [
                    "ship_first_name": CustomerObj.str_first_name,
                    "ship_last_name": CustomerObj.str_last_name,
                    "ship_address_1": CustomerObj.str_Shippingaddress,
                    "ship_address_2": CustomerObj.str_Shippingaddress2,
                    "ship_city": CustomerObj.str_Shippingcity,
                    "ship_region": CustomerObj.str_Shippingregion,
                    "ship_country": CustomerObj.country,
                    "ship_postal_code": cust_str_Shippingpostal_code,
                    "ship_email": CustomerObj.str_Shippingemail,
                    "ship_phone": cust_str_Shippingphone
                ],
                "is_billing_same": DataManager.isCheckUncheckShippingBilling,
                "cart_info": [
                    "coupon": self.str_AddCouponName,
                    "products": productsArray,
                    "subtotal": self.SubTotalPrice.roundToTwoDecimal,
                    "discount": "",
                    "manual_discount": self.str_AddDiscount,
                    "shipping_handling": self.str_ShippingANdHandling,
                    "tax": "",
                    "custom_tax_id": taxID,
                    "depositAmount": depositeAmount,
                    "total": totalAmount.roundToTwoDecimal,
                    "reward_points" : DataManager.finalLoyaltyDiscount
                ],
                "merchant_id": "",
                "payment_type": paymentName,
                "custom_text_1": CustomerObj.str_CustomText1,
                "custom_text_2": CustomerObj.str_CustomText2,
                "card_info": [
                    "card_number": invoiceCardNumber,
                    "cc_exp_mo": invoiceCardMonth,
                    "cc_exp_yr": invoiceCardYear
                ],
                "isSaveInvoice": "\(isSaveInvoice)",
                "invoice_info": [
                    "po_number": str_Ponumber,
                    "terms": str_Terms,
                    "duedate": str_DueDate,
                    "title": str_invoiceTitle,
                    "rep": str_Rep,
                    "invoice_date": invoiceDate,
                    "tip": "",
                    "total": "",
                    "notes": str_NotesInvoice
                ],
                "user_comments": self.str_AddNote,
                "order_source": str_DeviceName,
                "notes": self.str_AddNote,
                "campaign_code": "",
                "sub_id": "",
                "orderId": 0,
                "crm_partner_order_id": "",
                "enable_split_row": DataManager.isSplitRow,
                "invoiceTemplateId": invoiceTemplateId // 08 nov 220 for invoice template by altab
            ]
            
            let newOrderData = parameters.filter({$0.key == "cust_id" || $0.key == "customer_info" || $0.key == "bill_profile_id" || $0.key == "billing_info" || $0.key == "shipping_info" || $0.key == "is_billing_same" || $0.key == "cart_info" || $0.key == "order_source" || $0.key == "notes" })
            
//            if newOrderData == DataManager.recentOrder && orderType == .newOrder {
//                if let recentOrderID = DataManager.recentOrderID {
//                    parameters["orderId"] = recentOrderID
//                }
//            }
            
            if (newOrderData == DataManager.recentOrder && orderType == .newOrder) || DataManager.recentOrderID != 0  {
                if let recentOrderID = DataManager.recentOrderID {
                    parameters["orderId"] = recentOrderID
                }
            }
            
            if paymentName != "cash" {
                // MARK Hide for V5
                
                if HomeVM.shared.DueShared > 0{
                    UserDefaults.standard.removeObject(forKey: "changeAmountKey")
                    UserDefaults.standard.synchronize()
                }else{
                    UserDefaults.standard.removeObject(forKey: "changeAmountKey")
                    UserDefaults.standard.synchronize()
                }
                
                UserDefaults.standard.removeObject(forKey: "changeAmountKey")
                UserDefaults.standard.synchronize()
            }
            
            print("****************************************************** Invoice Parameters Start ******************************************************")
            print(parameters)
            print("****************************************************** Invoice Parameters End ******************************************************")
            
            //Call API To Make Invoice
            self.callAPIToCreateOrder(parameters: parameters, isInvoice: true, isAllManualProducts: !isAllManualProducts.contains(false))
            
        }else {
            var total = totalAmount
            if UI_USER_INTERFACE_IDIOM() == .phone {
                switch paymentName {
                case "credit":
                    total += tipAmountCreditCard
                    break
                case "multi_card":
                    total += tipAmountMulticard
                    break
                case "pax_pay":
                    total += (Double(paxtip) ?? 0.0)
                    break
                default: break
                }
            }
            //Prepare Parameters For Create Order
            var parameters = Parameters()
            
            var preTxnRes = [JSONDictionary]()
            
            if appDelegate.isIngenicoDataFail {
                preTxnRes = DataManager.ingenicoOflineCaseData ?? [[:]]
            } else {
                preTxnRes = [[:]]
            }

            if orderType == .newOrder {
               
                if !str_CreditCardNumber.contains("*")   && !self.isBillingProfileIDSetError {
                    CustomerObj.str_bpid = ""
                } else {
                    if merchant == "" {
                        if paymentName == "credit"{
                            if DataManager.CardCount > 1 {
                                if !str_CreditCardNumber.contains("*") {
                                    if isBillingProfileIDSetError {
                                        CustomerObj.str_bpid = DataManager.ErrorBbpid
                                    } else {
                                        CustomerObj.str_bpid = ""
                                    }
                                    //CustomerObj.str_bpid = ""
                                } else {
                                    CustomerObj.str_bpid = DataManager.Bbpid
                                }
                                
                            } else {
                                if str_CreditCardNumber.contains("*") {
                                    CustomerObj.str_bpid =  CustomerObj.str_bpid
                                } else {
                                    if isBillingProfileIDSetError {
                                        CustomerObj.str_bpid = DataManager.ErrorBbpid
                                    } else {
                                        CustomerObj.str_bpid = ""
                                    }
                                    
                                }
                                //CustomerObj.str_bpid = DataManager.Bbpid
                            }
                            
                        } else {
                            if isBillingProfileIDSetError {
                                if paymentName == "credit"{
                                    CustomerObj.str_bpid = DataManager.Bbpid
                                } else {
                                   // if DataManager.customerId == "" {
                                        CustomerObj.str_bpid = DataManager.ErrorBbpid
                                   // } else {
                                        //CustomerObj.str_bpid = ""
                                   // }
                                    
                                }
                                //CustomerObj.str_bpid = DataManager.Bbpid
                            } else {
                                CustomerObj.str_bpid = ""
                            }
                        }
                        //CustomerObj.str_bpid = DataManager.Bbpid
                    } else {
                        if str_CreditCardNumber.contains("X") {
                            CustomerObj.str_bpid = DataManager.Bbpid
                        } else if str_CreditCardNumber.contains("*") {
                            if self.isBillingProfileIDSetError {
                                CustomerObj.str_bpid = DataManager.Bbpid
                            } else {
                                CustomerObj.str_bpid = ""
                            }
                        } else {
                            CustomerObj.str_bpid = ""
                        }
                    }
                }
                
                if HomeVM.shared.customerUserId != "" {
                    CustomerObj.str_userID = HomeVM.shared.customerUserId
                }
                
                parameters = [
                    "cust_id": CustomerObj.str_userID,
                    "customer_status": CustomerObj.str_customer_status,
                    "customer_info": [
                        "first_name": strFName,
                        "last_name": strLName,
                        "email": invoiceEmail == "" ? CustomerObj.str_email : invoiceEmail,
                        "phone": cust_str_phone,
                        "company":CustomerObj.str_company,
                        "address": CustomerObj.str_address,
                        "address2": CustomerObj.str_address2,
                        "city": CustomerObj.str_city,
                        "state": CustomerObj.str_region,
                        "zip":cust_str_postal,
                        "country": CustomerObj.country,
                        "office_phone":CustomerObj.str_office_phone,
                        "contact_source": CustomerObj.str_contact_source
                    ],
                    "bill_profile_id": CustomerObj.str_bpid,
                    "billing_info": [
                        "bill_first_name": strFNameBil,
                        "bill_last_name": strLNameBil,
                        "bill_address_1": CustomerObj.str_Billingaddress,
                        "bill_address_2": CustomerObj.str_Billingaddress2,
                        "bill_city": CustomerObj.str_Billingcity,
                        "bill_region": CustomerObj.str_Billingregion,
                        "bill_country": CustomerObj.billingCountry,
                        "bill_postal_code": cust_str_Billingpostal_code,
                        "bill_email": CustomerObj.str_Billingemail,
                        "bill_phone": cust_str_Billingphone,
                        "bill_company":CustomerObj.str_company
                    ],
                    "shipping_info": [
                        "ship_first_name": CustomerObj.str_shipping_first_name,
                        "ship_last_name": CustomerObj.str_shipping_last_name,
                        "ship_address_1": CustomerObj.str_Shippingaddress,
                        "ship_address_2": CustomerObj.str_Shippingaddress2,
                        "ship_city": CustomerObj.str_Shippingcity,
                        "ship_region": CustomerObj.str_Shippingregion,
                        "ship_country": CustomerObj.shippingCountry,
                        "ship_postal_code": cust_str_Shippingpostal_code,
                        "ship_email": CustomerObj.str_Shippingemail,
                        "ship_phone": cust_str_Shippingphone
                    ],
                    "is_billing_same": DataManager.isCheckUncheckShippingBilling,
                    "cart_info": [
                        "coupon": self.str_AddCouponName,
                        "products": productsArray,
                        "subtotal": self.SubTotalPrice.roundToTwoDecimal,
                        "discount": "",
                        "manual_discount": self.str_AddDiscount,
                        "shipping_handling": self.str_ShippingANdHandling,
                        "tax": "",
                        "custom_tax_id": taxID,
                        "total": "\(total)",
                        "reward_points" : DataManager.finalLoyaltyDiscount
                    ],
                    "merchant_id": "",
                    "payment_type": paymentName,
                    "payment_method": str_AUTH,
                    "custom_text_1": CustomerObj.str_CustomText1,
                    "custom_text_2": CustomerObj.str_CustomText2,
                    "isSplitPayment" : DataManager.isSplitPayment,
                    "previousTxnResponse": preTxnRes,
                    "credit": [
                        "amount": strSplitAmount,
                        "cc_account": str_CreditCardNumber,
                        "cc_exp_mo": str_MM,
                        "cc_exp_yr": str_YYYY,
                        "cc_cvv": str_CVV,
                        "tip": tipAmountCreditCard.roundToTwoDecimal,
                        "total": strSplitAmount,
                        "digital_signature": str_SignatureData,
                        "orig_txn_response": orig_txn_response,
                        "merchant": merchant,
                        "merchant_id": merchant_Id,
                        "txn_response": txn_response
                    ],
                    "cash": [
                        "amount": str_Cash.replacingOccurrences(of: "$", with: ""),
                        "tip": "",
                        "total": "",
                        "digital_signature": str_SignatureData
                    ],
                    "invoice": [
                        "po_number": str_Ponumber,
                        "terms": str_Terms,
                        "rep": str_Rep,
                        "invoice_date": "",
                        "tip": "",
                        "total": "",
                        "notes": str_NotesInvoice
                    ],
                    "ach_check": [
                        "routing_number": str_RoutingNumber,
                        "account_number": str_AccountNumber,
                        "dl_number": str_DLNumber,
                        "amount": strSplitAmount,
                        "dl_state": str_DLState,
                        "check_type": "",
                        "sec_code": "",
                        "account_type": "",
                        "tip": "",
                        "total": "",
                        "digital_signature": str_SignatureData
                    ],
                    "gift_card": [
                        "gift_card_number": str_GiftCardNumber,
                        "gift_card_pin": str_CardPin,
                        "amount": strSplitAmount,
                        "tip": "",
                        "total": "",
                        "digital_signature": str_SignatureData
                    ],
                    "external_gift": [
                        "gift_card_number": str_ExternalGiftCardNumber,
                        "amount": strSplitAmount,
                        "tip": "",
                        "total": "",
                        "digital_signature": str_SignatureData
                    ],
                    "internal_gift_card": [
                        "gift_card_number": str_InternalGiftCardNumber,
                        "amount": strSplitAmount,
                        "tip": "",
                        "total": "",
                        "digital_signature": str_SignatureData
                    ],
                    "multi_card": multicardData,
                    "check": [
                        "amount": str_CheckAmount,
                        "check_number": str_CheckNumber,
                        "tip": "",
                        "total": "",
                        "digital_signature": str_SignatureData
                    ],
                    "external": [
                        "amount": str_ExternalAmount,
                        "tip": "",
                        "total": "",
                        "digital_signature": str_SignatureData,
                        "external_approval_number": str_externalAprrovalNumber
                    ],
                    "pax_pay": [
                        "pax_payment_type": paxPaymentType,
                        "pax_url": paxUrl,
                        "device_name": paxDevice,
                        "tip": paxtip,
                        //"amount": paxTotal,
                        "pax_pay_receipt" : DataManager.isSingatureOnEMV,
                        "use_token" : isCardFileSelected,
                        "user_pax_token" : str_userPaxToken,
                        "amount": strSplitAmount,
                        "digital_signature": str_SignatureData
                    ],
                    "order_source": str_DeviceName,
                    "digital_signature": self.signatureImage?.base64(format: .png) ?? "",
                    "orderId": 0,
                    "notes": self.str_AddNote,
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
            }else {
                
                var productsArrayOne = Array<Any>()
                
                var dictOne = [String: Any]()
                for i in 0..<orderInfoObj.transactionArray.count
                {
                    //let indexPath = IndexPath(item: i, section: 0)
                    //let cellindex = self.collectionPayExchange?.cellForItem(at: indexPath) as? AddPaymentCollectionCell
                    
                    
                    dictOne["amount"] = orderInfoObj.transactionArray[i].availableRefundAmount
                    //dictOne["editTextFocus"] = false
                    //dictOne["fullRefundAmount"] = "0"
                    //dictOne["isRefund"] = false
                    //dictOne["isVoid"] = false
                    //dictOne["isVoidClick"] = false
                    //dictOne["partialEditTextValue"] = ""
                    //dictOne["refund_amount"] = "0"
                    //dictOne["selectedCardType"] = orderInfoObj.transactionArray[i].cardType
                    dictOne["gift_card_number"] = str_InternalGiftCardNumber
                    dictOne["transaction_type"] = paymentName
                    //dictOne["terminal_port"] = str_paxUrl
                    //dictOne["device_name"] = str_addDeviceName
                    dictOne["txnID"] = orderInfoObj.transactionArray[i].txnId
                    
                    productsArrayOne.append(dictOne)
                }
                //productsArrayOne.append(dictOne)
                
                
                 var RefundBPID = ""
//                if !str_CreditCardNumber.contains("*")  && !self.isBillingProfileIDSetError {
//                    RefundBPID = ""
//                } else {
//                    if self.isBillingProfileIDSetError {
//                        RefundBPID = DataManager.Bbpid
//                    } else {
//                        RefundBPID = orderInfoObj.bpId
//                    }
//
//                }
                
                if !str_CreditCardNumber.contains("*")   && !self.isBillingProfileIDSetError {
                    RefundBPID = ""
                } else {
                    if merchant == "" {
                        if paymentName == "credit"{
                            if DataManager.CardCount > 1 {
                                RefundBPID = DataManager.Bbpid
                            } else {
                                if str_CreditCardNumber.contains("*") {
                                    RefundBPID = orderInfoObj.bpId
                                } else {
                                    if isBillingProfileIDSetError {
                                        RefundBPID = DataManager.Bbpid
                                    } else {
                                        RefundBPID = ""
                                    }
                                    
                                }
                                //CustomerObj.str_bpid = DataManager.Bbpid
                            }
                            
                        } else {
                            if isBillingProfileIDSetError {
                                RefundBPID = DataManager.Bbpid
                            } else {
                                RefundBPID = ""
                            }
                        }
                        //CustomerObj.str_bpid = DataManager.Bbpid
                    } else {
                        if str_CreditCardNumber.contains("X") {
                            RefundBPID = DataManager.Bbpid
                        } else if str_CreditCardNumber.contains("*") {
                            if self.isBillingProfileIDSetError {
                                RefundBPID = DataManager.Bbpid
                            } else {
                                RefundBPID = ""
                            }
                        } else {
                            RefundBPID = ""
                        }
                    }
                }
                
                parameters = [
                    "cust_id": orderInfoObj.userID,
                    "customer_status": CustomerObj.str_customer_status,
                    "customer_info": [
                        "first_name": orderInfoObj.firstName,
                        "last_name": orderInfoObj.lastName,
                        "email": orderInfoObj.email,
                        "phone": ord_str_phone,
                        "company":CustomerObj.str_company,
                        "address": orderInfoObj.addressLine1,
                        "address2": orderInfoObj.addressLine2,
                        "city": orderInfoObj.city,
                        "state": orderInfoObj.region,
                        "zip":ord_str_postal,
                        "country": orderInfoObj.country,
                        "office_phone":CustomerObj.str_office_phone,
                        "contact_source": CustomerObj.str_contact_source
                    ],
                    "bill_profile_id": RefundBPID,
                    "billing_info": [
                        "bill_first_name": orderInfoObj.firstName,
                        "bill_last_name": orderInfoObj.lastName,
                        "bill_address_1": orderInfoObj.addressLine1,
                        "bill_address_2": orderInfoObj.addressLine2,
                        "bill_city": orderInfoObj.city,
                        "bill_region": orderInfoObj.region,
                        "bill_country": orderInfoObj.country,
                        "bill_postal_code": ord_str_postal,
                        "bill_email": orderInfoObj.email,
                        "bill_phone": ord_str_phone,
                        "bill_company":CustomerObj.str_company
                    ],
                    "shipping_info": [
                        "ship_first_name": orderInfoObj.shippingFirstName,
                        "ship_last_name": orderInfoObj.shippingLastName,
                        "ship_address_1": orderInfoObj.shippingAddressLine1,
                        "ship_address_2": orderInfoObj.shippingAddressLine2,
                        "ship_city": orderInfoObj.shippingCity,
                        "ship_region": orderInfoObj.shippingRegion,
                        "ship_country": orderInfoObj.shippingCountry,
                        "ship_postal_code": ord_str_shippingPostalCode,
                        "ship_email": orderInfoObj.shippingEmail,
                        "ship_phone": ord_str_shippingPhone
                    ],
                    "cart_info": [
                        "coupon": self.str_AddCouponName,
                        "products": productsArray,
                        "subtotal": self.SubTotalPrice,
                        "discount": "",
                        "manual_discount": self.str_AddDiscount,
                        "shipping_handling": self.str_ShippingANdHandling,
                        "tax": "",
                        "custom_tax_id": taxID,
                        "total": "",
                        //"reward_points" : DataManager.finalLoyaltyDiscount
                    ],
                    "merchant_id": orderInfoObj.merchantId,
                    "payment_type": paymentName,
                    "payment_method": str_AUTH,
                    "custom_text_1": CustomerObj.str_CustomText1,
                    "custom_text_2": CustomerObj.str_CustomText2,
                    "isSplitPayment" : DataManager.isSplitPayment,
                    "previousTxnResponse": preTxnRes,
                    "credit": [
                        "cc_account": str_CreditCardNumber,
                        "cc_exp_mo": str_MM,
                        "cc_exp_yr": str_YYYY,
                        "cc_cvv": str_CVV,
                        "tip": tipAmountCreditCard.roundToTwoDecimal,
                        "total": strSplitAmount,
                        "digital_signature": "",
                        "amount" : strSplitAmount,
                        "orig_txn_response": orig_txn_response,
                        "merchant": merchant,
                        "merchant_id": merchant_Id,
                        "txn_response": txn_response
                    ],
                    "cash": [
                        "amount": str_Cash.replacingOccurrences(of: "$", with: ""),
                        "tip": "",
                        "total": ""
                    ],
                    "invoice": [
                        "po_number": str_Ponumber,
                        "terms": str_Terms,
                        "rep": str_Rep,
                        "invoice_date": "",
                        "tip": "",
                        "total": "",
                        "notes": str_NotesInvoice
                    ],
                    "ach_check": [
                        "routing_number": str_RoutingNumber,
                        "account_number": str_AccountNumber,
                        "dl_number": str_DLNumber,
                        "dl_state": str_DLState,
                        "amount": strSplitAmount,
                        "check_type": "",
                        "sec_code": "",
                        "account_type": "",
                        "tip": "",
                        "total": ""
                    ],
                    "gift_card": [
                        "gift_card_number": str_GiftCardNumber,
                        "gift_card_pin": str_CardPin,
                        "amount": strSplitAmount,
                        "tip": "",
                        "total": ""
                    ],
                    "external_gift": [
                        "gift_card_number": str_ExternalGiftCardNumber,
                        "amount": strSplitAmount,
                        "tip": "",
                        "total": ""
                    ],
                    "internal_gift_card": [
                        "gift_card_number": str_InternalGiftCardNumber,
                        "amount": strSplitAmount,
                        "tip": "",
                        "total": ""
                    ],
                    "multi_card": multicardData,
                    "check": [
                        "amount": str_CheckAmount,
                        "check_number": str_CheckNumber,
                        "tip": "",
                        "total": ""                    ],
                    "external": [
                        "amount": str_ExternalAmount,
                        "tip": "",
                        "total": "",
                        "external_approval_number": str_externalAprrovalNumber
                    ],
                    "pax_pay": [
                        "pax_payment_type": paxPaymentType,
                        "pax_url": paxUrl,
                        "device_name": paxDevice,
                        "tip": paxtip,
                        "terminal_port" : paxUrl,
                        //"amount": paxTotal,
                        "user_pax_token" : str_userPaxToken,
                        "amount": strSplitAmount,
                        "pax_pay_receipt" : DataManager.isSingatureOnEMV,
                        "use_token" : isCardFileSelected
                    ],
                    "isOrderRefund": true,
                    "orderId": orderInfoObj.orderID,
                    "order_source": str_DeviceName,
                    "digital_signature": self.signatureImage?.base64(format: .png) ?? "",
                    "notes": self.str_AddNote,
                    "campaign_code": "",
                    "sub_id": "",
                    "crm_partner_order_id": "",
                    "enable_split_row": DataManager.isSplitRow,
                    "isPartialRefund": false,
                    "isShippingRefund": false,
                    "isTipRefund": false,
                    "transactionsList":productsArrayOne,
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
            }
            
            let newOrderData = parameters.filter({$0.key == "cust_id" || $0.key == "customer_info" || $0.key == "bill_profile_id" || $0.key == "billing_info" || $0.key == "shipping_info" || $0.key == "is_billing_same" || $0.key == "cart_info" || $0.key == "order_source" || $0.key == "notes" })
            
            if (newOrderData == DataManager.recentOrder && orderType == .newOrder) || DataManager.recentOrderID != 0  {
                if let recentOrderID = DataManager.recentOrderID {
                    parameters["orderId"] = recentOrderID
                }
            }
            if isOpenToOrderHistory {
                parameters["orderId"] = orderInfoObj.orderID
                parameters["isProcessInvoice"] = true
            }
            if paymentName != "cash" {
                UserDefaults.standard.removeObject(forKey: "changeAmountKey")
                UserDefaults.standard.synchronize()
            }
            
            print("****************************************************** Order Parameters Start ******************************************************")
            print(parameters)
            print("****************************************************** Order Parameters End ******************************************************")
            
            //Call API To Make Order
            self.callAPIToCreateOrder(parameters: parameters, isInvoice: false, isAllManualProducts: !isAllManualProducts.contains(false))
        }
    }
}

//MARK: EPSignatureDelegate
extension PaymentsViewController: EPSignatureDelegate {
    //    func epSignature(_: MultipleSignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
    //        <#code#>
    //    }
    //
    //    func epSignature(_: SignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
    //        self.signatureImage = signatureImage
    //        prepareForPlaceOrder()
    //    }
    
    func epSignature(_: MultipleSignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
        print("test")
    }
    
    func signatureJsonArraySend(arrdata: JSONArray) {
        print(arrdata)
        
        if paymentName == "MULTI CARD" || paymentName == "multi card" || paymentName == "multi_card" {
            
            if let multiData = multicardData["credit"] as? JSONArray {
                print(multiData.count)
                var multiValue =  multicardData["credit"] as? JSONArray
                for i in 0..<arrdata.count {
                    let arrsign = arrdata[i]
                    
                    let cardNo = arrsign["card_number"] as? String
                    let cardval = cardNo?.suffix(4)
                    for j in 0..<multiData.count {
                        let card =  multiData[j]["cc_account"] as? String
                        
                        let card4 = card?.suffix(4)
                        if cardval == card4 {
                            let tipVal = (arrsign["tip"] as? String)?.toDouble()
                            multiValue?[j]["tip"] = tipVal ?? 0.0
                            multiValue?[j]["digital_signature"] = arrsign["signature"] as? String ?? ""
                        }
                    }
                }
                multicardData["credit"] = multiValue
            }
            
            if let multiData = multicardData["pax_pay"] as? JSONArray {
                print(multiData.count)
                var multiValue =  multicardData["pax_pay"] as? JSONArray
                
                for i in 0..<arrdata.count {
                    let arrsign = arrdata[i]
                    
                    let cardNo = arrsign["paxNumber"] as? String
                    let cardval = cardNo?.suffix(4)
                    for j in 0..<multiData.count {
                        let card =  "Emv\(j)"
                        
                        let card4 = card.suffix(4)
                        if cardval == card4 {
                            let tipVal = (arrsign["tip"] as? String)?.toDouble()
                            multiValue?[j]["tip"] = tipVal ?? 0.0
                            multiValue?[j]["paxNumber"] = ""
                            multiValue?[j]["digital_signature"] = arrsign["signature"] as? String ?? ""
                        }
                    }
                }
                multicardData["pax_pay"] = multiValue
            }
            
        } else if paymentName == "PAX PAY" || paymentName == "pax pay" || paymentName == "pax_pay" {
            for i in 0..<arrdata.count {
                let arrsign = arrdata[i]
                let tipVal = arrsign["tip"] as? String
                paxtip = tipVal ?? "0.00"
                
                str_SignatureData = arrsign["signature"] as? String ?? ""
            }
        } else {
            for i in 0..<arrdata.count {
                let arrsign = arrdata[i]
                let tipVal = (arrsign["tip"] as? String)?.toDouble()
                tipAmountCreditCard = tipVal ?? 0.0
                
                str_SignatureData = arrsign["signature"] as? String ?? ""
            }
        }
        
        if paymentName == "CARD READER" || paymentName == "card reader" {
            Indicator.sharedInstance.delegate = self
            ingenicoStartOnClick()
        } else {
            prepareForPlaceOrder()
        }
        
    }
    
}

//MARK: CancelPAXDelegate Delegate
extension PaymentsViewController : CancelPAXDelegate{
    func didCancelPAX() {
        print("Delegate in IPad_payment")
        Indicator.sharedInstance.hideIndicator()
        ingenico.payment.abortTransaction()
    }
}


extension Array {
    
    mutating func remove(at indexs: [Int]) {
        guard !isEmpty else { return }
        let newIndexs = Set(indexs).sorted(by: >)
        newIndexs.forEach {
            guard $0 < count, $0 >= 0 else { return }
            remove(at: $0)
        }
    }
    
}

extension PaymentsViewController {
    func promptForAmountAndClerkID(_ transactiontype:IMSTransactionType, andIsKeyed isKeyed:Bool, andIsWithReader isWithReader:Bool) {
        
        let myamount = "50"
        let clerkIDTF = ""
        
        
        //Indicator.sharedInstance.showIndicator()
        let request:AnyObject? = self.getSampleTransactionRequestwithTotalAmount((appDelegate.CardReaderAmount * 100), andClerkID: clerkIDTF , andType: transactiontype, andIsKeyed: isKeyed, andIsWithReader: isWithReader)
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
    
    //        let myamount = "50"
    //        let clerkIDTF = ""
    //        let okAction:UIAlertAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
    //            let textFeildData:Int? = Int(myamount)
    //            if textFeildData == nil || textFeildData! <= 0 {
    //                //self.showErrorMessage("Please provide valid amount", andErrorTitle: "Wrong Amount")
    //            }else if (clerkIDTF.count) > 4{
    //                //self.showErrorMessage("ClerkID is up to 4 alphanumerics", andErrorTitle: "Error")
    //            }else {
    //                self.view.endEditing(true)
    //                let request:AnyObject? = self.getSampleTransactionRequestwithTotalAmount(self.TotalPrice, andClerkID: clerkIDTF , andType: transactiontype, andIsKeyed: isKeyed, andIsWithReader: isWithReader)
    //                guard let transactionRequest = request
    //                    else{
    //                        return
    //                }
    //                //SVProgressHUD.show(withStatus: "Processing Transaction")
    //                appDelegate.showToast(message: "Processing Transaction")
    //                self.myTextField = nil
    //                self.clerkIDTF = nil
    //                self.setLastTransactionType(transactiontype)
    //                self.setLastTransactionID("")
    //                switch transactiontype{
    //                case .TransactionTypeCashSale:
    //                    self.ingenico?.payment.processCashTransaction(transactionRequest as! IMSCashSaleTransactionRequest,
    //                                                                  andOnDone: self.doneCallback!)
    //                case .TransactionTypeCreditSale:
    //                    if isKeyed {
    //                        self.ingenico?.payment.processKeyedTransaction(transactionRequest as! IMSKeyedCardSaleTransactionRequest,
    //                                                                       andOnDone: self.doneCallback!)
    //                    }else if isWithReader {
    //                        self.ingenico?.payment.processCreditSaleTransaction(withCardReader: transactionRequest as! IMSCreditSaleTransactionRequest,
    //                                                                            andUpdateProgress: self.progressCallback!,
    //                                                                            andSelectApplication: self.applicationSelectionCallback! ,
    //                                                                            andOnDone: self.doneCallback!)
    //                    }
    //                    else {
    //                        //SVProgressHUD.dismiss()
    //                        if let secureCardEntryViewController = IMSSecureCardEntryViewController(transactionRequest: transactionRequest as! IMSSCETransactionRequest,
    //                                                                                                andUpdateProgress: self.progressCallback!,
    //                                                                                                andOnDone: self.doneCallback!) {
    //
    //                            appDelegate.showToast(message: "payment inter value")
    ////                            if self.isViewController {
    ////                                let navigationController = IMSNavigationViewController(rootViewController: secureCardEntryViewController)
    ////                                self.present(navigationController, animated: true, completion: nil)
    ////                            }
    ////                            else {
    ////                                self.sceViewController = secureCardEntryViewController
    ////                                self.sceViewController?.view.frame = CGRect(x: 0, y: 0, width: (self.view.bounds.size.width * 90) / 100, height: (self.view.bounds.size.height * 90) / 100)
    ////                                self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissModalView))
    ////                                self.tapGesture?.numberOfTapsRequired = 1
    ////                                self.view.addGestureRecognizer(self.tapGesture!)
    ////                                self.sceViewController?.didMove(toParentViewController: self)
    ////                                self.sceViewController?.view.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
    ////                                self.sceViewController?.view.layer.borderWidth = 1
    ////                                self.sceViewController?.view.layer.borderColor = UIColor.darkGray.cgColor
    ////                                self.addChildViewController(self.sceViewController!)
    ////                                self.view.addSubview((self.sceViewController?.view)!)
    ////                            }
    //                        }
    //                    }
    //
    //                case .TransactionTypeCreditAuth:
    //                    if isKeyed {
    //                        self.ingenico?.payment.processKeyedCreditAuthTransaction(transactionRequest as! IMSKeyedCreditAuthTransactionRequest,
    //                                                                                 andOnDone: self.doneCallback!)
    //                    }else {
    //                        self.ingenico?.payment.processCreditAuthTransaction(withCardReader: transactionRequest as! IMSCreditAuthTransactionRequest ,
    //                                                                            andUpdateProgress: self.progressCallback!,
    //                                                                            andSelectApplication: self.applicationSelectionCallback! ,
    //                                                                            andOnDone: self.doneCallback!)
    //                    }
    //
    //                case .TransactionTypeDebitSale:
    //                    self.ingenico?.payment.processDebitSaleTransaction(withCardReader: transactionRequest as! IMSDebitSaleTransactionRequest,
    //                                                                       andUpdateProgress: self.progressCallback!,
    //                                                                       andSelectApplication: self.applicationSelectionCallback!,
    //                                                                       andOnDone: self.doneCallback!)
    //                case .TransactionTypeCashRefund:
    //                    self.ingenico?.payment.processCashRefundTransaction(transactionRequest as! IMSCashRefundTransactionRequest,
    //                                                                        andOnDone: self.doneCallback!)
    //
    //                case .TransactionTypeCreditRefund:
    //                    if isKeyed {
    //                        self.ingenico?.payment.processCreditRefundAgainstTransaction(transactionRequest as! IMSCreditRefundTransactionRequest,
    //                                                                                     andOnDone: self.doneCallback!)
    //                    }else{
    //                        self.ingenico?.payment.processCreditRefund(withCardReader: transactionRequest as! IMSCreditCardRefundTransactionRequest,
    //                                                                   andUpdateProgress: self.progressCallback!,
    //                                                                   andSelectApplication: self.applicationSelectionCallback!,
    //                                                                   andOnDone: self.doneCallback!)
    //                    }
    //
    //                case .TransactionTypeCreditAuthCompletion:
    //                    self.ingenico?.payment.processCreditAuthCompleteTransaction(transactionRequest as! IMSCreditAuthCompleteTransactionRequest,
    //                                                                                andOnDone: self.doneCallback!)
    //                default:
    //                    break
    //                }
    //            }
    //        }
    //        self.showAmountAlertControllerWithAction(okAction, andMessage: iPad_PaymentTypesViewController.Transaction_Message)
    //    }
    
    func getSampleTransactionRequestwithTotalAmount(_ total:Double, andClerkID cID:String?, andType type:IMSTransactionType, andIsKeyed isKeyed:Bool, andIsWithReader isWithReader:Bool)->AnyObject?{
        var clerkID:String?
        
        if(cID == ""){
            clerkID = nil
        }else {
            clerkID = cID
        }
        let taxVal = Double(str_TaxAmount)
        var totalAmount = total + (tipAmountCreditCard * 100)
        let subTotalVal = total - (tipAmountCreditCard * 100)

        var amount = IMSAmount()
//        if HomeVM.shared.DueShared > 0.0 {
//             amount = IMSAmount.init(total: Int(totalAmount), andSubtotal: 0, andTax: 0, andDiscount: 0, andDiscountDescription: "", andTip: Int(tipAmountCreditCard * 100), andCurrency: "USD")
//
//        } else {
//             amount = IMSAmount.init(total: Int(totalAmount), andSubtotal: Int(subTotalVal*100), andTax: 0, andDiscount: 0, andDiscountDescription: "", andTip: Int(tipAmountCreditCard * 100), andCurrency: "USD")
//
//        }
        amount = IMSAmount.init(total: Int(totalAmount), andSubtotal: Int(subTotalVal), andTax: 0, andDiscount: 0, andDiscountDescription: "", andTip: Int(tipAmountCreditCard * 100), andCurrency: "USD")

        //let amount :IMSAmount = IMSAmount.init(total: Int(totalAmount), andSubtotal: 0, andTax: 0, andDiscount: 0, andDiscountDescription: "", andTip: Int(tipAmountCreditCard * 100), andCurrency: "USD")
        //let amount :IMSAmount = IMSAmount.init(total: Int(totalAmount), andSubtotal: Int(SubTotalPrice*100), andTax: Int(taxVal ?? 0.0 * 100), andDiscount: 0, andDiscountDescription: "ROAMDiscount", andTip: Int(tipAmountCreditCard * 100), andCurrency: "USD")
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
    
    func getSignatureOrUpdateTransaction(_ response: IMSTransactionResponse){
        self.idleChargeButton()
        self.placeOrder(isAuth: false, isSwiped: false)
        
        
        //        if ((response.cardVerificationMethod == .CardVerificationMethodPinAndSignature ||
        //            response.cardVerificationMethod == .CardVerificationMethodSignature) &&
        //            ( response.posEntryMode == .POSEntryModeContactEMV ||
        //                response.posEntryMode == .POSEntryModeContactlessEMV ||
        //                response.posEntryMode == .POSEntryModeMagStripeEMVFail
        //            )){
        //            //SVProgressHUD.dismiss()
        //            let controller:UIAlertController = UIAlertController.init(title: "Select action", message: String.init(format: "Please select action for pending signature transaction: %@", getLastTransactionID()!), preferredStyle:.alert)
        //            let uploadAction:UIAlertAction = UIAlertAction.init(title: "Upload Signature", style: .default, handler: { (action) in
        //                //SVProgressHUD.show(withStatus: "Adding Signature progrmatically")
        //                appDelegate.showToast(message: "Adding Signature progrmatically")
        //                self.uploadSignature()
        //                //self.displaySignature(response)
        //            })
        //            let elsedaction:UIAlertAction = UIAlertAction.init(title: "SignatureCapturedElseWhere", style: .default, handler: { (action) in
        //                self.ingenico?.payment.signatureCapturedElseWhere(response.transactionID)
        //            })
        //            let voidAction:UIAlertAction = UIAlertAction.init(title: "Void", style: .default, handler: { (action) in
        //                self.doVoidTransaction()
        //            })
        //            let dismissAction = UIAlertAction.init(title: "Dismiss", style: .default, handler: nil)
        //            controller.addAction(voidAction)
        //            controller.addAction(uploadAction)
        //            controller.addAction(elsedaction)
        //            controller.addAction(dismissAction)
        //            self.present(controller, animated: true, completion: nil)
        //        }else {
        //            if response.cardVerificationMethod == .CardVerificationMethodSignature {
        //                //displaySignature(response)
        //                self.consoleLog("Adding Signature progrmatically")
        //                //SVProgressHUD.show(withStatus: "Adding Signature progrmatically")
        //                appDelegate.showToast(message: "Adding Signature progrmatically")
        //                self.uploadSignature()
        //            }else {
        //                updateTranasctionWithTransactionResponse(response)
        //            }
        //        }
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
    
//    func getProgressStrFromMessage(_ message:IMSProgressMessage) -> String?{
//        switch message {
//        case .PleaseInsertCard:
//            let allowedPOS = ingenico?.paymentDevice.allowedPOSEntryModes()
//            if let allowedPOS = allowedPOS as? [Int] {
//                if (allowedPOS.contains(where: {$0 == IMSPOSEntryMode.POSEntryModeContactlessMSR.rawValue}) || allowedPOS.contains(where: {$0 == IMSPOSEntryMode.POSEntryModeContactlessEMV.rawValue})) {
//                    if allowedPOS.contains(where: {$0 == IMSPOSEntryMode.POSEntryModeContactEMV.rawValue}) {
//                        return "Please insert/tap/swipe card"
//                    } else {
//                        return "Please tap or swipe card"
//                    }
//                } else {
//                    return "Please insert or swipe card";
//                }
//            }
//            return "Please swipe card"
//        case .CardInserted:
//            return "Card inserted";
//        case .ICCErrorSwipeCard:
//            return "ICCError swipe card please";
//        case .ApplicationSelectionStarted:
//            return "Application selection started";
//        case .ApplicationSelectionCompleted:
//            return "Application selection completed";
//        case .FirstPinEntryPrompt:
//            return "First Pin prompt";
//        case .LastPinEntryPrompt:
//            return "Last Pin prompt";
//        case .PinEntryFailed:
//            return "Pin entry failed";
//        case .PinEntryInProgress:
//            return "Pin entry in progress";
//        case .PinEntrySuccessful:
//            return "Pin entry in progress";
//        case .RetrytPinEntryPrompt:
//            return "Retry Pin entry prompt";
//        case .WaitingforCardSwipe:
//            return "Waiting for card swipe";
//        case .PleaseSeePhone:
//            return "Please see phone";
//        case .SwipeDetected:
//            return "Swipe detected";
//        case .SwipeErrorReswipeMagStripe:
//            return "Reswipe please";
//        case .TapDetected:
//            return "Tap detected";
//        case .UseContactInterfaceInsteadOfContactless:
//            return "Use contact interface instead of contactless";
//        case .ErrorReadingContactlessCard:
//            return "Error reading contactless card";
//        case .DeviceBusy:
//            return "Device busy";
//        case .CardHolderPressedCancelKey:
//            return "Cancel key pressed";
//        case .RecordingTransaction:
//            return "Recording transaction";
//        case .UpdatingTransaction:
//            return "Updating transaction";
//        case .PleaseRemoveCard:
//            return "Please remove card";
//        case .RestartingContactlessInterface:
//            return "Restarting contactless interface";
//        case .GettingOnlineAuthorization:
//            return "Getting Online Authorization";
//        case .TryContactInterface:
//            return "Try contact interface";
//        case .ReinsertCard:
//            return "Reinsert Card properly";
//        case .RestartingTransactionDueToIncorrectPin:
//            return "Restarting Transaction Due To Incorrect Pin";
//        default:
//            return nil;
//        }
//    }
    
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
//        ingenico?.payment.getPendingTransactions({ transactions, error in
//            if (error == nil) {
//                let pendingTransactions = transactions as! [IMSPendingTransaction]
//
////                self.consoleLog("getPendingTransactions success")
//            }
//            else {
//            }
//        })
//
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
        //SVProgressHUD.show(withStatus: "Uploading Signature...")
        //        let encodedString:String = (UIImage.init(named: "signature.png")!.UIImagePNGRepresentation()?.base64EncodedString(options: .endLineWithLineFeed))!
        //        ingenico?.user.uploadSignatureForTransaction(withId: getLastTransactionID()!, andSignature: encodedString, andOnDone: { (error) in
        //            //SVProgressHUD.dismiss()
        //            if error == nil {
        //                //SVProgressHUD.showSuccess(withStatus: "Uploading signature Succeeded")
        //                self.consoleLog("Uploading signature Succeeded")
        //            } else {
        //                //SVProgressHUD.showError(withStatus: "Uploading signature failed")
        //                self.consoleLog("Uploading signature failed")
        //            }
        //        })
        
    }
}

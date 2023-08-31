//
//  iPad_PaymentTypesViewController.swift
//  HieCOR
////  Created by HyperMacMini on 02/04/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SocketIO
import CoreLocation

class iPad_PaymentTypesViewController: BaseViewController, RUADeviceSearchListener, RUAAudioJackPairingListener {
    func isReaderSupported(_ reader: RUADevice) -> Bool{
        if (reader.name == nil){
            return false
        }
        print(reader.name)
        return reader.name.lowercased().hasPrefix("rp") || reader.name.lowercased().hasPrefix("mob")
    }
    
    func discoveredDevice(_ reader: RUADevice) {
        var isIncluded:Bool = false
        print("enterhgashdgfahgsd1")
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
                print("enterhgashdgfahgsd2")
                ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                                    apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                                    clientVersion: ClientVersion)
                ingenico.setLogging(false)
                
                loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password, islogin: false)
                
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
        //Indicator.sharedInstance.showIndicator()
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
                self.refreshUserSession(islogin: islogin)
                
                
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
    
    
    //MARK: IBOutlets
    
    
    @IBOutlet weak var lblLoyaltyStroreCredit: UILabel!
    @IBOutlet weak var loyaltyStoredCreditView: UIStackView!
    @IBOutlet var balanceDueView: UIView!
    @IBOutlet var labelBallanceDueAmt: UILabel!
    @IBOutlet weak var lbl_PaymentMethodName: UILabel!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editProductDetailContainerView: UIView!
    @IBOutlet weak var subtotalView: UIStackView!
    @IBOutlet weak var applyCouponView: UIStackView!
    @IBOutlet weak var discountView: UIStackView!
    @IBOutlet weak var shippingView: UIStackView!
    @IBOutlet weak var depositeView: UIStackView!
    @IBOutlet weak var taxView: UIStackView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var addCustomerView: UIView!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var addDiscountView: UIView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var couponNameLabel: UILabel!
    @IBOutlet weak var couponAmountLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var taxAmountLabel: UILabel!
    @IBOutlet weak var taxNameLabel: UILabel!
    @IBOutlet weak var taxTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var depositeAmountLabel: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var addIconImageView: UIImageView!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var editProductDetailBlurView: UIView!
    @IBOutlet weak var editProductDetailContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cartPaymentSectionView: UIStackView!
    @IBOutlet weak var paymentButtonsView: UIStackView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var lockLineView: UIView!
    @IBOutlet weak var shippingRefundButton: UIButton!
    @IBOutlet weak var audioLineView: UIView!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoutLineView: UIView!
    @IBOutlet var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var showDetailsContainer: UIView!
    @IBOutlet weak var SavedCardContainer: UIView!
    @IBOutlet weak var shippingContainer: UIView!
    @IBOutlet weak var authorizationContainer: UIView!
    @IBOutlet weak var lblShippingHead: UILabel!
    @IBOutlet weak var viewAmountPaid: UIView!
    @IBOutlet weak var lblAmountPaid: UILabel!
    //For product info container
    @IBOutlet weak var view_Bg: UIView!
    @IBOutlet weak var containerViewIpadProductInfo: UIView!
    @IBOutlet weak var constAddCustomerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnAddMoreProduct: UIButton!
    
    //MARK: Variables
    var isPayButtonSelected = Bool()
    var isSaveInvoice = Bool()
    var invoiceEmail = String()
    var invoiceCardNumber = String()
    var invoiceCardMonth = String()
    var invoiceCardYear = String()
    var invoiceDate = String()
    var str_Auth = String()
    var isCardFileSelected = Bool()
    var str_user_pax_token = String()
    var str_CreditCardNumber = String()
    var str_MM = String()
    var str_YYYY = String()
    var str_CVV = String()
    var str_Cash = String()
    var str_NotesInvoice = String()
    var str_Rep = String()
    var str_Terms = String()
    var str_DueDate = String()
    var str_title = String()
    var str_Ponumber = String()
    var str_RoutingNumber = String()
    var str_AccountNumber = String()
    var str_DLState = String()
    var str_DLNumber = String()
    var str_CheckNumber = String()
    var str_CheckAmount = String()
    var str_CardPin = String()
    var str_GiftCardNumber = String()
    var str_ExternalAmount = String()
    var str_ExternalGiftCardNumber = String()
    var str_ExternalApprovalNumber = String()
    var str_InternalGiftCardNumber = String()
    var str_Notes = String()
    var cartObjectData:AnyObject = () as AnyObject
    var isplaceOrderCalled = Bool()
    var str_PaymentName = String()
    var addNote = String()
    var multicardData = JSONDictionary()
    var multicardTotal = Double()
    var paxPaymentType = String()
    var paxDevice = String()
    var paxUrl = String()
    var paxtip = String()
    var paxTotal = String()
    var isCreditCardNumberDetected = false
    var tipAmount = Double()
    var tipAmountCreditCard = Double()
    var tipIngenico = 0.0
    var taxableCouponTotal = Double()
    var isDefaultTaxChanged = false
    var isDefaultTaxSelected = false
    var isPercentageDiscountApplied = false
    var str_ShippingANdHandling = String()
    var str_AddDiscount = String()
    var str_AddDiscountPercent = String()
    var str_AddCouponName = String()
    var visualEffectView = UIVisualEffectView()
    var cartProductsArray = Array<Any>()
    var SubTotalPrice = Double()
    var TotalPrice = Double()
    var CustomerObj = CustomerListModel()
    var str_CouponDiscount = String()
    var isShippingPriceChanged = false
    var taxTitle = String()
    var taxAmountValue = String()
    var taxType = String()
    var str_TaxPercentage = String()
    var str_TaxAmount = String()
    var controller: UIViewController?
    var isCoupanApplyOnAllProducts = false
    var isAllDataRemoved = false
    var array_TaxList = [TaxListModel]()
    var customerDelegate: CustomerDelegates?
    var delegate: iPad_PaymentTypesViewControllerDelegate?
    var orderInfoObj = OrderInfoModel()
    var orderType: OrderType = .newOrder
    var selectedViewController: UIViewController?
    var isOderPlaced = false
    var str_remainingamt = String()
    var balanceDue = Double()
    var Totaldue = Double()
    var tipAmountDue = Double()
    var MultiTipAmountDue = Double()
    var finalTotalSend = Double()
    var str_showImagesFunctionality = String()
    var str_showProductCodeFunctionality = String()
    var str_showShipOrderInPos = String()
    var lastChargeValue = Double()
    var payValue = Double()
    var dataNew = Double()
    var isTotalChange = false
    var strCardUserID = String()
    var versionOb = Int()
    var checkFillFeild = true
    var isCheckCustDetail = false
    var amountforCredit = 0.0
    var isAddSubscription = false // by sudama add sub
    var subTotalLoyaltyCredit:Double = 0
    var subTotalLoyaltyPurchase:Double = 0
    var isLoyaltyAllowCreditProduct = Bool()
    var isLoyaltyAllowPurchaseProduct = Bool()
    var rewardsPoint:Double = 0
    var strCustLoyaltyBalance = String()
    var doubleCustLoyaltyBalance = Double()
    var allowPurchaseTotalLoyalty = Double()
    var rewardPoints = Double()
    var totalLoyalty = Double()
    var strSplitPayAmount = String()
    var taxableAmtData = Double()
    var discountPointTaxable = Double()
    var discountPointWithoutCouponTaxable = Double()
    var tempWithoutCoupon = Double()
    var CouponTotal = Double()
    var withoutCouponTotal = Double()
    var cardholderName = String()
    var radioCount = 0
    var arrTempAttId = [String]()
    var arrTempVarId = [String]()
    var taxDef = Double()
    var orig_txn_response = String()
    var merchant = String()
    var txn_response = JSONDictionary()
    
    fileprivate var ingenico:Ingenico!
    fileprivate var deviceList:[RUADevice] = []
    let ClientVersion:String  = "4.2.3"
    private var isDiscoveryComplete = false
    var arrIngenico = JSONArray()
    
    var dictSocket = [String: Any]()
    var productsArraySocket = Array<Any>()
    var MainproductsArraySocket = [Int: Any]()
    var transactionType = IMSTransactionType.TransactionTypeUnknown
    var canEnrollToken = false
    var checkIfCardPresent = false
    var canUpdateToken = false
    var tokenEnrollCheckBox = true
    var isOpenToOrderHistory = false
    var orderInfoModelObj = OrderInfoModel()
    //MARK: Delegates
    var creditCardDelegate: PaymentTypeDelegate?
    var cashDelegate: PaymentTypeDelegate?
    var invoiceDelegate: PaymentTypeDelegate?
    var achCheckDelegate: PaymentTypeDelegate?
    var checkDelegate: PaymentTypeDelegate?
    var giftCardDelegate: PaymentTypeDelegate?
    var externalGiftCardDelegate: PaymentTypeDelegate?
    var internalGiftCardDelegate: PaymentTypeDelegate?
    var externalCardDelegate: PaymentTypeDelegate?
    var notesDelegate: PaymentTypeDelegate?
    var multicardDelegate: PaymentTypeDelegate?
    var paxDelegate: PaymentTypeDelegate?
    var ingenicoDelegate: PaymentTypeDelegate?
    var paymentViewDelegate: PaymentTypeContainerViewControllerDelegate?
    var paymentTypeViewDelegate: PaymentTypeContainerViewControllerDelegate?
    weak var editProductDetailDelegate: CatAndProductsViewControllerDelegate?
    var showDetailsDelegateOne: showDetailsDelegate?
    var delegateSavedCard : savedCardDelegate?
    var delegateSavedCardDetail : EditProductDelegate?
    var creditshowData : creditInfoDelegate?
    var delegateEditProduct: EditProductDelegate?
    
    var myTextField:UITextField!
    var clerkIDTF:UITextField!
    var tapGesture : UITapGestureRecognizer?
    //var ingenico:Ingenico?
    var staticDataArray = [[String: [String]]] ()
    var response:IMSTransactionResponse?
    var clerkID:String?
    var doneCallback:TransactionOnDone?
    var progressCallback:UpdateProgress?
    var applicationSelectionCallback:ApplicationSelectionHandler?
    var isViewController = false
    var sceViewController : IMSSecureCardEntryViewController?
    weak var productDelegate: ProductsContainerViewControllerDelegate?
    static var Transaction_Message:String = "Provide normalized transaction amount and clerkID"
    static var RefundTransaction_Message:String = "Provide normalized refund transaction amount and clerkID"
    var IngenicoDataResponce = IMSTransactionResponse()
    var isMultiShippingAdrs = false
    //MARK: ViewController Variables
    private lazy var addCustomerContainer: iPadSelectCustomerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "iPadSelectCustomerViewController") as! iPadSelectCustomerViewController
        self.customerDelegate = vc
        vc.customerDelegate = self
        vc.customerDelegateForAddNewCustomer = self
        return vc
    }()
    
    private lazy var paymentTypeContainer: PaymentTypeContainerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentTypeContainerViewController") as! PaymentTypeContainerViewController
        vc.delegate = self
        paymentTypeViewDelegate = vc
        vc.orderType = self.orderType
        vc.isOpenToOrderHistory = self.isOpenToOrderHistory
        return vc
    }()
    
    private lazy var paymentViewContainer: PaymentsViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentsViewController") as! PaymentsViewController
        paymentViewDelegate = vc
        paymentTypeViewDelegate = vc
        vc.delegate = self
        vc.isOpenToOrderHistory = isOpenToOrderHistory
        return vc
    }()
    
    private lazy var creditCardContainer: CreditCardContainerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreditCardContainerViewController") as! CreditCardContainerViewController
        creditCardDelegate = vc
        vc.delegate = self
        vc.isCreditCardNumberDetected = isCreditCardNumberDetected
        vc.total = amountforCredit
        
        if balanceDue > 0 {
            vc.totalAmount = Double(balanceDue)
        } else {
            vc.totalAmount = Double(truncating: cartObjectData["Total"] as? NSNumber ?? 0)
        }
        
        //vc.total = Double(truncating: cartObjectData["Total"] as? NSNumber ?? 0)
        return vc
    }()
    
    private lazy var ingenicoContainer: IngenicoViewControllerVC = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "IngenicoViewControllerVC") as! IngenicoViewControllerVC
        ingenicoDelegate = vc
        vc.delegate = self
        if balanceDue > 0 {
            vc.totalAmount = Double(balanceDue)
        } else {
            vc.totalAmount = Double(truncating: cartObjectData["Total"] as? NSNumber ?? 0)
        }
        
        return vc
    }()
    
    private lazy var multiCardContainer: MultiCardContainerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MultiCardContainerViewController") as! MultiCardContainerViewController
        if balanceDue > 0 {
            vc.totalAmount = Double(balanceDue)
        } else {
            vc.totalAmount = Double(finalTotalSend)
        }
        
        //vc.totalAmount = Double(truncating: cartObjectData["Total"] as? NSNumber ?? 0)
        multicardDelegate = vc
        vc.delegate = self
        vc.customerData = cartObjectData["customerObj"] as? CustomerListModel ?? CustomerListModel()
        return vc
    }()
    
    private lazy var invoiceContainer: InvoiceContainerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InvoiceContainerViewController") as! InvoiceContainerViewController
        vc.invoiceEmail = self.invoiceEmail
        vc.customerObj = cartObjectData["customerObj"] as? CustomerListModel ?? CustomerListModel()
        invoiceDelegate = vc
        if balanceDue > 0 {
            vc.total = Double(balanceDue)
        } else {
            vc.total = Double(finalTotalSend)
        }
        vc.delegate = self
        return vc
    }()
    
    private lazy var cashContainer: CashViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CashViewController") as! CashViewController
        cashDelegate = vc
        vc.delegate = self
        
        if balanceDue > 0 {
            vc.totalCashAmount = "\(Double(balanceDue))"
        } else {
            vc.totalCashAmount = "\(Double(truncating: cartObjectData["Total"] as? NSNumber ?? 0))"
        }
        return vc
    }()
    
    private lazy var achCheckContainer: ACHcheckContainerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ACHcheckContainerViewController") as! ACHcheckContainerViewController
        if balanceDue > 0 {
            vc.total = Double(balanceDue)
        } else {
            vc.total = Double(finalTotalSend)
        }
        achCheckDelegate = vc
        vc.delegate = self
        return vc
    }()
    
    private lazy var checkContainer: CheckContainerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CheckContainerViewController") as! CheckContainerViewController
        checkDelegate = vc
        if balanceDue > 0 {
            vc.total = Double(balanceDue)
        } else {
            vc.total = Double(finalTotalSend)
        }
        vc.delegate = self
        return vc
    }()
    
    private lazy var giftCardContainer: GiftCardContainerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GiftCardContainerViewController") as! GiftCardContainerViewController
        giftCardDelegate = vc
        if balanceDue > 0 {
            vc.total = Double(balanceDue)
        } else {
            vc.total = Double(finalTotalSend)
        }
        vc.delegate = self
        return vc
    }()
    
    private lazy var internalGiftCardContainer: InternalGiftCardViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InternalGiftCardViewController") as! InternalGiftCardViewController
        internalGiftCardDelegate = vc
        if balanceDue > 0 {
            vc.total = Double(balanceDue)
        } else {
            vc.total = Double(finalTotalSend)
        }
        vc.delegate = self
        return vc
    }()
    
    private lazy var externalGiftCardContainer: ExternalGiftCardContainerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ExternalGiftCardContainerViewController") as! ExternalGiftCardContainerViewController
        externalGiftCardDelegate = vc
        if balanceDue > 0 {
            vc.total = Double(balanceDue)
        } else {
            vc.total = Double(finalTotalSend)
        }
        vc.delegate = self
        return vc
    }()
    
    private lazy var externalContainer: ExternalContainerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ExternalContainerViewController") as! ExternalContainerViewController
        externalCardDelegate = vc
        if balanceDue > 0 {
            vc.total = Double(balanceDue)
        } else {
            vc.total = Double(finalTotalSend)
        }
        vc.delegate = self
        return vc
    }()
    
    private lazy var paxPayContainer: PaxPayContainerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaxPayContainerViewController") as! PaxPayContainerViewController
        paxDelegate = vc
        vc.delegate = self
        vc.total = "\(Double(truncating: cartObjectData["Total"] as? NSNumber ?? 0))"
        if balanceDue > 0 {
            vc.totalAmount = Double(balanceDue)
        } else {
            vc.totalAmount = Double(finalTotalSend)
        }
        return vc
    }()
    private lazy var ProductInfoViewController: iPad_ProductInfoViewController = {
        let storyboard = UIStoryboard.init(name: "iPad", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "iPad_ProductInfoViewController") as! iPad_ProductInfoViewController
        productDelegate = vc
        vc.cancelProductDelegate = self
        return vc
    }()
    
    // token enroll
    func processTokenEnroll() {
        let request = IMSTokenEnrollmentTransactionRequest(tokenRequestParameters: getTokenRequestParams(), andClerkID: "3733", andLongitude: getLongitude(), andLatitude: getLatitude(), andUCIFormat: .UCIFormatIngenico, andOrderNumber: "12132434")!
        Ingenico.sharedInstance()?.payment.processTokenEnrollment(withCardReader: request, andUpdateProgress: progressCallback!, andSelectApplication: applicationSelectionCallback!, andOnDone: doneCallback!)
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
        builder.tokenFeeInCents = Int(HomeVM.shared.ingenicoData[0].tokenization_fee_cents) ?? 0
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
        if ((transactionType == .TransactionTypeTokenEnrollment && canEnrollToken) || HomeVM.shared.ingenicoData[0].tokenization_enabled == true ) {
            return builder.createTokenEnrollmentRequestParameters()
        }
        return nil
    }
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK Hide for V5
        
        
        
        ingenico = Ingenico.sharedInstance()
        ingenico.setLogging(false)
        deviceList = [RUADevice]()
        
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
                
                if (response?.transactionID?.count ?? 0 > 0) {
                    self.setLastTransactionID(response?.transactionID ?? "")
                }
                if (response?.tokenResponseParameters?.tokenIdentifier?.count ?? 0 > 0) {
                    self.setLastTokenID(response?.tokenResponseParameters.tokenIdentifier ?? "")
                }
                if (response?.clientTransactionID?.count ?? 0 > 0) {
                    self.setLastClientTransactionID(response?.clientTransactionID ?? "")
                }
                //SVProgressHUD.showSuccess(withStatus: "Transaction Approved")
                appDelegate.showToast(message: "Transaction Approved")
                DispatchQueue.main.async {
                    Indicator.sharedInstance.lblIngenico.text = ""
                }
                
                
                print(response)
                if DataManager.isIngenicPaymentMethodCancelAndMessage {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        MainSocketManager.shared.onPaymentMessage(paymentMesssage: "Transaction Approved")
                    }
                }
                appDelegate.strIngenicoErrorMsg = ""
                Indicator.sharedInstance.hideIndicator()
                //self.IngenicoDataResponce = response!
                self.getSignatureOrUpdateTransaction(response!)
            }else {
                let nserror = error as NSError?
                Indicator.sharedInstance.hideIndicator()
                if response?.transactionID != nil && response?.transactionResponseCode.rawValue == 2{
                    self.isPayButtonSelected = true
                    self.idleChargeButton()
                    Indicator.sharedInstance.hideIndicator()
                    //self.placeOrder()
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
                
                Indicator.sharedInstance.hideIndicator()
                //if  "Transaction Failed with error code: \(self.getResponseCodeString((nserror!.code)))" == "Transaction Failed with error code: Transaction Cancelled" {
                self.placeOrder()
                
                if self.getResponseCodeString((nserror!.code)) == "4995" {
                    
                }
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
        
        self.versionOb = Int(DataManager.appVersion)!
        DataManager.isSideMenuSwiperCard = false
        self.balanceDueView.isHidden = true
        self.labelBallanceDueAmt.isHidden = true
        self.loadData()
        self.refreshCart()

        //OfflineDataManager Delegate
        OfflineDataManager.shared.iPadPaymentTypeDelegate = self
        if self.orderType == .refundOrExchangeOrder {
            DataManager.refundExchangeCheckForCustomerApp = true
            btnHome.isHidden = true
        }else{
            DataManager.refundExchangeCheckForCustomerApp = false
            btnHome.isHidden = false
        }
        addChildView(childVC: ProductInfoViewController, in: containerViewIpadProductInfo)//For load product info contoller in container

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        containerViewIpadProductInfo.isHidden = true
        self.selectedViewController = nil
        if self.selectedViewController == nil {
            // self.add(childVC: paymentTypeContainer, isRemoveAll: false)
            // sudama task - 4499
            // self.add(childVC: paymentTypeContainer, isRemoveAll: false)
            if appDelegate.isOpenUrl &&  DataManager.isIngenicoConnected && getIsDeviceConnected() {
                didSelectPaymentMethod(with: "CARD READER")
                appDelegate.strPaymentType = "CARD READER"
            } else {
                if appDelegate.isOpenUrl {
                    appDelegate.showToast(message: "Please connect the ingenico device.")
                }
                if DataManager.selectedPayment?.count == 1 {
                    if DataManager.selectedPayment?[0] == "CARD READER" {
                        if getIsDeviceConnected() {
                            didSelectPaymentMethod(with: DataManager.selectedPayment?[0] ?? "")
                            appDelegate.strPaymentType = DataManager.selectedPayment?[0] ?? ""
                        } else {
                            //self.add(childVC: paymentTypeContainer, isRemoveAll: false)
                            didSelectPaymentMethod(with: DataManager.selectedPayment?[0] ?? "")
                            appDelegate.strPaymentType = DataManager.selectedPayment?[0] ?? ""
                        }
                    } else {
                        didSelectPaymentMethod(with: DataManager.selectedPayment?[0] ?? "")
                        appDelegate.strPaymentType = DataManager.selectedPayment?[0] ?? ""
                    }
                    //didSelectPaymentMethod(with: DataManager.selectedPayment?[0] ?? "")
                    //appDelegate.strPaymentType = DataManager.selectedPayment?[0] ?? ""
                }else{
                    if DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD")) {
                        
                        if let index = DataManager.selectedPayment!.index(of: "MULTI CARD") {
                            if index == 0 {
                                if DataManager.selectedPayment?[1] == "CARD READER" {
                                    if getIsDeviceConnected() {
                                        didSelectPaymentMethod(with: DataManager.selectedPayment?[1] ?? "")
                                        appDelegate.strPaymentType = DataManager.selectedPayment?[1] ?? ""
                                    } else {
                                        self.add(childVC: paymentTypeContainer, isRemoveAll: false)
                                    }
                                } else {
                                    didSelectPaymentMethod(with: DataManager.selectedPayment?[1] ?? "")
                                    appDelegate.strPaymentType = DataManager.selectedPayment?[1] ?? ""
                                }
                                //didSelectPaymentMethod(with: DataManager.selectedPayment![1])
                                //appDelegate.strPaymentType = DataManager.selectedPayment?[1] ?? ""
                            }else{
                                if DataManager.selectedPayment?[0] == "CARD READER" {
                                    if getIsDeviceConnected() {
                                        didSelectPaymentMethod(with: DataManager.selectedPayment?[0] ?? "")
                                        appDelegate.strPaymentType = DataManager.selectedPayment?[0] ?? ""
                                    } else {
                                        //self.add(childVC: paymentTypeContainer, isRemoveAll: false)
                                        didSelectPaymentMethod(with: DataManager.selectedPayment?[0] ?? "")
                                        appDelegate.strPaymentType = DataManager.selectedPayment?[0] ?? ""
                                    }
                                } else {
                                    didSelectPaymentMethod(with: DataManager.selectedPayment?[0] ?? "")
                                    appDelegate.strPaymentType = DataManager.selectedPayment?[0] ?? ""
                                }
                                //didSelectPaymentMethod(with: DataManager.selectedPayment![0])
                                //appDelegate.strPaymentType = DataManager.selectedPayment?[0] ?? ""
                            }
                        }
                        
                    }else{
                        if DataManager.posDefaultPaymentMethod != "" && !appDelegate.isOpenUrl {
                            if DataManager.selectedPayment != nil {
                                if self.isOpenToOrderHistory {
                                    self.add(childVC: paymentTypeContainer, isRemoveAll: false)
                                }else {
                                    if DataManager.selectedPayment!.contains(DataManager.posDefaultPaymentMethod.uppercased()) {
                                        didSelectPaymentMethod(with: DataManager.posDefaultPaymentMethod.uppercased())
                                        appDelegate.strPaymentType = DataManager.posDefaultPaymentMethod.uppercased()
                                    } else {
                                        self.add(childVC: paymentTypeContainer, isRemoveAll: false)
                                    }
                                }
                                
                            } else {
                                self.add(childVC: paymentTypeContainer, isRemoveAll: false)
                            }
                            
                        } else {
                            self.add(childVC: paymentTypeContainer, isRemoveAll: false)

                        }
                    }
                }
            }
            //
        }
//        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
//            return
//        }  /// this code comment on 25 july 2022 because of location off from device , over next code not working
        
        
        if DataManager.showShippingCalculatiosInPos == "false" {
            lblShippingHead.addDashedBorder = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        } else {
            lblShippingHead.addDashedBorder = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        
        if DataManager.isTaxOn {
            taxNameLabel.addDashedBorder = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        } else {
            taxNameLabel.addDashedBorder = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
        
        self.str_showShipOrderInPos = DataManager.showShipOrderInPos!
        self.idleChargeButton()
        SwipeAndSearchVC.shared.connectionDelegate = self
        self.audioButton.isSelected = SwipeAndSearchVC.shared.isJackReaderConnected
        SwipeAndSearchVC.shared.isProductSearching = false
        SwipeAndSearchVC.shared.enableTextField()
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "SaveApplicationData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveApplicationData(_:)), name: Notification.Name(rawValue: "SaveApplicationData"), object: nil)
        //Hide View When Internet Off
        //self.taxView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.shippingView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.lockLineView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.lockButton.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.logoutButton.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.logoutLineView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            self.addCustomerView.isHidden = true
        }else {
            self.addCustomerView.isHidden = !DataManager.isCustomerManagementOn || orderType == .refundOrExchangeOrder
        }
        self.addDiscountView.isHidden = orderType == .refundOrExchangeOrder
        if appDelegate.isOpenToOrderHistory {
            self.addDiscountView.isHidden =  true
            addIconImageView.isHidden = true
        }
        if !Keyboard._isExternalKeyboardAttached() {
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        }
        
        //if versionOb < 4 {
            shippingRefundButton.isHidden = true
        //}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // MARK Hide for V5
        // opne code Dev
        //        self.payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //            self.payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        //        }
        var cartDataDue = DataManager.cartData
        self.str_showShipOrderInPos = DataManager.showShipOrderInPos!
        if self.str_showShipOrderInPos == "true" {
            self.shippingRefundButton.isHidden = false
            if orderType == .refundOrExchangeOrder {
                self.shippingRefundButton.setTitle("Refund", for: .normal)
            } else {
                self.shippingRefundButton.setTitle("Ship Order", for: .normal)
            }
        }else{
            shippingRefundButton.isHidden = true
        }
        if ((cartDataDue?["balance_due"] as? Double) != nil) {
            HomeVM.shared.DueShared = cartDataDue?["balance_due"] as? Double ?? 99.99
            balanceDue = HomeVM.shared.DueShared
        }
        if HomeVM.shared.DueShared > 0.0 {
            self.balanceDueView.isHidden = false
            self.labelBallanceDueAmt.isHidden = false
            
            if dataNew == 0.0 {
                self.labelBallanceDueAmt.text = HomeVM.shared.DueShared.currencyFormat
                payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(HomeVM.shared.DueShared.currencyFormat)", for: .normal)
                self.updateTotalAmount(amount: dataNew, SubTotal: SubTotalPrice)
                
            } else {
                self.labelBallanceDueAmt.text = dataNew.currencyFormat
                balanceDue = dataNew
                HomeVM.shared.DueShared = dataNew
                
                payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(dataNew.currencyFormat)", for: .normal)
                self.updateTotalAmount(amount: dataNew, SubTotal: SubTotalPrice)
                
            }
        } else {
            self.balanceDueView.isHidden = true
            self.labelBallanceDueAmt.isHidden = true
        }
        
        if DataManager.isBalanceDueData {
            if HomeVM.shared.amountPaid > 0 {
                viewAmountPaid.isHidden = false
                lblAmountPaid.text = HomeVM.shared.amountPaid.currencyFormat
            } else {
                viewAmountPaid.isHidden = true
            }
            taxTextField.isUserInteractionEnabled = false
        } else {
            viewAmountPaid.isHidden = true
            taxTextField.isUserInteractionEnabled = true
        }
        
        if versionOb < 4 {
            shippingRefundButton.isHidden = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.saveAllData()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "ShowKeyboard"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "SaveApplicationData"), object: nil)
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = true
        if UI_USER_INTERFACE_IDIOM() == .phone {
            SwipeAndSearchVC.delegate = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProductVC"
        {
            let vc = segue.destination as! EditProductVC
            vc.delegate = self
            vc.editProductDelegate = self
            vc.delegateForProductInfo = self
            editProductDetailDelegate = vc
        }
        
        if segue.identifier == "iPadSelectCustomerViewController" {
            let vc = segue.destination as! iPadSelectCustomerViewController
            self.customerDelegate = vc
            vc.customerDelegate = self
            vc.customerDelegateForAddNewCustomer = self
        }
        
        //        if segue.identifier == "signatureSegue"
        //        {
        //            if let vc = segue.destination as? SignatureViewController
        //            {
        //                vc.signatureDelegateone = self
        //            }
        //        }
        
        if segue.identifier == "ShowDetailsVC"
        {
            let vc = segue.destination as! ShowDetailsVC
            vc.delegate = self
            showDetailsDelegateOne = vc
        }
        if segue.identifier == "savedCardVC"
        {
            let vc = segue.destination as! SavedCardViewController
            vc.delegate = self
            vc.closeDelegate = self
            vc.userId = strCardUserID
            vc.customerSavedCardDelegate = self
            delegateSavedCard = vc as? savedCardDelegate
            creditshowData = vc
        }
        if segue.identifier == "ShippingVC"
        {
            let vc = segue.destination as! ShippingVC
            vc.delegate = self
            delegateEditProduct = vc
            
        }
    }
    
    @objc func saveApplicationData(_ sender: Notification) {
        saveAllData()
    }
    
    //MARK: Private Functions
    private func idleChargeButton(by time: Double = 1.5) {
        if NetworkConnectivity.isConnectedToInternet() {
            self.payButton.isUserInteractionEnabled = false
            self.authButton.isUserInteractionEnabled = false
            //self.authButton.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                self.payButton.isUserInteractionEnabled = true
                self.authButton.isUserInteractionEnabled = true
            }
        }else {
            self.payButton.isUserInteractionEnabled = true
            self.authButton.isUserInteractionEnabled = true
        }
    }
    
    private func saveAllData() {
        if orderType == .newOrder {
            UserDefaults.standard.removeObject(forKey: "CustomerObj")
            UserDefaults.standard.synchronize()
            
            //Save cart Data
            let cartData = ["balance_due": balanceDue, "Total_due": Totaldue, "MultiTipAmount_due":MultiTipAmountDue, "tipAmount_due": tipAmountDue,"isDefaultTaxSelected": isDefaultTaxSelected,"isDefaultTaxChanged": isDefaultTaxChanged, "isPercentageDiscountApplied":isPercentageDiscountApplied,"str_AddDiscountPercent":str_AddDiscountPercent,"taxType":taxType , "taxTitle":taxTitle, "taxAmountValue":taxAmountValue, "str_ShippingANdHandling":str_ShippingANdHandling,"isShippingPriceChanged": isShippingPriceChanged, "str_AddDiscount":str_AddDiscount, "str_TaxPercentage":str_TaxPercentage, "str_AddCoupon":str_AddCouponName, "str_CouponDiscount":str_CouponDiscount, "taxableCouponTotal":taxableCouponTotal] as [String : Any]
            let customerObj = ["country": CustomerObj.country, "billingCountry":CustomerObj.billingCountry,"shippingCountry":CustomerObj.shippingCountry,"coupan": str_AddCouponName, "str_first_name":CustomerObj.str_first_name, "str_last_name":CustomerObj.str_last_name, "str_address":CustomerObj.str_address, "str_bpid":CustomerObj.str_bpid, "str_city":CustomerObj.str_city, "str_order_id":CustomerObj.str_order_id, "str_email":CustomerObj.str_email, "str_userID":CustomerObj.str_userID, "str_phone":CustomerObj.str_phone,"str_region":CustomerObj.str_region, "str_address2":CustomerObj.str_address2, "str_Billingcity":CustomerObj.str_Billingcity, "str_postal_code":CustomerObj.str_postal_code, "str_Billingphone":CustomerObj.str_Billingphone, "str_Billingaddress":CustomerObj.str_Billingaddress, "str_Billingaddress2":CustomerObj.str_Billingaddress2, "str_Billingregion":CustomerObj.str_Billingregion, "str_Billingpostal_code":CustomerObj.str_Billingpostal_code,"shippingPhone": CustomerObj.str_Shippingphone,"shippingAddress" : CustomerObj.str_Shippingaddress, "shippingAddress2": CustomerObj.str_Shippingaddress2, "shippingCity": CustomerObj.str_Shippingcity, "shippingRegion" : CustomerObj.str_Shippingregion, "shippingPostalCode": CustomerObj.str_Shippingpostal_code, "billing_first_name":CustomerObj.str_billing_first_name, "billing_last_name":CustomerObj.str_billing_last_name,"user_custom_tax":CustomerObj.userCustomTax,"shipping_first_name":CustomerObj.str_shipping_first_name, "shipping_last_name":CustomerObj.str_shipping_last_name,"shippingEmail": CustomerObj.str_Shippingemail,"str_Billingemail": CustomerObj.str_Billingemail,"str_company" : CustomerObj.str_company, "str_BillingCustom1TextField": CustomerObj.str_CustomText1, "str_BillingCustom2TextField" : CustomerObj.str_CustomText2 ,"loyalty_balance" : CustomerObj.doubleloyalty_balance, "emv_card_count": CustomerObj.emv_card_Count,"office_phone":CustomerObj.str_office_phone,"contact_source": CustomerObj.str_contact_source, "customer_status":CustomerObj.str_customer_status] as [String : Any]
            
            var isDataSave = false
            
            for (key, value) in customerObj {
                if value as? String != "" && key != "coupan" {
                    isDataSave = true
                }
            }
            
            if !isAllDataRemoved && !isPayButtonSelected {
                DataManager.cartData = cartData
            }
            
            if isDataSave && !isPayButtonSelected && CustomerObj.isDataAdded {
                DataManager.customerObj = customerObj
            }
            //            else {
            //                updateLoggedInCustomer()
            //            }
            
        }
    }
    
    private func saveCustomerData() {
        let customerObj = ["country": CustomerObj.country, "billingCountry":CustomerObj.billingCountry,"shippingCountry":CustomerObj.shippingCountry,"coupan": str_AddCouponName, "str_first_name":CustomerObj.str_first_name, "str_last_name":CustomerObj.str_last_name, "str_address":CustomerObj.str_address, "str_bpid":CustomerObj.str_bpid, "str_city":CustomerObj.str_city, "str_order_id":CustomerObj.str_order_id, "str_email":CustomerObj.str_email, "str_userID":CustomerObj.str_userID, "str_phone":CustomerObj.str_phone,"str_region":CustomerObj.str_region, "str_address2":CustomerObj.str_address2, "str_Billingcity":CustomerObj.str_Billingcity, "str_postal_code":CustomerObj.str_postal_code, "str_Billingphone":CustomerObj.str_Billingphone, "str_Billingaddress":CustomerObj.str_Billingaddress, "str_Billingaddress2":CustomerObj.str_Billingaddress2, "str_Billingregion":CustomerObj.str_Billingregion, "str_Billingpostal_code":CustomerObj.str_Billingpostal_code,"shippingPhone": CustomerObj.str_Shippingphone,"shippingAddress" : CustomerObj.str_Shippingaddress, "shippingAddress2": CustomerObj.str_Shippingaddress2, "shippingCity": CustomerObj.str_Shippingcity, "shippingRegion" : CustomerObj.str_Shippingregion, "shippingPostalCode": CustomerObj.str_Shippingpostal_code, "billing_first_name":CustomerObj.str_billing_first_name, "billing_last_name":CustomerObj.str_billing_last_name,"user_custom_tax":CustomerObj.userCustomTax,"shipping_first_name":CustomerObj.str_shipping_first_name, "shipping_last_name":CustomerObj.str_shipping_last_name,"shippingEmail": CustomerObj.str_Shippingemail,"str_Billingemail": CustomerObj.str_Billingemail,"str_company" : CustomerObj.str_company, "str_BillingCustom1TextField" : CustomerObj.str_CustomText1, "str_BillingCustom2TextField" :  CustomerObj.str_CustomText2,"loyalty_balance" : CustomerObj.doubleloyalty_balance, "emv_card_count": CustomerObj.emv_card_Count,"office_phone":CustomerObj.str_office_phone,"contact_source": CustomerObj.str_contact_source, "customer_status": CustomerObj.str_customer_status] as [String : Any]
        DataManager.customerObj = customerObj
        
    }
    
    private func saveCartData() {
        let cartData = ["balance_due":balanceDue, "Total_due": Totaldue, "MultiTipAmount_due":MultiTipAmountDue, "tipAmount_due":tipAmountDue,"isDefaultTaxSelected": isDefaultTaxSelected,"isDefaultTaxChanged":isDefaultTaxChanged ,"str_AddDiscountPercent":str_AddDiscountPercent, "isPercentageDiscountApplied":isPercentageDiscountApplied,"taxType":taxType , "taxTitle":taxTitle, "taxAmountValue":taxAmountValue, "str_ShippingANdHandling":str_ShippingANdHandling,"isShippingPriceChanged": isShippingPriceChanged, "str_AddDiscount":str_AddDiscount, "str_TaxPercentage":str_TaxPercentage, "str_AddCoupon":str_AddCouponName, "str_CouponDiscount":str_CouponDiscount, "taxableCouponTotal":taxableCouponTotal] as [String : Any]
        DataManager.cartData = cartData
    }
    
    private func updateCustomerData() {
        if let customerObj = DataManager.customerObj {
            CustomerObj.str_userID = customerObj["str_userID"] as? String ?? ""
            CustomerObj.str_bpid = customerObj["str_bpid"] as? String ?? ""
            CustomerObj.userCustomTax = customerObj["user_custom_tax"] as? String ?? ""
            CustomerObj.userCoupan = customerObj["coupan"] as? String ?? ""
            CustomerObj.cardCount = customerObj["card_count"] as? Int ?? 0
            CustomerObj.shippingaddressCount = customerObj["shippingaddress_count"] as? Int
            
            CustomerObj.str_first_name = customerObj["str_first_name"] as? String ?? ""
            CustomerObj.str_last_name = customerObj["str_last_name"] as? String ?? ""
            CustomerObj.str_email = customerObj["str_email"] as? String ?? ""
            CustomerObj.str_phone = customerObj["str_phone"] as? String ?? ""
            CustomerObj.str_address = customerObj["str_address"] as? String ?? ""
            CustomerObj.str_address2 = customerObj["str_address2"] as? String ?? ""
            CustomerObj.str_city = customerObj["str_city"] as? String ?? ""
            CustomerObj.str_region = customerObj["str_region"] as? String ?? ""
            CustomerObj.str_postal_code = customerObj["str_postal_code"] as? String ?? ""
            CustomerObj.country = customerObj["country"] as? String ?? ""
            
            CustomerObj.str_Billingphone = customerObj["str_Billingphone"] as? String ?? ""
            CustomerObj.str_Billingaddress = customerObj["str_Billingaddress"] as? String ?? ""
            CustomerObj.str_Billingaddress2 = customerObj["str_Billingaddress2"] as? String ?? ""
            CustomerObj.str_Billingcity = customerObj["str_Billingcity"] as? String ?? ""
            CustomerObj.str_Billingregion = customerObj["str_Billingregion"] as? String ?? ""
            CustomerObj.str_Billingpostal_code = customerObj["str_Billingpostal_code"] as? String ?? ""
            CustomerObj.str_billing_first_name = customerObj["billing_first_name"] as? String ?? ""
            CustomerObj.str_billing_last_name = customerObj["billing_last_name"] as? String ?? ""
            CustomerObj.billingCountry = customerObj["billingCountry"] as? String ?? ""
            CustomerObj.str_Billingemail = customerObj["str_Billingemail"] as? String ?? ""
            CustomerObj.str_company = customerObj["str_company"] as? String ?? ""
            CustomerObj.str_CustomText1 = customerObj["str_BillingCustom1TextField"] as? String ?? ""
            CustomerObj.str_CustomText2 = customerObj["str_BillingCustom2TextField"] as? String ?? ""
            
            CustomerObj.str_office_phone = customerObj["office_phone"]as? String ?? ""
            CustomerObj.str_contact_source = customerObj["contact_source"]as? String ?? ""
            CustomerObj.str_customer_status = customerObj["customer_status"] as? String ?? ""
            CustomerObj.str_Shippingphone = customerObj["shippingPhone"] as? String ?? ""
            CustomerObj.str_Shippingaddress = customerObj["shippingAddress"] as? String ?? ""
            CustomerObj.str_Shippingaddress2 = customerObj["shippingAddress2"] as? String ?? ""
            CustomerObj.str_Shippingcity = customerObj["shippingCity"] as? String ?? ""
            CustomerObj.str_Shippingregion = customerObj["shippingRegion"] as? String ?? ""
            CustomerObj.str_Shippingpostal_code = customerObj["shippingPostalCode"] as? String ?? ""
            CustomerObj.str_shipping_first_name = customerObj["shipping_first_name"] as? String ?? ""
            CustomerObj.str_shipping_last_name = customerObj["shipping_last_name"] as? String ?? ""
            CustomerObj.shippingCountry = customerObj["shippingCountry"] as? String ?? ""
            CustomerObj.str_Shippingemail = customerObj["shippingEmail"] as? String ?? ""
            CustomerObj.doubleloyalty_balance = customerObj["loyalty_balance"] as? Double ?? 0.0
            CustomerObj.emv_card_Count = customerObj["emv_card_count"] as? Double ?? 0.0
            
            CustomerObj.isDataAdded = true
            if CustomerObj.str_first_name == "" && CustomerObj.str_last_name == "" {
                self.customerNameLabel.text = "Customer #" + CustomerObj.str_userID
                strCardUserID = CustomerObj.str_userID
            }else{
                self.customerNameLabel.text = CustomerObj.str_first_name + " " + CustomerObj.str_last_name
            }
            addIconImageView.image =  UIImage(named: "edit-icon1")
        }
    }
    
    private func addBlurView() {
        let blurEffect = UIBlurEffect(style: .regular)
        self.visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.visualEffectView.frame = view.frame
        self.view.addSubview(self.visualEffectView)
    }
    
    private func showEditView() {
        setView(view: editProductDetailContainerView, hidden: false)
        self.editProductDetailBlurView.isHidden = false
        self.editProductDetailBlurView.alpha = 0
        UIView.animate(withDuration: Double(0.5), animations: {
            self.editProductDetailBlurView.alpha = 0.4
            self.editProductDetailContainerTopConstraint.constant = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? 100 : 180
            self.view.layoutIfNeeded()
        })
    }
    
    func hideEditView() {
        setView(view: editProductDetailContainerView, hidden: true)
        UIView.animate(withDuration: Double(0.5), animations: {
            self.editProductDetailContainerTopConstraint.constant = UIScreen.main.bounds.height
            self.view.layoutIfNeeded()
            self.editProductDetailBlurView.alpha = 0
            self.editProductDetailBlurView.isHidden = true
        })
    }
    
    //Add Child View Controller
    private func add(childVC: UIViewController, isRemoveAll: Bool = true) {
        self.containerViewTopConstraint.constant = childVC == addCustomerContainer ? 0 : 55
        if isRemoveAll {
            self.removeAllContainer()
        }
        self.selectedViewController = childVC
        self.addChildViewController(childVC)
        self.containerView.addSubview(childVC.view)
        self.containerView.layer.add(transition, forKey: kCATransition)
        childVC.view.frame = containerView.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childVC.didMove(toParentViewController: self)
    }
    
    //Remove Child View Controller
    private func remove(childVC: UIViewController) {
        childVC.willMove(toParentViewController: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParentViewController()
    }
    private func addChildView(childVC: UIViewController, in view: UIView) {
        self.addChildViewController(childVC)
        view.addSubview(childVC.view)
        view.layer.add(transition, forKey: kCATransition)
        childVC.view.frame = view.bounds
        childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childVC.didMove(toParentViewController: self)
    }
    //Remove All Child View Controller
    private func removeAllContainer() {
        self.selectedViewController = nil
        self.remove(childVC: addCustomerContainer)
        self.remove(childVC: paymentTypeContainer)
        self.remove(childVC: paymentViewContainer)
        self.remove(childVC: creditCardContainer)
        self.remove(childVC: multiCardContainer)
        self.remove(childVC: invoiceContainer)
        self.remove(childVC: cashContainer)
        self.remove(childVC: achCheckContainer)
        self.remove(childVC: checkContainer)
        self.remove(childVC: giftCardContainer)
        self.remove(childVC: internalGiftCardContainer)
        self.remove(childVC: externalGiftCardContainer)
        self.remove(childVC: externalContainer)
        self.remove(childVC: paxPayContainer)
        self.remove(childVC: ingenicoContainer)
    }
    
    private func updateTotalAmount(amount: Double , SubTotal: Double) {
        amountforCredit = amount
        if(str_PaymentName != "")
        {
            if str_PaymentName == "CREDIT" || str_PaymentName == "credit"
            {
                creditCardDelegate?.didUpdateTotal?(amount: amount , subToal : SubTotal)
            }
            else if str_PaymentName == "CASH"
            {
                cashDelegate?.didUpdateTotal?(amount: amount , subToal : 0.0)
            }
            else if str_PaymentName == "INVOICE"
            {
                invoiceDelegate?.didUpdateTotal?(amount: amount , subToal : 0.0)
            }
            else if str_PaymentName == "ACH CHECK"
            {
                achCheckDelegate?.didUpdateTotal?(amount: amount , subToal : 0.0)
            }
            
            else if str_PaymentName == "GIFT CARD"
            {
                giftCardDelegate?.didUpdateTotal?(amount: amount , subToal : 0.0)
            }
            else if str_PaymentName == "EXTERNAL GIFT CARD"
            {
                externalGiftCardDelegate?.didUpdateTotal?(amount: amount , subToal : 0.0)
            }
            else if str_PaymentName == "INTERNAL GIFT CARD"
            {
                internalGiftCardDelegate?.didUpdateTotal?(amount: amount, subToal : 0.0)
            }
            else if str_PaymentName == "CHECK"
            {
                checkDelegate?.didUpdateTotal?(amount: amount, subToal : 0.0)
            }
            else if str_PaymentName == "EXTERNAL"
            {
                externalCardDelegate?.didUpdateTotal?(amount: amount, subToal : 0.0)
            }
            else if str_PaymentName == "PAX PAY"
            {
                paxDelegate?.didUpdateTotal?(amount: amount, subToal : SubTotal)
            }
            else if str_PaymentName == "MULTI CARD"
            {
                multicardDelegate?.didUpdateTotal?(amount: amount, subToal : SubTotal)
            }
            else if str_PaymentName == "NOTES"
            {
                notesDelegate?.didUpdateTotal?(amount: amount, subToal : 0.0)
            }
            else if str_PaymentName == "CARD READER" || str_PaymentName == "card reader"
            {
                ingenicoDelegate?.didUpdateTotal?(amount: amount , subToal : SubTotal)
            }
        }
    }
    // end......priya
    
    private func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    
    func refreshCart() {
        if let cartProductsArray = DataManager.cartProductsArray {
            self.cartProductsArray = cartProductsArray
        }
        DispatchQueue.main.async {
            self.tabelView.reloadData {
                if self.cartProductsArray.count != 0 {
                    self.tabelView.scrollToBottom()
                    if self.tabelView.contentSize.height > self.tabelView.frame.size.height {
                        DispatchQueue.main.async {
                            self.tabelView.contentOffset.y = self.tabelView.contentSize.height - self.tabelView.frame.size.height + 5
                            self.view.layoutIfNeeded()
                        }
                    }
                }
            }
        }
        self.calculateTotalCart()
    }
    
    private func moveToCreditCardScreen() {
        str_PaymentName = "CREDIT"
        if UI_USER_INTERFACE_IDIOM() == .pad {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                appDelegate.strPaymentType = "CREDIT"
                self.updateCustomerData()
                self.creditCardDelegate?.enableCardReader?()
            }
        }
        self.add(childVC: creditCardContainer)
        //lbl_PaymentMethodName.text = "Credit Card"
        lbl_PaymentMethodName.text = " "
        
        btn_Cancel.isHidden = false
        authButton.isHidden = false
        
        if DataManager.isAuthentication {
            if DataManager.isBalanceDueData {
                self.authButton.isHidden = true
            } else {
                self.authButton.isHidden = !((str_PaymentName == "CREDIT") ||  (str_PaymentName == "PAX PAY"))
            }
        }else {
            self.authButton.isHidden = true
        }
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            authButton.isHidden = true
        }
        
    }
    
    private func loadData() {
        self.str_showShipOrderInPos = DataManager.showShipOrderInPos!
        
        editProductDetailContainerView.isHidden = true
        editProductDetailBlurView.isHidden = true
        self.depositeView.isHidden = true
        self.authButton.isHidden = true
        //self.applyCouponView.isHidden = true
        //self.discountView.isHidden = true
        //self.tipView.isHidden = true
        self.btn_Cancel.isHidden = true
        
        
        if let cartData = DataManager.cartData {
            isPercentageDiscountApplied = cartData["isPercentageDiscountApplied"] as? Bool ?? false
            
            str_AddDiscountPercent = cartData["str_AddDiscountPercent"] as? String ?? ""
            
            balanceDue = cartData["balance_due"] as? Double ?? 0.0
            tipAmountDue = cartData["tipAmount_due"] as? Double ?? 0.0
            MultiTipAmountDue = cartData["MultiTipAmount_due"] as? Double ?? 0.0
            Totaldue = cartData["Total_due"] as? Double ?? 0.0
            HomeVM.shared.DueShared = balanceDue
            HomeVM.shared.tipValue = tipAmountDue
            if str_PaymentName == "CARD READER" {
                if HomeVM.shared.tipValue > 0 {
                    self.tipLabel.text = HomeVM.shared.tipValue.currencyFormat
                    self.tipView.isHidden = tipLabel.text == "$0.00"
                }
            }
            HomeVM.shared.MultiTipValue = MultiTipAmountDue
            if DataManager.isBalanceDueData {
                HomeVM.shared.TotalDue = TotalPrice
            } else {
                HomeVM.shared.TotalDue = Totaldue
            }
            tipLabel.text = HomeVM.shared.tipValue.currencyFormat
            
            if tipAmountDue == 0.0 {
                self.tipView.isHidden = true
            }
            
            
            
        }
        
        
        if let array = DataManager.cartProductsArray {
            cartProductsArray = array
        }
        
        if versionOb < 4 {
            shippingRefundButton.isHidden = true
        } else {
            if str_showShipOrderInPos == "true"{
                shippingRefundButton.isHidden = orderType == .newOrder
                self.shippingRefundButton.setTitle("Ship order", for: .normal)
            }else{
                shippingRefundButton.isHidden = true
            }
        }
        
        
        self.array_TaxList = [TaxListModel]()
        let taxModelObj = TaxListModel()
        taxModelObj.tax_title = "Default"
        taxModelObj.tax_type = self.taxType
        taxModelObj.tax_amount = self.taxAmountValue
        self.array_TaxList.insert(taxModelObj, at: 0)
        
        for tax in HomeVM.shared.taxList {
            self.array_TaxList.append(tax)
        }
        
        if orderType == .refundOrExchangeOrder || appDelegate.isOpenToOrderHistory {
            orderInfoObj = cartObjectData["orderInfoObj"] as? OrderInfoModel ?? OrderInfoModel()
        }
        
        btn_Cancel.isHidden = true
        self.isShippingPriceChanged = cartObjectData["isShippingPriceChanged"] as? Bool ?? false
        self.isDefaultTaxChanged = cartObjectData["isDefaultTaxChanged"] as? Bool ?? false
        self.isDefaultTaxSelected = cartObjectData["isDefaultTaxSelected"] as? Bool ?? false
        
        if versionOb < 4 {
            shippingRefundButton.isHidden = true
        } else {
            if self.str_showShipOrderInPos == "true" {
                shippingRefundButton.isHidden = false
                self.shippingRefundButton.setTitle("Ship Order", for: .normal)
                self.shippingRefundButton.isSelected = cartObjectData["shippingRefundButtonSelected"] as? Bool ?? false
            }else{
                shippingRefundButton.isHidden = true
            }
        }
        
        
        subtotalLabel.text = Double(truncating: cartObjectData["subTotal"]as! NSNumber).currencyFormat
        //balanceDue = cartObjectData["balance_due"] as? Double ?? 0.0
        //HomeVM.shared.DueShared = cartObjectData["balance_due"] as? Double ?? 0.0
        if let customerObj = cartObjectData["customerObj"] as? CustomerListModel {
            self.CustomerObj = customerObj
            if CustomerObj.isDataAdded {
                
                if customerObj.str_first_name == "" && customerObj.str_last_name == "" {
                    self.customerNameLabel.text = "Customer #" + customerObj.str_userID
                    strCardUserID = customerObj.str_userID
                }else{
                    self.customerNameLabel.text = customerObj.str_first_name + " " + customerObj.str_last_name
                }
                
                // self.customerNameLabel.text = customerObj.str_first_name + " " + customerObj.str_last_name
                addIconImageView.image = UIImage(named: "edit-icon1")
            }
        }
        
        if let couponName = cartObjectData["couponName"] as? String,couponName != "" {
            self.callAPItoGetCoupanProductIds(coupan: couponName)
        }
        
        self.str_AddDiscount = cartObjectData["addDiscount"] as? String ?? ""
        let discount = Double(self.str_AddDiscount) ?? 0.0
        discountLabel.text = discount.currencyFormat
        
        if cartObjectData["ShippingHandling"]as? String == "" {
            shippingLabel.text = "$0.00"
        }
        else
        {
            let shipHand = Double((cartObjectData["ShippingHandling"]as? String ?? "0.00").replacingOccurrences(of: "$", with: "")) ?? 0.00
            shippingLabel.text = shipHand.currencyFormat
            str_ShippingANdHandling = shipHand.roundToTwoDecimal
        }
        
        let tax =  Double(cartObjectData["tax"]as? String ?? "0") ?? 0.00
        taxAmountLabel.text = tax.currencyFormat
        
        if cartObjectData["taxStateName"]as? String == "" {
            taxNameLabel.text = "Tax (Default)"
        }
        else if(cartObjectData["taxStateName"]as? String == "countrywide")
        {
            taxNameLabel.text = "Tax (Default)"
        }
        else
        {
            taxNameLabel.text = "Tax (\(cartObjectData["taxStateName"]as? String ?? ""))"
        }
        
        totalLabel.text = (cartObjectData["Total"] as! NSNumber).doubleValue.currencyFormat
        
        var val = (cartObjectData["Total"] as! NSNumber).doubleValue
        
        if HomeVM.shared.tipValue > 0 {
            val = DataManager.duebalanceData ?? 0.0
        }
        if isOpenToOrderHistory {
            DataManager.duebalanceData = balanceDue
        }
        if DataManager.duebalanceData == val || DataManager.duebalanceData == 0.0 {
            print("enter value")
            isTotalChange = false
        } else {
            
            if val > DataManager.duebalanceData! {
                let datashow = val - DataManager.duebalanceData!
                
                dataNew = /*datashow +*/ balanceDue
                isTotalChange = true
                
                if balanceDue == 0.0 {
                    
                } else {
                    balanceDue = dataNew
                }
                print("data enter value \(datashow + balanceDue)")
            } else {
                let datashow = val - DataManager.duebalanceData!
                dataNew = datashow + balanceDue
                isTotalChange = true
                print("data enter value \(datashow + balanceDue)")
            }
        }
        
        if str_PaymentName == "CASH"{
            // MARK Hide for V5
            
            if balanceDue > 0{
                
                payButton.setTitle("Tender \(balanceDue.currencyFormat)", for: .normal)
                
                HomeVM.shared.DueShared = balanceDue
            }else{
                payButton.setTitle("Tender \(TotalPrice.currencyFormat)", for: .normal)
            }
            
        }else {
            
            //For Splite payment
            
            if balanceDue > 0{
                //payButton.setTitle("Tender \(HomeVM.shared.DueShared.currencyFormat)", for: .normal)
                if appDelegate.amount > 0 {
                    payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(appDelegate.amount.currencyFormat)", for: .normal)
                    
                }else{
                    payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(balanceDue.currencyFormat)", for: .normal)
                    
                }
                //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(balanceDue.currencyFormat)", for: .normal)
               // payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(balanceDue.currencyFormat)", for: .normal)
                //totalLabel.text = balanceDue.currencyFormat
                //HomeVM.shared.DueShared = balanceDue
                
            }else{
                //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \((cartObjectData["Total"] as! NSNumber).doubleValue.currencyFormat)", for: .normal)
                //payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \((cartObjectData["Total"] as! NSNumber).doubleValue.currencyFormat)", for: .normal)
                if appDelegate.amount > 0 {
                    payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(appDelegate.amount.currencyFormat)", for: .normal)
                    
                }else{
                    payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \((cartObjectData["Total"] as! NSNumber).doubleValue.currencyFormat)", for: .normal)
                    
                }
            }
            
        }
        
        // MARK Hide for V5
        
        if HomeVM.shared.DueShared > 0.0  {
            self.balanceDueView.isHidden = false
            self.labelBallanceDueAmt.isHidden = false
            self.labelBallanceDueAmt.text = HomeVM.shared.DueShared.currencyFormat
            totalLabel.text = HomeVM.shared.TotalDue.currencyFormat
            //multicardDelegate?.didUpdateTotal?(amount: val + 25.0, subToal: SubTotalPrice)
        }else {
            self.balanceDueView.isHidden = true
            self.labelBallanceDueAmt.isHidden = true
        }
        
        //For Splite payment
        
        if balanceDue > 0{
            //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(balanceDue.currencyFormat)", for: .normal)
            //payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(balanceDue.currencyFormat)", for: .normal)
            if appDelegate.amount > 0 {
                payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(appDelegate.amount.currencyFormat)", for: .normal)
                
            }else{
                payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(balanceDue.currencyFormat)", for: .normal)
                
            }
            //totalLabel.text = balanceDue.currencyFormat
        }else{
            //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \((cartObjectData["Total"] as! NSNumber).doubleValue.currencyFormat)", for: .normal)
            // payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \((cartObjectData["Total"] as! NSNumber).doubleValue.currencyFormat)", for: .normal)
            
            if appDelegate.amount > 0 {
                payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(appDelegate.amount.currencyFormat)", for: .normal)
                
            }else{
                payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \((cartObjectData["Total"] as! NSNumber).doubleValue.currencyFormat)", for: .normal)
                
            }
            
        }
        
        if HomeVM.shared.tipValue > 0 {
            
            if HomeVM.shared.multicardErrorResponse.count > 0 {
                //let status = HomeVM.shared.multicardErrorResponse["status"]
                
                //if
            }
            
            if balanceDue > HomeVM.shared.tipValue {
                
                let total =  (cartObjectData["Total"] as! NSNumber).doubleValue
                let amtTotal = total + HomeVM.shared.tipValue
                if HomeVM.shared.DueShared > amtTotal {
                    totalLabel.text = HomeVM.shared.TotalDue.currencyFormat
                    multicardDelegate?.didUpdateTotal?(amount: balanceDue, subToal: balanceDue)
                } else {
                    var amtTotal = 0.0
                    if HomeVM.shared.multicardErrorResponse.count > 0 {
                        //amtTotal = total + HomeVM.shared.MultiTipValue
                        amtTotal = total
                        multicardDelegate?.didUpdateTotal?(amount: amtTotal, subToal: amtTotal)
                    } else {
                        amtTotal = total
                        multicardDelegate?.didUpdateTotal?(amount: amtTotal, subToal: amtTotal)
                    }
                    let data = total + HomeVM.shared.tipValue
                    totalLabel.text = HomeVM.shared.TotalDue.currencyFormat
                }
            }
        } else {
            if HomeVM.shared.DueShared > 0.0  {
                balanceDue = HomeVM.shared.DueShared
                totalLabel.text = HomeVM.shared.TotalDue.currencyFormat
            }
        }
        
        self.taxType = cartObjectData["taxType"]as? String ?? ""
        let title = cartObjectData["taxStateName"]as? String ?? ""
        self.taxTitle = title == "" ? "Default" : title
        self.taxAmountValue = cartObjectData["taxAmountValue"]as? String ?? ""
        
        if isCreditCardNumberDetected {
            self.moveToCreditCardScreen()
            return
        }
        
        
        // devendra payment error to each and every time credit card page open
        if let dict = UserDefaults.standard.value(forKey: "SelectedCustomer") as? NSDictionary {
            let cardDetail = decode(dict: dict as! [String : Any])
            if let number = cardDetail.cardNumber , number.count == 4, (str_PaymentName == "" ||  str_PaymentName == "CREDIT" || str_PaymentName == "credit") {
                //self.moveToCreditCardScreen()
                //return
            }
        }
        
        self.moveToPreviousSavedScreen()
        if appDelegate.isOpenToOrderHistory {
            taxableAmtData = Double(str_TaxAmount) ?? 0.0
        }
        if appDelegate.isOpenToOrderHistory {
            self.addDiscountView.isHidden =  true
            addIconImageView.isHidden = true
            btnAddMoreProduct.isHidden = true
        }
        if isOpenToOrderHistory || DataManager.isBalanceDueData {
            btnAddMoreProduct.isHidden = true
        }
    }
    
    private func placeOrder()
    {
        
        // by sudama add sub
        isAddSubscription = false
        if self.cartProductsArray.count > 0 {
            for i in 0..<cartProductsArray.count {
                let addSubcriptionCheck = (cartProductsArray[i] as AnyObject).value(forKey: "addSubscription") as? Bool ?? false
                if addSubcriptionCheck {
                    isAddSubscription = true
                }
            }
        }
        print(isAddSubscription)
        //
        
        if(str_PaymentName != "")
        {
            var isGreenBtn = false
            
            if self.payButton.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
                isGreenBtn = true
            }
            self.payButton.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.payButton.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
                self.payButton.setTitleColor(.white, for: .normal)
            }
            if str_PaymentName == "CREDIT" || str_PaymentName == "credit"
            {
                if str_Auth == "AUTH"
                {
                    self.creditCardDelegate?.sendCreditCardData?(with: "auth", isIPad: true)
                }
                else
                {
                    self.creditCardDelegate?.sendCreditCardData?(with: "authcapture", isIPad: true)
                }
            }
            else if str_PaymentName == "CASH"
            {
                cashDelegate?.sendCashData?(isIPad: true)
            }
            else if str_PaymentName == "INVOICE"
            {
                invoiceDelegate?.sendInvoiceData?(isSaveInvoice: true, isIPad: true)
            }
            else if str_PaymentName == "ACH CHECK"
            {
                achCheckDelegate?.sendACHCheckData?(isIPad: true)
            }
            else if str_PaymentName == "GIFT CARD"
            {
                giftCardDelegate?.sendGiftCardData?(isIPad: true)
            }
            else if str_PaymentName == "EXTERNAL GIFT CARD"
            {
                externalGiftCardDelegate?.sendExternalGiftCardData?(isIPad: true)
            }
            else if str_PaymentName == "INTERNAL GIFT CARD"
            {
                internalGiftCardDelegate?.sendInternalGiftCardData?(isIPad: true)
            }
            else if str_PaymentName == "CHECK"
            {
                checkDelegate?.sendCheckData?(isIPad: true)
            }
            else if str_PaymentName == "EXTERNAL"
            {
                externalCardDelegate?.sendExternalCardData?(isIPad: true)
            }
            else if str_PaymentName == "PAX PAY"
            {
                paxDelegate?.sendPAXData?(with: "authcapture", isIPad: true)
            }
            else if str_PaymentName == "MULTI CARD"
            {
                multicardDelegate?.sendMulticardData?(isIPad: true)
            }
            else if str_PaymentName == "NOTES"
            {
                notesDelegate?.sendNotesData?(isIPad: true)
            }
            else if str_PaymentName == "CARD READER"
            {
                self.ingenicoDelegate?.sendIngenicoCardData?(with: "authcapture", isIPad: true, data: IngenicoDataResponce)
            }
        }
        else
        {
            //            self.showAlert(message: "Please select a payment method.")
            appDelegate.showToast(message: "Please select a payment method.")
            print("data send kkk")
        }
    }
    
    private func savePaymentData() {
        PaymentsViewController.paymentDetailDict.removeAll()
        PaymentsViewController.paymentDetailDict["key"] = str_PaymentName
        switch str_PaymentName {
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
    
    private func showApplyCouponIPad() {
        
        let alert = UIAlertController(title: "Apply Coupon", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .asciiCapable
            textField.text = self.str_AddCouponName
            textField.tag = 4000
            textField.delegate = self
            textField.placeholder = "Please enter coupon code"
            textField.selectAll(nil)
            
            if DataManager.isCouponList {
                let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
                let iconView  = UIImageView(frame: CGRect(x: 25, y: 7, width: 10, height: 7))
                iconView.image = UIImage(named: "dropdown-arrow")
                outerView.isUserInteractionEnabled = true
                iconView.isUserInteractionEnabled = true
                outerView.addSubview(iconView)
                
                textField.rightView = outerView
                textField.rightViewMode = .always
                
                let array = HomeVM.shared.coupanList.compactMap({$0.str_coupon_code})
                if array.count > 0 {
                    self.pickerDelegate = self
                    textField.text = array.first
                    self.setPickerView(textField: textField, array: array)
                }
            }
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.handleApplyCoupon(textField: textField)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.visualEffectView.removeFromSuperview()
        }))
        self.addBlurView()
        self.present(alert, animated: true, completion: nil)
    }
    
    private func handleDiscount(textField: UITextField) {
        
        self.visualEffectView.removeFromSuperview()
        if self.isPercentageDiscountApplied {
            self.str_AddDiscountPercent = (textField.text ?? "").replacingOccurrences(of: "$", with: "")
            //var discount = Double(self.str_AddDiscountPercent) ?? 0.00
        } else {
            self.str_AddDiscount = (textField.text ?? "").replacingOccurrences(of: "$", with: "")
            //var discount = Double(self.str_AddDiscount) ?? 0.00
        }
        
        var discount = self.isPercentageDiscountApplied ? (Double(self.str_AddDiscountPercent) ?? 0.0) : (Double(self.str_AddDiscount) ?? 0.0)
        
        let subTotal = self.SubTotalPrice.currencyFormatA
        let stringToDoublTotal = Double(subTotal) ?? 0.00
        
        if self.isPercentageDiscountApplied {
            discount = (discount / 100) * stringToDoublTotal
            discount = discount < 0 ? 0 : discount
        }
        self.str_AddDiscount = "\(discount)"
        
        if !self.isPercentageDiscountApplied {
            discount = (100 * discount) / stringToDoublTotal
            discount = discount < 0 ? 0 : discount
            self.str_AddDiscountPercent = "\(discount)"
        }
        
        self.discountLabel.text = discount.currencyFormat
        self.delegate?.didUpdateManualDiscount?(amount: discount, isPercentage: self.isPercentageDiscountApplied)
        self.calculateTotalCart()
    }
    
    private func handleApplyCoupon(textField: UITextField) {
        self.visualEffectView.removeFromSuperview()
        self.str_AddCouponName = (textField.text)!
        self.couponNameLabel.text = self.str_AddCouponName
        if (self.str_AddCouponName.count>0) {
            //New Coupon Applied
            self.callAPItoGetCoupanProductIds(coupan: self.str_AddCouponName)
        }else {
            self.resetCoupan()
        }
    }
    
    private func moveToPreviousSavedScreen() {
        
        if DataManager.isAuthentication {
            if DataManager.isBalanceDueData {
                self.authButton.isHidden = true
                
            } else {
                self.authButton.isHidden = !((str_PaymentName == "CREDIT") ||  (str_PaymentName == "PAX PAY"))
                
            }
        }else {
            self.authButton.isHidden = true
        }
        
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key != "" {
            didSelectPaymentMethod(with: key)
            return
        }
        
        if appDelegate.IS_DEFAULT_PAYMENT_FUNCTIONLITY {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if appDelegate.isVoidPayment == false {
                    if DataManager.SavedPaymentArray != nil {
                        
                        var valueone = DataManager.SavedPaymentArray
                        print(valueone as Any)
                        
                        for i in 0..<valueone!.count {
                            let id = valueone![i]["userId"] as? String
                            print(id as Any)
                            
                            let url = valueone![i]["baseUrl"] as? String
                            print(url as Any)
                            
                            var type = valueone![i]["paymentMethod"] as? String
                            print(type as Any)
                            
                            if type == "multi_card" {
                                type = "MULTI CARD"
                            }
                            
                            if type == "external_gift" {
                                type = "EXTERNAL GIFT CARD"
                            }
                            if type == "internal_gift" {
                                type = "INTERNAL GIFT CARD"
                            }
                            if type == "ach_check" {
                                type = "ACH CHECK"
                            }
                            
                            if (id == DataManager.appUserID) && (url == DataManager.loginBaseUrl) {
                                self.didSelectPaymentMethod(with: type!.localizedUppercase)
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    private func handleShippingAndHandling(textField: UITextField) {
        self.str_ShippingANdHandling = (textField.text)!
        self.str_ShippingANdHandling = self.str_ShippingANdHandling.replacingOccurrences(of: "$", with: "")
        let shipping = Double(self.str_ShippingANdHandling) ?? 0.00
        // -----Start---- //
        // Thia code done by sudama for shipping 0 set when privious value is geter then 0
        if shipping == 0 || shipping == 0.00 {
            shippingRefundButton.isSelected = false
            DataManager.isshipOrderButton = shippingRefundButton.isSelected
        }
        // -----End---- //
        self.shippingLabel.text = shipping.currencyFormat
        self.isShippingPriceChanged = true
        self.visualEffectView.removeFromSuperview()
        self.delegate?.didUpdateShipping?(amount: Double(self.str_ShippingANdHandling) ?? 0)
        self.calculateTotalCart()
    }
    
    private func handleShippingAddRate(shiipingRate: String){
        self.str_ShippingANdHandling = shiipingRate
        self.str_ShippingANdHandling = self.str_ShippingANdHandling.replacingOccurrences(of: "$", with: "")
        let shipping = Double(self.str_ShippingANdHandling) ?? 0.00
        self.shippingLabel.text = shipping.currencyFormat
        self.isShippingPriceChanged = true
        self.visualEffectView.removeFromSuperview()
        self.delegate?.didUpdateShipping?(amount: Double(self.str_ShippingANdHandling) ?? 0)
        self.calculateTotalCart()
        
    }
    
    private func handleAddDiscountAction() {
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        let alert = UIAlertController(title: "Discount", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.keyboardType = .decimalPad
            
            let manualDiscount = self.isPercentageDiscountApplied ? (Double(self.str_AddDiscountPercent) ?? 0.0) : (Double(self.str_AddDiscount) ?? 0.0)
            
            textField.text = manualDiscount == 0 ? "" : manualDiscount.roundToTwoDecimal
            textField.placeholder = self.isPercentageDiscountApplied ? "Please enter discount amount (%)" : "Please enter discount amount"
            textField.tag = 3000
            if !self.isPercentageDiscountApplied {
                textField.setDollar(color: UIColor.darkGray, font: textField.font!)
            }
            textField.selectAll(nil)
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.handleDiscount(textField: textField)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.visualEffectView.removeFromSuperview()
            
        }))
        self.addBlurView()
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func CancelActionData() {
        DispatchQueue.main.async {
            
            //            if HomeVM.shared.tipValue > 0 {
            //
            //                if HomeVM.shared.multicardErrorResponse.count > 0 {
            //                    HomeVM.shared.DueShared = HomeVM.shared.DueShared
            //                    HomeVM.shared.tipValue = 0.00
            //                    HomeVM.shared.MultiTipValue = 0.00
            //                } else {
            //                    if DataManager.isPartialAprrov {
            //                        HomeVM.shared.DueShared = HomeVM.shared.DueShared
            //                    } else {
            //                        HomeVM.shared.DueShared = self.finalTotalSend - HomeVM.shared.tipValue
            //                        HomeVM.shared.tipValue = 0.00
            //                        HomeVM.shared.MultiTipValue = 0.00
            //                        self.tipLabel.text = "$0.00"
            //                    }
            //                }
            //                self.balanceDue = HomeVM.shared.DueShared
            //                //HomeVM.shared.DueShared = HomeVM.shared.DueShared - HomeVM.shared.tipValue
            //
            //                DataManager.cartData!["tipAmount_due"] = HomeVM.shared.tipValue
            //                DataManager.cartData!["MultiTipAmount_due"] = HomeVM.shared.MultiTipValue
            //                DataManager.cartData!["balance_due"] = HomeVM.shared.DueShared
            //
            //                self.tipAmountDue = HomeVM.shared.tipValue
            //                self.MultiTipAmountDue = HomeVM.shared.MultiTipValue
            //            } else {
            //                self.tipLabel.text = "$0.00"
            //            }
            
            self.str_PaymentName = ""
            //appDelegate.strPaymentType = ""
            if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
                //appDelegate.strPaymentType =
                if DataManager.selectedPayment?.contains("CARD READER") ?? false {
                    if !self.getIsDeviceConnected() {
                        appDelegate.strPaymentType = ""
                    }
                }
            }else{
                appDelegate.strPaymentType = ""
            }
            self.depositeAmountLabel.text = "$0.00"
            //Reset Data
            self.creditCardDelegate?.reset?()
            self.cashDelegate?.reset?()
            self.invoiceDelegate?.reset?()
            self.achCheckDelegate?.reset?()
            self.giftCardDelegate?.reset?()
            self.externalGiftCardDelegate?.reset?()
            self.internalGiftCardDelegate?.reset?()
            self.multicardDelegate?.reset?()
            self.checkDelegate?.reset?()
            self.externalCardDelegate?.reset?()
            self.paxDelegate?.reset?()
            self.notesDelegate?.reset?()
            //Remove Payment Data
            PaymentsViewController.paymentDetailDict.removeAll()
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
            //Enable Card Reader
            self.paymentTypeViewDelegate?.enableCardReaders?()
            self.creditCardDelegate?.disableCardReader?()
            self.giftCardDelegate?.disableCardReader?()
            self.externalGiftCardDelegate?.disableCardReader?()
            self.internalGiftCardDelegate?.disableCardReader?()
            self.multicardDelegate?.disableCardReader?()
            self.invoiceDelegate?.disableCardReader?()
            //Update Payment Label
            self.lbl_PaymentMethodName.text = "Payment Method"
            self.btn_Cancel.isHidden = true
            //Hide All Container & Enable Swipe Reader
            self.add(childVC: self.paymentTypeContainer)
            SwipeAndSearchVC.shared.enableTextField()
            
            
            self.tipView.isHidden = self.tipLabel.text == "$0.00"
            self.updateLabels(isUpdateTotal: false)
            self.calculateTotal()
            self.payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            self.authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            
        }
    }
    
    //MARK: IBActions
    @IBAction func applyCouponButtonAction(_ sender: Any) {
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        if isOpenToOrderHistory {
            return
        }
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        self.showApplyCouponIPad()
    }
    
    @IBAction func applyDiscountButtonAction(_ sender: Any) {
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        if isOpenToOrderHistory {
            return
        }
        self.isPercentageDiscountApplied = false
        self.handleAddDiscountAction()
    }
    
    @IBAction func applyDepositeAmountButtonAction(_ sender: Any) {
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        if isOpenToOrderHistory {
            return
        }
        let alert = UIAlertController(title: "Deposit Amount", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.keyboardType = .decimalPad
            
            let amount  = Double(self.depositeAmountLabel.text!.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: " ", with: "")) ?? 0
            
            textField.text = amount == 0 ? "" : amount.roundToTwoDecimal
            textField.placeholder = "Please enter amount ($)"
            textField.tag = 6000
            textField.selectAll(nil)
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            let depositeAmount = Double(textField.text ?? "") ?? 0
            self.visualEffectView.removeFromSuperview()
            self.depositeAmountLabel.text = depositeAmount.currencyFormat
            self.calculateTotalCart()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.visualEffectView.removeFromSuperview()
            
        }))
        self.addBlurView()
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func removeCoupanAction(_ sender: Any) {
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        if isOpenToOrderHistory {
            return
        }
        self.view.endEditing(true)
        str_AddCouponName = ""
        couponNameLabel.text = "Apply Coupon"
        str_CouponDiscount = ""
        isCoupanApplyOnAllProducts = false
        taxableCouponTotal = 0.0
        crossButton.isHidden = true
        HomeVM.shared.coupanDetail.code = ""
        self.delegate?.didUpdateCoupon?(name: "", amount: 0)
        self.calculateTotalCart()
    }
    
    @IBAction func addmoreProductButtonAction(_ sender: Any) {
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        if isOpenToOrderHistory {
            return
        }
        if selectedViewController == addCustomerContainer && !iPadSelectCustomerViewController.isSelectCustomerOpen {
            //            self.showAlert(message: "Please first save the customer information.")
            appDelegate.showToast(message: "Please first save the customer information.")
            return
        }
        
        if HomeVM.shared.tipValue > 0 {
            
            if HomeVM.shared.DueShared == finalTotalSend {
                DataManager.tempBalanceDuedata = 0.0
            } else if HomeVM.shared.DueShared > HomeVM.shared.TotalDue {
                DataManager.tempBalanceDuedata = HomeVM.shared.TotalDue - HomeVM.shared.DueShared
            } else if HomeVM.shared.DueShared < HomeVM.shared.TotalDue {
                DataManager.tempBalanceDuedata = finalTotalSend - HomeVM.shared.DueShared
            }
            
            print(DataManager.tempBalanceDuedata)
            
            if HomeVM.shared.multicardErrorResponse.count > 0 {
                HomeVM.shared.DueShared = HomeVM.shared.DueShared
                //HomeVM.shared.tipValue = 0.00
                // HomeVM.shared.MultiTipValue = 0.00
            } else {
                if DataManager.isPartialAprrov {
                    HomeVM.shared.DueShared = HomeVM.shared.DueShared
                } else {
                    //HomeVM.shared.DueShared = HomeVM.shared.TotalDue - HomeVM.shared.tipValue
                    //HomeVM.shared.tipValue = 0.00
                    //HomeVM.shared.MultiTipValue = 0.00
                    //self.tipLabel.text = "$0.00"
                }
            }
            self.balanceDue = HomeVM.shared.DueShared
            //HomeVM.shared.DueShared = HomeVM.shared.DueShared - HomeVM.shared.tipValue
            
            DataManager.cartData!["tipAmount_due"] = HomeVM.shared.tipValue
            DataManager.cartData!["MultiTipAmount_due"] = HomeVM.shared.MultiTipValue
            DataManager.cartData!["balance_due"] = HomeVM.shared.DueShared
            
            self.tipAmountDue = HomeVM.shared.tipValue
            self.MultiTipAmountDue = HomeVM.shared.MultiTipValue
        }
        savePaymentData()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func applyShippingCalculateAction(_ sender: Any) {
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        if orderType == .refundOrExchangeOrder {
            return
        }
        if isOpenToOrderHistory {
            return
        }
        // if CustomerObj.str_address != "" && CustomerObj.str_city != ""  && CustomerObj.str_region != "" && CustomerObj.str_postal_code != "" && CustomerObj.country != "" {
        if DataManager.showShippingCalculatiosInPos == "true" {
            if Int(DataManager.appVersion)! < 4 {
                //Devd
            }else{
                self.delegateEditProduct?.didShowShippingAddress?(data: CustomerObj)
                self.delegateEditProduct?.getCartProductsArray?(data:cartProductsArray)
                setView(view: shippingContainer, hidden: false)
            }
        }
        //        } else {
        //            self.showAlert(message: "Please enter Customer address.")
        //        }
    }
    
    @IBAction func applyShippingButtonAction(_ sender: Any) {
        
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        //if CustomerObj.str_address != "" && CustomerObj.str_city != ""  && CustomerObj.str_region != "" && CustomerObj.str_postal_code != "" && CustomerObj.country != "" {
        if orderType == .refundOrExchangeOrder {
            return
        }
        if isOpenToOrderHistory {
            return
        }
        self.view.endEditing(true)
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        let alert = UIAlertController(title: "Shipping & Handling", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.keyboardType = .decimalPad
            textField.tag = 2000
            self.str_ShippingANdHandling = self.str_ShippingANdHandling.replacingOccurrences(of: ".00", with: "")
            self.str_ShippingANdHandling = self.str_ShippingANdHandling.replacingOccurrences(of: ".0", with: "")
            textField.placeholder = self.isPercentageDiscountApplied ? "Please enter Manual Shipping (%)" : "Please enter Manual Shipping ($)"
            
            if !self.isPercentageDiscountApplied {
                textField.setDollar(color: UIColor.darkGray, font: textField.font!)
            }
            textField.text = self.str_ShippingANdHandling == "0.0" ? "" : self.str_ShippingANdHandling
            textField.selectAll(nil)
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.handleShippingAndHandling(textField: textField)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.visualEffectView.removeFromSuperview()
            
        }))
        self.addBlurView()
        self.present(alert, animated: true, completion: nil)
        //        } else {
        //            self.showAlert(message: "Please enter Customer address.")
        //        }
    }
    
    
    @IBAction func addCustomerButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if isOpenToOrderHistory {
            return
        }
        addCustomerView.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.addCustomerView.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        if orderType == .refundOrExchangeOrder {
            return
        }
        //        DataManager.CardCount = 0
        //        DataManager.Bbpid = ""
        //        DataManager.customerId = ""
        DataManager.isPaymentBtnAddCustomer = false
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        
        SwipeAndSearchVC.shared.enableTextField()
        
        self.add(childVC: addCustomerContainer)
        
        self.customerDelegate?.didSelectAddCustomerButton?()
        self.customerDelegate?.didSelectCustomer?(data: CustomerObj)
    }
    
    @IBAction func addDiscountViewButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        if isOpenToOrderHistory {
            return
        }
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddDiscountPopupVC") as! AddDiscountPopupVC
        vc.delegate = self
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.preferredContentSize = CGSize(width: addDiscountView.frame.width, height: 85)
        controller = vc
        
        let popController = vc.popoverPresentationController
        popController?.permittedArrowDirections = .down
        popController?.backgroundColor = UIColor.white
        popController?.delegate = self
        popController?.sourceRect = CGRect(x: 0, y: -5 , width: addDiscountView.frame.width , height: 85)
        popController?.sourceView =  sender
        self.present(vc, animated: true, completion: {
            vc.view.superview?.layer.cornerRadius = 5
        })
        
    }
    
    @IBAction func btn_BackAction(_ sender: Any)
    {
        appDelegate.isOpenUrl = false
        appDelegate.openUrlCardReaderAmmount = ""
        appDelegate.isOpenToOrderHistory = false
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        
        if selectedViewController == addCustomerContainer && !iPadSelectCustomerViewController.isSelectCustomerOpen {
            //            self.showAlert(message: "Please first save the customer information.")
            appDelegate.showToast(message: "Please first save the customer information.")
            return
        }
        appDelegate.isVoidPayment = false
        savePaymentData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_HomeAction(_ sender: Any) {
        appDelegate.isOpenUrl = false
        appDelegate.openUrlCardReaderAmmount = ""
        appDelegate.isOpenToOrderHistory = false
        if DataManager.isBalanceDueData {
            
            // let refreshAlert = UIAlertController(title: "Alert", message: "Incomplete Split Payment,\n if continue then all data will be reset.", preferredStyle: UIAlertControllerStyle.alert)
            var strId = 0
            if let id = DataManager.recentOrderID {
                strId = id
            }
            
            let refreshAlert = UIAlertController(title: "Cancel Order", message: "Navigating away from this order will \nleave the existing order #\(strId) \nwith total paid: \(HomeVM.shared.amountPaid.currencyFormat) you can \nreview and refund these \ncharges from Past Orders.", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                //...
            }))
            refreshAlert.addAction(UIAlertAction(title: "Proceed", style: .destructive, handler: { (action: UIAlertAction!) in
                self.isDefaultTaxChanged = false
                self.isDefaultTaxSelected = false
                self.taxTitle = DataManager.defaultTaxID
                DataManager.isBalanceDueData = false
                HomeVM.shared.errorTip = 0.0
                HomeVM.shared.tipValue = 0.0
                appDelegate.localBezierPath.removeAllPoints()
                appDelegate.amount = 0.0
                PaymentsViewController.paymentDetailDict.removeAll()
                self.resetCartData()
                self.delegate?.didupdateOrderHistoryInfo?()
            }))
            present(refreshAlert, animated: true, completion: nil)
            
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        if isOpenToOrderHistory{
            DataManager.customerId = ""
            self.isDefaultTaxChanged = false
            self.isDefaultTaxSelected = false
            self.taxTitle = DataManager.defaultTaxID
            DataManager.isBalanceDueData = false
            HomeVM.shared.errorTip = 0.0
            HomeVM.shared.tipValue = 0.0
            appDelegate.localBezierPath.removeAllPoints()
            appDelegate.amount = 0.0
            PaymentsViewController.paymentDetailDict.removeAll()
            self.resetCartData()
            self.delegate?.didupdateOrderHistoryInfo?()
            UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
            return
        }
        if selectedViewController == addCustomerContainer && !iPadSelectCustomerViewController.isSelectCustomerOpen {
            //            self.showAlert(message: "Please first save the customer information.")
            appDelegate.showToast(message: "Please first save the customer information.")
            return
        }
        if HomeVM.shared.tipValue > 0 {
            
            if HomeVM.shared.multicardErrorResponse.count > 0 {
                HomeVM.shared.DueShared = HomeVM.shared.DueShared
                HomeVM.shared.tipValue = 0.00
                HomeVM.shared.MultiTipValue = 0.00
            } else {
                if DataManager.isPartialAprrov {
                    HomeVM.shared.DueShared = HomeVM.shared.DueShared
                } else {
                    HomeVM.shared.DueShared = HomeVM.shared.TotalDue - HomeVM.shared.tipValue
                    HomeVM.shared.tipValue = 0.00
                    HomeVM.shared.MultiTipValue = 0.00
                    self.tipLabel.text = "$0.00"
                }
            }
            self.balanceDue = HomeVM.shared.DueShared
            //HomeVM.shared.DueShared = HomeVM.shared.DueShared - HomeVM.shared.tipValue
            
            DataManager.cartData!["tipAmount_due"] = HomeVM.shared.tipValue
            DataManager.cartData!["MultiTipAmount_due"] = HomeVM.shared.MultiTipValue
            DataManager.cartData!["balance_due"] = HomeVM.shared.DueShared
            
            self.tipAmountDue = HomeVM.shared.tipValue
            self.MultiTipAmountDue = HomeVM.shared.MultiTipValue
        }
        savePaymentData()
        
        DispatchQueue.main.async {
            if self.orderType == .newOrder {
                self.navigationController?.popViewController(animated: true)
            }else {
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController")
                appDelegate.window?.rootViewController = vc
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func btn_LogOutAction(_ sender: Any) {
        appDelegate.isOpenUrl = false
        appDelegate.openUrlCardReaderAmmount = ""
        appDelegate.isOpenToOrderHistory = false
        alertForLogOut()
    }
    
    @IBAction func btn_LockAction(_ sender: Any) {
        //...
        appDelegate.isOpenUrl = false
        appDelegate.openUrlCardReaderAmmount = ""
        appDelegate.isOpenToOrderHistory = false
        if DataManager.isBalanceDueData {
            
            // let refreshAlert = UIAlertController(title: "Alert", message: "Incomplete Split Payment,\n if continue then all data will be reset.", preferredStyle: UIAlertControllerStyle.alert)
            var strId = 0
            if let id = DataManager.recentOrderID {
                strId = id
            }
            
            let refreshAlert = UIAlertController(title: "Cancel Order", message: "Navigating away from this order will \nleave the existing order #\(strId) \nwith total paid: \(HomeVM.shared.amountPaid.currencyFormat) you can \nreview and refund these \ncharges from Past Orders.", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                //...
            }))
            refreshAlert.addAction(UIAlertAction(title: "Proceed", style: .destructive, handler: { (action: UIAlertAction!) in
                self.isDefaultTaxChanged = false
                self.isDefaultTaxSelected = false
                self.taxTitle = DataManager.defaultTaxID
                DataManager.isBalanceDueData = false
                HomeVM.shared.errorTip = 0.0
                HomeVM.shared.tipValue = 0.0
                appDelegate.localBezierPath.removeAllPoints()
                appDelegate.amount = 0.0
                PaymentsViewController.paymentDetailDict.removeAll()
                self.resetCartData()
                self.delegate?.didupdateOrderHistoryInfo?()
            }))
            present(refreshAlert, animated: true, completion: nil)
            
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        let vc = UIStoryboard(name: "iPad", bundle: nil).instantiateViewController(withIdentifier: "iPad_AccessPINViewController") as! iPad_AccessPINViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btn_AuthAction(_ sender: Any) {
        //Prevent to place multiple order
        str_Auth = "AUTH"
        if isOderPlaced {
            return
        }
        if str_PaymentName == "PAX PAY" {
            appDelegate.strPaxMode = "GIFT"
        }
        isOderPlaced = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isOderPlaced = false
        }
        //Place Order
        if selectedViewController == addCustomerContainer {
            //            self.showAlert(message: "Please first save the customer information.")
            appDelegate.showToast(message: "Please first save the customer information.")
            return
        }
        
        isPayButtonSelected = true
        self.idleChargeButton()
        
        if str_PaymentName == "INVOICE" {
            invoiceDelegate?.sendInvoiceData?(isSaveInvoice: true, isIPad: true)
            return
        }
        var isGreenBtn = false
        
        if self.authButton.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        self.authButton.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.authButton.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
            self.authButton.setTitleColor(.white, for: .normal)
        }
        if str_PaymentName == "CREDIT" || str_PaymentName == "credit" {
            self.creditCardDelegate?.sendCreditCardData?(with: "auth", isIPad: true)
        }else { //PAX
            self.paxDelegate?.sendPAXData?(with: "auth", isIPad: true)
        }
    }
    
    @IBAction func btn_CancelAction(_ sender: Any) {
        DispatchQueue.main.async {
            appDelegate.strPaxMode = ""
            DataManager.errorOccure = false
            if DataManager.isBalanceDueData == false && self.isOpenToOrderHistory == false{
                if HomeVM.shared.tipValue > 0 {
                    
                    if HomeVM.shared.multicardErrorResponse.count > 0 {
                        HomeVM.shared.DueShared = HomeVM.shared.DueShared
                        HomeVM.shared.tipValue = 0.00
                        HomeVM.shared.MultiTipValue = 0.00
                    } else {
                        if DataManager.isPartialAprrov {
                            HomeVM.shared.DueShared = HomeVM.shared.DueShared
                        } else {
                            if self.str_PaymentName == "CARD READER" {
                                HomeVM.shared.DueShared = self.finalTotalSend //- HomeVM.shared.tipValue
                            } else {
                                HomeVM.shared.DueShared = self.finalTotalSend - HomeVM.shared.tipValue
                            }
                            HomeVM.shared.tipValue = 0.00
                            HomeVM.shared.MultiTipValue = 0.00
                            self.tipLabel.text = "$0.00"
                        }
                    }
                    self.balanceDue = HomeVM.shared.DueShared
                    //HomeVM.shared.DueShared = HomeVM.shared.DueShared - HomeVM.shared.tipValue
                    
                    DataManager.cartData!["tipAmount_due"] = HomeVM.shared.tipValue
                    DataManager.cartData!["MultiTipAmount_due"] = HomeVM.shared.MultiTipValue
                    DataManager.cartData!["balance_due"] = HomeVM.shared.DueShared
                    
                    self.tipAmountDue = HomeVM.shared.tipValue
                    self.MultiTipAmountDue = HomeVM.shared.MultiTipValue
                } else {
                    self.tipLabel.text = "$0.00"
                }
            }
            HomeVM.shared.errorTip = 0.0
            appDelegate.localBezierPath.removeAllPoints()
            appDelegate.amount = 0.0
//           if self.isOpenToOrderHistory == false {
//                HomeVM.shared.tipValue = 0.0
//            }
            self.str_PaymentName = ""
            appDelegate.strPaymentType = ""
            self.depositeAmountLabel.text = "$0.00"
            //Reset Data
            self.creditCardDelegate?.reset?()
            self.cashDelegate?.reset?()
            self.invoiceDelegate?.reset?()
            self.achCheckDelegate?.reset?()
            self.giftCardDelegate?.reset?()
            self.externalGiftCardDelegate?.reset?()
            self.internalGiftCardDelegate?.reset?()
            self.multicardDelegate?.reset?()
            self.checkDelegate?.reset?()
            self.externalCardDelegate?.reset?()
            self.paxDelegate?.reset?()
            self.notesDelegate?.reset?()
            //Remove Payment Data
            PaymentsViewController.paymentDetailDict.removeAll()
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
            //Enable Card Reader
            self.paymentTypeViewDelegate?.enableCardReaders?()
            self.creditCardDelegate?.disableCardReader?()
            self.giftCardDelegate?.disableCardReader?()
            self.externalGiftCardDelegate?.disableCardReader?()
            self.internalGiftCardDelegate?.disableCardReader?()
            self.multicardDelegate?.disableCardReader?()
            self.invoiceDelegate?.disableCardReader?()
            //Update Payment Label
            self.lbl_PaymentMethodName.text = "Payment Method"
            self.btn_Cancel.isHidden = true
            //Hide All Container & Enable Swipe Reader
            self.add(childVC: self.paymentTypeContainer)
            SwipeAndSearchVC.shared.enableTextField()
            
            
            self.tipView.isHidden = self.tipLabel.text == "$0.00"
            self.updateLabels(isUpdateTotal: false)
            self.calculateTotal()
            self.payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            self.authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            if DataManager.isSplitPayment {
                self.balanceDueRemaining(with: 0.0)
            }
            
            //            if str_PaymentName == "CASH"{
            //                payButton.setTitle("Tender \(amount.currencyFormat)", for: .normal)
            //            } else {
            //                self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Done" : "Charge \(amount.currencyFormat)", for: .normal)
            //            }
            
        }
    }
    
    func cardReaderFunctionCallPlaceOrder() {
        
        //            ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
        //                                apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
        //                                clientVersion: ClientVersion)
        //
        //            //if communicationSegment.selectedSegmentIndex == 1 {
        //               // doSearching()
        //
        //            self.ingenico.paymentDevice.setDeviceType(RUADeviceTypeRP45BT)
        //
        //            self.ingenico.paymentDevice.search(self)
        //
        //            ingenico = Ingenico.sharedInstance()
        //            ingenico.setLogging(true)
        //            ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
        //                                apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
        //                                clientVersion: ClientVersion)
        //
        //
        //            loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password, islogin: true)
        
        
        //            ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
        //                                apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
        //                                clientVersion: ClientVersion)
        //
        //            //if communicationSegment.selectedSegmentIndex == 1 {
        //               // doSearching()
        //
        //            self.ingenico.paymentDevice.setDeviceType(RUADeviceTypeRP45BT)
        //
        //            self.ingenico.paymentDevice.search(self)
        
        if ((DataManager.signature && DataManager.isSingatureOnEMV) && !DataManager.collectTips) || (HomeVM.shared.DueShared > 0 && (DataManager.signature && DataManager.isSingatureOnEMV)) || (HomeVM.shared.DueShared > 0 && !DataManager.signature && DataManager.collectTips) {
            
            if str_PaymentName == "CARD READER" || str_PaymentName == "card reader" {
                if ((DataManager.signature && DataManager.isSingatureOnEMV)){
                    if DataManager.collectTips || DataManager.signature {
                        if str_PaymentName == "PAX PAY" || str_PaymentName == "pax pay" || str_PaymentName == "pax_pay" {
                            
                        } else {
                            var arrcard = NSMutableArray()
                            //if HomeVM.shared.DueShared > 0 {
                            //appDelegate.CardReaderAmount = HomeVM.shared.DueShared
                            //}
                            let datavalue = ["card_number": "Ingenico",
                                             "txn_id": "1",
                                             "total": "\(SubTotalPrice)",
                                             "TotalAmount": "\(appDelegate.CardReaderAmount)",
                                             "tipAmount": "\(HomeVM.shared.errorTip)"]
                            
                            arrcard.add(datavalue)
                            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                                MainSocketManager.shared.onOpenSignature(signArry: arrcard, subTotal: appDelegate.CardReaderAmount ?? 0.00, total: appDelegate.CardReaderAmount ?? 0.00, paxLoader:  true)
                                //main chnages right sudama for socket
                            }
                            
                            if appDelegate.strIngenicoAmount != "" {
                                sendSignatureScreen(arrcardData: arrcard)
                            } else {
                                updateError(textfieldIndex: 1, message: "Please enter amount")
                            }
                            //sendSignatureScreen(arrcardData: arrcard)
                        }
                    } else {
                        ingenicoStartOnClick()
                        //promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
                    }
                } else {
                    if DataManager.collectTips || DataManager.signature {
                        if str_PaymentName == "PAX PAY" || str_PaymentName == "pax pay" || str_PaymentName == "pax_pay" {
                            
                        } else {
                            var arrcard = NSMutableArray()
                            //if HomeVM.shared.DueShared > 0 {
                            //appDelegate.CardReaderAmount = HomeVM.shared.DueShared
                            //}
                            let datavalue = ["card_number": "Ingenico",
                                             "txn_id": "1",
                                             "total": "\(SubTotalPrice)",
                                             "TotalAmount": "\(appDelegate.CardReaderAmount)",
                                             "tipAmount": "\(HomeVM.shared.errorTip)"]
                            
                            arrcard.add(datavalue)
                            
                            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                                MainSocketManager.shared.onOpenSignature(signArry: arrcard, subTotal: appDelegate.CardReaderAmount ?? 0.00, total: appDelegate.CardReaderAmount ?? 0.00, paxLoader:  true)
                                //main chnages right sudama for socket
                            }
                            if appDelegate.strIngenicoAmount != "" {
                                sendSignatureScreen(arrcardData: arrcard)
                            } else {
                                updateError(textfieldIndex: 1, message: "Please enter amount")
                            }
                            //sendSignatureScreen(arrcardData: arrcard)
                        }
                    } else {
                        ingenicoStartOnClick()
                        //promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
                    }
                    //ingenicoStartOnClick()
                    //promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
                }
            } else {
                ingenicoStartOnClick()
                //promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
            }
            
        } else {
            if DataManager.collectTips || DataManager.signature {
                if str_PaymentName == "PAX PAY" || str_PaymentName == "pax pay" || str_PaymentName == "pax_pay" {
                    
                } else {
                    var arrcard = NSMutableArray()
                    
                    //if HomeVM.shared.DueShared > 0 {
                    //appDelegate.CardReaderAmount = HomeVM.shared.DueShared
                    //}
                    let datavalue = ["card_number": "Ingenico",
                                     "txn_id": "1",
                                     "total": "\(SubTotalPrice)",
                                     "TotalAmount": "\(appDelegate.CardReaderAmount)",
                                     "tipAmount": "\(HomeVM.shared.errorTip)"]
                    
                    arrcard.add(datavalue)
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        MainSocketManager.shared.onOpenSignature(signArry: arrcard, subTotal: appDelegate.CardReaderAmount ?? 0.00, total: appDelegate.CardReaderAmount ?? 0.00, paxLoader:  true)
                        //main chnages right sudama for socket
                    }
                    
                    if appDelegate.strIngenicoAmount != "" {
                        sendSignatureScreen(arrcardData: arrcard)
                    } else {
                        updateError(textfieldIndex: 1, message: "Please enter amount")
                    }
                    
                }
            } else {
                ingenicoStartOnClick()
                //promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
            }
        }
    }
    
    func refreshUserSession(islogin:Bool) {
        //self.showProgressMessage("Refreshing User Session...")
        Ingenico.sharedInstance()?.user.refreshUserSession({ (userprofile, error) in
            //self.dismissProgress()
            if error == nil {
                //self.showSucess( "refreshUserSession Succeeded")
                self.consoleLog("refreshUserSession Succeeded")
                self.consoleLog("userprofile : \(userprofile?.description ?? "")")
                
                //self.Alert(mesaage: userprofile?.session.sessionToken ?? "")
                //self.Alert(mesaage: userprofile.debugDescription)
                
                if islogin {
                    if appDelegate.isIngenicoTokenAvl {
                        self.processTokenSale()
                    } else {
                        self.promptForAmountAndClerkID(.TransactionTypeCreditSale, andIsKeyed: false, andIsWithReader: true)
                    }
                } else {
                    Indicator.sharedInstance.hideIndicator()
                    self.cardReaderFunctionCallPlaceOrder()
                }
            } else {
                //self.showError("refreshUserSession failed")
                self.consoleLog("refreshUserSession failed")
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    Ingenico.sharedInstance()?.user.logoff { (error) in
                        self.setLoggedIn(false)
                    }
                    self.loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password, islogin: true)

                }

            }
        })
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


                if DataManager.socketAppUrl != "" &&
                    DataManager.showCustomerFacing {
                    MainSocketManager.shared.onOrderProcessignloader(paymentType: "Ingenico")
                }
                if DataManager.isIngenicoConnected {
                    if self.getIsDeviceConnected() {
                        //                ingenico.initialize(withBaseURL: HomeVM.shared.ingenicoData[0].str_url,
                        //                                                   apiKey: HomeVM.shared.ingenicoData[0].str_apikey,
                        //                                                   clientVersion: ClientVersion)
                        // Indicator.sharedInstance.showIndicator()
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
    
    @IBAction func btn_placeOrderAction(_ sender: Any) {
        str_Auth = ""
        if str_PaymentName == "CARD READER" {
            if !getIsDeviceConnected() {
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
                //Indicator.sharedInstance.hideIndicator()
                //appDelegate.showToast(message: "Device is powered off, please power on / First connect device from setting page")
                return
            }
            
            if !getIsLoggedIn() {
                appDelegate.showToast(message: "Ingenico Login Fail.")
                loginWithUserName(HomeVM.shared.ingenicoData[0].str_username, andPW: HomeVM.shared.ingenicoData[0].str_password, islogin: true)
                return
            }
            cardReaderFunctionCallPlaceOrder()
            return
        }
        
        if shippingRefundButton.isSelected && orderType == .newOrder { //}|| Double(self.str_ShippingANdHandling) ?? 0.00 > 0 {
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
            SwipeAndSearchVC.shared.enableTextField()
            DataManager.isPaymentBtnAddCustomer = true
            DispatchQueue.main.async {
                
            }
            if DataManager.isCheckUncheckShippingBilling {
                if selectedViewController == addCustomerContainer && !iPadSelectCustomerViewController.isSelectCustomerOpen {
                    //                    self.showAlert(message: "Please first save the customer information.")
                    appDelegate.showToast(message: "Please first save the customer information.")
                    return
                }
                //Add FN LN and C
                if CustomerObj.str_address == "" && CustomerObj.str_city == "" && CustomerObj.str_region == "" && CustomerObj.str_postal_code == "" && CustomerObj.str_first_name == "" && CustomerObj.str_last_name == "" && CustomerObj.str_company == ""{
                    self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                    self.customerDelegate?.didSelectAddCustomerButton?()
                    self.add(childVC: addCustomerContainer)
                    
                }else{
                    
                    
                    
                    if CustomerObj.str_address == "" && CustomerObj.str_address2 == "" {
                        checkFillFeild = false
                    }else if CustomerObj.str_city == "" {
                        checkFillFeild = false
                    }else if CustomerObj.str_region == "" {
                        checkFillFeild = false
                    }else if CustomerObj.str_postal_code == "" {
                        checkFillFeild = false
                    }else{
                        if (CustomerObj.str_first_name == "" && CustomerObj.str_last_name == "") {
                            if CustomerObj.company == "" {
                                checkFillFeild = false
                            }else{
                                checkFillFeild = true
                            }
                        }else{
                            if (CustomerObj.str_first_name != "" && CustomerObj.str_last_name != ""){
                                checkFillFeild = true
                            }else{
                                if CustomerObj.company == "" {
                                    checkFillFeild = false
                                }else{
                                    checkFillFeild = true
                                }
                            }
                            
                        }
                    }
                    
                    if checkFillFeild {
                        //self.customerDelegate?.hideView?(with: "paymentActionAddCustomer")
                        if TotalPrice < 0 {
                            //                            showAlert(message: "You can not proceed with negative amount. ")
                            appDelegate.showToast(message: "You can not proceed with negative amount. ")
                            return
                        }
                        //Prevent to place multiple order
                        if isOderPlaced {
                            return
                        }
                        isOderPlaced = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.isOderPlaced = false
                        }
                        
                        isPayButtonSelected = true
                        self.idleChargeButton()
                        placeOrder()
                    }else{
                        self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                        self.customerDelegate?.didSelectAddCustomerButton?()
                        self.add(childVC: addCustomerContainer)
                    }
                }
                
                if CustomerObj.str_address == "" && CustomerObj.str_city == "" && CustomerObj.str_region == "" && CustomerObj.str_postal_code == "" {
                    self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                    self.customerDelegate?.didSelectAddCustomerButton?()
                    self.add(childVC: addCustomerContainer)
                }else{
                    if CustomerObj.str_address == "" && CustomerObj.str_address2 == "" {
                        self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                        self.customerDelegate?.didSelectAddCustomerButton?()
                        self.add(childVC: addCustomerContainer)
                    }else if CustomerObj.str_city == "" {
                        self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                        self.customerDelegate?.didSelectAddCustomerButton?()
                        self.add(childVC: addCustomerContainer)
                    }else if CustomerObj.str_region == "" {
                        self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                        self.customerDelegate?.didSelectAddCustomerButton?()
                        self.add(childVC: addCustomerContainer)
                    }else if CustomerObj.str_postal_code == "" {
                        self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                        self.customerDelegate?.didSelectAddCustomerButton?()
                        self.add(childVC: addCustomerContainer)
                    }else{
                        //self.customerDelegate?.hideView?(with: "paymentActionAddCustomer")
                        if TotalPrice < 0 {
                            //                            showAlert(message: "You can not proceed with negative amount. ")
                            appDelegate.showToast(message: "You can not proceed with negative amount. ")
                            return
                        }
                        //Prevent to place multiple order
                        if isOderPlaced {
                            return
                        }
                        isOderPlaced = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.isOderPlaced = false
                        }
                        
                        isPayButtonSelected = true
                        self.idleChargeButton()
                        placeOrder()
                        
                    }
                }
            }else{
                if selectedViewController == addCustomerContainer && !iPadSelectCustomerViewController.isSelectCustomerOpen {
                    //                    self.showAlert(message: "Please first save the customer information.")
                    appDelegate.showToast(message: "Please first save the customer information.")
                    return
                }
                
                if CustomerObj.str_Shippingaddress == "" && CustomerObj.str_Shippingcity == "" && CustomerObj.str_Shippingregion == "" && CustomerObj.str_Shippingpostal_code == "" {
                    self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                    self.customerDelegate?.didSelectAddCustomerButton?()
                    self.add(childVC: addCustomerContainer)
                }else{
                    if CustomerObj.str_Shippingaddress == "" && CustomerObj.str_Shippingaddress2 == "" {
                        self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                        self.customerDelegate?.didSelectAddCustomerButton?()
                        self.add(childVC: addCustomerContainer)
                    }else if CustomerObj.str_Shippingcity == "" {
                        self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                        self.customerDelegate?.didSelectAddCustomerButton?()
                        self.add(childVC: addCustomerContainer)
                    }else if CustomerObj.str_Shippingregion == "" {
                        self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                        self.customerDelegate?.didSelectAddCustomerButton?()
                        self.add(childVC: addCustomerContainer)
                    }else if CustomerObj.str_Shippingpostal_code == "" {
                        self.customerDelegate?.didSelectCustomer?(data: self.CustomerObj)
                        self.customerDelegate?.didSelectAddCustomerButton?()
                        self.add(childVC: addCustomerContainer)
                    }else{
                        //self.customerDelegate?.hideView?(with: "paymentActionAddCustomer")
                        if TotalPrice < 0 {
                            //                            showAlert(message: "You can not proceed with negative amount. ")
                            appDelegate.showToast(message: "You can not proceed with negative amount. ")
                            return
                        }
                        //Prevent to place multiple order
                        if isOderPlaced {
                            return
                        }
                        isOderPlaced = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.isOderPlaced = false
                        }
                        
                        isPayButtonSelected = true
                        self.idleChargeButton()
                        placeOrder()
                    }
                }
            }
        }else{
            if TotalPrice < 0 {
                //                showAlert(message: "You can not proceed with negative amount.")
                appDelegate.showToast(message: "You can not proceed with negative amount. ")
                return
            }
            //Prevent to place multiple order
            if isOderPlaced {
                return
            }
            isOderPlaced = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isOderPlaced = false
            }
            //Place Order
            if selectedViewController == addCustomerContainer {
                //                self.showAlert(message: "Please first save the customer information.")
                appDelegate.showToast(message: "Please first save the customer information.")
                return
            }
            isPayButtonSelected = true
            self.idleChargeButton()
            placeOrder()
        }
        
    }
    
    @IBAction func shippingRefundButton(_ sender: UIButton) {
        
        if DataManager.isBalanceDueData {
            return
        }
        
        //if CustomerObj.str_address != "" && CustomerObj.str_city != ""  && CustomerObj.str_region != "" && CustomerObj.str_postal_code != "" && CustomerObj.country != "" {
        self.view.endEditing(true)
        shippingRefundButton.isSelected = !shippingRefundButton.isSelected
        DataManager.isshipOrderButton = shippingRefundButton.isSelected
        calculateTotalCart()
        self.delegate?.didUpdateShippingRefund?(isselected: shippingRefundButton.isSelected)
        //        } else {
        //            self.showAlert(message: "Please enter Customer address.")
        //        }
        if isCheckCustDetail {
            if orderType == .newOrder {
                checkForCusGreenBtn()
            }
        }
    }
    
    func checkForCusGreenBtn() {
        if shippingRefundButton.isSelected {
            if DataManager.isCheckUncheckShippingBilling {
                
                //Add FN LN and C
                if CustomerObj.str_address == "" && CustomerObj.str_city == "" && CustomerObj.str_region == "" && CustomerObj.str_postal_code == "" && CustomerObj.str_first_name == "" && CustomerObj.str_last_name == "" && CustomerObj.str_company == ""{
                    payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    
                }else{
                    
                    if CustomerObj.str_address == "" && CustomerObj.str_address2 == "" {
                        checkFillFeild = false
                    }else if CustomerObj.str_city == "" {
                        checkFillFeild = false
                    }else if CustomerObj.str_region == "" {
                        checkFillFeild = false
                    }else if CustomerObj.str_postal_code == "" {
                        checkFillFeild = false
                    }else{
                        if (CustomerObj.str_first_name == "" && CustomerObj.str_last_name == "") {
                            if CustomerObj.company == "" {
                                checkFillFeild = false
                            }else{
                                checkFillFeild = true
                            }
                        }else{
                            if (CustomerObj.str_first_name != "" && CustomerObj.str_last_name != ""){
                                checkFillFeild = true
                            }else{
                                if CustomerObj.company == "" {
                                    checkFillFeild = false
                                }else{
                                    checkFillFeild = true
                                }
                            }
                        }
                    }
                    
                    if checkFillFeild {
                        payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                    }else{
                        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    }
                }
                
                if CustomerObj.str_address == "" && CustomerObj.str_city == "" && CustomerObj.str_region == "" && CustomerObj.str_postal_code == "" {
                    payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                }else{
                    if CustomerObj.str_address == "" && CustomerObj.str_address2 == "" {
                        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    }else if CustomerObj.str_city == "" {
                        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    }else if CustomerObj.str_region == "" {
                        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    }else if CustomerObj.str_postal_code == "" {
                        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    }else{
                        payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                    }
                }
            }else{
                if selectedViewController == addCustomerContainer && !iPadSelectCustomerViewController.isSelectCustomerOpen {
                    
                }
                
                if CustomerObj.str_Shippingaddress == "" && CustomerObj.str_Shippingcity == "" && CustomerObj.str_Shippingregion == "" && CustomerObj.str_Shippingpostal_code == "" {
                    payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                }else{
                    if CustomerObj.str_Shippingaddress == "" && CustomerObj.str_Shippingaddress2 == "" {
                        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    }else if CustomerObj.str_Shippingcity == "" {
                        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    }else if CustomerObj.str_Shippingregion == "" {
                        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    }else if CustomerObj.str_Shippingpostal_code == "" {
                        payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    }else{
                        payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                    }
                }
            }
            //checkPayButtonColorChange(isCheck: true, text: str_PaymentName)
        }
    }
}

//MARK: PaymentTypeContainerViewControllerDelegate
extension iPad_PaymentTypesViewController: PaymentTypeContainerViewControllerDelegate {
    
    func balanceRemoveTip(with amount: Double) {
        print(amount)
        HomeVM.shared.DueShared = HomeVM.shared.DueShared - amount
        balanceDue = HomeVM.shared.DueShared
        labelBallanceDueAmt.text = HomeVM.shared.DueShared.currencyFormat
        
        HomeVM.shared.tipValue = HomeVM.shared.tipValue - amount
        
        if HomeVM.shared.tipValue == 0 {
            tipView.isHidden = true
            //totalLabel.text =
        }
    }
    
    func balanceDueRemaining(with amount: Double) {
        print(amount)
        if amount > 0 {
            if str_PaymentName == "CASH"{
                payButton.setTitle("Tender \(amount.currencyFormat)", for: .normal)
            } else {
                self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Done" : "Charge \(amount.currencyFormat)", for: .normal)
            }
        }
        
        //balanceDueView.isHidden = false
        //labelBallanceDueAmt.isHidden = false
        var val = 0.0
        if balanceDue > 0 {
            val = Double(balanceDue)
        } else {
            val = Double(finalTotalSend)
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
            
            if DataManager.isAuthentication {
                if balDue == finalTotalSend {
                    if str_PaymentName == "CREDIT" || str_PaymentName == "PAX PAY"{
                        if DataManager.isBalanceDueData {
                            authButton.isHidden = true
                        } else {
                            authButton.isHidden = false
                        }
                    }
                    
                } else if balDue == balanceDue {
                    if str_PaymentName == "CREDIT" || str_PaymentName == "PAX PAY"{
                        if DataManager.isBalanceDueData {
                            authButton.isHidden = true
                        } else {
                            authButton.isHidden = false
                        }
                    }
                } else {
                    authButton.isHidden = true
                }
            } else {
                authButton.isHidden = true
            }
            
            if amount == 0 {
                if str_PaymentName == "CASH"{
                    payButton.setTitle("Tender \(balDue.currencyFormat)", for: .normal)
                } else {
                    self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Done" : "Charge \(balDue.currencyFormat)", for: .normal)
                }
            }
            
        } else {
            //labelBallanceDueAmt.text = "$0.00"
        }
        
    }
    
    func checkPayButtonColorChange(isCheck: Bool, text : String){
        
        //        if text == "restButton"{
        //            payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
        //            authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
        //        }
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        //            if self.CustomerObj.str_first_name == "" && self.CustomerObj.str_last_name == "" {
        //                self.customerNameLabel.text = "Add Customer"
        //            }else{
        //                self.customerNameLabel.text = self.CustomerObj.str_first_name + " " + self.CustomerObj.str_last_name
        //            }
        //        }
        
        if str_PaymentName == text  {
            print("got check")
            print("paymentName",str_PaymentName)
            payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            if isCheck {
                payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                isCheckCustDetail = true
                if orderType == .newOrder {
                    checkForCusGreenBtn()
                }
            }else{
                isCheckCustDetail = false
                payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            }
        }else{
            
        }
        
        // payButton.isUserInteractionEnabled = true
        if DataManager.allowZeroDollarTxn  == "false"{
            if HomeVM.shared.DueShared > 0 {
                if HomeVM.shared.DueShared == 0.0 {
                    payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    //  payButton.isUserInteractionEnabled = false
                }
            } else {
                if TotalPrice == 0.0 {
                    payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    //  payButton.isUserInteractionEnabled = false
                }
            }
            
            //                   if "CASH" == text {
            //                       if payButton.titleLabel?.text == "Tender $0.00" {
            //                           payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            //                           authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            //                       } else {
            //                           payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            //                           authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            //                       }
            //                   }
        }
        
        //if text == "CREDIT" || text == "MULTI CARD" {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateCustomerData()
        }
        // }
    }
    
    func placeOrder(isIpad: Bool) {
        DispatchQueue.main.async {
            self.isPayButtonSelected = true
            self.str_PaymentName = "CREDIT"
            self.placeOrder()
        }
    }
    
    func showCreditCard(){
        print("Hello")
        // self.customerDelegate?.didSelectCustomer?(data: CustomerObj)
        if str_PaymentName ==  "PAX PAY" {
            creditshowData?.didDataShowCreditcard?(paymentMethod: "paxpay")
        } else if str_PaymentName ==  "CARD READER" {
            creditshowData?.didDataShowCreditcard?(paymentMethod: "cardreader")
        } else {
            creditshowData?.didDataShowCreditcard?(paymentMethod: "credit")
        }
        setView(view: SavedCardContainer, hidden: false)
        
    }
    
    func sendCardCustomerCardData(data: CustomerListModel){
        self.customerDelegate?.didSelectCustomer?(data: CustomerObj)
    }
    
    func disableCardReaders() {
        paymentTypeViewDelegate?.disableCardReaders?()
    }
    
    func updateTotal(with amount: Double) {
        if HomeVM.shared.tipValue > 0 {
            tipAmountCreditCard = HomeVM.shared.tipValue
            self.tipLabel.text = HomeVM.shared.tipValue.currencyFormat
            self.tipView.isHidden = tipLabel.text == "$0.00"
        } else {
            tipAmountCreditCard = amount
            self.tipLabel.text = amount.currencyFormat
            self.tipView.isHidden = tipLabel.text == "$0.00"
        }
        
        if orderType == .newOrder {
            self.updateLabels(isUpdateTotal: false)
        }
        
    }
    
    func paxModeCheckAuth(strPaxMode: String) {
        
        if DataManager.isAuthentication {
            if (str_PaymentName == "CREDIT") ||  (str_PaymentName == "PAX PAY") {
                
                if DataManager.isBalanceDueData {
                    authButton.isHidden = true
                } else {
                    authButton.isHidden = false
                    if str_PaymentName == "PAX PAY" {
                        if strPaxMode == "DEBIT" ||  strPaxMode == "GIFT" {
                            authButton.isHidden = true
                        } else {
                            authButton.isHidden = false
                        }
                    }
                }
            } else {
                authButton.isHidden = true
            }
            
            if (!NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline) || orderType == .refundOrExchangeOrder{
                authButton.isHidden = true
            }
            
        } else {
            authButton.isHidden = true
        }
    }
    
    func balanceDueAfterVoid(with amount: Double) {
        //tipAmountCreditCard = amount
        //self.tipLabel.text = amount.currencyFormat
        //self.tipView.isHidden = tipLabel.text == "$0.00"
        balanceDue = amount
        self.updateLabels(isUpdateTotal: false)
    }
    
    func didGetCardDetail() {
        if selectedViewController == addCustomerContainer {
            //            self.showAlert(message: "Please first save the customer information.")
            appDelegate.showToast(message: "Please first save the customer information.")
            return
        }
        
        isCreditCardNumberDetected = true
        if selectedViewController == paymentTypeContainer {
            creditCardDelegate?.didUpdateTotal?(amount: amountforCredit, subToal: SubTotalPrice)
            self.moveToCreditCardScreen()
            self.creditCardDelegate?.didGetCardDetail?()
            self.creditCardDelegate?.placeOrder?(isIpad: true)
        }
    }
    
    func noCardDetailFound() {
        isCreditCardNumberDetected = false
        self.creditCardDelegate?.noCardDetailFound?()
    }
    
    func didUpdateDevice() {
        isCreditCardNumberDetected = false
        self.creditCardDelegate?.didUpdateDevice?()
    }
    
    func moveBackPage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didSelectPaymentMethod(with key: String) {
        str_PaymentName = key
        if DataManager.showSubscription {
            // by sudama add sub
            if isAddSubscription {
                if str_PaymentName != ""{
                    if str_PaymentName != "PAX PAY" && str_PaymentName != "CREDIT" {
                        appDelegate.strPaymentType = ""
                        str_PaymentName = ""
                        //                        showAlert(message: "Please select Credit payment type because cart having subscription product.")
                        appDelegate.showToast(message: "Please select Credit payment type because cart having subscription product.")
                        return
                    }
                    if DataManager.paxTokenizationEnable != "true" && str_PaymentName != "CREDIT"{
                        str_PaymentName = ""
                        appDelegate.strPaymentType = ""
                        //                        showAlert(message: "Please select Credit payment type because cart having subscription product.")
                        appDelegate.showToast(message: "Please select Credit payment type because cart having subscription product.")
                        return
                    }
                }
            }
            //
        }
        
        
        if orderType == .refundOrExchangeOrder {
            self.authButton.isHidden = true
        }
        
        if (key == "INVOICE") {
            self.authButton.isHidden = true  // code for done button client changes
            self.depositeView.isHidden = false
            self.authButton.setTitle("Save Invoice", for: .normal)
            //self.payButton.setTitle("Send Invoice", for: .normal)
            self.payButton.setTitle("Done", for: .normal)
            
        }else if (key == "CASH") {
            // MARK Hide for V5
            
            if balanceDue > 0{
                
                var valueOne = self.lastChargeValue - self.TotalPrice
                
                print("last amount value = \(valueOne)")
                
                if valueOne < 0 {
                    valueOne  = -(valueOne)
                } else {
                    valueOne  = -(valueOne)
                }
                
                let valueData =   self.balanceDue
                
                print("balance due after update = \(valueData)")
                
                if valueOne == 0 {
                    payValue = balanceDue
                    payButton.setTitle("Tender \(payValue.currencyFormat)", for: .normal)
                } else {
                    payValue = valueData
                    payButton.setTitle("Tender \(valueData.currencyFormat)", for: .normal)
                }
                
            }else{
                payButton.setTitle("Tender \(TotalPrice.currencyFormat)", for: .normal)
            }
            
        }else {
            self.depositeView.isHidden = true
            self.authButton.setTitle("Auth", for: .normal)
            
            if balanceDue > 0{
                
                let valueOne = lastChargeValue - TotalPrice
                
                print("last amount value = \(valueOne)")
                
                let valueData = balanceDue
                
                print("balance due after update = \(valueData)")
                
                if valueOne == 0 {
                    payButton.setTitle("Charge \(balanceDue.currencyFormat)", for: .normal)
                } else {
                    payButton.setTitle("Charge \(valueData.currencyFormat)", for: .normal)
                }
                
            }else{
                if TotalPrice < 0 {
                    payButton.setTitle("Charge $0.00", for: .normal)
                    
                } else {
                    payButton.setTitle("Charge \(TotalPrice.currencyFormat)", for: .normal)
                    
                }
                
            }
            
            //payButton.setTitle("Charge \(TotalPrice.currencyFormat)", for: .normal)
        }
        
        str_PaymentName = key
        
        if key == "CREDIT" {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if orderType == .refundOrExchangeOrder {
                    if self.orderInfoObj.cardDetail?.number != nil {
                        var number  = self.orderInfoObj.cardDetail!.number
                        if number != "" {
                            number = "************"+number!
                        }
                        PaymentsViewController.paymentDetailDict["data"] = ["cardnumber": number!,"mm":self.orderInfoObj.cardDetail?.month, "yyyy":self.orderInfoObj.cardDetail?.year, "cvv": ""]
                    }
                }
                DispatchQueue.main.async {
                    self.creditCardDelegate?.didUpdateTotal?(amount: self.amountforCredit, subToal: self.SubTotalPrice)
                    
                    self.creditCardDelegate?.enableCardReader?()
                }
            }
            self.add(childVC: creditCardContainer)
            if  DataManager.customerId != "" {
                lbl_PaymentMethodName.text = " "
            }else{
                lbl_PaymentMethodName.text = "Credit Card"
            }
            btn_Cancel.isHidden = false
            
            // by sudama offline
            if (!NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline) || orderType == .refundOrExchangeOrder {
                authButton.isHidden = true
            }
            
        }
        else if(key == "CASH")
        {
            self.add(childVC: cashContainer)
            lbl_PaymentMethodName.text = "Cash"
            btn_Cancel.isHidden = false
            
        }
        else if(key == "INVOICE")
        {
            self.add(childVC: invoiceContainer)
            lbl_PaymentMethodName.text = "Invoice / Estimate"
            btn_Cancel.isHidden = false
            if UI_USER_INTERFACE_IDIOM() == .pad {
                DispatchQueue.main.async {
                    self.invoiceDelegate?.loadClassData?()
                    self.invoiceDelegate?.enableCardReader?()
                }
            }
        }
        else if(key == "ACH CHECK")
        {
            self.add(childVC: achCheckContainer)
            lbl_PaymentMethodName.text = "ACH Check"
            btn_Cancel.isHidden = false
            if UI_USER_INTERFACE_IDIOM() == .pad {
                DispatchQueue.main.async {
                    self.achCheckDelegate?.loadClassData?()
                }
            }
        }
        else if(key == "GIFT CARD")
        {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                DispatchQueue.main.async {
                    self.giftCardDelegate?.enableCardReader?()
                }
            }
            self.add(childVC: giftCardContainer)
            lbl_PaymentMethodName.text = "Heartland Gift Card"
            btn_Cancel.isHidden = false
        }
        
        else if(key == "EXTERNAL GIFT CARD")
        {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                DispatchQueue.main.async {
                    self.externalGiftCardDelegate?.enableCardReader?()
                }
            }
            self.add(childVC: externalGiftCardContainer)
            lbl_PaymentMethodName.text = "External Gift Card"
            btn_Cancel.isHidden = false
        }
        
        else if(key == "INTERNAL GIFT CARD")
        {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                DispatchQueue.main.async {
                    self.internalGiftCardDelegate?.enableCardReader?()
                }
            }
            self.add(childVC: internalGiftCardContainer)
            lbl_PaymentMethodName.text = "Internal Gift Card"
            btn_Cancel.isHidden = false
        }
        
        else if(key == "MULTI CARD")
        {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                DispatchQueue.main.async {
                    self.multicardDelegate?.enableCardReader?()
                }
            }
            self.add(childVC: multiCardContainer)
            lbl_PaymentMethodName.text = "Split Payment"
            btn_Cancel.isHidden = false
        }
        else if(key == "CHECK")
        {
            self.add(childVC: checkContainer)
            lbl_PaymentMethodName.text = "Check"
            btn_Cancel.isHidden = false
        }
        else if(key == "EXTERNAL")
        {
            self.add(childVC: externalContainer)
            lbl_PaymentMethodName.text = "External Payment"
            btn_Cancel.isHidden = false
        }
        else if(key == "PAX PAY")
        {
            self.add(childVC: paxPayContainer)
            lbl_PaymentMethodName.text = "Pax Pay"
            btn_Cancel.isHidden = false
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                DispatchQueue.main.async {
                    self.paxDelegate?.loadClassData?()
                }
            }
        }
        else if(key == "CARD READER")
        {
            
            self.add(childVC: ingenicoContainer)
            lbl_PaymentMethodName.text = "Ingenico"
            btn_Cancel.isHidden = false
        }
        if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
            
//            if DataManager.selectedPayment?.contains("CARD READER") ?? false {
//                btn_Cancel.isHidden = false
//            } else {
                btn_Cancel.isHidden = true
            //}
        }
        
        if self.balanceDue > 0{
            self.updateTotalAmount(amount: self.payValue, SubTotal: 0.0)
        }else{
            self.updateTotalAmount(amount: self.TotalPrice, SubTotal: SubTotalPrice)
        }
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            //            if DataManager.isAuthentication {
            //                self.authButton.isHidden = !((key == "CREDIT") ||  (key == "PAX PAY"))
            //            }else {
            self.authButton.isHidden = true
            // }
        }else{
            if DataManager.isAuthentication {
                if DataManager.isBalanceDueData {
                    self.authButton.isHidden = true
                } else {
                    self.authButton.isHidden = !((key == "CREDIT") ||  (key == "PAX PAY"))
                }
            }else {
                self.authButton.isHidden = true
            }
        }
        
        if (!NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline) || orderType == .refundOrExchangeOrder {
            authButton.isHidden = true
        }
        
        //        if DataManager.isAuthentication {
        //            self.authButton.isHidden = !((key == "CREDIT") ||  (key == "PAX PAY"))
        //        }else {
        //            self.authButton.isHidden = true
        //        }
    }
    
    func getPaymentData(with dict: JSONDictionary) {
        var  invoiceTemplateId = ""
        switch str_PaymentName {
        case "CARD READER":
            str_CreditCardNumber = dict["cardnumber"]as? String ?? ""
            str_MM = dict["mm"] as? String ?? ""
            str_YYYY = dict["yyyy"] as? String ?? ""
            str_CVV = dict["cvv"] as? String ?? ""
            str_Auth = dict["auth"] as? String ?? ""
            strSplitPayAmount = "\(dict["amount"] as? Double ?? 0)"
            orig_txn_response = dict["orig_txn_response"] as? String ?? ""
            merchant = dict["merchant"] as? String ?? ""
            txn_response = dict["txn_response"] as? JSONDictionary ?? JSONDictionary()
            let datacardholderName = txn_response["transaction"] as? JSONDictionary ?? JSONDictionary()
            cardholderName = datacardholderName["cardholderName"] as? String ?? ""
            break
            
        case "CREDIT":
            str_CreditCardNumber = dict["cardnumber"]as? String ?? ""
            str_MM = dict["mm"] as? String ?? ""
            str_YYYY = dict["yyyy"] as? String ?? ""
            str_CVV = dict["cvv"] as? String ?? ""
            str_Auth = dict["auth"] as? String ?? ""
            strSplitPayAmount = dict["amount"] as? String ?? ""
            break
            
        case "CASH":
            let cash = dict["cash"] as? String ?? ""
            if cash != "" && cash != "$" {
                str_Cash = cash
            }
            break
            
        case "INVOICE":
            invoiceEmail = dict["email"] as? String ?? ""
            str_NotesInvoice = dict["notesInvoice"]as? String ?? ""
            str_Rep = dict["rep"]as? String ?? ""
            str_Terms = dict["terms"]as? String ?? ""
            str_DueDate = dict["duedate"]as? String ?? ""
            str_title = dict["invoiceTitle"]as? String ?? ""
            str_Ponumber = dict["ponumber"]as? String ?? ""
            invoiceCardYear = dict["YYYY"]as? String ?? ""
            invoiceCardMonth = dict["MM"]as? String ?? ""
            invoiceCardNumber = dict["cardNumber"]as? String ?? ""
            invoiceDate = dict["invoiceDate"]as? String ?? ""
            isSaveInvoice = dict["isSaveInvoice"]as? Bool ?? false
            strSplitPayAmount = "\(dict["total"] as? Double ?? 0.0)"
            CustomerObj = dict["customerObj"] as? CustomerListModel ?? CustomerListModel()
            invoiceTemplateId = dict["invoiceTemplateId"] as? String ?? ""
            if CustomerObj.isDataAdded {
                if CustomerObj.str_first_name == "" && CustomerObj.str_last_name == "" {
                    self.customerNameLabel.text = "Customer #" + CustomerObj.str_userID
                }else{
                    self.customerNameLabel.text = CustomerObj.str_first_name + " " + CustomerObj.str_last_name
                }
                // self.customerNameLabel.text = CustomerObj.str_first_name + " " + CustomerObj.str_last_name
                addIconImageView.image =  UIImage(named: "edit-icon1")
            }
            
            break
            
        case "ACH CHECK":
            str_RoutingNumber = dict["routingnumber"] as? String ?? ""
            str_AccountNumber = dict["accountnumber"] as? String ?? ""
            str_DLState = dict["dlstate"] as? String ?? ""
            str_DLNumber = dict["dlnumber"] as? String ?? ""
            strSplitPayAmount = dict["amount"] as? String ?? ""
            break
            
        case "GIFT CARD":
            str_CardPin = dict["cardpin"] as? String ?? ""
            str_GiftCardNumber = dict["giftcardnumber"] as? String ?? ""
            strSplitPayAmount = dict["amount"] as? String ?? ""
            break
            
        case "EXTERNAL GIFT CARD":
            str_ExternalGiftCardNumber = dict["externalGiftCardNumber"] as? String ?? ""
            strSplitPayAmount = dict["amount"] as? String ?? ""
            break
            
        case "INTERNAL GIFT CARD":
            str_InternalGiftCardNumber = dict["internalGiftCardNumber"] as? String ?? ""
            strSplitPayAmount = dict["amount"] as? String ?? ""
            break
            
        case "CHECK":
            str_CheckAmount = dict["checkamount"] as? String ?? ""
            str_CheckNumber = dict["checknumber"] as? String ?? ""
            break
            
        case "EXTERNAL":
            str_ExternalAmount = dict["amount"] as? String ?? ""
            str_ExternalApprovalNumber = dict["external_approval_number"] as? String ?? ""
            break
            
        case "NOTES":
            str_Notes = dict["notes"] as? String ?? ""
            break
            
        case "PAX PAY":
            paxPaymentType = dict["pax_payment_type"] as? String ?? ""
            paxDevice = dict["device"] as? String ?? ""
            paxUrl = dict["url"] as? String ?? ""
            paxtip = dict["tip"] as? String ?? ""
            paxTotal = dict["total"] as? String ?? ""
            str_Auth = dict["auth"] as? String ?? ""
            isCardFileSelected = dict["use_token"] as? Bool ?? false
            strSplitPayAmount = dict["amount"] as? String ?? ""
            str_user_pax_token = dict["user_pax_token"] as? String ?? ""
            break
            
        case "MULTI CARD":
            if let multicards = dict["multi_card"] as? JSONDictionary {
                multicardData = multicards
            }
            if let total = dict["totalAmount"] as? Double {
                multicardTotal = total
            }
            if let tip = dict["tipAmount"] as? Double {
                tipAmount = tip
            }
            break
            
        default: break
        }
        
        let depositeAmount = Double((self.depositeAmountLabel.text ?? "0.0").replacingOccurrences(of: "$", with: "")) ?? 0.0
        
        let paymentData: JSONDictionary = ["paymnetType":str_PaymentName,
                                           "auth":str_Auth,
                                           "cardnumber":str_CreditCardNumber,
                                           "mm":str_MM,
                                           "yyyy":str_YYYY,
                                           "cvv":str_CVV,
                                           "spliteAmount":strSplitPayAmount,
                                           "cash":str_Cash,
                                           "notesInvoice":str_NotesInvoice,
                                           "rep":str_Rep,
                                           "terms":str_Terms,
                                           "duedate":str_DueDate,
                                           "title":str_title,
                                           "ponumber":str_Ponumber,
                                           "routingnumber":str_RoutingNumber,
                                           "accountnumber":str_AccountNumber,
                                           "dlstate":str_DLState,
                                           "dlnumber":str_DLNumber,
                                           "checknumber":str_CheckNumber,
                                           "checkamount":str_CheckAmount,
                                           "cardpin":str_CardPin,
                                           "external_approval_number":str_ExternalApprovalNumber,
                                           "giftcardnumber":str_GiftCardNumber,
                                           "amount": str_ExternalAmount,
                                           "notes":str_Notes,
                                           "addnotes":addNote,
                                           "email": invoiceEmail,
                                           "multi_card": multicardData,
                                           "totalAmount": multicardTotal,
                                           "tipAmount": tipAmount,
                                           "pax_payment_type": paxPaymentType,
                                           "device": paxDevice,
                                           "use_token":isCardFileSelected,
                                           "user_pax_token": str_user_pax_token,
                                           "url": paxUrl,
                                           "tip": paxtip,
                                           "total": paxTotal,
                                           "externalGiftCardNumber": str_ExternalGiftCardNumber,
                                           "tipAmountCreditCard": tipAmountCreditCard,
                                           "YYYY": invoiceCardYear,
                                           "MM": invoiceCardMonth,
                                           "cardNumber": invoiceCardNumber,
                                           "invoiceDate": invoiceDate,
                                           "isSaveInvoice": "\(isSaveInvoice)",
                                           "orig_txn_response": orig_txn_response,
                                           "merchant": merchant,
                                           "txn_response": txn_response,
                                           "depositeAmount": depositeAmount,
                                           "pax_pay_receipt" : DataManager.isSingatureOnEMV,
                                           "internalGiftCardNumber": str_InternalGiftCardNumber,
                                           "invoiceTemplateId":invoiceTemplateId]
        
        paymentViewDelegate?.getPaymentData?(with: paymentData)
    }
    
    func placeOrderForIpad(with data: AnyObject) {
        
        if var dict = cartObjectData as? JSONDictionary {
            dict["customerObj"] = self.CustomerObj as Any
            Indicator.sharedInstance.showIndicator()
            if var cartArray = dict["cartArray"] as? Array<Any> {
                cartArray = self.cartProductsArray
                dict["cartArray"] = cartArray as Array<Any>
            }
            
            var totalInString = ""
            
            //            if balanceDue > 0 {
            //                totalInString = self.labelBallanceDueAmt.text ?? "0.0"
            //                totalInString = totalInString.replacingOccurrences(of: "$", with: "")
            //                totalInString = totalInString.replacingOccurrences(of: " ", with: "")
            //            } else {
            totalInString = self.totalLabel.text ?? "0.0"
            totalInString = totalInString.replacingOccurrences(of: "$", with: "")
            totalInString = totalInString.replacingOccurrences(of: " ", with: "")
            // }
            
            var total = Double(totalInString) ?? 0.0
            var shipping = Double(self.str_ShippingANdHandling) ?? 0
            if orderType == .refundOrExchangeOrder {
                shipping =  self.shippingRefundButton.isSelected ? -shipping : shipping
            }
            
            if let val = HomeVM.shared.coupanDetail.totalAmount {
                let valueOne = NSString(string: HomeVM.shared.coupanDetail.totalAmount)
                let couponAmount = valueOne.doubleValue
                
                if SubTotalPrice < couponAmount {
                    dict["couponName"] = ""
                } else {
                    dict["couponName"] = str_AddCouponName
                }
            }
            
            
            //let  HomeVM.shared.coupanDetail.totalAmount
            if  str_PaymentName == "CARD READER" {
                total += tipAmountCreditCard
            }
            dict["Total"] = total
            dict["taxStateName"] = taxTitle
            dict["addDiscount"] = str_AddDiscount
            dict["ShippingHandling"] = shipping.roundToTwoDecimal
            dict["subTotal"] = SubTotalPrice
            dict["tax"] = str_TaxAmount
            //dict["couponName"] = str_AddCouponName
            dict["orderInfoObj"] = orderInfoObj
            dict["orderType"] = orderType
            if appDelegate.isOpenToOrderHistory {
                if let obj = dict["orderInfoObj"] as? OrderInfoModel {
                    dict["orderInfoObj"] = obj
                }
                
            }
            cartObjectData = dict as AnyObject
        }
        
        paymentViewDelegate?.placeOrderForIpad?(with: cartObjectData)
    }
    func showCustomerViewfromInvoice() {
        DataManager.isPaymentBtnAddCustomer = false
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        
        SwipeAndSearchVC.shared.enableTextField()
        
        self.add(childVC: addCustomerContainer)
        
        self.customerDelegate?.didSelectAddCustomerButton?()
        self.customerDelegate?.didSelectCustomer?(data: CustomerObj)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension iPad_PaymentTypesViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        isAddSubscription = false
        return self.cartProductsArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cartProductsArray = self.cartProductsArray[indexPath.row]
        let isRefundProduct = (cartProductsArray as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
        // by sudama add sub
        let isAddSubscriptionCheck = (cartProductsArray as AnyObject).value(forKey: "addSubscription") as? Bool ?? false
        
        if isAddSubscriptionCheck {
            isAddSubscription = isAddSubscriptionCheck
            resetPaymentView()
        }
        //
        if let val = DataManager.showImagesFunctionality {
            self.str_showImagesFunctionality = val
        }
        if let productCode = DataManager.showProductCodeFunctionality{
            self.str_showProductCodeFunctionality = productCode
        }
        
        var newString = ""
        //self.str_showImagesFunctionality = DataManager.showImagesFunctionality!
        var isShowDetails = false
        
        if !isRefundProduct {   //New Product
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartcell", for: indexPath) as! CartTableCell
            
            let qty = Double((cartProductsArray as AnyObject).value(forKey: "productqty") as? String ?? "") ?? 1
            let price = Double((cartProductsArray as AnyObject).value(forKey: "productprice") as? String ?? "") ?? 0
            let isAllowDecimal = (cartProductsArray as AnyObject).value(forKey: "qty_allow_decimal") as? Bool ?? false
            var notesText = (cartProductsArray as AnyObject).value(forKey: "productNotes") as? String ?? ""
            cell.productName.text = (cartProductsArray as AnyObject).value(forKey: "producttitle") as? String
            
            // var newString = " "
            
            //            if let dictArray = (cartProductsArray as AnyObject).value(forKey: "attributesArray") as? [JSONDictionary] {
            //                for dict in dictArray {
            //                    let key = dict["key"] as? String ?? ""
            //                    var name = String()
            //                    if let jsonArray = dict["values"] as? JSONArray {
            //                        for value in jsonArray {
            //
            //                            if let data = value["jsonArray"] as? JSONArray {
            //                                for val in data {
            //                                    let select = val["isSelect"] as? Bool
            //                                    if select == true {
            //                                        isShowDetails = select!
            //                                    }
            //                                }
            //                            }
            //                        }
            //                    }
            //                }
            //            }
            //
            if let dictArray = (cartProductsArray as AnyObject).value(forKey: "itemMetaFieldsArray") as? [JSONDictionary] {
                print(dictArray)
                for dict in dictArray {
                    print(dict)
                    if let jsonArray = dict["values"] as? JSONArray {
                        for value in jsonArray {
                            isShowDetails = true
                            let keyMeta = value["label"] as? String ?? ""
                            let valueMeta = value["tempValue"] as? String ?? ""
                            if valueMeta != "" {
                                newString.append("\(keyMeta): \(valueMeta)\n")
                            }
                        }
                    }
                }
            }
            
            if let dictArray = (cartProductsArray as AnyObject).value(forKey: "attributesArray") as? [JSONDictionary] {
                
                for dict in dictArray {
                    
                    
                    if let jsonArray = dict["values"] as? JSONArray {
                        var i = 1
                        var j = 1
                        for value in jsonArray {
                            let tyoe = value["attributeType"] as? String ?? ""
                            var name = ""
                            
                            let key = value["attributeName"] as? String ?? ""
                            if let data = value["jsonArray"] as? JSONArray {
                                for val in data {
                                    let select = val["isSelect"] as? Bool
                                    if select == true {
                                        name = val["attribute_value"] as? String ?? ""
                                        isShowDetails = select!
                                        // newString.append("\(key): \(name)\n")
                                         //------ sudama add surcharge variation value start ------//
                                         
                                         //newString.append("\(key): \(name)\n")
                                         var surchargVariationValue = ""
                                         let aatrVariId =  val["attribute_value_id"] as? String ?? ""
                                         if let dictArraysurch = (cartProductsArray as AnyObject).value(forKey: "surchargVariationArray") as? [JSONDictionary] {
                                             for dict in dictArraysurch {
                                                 if let jsonArray = dict["values"] as? JSONArray {
                                                     for value in jsonArray {
                                                         let valueSur = value["variation_price_surchargeClone"] as? String ?? ""
                                                         
                                                         for value in jsonArray {
                                                             if let data = value["jsonArray"] as? JSONArray {
                                                                 for val in data {
                                                                     let select = val["isSelect"] as? Bool
                                                                     let attribute_value_id = val["attribute_value_id"] as? String ?? ""
                                                                     if attribute_value_id == aatrVariId {
                                                                         surchargVariationValue = " $\(valueSur)"
                                                                     }
                                                                 }
                                                             }
                                                         }
                                                     }
                                                 }
                                                 
                                             }
                                         }
                                         //    newString.append("\(key): \(name)\(surchargVariationValue)\n")
                                        if i == 1 {
                                            i = i+1
                                            //  newString.append("\(key): \(name)\n")
                                            newString.append("\(key): \(name)\(surchargVariationValue)\n")
                                        } else {
                                            newString.append("\(name)\(surchargVariationValue)\n")
                                        }
                                        //------ sudama add surcharge variation value start ------//
                                    }
                                }
                            }
                            if tyoe == "text" {
                                name = value["attribute_value"] as? String ?? ""
                                if name != "" {
                                   // newString.append("\(key): \(name)\n")
                                    if j == 1 {
                                        j = j+1
                                        newString.append("\(key): \(name)\n")
                                    } else {
                                        newString.append("\(name)\n")
                                    }
                                }
                            } else if tyoe == "text_calendar" {
                                name = value["attribute_value"] as? String ?? ""
                                if name != "" {
                                    isShowDetails = true
                                   newString.append("\(key): \(name)\n")
                                }
                            }
                        }
                    }
                    //  newString.append("| \(key): \(name) ")
                }
            }
            if isShowDetails {
                cell.showAttributeLabel.isHidden = false
            } else {
                cell.showAttributeLabel.isHidden = true
            }
            
            cell.showAttributeLabel.text = newString
            if isOpenToOrderHistory {
                var variationText = ""
                if orderInfoObj.productsArray[indexPath.row ].metaFeildsStringValue == "" {
                    if orderInfoObj.productsArray[indexPath.row].attribute != "" {
                        variationText =  orderInfoObj.productsArray[indexPath.row].attribute.replacingOccurrences(of: ",", with: "\n")
                    }
                }else if  orderInfoObj.productsArray[indexPath.row].attribute == "" {
                    variationText = orderInfoObj.productsArray[indexPath.row ].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n")
                } else {
                    variationText = orderInfoObj.productsArray[indexPath.row ].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n") + "\n" + orderInfoObj.productsArray[indexPath.row].attribute.replacingOccurrences(of: ",", with: "\n")
                }
                
                if variationText != "" {
                    cell.showAttributeLabel.text = variationText
                    cell.showAttributeLabel.isHidden = false
                }else{
                    cell.showAttributeLabel.isHidden = true
                }
                
                //cell.variationTitleLabel.text = orderInfoModelObj.productsArray[indexPath.row - 1].attribute.replacingOccurrences(of: ",", with: "\n")
                let value  =  "\(orderInfoModelObj.productsArray[indexPath.row].man_desc)"
                // cell.labelNotes.text = value
                notesText = value
                
            }
            cell.totalLabel.text = (qty * price).currencyFormat
            cell.priceQtyLabel.text = price.currencyFormat + " X " + (isAllowDecimal ? qty.roundToTwoDecimal : qty.roundOFF)
            
            let code = (cartProductsArray as AnyObject).value(forKey: "productCode") as? String
            let discount = notesText//(cartProductsArray as AnyObject).value(forKey: "apppliedDiscountString") as? String ?? ""
            if str_showProductCodeFunctionality == "true" {
                if orderType == .refundOrExchangeOrder {
                    cell.productCodeLabel.isHidden = true
                }else{
                    cell.productCodeLabel.isHidden = false
                    cell.productCodeLabel.text = code
                    cell.productCodeLabel.isHidden = code == ""
                }
            }else{
                cell.productCodeLabel.isHidden = true
            }
            // cell.productCodeLabel.text = code
            cell.productDiscountLabel.text = discount
            //  cell.productCodeLabel.isHidden = code == ""
            cell.productDiscountLabel.isHidden = discount == ""
            
            if self.str_showImagesFunctionality == "true" {
                if str_showProductCodeFunctionality == "true" {
                    cell.proImgWidthConstarint.constant = 50
                    cell.proImgHeightConstarint.constant = 50
                }else{
                    cell.proImgWidthConstarint.constant = 30
                    cell.proImgHeightConstarint.constant = 30
                }
                cell.productImageView.isHidden = false
                let image = UIImage(named: "category-bg")
                cell.productImageView.image = #imageLiteral(resourceName: "m-payment")
                if let url = URL(string: (cartProductsArray as AnyObject).value(forKey: "productimage") as? String ?? "") {
                    cell.productImageView.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
                }else {
                    if  let data = (cartProductsArray as AnyObject).value(forKey: "productimagedata") as? Data {
                        cell.productImageView?.image = UIImage(data: data)
                    }
                }
                cell.contentView.layoutIfNeeded()
                cell.contentView.setNeedsLayout()
                cell.contentView.setNeedsDisplay()
            }else{
                cell.proImgWidthConstarint.constant = 0
                cell.proImgHeightConstarint.constant = 0
                cell.productImageView.isHidden = true
                cell.contentView.layoutIfNeeded()
                cell.contentView.setNeedsLayout()
                cell.contentView.setNeedsDisplay()
            }
            
            //  cell.btnShowDetails.tag = indexPath.row
            // cell.btnShowDetails.addTarget(self, action:#selector(btn_ShowDetailsAction(sender:)), for: .touchUpInside)
            cell.crossButton.isHidden = appDelegate.isOpenToOrderHistory
            cell.crossButton.tag = indexPath.row
            cell.crossButton.addTarget(self, action:#selector(btn_DeleteAction(sender:)), for: .touchUpInside)
            return cell
            
        }
        
        //        //Refund or Exchange
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "refundcell", for: indexPath) as! CartTableCell
        //
        //        let qty = (cartProductsArray as AnyObject).value(forKey: "productqty") as? Double ?? 1
        //        let price = (cartProductsArray as AnyObject).value(forKey: "productprice") as? Double ?? 0
        //        let isAllowDecimal = (cartProductsArray as AnyObject).value(forKey: "qty_allow_decimal") as? Bool ?? false
        //
        //        cell.productName.text = (cartProductsArray as AnyObject).value(forKey: "producttitle") as? String
        //        cell.attributeLabel.text = (cartProductsArray as AnyObject).value(forKey: "attributeString") as? String
        //        cell.totalLabel.text = (qty * price).currencyFormat
        //        cell.priceQtyLabel.text = price.currencyFormat + " X " + (isAllowDecimal ? qty.roundToTwoDecimal : qty.roundOFF)
        //
        //        let code = (cartProductsArray as AnyObject).value(forKey: "productCode") as? String ?? ""
        //
        //        cell.productCodeLabel.text = code
        //        cell.productCodeLabel.isHidden = code == ""
        //        cell.productDiscountLabel.isHidden = true
        //
        //        if self.str_showImagesFunctionality == "true" {
        //            cell.productImageView.isHidden = false
        //            cell.proImgWidthConstarint.constant = 50
        //            let image = UIImage(named: "category-bg")
        //            cell.productImageView.image = #imageLiteral(resourceName: "m-payment")
        //            if let url = URL(string: (cartProductsArray as AnyObject).value(forKey: "productimage") as? String ?? "") {
        //                cell.productImageView.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        //            }
        //            cell.contentView.setNeedsLayout()
        //            cell.contentView.setNeedsDisplay()
        //        }else{
        //            cell.productImageView.isHidden = true
        //            cell.proImgWidthConstarint.constant = 0
        //            cell.contentView.setNeedsLayout()
        //            cell.contentView.setNeedsDisplay()
        //        }
        //
        //        let returnToStock = (cartProductsArray as AnyObject).value(forKey: "returnToStock") as? Bool ?? false
        //
        //        cell.returnToStockButton.tag = indexPath.row
        //        cell.returnToStockButton.isSelected = returnToStock
        //        cell.returnToStockButton.addTarget(self, action:#selector(btn_ReturnToStockAction(sender:)), for: .touchUpInside)
        //        return cell
        
        //Refund or Exchange
        let cell = tableView.dequeueReusableCell(withIdentifier: "refundcell", for: indexPath) as! CartTableCell
        
        let qty = (cartProductsArray as AnyObject).value(forKey: "productqty") as? Double ?? 1
        let price = (cartProductsArray as AnyObject).value(forKey: "productprice") as? Double ?? 0
        let isAllowDecimal = (cartProductsArray as AnyObject).value(forKey: "qty_allow_decimal") as? Bool ?? false
        
        cell.priceQtyLabel.tag = indexPath.row
        cell.totalLabel.tag = indexPath.row
        cell.productName.text = (cartProductsArray as AnyObject).value(forKey: "producttitle") as? String
        //cell.attributeLabel.text = ""//(cartProductsArray as AnyObject).value(forKey: "attributeString") as? String
        cell.totalLabel.text = (qty * price).currencyFormat
        
        //stringQty = (cartProductsArray as AnyObject).value(forKey: "productqty") as? Double ?? 1
        //StringShowQty = (cartProductsArray as AnyObject).value(forKey: "productqty") as? Double ?? 1
        cell.priceQtyLabel.text = price.currencyFormat + " X " + (isAllowDecimal ? qty.roundToTwoDecimal : qty.roundOFF)
        
        let strTax = (cartProductsArray as AnyObject).value(forKey: "per_product_tax") as? Double ?? 0
        let strDiscount = (cartProductsArray as AnyObject).value(forKey: "per_product_discount") as? Double ?? 0
        let strAmount = (qty * price).currencyFormat
        cell.lblAmount.text = "Amount:" + strAmount
        
        var strTaxval = (qty * strTax)
        if strTax == 0{
            cell.lblTax.isHidden = true
        }else{
            cell.lblTax.isHidden = false
            cell.lblTax.text = "Tax:" + strTaxval.currencyFormat
        }
        
        var strDiscval = (qty * strDiscount)
        if strDiscount == 0.0{
            cell.lblDisccount.isHidden = true
        }else{
            cell.lblDisccount.isHidden = false
            
            cell.lblDisccount.text = "Discount:" + String(strDiscval.currencyFormat)
        }
        
        
        if strDiscval < 0 {
            strDiscval = -strDiscval
        }
        
        if strTaxval < 0 {
            strTaxval = -strTaxval
        }
        
        if qty < 0 {
            let totalOb =  (Double(-qty * price) + Double(strTaxval)) - Double(strDiscval)
            cell.totalLabel.text = "-" + totalOb.currencyFormat
        }else{
            let totalOb = Double(qty * price) + Double(strTaxval) - Double(strDiscval)
            cell.totalLabel.text = totalOb.currencyFormat
        }
        
        //if qty == -1 {
        
        //}else{
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.actionTapQuantity))
        //cell.priceQtyLabel?.isUserInteractionEnabled = true
        //cell.priceQtyLabel?.addGestureRecognizer(tapGestureRecognizer)
        //}
        
        let code = (cartProductsArray as AnyObject).value(forKey: "productCode") as? String ?? ""
        
        cell.productCodeLabel.text = code
        cell.productCodeLabel.isHidden = code == ""
        cell.productDiscountLabel.isHidden = true
        if orderType == .refundOrExchangeOrder {
            cell.productCodeLabel.isHidden = true
        }
        if self.str_showImagesFunctionality == "true" {
            cell.proImgWidthConstarint.constant = 50
            cell.productImageView.isHidden = false
            let image = UIImage(named: "category-bg")
            cell.productImageView.image = #imageLiteral(resourceName: "m-payment")
            if let url = URL(string: (cartProductsArray as AnyObject).value(forKey: "productimage") as? String ?? "") {
                cell.productImageView.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell.contentView.layoutIfNeeded()
            cell.contentView.setNeedsLayout()
            cell.contentView.setNeedsDisplay()
        }else{
            cell.proImgWidthConstarint.constant = 0
            cell.proImgHeightConstarint.constant = 0
            cell.productImageView.isHidden = true
            cell.contentView.layoutIfNeeded()
            cell.contentView.setNeedsLayout()
            cell.contentView.setNeedsDisplay()
        }
        
        let returnToStock = (cartProductsArray as AnyObject).value(forKey: "returnToStock") as? Bool ?? false
        cell.tfSelectCondition.isUserInteractionEnabled = false
        if UI_USER_INTERFACE_IDIOM() == .pad {
            ///cell.returnToStockButtoniPhone.isHidden = true
            cell.returnToStockButton.tag = indexPath.row
            cell.returnToStockButton.isSelected = returnToStock
            if cell.returnToStockButton.isSelected{
                cell.tfSelectCondition.isHidden = false
            }else{
                cell.tfSelectCondition.isHidden = true
            }
            //cell.returnToStockButton.addTarget(self, action:#selector(btn_ReturnToStockAction(sender:)), for: .touchUpInside)
        }else {
            //cell.returnToStockButton.isHidden = true
            //cell.returnToStockButtoniPhone.tag = indexPath.row
            //cell.returnToStockButtoniPhone.backgroundColor = returnToStock ? UIColor.HieCORColor.blue.colorWith(alpha: 1.0) : UIColor.white
            //cell.returnToStockButtoniPhone.setTitleColor(!returnToStock ? UIColor.HieCORColor.blue.colorWith(alpha: 1.0) : UIColor.white, for: .normal)
            //cell.returnToStockButtoniPhone.addTarget(self, action:#selector(btn_ReturnToStockAction(sender:)), for: .touchUpInside)
        }
        cell.contentView.backgroundColor = UI_USER_INTERFACE_IDIOM() == .phone ? UIColor.white : UIColor.clear
        
        let selectedAttribute = (cartProductsArray as AnyObject).value(forKey: "selectedAttributes") as? NSArray
        
        if (selectedAttribute?.count)! > 0 {
            isShowDetails = true
        }
        
        if isShowDetails {
            cell.showAttributeLabel.isHidden = false
        } else {
            cell.showAttributeLabel.isHidden = true
        }
//        newString = didShowDetailsAtrribute(cartArray: [cartProductsArray])
        // cell.btnShowDetails.tag = indexPath.row
        // cell.btnShowDetails.addTarget(self, action:#selector(btn_ShowDetailsAction(sender:)), for: .touchUpInside)
//        cell.showAttributeLabel.text = newString
        // newString = didShowDetailsAtrribute(cartArray: [cartProductsArray] )
        var variationText = ""
       // newString = didShowDetailsAtrribute(cartArray: [cartProductsArray] )
        if orderInfoObj.productsArray[indexPath.row ].metaFeildsStringValue == "" {
            if orderInfoObj.productsArray[indexPath.row].attribute != "" {
                variationText =  orderInfoObj.productsArray[indexPath.row].attribute.replacingOccurrences(of: ",", with: "\n")
            }
        }else if  orderInfoObj.productsArray[indexPath.row].attribute == "" {
            variationText = orderInfoObj.productsArray[indexPath.row ].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n")
        } else {
            variationText = orderInfoObj.productsArray[indexPath.row ].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n") + "\n" + orderInfoObj.productsArray[indexPath.row].attribute.replacingOccurrences(of: ",", with: "\n")
        }
//         let variationText = orderInfoObj.productsArray[indexPath.row ].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n") + "\n" + orderInfoObj.productsArray[indexPath.row].attribute.replacingOccurrences(of: ",", with: "\n")
         if variationText != "" {
             cell.showAttributeLabel.text = variationText
             cell.showAttributeLabel.isHidden = false
         }else{
             cell.showAttributeLabel.isHidden = true
         }
        cell.tfSelectCondition.tag = indexPath.row
        cell.tfSelectCondition.setPaddingleft()
        cell.tfSelectCondition.setDropDown()
        cell.btn_DeleteProduct.tag = indexPath.row
        cell.btn_DeleteProduct.addTarget(self, action:#selector(btn_DeleteAction(sender:)), for: .touchUpInside)
        let selectionInventory = (cartProductsArray as AnyObject).value(forKey: "selectionInventory") as? String
        
        cell.tfSelectCondition.text = selectionInventory
        
        //cell.tfSelectCondition.addTarget(self, action: #selector(handleItemsTextField(sender:)), for: .editingDidBegin)
        
        //        let ob = strStatusItem[indexPath.row] as? String
        //
        //        if  ob  == "Select Condition"  {
        //            cell.tfSelectCondition.text = array_ItemList[0] as? String
        //        }else if ob  == "New/Unopened"  {
        //            cell.tfSelectCondition.text = array_ItemList[1] as? String
        //        }else if ob  == "New/Open Box"  {
        //            cell.tfSelectCondition.text = array_ItemList[2] as? String
        //        }else if ob  == "Used"  {
        //            cell.tfSelectCondition.text = array_ItemList[3] as? String
        //        }else if ob  == "Damaged"  {
        //            cell.tfSelectCondition.text = array_ItemList[4] as? String
        //        }
        //
        //        if !cell.returnToStockButton.isSelected{
        //            strStatusItem[indexPath.row] = ob
        //            for product in orderInfoObj.productsArray {
        //                showItems.removeAll()
        //                strStatusItem[indexPath.row] = "Select Condition"
        //            }
        //        }
        
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        if isOpenToOrderHistory {
            return
        }
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        
        let cartProductsArray = self.cartProductsArray[indexPath.row]
        let isRefundProduct = (cartProductsArray as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
        
        if !isRefundProduct {
            self.editProductDetailDelegate?.didEditProduct?(index: indexPath.row)
            self.showEditView()
        }
    }
    
    
    func didShowDetailsAtrribute(cartArray: Array<Any>) -> String {
        var newString = ""
        
        
        print(cartArray)
        
        //variationData
        
        //  let productAttribute = (cartArray[0] as AnyObject).value(forKey: "attributeString") as? String
        
        if let selectedAttribute = (cartArray[0] as AnyObject).value(forKey: "selectedAttributes") as? [JSONDictionary] {
            
            //            dictAttribute.removeAll()
            //            attributeData.removeAll()
            //            arrdict.removeAllObjects()
            
            if let jsonArray = (cartArray[0] as AnyObject).value(forKey: "variationData") as? JSONArray {
                
                for value in selectedAttribute {
                    let attribute_id = value["attribute_id"] as? String
                    let attributevalueIdDataSelect = value["attribute_value_id"] as? NSArray
                    
                    for data in jsonArray {
                        
                        let attrId = data["attribute_id"] as? String
                        let attributename = data["attribute_name"] as? String ?? ""
                        let type = data["attribute_type"] as? String ?? ""
                        if attribute_id == attrId {
                            print(attribute_id)
                            
                            if let attributevalueIdData = data["attribute_values"] as? JSONArray {
                                
                                var isShowDetails = false
                                
                                for dataval in attributevalueIdData {
                                    let attrvalId = dataval["attribute_value_id"] as? String
                                    let attributeValue = dataval["attribute_value"] as? String ?? ""
                                    let key = dataval["attributeName"] as? String ?? ""
                                    for data in attributevalueIdDataSelect! {
                                        let id = data as? String
                                        if id == attrvalId {
                                            // dataAtt.append(attributename!)
                                            isShowDetails = true
                                            newString.append("\(attributename): \(attributeValue)\n")
                                        }
                                    }
                                }
                                
                                if type  == "text" {
                                    for data in attributevalueIdDataSelect! {
                                        let value = data as? String ?? ""
                                        if attribute_id == attrId {
                                            // dataAtt.append(attributename!)
                                            isShowDetails = true
                                            newString.append("\(attributename): \(value)\n")
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
            }
        }
        
        if let dictArray = (cartArray as AnyObject).value(forKey: "attributesArray") as? [JSONDictionary] {
            
            for dict in dictArray {
                
                
                if let jsonArray = dict["values"] as? JSONArray {
                    
                    for value in jsonArray {
                        let tyoe = value["attributeType"] as? String ?? ""
                        var name = ""
                        
                        let key = value["attributeName"] as? String ?? ""
                        if let data = value["jsonArray"] as? JSONArray {
                            for val in data {
                                let select = val["isSelect"] as? Bool
                                if select == true {
                                    
                                    name = val["attribute_value"] as? String ?? ""
                                    // isShowDetails = select!
                                    
                                   // newString.append("\(key): \(name)\n")
                                    //------ sudama add surcharge variation value start ------//
                                    
                                    //newString.append("\(key): \(name)\n")
                                    var surchargVariationValue = ""
                                    let aatrVariId =  val["attribute_value_id"] as? String ?? ""
                                    if let dictArraysurch = (cartProductsArray as AnyObject).value(forKey: "surchargVariationArray") as? [JSONDictionary] {
                                        for dict in dictArraysurch {
                                            if let jsonArray = dict["values"] as? JSONArray {
                                                for value in jsonArray {
                                                    let valueSur = value["variation_price_surchargeClone"] as? String ?? ""
                                                    
                                                    for value in jsonArray {
                                                        if let data = value["jsonArray"] as? JSONArray {
                                                            for val in data {
                                                                let select = val["isSelect"] as? Bool
                                                                let attribute_value_id = val["attribute_value_id"] as? String ?? ""
                                                                if attribute_value_id == aatrVariId {
                                                                    surchargVariationValue = " $\(valueSur)"
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                    newString.append("\(key): \(name)\(surchargVariationValue)\n")
                                    //------ sudama add surcharge variation value start ------//
                                }
                            }
                        }
                        if tyoe == "text" {
                            name = value["attribute_value"] as? String ?? ""
                            if name != "" {
                                newString.append("\(key): \(name)\n")
                            }
                        } else if tyoe == "text_calendar" {
                            name = value["attribute_value"] as? String ?? ""
                            if name != "" {
                               // isShowDetails = true
                               newString.append("\(key): \(name)\n")
                            }
                        }
                    }
                }
                //  newString.append("| \(key): \(name) ")
            }
        }
        return newString
    }
    
    @objc func btn_DeleteAction(sender: UIButton)
    {
        if isOpenToOrderHistory {
            return
        }
        if DataManager.isBalanceDueData {
            //appDelegate.showToast(message: "Please complete Split Payment transactions.")
            return
        }
        
        if HomeVM.shared.DueShared > 0 {
            
            if HomeVM.shared.DueShared == finalTotalSend {
                DataManager.tempBalanceDuedata = 0.0
            } else if HomeVM.shared.DueShared > HomeVM.shared.TotalDue {
                DataManager.tempBalanceDuedata = HomeVM.shared.TotalDue - HomeVM.shared.DueShared
            } else if HomeVM.shared.DueShared < HomeVM.shared.TotalDue {
                DataManager.tempBalanceDuedata = finalTotalSend - HomeVM.shared.DueShared
            }
        }
        cartProductsArray.remove(at: sender.tag)
        DataManager.cartProductsArray = cartProductsArray
        if cartProductsArray.count == 0 {
            if CustomerObj.userCoupan == "" {
                str_AddCouponName = ""
                couponNameLabel.text = "Apply Coupon"
                str_CouponDiscount = ""
                taxableCouponTotal = 0.0
                crossButton.isHidden = true
                DataManager.shippingWeight = 0
                DataManager.finalLoyaltyDiscount = 0
                DataManager.shippingWidth = 0
                DataManager.shippingLength = 0
                DataManager.shippingHeight = 0
                DataManager.cartShippingProductsArray?.removeAll()
                DataManager.cartData?.removeAll()
                DataManager.selectedFullfillmentId = ""
                str_AddCouponName = ""
                isCoupanApplyOnAllProducts = false
                str_CouponDiscount = ""
                str_AddDiscountPercent = ""
                str_AddDiscount = ""
                isPercentageDiscountApplied = false
                str_ShippingANdHandling = ""
                taxableCouponTotal = 0.0
                crossButton.isHidden = true
                str_TaxAmount = ""
                taxNameLabel?.text = "Tax (Default)"
                str_TaxPercentage = ""
                balanceDue = 0.0
                DataManager.customerId = ""
                DataManager.CardCount = 0
                self.delegate?.didUpdateCoupon?(name: "", amount: 0)
            }
            self.resetCartData()
        }
        calculateTotalCart()
        isAddSubscription = false
        self.tabelView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if HomeVM.shared.DueShared > 0.0 {
                if self.finalTotalSend > 0 {
                    self.labelBallanceDueAmt.text = self.dataNew.currencyFormat
                    self.balanceDue = self.dataNew
                    HomeVM.shared.DueShared = self.dataNew
                    self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Done" : "Charge \(self.dataNew.currencyFormat)", for: .normal)
                    
                    //self.updateTotalAmount(amount: self.finalTotalSend, SubTotal: self.SubTotalPrice)
                }
            }
            //self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Done" : "Charge \(self.dataNew.currencyFormat)", for: .normal)
        }
        
        
        //        if DataManager.tempBalanceDuedata == 0.0 {
        //            dataNew = finalTotalSend
        //
        //            //                if finalTotalSend > 0 {
        //            //                    //payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(finalTotalSend.currencyFormat)", for: .normal)
        //            //                    self.updateTotalAmount(amount: finalTotalSend, SubTotal: SubTotalPrice)
        //            //                }
        //        } else {
        //            dataNew = finalTotalSend - DataManager.tempBalanceDuedata!
        //        }
        
    }
    
    @objc func btn_ReturnToStockAction(sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        if var dict = self.cartProductsArray[sender.tag] as? JSONDictionary {
            dict["returnToStock"] = sender.isSelected
            self.cartProductsArray[sender.tag] = dict as AnyObject
        }
        
        DataManager.cartProductsArray = self.cartProductsArray
        isAddSubscription = false
        tabelView.reloadData()
    }
    
    @objc func btn_ShowDetailsAction(sender: UIButton)
    {
        print("enter Btn Click")
        setView(view: showDetailsContainer, hidden: false)
        self.showDetailsDelegateOne?.didShowDetailsAtrribute?(index: sender.tag, cartArray: [cartProductsArray[sender.tag] as AnyObject])
    }
    
}

//MARK: showDetailsDelegate
extension iPad_PaymentTypesViewController: showDetailsDelegate {
    
    func didShowDetailsAtrribute(index: Int, cartArray: Array<AnyObject>) {
        showDetailsDelegateOne?.didShowDetailsAtrribute?(index: index, cartArray: cartArray)
        setView(view: showDetailsContainer, hidden: false)
    }
}

//MARK: savedCardDelegate
extension iPad_PaymentTypesViewController: savedCardDelegate {
    
    func didCloseSavedCard() {
        self.delegateSavedCard?.didCloseSavedCard!()
        setView(view: SavedCardContainer, hidden: true)
    }
    
    
    
}
//MARK: UITextFieldDelegate
extension iPad_PaymentTypesViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == taxTextField {
            IQKeyboardManager.shared.enableAutoToolbar = false
            IQKeyboardManager.shared.enable = false
        }
        
        switch textField.tag {
        case 1000,2000,3000,4000,6000:
            textField.selectAll(nil)
            break
        default: break
        }
        
        if textField == taxTextField {
            
            if DataManager.isBalanceDueData {
                return
            }
            if isOpenToOrderHistory {
                textField.resignFirstResponder()
                return
            }
            //Enable IQKeyboardManager
            IQKeyboardManager.shared.enableAutoToolbar = false
            if DataManager.isTaxOn
            {
                if self.array_TaxList.count == 0 || self.array_TaxList.count == 1 {
                    textField.resignFirstResponder()
                    //                    self.showAlert(message: "No Tax List found.")
                    appDelegate.showToast(message: "No Tax List found.")
                    return
                }
                self.pickerDelegate = self
                let array = self.array_TaxList.compactMap({$0.tax_title})
                CartContainerViewController.isPickerSelected = true
                self.setPickerView(textField: self.taxTextField, array: array)
            }
            else
            {
                textField.resignFirstResponder()
                //                self.showAlert(message: "Tax setting is OFF")
                appDelegate.showToast(message: "Tax setting is OFF")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == taxTextField {
            IQKeyboardManager.shared.enableAutoToolbar = true
            IQKeyboardManager.shared.enable = true
        }
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            IQKeyboardManager.shared.enableAutoToolbar = false
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Handle Data
        switch textField.tag {
        case 6000:
            let depositeAmount = Double(textField.text ?? "") ?? 0
            self.visualEffectView.removeFromSuperview()
            self.depositeAmountLabel.text = depositeAmount.currencyFormat
            break
        case 2000:
            self.handleShippingAndHandling(textField: textField)
            break
        case 3000:
            self.handleDiscount(textField: textField)
            break
        case 4000:
            self.handleApplyCoupon(textField: textField)
            break
        default: break
        }
        //Remove Alerts
        switch textField.tag {
        case 6000,2000,3000,4000:
            SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
            break
        default: break
        }
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        
        if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }
        
        if string == "\t" {
            return false
        }
        
        if textField.tag == 3000 {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let value = Double(replacementText.replacingOccurrences(of: "$", with: "")) ?? 0
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 15 && (self.isPercentageDiscountApplied ? value <= 100 : value <= SubTotalPrice)
        }
        
        if textField.tag == 2000 || textField.tag == 3000 || textField.tag == 6000  {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 15
        }
        
        return true
    }
    
}
//MARK: PaymentTypeDelegate
extension iPad_PaymentTypesViewController: PaymentTypeDelegate {
    func didPerformSegueWith(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
    
    func sendSignatureScreen(arrcardData: NSMutableArray) {
        
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
    
    func didMoveToSuccessScreen(totalAmount: Double, orderedData: [String : AnyObject], paymentName: String) {
        if str_Auth == "AUTH"{
            let storyboard = UIStoryboard.init(name: "iPad", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AuthorizeViewController") as! AuthorizeViewController
            vc.Orderedobj = orderedData
            HomeVM.shared.customerUserId = ""
            DataManager.Bbpid = ""
            DataManager.EmvCardCount = 0
            DataManager.IngenicoCardCount = 0
            DataManager.CardCount = 0
            self.present(vc, animated: true, completion: nil)
            
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                
                var receiptModelForSocket = ReceiptModelForSocket()
                var orderIdForAuth = ""
                var authCode = ""
                if let id = orderedData["order_id"] as? Int {
                    orderIdForAuth = "\(id)"
                }
                if let id = orderedData["order_id"] as? String {
                    orderIdForAuth = id
                }
                if let authCodeObj = orderedData["auth_code"] as? String {
                    authCode = authCodeObj
                }
                
                receiptModelForSocket.order_id = Double(orderIdForAuth) ?? 0.0
                receiptModelForSocket.session_id = DataManager.sessionID
                receiptModelForSocket.paymentMethod = str_Auth
                receiptModelForSocket.authCode = authCode
                MainSocketManager.shared.onOpenRecieptModal(receiptModelForSocket: receiptModelForSocket)
            }
        }else{
            
            if DataManager.isBalanceDueData == true {
                balanceDueView.isHidden = false
                labelBallanceDueAmt.text = HomeVM.shared.DueShared.currencyFormat
                balanceDue = HomeVM.shared.DueShared
                if HomeVM.shared.tipValue > 0 {
                    tipAmountCreditCard = HomeVM.shared.tipValue
                }
                CancelActionData()
            }
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
            vc.total = totalAmount
            vc.subTotal = SubTotalPrice
            vc.OrderedData = orderedData
            vc.paymentType = paymentName
            if DataManager.isOffline && !NetworkConnectivity.isConnectedToInternet() {
                vc.tax = str_TaxAmount.toDouble()?.rounded(toPlaces: 2) ?? 0.0
            }
            //vc.tax = str_TaxAmount.toDouble()?.rounded(toPlaces: 2) ?? 0.0
            vc.paxDevice = paxDevice
            vc.discountV = discountLabel.text!
            vc.tip = tipAmountCreditCard
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func didOpenErrorAlert(identifier: String) {
        Indicator.sharedInstance.hideIndicator()
        if identifier == "" {
            //            self.showAlert(title: "Oops!", message: "Only Manual Payment Products is available in offline mode.")
            appDelegate.showToast(message: "Only Manual Payment Products is available in offline mode.")
        } else {
            //            self.showAlert(title: "Oops!", message: "Payment with \(identifier.replacingOccurrences(of: "_", with: " ").lowercased().capitalized) is not available in offline mode.")
            appDelegate.showToast(message: "Payment with \(identifier.replacingOccurrences(of: "_", with: " ").lowercased().capitalized) is not available in offline mode.")
        }
    }
    
    func enableCreditCardDelegate() {
        creditCardDelegate?.enableCardReader?()
    }
    
    func gettingErrorDuringPayment(isMulticard: Bool, message: String?, error: NSError?) {
        isPayButtonSelected = false
        if DataManager.isBalanceDueData {
            authButton.isHidden = true
            HomeVM.shared.TotalDue = TotalPrice
            tipAmountCreditCard = HomeVM.shared.tipValue
            self.updateLabels(isUpdateTotal: false)
            self.calculateTotal()
        }
        
        if !isMulticard {
            if message != nil {
                //                self.showAlert(message: message!)
                appDelegate.showToast(message: message!)
                
                // Need Payment Error Socket event emit
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                    MainSocketManager.shared.onPaymentError(errorMessage: message!)
                }
                
                self.loadData()
                
                btn_Cancel.isHidden = false
                if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
                    btn_Cancel.isHidden = true
                }
                appDelegate.isVoidPayment = true
                return
            }else {
                self.showErrorMessage(error: error)
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                    MainSocketManager.shared.onPaymentError(errorMessage: error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg)
                }
                
            }
            return
        }
        self.loadData()
        btn_Cancel.isHidden = false
        if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
            btn_Cancel.isHidden = true
        }
        multicardDelegate?.gettingErrorDuringPayment?(isMulticard: isMulticard, message: message, error: error)
    }
    
    func updateError(textfieldIndex: Int, message: String) {
        isPayButtonSelected = false
        switch str_PaymentName {
        case "CREDIT":
            creditCardDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "CASH":
            cashDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "INVOICE":
            invoiceDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "ACH CHECK":
            achCheckDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "GIFT CARD":
            giftCardDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "EXTERNAL GIFT CARD":
            externalGiftCardDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "INTERNAL GIFT CARD":
            internalGiftCardDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "CHECK":
            checkDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "EXTERNAL":
            externalCardDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "NOTES":
            notesDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "PAX PAY":
            paxDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "MULTI CARD":
            multicardDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        case "CARD READER":
            ingenicoDelegate?.updateError?(textfieldIndex: textfieldIndex, message: message)
            break
            
        default: break
        }
    }
}

//MARK: HieCORPickerDelegate
extension iPad_PaymentTypesViewController : HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        if pickerTextfield.tag == 4000 || pickerTextfield.tag == 10000 {
            let array = HomeVM.shared.coupanList.compactMap({$0.str_coupon_code})
            pickerTextfield.text = array[index]
            return
        }
        taxTextField.text = "\(self.array_TaxList[index].tax_title)"
    }
    
    func didClickOnPickerViewDoneButton() {
        self.view.endEditing(true)
        if pickerTextfield.tag == 4000 {
            self.handleApplyCoupon(textField: pickerTextfield)
            pickerTextfield.resignFirstResponder()
            SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
            return
        }
        
        if pickerTextfield == taxTextField {
            
            if (pickerView.selectedRow(inComponent: 0) == 0)
            {
                for i in (0..<self.array_TaxList.count)
                {
                    let taxes = self.array_TaxList[i]
                    
                    if(taxes.tax_title == "countrywide")
                    {
                        self.taxTitle = "Default"
                        self.taxType = taxes.tax_type
                        self.taxAmountValue = taxes.tax_amount
                    }
                }
                isDefaultTaxChanged = false
                isDefaultTaxSelected = true
                self.taxTitle = "Default"
                self.taxNameLabel.text = "Tax (Default)"
                if CustomerObj.userCustomTax != "" {
                    CustomerObj.userCustomTax = taxTitle
                }
            }
            else
            {
                let str = self.array_TaxList[pickerView.selectedRow(inComponent: 0)]
                taxTitle = str.tax_title
                taxType = str.tax_type
                taxAmountValue = str.tax_amount
                isDefaultTaxChanged = true
                isDefaultTaxSelected = false
                self.taxNameLabel.text = "Tax (\(str.tax_title))"
                if CustomerObj.userCustomTax != "" {
                    CustomerObj.userCustomTax = taxTitle
                }
            }
            taxTextField.resignFirstResponder()
            isAddSubscription = false
            tabelView.reloadData()
            calculateTotalCart()
        }
        self.delegate?.didUpdateTax?(amount: Double(taxAmountValue) ?? 0, type: taxType, title: taxTitle)
    }
    
    func didClickOnPickerViewCancelButton() {
        if pickerTextfield.tag == 4000 || pickerTextfield.tag == 10000 {
            pickerTextfield.text = ""
            self.view.endEditing(true)
            self.visualEffectView.removeFromSuperview()
            SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
            return
        }
        
        pickerTextfield.text = ""
        pickerTextfield.resignFirstResponder()
        self.visualEffectView.removeFromSuperview()
    }
}

//MARK: API Method
extension iPad_PaymentTypesViewController {
    func callAPIToGetTaxList(textfield: UITextField? = nil) {
        HomeVM.shared.getTaxList { (success, message, error) in
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                //Update Data
                self.array_TaxList = [TaxListModel]()
                let taxModelObj = TaxListModel()
                taxModelObj.tax_title = "Default"
                taxModelObj.tax_type = "Fixed"
                taxModelObj.tax_amount = "0"
                self.array_TaxList.insert(taxModelObj, at: 0)
                
                for tax in HomeVM.shared.taxList {
                    self.array_TaxList.append(tax)
                }
                
                if self.array_TaxList.count > 1 {
                    if textfield != nil {
                        DispatchQueue.main.async {
                            self.pickerDelegate = self
                            let array = self.array_TaxList.compactMap({$0.tax_title})
                            self.setPickerView(textField: textfield!, array: array)
                        }
                    }
                }
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
    
    func callAPItoGetCoupanProductIds(coupan: String) {
        self.resetCoupan()
        
        let text = coupan.trimmingCharacters(in: .whitespaces)
        if text == "" {
            self.calculateTotalCart()
            return
        }
        
        var strCoupon = ""
        print(strCoupon)
        
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        
        if let escapedString = text.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            //do something with escaped string
            strCoupon = escapedString
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            HomeVM.shared.getCoupanProductIDList(coupan: text, responseCallBack: { (success, message, error) in
                if success == 1 {
                    self.str_CouponDiscount = HomeVM.shared.coupanDetail.amount
                    self.str_AddCouponName = coupan
                    self.delegate?.didUpdateCoupon?(name: coupan, amount: Double(HomeVM.shared.coupanDetail.amount) ?? 0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.calculateTotalCart()
                    }
                }else {
                    if message != nil {
                        //                        self.showAlert(message: message!)
                        DispatchQueue.main.async {
                            appDelegate.showToast(message: message!)
                        }
                        
                    }else {
                        DispatchQueue.main.async {
                            self.showErrorMessage(error: error)
                        }
                    }
                }
            })
        }
    }
    
    func resetCoupan() {
        //Reset Coupan
        self.crossButton.isHidden = true
        self.str_AddCouponName = ""
        self.taxableCouponTotal = 0.0
        self.couponNameLabel.text = "Apply Coupon"
        self.couponAmountLabel.text = "$0.00"
        self.crossButton.isHidden = true
        self.str_CouponDiscount = ""
        self.calculateTotalCart()
        self.delegate?.didUpdateCoupon?(name: "", amount: 0)
    }
}

//MARK: AddDiscountPopupVCDelegate
extension iPad_PaymentTypesViewController: AddDiscountPopupVCDelegate {
    func didSelectManualPrcentageDiscount() {
        controller?.dismiss(animated: true, completion: nil)
        self.isPercentageDiscountApplied = true
        self.handleAddDiscountAction()
    }
    
    func didSelectManualFlatDiscount() {
        controller?.dismiss(animated: true, completion: nil)
        self.isPercentageDiscountApplied = false
        self.handleAddDiscountAction()
    }
    
    func didSelectApplyCoupon() {
        controller?.dismiss(animated: true, completion: nil)
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        self.showApplyCouponIPad()
    }
}

//MARK: UIPopoverControllerDelegate
extension iPad_PaymentTypesViewController {
    override func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
    
    override func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

//MARK: Caculate Cart Total
extension iPad_PaymentTypesViewController {
    
    func calculateTotalCart() {
        
        if orderType == .newOrder {
            if let array = DataManager.cartProductsArray {
                cartProductsArray = array
            }
            
            if DataManager.customerObj == nil && !isDefaultTaxChanged {
                updateDefaultTax()
            }
            
            if DataManager.customerObj != nil && !isDefaultTaxChanged {
                //Update User Custom Tax
                if !(taxNameLabel.text?.contains("Default"))! {
                    if let userCustomTax = DataManager.customerObj?["user_custom_tax"] as? String {
                        if let index = array_TaxList.index(where: {$0.tax_title == userCustomTax}) {
                            taxType = array_TaxList[index].tax_type
                            taxTitle = array_TaxList[index].tax_title
                            taxAmountValue = array_TaxList[index].tax_amount
                            DataManager.defaultTaxID = array_TaxList[index].tax_title
                        }
                    }
                }
                
                if (taxNameLabel.text?.contains("Default"))! {
                    updateCustomerTax()
                }
            }
        }else {
            if !isDefaultTaxChanged {
                //updateDefaultTax()
            }
        }
        
        self.calculateTotal()
    }
    
    func updateDefaultTax() {
        if let userObject = UserDefaults.standard.value(forKey: "userdata") as? NSData {
            let userdata = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data)
             if appDelegate.isOpenToOrderHistory {
                taxAmountValue = str_TaxAmount
                let title = cartObjectData["taxStateName"]as? String ?? ""
                taxTitle = title == "" ? "Default" : title
                DataManager.defaultTaxID = title
                return
            }
            if appDelegate.isPinlogin {
                appDelegate.isPinlogin = false
            } else {
                if self.taxTitle == "Default" || taxTitle == "countrywide"{
                    if let index = self.array_TaxList.index(where: {$0.tax_title == "countrywide"}) {
                        taxType = self.array_TaxList[index].tax_type
                        taxTitle = "Default"
                        taxAmountValue = self.array_TaxList[index].tax_amount
                        DataManager.defaultTaxID = self.array_TaxList[index].tax_title
                        return
                    }
                    //Default Tax Selected
                    taxType = "Fixed"
                    taxTitle = "Default"
                    taxAmountValue = "0"
                    DataManager.defaultTaxID = "Default"
                    return
                }
            }
            
            
            
            if let id = (userdata as AnyObject).value(forKey: "user_tax_lock") as? String {
                if let index = self.array_TaxList.index(where: {$0.tax_title == id}) {
                    taxType = self.array_TaxList[index].tax_type
                    taxTitle = self.array_TaxList[index].tax_title
                    taxAmountValue = self.array_TaxList[index].tax_amount
                    DataManager.defaultTaxID = self.array_TaxList[index].tax_title
                    return
                }
            }
            
            if let region = (userdata as AnyObject).value(forKey: "region") as? String {
                if let index = self.array_TaxList.index(where: {$0.tax_title == region}) {
                    taxType = self.array_TaxList[index].tax_type
                    taxTitle = "Default"
                    taxAmountValue = self.array_TaxList[index].tax_amount
                    DataManager.defaultTaxID = self.array_TaxList[index].tax_title
                    return
                }
            }
            
            if let city = (userdata as AnyObject).value(forKey: "city") as? String {
                if let index = self.array_TaxList.index(where: {$0.tax_title == city}) {
                    taxType = self.array_TaxList[index].tax_type
                    taxTitle = "Default"
                    taxAmountValue = self.array_TaxList[index].tax_amount
                    DataManager.defaultTaxID = self.array_TaxList[index].tax_title
                    return
                }
            }
            
            if (!NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline) {
                
            } else {
                taxType = "Fixed"
                taxTitle = "Default"
                taxAmountValue = "0"
                DataManager.defaultTaxID = "Default"
            }
            if appDelegate.isOpenToOrderHistory {
                taxAmountValue = str_TaxAmount
                let title = cartObjectData["taxStateName"]as? String ?? ""
                taxTitle = title == "" ? "Default" : title
                DataManager.defaultTaxID = title
            }
            
        }
    }
    
    func updateCustomerTax() {
        let CustomerObj = UserDefaults.standard.object(forKey: "CustomerObj")
        
        if let region = (CustomerObj as AnyObject).value(forKey: "str_region") as? String {
            if let index = self.array_TaxList.index(where: {$0.tax_title == region}) {
                taxType = self.array_TaxList[index].tax_type
                taxTitle = "Default"
                taxAmountValue = self.array_TaxList[index].tax_amount
                DataManager.defaultTaxID = self.array_TaxList[index].tax_title
                return
            }
        }
        
        if let city = (CustomerObj as AnyObject).value(forKey: "str_city") as? String {
            if let index = self.array_TaxList.index(where: {$0.tax_title == city}) {
                taxType = self.array_TaxList[index].tax_type
                taxTitle = "Default"
                taxAmountValue = self.array_TaxList[index].tax_amount
                DataManager.defaultTaxID = self.array_TaxList[index].tax_title
                return
            }
        }
        
        updateDefaultTax()
    }
    
    func taxCouponDataCalculation() -> Double {
        var taxableAmount = 0.0
        var taxDetailAmt = Double()
        var taxNewAmount = Double()
        
        taxableAmtData = 0.0
        
        var subTotal:Double = 0
        var newProductFound = false
        
        for i in (0..<self.cartProductsArray.count) {
            
            let dataprice = 0.0
            
            let obj = (cartProductsArray as AnyObject).object(at: i)
            
            let isRefundProduct = (obj as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
            newProductFound = !isRefundProduct
            var price = Double()
            var qty = Double()
            var strval = didvariationPrizeAtrribute(cartArray: cartProductsArray, index: i)
            print(strval)

            if isRefundProduct {
                price = (obj as AnyObject).value(forKey: "productprice") as? Double ?? 0
                qty = (obj as AnyObject).value(forKey: "productqty") as? Double ?? 0.00
            }else {
                price = Double((obj as AnyObject).value(forKey: "productprice") as? String ?? "0") ?? 0.00
                qty = Double((obj as AnyObject).value(forKey: "productqty") as? String ?? "0") ?? 0.00
            }
            strval = strval * qty
            let taxable = (obj as AnyObject).value(forKey: "productistaxable") as? String ?? ""
            let isTaxExempt = (obj as AnyObject).value(forKey: "isTaxExempt") as? String ?? "No"
            let id = (obj as AnyObject).value(forKey: "productid") as? String ?? "0"
            
            if HomeVM.shared.coupanDetail.productList.contains(where: {(Int($0) ?? -1) == (Int(id) ?? -2)}) {
                
            } else {
                print("product name data === ")
            }
            
            var total = qty * price
            subTotal = total + subTotal
            
            var taxDetails = JSONDictionary()
            if versionOb > 3 {
                taxDetails = (obj as AnyObject).value(forKey: "tax_detail") as? JSONDictionary ?? [:]
            }
            
            var IsTaxApply = false
            
            if str_TaxPercentage == "0"  && taxTitle != "Default"{
                IsTaxApply = true
            }
            
            if !IsTaxApply {
                if (taxable == "Yes") && (isTaxExempt == "No") {
                    taxNewAmount += total
                    if taxDetails.count == 0 {
                        if HomeVM.shared.coupanDetail.productList.contains(where: {(Int($0) ?? -1) == (Int(id) ?? -2)}) {
                            print(taxDetails.count)
                            total = total - strval
                            let valTo = discountPointTaxable * total
                            total = total - valTo
                            taxableAmount += total
                            
                            if (taxType == "Percentage") {
                                taxDef = 0.0
                                total = total * (Double(str_TaxPercentage) ?? 0) / 100
                                total = total > 0 ? total : 0
                                //taxDef = tax
                                total = total.roundedTax()
                                taxableAmtData += total
                                str_TaxAmount = taxableAmtData.currencyFormatA
                                
                            }
                            
                            if (taxType == "Fixed") {
                                taxDef = 0.0
                                if versionOb < 4 {
                                    total = (Double(str_TaxPercentage) ?? 0)
                                    total = total > 0 ? total : 0
                                    
                                    total = total.roundedTax()
                                    taxableAmtData = total
                                    //taxDef = tax
                                    str_TaxAmount = taxableAmtData.currencyFormatA
                                } else {
                                    if taxableAmount > 0.0 {
                                        total = (Double(str_TaxPercentage) ?? 0)
                                        total = total > 0 ? total : 0
                                        //taxDef = tax
                                        total = total.roundedTax()
                                        taxableAmtData = total
                                        //taxDef = tax
                                        str_TaxAmount = taxableAmtData.currencyFormatA
                                    }
                                }
                            }
                        } else {
                            print("product name data === ")
                            print(taxDetails.count)
                            total = total - strval
                            let valTo = discountPointWithoutCouponTaxable * total
                            total = total - valTo
                            taxableAmount += total
                            
                            if (taxType == "Percentage") {
                                taxDef = 0.0
                                total = total * (Double(str_TaxPercentage) ?? 0) / 100
                                total = total > 0 ? total : 0
                                //taxDef = tax
                                total = total.roundedTax()
                                taxableAmtData += total
                                str_TaxAmount = taxableAmtData.currencyFormatA
                                
                            }
                            
                            if (taxType == "Fixed") {
                                taxDef = 0.0
                                if versionOb < 4 {
                                    total = (Double(str_TaxPercentage) ?? 0)
                                    total = total > 0 ? total : 0
                                    
                                    total = total.roundedTax()
                                    taxableAmtData = total
                                    //taxDef = tax
                                    str_TaxAmount = taxableAmtData.currencyFormatA
                                } else {
                                    if taxableAmount > 0.0 {
                                        total = (Double(str_TaxPercentage) ?? 0)
                                        total = total > 0 ? total : 0
                                        //taxDef = tax
                                        total = total.roundedTax()
                                        taxableAmtData = total
                                        //taxDef = tax
                                        str_TaxAmount = taxableAmtData.currencyFormatA
                                    }
                                }
                            }
                        }
                        
                    } else {
                        if HomeVM.shared.coupanDetail.productList.contains(where: {(Int($0) ?? -1) == (Int(id) ?? -2)}) {
                            print(taxDetails.count)
                            taxDetailAmt += total
                            let typeT = taxDetails["type"] as? String
                            let AmtT = taxDetails["amount"] as? Double
                            let valTo = discountPointTaxable * total
                            
                            total = total - valTo
                            print(typeT)
                            
                            if (typeT == "Percentage") {
                                var taxd = 0.0
                                taxd = AmtT ?? 0.0
                                
                                taxd = (taxd * total) / 100
                                taxd = taxd > 0 ? taxd : 0
                                taxableAmtData += taxd
                            }
                            
                            if (typeT == "Fixed") {
                                var taxd = 0.0
                                if versionOb < 4 {
                                    taxd = AmtT ?? 0.0
                                    taxableAmtData += taxd
                                    //taxd = taxd.rounded(toPlaces: 2)
                                    //str_TaxAmount = taxd.currencyFormatA
                                } else {
                                    //if taxableAmount > 0.0 {
                                    taxd = AmtT ?? 0.0
                                    taxableAmtData += taxd
                                    //                                taxd = taxd.rounded(toPlaces: 2)
                                    //                                str_TaxAmount = taxd.currencyFormatA
                                    //}
                                }
                                //str_TaxAmount = tax.roundToTwoDecimal change by Devendra (rond function)
                            }
                        } else {
                            print("product name data === ")
                            
                            print(taxDetails.count)
                            taxDetailAmt += total
                            let typeT = taxDetails["type"] as? String
                            let AmtT = taxDetails["amount"] as? Double
                            let valTo = discountPointWithoutCouponTaxable * total
                            
                            total = total - valTo
                            print(typeT)
                            
                            if (typeT == "Percentage") {
                                var taxd = 0.0
                                taxd = AmtT ?? 0.0
                                
                                taxd = (taxd * total) / 100
                                taxd = taxd > 0 ? taxd : 0
                                taxableAmtData += taxd
                            }
                            
                            if (typeT == "Fixed") {
                                var taxd = 0.0
                                if versionOb < 4 {
                                    taxd = AmtT ?? 0.0
                                    taxableAmtData += taxd
                                    //taxd = taxd.rounded(toPlaces: 2)
                                    //str_TaxAmount = taxd.currencyFormatA
                                } else {
                                    //if taxableAmount > 0.0 {
                                    taxd = AmtT ?? 0.0
                                    taxableAmtData += taxd
                                    //                                taxd = taxd.rounded(toPlaces: 2)
                                    //                                str_TaxAmount = taxd.currencyFormatA
                                    //}
                                }
                                //str_TaxAmount = tax.roundToTwoDecimal change by Devendra (rond function)
                            }
                        }
                    }
                    //taxableAmount += total
                }
            }
            
        }
        
        return taxableAmount
    }
    func didvariationPrizeAtrribute(cartArray: Array<Any>, index:Int) -> Double {
        var newString = ""
        var amount = 0.0
        radioCount = 0
        arrTempAttId.removeAll()
        arrTempVarId.removeAll()

        print(cartArray)
                        
        if let dictArray = (cartArray[index] as AnyObject).value(forKey: "attributesArray") as? [JSONDictionary] {
            
            for dict in dictArray {
                if let jsonArray = dict["values"] as? JSONArray {
                    for value in jsonArray {
                        let tyoe = value["attributeType"] as? String ?? ""
                        var name = ""
                        
                        if tyoe == "radio" {
                            if let data = value["jsonArray"] as? JSONArray {
                                for val in data {
                                    let select = val["isSelect"] as? Bool
                                    let attribute_value_id = val["attribute_value_id"] as? String
                                    if select == true {
                                        radioCount += 1
                                        arrTempAttId.append(attribute_value_id!)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            for dict in dictArray {
                
                
                if let jsonArray = dict["values"] as? JSONArray {
                    
                    for value in jsonArray {
                        let tyoe = value["attributeType"] as? String ?? ""
                        var name = ""
                        
                        let key = value["attributeName"] as? String ?? ""
                        if let data = value["jsonArray"] as? JSONArray {
                            for val in data {
                                let select = val["isSelect"] as? Bool
                                if select == true {
                                    name = val["attribute_value"] as? String ?? ""
                                   // isShowDetails = select!
                                   // newString.append("\(key): \(name)\n")
                                    
        //------ sudama add surcharge variation value start ------//
                                    
                                    //newString.append("\(key): \(name)\n")
                                    var surchargVariationValue = ""
                                    let aatrVariId =  val["attribute_value_id"] as? String ?? ""
                                    if let dictArraysurch = (cartArray[index] as AnyObject).value(forKey: "surchargVariationArray") as? [JSONDictionary] {
                                        for dict in dictArraysurch {
                                            if let jsonArray = dict["values"] as? JSONArray {
                                                for value in jsonArray {
                                                    let valueSur = value["variation_price_surchargeClone"] as? String ?? ""
                                                    
                                                    for value in jsonArray {
                                                        if let data = value["jsonArray"] as? JSONArray {
                                                            for val in data {
                                                                let select = val["isSelect"] as? Bool
                                                                let attribute_value_id = val["attribute_value_id"] as? String ?? ""
                                                                if attribute_value_id == aatrVariId {
                                                                    if let isTaxVal = value["variation_taxable"] as? Bool {
                                                                        print(isTaxVal)
                                                                        if !isTaxVal {
                                                                            if let prize = value["variation_price_surchargeClone"] as? String {
                                                                                print(prize)
                                                                                let DPrize = Double(prize) ?? 0.0
                                                                                //amount += DPrize
                                                                                let priceVar = Double((cartArray[0] as AnyObject).value(forKey: "mainprice") as? String ?? "0") ?? 0.00
                                                                                //amount += priceVar
                                                                                amount += Double(valueSur) ?? 0.0
                                                                            }
                                                                        }
                                                                    }
                                                                    surchargVariationValue = " $\(valueSur)"
                                                                    
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                    newString.append("\(key): \(name)\(surchargVariationValue)\n")
    //------ sudama add surcharge variation value start ------//
                                }
                            }
                        }
                        if tyoe == "text" {
                            name = value["attribute_value"] as? String ?? ""
                            if name != "" {
                                newString.append("\(key): \(name)\n")
                            }
                        }else if tyoe == "text_calendar" {
                            name = value["attribute_value"] as? String ?? ""
                            if name != "" {
                               // isShowDetails = true
                               newString.append("\(key): \(name)\n")
                            }
                        }
                    }
                }
                //  newString.append("| \(key): \(name) ")
            }
        }
        if let dictArraysurch = (cartArray[index] as AnyObject).value(forKey: "variationArray") as? [JSONDictionary] {
            for dict in dictArraysurch {
                if let jsonArray = dict["values"] as? JSONArray {
                    for value in jsonArray {
                        let valueSur = value["variationPriceSurcharge"] as? String ?? ""
                        
                        //for value in jsonArray {
                            if let data = value["jsonArray"] as? JSONArray {
                                
                                let count = data.count
                                
                                if count == radioCount {
                                    arrTempVarId.removeAll()
                                    for val in data {
                                        let select = val["isSelect"] as? Bool
                                        let attribute_value_id = val["attribute_value_id"] as? String ?? ""
                                        arrTempVarId.append(attribute_value_id)
                                    }
                                    
                                    arrTempAttId = arrTempAttId.sorted()
                                    arrTempVarId = arrTempVarId.sorted()
                                    
                                    if arrTempAttId == arrTempVarId {
                                        if let isTaxVal = value["variation_taxable"] as? Bool {
                                            print(isTaxVal)
                                            if !isTaxVal {
                                                if let isvariationUseParentPrice = value["variationUseParentPrice"] as? String {
                                                    if isvariationUseParentPrice == "Yes" {
                                                        if let prize = (cartArray[index] as AnyObject).value(forKey: "mainprice") as? String {
                                                            print(prize)
                                                            
                                                            let DPrize = Double(prize) ?? 0.0
                                                            //amount += DPrize
                                                            let priceVar = Double(value["variationOriginalPrice"] as? String ?? "0") ?? 0.00
                                                            amount += DPrize
                                                            amount += Double(valueSur) ?? 0.0
                                                        }
                                                    } else {
                                                        if let prize = value["variationPriceSurcharge"] as? String {
                                                            print(prize)
                                                            
                                                            let DPrize = Double(prize) ?? 0.0
                                                            //amount += DPrize
                                                            let priceVar = Double(value["variationOriginalPrice"] as? String ?? "0") ?? 0.00
                                                            amount += priceVar
                                                            amount += Double(valueSur) ?? 0.0
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                    
                            }
                        //}
                    }
                }
                
            }
        }
        return amount
    }
    
    func taxDataCalculation() -> Double {
        var taxableAmount = 0.0
        var taxDetailAmt = Double()
        var taxNewAmount = Double()
        
        taxableAmtData = 0.0
        if isOpenToOrderHistory {
            str_TaxAmount = taxAmountValue
            taxableAmtData = taxAmountValue.toDouble() ?? 0
            return taxableAmtData
        }
        var subTotal:Double = 0
        var newProductFound = false
        
        for i in (0..<self.cartProductsArray.count) {
            
            let dataprice = 0.0
            
            let obj = (cartProductsArray as AnyObject).object(at: i)
            
            let isRefundProduct = (obj as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
            newProductFound = !isRefundProduct
            var price = Double()
            var qty = Double()
            var strval = didvariationPrizeAtrribute(cartArray: cartProductsArray, index: i)
            print(strval)
            if isRefundProduct {
                price = (obj as AnyObject).value(forKey: "productprice") as? Double ?? 0
                qty = (obj as AnyObject).value(forKey: "productqty") as? Double ?? 0.00
            }else {
                price = Double((obj as AnyObject).value(forKey: "productprice") as? String ?? "0") ?? 0.00
                qty = Double((obj as AnyObject).value(forKey: "productqty") as? String ?? "0") ?? 0.00
            }
            strval = strval * qty
            let taxable = (obj as AnyObject).value(forKey: "productistaxable") as? String ?? ""
            let isTaxExempt = (obj as AnyObject).value(forKey: "isTaxExempt") as? String ?? "No"
            
            var total = qty * price
            subTotal = total + subTotal
            
            var taxDetails = JSONDictionary()
            if versionOb > 3 {
                taxDetails = (obj as AnyObject).value(forKey: "tax_detail") as? JSONDictionary ?? [:]
            }
            
            var IsTaxApply = false
            
            if str_TaxPercentage == "0"  && taxTitle != "Default"{
                IsTaxApply = true
            }
            
            if !IsTaxApply {
                if (taxable == "Yes") && (isTaxExempt == "No") {
                    taxNewAmount += total
                    if taxDetails.count == 0 {
                        print(taxDetails.count)
                        total = total - strval
                        let valTo = discountPointTaxable * total
                        total = total - valTo
                        taxableAmount += total
                        
                        if (taxType == "Percentage") {
                            //taxDef = 0.0
                            total = total * (Double(str_TaxPercentage) ?? 0) / 100
                            total = total > 0 ? total : 0
//                            var strT = "\(total)"
//                            var strIn = ""
//                            if let range = strT.range(of: ".") {
//                                let num = strT[range.upperBound...]
//                                print(num)
//                                strT = String(num)
//                            }
//
//                            strIn = strT[0 ..< 3]
//                            var newtaxTotal = total.rounded(toPlaces: 3)
//
//                            let strLastDigitFive = strIn.last
//                            if strLastDigitFive == "5" {
//                                newtaxTotal = newtaxTotal + 0.001
//                                newtaxTotal = newtaxTotal.rounded(toPlaces: 2)
//                                total = newtaxTotal
//                            } else {
//                                total = total.rounded(toPlaces: 2)
//                            }
                            //total = total.rounded(toPlaces: 2)
                            //taxDef = tax
                            taxableAmtData += total
                            str_TaxAmount = taxableAmtData.roundToTwoDecimal
                            
                        }
                        //        //If Tax Type Fixed
                        //        if (taxType == "Fixed") {
                        //            tax = (Double(str_TaxPercentage) ?? 0)
                        //            tax = tax > 0 ? tax : 0
                        //            str_TaxAmount = tax.roundToTwoDecimal
                        //        }
                        if (taxType == "Fixed") {
                            // taxDef = 0.0
                            if versionOb < 4 {
                                total = (Double(str_TaxPercentage) ?? 0)
                                total = total > 0 ? total : 0
                                total = total.roundedTax()
                                //taxDef = total
                                taxableAmtData += total
                                str_TaxAmount = taxableAmtData.roundToTwoDecimal
                            } else {
                                if taxableAmount > 0.0 {
                                    total = (Double(str_TaxPercentage) ?? 0)
                                    total = total > 0 ? total : 0
                                    
                                    total = total.roundedTax()
                                    taxableAmtData += total
                                    str_TaxAmount = taxableAmtData.roundToTwoDecimal
                                }
                            }
                            
                        }
                        
                    } else {
                        print(taxDetails.count)
                        taxDetailAmt += total
                        let typeT = taxDetails["type"] as? String
                        let AmtT = taxDetails["amount"] as? Double
                        total = total - strval
                        let valTo = discountPointTaxable * total
                        
                        total = total - valTo
                        print(typeT)
                        
                        if (typeT == "Percentage") {
                            var taxd = 0.0
                            taxd = AmtT ?? 0.0
                            
                            taxd = (taxd * total) / 100
                            taxd = taxd > 0 ? taxd : 0
                            taxableAmtData +=  taxd.roundedTax()
                        }
                        
                        if (typeT == "Fixed") {
                            var taxd = 0.0
                            if versionOb < 4 {
                                taxd = AmtT ?? 0.0
                                taxableAmtData += taxd
                                //taxd = taxd.rounded(toPlaces: 2)
                                //str_TaxAmount = taxd.currencyFormatA
                            } else {
                                //if taxableAmount > 0.0 {
                                taxd = AmtT ?? 0.0
                                taxableAmtData += taxd.rounded(toPlaces: 2)
                                //                                taxd = taxd.rounded(toPlaces: 2)
                                //                                str_TaxAmount = taxd.currencyFormatA
                                //}
                            }
                            //str_TaxAmount = tax.roundToTwoDecimal change by Devendra (rond function)
                        }
                        
                    }
                    //taxableAmount += total
                }
            }
            
        }
        
        return taxableAmount
    }
    
    func getVariationDatForSocketEvent(indexSocket: Int){
        let cartProductsArray = self.cartProductsArray[indexSocket]
        
        let isRefundProduct = (cartProductsArray as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
        
        //var newString = ""
        var isShowDetails = false
        dictSocket.removeAll()
        productsArraySocket.removeAll()
        if !isRefundProduct {   //New Product
            // let cell = tableView.dequeueReusableCell(withIdentifier: "cartcell", for: indexPath) as! CartTableCell
            
            
            if let dictArray = (cartProductsArray as AnyObject).value(forKey: "itemMetaFieldsArray") as? [JSONDictionary] {
                print(dictArray)
                for dict in dictArray {
                    print(dict)
                    if let jsonArray = dict["values"] as? JSONArray {
                        for value in jsonArray {
                            let keyMeta = value["label"] as? String ?? ""
                            let valueMeta = value["tempValue"] as? String ?? ""
                            
                            if valueMeta != "" {
                                dictSocket["key"] = keyMeta
                                dictSocket["value"] = valueMeta
                                productsArraySocket.append(dictSocket) // Customer
                            }
                            
                            print(productsArraySocket)
                        }
                    }
                }
            }
            if let dictArray = (cartProductsArray as AnyObject).value(forKey: "attributesArray") as? [JSONDictionary] {
                
                for dict in dictArray {
                    
                    
                    if let jsonArray = dict["values"] as? JSONArray {
                        
                        for value in jsonArray {
                            let tyoe = value["attributeType"] as? String ?? ""
                            var name = ""
                            
                            let key = value["attributeName"] as? String ?? ""
                            if let data = value["jsonArray"] as? JSONArray {
                                for val in data {
                                    let select = val["isSelect"] as? Bool
                                    if select == true {
                                        name = val["attribute_value"] as? String ?? ""
                                        isShowDetails = select!
                                        // newString.append("\(key): \(name)\n") // poS
                                        //------ sudama add surcharge variation value start ------//
                                                                    
                                                                    //newString.append("\(key): \(name)\n")
                                                                    var surchargVariationValue = ""
                                                                    let aatrVariId =  val["attribute_value_id"] as? String ?? ""
                                                                    if let dictArraysurch = (cartProductsArray as AnyObject).value(forKey: "surchargVariationArray") as? [JSONDictionary] {
                                                                        for dict in dictArraysurch {
                                                                            if let jsonArray = dict["values"] as? JSONArray {
                                                                                for value in jsonArray {
                                                                                    let valueSur = value["variation_price_surchargeClone"] as? String ?? ""
                                                                                    
                                                                                    for value in jsonArray {
                                                                                        if let data = value["jsonArray"] as? JSONArray {
                                                                                            for val in data {
                                                                                                let select = val["isSelect"] as? Bool
                                                                                                let attribute_value_id = val["attribute_value_id"] as? String ?? ""
                                                                                                if attribute_value_id == aatrVariId {
                                                                                                    surchargVariationValue = " $\(valueSur)"
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                   // newString.append("\(key): \(name)\(surchargVariationValue)\n")
                                    //------ sudama add surcharge variation value start ------//
                                        dictSocket["key"] = key
                                       // dictSocket["value"] = name
                                        dictSocket["value"] =  "\(name)\(surchargVariationValue)"
                                        productsArraySocket.append(dictSocket) // Customer
                                        print(productsArraySocket)
                                    }
                                }
                            }
                            if tyoe == "text" {
                                name = value["attribute_value"] as? String ?? ""
                                if name != "" {
                                    dictSocket["key"] = key
                                    dictSocket["value"] = name
                                    productsArraySocket.append(dictSocket) // Customer
                                    print(productsArraySocket)
                                }
                            } else if tyoe == "text_calendar" {
                                name = value["attribute_value"] as? String ?? ""
                                if name != "" {
                                    dictSocket["key"] = key
                                    dictSocket["value"] = name
                                    productsArraySocket.append(dictSocket) // Customer
                                    print(productsArraySocket)
                                }
                            }
                        }
                    }
                    //  newString.append("| \(key): \(name) ")
                }
            }
            
            
        }
        MainproductsArraySocket[indexSocket] = productsArraySocket
    }
    
    func calculateTotal() {
        if orderType == .refundOrExchangeOrder {
            self.calculateRefundExchangeTotal()
            return
        }
        
        print("****************************************************** Start Calculation ******************************************************")
        self.shippingView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        
        if cartProductsArray.count == 0 {
            self.str_AddDiscount = ""
            self.discountLabel.text = "$0.00"
            self.isShippingPriceChanged = false
            self.str_ShippingANdHandling = ""
            self.shippingLabel.text = "$0.00"
        }
        
        if HomeVM.shared.coupanDetail.code == nil || HomeVM.shared.coupanDetail.code == "" {
            
        } else {
            str_AddCouponName = HomeVM.shared.coupanDetail.code
        }
        // Start ..... by priya loyalty change
        strCustLoyaltyBalance = CustomerObj.str_loyalty_balance
        doubleCustLoyaltyBalance = CustomerObj.doubleloyalty_balance
        //end......priya
        
        //Update Shipping
        updateShippingTotal()
        //Update Coupon
        updateCouponTotal()
        //Reset Values
        SubTotalPrice = 0.0
        str_TaxAmount = "0.00"
        str_TaxPercentage = taxAmountValue as String
        
        subTotalLoyaltyCredit = 0
        subTotalLoyaltyPurchase = 0
        
        var taxableAmount = Double()
        var taxDetailAmt = Double()
        var taxNewAmount = Double()
        
        var subTotal:Double = 0
        var newProductFound = false
        
        print("************************ Cart Products Start **********************")
        print(cartProductsArray)
        print("************************ Cart Products End ************************")
        
        //Taxable & Non Taxable Amount
        for i in (0..<self.cartProductsArray.count) {
            let obj = (cartProductsArray as AnyObject).object(at: i)
            
            let isRefundProduct = (obj as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
            newProductFound = !isRefundProduct
            var price = Double()
            var qty = Double()
            if isRefundProduct {
                price = (obj as AnyObject).value(forKey: "productprice") as? Double ?? 0
                qty = (obj as AnyObject).value(forKey: "productqty") as? Double ?? 0.00
            }else {
                price = Double((obj as AnyObject).value(forKey: "productprice") as? String ?? "0") ?? 0.00
                qty = Double((obj as AnyObject).value(forKey: "productqty") as? String ?? "0") ?? 0.00
            }
            
            let taxable = (obj as AnyObject).value(forKey: "productistaxable") as? String ?? ""
            let isTaxExempt = (obj as AnyObject).value(forKey: "isTaxExempt") as? String ?? "No"
            
            let total = qty * price
            subTotal = total + subTotal
            
            var taxDetails = JSONDictionary()
            if versionOb > 3 {
                taxDetails = (obj as AnyObject).value(forKey: "tax_detail") as? JSONDictionary ?? [:]
            }
            
            if (taxable == "Yes") && (isTaxExempt == "No") {
                taxNewAmount += total
                if taxDetails.count == 0 {
                    print(taxDetails.count)
                    taxableAmount += total
                } else {
                    print(taxDetails.count)
                    taxDetailAmt += total
                    let typeT = taxDetails["type"] as? String
                    let AmtT = taxDetails["amount"] as? Double
                    
                    print(typeT)
                    
                    if (typeT == "Percentage") {
                        var taxd = 0.0
                        taxd = AmtT ?? 0.0
                        
                        taxd = (taxd * total) / 100
                        taxd = taxd > 0 ? taxd : 0
                        taxableAmtData += taxd
                    }
                    
                    if (typeT == "Fixed") {
                        var taxd = 0.0
                        if versionOb < 4 {
                            taxd = AmtT ?? 0.0
                            taxableAmtData += taxd
                            //taxd = taxd.rounded(toPlaces: 2)
                            //str_TaxAmount = taxd.currencyFormatA
                        } else {
                            //if taxableAmount > 0.0 {
                            taxd = AmtT ?? 0.0
                            taxableAmtData += taxd
                            //                                taxd = taxd.rounded(toPlaces: 2)
                            //                                str_TaxAmount = taxd.currencyFormatA
                            //}
                        }
                        //str_TaxAmount = tax.roundToTwoDecimal change by Devendra (rond function)
                    }
                    
                }
                //taxableAmount += total
            }
            
            // Start ..... by priya loyalty change
            isLoyaltyAllowCreditProduct = (obj as AnyObject).value(forKey: "allow_credit_product") as? Bool ?? false
            isLoyaltyAllowPurchaseProduct = (obj as AnyObject).value(forKey: "allow_purchase_product") as? Bool ?? false
            
            if isLoyaltyAllowCreditProduct {
                loyaltyStoredCreditView.isHidden = false
                lblLoyaltyStroreCredit.isHidden = false
                let total = qty * price
                subTotalLoyaltyCredit = total + subTotalLoyaltyCredit
                allowPurchaseTotalLoyalty = total + subTotalLoyaltyPurchase
            }else{
                loyaltyStoredCreditView.isHidden = true
                lblLoyaltyStroreCredit.isHidden = true
            }
            if isLoyaltyAllowPurchaseProduct {
                loyaltyStoredCreditView.isHidden = false
                lblLoyaltyStroreCredit.isHidden = false
                let total = qty * price
                subTotalLoyaltyPurchase = total + subTotalLoyaltyPurchase
                allowPurchaseTotalLoyalty = total + subTotalLoyaltyPurchase
            }else{
                loyaltyStoredCreditView.isHidden = true
                lblLoyaltyStroreCredit.isHidden = true
            }
        }
        
        
        if isLoyaltyAllowPurchaseProduct{
            if DataManager.loyaltyPercentSaving == "" {
                loyaltyStoredCreditView.isHidden = true
                lblLoyaltyStroreCredit.isHidden = true
            } else {
                if let ob = DataManager.loyaltyPercentSaving {
                    subTotalLoyaltyCredit = (subTotalLoyaltyCredit*Double(ob)!)/100
                    subTotalLoyaltyPurchase = (subTotalLoyaltyPurchase*Double(ob)!)/100
                }
                
                if let amount = DataManager.loyaltyMaxSaveOrder {
                    if subTotalLoyaltyPurchase < Double(amount) ?? 0.0{
                        loyaltyStoredCreditView.isHidden = false
                        lblLoyaltyStroreCredit.isHidden = false
                        lblLoyaltyStroreCredit.text = subTotalLoyaltyCredit.currencyFormat
                        
                        if strCustLoyaltyBalance != ""{
                            totalLoyalty = subTotalLoyaltyCredit + (Double(strCustLoyaltyBalance) ?? 0.0)//Double(strCustLoyaltyBalance) ?? 0.0 + subTotalLoyaltyCredit
                        }else{
                            totalLoyalty = doubleCustLoyaltyBalance + subTotalLoyaltyCredit
                        }
                    }
                    if Double(amount) ?? 0.0 < subTotalLoyaltyPurchase{
                        lblLoyaltyStroreCredit.text = Double(amount)?.currencyFormat
                        subTotalLoyaltyPurchase = Double(amount) ?? 0.0
                    }
                    if totalLoyalty > allowPurchaseTotalLoyalty{
                        rewardPoints = allowPurchaseTotalLoyalty
                    }else{
                        rewardPoints = totalLoyalty
                    }
                    if strCustLoyaltyBalance != "" || doubleCustLoyaltyBalance != 0.0{
                        taxableAmount = taxableAmount - rewardPoints
                        print("taxableAmount",taxableAmount)
                    }
                }
            }
        }else{
            loyaltyStoredCreditView.isHidden = true
            lblLoyaltyStroreCredit.isHidden = true
        }
        
        
        if isLoyaltyAllowCreditProduct {
            loyaltyStoredCreditView.isHidden = false
            lblLoyaltyStroreCredit.isHidden = false
        }else{
            loyaltyStoredCreditView.isHidden = true
            lblLoyaltyStroreCredit.isHidden = true
        }
        
        
        // end.....priya
        //Tax
        var tax = Double()
        
        print("Tax Title:",taxTitle ,"Tax Type:",taxType , "& Tax Value:", str_TaxPercentage)
        
        //Manual Discount
        var manualDiscount = self.isPercentageDiscountApplied ? (Double(self.str_AddDiscountPercent) ?? 0.0) : (Double(self.str_AddDiscount) ?? 0.0)
        
        let subTotalONe = subTotal.currencyFormatA
        let stringToDoublTotal = Double(subTotalONe) ?? 0.00
        
        if manualDiscount > 0 {
            if self.isPercentageDiscountApplied {
                manualDiscount = (manualDiscount / 100) * stringToDoublTotal
                manualDiscount = manualDiscount < 0 ? 0 : manualDiscount
            }
            self.str_AddDiscount = "\(manualDiscount)"
            
            discountPointTaxable = manualDiscount/subTotal
            
            let dd = taxDataCalculation()
            
            if manualDiscount > subTotal {
                print("enter value data")
                
                manualDiscount = 0
                
                self.str_AddDiscount = "\(manualDiscount)"
                //self.lbl_AddDiscount.text = manualDiscount.currencyFormat
                
            }
        } else {
            self.str_AddDiscount = "\(manualDiscount)"
        }
        
        //If isCoupanApplyOnAllProducts
        if isCoupanApplyOnAllProducts {
            
            if taxableCouponTotal > 0 {
                discountPointTaxable = taxableCouponTotal/CouponTotal
                
                discountPointTaxable = discountPointTaxable + (manualDiscount/subTotal)
                discountPointWithoutCouponTaxable = manualDiscount/subTotal
                taxableAmount = taxCouponDataCalculation()
                
                tax = taxableAmount
                
                //let newTaxableCouponTotal = valTax * taxableCouponTotal / CouponTotal
                //tax = (taxableAmount.rounded(toPlaces: 2) - newTaxableCouponTotal) - ((manualDiscount/(subTotal - taxableCouponTotal)) * (taxableAmount.rounded(toPlaces: 2) - newTaxableCouponTotal))
            } else {
                let valTax = taxableAmount
                tax = (taxableAmount - taxableCouponTotal) - ((manualDiscount/(subTotal - taxableCouponTotal)) * (valTax - taxableCouponTotal))
            }
            
        }else {
            
            discountPointTaxable = (manualDiscount.rounded(toPlaces: 2) + taxableCouponTotal)/subTotal
            taxableAmount = taxDataCalculation()
            
            tax = taxableAmount
            //let valTax = taxableAmount.rounded(toPlaces: 2)
            //tax = (taxableAmount - taxableCouponTotal) - ((manualDiscount/(subTotal - taxableCouponTotal)) * (valTax - taxableCouponTotal))
        }
        
        // Start ..... by priya loyalty change
        if strCustLoyaltyBalance != "" || doubleCustLoyaltyBalance != 0.0{
            
        }else{
            if (isLoyaltyAllowCreditProduct || isLoyaltyAllowPurchaseProduct) || (isLoyaltyAllowCreditProduct && isLoyaltyAllowPurchaseProduct){
                tax = tax - rewardPoints
            }
        }
        // end ......priya
        //If Tax Type Percentage
        if (taxType == "Percentage") {
            //            taxDef = 0.0
            //            tax = tax * (Double(str_TaxPercentage) ?? 0) / 100
            //            tax = tax > 0 ? tax : 0
            //            tax = tax.rounded(toPlaces: 2)
            //            taxDef = tax
            //            str_TaxAmount = tax.roundToTwoDecimal
            
            if let tax_settings =  HomeVM.shared.taxSetting["tax_settings"] as? JSONDictionary {
                if (tax_settings["charge_shipping_tax"] != nil) {
                    if DataManager.posTaxOnShippingHandlingFunctionality == "true" {
                        var shippingHandlingTax = (Double(str_ShippingANdHandling) ?? 0.0) * ((Double(str_TaxPercentage) ?? 0.0)/100)
                        if orderType == .refundOrExchangeOrder && !shippingRefundButton.isSelected && !newProductFound {
                            shippingHandlingTax = 0
                        }
                        str_TaxAmount = "\(taxableAmtData + shippingHandlingTax)"
                        taxableAmtData = taxableAmtData + shippingHandlingTax
                    }
                }
            }
        }
        
        //        //If Tax Type Fixed
        //        if (taxType == "Fixed") {
        //            tax = (Double(str_TaxPercentage) ?? 0)
        //            tax = tax > 0 ? tax : 0
        //            str_TaxAmount = tax.roundToTwoDecimal
        //        }
        if (taxType == "Fixed") {
            //            taxDef = 0.0
            //            if versionOb < 4 {
            //                tax = (Double(str_TaxPercentage) ?? 0)
            //                tax = tax > 0 ? tax : 0
            //                tax = tax.rounded(toPlaces: 2)
            //                taxDef = tax
            //                str_TaxAmount = tax.currencyFormatA
            //            } else {
            //                if taxableAmount > 0.0 {
            //                    tax = (Double(str_TaxPercentage) ?? 0)
            //                    tax = tax > 0 ? tax : 0
            //
            //                    tax = tax.rounded(toPlaces: 2)
            //                    taxDef = tax
            //                    str_TaxAmount = tax.currencyFormatA
            //                }
            //            }
            //
            if let tax_settings =  HomeVM.shared.taxSetting["tax_settings"] as? JSONDictionary {
                if (tax_settings["charge_shipping_tax"] != nil) {
                    if DataManager.posTaxOnShippingHandlingFunctionality == "true" {
                        if !isOpenToOrderHistory {//condtion for multiple time add shhipping tax when pay invoice from order history
                            var shippingHandlingTax = (Double(str_ShippingANdHandling) ?? 0.0) * ((Double(str_TaxPercentage) ?? 0.0)/100)
                            if orderType == .refundOrExchangeOrder && !shippingRefundButton.isSelected && !newProductFound {
                                shippingHandlingTax = 0
                            }
                            str_TaxAmount = "\(taxableAmtData + shippingHandlingTax)"
                            taxableAmtData = taxableAmtData + shippingHandlingTax
                        }
                        
                    }
                }
            }
            //str_TaxAmount = tax.roundToTwoDecimal change by Devendra (rond function)
        }
        
        
        //Update Subtotal
        SubTotalPrice = subTotal
        //Update Labels
        updateLabels()
        
        print("****************************************************** End Calculation ****************************************************")
    }
    
    func updateLabels(isUpdateTotal: Bool? = true) {
        let couponDiscount = NSString(string: String(describing: taxableCouponTotal))
        var discountAmount = Double(self.str_AddDiscount) ?? 0.00
        let tip = Double((self.tipLabel.text ?? "0.00").replacingOccurrences(of: "$", with: "")) ?? 0.0
        let shipping = Double(shippingLabel.text?.replacingOccurrences(of: "$", with: "") ?? "0") ?? 0
        let taxAmount = NSString(string: str_TaxAmount)
        var subtotal = (SubTotalPrice-discountAmount)-taxableCouponTotal//SubTotalPrice-discountAmount-couponDiscount.doubleValue
        
        if orderType == .newOrder {
            subtotal = subtotal < 0 ? 0 : subtotal
        } else {
            taxDef = Double(str_TaxAmount) ?? 0.0
        }
        if taxDef.isNaN{
            taxDef = 0.0
        }
        let total = shipping + taxDef + taxableAmtData + subtotal
        TotalPrice =  total //+ tip
        
        print(SubTotalPrice - discountAmount)
        
        
        if SubTotalPrice == taxableCouponTotal {
            discountAmount = 0.0
            discountLabel.text = "$0.00"
            //discountView.isHidden = true
        }
        
        if SubTotalPrice == discountAmount {
            taxableCouponTotal = 0.0
            couponAmountLabel.text = "$0.00"
            //discountView.isHidden = true
        }
        
        let CSubTotalPrice = SubTotalPrice.rounded(toPlaces: 2)//Double(SubTotalPrice.currencyFormatA)
        let CcouponDiscount = taxableCouponTotal.rounded(toPlaces: 2)//Double(taxableCouponTotal.currencyFormatA)
        
        let CdiscountAmount = discountAmount.rounded(toPlaces: 2)//Double(discountAmount.currencyFormatA)
        let Cshipping = shipping.rounded(toPlaces: 2)//Double(shipping.currencyFormatA)
        //let CtaxAmount = taxAmount.doubleValue.rounded(toPlaces: 2)//Double(taxAmount.doubleValue.currencyFormatA)
        //        TotalPrice = (Cshipping + CtaxAmount + CSubTotalPrice)
        
        let dataT = taxDef + taxableAmtData
        let CtaxAmount = dataT.rounded(toPlaces: 2)//Double(taxAmount.doubleValue.currencyFormatA)
        
        
        let newtotal = CSubTotalPrice + Cshipping + CtaxAmount //+ tip
        let minusTotal = CdiscountAmount + CcouponDiscount
        var finalTotal = newtotal - minusTotal
        
        if finalTotal < 0 {
            TotalPrice = 0.0
            finalTotal = 0.0
        }
        
        TotalPrice = finalTotal
        let hh = taxableCouponTotal.rounded(toPlaces: 2)
        
        print("final prize change value \(finalTotal)")
        discountLabel.text = discountAmount.currencyFormat
        
        subtotalLabel.text = SubTotalPrice.currencyFormat
        couponAmountLabel.text = couponDiscount == "" ? "$0.00" : hh.currencyFormat
        taxNameLabel.text = (taxTitle == "countrywide" || taxTitle == "Default") ? "Tax (Default)" :  "Tax (\(taxTitle))"
        taxAmountLabel.text =  taxAmount.doubleValue.currencyFormat
        if appDelegate.isOpenToOrderHistory {
            taxableAmtData = taxAmount.doubleValue
        }
        let dataval = taxDef + taxableAmtData
        taxAmountLabel.text = dataval.currencyFormat
        if finalTotal < 0 {
            totalLabel.text =  "$0.00"
        } else {
            totalLabel.text =  finalTotal.currencyFormat
        }
        DataManager.finalLoyaltyDiscount = 0
        
        // socket sudama
        if orderType == .newOrder {
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                var cartModelObj = CartDataSocketModel()
                //cartModelObj.balance_due = 0.0
                cartModelObj.total = TotalPrice
                cartModelObj.subTotal = SubTotalPrice
                if HomeVM.shared.DueShared > 0 { // SSUU for customer facing
                    cartModelObj.balance_due = HomeVM.shared.DueShared
                }else{
                    cartModelObj.balance_due = balanceDue
                }
                //cartModelObj.balance_due = balanceDue
                cartModelObj.tax = dataval//taxAmount.doubleValue
                cartModelObj.coupon = taxTitle
                cartModelObj.couponDiscount = taxableCouponTotal
                cartModelObj.manualDiscount = Double(self.str_AddDiscount) ?? 0.0
                cartModelObj.strAddCouponName = str_AddCouponName
                cartModelObj.shippingAmount = Cshipping
                MainSocketManager.shared.connect()
                let socketConnectionStatus = MainSocketManager.shared.socket.status
                
                switch socketConnectionStatus {
                case SocketIOStatus.connected:
                    print("socket connected")
                    if DataManager.sessionID != ""  && cartProductsArray.count > 0{
                        productsArraySocket.removeAll()
                        MainproductsArraySocket.removeAll()
                        for i in (0..<self.cartProductsArray.count){
                            getVariationDatForSocketEvent(indexSocket: i)
                        }
                        
                        MainSocketManager.shared.onCartUpdate(Arr: cartProductsArray, cartDataSocketModel: cartModelObj, variationData: MainproductsArraySocket)
                    }
                case SocketIOStatus.connecting:
                    print("socket connecting")
                case SocketIOStatus.disconnected:
                    print("socket disconnected")
                case SocketIOStatus.notConnected:
                    print("socket not connected")
                }
            }
        }
        
        // Start ..... by priya loyalty change
        if (isLoyaltyAllowCreditProduct || isLoyaltyAllowPurchaseProduct) || (isLoyaltyAllowCreditProduct && isLoyaltyAllowPurchaseProduct){
            
            //            let loyaltyBonus = subTotalLoyaltyPurchase.rounded(toPlaces: 2)
            //            let newtotal = CSubTotalPrice + Cshipping + CtaxAmount
            let loyaltyBonus = rewardPoints.rounded(toPlaces: 2)
            let newtotal = CSubTotalPrice + Cshipping + CtaxAmount //+ tip
            let minusTotal = CdiscountAmount + CcouponDiscount + loyaltyBonus
            finalTotal = newtotal - minusTotal
            DataManager.finalLoyaltyDiscount = rewardPoints
            print("finalTotal", finalTotal.currencyFormatA)
            if finalTotal < 0 {
                TotalPrice =  0.00
                totalLabel.text = "$0.00"
            }else{
                TotalPrice =  (finalTotal.currencyFormatA as NSString).doubleValue//finalTotal.currencyFormat
                totalLabel.text = "$" + "\(finalTotal.currencyFormatA)"
                finalTotalSend = finalTotal
            }
            
            UserDefaults.standard.set(finalTotal, forKey: "balancefinalCart")
            
            if strCustLoyaltyBalance != "" || doubleCustLoyaltyBalance != 0.0{
                //                CdiscountAmount =  CdiscountAmount - Double(rewardPoints)
                //                self.discountLabel.text = "$" + CdiscountAmount.currencyFormatA
                lblLoyaltyStroreCredit.text = rewardPoints.currencyFormat
                
                // finalTotalSend = rewardPoints
            }
        }else{
            finalTotalSend = finalTotal
        }
        
        //end.....priya
//        if appDelegate.isOpenToOrderHistory {
//            finalTotal = dataNew
//        }
        DataManager.duebalanceData = finalTotal
        //creditshowData?.didDataShowCreditcard?()
        
        
        
        if str_PaymentName == "CASH"{
            // MARK Hide for V5
            
            if balanceDue > 0{
                
                var valueOne = lastChargeValue - TotalPrice
                
                print("last amount value = \(valueOne)")
                
                if valueOne < 0 {
                    valueOne  = -(valueOne)
                } else {
                    valueOne  = -(valueOne)
                }
                
                let valueData =   balanceDue
                
                print("balance due after update = \(valueData)")
                
                if valueOne == 0 {
                    payValue = balanceDue
                    payButton.setTitle("Tender \(balanceDue.currencyFormat)", for: .normal)
                } else {
                    payValue = valueData
                    payButton.setTitle("Tender \(valueData.currencyFormat)", for: .normal)
                }
            }else{
                lastChargeValue = finalTotalSend
                payButton.setTitle("Tender \(finalTotal.currencyFormat)", for: .normal)
            }
        }else {
            
            //For Splite payment
            if balanceDue > 0{
                //payButton.setTitle("Tender \(HomeVM.shared.DueShared.currencyFormat)", for: .normal)
                dataNew = balanceDue
                if isTotalChange {
                    isTotalChange = false
                    payValue = dataNew
                    lastChargeValue = finalTotalSend
                    self.labelBallanceDueAmt.text = dataNew.currencyFormat
                    //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(dataNew.currencyFormat)", for: .normal)
                    
                    payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(dataNew.currencyFormat)", for: .normal)
                } else {
                    
                    if lastChargeValue == 0.0 {
                        lastChargeValue = finalTotalSend
                        payValue = balanceDue
                        self.labelBallanceDueAmt.text = balanceDue.currencyFormat
                        //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(balanceDue.currencyFormat)", for: .normal)
                        payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(balanceDue.currencyFormat)", for: .normal)
                        
                    } else {
                        var valueOne = lastChargeValue - TotalPrice
                        
                        print("last amount value = \(valueOne)")
                        
                        if valueOne < 0 {
                            valueOne  = -(valueOne)
                        } else {
                            valueOne  = -(valueOne)
                        }
                        
                        let valueData =  balanceDue
                        
                        print("balance due after update = \(valueData)")
                        if valueOne == 0 {
                            payValue = balanceDue
                            self.labelBallanceDueAmt.text = balanceDue.currencyFormat
                            //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(balanceDue.currencyFormat)", for: .normal)
                            
                            payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(balanceDue.currencyFormat)", for: .normal)
                        } else {
                            payValue = valueData
                            //balanceDue = valueData
                            self.labelBallanceDueAmt.text = valueData.currencyFormat
                            //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(valueData.currencyFormat)", for: .normal)
                            
                            payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(valueData.currencyFormat)", for: .normal)
                        }
                    }
                }
            }else{
                
                lastChargeValue = finalTotalSend
                if finalTotal < 0 {
                    //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge $0.00", for: .normal)
                    payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge $0.00", for: .normal)
                } else {
                    //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(finalTotal.currencyFormat)", for: .normal)
                    //payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(finalTotal.currencyFormat)", for: .normal)
                    if appDelegate.amount > 0 {
                        payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(appDelegate.amount.currencyFormat)", for: .normal)
                        
                    }else{
                        payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(finalTotal.currencyFormat)", for: .normal)
                        
                    }
                    
                }
            }
            //payButton.setTitle(str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(finalTotal.currencyFormat)", for: .normal)
        }
        
        //Hide View
        discountView.isHidden = discountLabel.text == "$0.00"
        self.taxView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        //        applyCouponView.isHidden = couponNameLabel.text == "Apply Coupon"
        self.applyCouponView.isHidden = (!NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline) || couponNameLabel.text == "Apply Coupon"
        crossButton.isHidden = couponNameLabel.text == "Apply Coupon"
        tipView.isHidden = tip == 0.0
        
        //Hide If Cart Empty
        paymentButtonsView.isHidden = cartProductsArray.count == 0
        cartPaymentSectionView.isHidden = cartProductsArray.count == 0
        
        self.addDiscountView.isHidden = orderType == .refundOrExchangeOrder
        if appDelegate.isOpenToOrderHistory {
            self.addDiscountView.isHidden =  true
            addIconImageView.isHidden = true
        }
        if lblLoyaltyStroreCredit.text == "$0.00"{
            self.loyaltyStoredCreditView.isHidden = true
        }else{
            loyaltyStoredCreditView.isHidden = false
            lblLoyaltyStroreCredit.isHidden = false
        }
        
        
        if HomeVM.shared.DueShared > 0 {
            if DataManager.tempBalanceDuedata == 0.0 {
                dataNew = finalTotalSend
                
                //                if finalTotalSend > 0 {
                //                    //payButton.setTitle(str_PaymentName == "INVOICE" ? "Done" : "Charge \(finalTotalSend.currencyFormat)", for: .normal)
                //                    self.updateTotalAmount(amount: finalTotalSend, SubTotal: SubTotalPrice)
                //                }
            } else {
                dataNew = finalTotalSend - DataManager.tempBalanceDuedata!
            }
        }
        if appDelegate.isOpenToOrderHistory {
            dataNew = balanceDue
        }
        //Update Total Amount
        if isUpdateTotal! {
            
            TotalPrice = finalTotalSend
            
            if tip == 0 {
                if balanceDue > 0{
                    if payValue > 0 {
                      //  self.updateTotalAmount(amount: payValue, SubTotal: SubTotalPrice)
                        if appDelegate.amount > 0 {
                            self.updateTotalAmount(amount: appDelegate.amount, SubTotal: SubTotalPrice)
                        }else{
                            self.updateTotalAmount(amount: payValue, SubTotal: SubTotalPrice)
                        }
                    }
                }else{
                    //self.updateTotalAmount(amount: finalTotalSend, SubTotal: SubTotalPrice)
                    if appDelegate.amount > 0 {
                        self.updateTotalAmount(amount: appDelegate.amount, SubTotal: SubTotalPrice)
                    }else{
                        self.updateTotalAmount(amount: finalTotalSend, SubTotal: SubTotalPrice)
                    }
                }
            } else {
                if balanceDue > 0{
                    
                    if payValue > 0 {
                       // self.updateTotalAmount(amount: payValue, SubTotal: SubTotalPrice)
                        if appDelegate.amount > 0 {
                            self.updateTotalAmount(amount: appDelegate.amount, SubTotal: SubTotalPrice)
                            
                        }else{
                            self.updateTotalAmount(amount: payValue, SubTotal: SubTotalPrice)
                            
                        }
                    }
                    //self.updateTotalAmount(amount: balanceDue)
                }else{
                   // self.updateTotalAmount(amount: total, SubTotal: SubTotalPrice)
                    if appDelegate.amount > 0 {
                        self.updateTotalAmount(amount: appDelegate.amount, SubTotal: SubTotalPrice)
                    }else{
                        
                        self.updateTotalAmount(amount: total, SubTotal: SubTotalPrice)
                    }
                }
            }
        }
        if CtaxAmount > 0 {
            self.taxView.isHidden = false
        }
        if DataManager.isAuthentication {
            if (str_PaymentName == "CREDIT") ||  (str_PaymentName == "PAX PAY") {
                if DataManager.isBalanceDueData {
                    authButton.isHidden = true
                } else {
                    authButton.isHidden = false
                }
            } else {
                authButton.isHidden = true
            }
            
            if (!NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline) || orderType == .refundOrExchangeOrder{
                authButton.isHidden = true
            }
        } else {
            authButton.isHidden = true
        }
    }
    
    func updateShippingTotal() {
        if !isShippingPriceChanged {
            
            var totalShipping = Double()
            
            for data in cartProductsArray {
                if let shippingPrice = (data as AnyObject).value(forKey: "shippingPrice") as? String {
                    let qty = Double((data as AnyObject).value(forKey: "productqty") as? String ?? "1") ?? 1
                    totalShipping += ((Double(shippingPrice) ?? 0.0) * qty)
                }
            }
            
            if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                totalShipping = 0
            }
            
            str_ShippingANdHandling = "\(totalShipping)"
            self.shippingLabel.text = totalShipping.currencyFormat
            
        }
    }
    
    func updateCouponTotal() {
        if self.cartProductsArray.count == 0 || HomeVM.shared.coupanDetail.code == nil || str_AddCouponName == "" {
            return
        }
        
        //Calculate Coupan Total
        var isCoupanApplied = false
        var totalAMT = Double()
        var totalQTY = Double()
        var taxableTotalQTY = Double()
        var nonTaxableTotalQTY = Double()
        let coupon = NSString(string: HomeVM.shared.coupanDetail.amount)
        
        for i in (0..<self.cartProductsArray.count)
        {
            let obj = (self.cartProductsArray as AnyObject).object(at: i)
            let price = Double((obj as AnyObject).value(forKey: "productprice") as? String ?? "0") ?? 0.00
            let qty = Double((obj as AnyObject).value(forKey: "productqty") as? String ?? "0") ?? 0.00
            let total = qty * price
            let taxable = (obj as AnyObject).value(forKey: "productistaxable") as? String ?? ""
            let isTaxExempt = (obj as AnyObject).value(forKey: "isTaxExempt") as? String ?? "No"
            
            if (taxable == "Yes") && (isTaxExempt == "No") {
                taxableTotalQTY += qty
            }else {
                nonTaxableTotalQTY += qty
            }
            
            totalAMT += total
            totalQTY += qty
        }
        
        let valueOne = NSString(string: HomeVM.shared.coupanDetail.totalAmount)
        let couponAmount = valueOne.doubleValue
        
        if totalAMT < couponAmount {
            
            self.taxableCouponTotal = 0
            isCoupanApplied = false
            self.couponNameLabel.text = "Apply Coupon"
            self.crossButton.isHidden = true
            
            return
        }
        CouponTotal = 0.0
        if HomeVM.shared.coupanDetail.productList.count > 0 {
            self.taxableCouponTotal = 0.0
            CouponTotal = 0.0
            withoutCouponTotal = 0.0
            for i in (0..<self.cartProductsArray.count)
            {
                let obj = (self.cartProductsArray as AnyObject).object(at: i)
                let id = (obj as AnyObject).value(forKey: "productid") as? String ?? "0"
                let price = Double((obj as AnyObject).value(forKey: "productprice") as? String ?? "0") ?? 0.00
                let qty = Double((obj as AnyObject).value(forKey: "productqty") as? String ?? "0") ?? 0.00
                
                let total = qty * price
                
                //If Product Coupan Able
                if HomeVM.shared.coupanDetail.productList.contains(where: {(Int($0) ?? -1) == (Int(id) ?? -2)}) {
                    isCoupanApplied = true
                    self.taxableCouponTotal = HomeVM.shared.coupanDetail.productList.count == 1 ? 0 : self.taxableCouponTotal
                    CouponTotal += total
                    if HomeVM.shared.coupanDetail.type == "Percent" {
                        self.taxableCouponTotal += coupon.doubleValue/100 * total
                    }else {
                        self.taxableCouponTotal =  coupon.doubleValue //>= 0 ? newValue : totalAMT
                    }
                } else {
                    withoutCouponTotal += total
                }
            }
        }
        
        if !isCoupanApplied {
            if HomeVM.shared.coupanDetail.productList.count == 0 {
                
                let TotalVal = (totalAMT.currencyFormatA as NSString).doubleValue
                
                if HomeVM.shared.coupanDetail.type == "Percent" {
                    self.taxableCouponTotal = coupon.doubleValue/100 * TotalVal
                }else {
                    self.taxableCouponTotal = coupon.doubleValue > TotalVal ? TotalVal : coupon.doubleValue
                }
            }else {
                self.taxableCouponTotal = 0.0
            }
        }
        
        //Update Labels
        if HomeVM.shared.coupanDetail.type == "Percent" {
            if (HomeVM.shared.coupanDetail.amount == "0.00")
            {
                self.couponNameLabel.text = "Apply Coupon"
                self.crossButton.isHidden = true
            }
            
            if(HomeVM.shared.coupanDetail.amount.contains(".00"))
            {
                let str = HomeVM.shared.coupanDetail.amount.components(separatedBy: ".")
                //self.couponNameLabel.text = "\(str[0])% Coupon Applied"
                self.couponNameLabel.text = "Coupon (\(str_AddCouponName))"
                self.crossButton.isHidden = false
            }else {
                self.couponNameLabel.text = "Coupon (\(str_AddCouponName))"
                
                //self.couponNameLabel.text = "\(String(describing: HomeVM.shared.coupanDetail.amount ?? ""))% Coupon Applied"
                self.crossButton.isHidden = false
            }
        }else {
            self.couponNameLabel.text = "Coupon (\(str_AddCouponName))"
            //self.couponNameLabel.text = "$\(HomeVM.shared.coupanDetail.amount ?? "") Coupon Applied"
            self.crossButton.isHidden = false
        }
        
        if HomeVM.shared.coupanDetail.freeShipping == "Yes" {
            
            
            for i in (0..<self.cartProductsArray.count)
            {
                let obj = (self.cartProductsArray as AnyObject).object(at: i)
                let id = (obj as AnyObject).value(forKey: "productid") as? String ?? "0"
                
                
                //If Product Coupan Able
                if HomeVM.shared.coupanDetail.productList.contains(where: {(Int($0) ?? -1) == (Int(id) ?? -2)}) {
                    let totalShipping = 0.0
                    
                    str_ShippingANdHandling = "\(totalShipping)"
                    self.shippingLabel.text = totalShipping.currencyFormat
                }
                
                if HomeVM.shared.coupanDetail.productList.count == 0 {
                    let totalShipping = 0.0
                    
                    str_ShippingANdHandling = "\(totalShipping)"
                    self.shippingLabel.text = totalShipping.currencyFormat
                }
            }
        }
        
        self.isCoupanApplyOnAllProducts = isCoupanApplied
        
    }
    
    func resetCartData()
    {
        
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
        self.delegate?.didResetCart?()
        self.cartProductsArray.removeAll()
        self.updateDefaultTax()
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
        self.str_CouponDiscount=""
        self.str_AddDiscount = ""
        self.str_AddCouponName = ""
        self.str_ShippingANdHandling = ""
        CustomerObj = CustomerListModel()
        customerNameLabel.text = "Add Customer"
        //customerNameLabel.text = "Customer #"
        addIconImageView.image = UIImage(named: "add-button-inside-black-circle")
        self.discountLabel.text = "$0.00"
        self.shippingLabel.text = "$0.00"
        self.isShippingPriceChanged = false
        isAllDataRemoved = true
        DataManager.duebalanceData = 0.0
        HomeVM.shared.amountPaid = 0.0
        HomeVM.shared.coupanDetail.code = ""
        HomeVM.shared.customerUserId = ""
        DataManager.Bbpid = ""
        
        DispatchQueue.main.async {
            if self.orderType == .refundOrExchangeOrder {
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController")
                appDelegate.window?.rootViewController = vc
                appDelegate.window?.makeKeyAndVisible()
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        //        self.showAlert(title: "Alert", message: "Cart items removed!", otherButtons: nil, cancelTitle: kOkay) { (action) in
        // self.navigationController?.popViewController(animated: true)
        appDelegate.showToast(message: "Cart items removed!")
        //        }
        
    }
    // by sudama add sub
    func resetPaymentView(){
        DispatchQueue.main.async {
            
            if self.str_PaymentName == "CREDIT" || self.str_PaymentName == "PAX PAY" {
                return
            }
            
            self.str_PaymentName = ""
            appDelegate.strPaymentType = ""
            self.depositeAmountLabel.text = "$0.00"
            //Reset Data
            self.creditCardDelegate?.reset?()
            self.cashDelegate?.reset?()
            self.invoiceDelegate?.reset?()
            self.achCheckDelegate?.reset?()
            self.giftCardDelegate?.reset?()
            self.externalGiftCardDelegate?.reset?()
            self.internalGiftCardDelegate?.reset?()
            self.multicardDelegate?.reset?()
            self.checkDelegate?.reset?()
            self.externalCardDelegate?.reset?()
            self.paxDelegate?.reset?()
            self.notesDelegate?.reset?()
            //Remove Payment Data
            PaymentsViewController.paymentDetailDict.removeAll()
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
            //Enable Card Reader
            self.paymentTypeViewDelegate?.enableCardReaders?()
            self.creditCardDelegate?.disableCardReader?()
            self.giftCardDelegate?.disableCardReader?()
            self.externalGiftCardDelegate?.disableCardReader?()
            self.internalGiftCardDelegate?.disableCardReader?()
            self.multicardDelegate?.disableCardReader?()
            self.invoiceDelegate?.disableCardReader?()
            //Update Payment Label
            self.lbl_PaymentMethodName.text = "Payment Method"
            self.btn_Cancel.isHidden = true
            //Hide All Container & Enable Swipe Reader
            self.add(childVC: self.paymentTypeContainer)
            SwipeAndSearchVC.shared.enableTextField()
            
            self.tipLabel.text = "$0.00"
            self.tipView.isHidden = self.tipLabel.text == "$0.00"
            self.updateLabels(isUpdateTotal: false)
            self.calculateTotal()
            self.payButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            self.authButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            
        }
    }
    //
}

//MARK: UIPopoverControllerDelegate
extension iPad_PaymentTypesViewController: CustomerDelegates {
    func didAddNewCustomer() {
        self.delegate?.didAddNewCustomer?()
        customerNameLabel.text = "Add Customer"
        //customerNameLabel.text = "Customer #"
        addIconImageView.image = UIImage(named: "add-button-inside-black-circle")
        CustomerObj = CustomerListModel()
        str_AddCouponName = ""
        couponNameLabel.text = "Apply Coupon"
        couponAmountLabel.text = "$0.00"
        str_AddDiscount = "0.00"
        str_CouponDiscount = ""
        taxableCouponTotal = 0.0
        crossButton.isHidden = true
        calculateTotalCart()
    }
    
    func didCancelButtonTapped() {
        self.add(childVC: paymentTypeContainer) //Need to change...
    }
    
    func didRefreshNewCustomer() {
        
        if DataManager.customerObj != nil {
            self.updateCustomerData()
            self.saveCustomerData()
        }else {
            //self.customerNameLabel.text = "Add Customer"
            addIconImageView.image = UIImage(named: "add-button-inside-black-circle")
            self.CustomerObj = CustomerListModel()
        }
        
        self.delegate?.didUpdateCustomer?(data: CustomerObj)
        calculateTotalCart()
//        self.add(childVC: paymentTypeContainer) //Need to change...
        if !isMultiShippingAdrs {
            self.add(childVC: paymentTypeContainer) //Need to change...
        }
        isMultiShippingAdrs = false
        invoiceDelegate?.didUpdateCustomer?(data: CustomerObj)
        creditCardDelegate?.didUpdateCustomer?(data: CustomerObj)
        
        //        if DataManager.isshipOrderButton {
        //            if checkFillFeild {
        //                payButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
        //                authButton.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
        //            }
        //        }
        
        
    }
    
    func didSelectCustomer(data: CustomerListModel) {
        self.delegate?.didUpdateCustomer?(data: data)
        selectedCustomerData(customerdata: data)
        self.customerDelegate?.didSelectCustomer?(data: data)
    }
    
    func selectedCustomerData(customerdata: CustomerListModel)
    {
        CustomerObj = customerdata
        
        if CustomerObj.str_first_name == "" && CustomerObj.str_last_name == "" {
            self.customerNameLabel.text = "Customer #" + CustomerObj.str_userID
        }else{
            self.customerNameLabel.text = CustomerObj.str_first_name + " " + CustomerObj.str_last_name
        }
        //self.customerNameLabel.text = CustomerObj.str_first_name + " " + CustomerObj.str_last_name
        addIconImageView.image =  UIImage(named: "edit-icon1")
        self.saveCustomerData()
        
        //Update Coupon If Available
        if customerdata.userCoupan != "" {
            str_AddCouponName = customerdata.userCoupan
            //New Coupon Applied
            self.callAPItoGetCoupanProductIds(coupan: str_AddCouponName)
        } else {
            HomeVM.shared.coupanDetail.code = ""
            str_AddCouponName = ""
            self.resetCoupan()
        }
        //Update Tax If Available
        if customerdata.userCustomTax != "" {
            self.isDefaultTaxChanged = false
            self.isDefaultTaxSelected = false
            self.taxNameLabel.text = "Tax (\(customerdata.userCustomTax))"
        }
        
        self.calculateTotalCart()
//        self.add(childVC: paymentTypeContainer) //Need to change...
        isMultiShippingAdrs = customerdata.shippingaddressCount ?? 0 > 1
        if isMultiShippingAdrs && customerdata.shippingaddressCount ?? 0 > 1 {
            self.add(childVC: addCustomerContainer) //Need to change...
        }else{
            self.add(childVC: paymentTypeContainer) //Need to change...
        }
        invoiceDelegate?.didUpdateCustomer?(data: CustomerObj)
        
        DataManager.customerId = CustomerObj.str_userID
        DataManager.CardCount = CustomerObj.cardCount
        DataManager.EmvCardCount = Int(CustomerObj.emv_card_Count)
        DataManager.IngenicoCardCount = Int(CustomerObj.ingenico_card_count)
        DataManager.shippingaddressCount = (CustomerObj.shippingaddressCount == nil) ? DataManager.shippingaddressCount : CustomerObj.shippingaddressCount ?? 0
        DataManager.Bbpid = CustomerObj.str_bpid
        if CustomerObj.user_has_open_invoice == "true" {
            print("true")
            if UI_USER_INTERFACE_IDIOM() == .pad {
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "iPad_OrdersHistoryViewController") as! iPad_OrdersHistoryViewController
                //                controller.recentOrderID = self.orderId
                //controller.userHasOpenInvoice = true
                if CustomerObj.str_customerTags == ""{
                    self.navigationController?.pushViewController(controller, animated: true)
                }else{
                    self.closeAlert(title: "Customer Tags Found", message: CustomerObj.str_customerTags, cancelTitle: "Close", cancelAction: { (_) in
                        self.navigationController?.pushViewController(controller, animated: true)
                        
                    })
                }
                
            }
        }
    }
    
}

//MARK: EditProductDelegate
extension iPad_PaymentTypesViewController: EditProductDelegate {
    func didUpdateHeight(isKeyboardOpen: Bool) {
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            UIView.animate(withDuration: Double(0.5), animations: {
                self.editProductDetailContainerTopConstraint.constant =  isKeyboardOpen ? 20 : 180
            })
        }
    }
    
    func didClickOnDoneButton() {
        hideEditView()
        refreshCart()
    }
    
    func didClickOnCrossButton() {
        hideEditView()
    }
    
    func didClickOnCloseButton() {
        setView(view: showDetailsContainer, hidden: true)
    }
    func didClickOnCreditSavedButton() {
        setView(view: SavedCardContainer, hidden: true)
    }
    
    func hideShippingCard() {
        setView(view: shippingContainer, hidden: true)
    }
    func doneShippingCard(rate: String){
        handleShippingAddRate(shiipingRate: rate)
        setView(view: shippingContainer, hidden: true)
    }
    
    func didShowShippingAddress(data: CustomerListModel ){
        delegateEditProduct?.didShowShippingAddress?(data: data)
    }
    
    func getCartProductsArray(data: Array<Any>){
        delegateEditProduct?.getCartProductsArray?(data: data)
    }
    func didShowSavedCardDetail(index: Int, cartSavedArray: Array<AnyObject>) {
        //self.delegateSavedCardDetail?.didShowSavedCardDetail!(index: index, cartSavedArray: cartSavedArray)
        if lbl_PaymentMethodName.text == "Split Payment" {
            self.multicardDelegate?.didSendCreditSavedCardData!(cartDataArray: cartSavedArray)
        } else if lbl_PaymentMethodName.text == "Pax Pay" {
            self.paxDelegate?.didSendCreditSavedCardData?(cartDataArray: cartSavedArray)
        } else if lbl_PaymentMethodName.text == "Ingenico" {
            self.ingenicoDelegate?.didSendCreditSavedCardData!(cartDataArray:cartSavedArray )
        } else {
            self.creditCardDelegate?.didSendCreditSavedCardData!(cartDataArray:cartSavedArray )
        }
        print("card Data",cartSavedArray[0])
    }
    
    
}


//MARK: OfflineDataManagerDelegate
extension iPad_PaymentTypesViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        controller?.dismiss(animated: true, completion: nil)
        self.lockLineView.isHidden = !isOn
        self.lockButton.isHidden = !isOn
        self.logoutButton.isHidden = !isOn
        self.logoutLineView.isHidden = !isOn
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            self.addCustomerView.isHidden = true
            self.add(childVC: paymentTypeContainer) //Need to change...
            self.CustomerObj = CustomerListModel()
            UserDefaults.standard.removeObject(forKey: "isCheckUncheckShippingBilling")
            //            UserDefaults.standard.removeObject(forKey: "CustomerObj")
            //            UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
            UserDefaults.standard.synchronize()
            PaymentsViewController.paymentDetailDict.removeAll()
            customerNameLabel.text = "Customer #" + CustomerObj.str_order_id
            addIconImageView.image = #imageLiteral(resourceName: "add-button-inside-black-circle")
        }else {
            self.addCustomerView.isHidden = !DataManager.isCustomerManagementOn || orderType == .refundOrExchangeOrder
        }
        
        if DataManager.isOffline {
            self.taxView.isHidden = !isOn
            self.shippingView.isHidden = !isOn
            self.applyCouponView.isHidden = !isOn
            
            if !isOn {
                if str_PaymentName == "INVOICE" {
                    self.depositeView.isHidden = false
                }else {
                    self.depositeView.isHidden = true
                }
                self.resetCoupan()
            }
        }
        self.addDiscountView.isHidden = orderType == .refundOrExchangeOrder
        if appDelegate.isOpenToOrderHistory {
            self.addDiscountView.isHidden =  true
            addIconImageView.isHidden = true
        }
        self.calculateTotalCart()
    }
}

//MARK: Refund Calculation With API
extension iPad_PaymentTypesViewController {
    
    func calculateRefundExchangeTotal() {
        let taxID = self.taxTitle == "Default" ? DataManager.defaultTaxID : self.taxTitle
        
        var productDict = JSONDictionary()
        
        for i in (0..<self.cartProductsArray.count)
        {
            let obj = (cartProductsArray as AnyObject).object(at: i)
            
            let productId = (obj as AnyObject).value(forKey: "productid") as! String
            let productKey = productId + "_" + "\(i + 1)"
            
            var dict = [String: Any]()
            dict["product_id"] = (obj as AnyObject).value(forKey: "productid") as! String
            let isRefundProduct = (obj as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
            if isRefundProduct {
                let manPriceData = (Double((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0) + ((obj as AnyObject).value(forKey: "per_product_tax") as? Double ?? 0)) - ((obj as AnyObject).value(forKey: "per_product_discount") as? Double ?? 0)
                dict["base_price"] = "\((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0)"
                dict["price"] = Double((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0).roundToTwoDecimal
                dict["man_price"] = manPriceData
                dict["qty"] = (obj as AnyObject).value(forKey: "productqty") as? Double ?? 0
                dict["isRefunded"] = false
                dict["limit_qty"] = (obj as AnyObject).value(forKey: "limit_qty") as? Double ?? 0
                dict["is_refund_item"] = true
                dict["stock"] = 0
                dict["sales_id"] = (obj as AnyObject).value(forKey: "salesID") as? String ?? ""
                
                //dict["selectionInventory"] = (obj as AnyObject).value(forKey: "selectionInventory") as? String ?? ""
                dict["backToStock"] = (obj as AnyObject).value(forKey: "returnToStock") as? Bool ?? false
                dict["product_image"] = (obj as AnyObject).value(forKey: "product_image") as? String ?? ""
                dict["stock"] = (obj as AnyObject).value(forKey: "stock") as? Double ?? 0
                dict["title"] = (obj as AnyObject).value(forKey: "title") as? String ?? ""
            }else {
                dict["price"] = Double((obj as AnyObject).value(forKey: "productprice") as! String)?.roundToTwoDecimal
                dict["man_price"] = Double((obj as AnyObject).value(forKey: "productprice") as! String)?.roundToTwoDecimal
                dict["qty"] = (obj as AnyObject).value(forKey: "productqty") as! String
            }
            
            dict["per_product_discount"] = (obj as AnyObject).value(forKey: "per_product_discount") as? Double ?? 0
            dict["per_product_tax"] = (obj as AnyObject).value(forKey: "per_product_tax") as? Double ?? 0
            dict["is_taxable"] = (obj as AnyObject).value(forKey: "productistaxable") as? String ?? "No"
            dict["product_image"] = (obj as AnyObject).value(forKey: "productimage") as? String ?? ""
            dict["title"] = (obj as AnyObject).value(forKey: "producttitle") as? String ?? ""
            dict["sub_id"] = 0
            dict["row_id"] = i + 1
            dict["manual_description"] = (obj as AnyObject).value(forKey: "productNotes") as? String ?? ""
            let isTaxExempt = ((obj as AnyObject).value(forKey: "isTaxExempt") as? String ?? "No").lowercased()
            dict["tax_exempt"] = isTaxExempt == "no" ? false : true
            
            var variationArrayDetails = JSONArray()
            var surchargvariationArrayDetails = JSONArray()
            var attributeArrayDetails = JSONArray()
            
            if let productvariationArray = (obj as AnyObject).value(forKey: "variationArray") as? JSONArray {
                variationArrayDetails = productvariationArray
            }
            
            if let surchargevariationArray = (obj as AnyObject).value(forKey: "surchargVariationArray") as? JSONArray {
                surchargvariationArrayDetails = surchargevariationArray
                dict["surcharge_variations"] = surchargvariationArrayDetails
                //dict["surchargeAdded"] = "219.97"
            }
            
            if let productDetailArray = (obj as AnyObject).value(forKey: "attributesArray") as? JSONArray {
                attributeArrayDetails = productDetailArray
            }
            
            let value = getVariationValueForProduct(attributeObj: attributeArrayDetails, variationObj: variationArrayDetails, surchargeObj: surchargvariationArrayDetails)
                        
            //value.append(T##newElement: JSONDictionary##JSONDictionary)
            dict["variations"] = value
            dict["checkbox_variation_data"] = value


            productDict[productKey] = dict
        }
        
        var shipping = Double(self.str_ShippingANdHandling) ?? 0
        if orderType == .refundOrExchangeOrder {
            self.shippingRefundButton.setTitle("Refund", for: .normal)
            shipping =  self.shippingRefundButton.isSelected ? -appDelegate.shippingRefundOnly : appDelegate.shippingRefundOnly
        }
        
        let parameters: JSONDictionary = [
            "cust_id": orderInfoObj.userID,
            "customer_info": [
                "first_name": orderInfoObj.firstName,
                "last_name": orderInfoObj.lastName,
                "email": orderInfoObj.email,
                "phone": orderInfoObj.phone,
                "address": orderInfoObj.addressLine1,
                "address2": orderInfoObj.addressLine2,
                "city": orderInfoObj.city,
                "state": orderInfoObj.region,
                "zip":orderInfoObj.postalCode,
                "country": orderInfoObj.country
            ],
            "billing_info": [
                "bill_first_name": orderInfoObj.firstName,
                "bill_last_name": orderInfoObj.lastName,
                "bill_address_1": orderInfoObj.addressLine1,
                "bill_address_2": orderInfoObj.addressLine2,
                "bill_city": orderInfoObj.city,
                "bill_region": orderInfoObj.region,
                "bill_country": orderInfoObj.country,
                "bill_postal_code": orderInfoObj.postalCode,
                "bill_email": orderInfoObj.email,
                "bill_phone": orderInfoObj.phone
            ],
            "shipping_info": [
                "ship_first_name": orderInfoObj.shippingFirstName,
                "ship_last_name": orderInfoObj.shippingLastName,
                "ship_address_1": orderInfoObj.shippingAddressLine1,
                "ship_address_2": orderInfoObj.shippingAddressLine2,
                "ship_city": orderInfoObj.shippingCity,
                "ship_region": orderInfoObj.shippingRegion,
                "ship_country": orderInfoObj.shippingCountry,
                "ship_postal_code": orderInfoObj.shippingPostalCode,
                "ship_email": orderInfoObj.shippingEmail,
                "ship_phone": orderInfoObj.shippingPhone
            ],
            "cart_info": [
                "coupon": self.str_AddCouponName,
                "products": productDict,
                "manual_discount": self.str_AddDiscount,
                "shipping_handling": shipping.roundToTwoDecimal,
                "deposit_amount": 0,
                "custom_tax_id": taxID,
                "reward_points" : rewardPoints
            ],
            "isOrderRefund": true,
            "is_loyalty": true,
            "enable_split_row": DataManager.isSplitRow,
            "order_id": orderInfoObj.orderID,
            "invoiceSplitRow": true,//DataManager.isSplitRow,
            
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
            "isOfflineTransction" : false   // by sudama offline
        ]
        
        //Call API
        self.callAPIToCalculateCartTotal(parameters: parameters)
    }
    
    func callAPIToCalculateCartTotal(parameters: JSONDictionary) {
        HomeVM.shared.calculateCart(parameters: parameters) { (success, message, error) in
            if success == 1 {
                let detail = HomeVM.shared.cartCalculationDetail
                
                self.SubTotalPrice = detail.subTotal
                self.TotalPrice = detail.total
                //                self.str_ShippingANdHandling = detail.shipping.roundToTwoDecimal
                self.str_TaxAmount = detail.tax.roundToTwoDecimal
                
                self.shippingLabel.text = detail.shipping.currencyFormat
                self.discountLabel.text = detail.discount.currencyFormat
                
                self.subtotalLabel.text = detail.subTotal.currencyFormat
                self.couponAmountLabel.text = detail.couponDiscount.currencyFormat
                self.taxNameLabel.text = (self.taxTitle == "" || self.taxTitle == "countrywide" || self.taxTitle == "Default") ? "Tax (Default)" :  "Tax (\(self.taxTitle))"
                self.taxAmountLabel.text = detail.tax.currencyFormat
                self.totalLabel.text = detail.total.currencyFormat
                if self.str_PaymentName == "CASH"{
                    // MARK Hide for V5
                    
                    if self.balanceDue > 0{
                        
                        var valueOne = self.lastChargeValue - self.TotalPrice
                        
                        print("last amount value = \(valueOne)")
                        
                        if valueOne < 0 {
                            valueOne  = -(valueOne)
                        } else {
                            valueOne  = -(valueOne)
                        }
                        
                        let valueData =   self.balanceDue
                        
                        print("balance due after update = \(valueData)")
                        
                        if valueOne == 0 {
                            self.payValue = self.balanceDue
                            self.payButton.setTitle("Tender \(self.balanceDue.currencyFormat)", for: .normal)
                        } else {
                            self.payValue = valueData
                            self.payButton.setTitle("Tender \(valueData.currencyFormat)", for: .normal)
                        }
                        
                        //self.payButton.setTitle("Tender \(self.balanceDue.currencyFormat)", for: .normal)
                    }else{
                        self.payButton.setTitle("Tender \(self.TotalPrice.currencyFormat)", for: .normal)
                    }
                    
                }else {
                    
                    if self.balanceDue > 0{
                        
                        let valueOne = self.lastChargeValue - self.TotalPrice
                        
                        print("last amount value = \(valueOne)")
                        
                        let valueData = self.balanceDue
                        
                        print("balance due after update = \(valueData)")
                        
                        if valueOne == 0 {
                            //self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(self.balanceDue.currencyFormat)", for: .normal)
                            
                            self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Done" : "Charge \(self.balanceDue.currencyFormat)", for: .normal)
                        } else {
                            //self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(valueData.currencyFormat)", for: .normal)
                            
                            self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Done" : "Charge \(valueData.currencyFormat)", for: .normal)
                        }
                        
                    }else{
                        //self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(self.TotalPrice.currencyFormat)", for: .normal)
                        
                        self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Done" : "Charge \(self.TotalPrice.currencyFormat)", for: .normal)
                    }
                    
                    //self.payButton.setTitle(self.str_PaymentName == "INVOICE" ? "Send Invoice" : "Charge \(self.TotalPrice.currencyFormat)", for: .normal)
                }
                //Hide If Amount Is Zero
                self.discountView.isHidden = self.discountLabel.text == "$0.00"
                self.applyCouponView.isHidden = self.couponNameLabel.text == "Apply Coupon"
                self.crossButton.isHidden = self.couponNameLabel.text == "Apply Coupon"
                self.addDiscountView.isHidden = self.orderType == .refundOrExchangeOrder
                self.addDiscountView.isHidden = !DataManager.isCustomerManagementOn || self.orderType == .refundOrExchangeOrder
                if appDelegate.isOpenToOrderHistory {
                    self.addDiscountView.isHidden =  true
                    self.addIconImageView.isHidden = true
                }
                self.shippingView.isHidden = detail.shipping == 0
                self.taxView.isHidden = detail.tax == 0
                
                if self.lblLoyaltyStroreCredit.text == "$0.00"{
                    self.loyaltyStoredCreditView.isHidden = true
                }
                
                //Hide If Cart Empty
                self.paymentButtonsView.isHidden = self.cartProductsArray.count == 0
                self.cartPaymentSectionView.isHidden = self.cartProductsArray.count == 0
                self.cartPaymentSectionView.isHidden = self.cartProductsArray.count == 0
                
                self.tipView.isHidden = true
                
                if self.balanceDue > 0{
                    self.updateTotalAmount(amount: self.balanceDue, SubTotal: 0.0)
                }else{
                    self.updateTotalAmount(amount: self.TotalPrice, SubTotal: self.SubTotalPrice)
                }
                
                if self.orderType == .refundOrExchangeOrder {
                    self.authButton.isHidden = true
                }
                // socket sudama
                if self.orderType == .newOrder {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        var cartModelObj = CartDataSocketModel()
                        cartModelObj.balance_due = 0.0
                        cartModelObj.total = self.TotalPrice
                        cartModelObj.subTotal = self.SubTotalPrice
                        // cartModelObj.balance_due = HomeVM.shared.DueShared
                        // cartModelObj.tax = taxAmount.doubleValue
                        cartModelObj.coupon = self.taxTitle
                        cartModelObj.couponDiscount = self.taxableCouponTotal
                        cartModelObj.manualDiscount = Double(self.str_AddDiscount) ?? 0.0
                        cartModelObj.strAddCouponName = self.str_AddCouponName
                        //cartModelObj.shippingAmount = Cshipping
                        cartModelObj.balance_due = self.balanceDue
                        
                        MainSocketManager.shared.connect()
                        let socketConnectionStatus = MainSocketManager.shared.socket.status
                        
                        switch socketConnectionStatus {
                        case SocketIOStatus.connected:
                            print("socket connected")
                            if DataManager.sessionID != ""  && self.cartProductsArray.count > 0{
                                self.productsArraySocket.removeAll()
                                self.MainproductsArraySocket.removeAll()
                                if DataManager.sessionID != "" {
                                    for i in (0..<self.cartProductsArray.count){
                                        self.getVariationDatForSocketEvent(indexSocket: i)
                                    }
                                    
                                    MainSocketManager.shared.onCartUpdate(Arr: self.cartProductsArray, cartDataSocketModel: cartModelObj, variationData: self.MainproductsArraySocket)
                                }
                                //  MainSocketManager.shared.onCartUpdate(Arr: self.cartProductsArray, cartDataSocketModel: cartModelObj, variationData: self.MainproductsArraySocket)
                            }
                        case SocketIOStatus.connecting:
                            print("socket connecting")
                        case SocketIOStatus.disconnected:
                            print("socket disconnected")
                        case SocketIOStatus.notConnected:
                            print("socket not connected")
                        }
                    }
                }
                
                
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
}

//MARK: OfflineDataManagerDelegate
extension iPad_PaymentTypesViewController: SwipeAndSearchConnectionDelegate {
    func didUpdateJackReader(isConnected: Bool) {
        self.audioButton.isSelected = isConnected
    }
}

////MARK: EPSignatureDelegate
//extension iPad_PaymentTypesViewController: EPSignatureDelegate {
//    func epSignature(_: MultipleSignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
//        <#code#>
//    }
//
//    func epSignature(_: SignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
//        paymentViewDelegate?.placeOrderWithSignature?(image: signatureImage)
//    }
//}

//MARK: EPSignatureDelegate
extension iPad_PaymentTypesViewController: EPSignatureDelegate {
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
        var totalValData = 0.0
        for i in 0..<arrdata.count {
            let arrsign = arrdata[i]
            let tipDataVal = arrsign["tip"] as? String
            let tipVal = tipDataVal?.toDouble()
            let totalVal = arrsign["TotalAmount"] as? String
            totalValData = totalVal?.toDouble() ?? 0.0
            if arrdata.count == 1 {
                if tipVal == 0.0 {
                    HomeVM.shared.DueShared = HomeVM.shared.DueShared - HomeVM.shared.tipValue
                    balanceDue = HomeVM.shared.DueShared
                    HomeVM.shared.tipValue = 0.0
                    HomeVM.shared.MultiTipValue = 0.0
                    tipAmountDue = 0.0
                    MultiTipAmountDue = 0.0
                    HomeVM.shared.errorTip = 0.0
                } else {
                    HomeVM.shared.DueShared = HomeVM.shared.DueShared - HomeVM.shared.tipValue
                    balanceDue = HomeVM.shared.DueShared
                    HomeVM.shared.tipValue = tipVal ?? 0.0
                    HomeVM.shared.errorTip = tipVal ?? 0.0
                    HomeVM.shared.MultiTipValue = 0.0
                    tipAmountDue = tipVal ?? 0.0
                    MultiTipAmountDue = 0.0
                    
                }
            }
            
            if str_PaymentName == "CREDIT" || str_PaymentName == "credit" || str_PaymentName == "CARD READER" || str_PaymentName == "card reader"
            {
                tipAmountCreditCard = tipVal ?? 0.0
                tipIngenico = tipVal ?? 0.0
            } else {
                let tipData = tipVal ?? 0.0
                tipAmountCreditCard += tipData
            }
            updateTotal(with: tipAmountCreditCard)
        }
        appDelegate.arrIngenicoSigTip = arrdata
        Indicator.sharedInstance.delegate = self
        if str_PaymentName == "CARD READER" || str_PaymentName == "card reader" {
            if DataManager.allowZeroDollarTxn  == "true"{
                ingenicoStartOnClick()
            } else {
                if (totalValData > 0) {
                    ingenicoStartOnClick()
                }else{
                    appDelegate.showToast(message: "Please Enter Amount greater than 0")
                    Indicator.sharedInstance.hideIndicator()
                    return
                }
            }
            
        } else {
            calculateTotal()
            paymentViewDelegate?.returnDataSignature?(arrCardDataSignature: arrdata)
        }
    }
    
}

//MARK: CancelPAXDelegate Delegate
extension iPad_PaymentTypesViewController : CancelPAXDelegate{
    func didCancelPAX() {
        print("Delegate in IPad_payment")
        Indicator.sharedInstance.hideIndicator()
        ingenico.payment.abortTransaction()
    }
}

extension iPad_PaymentTypesViewController {
    
    
    func getAmount() -> IMSAmount {
        return IMSAmount(total: Int("25") ?? 0, andSubtotal: Int("20") ?? 0, andTax: Int("2") ?? 0, andDiscount: Int("1") ?? 0, andDiscountDescription: "ROAMDiscount", andTip: Int("1") ?? 0, andCurrency: "USD", andSurcharge: Int("1") ?? 0)
    }
    
    // Token Sale
    func processTokenSale() {
        
       // var amount = IMSAmount()
       // amount = IMSAmount.init(total: Int(totalAmount.rounded(toPlaces: 2)), andSubtotal: Int(subTotalVal), andTax: 0, andDiscount: 0, andDiscountDescription: "", andTip: valdatTip ?? 0, andCurrency: "USD", andSurcharge: 0)
        
        let discount = Double(self.str_AddDiscount) ?? 0.00
        
        let valdatTip = Int((tipIngenico.rounded(toPlaces: 2) * 100).roundOFF) ?? 0
        let totalAmount = (appDelegate.CardReaderAmount * 100) + (tipIngenico.rounded(toPlaces: 2) * 100)
        let shipp =  Double(self.str_ShippingANdHandling) ?? 0.00
        let subTotalVal = Int(totalAmount.rounded(toPlaces: 2)) - valdatTip
        var amount = IMSAmount()
        //        if HomeVM.shared.DueShared > 0.0 {
        //            amount = IMSAmount.init(total: Int(totalAmount.rounded(toPlaces: 2)), andSubtotal: 0, andTax: 0, andDiscount: 0, andDiscountDescription: "", andTip: valdatTip ?? 0, andCurrency: "USD")
        //
        //        } else {
        //            //amount = IMSAmount.init(total: Int(totalAmount.rounded(toPlaces: 2)), andSubtotal: Int(subTotalVal*100), andTax: Int(taxableAmtData * 100), andDiscount: Int(discount  * 100), andDiscountDescription: "ROAMDiscount", andTip: valdatTip ?? 0, andCurrency: "USD", andSurcharge: Int(shipp * 100) ?? 0)
        //
        //        }
        amount = IMSAmount.init(total: Int(totalAmount.rounded(toPlaces: 2)), andSubtotal: Int(subTotalVal), andTax: 0, andDiscount: 0, andDiscountDescription: "", andTip: valdatTip ?? 0, andCurrency: "USD", andSurcharge: 0)

        
        let request = IMSTokenSaleTransactionRequest(tokenReferenceNumber: appDelegate.strIngenicoSystemRefId, andTokenIdentifier: appDelegate.strIngenicoTokenData, andAmount: amount, andProducts: nil, andClerkID: "", andLongitude: getLongitude()!, andLatitude: getLatitude()!, andTransactionGroupID: nil, andTransactionNotes: "", andMerchantInvoiceID: "", andShowNotesAndInvoiceOnReceipt: false, andCustomReference: "", andIsCompleted: false, andOrderNumber: "")!
        Ingenico.sharedInstance()?.payment.processTokenSaleTransaction(request, andUpdateProgress: progressCallback!, andOnDone: doneCallback!)
    }
    
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
        // ingenicoDelegate.ingenicoDelegate
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
                    
                    appDelegate.showToast(message: "payment inter value")
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
        
        let discount = Double(self.str_AddDiscount) ?? 0.00
        
        let valdatTip = Int((tipIngenico.rounded(toPlaces: 2) * 100).roundOFF) ?? 0
        let totalAmount = total + (tipIngenico.rounded(toPlaces: 2) * 100)
        let shipp =  Double(self.str_ShippingANdHandling) ?? 0.00
        let subTotalVal = Int(totalAmount.rounded(toPlaces: 2)) - valdatTip
        var amount = IMSAmount()
        //        if HomeVM.shared.DueShared > 0.0 {
        //            amount = IMSAmount.init(total: Int(totalAmount.rounded(toPlaces: 2)), andSubtotal: 0, andTax: 0, andDiscount: 0, andDiscountDescription: "", andTip: valdatTip ?? 0, andCurrency: "USD")
        //
        //        } else {
        //            //amount = IMSAmount.init(total: Int(totalAmount.rounded(toPlaces: 2)), andSubtotal: Int(subTotalVal*100), andTax: Int(taxableAmtData * 100), andDiscount: Int(discount  * 100), andDiscountDescription: "ROAMDiscount", andTip: valdatTip ?? 0, andCurrency: "USD", andSurcharge: Int(shipp * 100) ?? 0)
        //
        //        }
        amount = IMSAmount.init(total: Int(totalAmount.rounded(toPlaces: 2)), andSubtotal: Int(subTotalVal), andTax: 0, andDiscount: 0, andDiscountDescription: "", andTip: valdatTip ?? 0, andCurrency: "USD", andSurcharge: 0)
        
        
        //let amount :IMSAmount = IMSAmount.init(total: Int(totalAmount.rounded(toPlaces: 2)), andSubtotal: Int(SubTotalPrice*100), andTax: Int(taxableAmtData * 100), andDiscount: Int(discount  * 100), andDiscountDescription: "ROAMDiscount", andTip: valdatTip ?? 0, andCurrency: "USD")
        let reverseAmount:IMSAmount = IMSAmount.init(total: Int(totalAmount.rounded(toPlaces: 2)), andSubtotal: -1, andTax: -1, andDiscount: -1, andDiscountDescription: nil, andTip: -1, andCurrency: "USD")
        
        let card:IMSCard = IMSCard.init()
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
                
                if HomeVM.shared.ingenicoData[0].tokenization_enabled {
                    //return IMSCreditSaleTransactionRequest.init(type: .TransactionTypeSale, andAmount: amount, andProducts: nil, andClerkID: clerkID, andLongitude: getLongitude(), andLatitude: getLatitude(), andTransactionGroupID: nil, andTransactionNotes: nil, andMerchantInvoiceID: nil, andShowNotesAndInvoiceOnReceipt: false, andTokenRequestParameters: getTokenRequestParams())
                    
                    return IMSCreditSaleTransactionRequest(amount:amount,
                                                                  andProducts: nil,
                                                                  andClerkID: clerkID,
                                                                  andLongitude: getLongitude(),
                                                                  andLatitude: getLatitude(),
                                                                  andTransactionGroupID: nil,
                                                                  andTransactionNotes: "",
                                                                  andMerchantInvoiceID: "",
                                                                  andShowNotesAndInvoiceOnReceipt: false,
                                                                  andTokenRequestParameters: getTokenRequestParams(),
                                                                  andCustomReference: "",
                                                                  andIsCompleted: false,
                                                                  andUCIFormat: .UCIFormatIngenico,
                                                                  andOrderNumber: "122122333")

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
                                                       andProducts: products,
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
        //        var strName = ""
        //        var strEmail = ""
        //        var strAddress = ""
        //
        //        if DataManager.customerId == "" {
        //            strName = response.cardholderName ?? ""
        //            strAddress = ""
        //            strEmail = ""
        //        } else {
        //
        //            let add1 = CustomerObj.str_Billingaddress + " " + CustomerObj.str_Billingaddress2 + " " + CustomerObj.str_Billingcity
        //            let add2 = CustomerObj.str_Billingregion + " " + CustomerObj.str_Billingpostal_code
        //            strName = CustomerObj.str_first_name + " " + CustomerObj.str_last_name
        //            strAddress = add1 + " " + add2
        //            strEmail = CustomerObj.str_email
        //        }
        
        var customerDetail = addressFill()
        if customerDetail.name.isEmpty && customerDetail.email.isEmpty && customerDetail.address.isEmpty {
            customerDetail.name = response.cardholderName ?? ""
            customerDetail.email = ""
            customerDetail.address = ""
            
        }
        
        ingenico?.user.updateTransaction(withTransactionID: response.transactionID, andCardholderInfo:getSampleCardholderInfo(name: customerDetail.name.condenseWhitespace(), email: customerDetail.email.condenseWhitespace(), address: customerDetail.address.condenseWhitespace()), andTransactionNote: nil, andIsCompleted: false, andDisplayNotesAndInvoice: true, andOnDone: { (error) in
            if error == nil{
                self.consoleLog(String("Update transaction succeeded"))
            } else {
                let nserror = error as NSError?
                self.consoleLog(String("Update transaction Failed with error\(self.getResponseCodeString((nserror?.code)!))"))
            }
            //self.sendReceipt(response.transactionID)
        })
        
        //self.updateTranasctionWithTransactionId(response.transactionID)
        
        isPayButtonSelected = true
        self.idleChargeButton()
        
        
        Indicator.sharedInstance.hideIndicator()
        placeOrder()
        //calculateTotal()
        //paymentViewDelegate?.returnDataSignature?(arrCardDataSignature: arrIngenico)
        
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
    
    
    func getSampleCardholderInfo(name:String,email:String,address:String)->IMSCardholderInfo{
        return IMSCardholderInfo.init(firstName: name,
                                      andLastName: "",
                                      andMiddleName: "",
                                      andEmail: email,
                                      andPhone: nil,
                                      andAddress1: address,
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
    
    func addressFill() -> (name : String, email: String, address: String){
        var name = ""
        var email = ""
        var address = ""
        
        var cust_str_Billingpostal_code = ""
        if CustomerObj.str_Billingpostal_code != "" {
            cust_str_Billingpostal_code = phoneNumberFormateRemoveText(number: CustomerObj.str_Billingpostal_code)
        }
        
        var cust_str_Shippingpostal_code = ""
        if CustomerObj.str_Shippingpostal_code != "" {
            cust_str_Shippingpostal_code = phoneNumberFormateRemoveText(number: CustomerObj.str_Shippingpostal_code)
        }
        
        
        
        if DataManager.isCheckUncheckShippingBilling {
            if (!CustomerObj.str_billing_first_name.isEmpty || !CustomerObj.str_billing_last_name.isEmpty || !CustomerObj.str_Billingaddress.isEmpty || !CustomerObj.str_Billingaddress2.isEmpty || !CustomerObj.str_Billingcity.isEmpty || !CustomerObj.str_Billingregion.isEmpty || !CustomerObj.billingCountry.isEmpty || !cust_str_Billingpostal_code.isEmpty || !CustomerObj.str_Billingemail.isEmpty) {
                name = CustomerObj.str_billing_first_name + " " + CustomerObj.str_billing_last_name
                email = CustomerObj.str_Billingemail
                address = CustomerObj.str_Billingaddress + " " + CustomerObj.str_Billingaddress2 + " " + CustomerObj.str_Billingcity + " " + CustomerObj.str_Billingregion + " " + CustomerObj.billingCountry + " " + cust_str_Billingpostal_code
                
            }
        }else{
            if (!CustomerObj.str_billing_first_name.isEmpty || !CustomerObj.str_billing_last_name.isEmpty || !CustomerObj.str_Billingaddress.isEmpty || !CustomerObj.str_Billingaddress2.isEmpty || !CustomerObj.str_Billingcity.isEmpty || !CustomerObj.str_Billingregion.isEmpty || !cust_str_Billingpostal_code.isEmpty || !CustomerObj.str_Billingemail.isEmpty) {
                name = CustomerObj.str_billing_first_name + " " + CustomerObj.str_billing_last_name
                email = CustomerObj.str_Billingemail
                address = CustomerObj.str_Billingaddress + " " + CustomerObj.str_Billingaddress2 + " " + CustomerObj.str_Billingcity + " " + CustomerObj.str_Billingregion + " " + CustomerObj.billingCountry + " " + cust_str_Billingpostal_code
                
            }else{
                if (!CustomerObj.str_shipping_first_name.isEmpty || !CustomerObj.str_shipping_last_name.isEmpty || !CustomerObj.str_Shippingaddress.isEmpty || !CustomerObj.str_Shippingaddress2.isEmpty || !CustomerObj.str_Shippingcity.isEmpty || !CustomerObj.str_Shippingregion.isEmpty || !CustomerObj.shippingCountry.isEmpty || !cust_str_Shippingpostal_code.isEmpty || !CustomerObj.str_Shippingemail.isEmpty) {
                    name = CustomerObj.str_shipping_first_name + " " + CustomerObj.str_shipping_last_name
                    email = CustomerObj.str_Shippingemail
                    address = CustomerObj.str_Shippingaddress + " " + CustomerObj.str_Shippingaddress2 + " " + CustomerObj.str_Shippingcity + " " + CustomerObj.str_Shippingregion + " " + CustomerObj.shippingCountry + " " + cust_str_Shippingpostal_code
                }
            }
        }
        return (name, email, address)
    }
    
    //       func updateTranasctionWithTransactionResponse(_ response: IMSTransactionResponse){
    //
    //           ingenico?.user.updateTransaction(withTransactionID: response.transactionID, andCardholderInfo:getSampleCardholderInfo(), andTransactionNote: nil, andIsCompleted: true, andDisplayNotesAndInvoice: true, andOnDone: { (error) in
    //               if error == nil{
    //                   self.consoleLog(String("Update transaction succeeded"))
    //               } else {
    //                   let nserror = error as NSError?
    //                   self.consoleLog(String("Update transaction Failed with error\(self.getResponseCodeString((nserror?.code)!))"))
    //               }
    //               self.sendReceipt(response.transactionID)
    //           })
    //       }
    
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
//MARK: EditProductsContainerViewDelegate
extension iPad_PaymentTypesViewController: EditProductsContainerViewDelegate {
   
    
    func didEditProduct(with identiifier: String) {
        if (identiifier == "iPad_ProductInfoViewController"){
            self.view_Bg.isHidden = false
            setView(view: containerViewIpadProductInfo, hidden: false)
        }
        // by anand cancel product info popup
        else if (identiifier == "ipad_CancelProductInfo"){
            self.view_Bg.isHidden = true
            setView(view: containerViewIpadProductInfo, hidden: true)
        }
    }
    
    func didReceiveProductDetail(data: ProductsModel) {
       // self.productsContainerDelegate?.didReceiveProductDetail?(data: data)
    }
}
//MARK: ProductsContainerViewControllerDelegate
extension iPad_PaymentTypesViewController: ProductsContainerViewControllerDelegate {
    func didSelectEditButton(data: ProductsModel, index: Int, isSearching: Bool) {
        productDelegate?.didSelectEditButton?(data: data, index: index, isSearching: isSearching)
    }
}

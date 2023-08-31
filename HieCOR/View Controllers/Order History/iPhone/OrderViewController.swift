//
//  OrderViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 05/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import CoreBluetooth
import CoreBluetooth.CBService
import SocketIO

class OrderViewController: BaseViewController {
    
    enum CellParamIndex: Int {
        case portName = 0
        case modelName
        case macAddress
    }
    
    //MARK: IBOutlet
    
    @IBOutlet weak var viewOfflineNetworkConnection: UIView!
    @IBOutlet weak var labelBalanceDueForiPhone: UILabel!
    @IBOutlet weak var viewBalanceDueForiPhone: UIView!
    @IBOutlet weak var viewForAdjustDesginForiPhone: UIView!
    @IBOutlet weak var viewOrderCompleted: UIView!
    @IBOutlet weak var viewAuthCode: UIView!
    @IBOutlet weak var labelAuthCode: UILabel!
    @IBOutlet weak var viewShowTotalAmountPartialy: UIView!
    @IBOutlet weak var labelTotalAmountPartialy: UILabel!
    @IBOutlet weak var labBalanceDueForPartialy: UILabel!
    @IBOutlet weak var viewBlanceDueForPartialy: UIView!
    @IBOutlet weak var labelOfflineMsg: UILabel!
    @IBOutlet var viewChangeDueLine: UIView!
    @IBOutlet var viewChargedToLine: UIView!
    @IBOutlet var viewChargedTo: UIView!
    @IBOutlet var viewHeightChargedTo: NSLayoutConstraint!
    @IBOutlet var labelChargedTo: UILabel!
    @IBOutlet weak var viewTotalChargedLine: UIView!
    @IBOutlet weak var labelHeadChargedTo: UILabel!
    @IBOutlet var viewTipLine: UIView!
    @IBOutlet var ViewDiscountLine: UIView!
    @IBOutlet var viewTaxLine: UIView!
    @IBOutlet var viewShippingLine: UIView!
    @IBOutlet var viewChangeDue: UIView!
    @IBOutlet var viewTip: UIView!
    @IBOutlet var viewDiscount: UIView!
    @IBOutlet var viewTax: UIView!
    @IBOutlet var viewShipping: UIView!
    @IBOutlet weak var viewTotalCharged: UIView!
    @IBOutlet var splitePaymentHeightConstraint: NSLayoutConstraint!
    @IBOutlet var changeDueHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tipHeightConstraint: NSLayoutConstraint!
    @IBOutlet var discountHeightConstraint: NSLayoutConstraint!
    @IBOutlet var taxHeightConstraint: NSLayoutConstraint!
    @IBOutlet var ShippingHeightConstraint: NSLayoutConstraint!
    @IBOutlet var SubTotalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalChargedHeightConstraint: NSLayoutConstraint!
    @IBOutlet var labelChangeDue: UILabel!
    @IBOutlet var labelHeadChangeDue: UILabel!
    @IBOutlet var labelTotal: UILabel!
    @IBOutlet var labelHeadTotal: UILabel!
    @IBOutlet var tableSplit: UITableView!
    @IBOutlet var labelHeadSubtotal: UILabel!
    @IBOutlet var labelHeadShipping: UILabel!
    @IBOutlet var labelSubtotal: UILabel!
    @IBOutlet var labelTax: UILabel!
    @IBOutlet var labelHeadTax: UILabel!
    @IBOutlet var labelShipping: UILabel!
    @IBOutlet var labelHeadPaymentType: UILabel!
    @IBOutlet var labelTip: UILabel!
    @IBOutlet var labelHeadTip: UILabel!
    @IBOutlet var labelDiscount: UILabel!
    @IBOutlet var labelHeadDiscount: UILabel!
    @IBOutlet weak var labelTotalCharged: UILabel!
    // @IBOutlet weak var labelChangeDue: UILabel!
    @IBOutlet weak var ipadHomeButtonView: UIView!
    @IBOutlet weak var iphoneHomeButtonView: UIView!
    @IBOutlet weak var customerInformationView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    //  @IBOutlet weak var totalPaidlabel: UILabel!
    @IBOutlet weak var view_CustomerMailView: UIView!
    @IBOutlet weak var view_CustomerMailViewHeightConstraint: NSLayoutConstraint!
    // @IBOutlet weak var lbl_TotalPaid: UILabel!
    @IBOutlet weak var lbl_OrderId: UILabel!
    @IBOutlet weak var lbl_CustomerEmail: UILabel!
    @IBOutlet weak var lbl_CustomerName: UILabel!
    @IBOutlet var view_KeyBoardUpBottomConstraint: NSLayoutConstraint!
    @IBOutlet var btn_AddNoteDone: UIButton!
    @IBOutlet var txt_AddNote: UITextView!
    @IBOutlet var view_KeyboardAddNotes: UIView!
    @IBOutlet var btn_Send: UIButton!
    @IBOutlet weak var btn_SendPhone: UIButton!
    @IBOutlet weak var receiptView: UIView!
    @IBOutlet weak var receiptViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    //  @IBOutlet weak var changeDueView: UIView!
    // @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneBackView: UIView!
    @IBOutlet weak var addNoteView: UIView!
    @IBOutlet weak var orderHistoryButtonIphone: UIButton!
    @IBOutlet weak var orderHistoryButtonIpad: UIButton!
    @IBOutlet weak var printReceiptButtonIpad: UIButton!
    @IBOutlet var backShadowView: UIView!
    @IBOutlet var backViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var backViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var orderIdVeiw: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var lockLineView: UIView!
    @IBOutlet var posLabel: UILabel!
    @IBOutlet var headerViewHeight: NSLayoutConstraint!
    @IBOutlet var btn_Menu: UIButton!
    @IBOutlet var backViewWidth: NSLayoutConstraint!
    @IBOutlet var backViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoutLineView: UIView!
    @IBOutlet weak var orderIdLabel: UILabel!
    //@IBOutlet var imageHeight: NSLayoutConstraint!
    
    @IBOutlet var ScrollViewMain: UIScrollView!
    @IBOutlet weak var tblHeights: NSLayoutConstraint!
    @IBOutlet weak var viewAddBotomLine: UIView!
    
    @IBOutlet weak var newOrderPaymentCompletView: UIView!
    @IBOutlet weak var exchnagePaymentCompleteView: UIView!
    @IBOutlet weak var exchangePaymentMethdShow: UILabel!
    @IBOutlet weak var lblTotalChargBanner: UILabel!
    @IBOutlet weak var refundedPaymentCompleteView: UIView!
    @IBOutlet weak var refundedTotalAmountLab: UILabel!
    
    @IBOutlet weak var refundPaymentMethodLab: UILabel!
    @IBOutlet weak var refundPaymentMethodWithAmountLab: UILabel!
    
    @IBOutlet weak var refundPaymentScrollHeightContnt: NSLayoutConstraint!
    @IBOutlet weak var scrollViewDataFilling: UIScrollView!
    
    @IBOutlet weak var viewSubTotal: UIView!
    
    @IBOutlet weak var viewsubTotalLine: UIView!
    @IBOutlet weak var lblOrderCompletedbanner: UILabel!
    @IBOutlet weak var constantOfflineLabel: NSLayoutConstraint!
    @IBOutlet weak var btn_Home: UIButton!
    @IBOutlet weak var btnHomeBottom: UIButton!
    @IBOutlet weak var btnHomeButtonIphone: UIButton!
    
    @IBOutlet weak var viewDeliveryOrderStatus: UIView!
    @IBOutlet weak var deliveryOrderStatusViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var deliveryOrderStatusCollectionView: UICollectionView!
    @IBOutlet weak var view_TestMode: UIView!
    //MARK: variables
    var heightKeyboard : CGFloat?
    var customView = UIView()
    var OrderedData = [String:AnyObject]()
    var refundOrderDataModelObj = RefundOrderDataModel()
    var receiptModel = ReceiptContentModel()
    var orderId = String()
    var paymentType = String()
    var total = Double()
    var change_due = Double()
    var shadowLayer: CAShapeLayer!
    var isHomeTapped = false
    var subTotal = Double()
    var shipping = Double()
    var tax = Double()
    var discountcharge = Double()
    var last4 = String()
    var discountV = String()
    var tenderValue = String()
    var tip = Double()
    var paymentTypeKey = String()
    var spliteArray = [String : AnyObject]()
    var arraySplite = NSMutableArray()
    var array = [String]()
    var strGooglePrint = ""
    var paxDevice = String()
    var delegate: PaymentTypeDelegate?
    var arrCardData = NSMutableArray()
    var signVCFlag = false
    var transactionId = String()
    
    //MARK: PrinterManager
    static var printerManager: PrinterManager?
    static var printerArray = [PrinterStruct]()
    static var printerUUID: UUID? = nil
    
    // Star printer
    var startPrntArray = NSMutableArray()
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
    
    static var centeralManager: CBCentralManager?
    //Star
    var starIoExtManager: StarIoExtManager!
    var orderDeliveryStatusArry = [OrderDeliveryStatus]()
    var selectDeliveryTypeStatusID = ""
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.isOpenUrl = false 
        appDelegate.isIngenicoDataFail = false // DD for Ingnico case fail 08 nov 2022
        DataManager.ingenicoOflineCaseData = nil // DD for Ingnico case fail 08 nov 2022
        appDelegate.arrIngenicoJsonArrayData.removeAll()
        appDelegate.isOpenUrl = false
        appDelegate.localBezierPath.removeAllPoints()
        if DataManager.isBluetoothPrinter {
            if paymentType == "cash" || paymentType == "check" {
                
                self.starIoExtManager = StarIoExtManager(type: StarIoExtManagerType.onlyBarcodeReader,
                                                     portName: LoadStarPrinter.getPortName(),
                                                 portSettings: LoadStarPrinter.getPortSettings(),
                                              ioTimeoutMillis: 10000)                             // 10000mS!!!

                self.starIoExtManager.cashDrawerOpenActiveHigh = LoadStarPrinter.getCashDrawerOpenActiveHigh()

                self.starIoExtManager.delegate =  self
                GlobalQueueManager.shared.serialQueue.async {
                    self.starIoExtManager.connect()
                    DispatchQueue.main.async {

                        //self.refreshCashDrawer()
                       // self.starIoExtManager.disconnect()
                            if self.starIoExtManager.port != nil {
                                self.openCashDrawer()
                            }

                    }
                }

            }
        }
        appDelegate.strPaxMode = ""
        if let type = OrderedData["isOrderRefunded"]as? Bool, type == true  {
             print("refund")
        }else{
         print("New Order")
            if let id = OrderedData["order_id"]as? String {
                if id == "" {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        MainSocketManager.shared.onCloseSignature()
                        //  socketDelegate?.callForSocketVC(str: "callback")
                    }
                }
            }
            
        }
        viewAuthCode.isHidden = true
        if let auth_code = OrderedData["auth_code"]as? String {
            self.labelAuthCode.text = "Auth Code: " + auth_code
            viewAuthCode.isHidden = auth_code == ""
        }
        
        if DataManager.isBalanceDueData == true {
            //DataManager.cartData?.removeAll()
            if HomeVM.shared.tipValue > 0 {
                
            } else {
                HomeVM.shared.tipValue = 0.0
            }
            
            
            viewShowTotalAmountPartialy.isHidden = false
            viewOrderCompleted.isHidden = true
            
            if let totalAmountPartial = OrderedData["cart_total"]as? Double {
                self.labelTotalAmountPartialy.text = "Total Amount: " + totalAmountPartial.currencyFormat
            }
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if let balance_due = OrderedData["balance_due"]as? Double {
                    
                    self.labBalanceDueForPartialy.text = "Balance Due: " + balance_due.currencyFormat
                    
                    viewBlanceDueForPartialy.isHidden = balance_due == 0.0
                    viewBalanceDueForiPhone.isHidden = true
                }
                
                viewBalanceDueForiPhone.isHidden = true
                viewForAdjustDesginForiPhone.isHidden = true
                viewBlanceDueForPartialy.isHidden = false
                labelHeadSubtotal.textAlignment = .right
                labelHeadSubtotal.text = "SubTotal: "
                labelSubtotal.textAlignment = .left
                viewsubTotalLine.isHidden = true
                
                labelHeadDiscount.textAlignment = .right
                labelHeadDiscount.text = "Discount: "
                labelDiscount.textAlignment = .left
                ViewDiscountLine.isHidden = true
                
                labelHeadShipping.textAlignment = .right
                labelHeadShipping.text = "Shipping: "
                labelShipping.textAlignment = .left
                viewShippingLine.isHidden = true
                
                labelHeadTax.textAlignment = .right
                labelHeadTax.text = "Tax: "
                labelTax.textAlignment = .left
                viewTaxLine.isHidden = true
                
                labelHeadTip.textAlignment = .right
                labelHeadTip.text = "Tip: "
                labelTip.textAlignment = .left
                viewTipLine.isHidden = true
                
                lblTotalChargBanner.textAlignment = .right
                lblTotalChargBanner.text = "Amount Paid: "
                lblTotalChargBanner.font = UIFont.boldSystemFont(ofSize: 15.0)
                labelTotalCharged.textAlignment = .left
                labelTotalCharged.font = UIFont.boldSystemFont(ofSize: 15.0)
                viewTotalChargedLine.isHidden = true
                
                labelHeadChangeDue.textAlignment = .right
                labelHeadChangeDue.text = "Change Due: "
                labelChangeDue.textAlignment = .left
                viewChangeDueLine.isHidden = true
                
                labelHeadChargedTo.textAlignment = .right
                labelHeadChargedTo.text = "Charged To: "
                labelChargedTo.textAlignment = .left
                viewChargedToLine.isHidden = true
                
                labelHeadPaymentType.textAlignment = .right
                labelHeadPaymentType.text = "Payment Method: "
                
                labBalanceDueForPartialy.layer.cornerRadius = 4
                labBalanceDueForPartialy.layer.masksToBounds = true
                
            }else{
                if let balance_due = OrderedData["balance_due"]as? Double {
                    self.labelBalanceDueForiPhone.text = "Balance Due: " + balance_due.currencyFormat
                    viewBalanceDueForiPhone.isHidden = balance_due == 0.0
                    viewBlanceDueForPartialy.isHidden = true
                }
                
                if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                    
                }else{
                    viewOfflineNetworkConnection.isHidden = true
                }
                labelTotalAmountPartialy.textAlignment = .center
                //viewBalanceDueForiPhone.isHidden = false
                labelBalanceDueForiPhone.layer.cornerRadius = 4
                labelBalanceDueForiPhone.layer.masksToBounds = true
            }
            btn_Home.isHidden = true
            lockButton.isHidden = true
            logoutButton.isHidden = true
            orderHistoryButtonIpad.isHidden = true
            addNoteView.isHidden = true
            btnHomeBottom.setTitle("Back To Payment", for: .normal)
        } else {
            // viewAuthCode.isHidden = true
            appDelegate.isOpenToOrderHistory = false
            viewShowTotalAmountPartialy.isHidden = true
            if UI_USER_INTERFACE_IDIOM() == .pad {
                viewForAdjustDesginForiPhone.isHidden = true
            }
            DataManager.selectedServiceId = ""
            DataManager.selectedServiceName = ""
            DataManager.selectedService = ""
            DataManager.selectedCarrierName = ""
            DataManager.selectedCarrier = ""
            DataManager.shippingWeight = 0
            DataManager.shippingWidth = 0
            DataManager.shippingLength = 0
            DataManager.shippingHeight = 0
            HomeVM.shared.tipValue = 0.0
            DataManager.cartData?.removeAll()
            HomeVM.shared.amountPaid = 0.0
            DataManager.duebalanceData = 0.0
            DataManager.isBalanceDueData = false
            HomeVM.shared.customerUserId = ""
            DataManager.CardCount = 0
            DataManager.EmvCardCount = 0
            DataManager.IngenicoCardCount = 0
            DataManager.customerId = ""
            appDelegate.isOpenToOrderHistory = false
        }
        
        increaseHeight()
        SwipeAndSearchVC.delegate = nil
        OfflineDataManager.shared.orderSuccessDelegate = self
        DataManager.Bbpid = ""
        DataManager.ErrorBbpid = ""
        DataManager.customerForShippingAddressId = ""
        HomeVM.shared.coupanDetail.code = ""
        
        DataManager.shippingaddressCount = 0
        DataManager.isUserPaxToken = ""
        if UI_USER_INTERFACE_IDIOM() == .pad {
            HomeVM.shared.DueShared = 0
        }
        DataManager.isCaptureButton = false
        DataManager.OrderDataModel = nil
        appDelegate.str_Refundvalue = ""
        DataManager.selectedCategory = "Home"
        appDelegate.isVoidPayment = false
        DataManager.finalLoyaltyDiscount = 0
        appDelegate.isIngenicoTokenAvl = false
        
        HomeVM.shared.MultiTipValue = 0.0
        HomeVM.shared.TotalDue = 0.0
        if DataManager.isBluetoothPrinter {
            loadPrinter()
            //loadStarPrint()
        }
        //loadPrinter()
        customizeUI()
        loadData()
        updateUI()
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            useForSocket()
        }
        loadSWRevealView()
        if paymentType == "pax_pay" {
            DataManager.selectedPaxDeviceName = paxDevice
        }
        
        var value = JSONArray()
        var IsNewEntry = false
        
        var paymentMethod = ""
        if let paymentType = OrderedData["payment_type_label"]as? String {
            paymentMethod = paymentType
        } else {
            let paymentTypeone = OrderedData["payment_type"]as? String
            paymentMethod = paymentTypeone?.capitalized ?? ""
        }
        
        if DataManager.posAutoPrintCreditCardFunctionality == "true" {
            if paymentMethod == "Credit" || paymentMethod == "credit" || paymentType == "pax_pay"{
                //self.checkPrinterConnection()
                if DataManager.isBluetoothPrinter {
                    self.checkPrinterConnection()
                }
                if !DataManager.isBluetoothPrinter && !DataManager.isGooglePrinter {
                    //            self.showAlert(message: "Please first enable the printer from settings")
                    appDelegate.showToast(message: "Please first enable the printer from settings")
                    return
                }
                
                if DataManager.isGooglePrinter && DataManager.starCloudMACaAddress == "" {
                    self.showAlert(message: "Please set default printer from printer settings.")
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter {
                        
                        //let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                        if DataManager.isBalanceDueData {
                            self.callAPItoGetTransactionPrintReceiptContent(transactionID: self.transactionId)
                        } else {
                            self.callAPItoGetReceiptContent()
                        }
                    }
                    
//                    if DataManager.isGooglePrinter {
//                        let Url = self.strGooglePrint
//                        //let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//                        if let url:NSURL = NSURL(string: Url) {
//                            UIApplication.shared.open(url as URL)
//                        }
//                    }
                }
            }
        }
        if DataManager.SavedPaymentArray != nil {
            
            var valueone = DataManager.SavedPaymentArray
            print(valueone as Any)
            
            for i in 0..<valueone!.count {
                let id = valueone![i]["userId"] as? String
                print(id as Any)
                
                let url = valueone![i]["baseUrl"] as? String
                print(url as Any)
                
                let type = valueone![i]["paymentMethod"] as? String
                print(type as Any)
                
                if (id == DataManager.appUserID) && (url == DataManager.loginBaseUrl) {
                    valueone![i]["paymentMethod"] = paymentMethod
                    DataManager.SavedPaymentArray = valueone
                    IsNewEntry = false
                    return
                } else {
                    IsNewEntry = true
                }
            }
            
            if IsNewEntry {
                let data : JSONDictionary = ["userId": DataManager.appUserID ,
                                             "baseUrl": DataManager.loginBaseUrl,
                                             "paymentMethod": paymentMethod]
                
                valueone?.append(data)
                
                DataManager.SavedPaymentArray = valueone
            }
            
        } else {
            let data : JSONDictionary = ["userId": DataManager.appUserID ,
                                         "baseUrl": DataManager.loginBaseUrl,
                                         "paymentMethod": paymentMethod]
            
            value.append(data)
            DataManager.SavedPaymentArray = value
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Indicator.sharedInstance.hideIndicator()        //ssk
    }
    
    func useForSocket(){
        MainSocketManager.shared.emitselectRecieptOption { (selectRecieptOptionForSocketObj) in
            //Parameters
            if DataManager.sessionID == selectRecieptOptionForSocketObj.session_id {
                
                if selectRecieptOptionForSocketObj.reciept_type == "email_reciept" {
                    let parameters: JSONDictionary = [
                        "order_id": String(selectRecieptOptionForSocketObj.order_id),
                        "email": selectRecieptOptionForSocketObj.email,
                        "txn_id":self.transactionId
                    ]
                    
                    self.callAPItoSendEmail(parameters: parameters)
                    if DataManager.isBalanceDueData {
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.navigationController?.popViewController(animated: true)
                        }
                       // self.navigationController?.popViewController(animated: true)
                        MainSocketManager.shared.oncloseRecieptModal()
                        self.offSocketEvent()
                        
                    }else{
                        //Call API to Send Email
                        MainSocketManager.shared.oncloseRecieptModal()
                        MainSocketManager.shared.onreset()
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.showHomeScreeen()
                        }
                        
                    }
                }
                
                if selectRecieptOptionForSocketObj.reciept_type == "no_reciept" {
                    
                    if DataManager.isBalanceDueData {
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.navigationController?.popViewController(animated: true)
                        }
                        MainSocketManager.shared.oncloseRecieptModal()
                        self.offSocketEvent()
                    }else{
                        MainSocketManager.shared.oncloseRecieptModal()
                        MainSocketManager.shared.onreset()
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.showHomeScreeen()
                        }
                    }
                    
                    
                }
                if selectRecieptOptionForSocketObj.reciept_type == "text_reciept" {
                    let stringURL = String(format: "%@%@",BaseURL, kSendText)
                    
                    //Parameters
                    let parameters: JSONDictionary = [
                        "order_id":self.orderId,
                        "phone": selectRecieptOptionForSocketObj.phone,
                        "txn_id": self.transactionId
                    ]
                    
                    //Call API
                    self.callAPItoSendMessage(url: stringURL, parameters: parameters)
                    
                }
                if selectRecieptOptionForSocketObj.reciept_type == "print_reciept" {
                    
                    if !DataManager.isBluetoothPrinter && !DataManager.isGooglePrinter {
                        //                         self.showAlert(message: "Please first enable the printer from settings")
                        appDelegate.showToast(message: "Please first enable the printer from settings")
                        return
                    }
                    if DataManager.isGooglePrinter && DataManager.starCloudMACaAddress == "" {
                        self.callAPItoGetstarCloudPrinterList()
                        return
                    }
                    if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter {
                        
                        //let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                        
                        self.callAPItoGetReceiptContent()
                    }
                    
//                    if DataManager.isGooglePrinter {
//                        let Url = self.strGooglePrint
//                        //let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//                        if let url:NSURL = NSURL(string: Url) {
//                            UIApplication.shared.open(url as URL)
//                        }
//                    }
                    //" B:1(C)|2(A)|3(C)|4(A)|5(c)|6(A)|7(C)|8(A)|9(C)/C:1(B)|2(C)|3(B)|4(C)|P|P|5(A)|6(C)7(A)/D:1(C)| 2(A)|3(C)|4(A)|P|P|5(C)|6(A)|7(C)/E:1(A)|2(C)|3(A)|4(C)|P|P|5(A)|6(C)|7(A)/F:1(C)|2(A)|3(C)|4(A)| P|P|5(C)|6(A)|7(C)"
                    if DataManager.isBalanceDueData {
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        MainSocketManager.shared.oncloseRecieptModal()
                        self.offSocketEvent()
                    }else{
                        MainSocketManager.shared.oncloseRecieptModal()
                        MainSocketManager.shared.onreset()
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.showHomeScreeen()
                        }
                    }
                }
                if selectRecieptOptionForSocketObj.reciept_type == "print_and_email_reciept" {
                    let parameters: JSONDictionary = [
                        "order_id": String(selectRecieptOptionForSocketObj.order_id),
                        "email": selectRecieptOptionForSocketObj.email,
                        "txn_id":self.transactionId
                    ]
                    
                    self.callAPItoSendEmail(parameters: parameters)
                    MainSocketManager.shared.oncloseRecieptModal()
                    if !DataManager.isBluetoothPrinter && !DataManager.isGooglePrinter {
                        //                         self.showAlert(message: "Please first enable the printer from settings")
                        appDelegate.showToast(message: "Please first enable the printer from settings")
                        return
                    }
                    if DataManager.isGooglePrinter && DataManager.starCloudMACaAddress == "" {
                        self.callAPItoGetstarCloudPrinterList()
                        return
                    }
                    if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter {
                        
                        //let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                        
                        self.callAPItoGetReceiptContent()
                    }
                    
//                    if DataManager.isGooglePrinter {
//                        let Url = self.strGooglePrint
//                        //let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//                        if let url:NSURL = NSURL(string: Url) {
//                            UIApplication.shared.open(url as URL)
//                        }
//                    }
                    if DataManager.isBalanceDueData {
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        MainSocketManager.shared.oncloseRecieptModal()
                        self.offSocketEvent()
                    }else{
                        MainSocketManager.shared.oncloseRecieptModal()
                        MainSocketManager.shared.onreset()
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.showHomeScreeen()
                        }
                    }
                }
            }
            
        }
    }
    func offSocketEvent(){
        MainSocketManager.shared.socket.off("selectRecieptOption")
        MainSocketManager.shared.socket.off("searchCustomer")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //7self.checkPrinterConnection()
        if DataManager.isBluetoothPrinter {
            self.checkPrinterConnection()
        }
        DataManager.collectTips = DataManager.collectTips ? DataManager.collectTips : DataManager.tempCollectTips
        hideReceiptView()
        //Disable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        //Add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = true
        OfflineDataManager.shared.orderSuccessDelegate = nil
        //Remove Observer
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.endEditing(true)
        setView(view: view_KeyboardAddNotes, hidden: true)
        customView.isHidden = true
        txt_AddNote.text = ""
        btn_AddNoteDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
        customView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height-158))
        updateUI()
        updateViewWidth()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.emailTextField.updateCustomBorder()
            self.phoneTextField.updateCustomBorder()
        }
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            printReceiptButtonIpad.isHidden = true
            receiptView.isHidden = true
        }
        updateViewWidth()
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.deliveryOrderStatusCollectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrdersHistory"
        {
            let vc = segue.destination as! OrderInfoViewController
            vc.orderID = self.orderId
        }
        
        if self.OrderedData["isOrderRefunded"] == nil {
            if segue.identifier == "MultipleSignatureViewSegue"
            {
                //                let vc = segue.destination as! MultipleSignatureViewController
                //                vc.orderID = self.orderId
                //                vc.arrCardData = arrCardData
                //                vc.socketDelegate = self
                //                signVCFlag = true
                //                if DataManager.socketAppUrl != "" {
                //                    MainSocketManager.shared.onOpenSignature(signArry: self.arrCardData)
                //                }
                //vc.signatureDelegate = self
            }
        }
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        super.performSegue(withIdentifier: identifier, sender: sender)
        
        if identifier == "OrdersHistory" {
            // now the vc3 was already pushed on the navigationStack
            var navStackArray : [UIViewController] = self.navigationController!.viewControllers
            // insert vc2 at second last position
            let viewController2 = self.storyboard?.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
            navStackArray.insert(viewController2, at: navStackArray.count - 1)
            // update navigationController viewControllers
            self.navigationController!.setViewControllers(navStackArray, animated:false)
        }
        
        //        if identifier == "MultipleSignatureViewSegue"
        //        {
        //            let vc = segue.destination as! MultipleSignatureViewController
        //            vc.CardCount = 6
        //        }
    }
    
    //MARK: Private Functions
    private func loadSWRevealView() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            btn_Menu.isHidden = true
            //            if DataManager.isBalanceDueData == true {
            //                btn_Menu.isHidden = true
            //                //btn_Menu.setImage(#imageLiteral(resourceName: "back-arrow-black"), for: .normal)
            //            } else {
            //                btn_Menu.setImage(#imageLiteral(resourceName: "menu-blue"), for: .normal)
            //                btn_Menu.isHidden = false
            //            }
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as? SWRevealViewController
            if (vc != nil)
            {
                vc!.delegate = self
                if let type = OrderedData["isOrderRefunded"]as? Bool, type == true  {
                     print("refund")
                }else{
                 print("New Order")
                    if !DataManager.refundExchangeCheckForCustomerApp {
                        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                            
                            var receiptModelForSocket = ReceiptModelForSocket()
                            receiptModelForSocket.change_due = self.labelChangeDue.text?.replacingOccurrences(of: "$", with: "") ?? ""
                            receiptModelForSocket.email = self.emailTextField.text ?? ""
                            receiptModelForSocket.order_id = Double(self.orderId) ?? 0.0
                            receiptModelForSocket.phone = self.phoneTextField.text ?? ""
                            receiptModelForSocket.session_id = DataManager.sessionID
                            receiptModelForSocket.paymentMethod = ""
                            
                            MainSocketManager.shared.onOpenRecieptModal(receiptModelForSocket: receiptModelForSocket)
                        }
                    }
                   
                }
//                if DataManager.isBalanceDueData == true {
//                    btn_Menu?.addTarget(vc, action: #selector(OrderViewController.btn_BackAction), for: UIControlEvents.touchUpInside)
//                } else {
//                    btn_Menu?.addTarget(vc, action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
//                }
//                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }else {
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                
                var receiptModelForSocket = ReceiptModelForSocket()
                receiptModelForSocket.change_due = self.labelChangeDue.text?.replacingOccurrences(of: "$", with: "") ?? ""
                receiptModelForSocket.email = self.emailTextField.text ?? ""
                receiptModelForSocket.order_id = Double(self.orderId) ?? 0.0
                receiptModelForSocket.phone = self.phoneTextField.text ?? ""
                receiptModelForSocket.session_id = DataManager.sessionID
                receiptModelForSocket.paymentMethod = ""
                MainSocketManager.shared.onOpenRecieptModal(receiptModelForSocket: receiptModelForSocket)
                
                
            }
            headerView.isHidden = true
            orderIdLabel.text = "Order #\(self.orderId)"
        }
    }
    // sudama for slipPayment
    @objc func btn_BackAction(){
        self.navigationController?.popViewController(animated: true)
    }
    //
    
    private func customizeUI() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            //Add Shadow
            self.backShadowView.clipsToBounds = false
            self.backShadowView.layer.shadowColor = UIColor.darkGray.cgColor
            self.backShadowView.layer.shadowOffset = CGSize.zero
            self.backShadowView.layer.shadowOpacity = 0.5
            self.backShadowView.layer.shadowRadius = 3
            self.viewAddBotomLine.isHidden = true
        }
        
        orderIdVeiw.isHidden = UI_USER_INTERFACE_IDIOM() == .pad
        txt_AddNote.delegate = self
        txt_AddNote.hideAssistantBar()
        emailTextField.delegate = self
        phoneTextField.delegate = self
        btn_Send.layer.borderWidth = 1.0
        btn_Send.layer.borderColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0).cgColor
        btn_SendPhone.layer.borderWidth = 1.0
        btn_SendPhone.layer.borderColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0).cgColor
        
        customView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height))
        customView.backgroundColor = UIColor.black
        customView.alpha = 0.5
        customView.isUserInteractionEnabled = false
        customView.isHidden = true
        self.view.addSubview(customView)
        
        self.customerInformationView.isHidden = true
        txt_AddNote.layer.masksToBounds = true
        txt_AddNote.layer.cornerRadius = 2.0
        txt_AddNote.layer.borderWidth = 1.0
        txt_AddNote.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        
        btn_AddNoteDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
        
        btn_AddNoteDone.isUserInteractionEnabled = false
        
        //Update Name
        if DataManager.isBalanceDueData == true {
            posLabel.text = ""
        }else{
            if let name = DataManager.deviceNameText {
                posLabel.text = name
            }else {
                let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
                posLabel.text = nameDevice//UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
            }
        }
        
        self.lockLineView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.lockButton.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.logoutButton.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.logoutLineView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        
        if DataManager.isBalanceDueData == true {
            btn_Home.isHidden = true
            lockButton.isHidden = true
            logoutButton.isHidden = true
            orderHistoryButtonIpad.isHidden = true
            addNoteView.isHidden = true
            btnHomeBottom.setTitle("Back To Payment", for: .normal)
        }
    }
    
    private func updateUI() {
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            orderHistoryButtonIphone.isHidden = true
            orderHistoryButtonIpad.isHidden = true
            printReceiptButtonIpad.isHidden = true
            receiptView.isHidden = true
            addNoteView.isHidden = true
            view_CustomerMailView.isHidden = true
            self.viewHeight.constant = UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? 250 : 280)
            //            self.labelHeadTotal.text = "Total"
            //            lblOrderCompletedbanner.text = "Order Queued"
            //            printReceiptButtonIpad.isHidden = true
            //            if UI_USER_INTERFACE_IDIOM() == .pad {
            //                labelOfflineMsg.isHidden = false
            //                labelOfflineMsg.font = labelOfflineMsg.font.withSize(12)
            //                labelOfflineMsg.numberOfLines = 0
            //                labelOfflineMsg.lineBreakMode = .byWordWrapping
            //                labelOfflineMsg.sizeToFit()
            //            }else{
            //                labelOfflineMsg.isHidden = false
            //                labelOfflineMsg.font = labelOfflineMsg.font.withSize(9)
            //                labelOfflineMsg.numberOfLines = 0
            //                labelOfflineMsg.lineBreakMode = .byWordWrapping
            //                labelOfflineMsg.sizeToFit()
            //            }
            //
            let dataOne  = self.splitePaymentHeightConstraint.constant + self.changeDueHeightConstraint.constant + self.tipHeightConstraint.constant
            let dataTwo = self.discountHeightConstraint.constant + self.taxHeightConstraint.constant + self.ShippingHeightConstraint.constant + self.SubTotalHeightConstraint.constant
            
            self.viewHeight.constant = dataOne + dataTwo
            
            if HomeVM.shared.customerDetail.str_email != "" || HomeVM.shared.customerDetail.str_first_name != "" || HomeVM.shared.customerDetail.str_last_name != "" {
                self.viewHeight.constant = dataOne + dataTwo - 40
            }else {
                self.viewHeight.constant = dataOne + dataTwo
            }
            updateViewHeight() // by sudama offline
        }else {
            //            labelOfflineMsg.isHidden = true
            //            self.labelHeadTotal.text = "Total Paid"
            //            lblOrderCompletedbanner.text = "Order Completed"
            orderHistoryButtonIphone.isHidden = false
            orderHistoryButtonIpad.isHidden = false
            printReceiptButtonIpad.isHidden = !DataManager.receipt
            receiptView.isHidden = !DataManager.receipt
            addNoteView.isHidden = false
            view_CustomerMailView.isHidden = false
            updateViewHeight()
            
        }
        
        if DataManager.isBalanceDueData == true {
            btn_Home.isHidden = true
            lockButton.isHidden = true
            logoutButton.isHidden = true
            orderHistoryButtonIpad.isHidden = true
            addNoteView.isHidden = true
            btnHomeBottom.setTitle("Back To Payment", for: .normal)
        }
    }
    
    private func handleAddNoteAction() {
        if self.txt_AddNote.text == "" {
            return
        }
        
        var actiontype = String()
        //Get Action Type
        if let userObject = UserDefaults.standard.value(forKey: "userdata") as? NSData {
            let userdata = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data)
            actiontype = ((userdata as AnyObject).value(forKey: "settings")as AnyObject).value(forKey: "action_type") as? String ?? ""
        }
        //Parameters
        let parameters: Parameters = [
            "order_id": self.orderId,
            "action_type": actiontype,
            "user_id": self.OrderedData["userID"]as? String ?? "",
            "note": self.txt_AddNote.text
        ]
        self.callAPItoSendNote(parameters: parameters)
    }
    
    private func loadData() {
        DataManager.isshippingRefundOnly = false
        DataManager.isTipRefundOnly = false
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            self.labelHeadTotal.text = "Total"
            lblOrderCompletedbanner.text = "Order Queued"
            printReceiptButtonIpad.isHidden = true
            labelOfflineMsg.isHidden = false
            constantOfflineLabel.constant = 22
            //            if UI_USER_INTERFACE_IDIOM() == .pad {
            //                labelOfflineMsg.isHidden = false
            //                labelOfflineMsg.font = labelOfflineMsg.font.withSize(12)
            //                labelOfflineMsg.numberOfLines = 0
            //                labelOfflineMsg.lineBreakMode = .byWordWrapping
            //                labelOfflineMsg.sizeToFit()
            //            }else{
            //                labelOfflineMsg.isHidden = false
            //                labelOfflineMsg.font = labelOfflineMsg.font.withSize(9)
            //                labelOfflineMsg.numberOfLines = 0
            //                labelOfflineMsg.lineBreakMode = .byWordWrapping
            //                labelOfflineMsg.sizeToFit()
            //            }
        }else{
            constantOfflineLabel.constant = 0
            labelOfflineMsg.isHidden = true
            self.labelHeadTotal.text = "Total Paid"
            lblOrderCompletedbanner.text = "Order Completed"
        }
        
        var paymentMethod = ""
        if let paymentType = OrderedData["payment_type_label"]as? String {
            paymentMethod = paymentType
        } else {
            let paymentTypeone = OrderedData["payment_type"]as? String
            paymentMethod = paymentTypeone?.capitalized ?? ""
        }
        
        if let id = OrderedData["order_id"]as? Int {
            self.orderId = "\(id)"
        }
        
        if let id = OrderedData["order_id"]as? String {
            self.orderId = id
        }
        lbl_OrderId.text = "#\(self.orderId)"
        
        //**********
        self.view_TestMode.isHidden = true
        if paymentType.lowercased() == "credit" {
            if let test_order = OrderedData["test_order"]as? Int {
                if test_order == 0 {
                    self.view_TestMode.isHidden = true
                }else {
                     self.view_TestMode.isHidden = false
                }
            }
        }
        //****************

        
        if let tender_value = OrderedData["tender_value"]as? String {
            self.tenderValue = tender_value
        }
        
        if let strGoogle = OrderedData["google_receipt_url"]as? String {
            self.strGooglePrint = strGoogle
        }
        
        self.emailTextField.text = HomeVM.shared.customerDetail.str_email
        self.phoneTextField.text = self.formattedPhoneNumber(number: HomeVM.shared.customerDetail.str_phone)
        
        print(strGooglePrint)
        if refundOrderDataModelObj.checkRefund {
            labelTotal.text = refundOrderDataModelObj.total.currencyFormat
            labelTotalCharged.text = refundOrderDataModelObj.total.currencyFormat
        }else{
            if let total = OrderedData["total"]as? String {
                let val = total.replacingOccurrences(of: ",", with: "")
                labelTotal.text = (Double(val) ?? 0.0).currencyFormat //  "$\(total)"
                labelTotalCharged.text = (Double(val) ?? 0.0).currencyFormat
            }else {
                if let total = OrderedData["total"]as? Double {
                    labelTotal.text = total.currencyFormat
                    labelTotalCharged.text = total.currencyFormat
                }
            }
        }
        
        //        if let subtotal = OrderedData["subtotal"]as? Double {
        //            self.subTotal = subtotal
        //        }
        if let subtotal = OrderedData["sub_total"]as? Double {
            self.subTotal = subtotal
        }
        labelSubtotal.text = subTotal.currencyFormat
        
        if let shipping = OrderedData["shipping"]as? Double {
            self.shipping = shipping
        }
        if shipping == 0{
            ShippingHeightConstraint.constant = 0
            viewShipping.isHidden = true
            viewShippingLine.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }else{
            labelShipping.text = shipping.currencyFormat
        }
        
        if let tax = OrderedData["tax"] as? String {
            self.tax = tax.toDouble() ?? 0.00
        }
        
        if let tax = OrderedData["tax"] as? Double {
            self.tax = tax
        }
        
        if tax == 0{
            taxHeightConstraint.constant = 0
            viewTax.isHidden = true
            viewTaxLine.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }else{
            labelTax.text = tax.currencyFormat
        }
        if let tip = OrderedData["tip"]as? String {
            self.tip = tip.toDouble()!
        }
        if tip == 0{
            tipHeightConstraint.constant = 0
            viewTip.isHidden = true
            viewTipLine.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }else{
            labelTip.text = tip.currencyFormat
        }
        /// ********************************
        // ORDER Delivery Status Type List
//        if DataManager.isBalanceDueData == true || paymentType == "INVOICE" || paymentType == "invoice" {
//            self.viewDeliveryOrderStatus.isHidden = true
//        } else {
            self.viewDeliveryOrderStatus.isHidden = true
            self.orderDeliveryStatusArry.removeAll()
            if let posSelectCustomOrderStatus = OrderedData["posSelectCustomOrderStatus"] as? String{
                if posSelectCustomOrderStatus == "true" {
                    if let statusID = OrderedData["statusID"] as? String {
                        self.selectDeliveryTypeStatusID = statusID
                    }
                    if let customOrderStatusObj = OrderedData["customOrderStatus"] as? JSONArray {
                        if customOrderStatusObj.count == 0 {
                            self.viewDeliveryOrderStatus.isHidden = true
                        } else {
                            self.viewDeliveryOrderStatus.isHidden = false
                        }
                        for obj in customOrderStatusObj {
                            if let id = obj["status_id"] as? String ,let name = obj["name"] as? String, let color = obj["color"] as? String , let isDisabled = obj["isDisabled"] as? Bool, let isSelected = obj["isSelected"] as? Bool{
                                let model = OrderDeliveryStatus.init(status_id: id, name: name,color: color,isDisabled: isDisabled,isSelected: isSelected)
                                self.orderDeliveryStatusArry.append(model)
                            }
                        }
                    }
                }
            }
        //}
        
        self.deliveryOrderStatusCollectionView.reloadData()
        ///***************************
        if let last4 = OrderedData["last4"]as? String {
            self.last4 = last4
        }
        if last4 == ""{
            viewHeightChargedTo.constant = 0
            viewChargedTo.isHidden = true
            viewChargedToLine.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }else{
            labelChargedTo.text = "***" + last4
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                
                self.arrCardData.removeAllObjects()
                
                var txnId = ""
                if let txnid = self.OrderedData["txn_id"]as? String {
                    txnId = txnid
                }
                
                let datavalue = ["card_number":self.last4,
                                 "txn_id": txnId]
                
                self.arrCardData.add(datavalue)
            }
        }
        
        if let discount: AnyObject = OrderedData["discount"]{
            if let disDouble = discount as? Double{
                if disDouble == 0 {
                    print("Hide View")
                    discountHeightConstraint.constant = 0
                    viewDiscount.isHidden = true
                    ViewDiscountLine.isHidden = true
                    discountV = "0.00"
                    view.setNeedsLayout()
                    view.setNeedsDisplay()
                }else{
                    self.discountV = "\(disDouble.currencyFormat)"
                    labelDiscount.text =  self.discountV
                }
            }else{
                if let disString = discount as? String {
                    if disString == "0" || disString == "0.00"{
                        discountHeightConstraint.constant = 0
                        viewDiscount.isHidden = true
                        ViewDiscountLine.isHidden = true
                        discountV = "0.00"
                        view.setNeedsLayout()
                        view.setNeedsDisplay()
                    }else{
                        let ob = Double(disString)?.currencyFormat
                        let val = String(describing: ob!)
                        labelDiscount.text = val
                        self.discountV = val
                    }
                }
            }
        }else {
            
            discountHeightConstraint.constant = 0
            viewDiscount.isHidden = true
            ViewDiscountLine.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }
        
        if discountV != "$0.00"  {
            discountHeightConstraint.constant = 20
            labelDiscount.text = discountV
            viewDiscount.isHidden = false
            labelDiscount.isHidden = false
            if DataManager.isBalanceDueData == true {
                ViewDiscountLine.isHidden = true
            }else{
                ViewDiscountLine.isHidden = false
            }
        }
        if discountV == "0.00" || discountV == "" {
            discountHeightConstraint.constant = 0
            //labelDiscount.text = discountV
            viewDiscount.isHidden = true
            labelDiscount.isHidden = true
            ViewDiscountLine.isHidden = true
        }
        
        if let paymentType = OrderedData["payment_type_label"]as? String {
            self.paymentTypeKey = paymentType
        } else {
            let paymentTypeone = OrderedData["payment_type"]as? String
            paymentTypeKey = paymentTypeone?.capitalized ?? ""
            
        }
        
        if let paymentType = OrderedData["payment_status"]as? String {
            self.paymentTypeKey = paymentType
        }
        
        if paymentType == "multi_card" || paymentType == "Multi_Card" {
            labelHeadPaymentType.text = "Split Payment"
        }else{
            if paymentType == "pax_pay" {
                labelHeadPaymentType.text = "EMV"
            } else {
                labelHeadPaymentType.text = self.paymentTypeKey.capitalized
            }
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if DataManager.isBalanceDueData == true {
                labelHeadPaymentType.textAlignment = .right
                labelHeadPaymentType.text = "Payment Method: "
            }}
        let changeDue = UserDefaults.standard.object(forKey: "changeAmountKey") as? Double ?? 0.0
        if changeDue == 0{
            labelChangeDue.text = ""
            changeDueHeightConstraint.constant = 0
            viewChangeDue.isHidden = true
            viewChangeDueLine.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }else{
            labelChangeDue.text = changeDue.currencyFormat
        }
        
        if let trId = OrderedData["txn_id"] as? String {
            transactionId = trId
        }
        
        if let trId = OrderedData["txn_id"] as? Double {
            transactionId = "\(trId)"
        }
        
        
        if let id = OrderedData["change_due"]as? Double {
            
            if id == 0 {
                changeDueHeightConstraint.constant = 0
                viewChangeDue.isHidden = true
                viewChangeDueLine.isHidden = true
                view.setNeedsLayout()
                view.setNeedsDisplay()
            } else {
                changeDueHeightConstraint.constant = 20
                viewChangeDue.isHidden = false
                viewChangeDueLine.isHidden = false
                view.setNeedsLayout()
                view.setNeedsDisplay()
                self.change_due = id
                labelChangeDue.text = change_due.currencyFormat
            }
        }
        
        if let multicard  = OrderedData["multi_card"]as? JSONDictionary{
            
            array.removeAll()
            
            if let credit = multicard["credit"] as? JSONArray{
                for ob in credit{
                    let amount = ob["amount"] as? String
                    let last4 = ob ["last4"] as? String
                    
                    if let val = amount {
                        let ob = Double(val)?.currencyFormat
                        var strData = ""
                        if last4 == "" {
                            strData = "Credit: \(ob!)"
                        } else {
                            strData = "Credit***\(last4!): \(ob!)"
                        }
                        
                        
                        array.append(strData)
                    }
                    
                    var txnId = ""
                    if let txnid = ob["txn_id"]as? String {
                        txnId = txnid
                    }
                    
                    let datavalue = ["card_number":last4,
                                     "txn_id": txnId]
                    
                    self.arrCardData.add(datavalue)
                    
                }
                
                spliteArray["credit"] = array as AnyObject
            }
            if let cash = multicard["cash"] as? JSONArray{
                for ob in cash{
                    var amount = ob["amount"] as? String
                    
                    if let amt = ob["amount"] as? String {
                        amount = amt
                    }
                    
                    if let amt = ob["amount"] as? Double {
                        amount = "\(amt)"
                    }
                    
                    if let val = amount {
                        let ob = Double(val)?.currencyFormat
                        let strData = "Cash: \(ob!)"
                        array.append(strData)
                    }
                    //                    let strData = "Cash - \("$" + amount!)"
                }
                spliteArray["cash"] = array as AnyObject
            }
            if let check = multicard["check"] as? JSONArray{
                for ob in check{
                    let amount = ob["amount"] as? String
                    if let val = amount {
                        let ob = Double(val)?.currencyFormat
                        let strData = "Check: \(ob!)"
                        array.append(strData)
                    }
                    // array.append(strData)
                }
                spliteArray["check"] = array as AnyObject
            }
            if let achCheck = multicard["ach_check"] as? JSONArray{
                for ob in achCheck{
                    let amount = ob["amount"] as? String
                    if let val = amount {
                        let ob = Double(val)?.currencyFormat
                        let strData = "Ach Check: \(ob!)"
                        array.append(strData)
                    }
                }
                spliteArray["ach_check"] = array as AnyObject
            }
            if let external = multicard["external"] as? JSONArray{
                for ob in external{
                    let amount = ob["amount"] as? String
                    // let strData = "External - \("$" + amount!)"
                    if let val = amount {
                        let ob = Double(val)?.currencyFormat
                        let strData = "External: \(ob!)"
                        array.append(strData)
                    }
                }
                spliteArray["external"] = array as AnyObject
            }
            if let externalGift = multicard["external_gift"] as? JSONArray{
                for ob in externalGift{
                    let amount = ob["amount"] as? String
                    if let val = amount {
                        let ob = Double(val)?.currencyFormat
                        let strData = "External Gift: \(ob!)"
                        array.append(strData)
                    }
                }
                spliteArray["external_gift"] = array as AnyObject
            }
            if let GiftCard = multicard["gift_card"] as? JSONArray{
                for ob in GiftCard{
                    let amount = ob["amount"] as? String
                    //let strData = "Gift Card - \("$" + amount!)"
                    if let val = amount {
                        let ob = Double(val)?.currencyFormat
                        let strData = "Gift Card: \(ob!)"
                        array.append(strData)
                    }
                }
                spliteArray["gift_card"] = array as AnyObject
            }
            if let internalGiftCard = multicard["internal_gift_card"] as? JSONArray{
                for ob in internalGiftCard{
                    let amount = ob["amount"] as? String
                    //let strData = "Internal Gift Card - \("$" + amount!)"
                    //array.append(strData)
                    if let val = amount {
                        let ob = Double(val)?.currencyFormat
                        let strData = "Internal Gift Card: \(ob!)"
                        array.append(strData)
                    }
                }
                spliteArray["internal_gift_card"] = array as AnyObject
            }
            if let internalGiftCard = multicard["STORE_CREDIT"] as? JSONArray{
                for ob in internalGiftCard{
                    let amount = ob["amount"] as? String
                    //let strData = "Internal Gift Card - \("$" + amount!)"
                    //array.append(strData)
                    
                    let last4 = ob ["last4"] as? String
                    
                    if let val = amount {
                        let ob = Double(val)?.currencyFormat
                        let strData = "STORE_CREDIT***\(last4!) : \(ob!)"
                        array.append(strData)
                    }
                }
                spliteArray["STORE_CREDIT"] = array as AnyObject
            }
            if let paxPay = multicard["pax_pay"] as? JSONArray{
                for ob in paxPay{
                    let amount = ob["amount"] as? String
                    //                    let strData = "Pax Pay - \("$" + amount!)"
                    //                    array.append(strData)
                    if let val = amount {
                        let ob = Double(val)?.currencyFormat
                        let strData = "EMV: \(ob!)"
                        array.append(strData)
                    }
                    
                    var last4 = ""
                    
                    if let last = ob["last4"]as? String {
                        last4 = last
                    }
                    
                    var txnId = ""
                    if let txnid = ob["txn_id"]as? String {
                        txnId = txnid
                    }
                    
                    let datavalue = ["card_number":last4,
                                     "txn_id": txnId]
                    
                    self.arrCardData.add(datavalue)
                    
                }
                spliteArray["pax_pay"] = array as AnyObject
            }
            arraySplite.add(spliteArray)
            
            tblHeights.constant = CGFloat(array.count * 40)
            
            tableSplit.reloadData()
            
        }
        
        if DataManager.signature {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if self.arrCardData.count > 0 {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        if self.OrderedData["isOrderRefunded"] == nil {
                            //self.performSegue(withIdentifier: "MultipleSignatureViewSegue", sender: nil)
                        }
                        //self.delegate?.didPerformSegueWith?(identifier: "MultipleSignatureViewSegue")
                    }else {
                        if self.OrderedData["isOrderRefunded"] == nil {
                            //self.performSegue(withIdentifier: "MultipleSignatureViewSegue", sender: nil)
                        }
                    }
                }
            }
        }
        
        if array.isEmpty{
            
            array.removeAll()
            
            var strval = ""
            if tenderValue == ""{
                strval = total.currencyFormat
            }else{
                strval = "$" + tenderValue
            }
            
            if strval == "$0.00" {
                strval = "\(paymentTypeKey): \(labelTotal.text!)"
            }
            
            if DataManager.isBalanceDueData {
                array.append(labelTotal.text!)
            } else {
                array.append(strval)
            }
            
            
            
            tblHeights.constant = CGFloat(array.count * 80)
            
            tableSplit.reloadData()
        }
        
        //Priya
        // labelChangeDue.text = strChangeDue
        // changeDueView.isHidden = changeDue <= 0
        // lineView.isHidden = changeDue <= 0
        
        //    lblOrderCompletedbanner.text = "Order Completed"
        
        
        
        
        if let type = OrderedData["isOrderRefunded"]as? Bool, type == true {
            exchnagePaymentCompleteView.isHidden = true
            newOrderPaymentCompletView.isHidden = true
            refundedPaymentCompleteView.isHidden = true
            
            
            
            if let paymentType = OrderedData["payment_type_label"]as? String {
                exchangePaymentMethdShow.text = paymentType.capitalized
            }
            
            var data = ""
            for i in 0..<array.count {
                let val = array[i]
                data = "\(val) \n \(data)"
            }
            lblOrderCompletedbanner.text = "Exchange Completed"
            
            exchangePaymentMethdShow.text = ""
            
            //Priya
            //totalPaidlabel.text = "Refunded Successfully"
            labelHeadTotal.text = "Refunded Amount"
        }else {
            
            if refundOrderDataModelObj.checkRefund {
                var paymentValue = ""
                var paymentValueRefundBy = ""
                labelHeadTotal.text = "Refunded Successful"
                orderId = refundOrderDataModelObj.order_id
                lbl_OrderId.text = "#\(self.orderId)"
                exchnagePaymentCompleteView.isHidden = true
                newOrderPaymentCompletView.isHidden = true
                refundedPaymentCompleteView.isHidden = false
                refundedTotalAmountLab.text = String(refundOrderDataModelObj.total.currencyFormat)
                paymentValueRefundBy = ""
                for i in refundOrderDataModelObj.refundedBy {
                    if refundOrderDataModelObj.refundedBy.count == 1 {
                        paymentValue = (Double(i.amount) ?? 0.0).currencyFormat
                        refundPaymentMethodLab.text = i.type
                    }else{
                        refundPaymentMethodLab.text = "Refund By"
                        
                        if i.type != "" {
                            paymentValueRefundBy = paymentValueRefundBy + "\(i.type): \((Double(i.amount) ?? 0.0).currencyFormat)\n"
                        }
                    }
                }
                if refundOrderDataModelObj.refundedBy.count == 1 {
                    refundPaymentMethodWithAmountLab.text = paymentValue
                }else{
                    refundPaymentMethodWithAmountLab.text = paymentValueRefundBy
                }
                
                
            }else{
                exchnagePaymentCompleteView.isHidden = true
                newOrderPaymentCompletView.isHidden = false
                refundedPaymentCompleteView.isHidden = true
                if paymentType == "INVOICE" || paymentType == "invoice" {
                    //Priya
                    labelHeadTotal.text = "Invoice Created"
                    lblTotalChargBanner.text = "Total"
                }else{
                    //Priya
                    if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                        self.labelHeadTotal.text = "Total"
                    }else{
                        labelHeadTotal.text = "Total Paid"
                    }
                    if DataManager.isBalanceDueData == true {
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            lblTotalChargBanner.text = "Amount Paid: "
                            
                        }else{
                            lblTotalChargBanner.text = "Amount Paid"
                        }
                    }else{
                        lblTotalChargBanner.text = "Total Charged"
                    }
                    
                }
            }
        }
        
        if paymentType == "INVOICE" || paymentType == "invoice" {
            lblOrderCompletedbanner.text = "Invoice Created"
            labelHeadTotal.text = "Invoice Amount"
        }
        
        
        var email = OrderedData["email"] as? String ?? ""
        var phone = self.OrderedData["phone"] as? String ?? ""
        var name = self.OrderedData["userName"] as? String ?? ""
        var id = OrderedData["userID"] as? String ?? "0"
        if refundOrderDataModelObj.checkRefund {
            email = refundOrderDataModelObj.email
            name = refundOrderDataModelObj.userName
            id = refundOrderDataModelObj.userID
            phone = refundOrderDataModelObj.phone
        }
        
        self.lbl_CustomerName.text = name
        self.lbl_CustomerEmail.text = email
        self.emailTextField.text = email
        self.phoneTextField.text = formattedPhoneNumber(number: phone)
        
        if email == "" && (name == "" || name == " " ){
            self.customerInformationView.isHidden = true
        }else {
            self.customerInformationView.isHidden = false
        }
        
        
        if labelDiscount.text == "$0.00" {
            discountHeightConstraint.constant = 0
            viewDiscount.isHidden = true
            ViewDiscountLine.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }
        
        if labelSubtotal.text == "$0.00" {
            SubTotalHeightConstraint.constant = 0
            labelHeadSubtotal.isHidden = true
            labelSubtotal.isHidden = true
            viewsubTotalLine.isHidden = true
            viewSubTotal.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }
        
        //self.getCustomersDetail(id: id)
        if paymentType == "INVOICE" || paymentType == "invoice" {
            lblOrderCompletedbanner.text = "Invoice Created"
            labelHeadTotal.text = "Invoice Amount"
            lblTotalChargBanner.text = "Total to be paid"
            SubTotalHeightConstraint.constant = 0
            labelHeadSubtotal.isHidden = true
            labelSubtotal.isHidden = true
            viewsubTotalLine.isHidden = true
            viewSubTotal.isHidden = true
            discountHeightConstraint.constant = 0
            viewDiscount.isHidden = true
            labelDiscount.isHidden = true
            ViewDiscountLine.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }
        
        if DataManager.isBalanceDueData {
            lblOrderCompletedbanner.font = UIFont.init(name: "OpenSans", size: 18)
            lblOrderCompletedbanner.text = "Order Is Partially Completed"
            discountHeightConstraint.constant = 0
            viewDiscount.isHidden = true
            ViewDiscountLine.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.deliveryOrderStatusCollectionView.reloadData()
        }
        
        //Offline
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            lbl_OrderId.text = "#Pending"
            //Priya
            self.labelTotal.text = total.currencyFormat
            labelSubtotal.text = subTotal.currencyFormat
            labelTotalCharged.text = total.currencyFormat
            labelHeadPaymentType.text = paymentType.capitalized // by sudama offline
            if discountV != "$0.00"  {
                discountHeightConstraint.constant = 20
                labelDiscount.text = discountV
                viewDiscount.isHidden = false
                labelDiscount.isHidden = false
                ViewDiscountLine.isHidden = false
            }
            if discountV == "0.0" || discountV == "" {
                discountHeightConstraint.constant = 0
                //labelDiscount.text = discountV
                viewDiscount.isHidden = true
                labelDiscount.isHidden = true
                ViewDiscountLine.isHidden = true
            }
            
            if tax > 0 {
                labelTax.text = tax.currencyFormat
                viewTax.isHidden = false
                taxHeightConstraint.constant = 20
            }
            
            if tip > 0 {
                labelTip.text = tip.currencyFormat
                viewTip.isHidden = false
                tipHeightConstraint.constant = 20
            }
            
            if changeDue > 0 {
                let totalOne = total + changeDue
                array.removeAll()
                array.append("\(totalOne.currencyFormat)")
                tableSplit.reloadData()
            }
            
            view.setNeedsLayout()
            view.setNeedsDisplay()
            return
        }
        
    }
    
    private func showLockScreen() {
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "iPad_AccessPINViewController") as! iPad_AccessPINViewController
            controller.delegate = self
            if #available(iOS 13.0, *) {
                controller.modalPresentationStyle = .fullScreen
            }
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AccessPINViewController") as! AccessPINViewController
            controller.delegate = self
            if #available(iOS 13.0, *) {
                controller.modalPresentationStyle = .fullScreen
            }
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    private func updateViewHeight() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
                
                self.viewHeight.constant = (UIScreen.main.bounds.size.height/1.85) - (customerInformationView.isHidden ? 0 : 62) - 80
                
                let dataOne  = self.splitePaymentHeightConstraint.constant + self.changeDueHeightConstraint.constant + self.tipHeightConstraint.constant + self.viewHeightChargedTo.constant
                let dataTwo = self.discountHeightConstraint.constant + self.taxHeightConstraint.constant + self.ShippingHeightConstraint.constant + self.SubTotalHeightConstraint.constant
                
                self.viewHeight.constant = dataOne + dataTwo + 70
                
                
                if array.count == 1 {
                    scrollViewDataFilling.isScrollEnabled = false
                } else {
                    scrollViewDataFilling.isScrollEnabled = true
                }
                
                if DataManager.isBalanceDueData == true {
                    self.viewHeight.constant = (UIScreen.main.bounds.size.height/1.85) - (customerInformationView.isHidden ? 0 : 62) - 80
                    
                    let dataOne  = 70 + self.tipHeightConstraint.constant + self.totalChargedHeightConstraint.constant + self.viewHeightChargedTo.constant
                    let dataTwo = self.discountHeightConstraint.constant + self.taxHeightConstraint.constant + self.ShippingHeightConstraint.constant + self.SubTotalHeightConstraint.constant
                    
                    self.viewHeight.constant = dataOne + dataTwo
                    
                }
                
                //                if HomeVM.shared.customerDetail.str_email == "" {
                //                    self.viewHeight.constant = dataOne + dataTwo
                //                }else {
                //                    self.viewHeight.constant = dataOne + dataTwo - 40
                //                }
                
                //self.viewHeight.constant = (UIScreen.main.bounds.size.height -
                
            }else {
                self.viewHeight.constant = (UIScreen.main.bounds.size.height/1.53) - (customerInformationView.isHidden ? 0 : 62) - 105
                
                let dataOne  = self.splitePaymentHeightConstraint.constant + self.changeDueHeightConstraint.constant + self.tipHeightConstraint.constant + self.viewHeightChargedTo.constant
                let dataTwo = self.discountHeightConstraint.constant + self.taxHeightConstraint.constant + self.ShippingHeightConstraint.constant + self.SubTotalHeightConstraint.constant
                
                self.viewHeight.constant = dataOne + dataTwo + 70
                
                if array.count == 1 {
                    scrollViewDataFilling.isScrollEnabled = false
                } else {
                    scrollViewDataFilling.isScrollEnabled = true
                }
                
                if DataManager.isBalanceDueData == true {
                    self.viewHeight.constant = (UIScreen.main.bounds.size.height/1.53) - (customerInformationView.isHidden ? 0 : 62) - 105
                    
                    let dataOne  = 70 + self.tipHeightConstraint.constant + self.totalChargedHeightConstraint.constant + self.viewHeightChargedTo.constant
                    let dataTwo = self.discountHeightConstraint.constant + self.taxHeightConstraint.constant + self.ShippingHeightConstraint.constant + self.SubTotalHeightConstraint.constant
                    
                    self.viewHeight.constant = dataOne + dataTwo
                }
                //                if HomeVM.shared.customerDetail.str_email == "" {
                //                    self.viewHeight.constant = dataOne + dataTwo
                //                }else {
                //                    self.viewHeight.constant = dataOne + dataTwo - 40
                //                }
            }
        }else {
            // self.imageHeight.isActive = false
            self.viewHeight.constant = (UIScreen.main.bounds.size.height/2.1) - (customerInformationView.isHidden ? 0 : 62) - 30
            if UIScreen.main.bounds.size.height == 667.0 {
                //self.imageHeight.isActive = true
                //self.imageHeight.constant = customerInformationView.isHidden || !DataManager.receipt ? 120 : 100
                self.viewHeight.constant = (UIScreen.main.bounds.size.height/2.1) - (customerInformationView.isHidden || !DataManager.receipt ? 0 : 62) - 63
            }
            if UIScreen.main.bounds.size.height == 568.0 {
                self.viewHeight.constant = (UIScreen.main.bounds.size.height/2.1) - 20
            }
            
            let dataOne  = self.splitePaymentHeightConstraint.constant + self.changeDueHeightConstraint.constant + self.tipHeightConstraint.constant
            let dataTwo = self.discountHeightConstraint.constant + self.taxHeightConstraint.constant + self.ShippingHeightConstraint.constant + self.SubTotalHeightConstraint.constant
            
            self.viewHeight.constant = dataOne + dataTwo - 25
            
            if HomeVM.shared.customerDetail.str_email != "" || HomeVM.shared.customerDetail.str_first_name != "" || HomeVM.shared.customerDetail.str_last_name != "" {
                self.viewHeight.constant = dataOne + dataTwo - 40
            }else {
                self.viewHeight.constant = dataOne + dataTwo - 25
            }
            
            
        }
    }
    
    func updateViewWidth() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
                backViewTrailingConstraint.constant = 170
                backViewLeadingConstraint.constant = 170
                backViewWidth.constant = UIScreen.main.bounds.size.width - 340
                backViewTopConstraint.constant = 55
            }else {
                backViewTrailingConstraint.constant = 60
                backViewLeadingConstraint.constant = 60
                backViewWidth.constant = UIScreen.main.bounds.size.width - 120
                backViewTopConstraint.constant = 80
            }
        } else {
            backViewTrailingConstraint.constant = 0
            backViewLeadingConstraint.constant = 0
            backViewTopConstraint.constant = 0
            backViewWidth.constant = UIScreen.main.bounds.size.width - 200
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
    
    private func hideReceiptView() {
        if DataManager.receipt {
            self.receiptView.isHidden = false
            self.receiptViewHeight.constant = 45
        }else {
            self.receiptView.isHidden = true
            self.receiptViewHeight.constant = 0
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.ipadHomeButtonView.isHidden = false
            self.iphoneHomeButtonView.isHidden = true
            self.receiptView.isHidden = true
            self.receiptViewHeight.constant = 0
        }else {
            self.ipadHomeButtonView.isHidden = true
            self.iphoneHomeButtonView.isHidden = false
            if DataManager.isBalanceDueData {
                btnHomeButtonIphone.setTitle("Back To Payment", for: .normal)
                orderHistoryButtonIphone.isHidden = true
            } else {
                btnHomeButtonIphone.setTitle("Home", for: .normal)
                orderHistoryButtonIphone.isHidden = false
            }
        }
        view_KeyboardAddNotes.isHidden = true
    }
    
    private func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: nil)
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
//                            let commands: Data
//                            
//                            let emulation: StarIoExtEmulation = LoadStarPrinter.getEmulation()
//                    print(emulation)
//                            
//                            let width: Int = LoadStarPrinter.getSelectedPaperSize().rawValue
//                            
//                            let paperSize: PaperSizeIndex = LoadStarPrinter.getSelectedPaperSize()
//                            let language: LanguageIndex = LanguageIndex.english//LoadStarPrinter.getSelectedLanguage()
//                            let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(language,
//                                                                                                              paperSizeIndex: paperSize)
//                            commands = PrinterFunctions.createTextReceiptApiData(emulation,utf8: true)
//                            
//                            //self.blind = true
//                            
//                  //  if #available(iOS 13.0, *) {
//                        Communication.sendCommandsForPrintReDirection(commands,
//                                                                      timeout: 10000) { (communicationResultArray) in
//                                                                       // self.blind = false
//                                                                        
//                                                                        var message: String = ""
//                                                                        
//                                                                        for i in 0..<communicationResultArray.count {
//                                                                            if i == 0 {
//                                                                                message += "[Destination]\n"
//                                                                            }
//                                                                            else {
//                                                                                message += "[Backup]\n"
//                                                                            }
//                                                                            
//                                                                            message += "Port Name: " + communicationResultArray[i].0 + "\n"
//                                                                            
//                                                                            switch communicationResultArray[i].1.result {
//                                                                            case .success:
//                                                                                message += "----> Success!\n\n";
//                                                                            case .errorOpenPort:
//                                                                                message += "----> Fail to openPort\n\n";
//                                                                            case .errorBeginCheckedBlock:
//                                                                                message += "----> Printer is offline (beginCheckedBlock)\n\n";
//                                                                            case .errorEndCheckedBlock:
//                                                                                message += "----> Printer is offline (endCheckedBlock)\n\n";
//                                                                            case .errorReadPort:
//                                                                                message += "----> Read port error (readPort)\n\n";
//                                                                            case .errorWritePort:
//                                                                                message += "----> Write port error (writePort)\n\n";
//                                                                            default:
//                                                                                message += "----> Unknown error\n\n";
//                                                                            }
//                                                                        }
//                                                                        
//                                                                        
//                                                                        
//                                                                        //                                                                    self.showSimpleAlert(title: "Communication Result",
//                                                                        //                                                                                         message: message,
//                                                                        //                                                                                         buttonTitle: "OK",
//                                                                        //                                                                                         buttonStyle: .cancel)
//                                                                        appDelegate.showToast(message: message)
//                        }
//                    
//                    if  HomeVM.shared.receiptModel.extra_merchant_copy == "true" {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                            let commands: Data
//                            
//                            let emulation: StarIoExtEmulation = LoadStarPrinter.getEmulation()
//                            print(emulation)
//                            
//                            let width: Int = LoadStarPrinter.getSelectedPaperSize().rawValue
//                            
//                            let paperSize: PaperSizeIndex = LoadStarPrinter.getSelectedPaperSize()
//                            let language: LanguageIndex = LanguageIndex.english//LoadStarPrinter.getSelectedLanguage()
//                            let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(language,
//                                                                                                              paperSizeIndex: paperSize)
//                            commands = PrinterFunctions.createTextReceiptApiData(emulation,utf8: true)
//                            
//                            //self.blind = true
//                            
//                            //  if #available(iOS 13.0, *) {
//                            Communication.sendCommandsForPrintReDirection(commands,
//                                                                          timeout: 10000) { (communicationResultArray) in
//                                                                            // self.blind = false
//                                                                            
//                                                                            var message: String = ""
//                                                                            
//                                                                            for i in 0..<communicationResultArray.count {
//                                                                                if i == 0 {
//                                                                                    message += "[Destination]\n"
//                                                                                }
//                                                                                else {
//                                                                                    message += "[Backup]\n"
//                                                                                }
//                                                                                
//                                                                                message += "Port Name: " + communicationResultArray[i].0 + "\n"
//                                                                                
//                                                                                switch communicationResultArray[i].1.result {
//                                                                                case .success:
//                                                                                    message += "----> Success!\n\n";
//                                                                                case .errorOpenPort:
//                                                                                    message += "----> Fail to openPort\n\n";
//                                                                                case .errorBeginCheckedBlock:
//                                                                                    message += "----> Printer is offline (beginCheckedBlock)\n\n";
//                                                                                case .errorEndCheckedBlock:
//                                                                                    message += "----> Printer is offline (endCheckedBlock)\n\n";
//                                                                                case .errorReadPort:
//                                                                                    message += "----> Read port error (readPort)\n\n";
//                                                                                case .errorWritePort:
//                                                                                    message += "----> Write port error (writePort)\n\n";
//                                                                                default:
//                                                                                    message += "----> Unknown error\n\n";
//                                                                                }
//                                                                            }
//                                                                            
//                                                                            
//                                                                            
//                                                                            //                                                                    self.showSimpleAlert(title: "Communication Result",
//                                                                            //                                                                                         message: message,
//                                                                            //                                                                                         buttonTitle: "OK",
//                                                                            //                                                                                         buttonStyle: .cancel)
//                                                                            appDelegate.showToast(message: message)
//                            }
//                        }
//                    }
//        //            } else {
//        //                // Fallback on earlier versions
//        //                 appDelegate.showToast(message: "#available(iOS 13.0, *)")
//        //            }
//                      //  }
//                   // }
                    //appDelegate.showToast(message: "No Printer Found.")
        } else {
            appDelegate.showToast(message: "No Printer Found.")
        }
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
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
            MainSocketManager.shared.socket.off("selectRecieptOption")
            MainSocketManager.shared.socket.off("searchCustomer")
            
        }
    }
    
    private func showOrderHistoryScreeen() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "iPad_OrdersHistoryViewController") as! iPad_OrdersHistoryViewController
            controller.recentOrderID = self.orderId
            self.navigationController?.pushViewController(controller, animated: true)
        }else {
            self.performSegue(withIdentifier: "OrdersHistory", sender: nil)
        }
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            self.offSocketEvent()
        }
    }
    
    //Handle Notification
    @objc func keyboardShown(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            self.heightKeyboard = keyboardFrame.size.height
            self.view.addSubview(view_KeyboardAddNotes)
        }
    }
    
    //MARK: IBAction
    @IBAction func lockButtonAction(_ sender: Any) {
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            
            MainSocketManager.shared.connect()
            let socketConnectionStatus = MainSocketManager.shared.socket.status
            
            switch socketConnectionStatus {
            case SocketIOStatus.connected:
                print("socket connected cat and pro")
                MainSocketManager.shared.onreset()
            case SocketIOStatus.connecting:
                print("socket connecting cat and pro")
            case SocketIOStatus.disconnected:
                print("socket disconnected")
            case SocketIOStatus.notConnected:
                print("socket not connected")
            }
            MainSocketManager.shared.socket.off("selectRecieptOption")
            MainSocketManager.shared.socket.off("searchCustomer")
        }
        let storyboard = UIStoryboard(name: "iPad", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "iPad_AccessPINViewController") as! iPad_AccessPINViewController
        if #available(iOS 13.0, *) {
            controller.modalPresentationStyle = .fullScreen
        }
        self.navigationController?.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        alertForLogOut()
    }
    
    func popViewControllerss(popViews: Int, animated: Bool = true) {
        if self.navigationController!.viewControllers.count > popViews
        {
            let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - popViews - 1]
            self.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    @IBAction func btn_HomeAction(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        if DataManager.isBalanceDueData {
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                self.navigationController?.popViewController(animated: true)
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                    MainSocketManager.shared.oncloseRecieptModal()
                    self.offSocketEvent()
                }
            } else {
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                    MainSocketManager.shared.oncloseRecieptModal()
                    self.offSocketEvent()
                }
                //self.popViewControllerss(popViews: 2)
                if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
                    self.popViewControllerss(popViews: 1)
                } else {
                    self.popViewControllerss(popViews: 2)
                }
            }
            
        } else {
            self.isHomeTapped = true
            if DataManager.pinloginEveryTransaction && NetworkConnectivity.isConnectedToInternet() {
                self.showLockScreen()
                return
            }
            self.showHomeScreeen()
            // for socket sudama
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                MainSocketManager.shared.oncloseRecieptModal()
                MainSocketManager.shared.onreset()
                //self.showHomeScreeen()
                
            }
        }
    }
    
    @IBAction func btn_OrderHistory(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        self.isHomeTapped = false
        if DataManager.pinloginEveryTransaction {
            self.showLockScreen()
            return
        }
        appDelegate.authOrderIdForOrderHistory = ""
        self.showOrderHistoryScreeen()
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.oncloseRecieptModal()
            MainSocketManager.shared.onreset()
            //self.showOrderHistoryScreeen()
            
        }
    }
    
    @IBAction func btn_SendAction(_ sender: UIButton)   //Tag 1 = Email, Tag 2 = Phone
    {
        self.view.endEditing(true)
        if sender.tag == 1 {
            //Validate Email
            if emailTextField.text == "" {
                emailTextField.setCustomError(text: "Please enter Email.", bottomSpace: 2)
                return
            }
            
            if !emailTextField.isValidEmail() {
                emailTextField.setCustomError(text: "Please enter valid Email.", bottomSpace: 2)
                return
            }
            
            //Parameters
            var parameters = JSONDictionary()
            
            if self.OrderedData["isOrderRefunded"] == nil {
                parameters = [
                    "order_id":self.orderId,
                    "email": emailTextField.text!,
                ]
            } else {
                parameters = [
                    "order_id":self.orderId,
                    "email": emailTextField.text!,
                    "total" : OrderedData["total"] as? String ?? "",
                    "isOrderRefunded" : OrderedData["isOrderRefunded"] as? String ?? "",
                    "txn_id":self.transactionId
                ]
            }
            
            
            //            let parameters: JSONDictionary = [
            //                "order_id":self.orderId,
            //                "email": emailTextField.text!,
            //                "total" : OrderedData["total"] as? String ?? "",
            //                "isOrderRefunded" : OrderedData["isOrderRefunded"] as? String ?? "",
            //            ]
            
            //Call API to Send Email
            self.callAPItoSendEmail(parameters: parameters,isPOSSendButton: true)
        }else {
            //Validate Email
            if phoneTextField.text == "" {
                phoneTextField.setCustomError(text: "Please enter Phone Number.", bottomSpace: 2)
                return
            }
            
            let stringURL = String(format: "%@%@",BaseURL, kSendText)
            
            //Parameters
            let parameters: JSONDictionary = [
                "order_id":self.orderId,
                "phone": phoneNumberFormateRemoveText(number: phoneTextField.text!),
                "txn_id":self.transactionId
            ]
            
            //Call API
            callAPItoSendMessage(url: stringURL, parameters: parameters)
            
        }
    }
    
    @IBAction func btn_PrintReceiptAction(_ sender: UIButton) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
            }
        }
        if !DataManager.isBluetoothPrinter && !DataManager.isGooglePrinter {
            //            self.showAlert(message: "Please first enable the printer from settings")
            
            if DataManager.showFullRecieptOptionForPrint == "true" {
                let Url = "\(BaseURL)/packing_slip/?&ai_skin=full_page&full=y&order_id=\(orderId)"
                let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                if let url:NSURL = NSURL(string: str!) {
                    UIApplication.shared.open(url as URL)
                }
            } else {
                appDelegate.showToast(message: "Please first enable the printer from settings")
            }
            return
        }
        if DataManager.isGooglePrinter && DataManager.starCloudMACaAddress == "" {
            callAPItoGetstarCloudPrinterList()
            return
        }
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            if DataManager.isBalanceDueData {
                self.navigationController?.popViewController(animated: true)
                MainSocketManager.shared.oncloseRecieptModal()
                self.offSocketEvent()
            }else{
                MainSocketManager.shared.oncloseRecieptModal()
                MainSocketManager.shared.onreset()
                self.showHomeScreeen()
            }
        }else{
            if DataManager.isBalanceDueData {
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showHomeScreeen()
            }
        }
        
        if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter {
            
            //let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            if DataManager.isBalanceDueData {
                self.callAPItoGetTransactionPrintReceiptContent(transactionID: transactionId)
            } else {
                self.callAPItoGetReceiptContent()
            }
        }
        
//        if DataManager.isGooglePrinter {
//            let Url = self.strGooglePrint
//            //let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//            //UIApplication
//            if let url:NSURL = NSURL(string: Url) {
//                UIApplication.shared.open(url as URL)
//            }
//        }
        // for socket sudama
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.oncloseRecieptModal()
            if !DataManager.isBalanceDueData {
                 MainSocketManager.shared.onreset()
            }
            //self.showHomeScreeen()
            
        }
        
        //self.callAPItoGetReceiptContent()
    }
    
    @IBAction func btn_AddNoteAction(_ sender: Any)
    {
        IQKeyboardManager.shared.enableAutoToolbar = false
        txt_AddNote.becomeFirstResponder()
        customView.isHidden = false
        customView.isUserInteractionEnabled = true
        setView(view: view_KeyboardAddNotes, hidden: false)
        view_KeyBoardUpBottomConstraint.constant = heightKeyboard ?? 0
        self.view.addSubview(view_KeyboardAddNotes)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btn_TfAddNoteAction(_ sender: Any) {
        //..
    }
    
    @IBAction func btn_AddNoteCancelAction(_ sender: Any) {
        IQKeyboardManager.shared.enableAutoToolbar = true
        txt_AddNote.resignFirstResponder()
        setView(view: view_KeyboardAddNotes, hidden: true)
        customView.isHidden = true
        txt_AddNote.text = ""
        btn_AddNoteDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
    }
    
    @IBAction func btn_AddNoteDoneAction(_ sender: Any)
    {        IQKeyboardManager.shared.enableAutoToolbar = true
        handleAddNoteAction()
    }
    
    
    //MARK: Get Star print
    func loadStarPrint() {
        
        self.startPrntArray.removeAllObjects()
        
        // self.selectedIndexPath = nil
        
        
        var searchPrinterResult: [PortInfo]? = nil
        
        do {
            // Bluetooth
            searchPrinterResult = try SMPort.searchPrinter(target: "BT:")  as? [PortInfo]
            //DataManager.isStarPrinterConnected = true
            if  searchPrinterResult?.count == 0 {
                DataManager.isStarPrinterConnected = false
            } else {
                if DataManager.isBluetoothPrinter {
                    DataManager.isStarPrinterConnected = true
                } else {
                    DataManager.isStarPrinterConnected = false
                }
            }
            
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
        startArr.removeAll()
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
    
}
extension OrderViewController: UIScrollViewDelegate {
    func increaseHeight()  {

        if UI_USER_INTERFACE_IDIOM() == .phone {
            ScrollViewMain.contentSize = CGSize(width: self.view.frame.width, height: ScrollViewMain.frame.size.height+50)
        }
    }
}
//MARK: UITextFieldDelegate
extension OrderViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }
        
        if string == "\t" {
            return false
        }
        
        if textField == emailTextField {
            if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
                return false
            }
            return true
        }
        
        if textField == phoneTextField {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedPhoneNumber(number: newString)
            return false
        }
        
        if textField == phoneTextField {
            if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
                return false
            }
            
            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
            
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            return string == filtered
        }
        
        var startingLength = Int()
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        var newLength = Int()
        
        startingLength = txt_AddNote.text?.count ?? 0
        newLength = startingLength + lengthToAdd - lengthToReplace
        if (newLength > 0)
        {
            btn_AddNoteDone.setImage(UIImage(named: "tick-active"), for: .normal)
            btn_AddNoteDone.isUserInteractionEnabled = true
        }
        else
        {
            btn_AddNoteDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
            btn_AddNoteDone.isUserInteractionEnabled = false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setView(view: view_KeyboardAddNotes, hidden: true)
        customView.isHidden = true
        txt_AddNote.text = ""
        btn_AddNoteDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.resetCustomError(isAddAgain: false)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}

//MARK: UITextViewDelegate
extension OrderViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let length = textView.text.count + (text.count - range.length)
        if text == "\t" {
            return false
        }
        
        if range.location == 0 && text == " " {
            return false
        }
        
        if textView == txt_AddNote && text == "\n" {
            self.handleAddNoteAction()
            textView.resignFirstResponder()
            return false
        }
        
        if (length > 0)
        {
            btn_AddNoteDone.setImage(UIImage(named: "tick-active"), for: .normal)
            btn_AddNoteDone.isUserInteractionEnabled = true
        }
        else
        {
            btn_AddNoteDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
            btn_AddNoteDone.isUserInteractionEnabled = false
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        txt_AddNote.resignFirstResponder()
        setView(view: view_KeyboardAddNotes, hidden: true)
        customView.isHidden = true
        txt_AddNote.text = ""
        btn_AddNoteDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
        self.heightKeyboard = 0
    }
    
}

//MARK: API Services
extension OrderViewController {
    func backandToastMsg(toastMessage: String){
        let storyboard = UIStoryboard(name: "iPad", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as! SWRevealViewController
        appDelegate.window?.rootViewController = controller
        appDelegate.window?.makeKeyAndVisible()
        appDelegate.showToast(message: toastMessage)
    }
    
    func callAPItoSendEmail(parameters: JSONDictionary,isPOSSendButton:Bool=false) {
        HomeVM.shared.sendEmail(parameters: parameters) { (success, message, error) in
            if success == 1 {
                //Hiec@r
                // self.showAlert(title: kAlert, message: "Mail sent successfully.", otherButtons: nil, cancelTitle: kOkay, cancelAction: { (_) in
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    appDelegate.showToast(message:"Mail sent successfully.")
                } else {
                    //self.setRootViewControllerForIphone()
                    appDelegate.showToast(message:"Mail sent successfully.")
                }
                //                if DataManager.isBalanceDueData {
                //                    self.navigationController?.popViewController(animated: true)
                //                }else{
                //                    self.showHomeScreeen()
                //                }
                
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                    if DataManager.isBalanceDueData {
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.navigationController?.popViewController(animated: true)
                        }else if isPOSSendButton {
                            self.navigationController?.popViewController(animated: true)
                        }
                     //   self.navigationController?.popViewController(animated: true)
                        MainSocketManager.shared.oncloseRecieptModal()
                        self.offSocketEvent()
                    }else{
                        MainSocketManager.shared.oncloseRecieptModal()
                        MainSocketManager.shared.onreset()
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.showHomeScreeen()
                        }else if isPOSSendButton {
                            self.showHomeScreeen()
                        }
                    }
                }else{
                    if DataManager.isBalanceDueData {
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.showHomeScreeen()
                    }
                }
                //                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                //                    MainSocketManager.shared.onreset()
                //                }
                //})
            }else {
                //                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                //                    MainSocketManager.shared.onreset()
                //                }
                if message != nil {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        MainSocketManager.shared.onerrorRecieptModal(errorMessage: message!)
                    }
                    //                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        MainSocketManager.shared.onerrorRecieptModal(errorMessage: error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg)
                    }
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    func callAPItoSendNote(parameters: JSONDictionary) {
        
        HomeVM.shared.sendNote(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.txt_AddNote.resignFirstResponder()
                self.setView(view: self.view_KeyboardAddNotes, hidden: true)
                self.customView.isHidden = true
                self.txt_AddNote.text = ""
                self.btn_AddNoteDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
                //                self.showAlert(message: "Notes save successfully.")
                appDelegate.showToast(message: "Notes save successfully.")
                
                //                // for socket sudama
                //                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                //                    MainSocketManager.shared.oncloseRecieptModal{
                //                        MainSocketManager.shared.onreset()
                //                        self.showHomeScreeen()
                //                        //
                //                    }
                //                }
                
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
    
    func callAPItoGetTransactionPrintReceiptContent(transactionID: String)
    {
        //        if orderID == "" {
        //            Indicator.isEnabledIndicator = true
        //            Indicator.sharedInstance.hideIndicator()
        //            return
        //        }
        
        //Call API
        HomeVM.shared.getTransactionPrintReceiptContent(transactionID: transactionID, responseCallBack: { (success, message, error) in
            if success == 1 {
                Indicator.sharedInstance.hideIndicator()
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
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.getReceiptContent(orderID: self.orderId, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.receiptModel = HomeVM.shared.receiptModel
                self.handlePrinterAction()
                Indicator.sharedInstance.hideIndicator()
            }else {
                Indicator.sharedInstance.hideIndicator()
                if message != nil {
                    //                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func callAPItoSendMessage(url: String, parameters: JSONDictionary,isPOSSendButton:Bool=false)
    {
        OrderVM.shared.sendEmailOrText(url: url, parameters: parameters, responseCallBack: { (success, message, error) in
            if success == 1 {
                //Hiec@r
                //  self.showAlert(title: kAlert, message: "Receipt sent successfully.", otherButtons: nil, cancelTitle: kOkay, cancelAction: { (_) in
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    appDelegate.showToast(message: "Receipt sent successfully.")
                } else {
                    self.setRootViewControllerForIphone()
                    appDelegate.showToast(message: "Receipt sent successfully.")
                }
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                    if DataManager.isBalanceDueData {
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.navigationController?.popViewController(animated: true)
                        }else if isPOSSendButton {
                            self.navigationController?.popViewController(animated: true)
                        }
                        MainSocketManager.shared.oncloseRecieptModal()
                        self.offSocketEvent()
                    }else{
                        MainSocketManager.shared.oncloseRecieptModal()
                        MainSocketManager.shared.onreset()
                        if self.orderDeliveryStatusArry.count == 0 {
                            self.showHomeScreeen()
                        }else if isPOSSendButton {
                            self.showHomeScreeen()
                        }
                    }
                }else{
                    if DataManager.isBalanceDueData {
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.showHomeScreeen()
                    }
                }
                //                })
            }else {
                if message != nil {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        MainSocketManager.shared.onerrorRecieptModal(errorMessage: message!)
                    }
                    //                    self.showAlert(message: message!)
                    
                    appDelegate.showToast(message: message!)
                }else {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        MainSocketManager.shared.onerrorRecieptModal(errorMessage: error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg)
                    }
                    
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func getCustomersDetail(id: String)
    {
        if id == "0" {
            return
        }
        //Call API
        HomeVM.shared.getCustomerDetail(id: id, responseCallBack: { (success, message, error) in
            if success == 1 {
                //Update Data
                self.emailTextField.text = HomeVM.shared.customerDetail.str_email
                self.phoneTextField.text = self.formattedPhoneNumber(number: HomeVM.shared.customerDetail.str_phone)
                
                let name = HomeVM.shared.customerDetail.str_first_name + " " + HomeVM.shared.customerDetail.str_last_name
                
                self.lbl_CustomerName.text = name
                self.lbl_CustomerEmail.text = HomeVM.shared.customerDetail.str_email
                // for socket sudama
                DispatchQueue.main.asyncAfter (deadline: .now() + 1) {
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        if self.signVCFlag {
                            // MainSocketManager.shared.onOpenSignature(signArry: self.arrCardData)
                        } else {
                            var receiptModelForSocket = ReceiptModelForSocket()
                            receiptModelForSocket.change_due = self.labelChangeDue.text?.replacingOccurrences(of: "$", with: "") ?? ""
                            receiptModelForSocket.email = self.emailTextField.text ?? ""
                            receiptModelForSocket.order_id = Double(self.orderId) ?? 0.0
                            receiptModelForSocket.phone = self.phoneTextField.text ?? ""
                            receiptModelForSocket.session_id = DataManager.sessionID
                            receiptModelForSocket.paymentMethod = ""
                            MainSocketManager.shared.onOpenRecieptModal(receiptModelForSocket: receiptModelForSocket)
                        }
                    }
                }
                //
                if HomeVM.shared.customerDetail.str_email == "" && (name == "" || name == " " ) {
                    self.customerInformationView.isHidden = true
                }else {
                    self.customerInformationView.isHidden = false
                }
            }
            else {
                if message != nil {
                    //                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func callAPItoGetstarCloudPrinterList() {
            HomeVM.shared.starCloudPrinterModel.arrprinter_list_value.removeAll()
            HomeVM.shared.getPrinterList { (success, message, error) in
                if success == 1 {
                    //self.sourcesList =  HomeVM.shared.sourcesList
                    print( HomeVM.shared.starCloudPrinterModel)
      
                    if DataManager.isGooglePrinter {
                        DispatchQueue.main.async {
                            //self.tbl_Settings.reloadData()
                            if HomeVM.shared.starCloudPrinterModel.arrprinter_list_value.count > 1 {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "StarCloudPRNTListPopupVC") as! StarCloudPRNTListPopupVC
                                vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                                vc.modalPresentationStyle = .overCurrentContext
                                vc.delegate = self
                                self.present(vc, animated: false, completion: nil)
                            } else {
                                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
                                    if DataManager.isBalanceDueData {
                                        if self.orderDeliveryStatusArry.count == 0 {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                        MainSocketManager.shared.oncloseRecieptModal()
                                        self.offSocketEvent()
                                    } else {
                                        MainSocketManager.shared.oncloseRecieptModal()
                                        MainSocketManager.shared.onreset()
                                        if self.orderDeliveryStatusArry.count == 0 {
                                            self.showHomeScreeen()
                                        }
                                    }
                                } else {
                                    if DataManager.isBalanceDueData {
                                        self.navigationController?.popViewController(animated: true)
                                    }else{
                                        self.showHomeScreeen()
                                    }
                                }
                                if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter {
                                    
                                    //let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                                    if DataManager.isBalanceDueData {
                                        self.callAPItoGetTransactionPrintReceiptContent(transactionID: self.transactionId)
                                    } else {
                                        self.callAPItoGetReceiptContent()
                                    }
                                }
                                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                                    MainSocketManager.shared.oncloseRecieptModal()
                                    if !DataManager.isBalanceDueData {
                                         MainSocketManager.shared.onreset()
                                    }
                                    //self.showHomeScreeen()
                                    
                                }
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
    func callAPItoPostUpdateDeliveryStatus(status_id:String) {
        let param : JSONDictionary = ["order_id":self.orderId,
                                      "status_id":status_id]
        HomeVM.shared.updateDeliveryStatus(parameters: param, responseCallBack: { (success, message, error) in
            if success == 1 {
                //Update Data
                DispatchQueue.main.async {
                    self.orderDeliveryStatusArry = HomeVM.shared.orderDeliveryStatusArry
                    self.selectDeliveryTypeStatusID = status_id
                    self.deliveryOrderStatusCollectionView.reloadData()
                }
            } else {
                if message != nil {
                    appDelegate.showToast(message: message!)
                } else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
}

//MARK: OfflineDataManagerDelegate
extension OrderViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            self.updateUI()
        }
        self.lockLineView.isHidden = !isOn
        self.lockButton.isHidden = !isOn
        self.logoutButton.isHidden = !isOn
        self.logoutLineView.isHidden = !isOn
        
        if DataManager.isBalanceDueData == true {
            btn_Home.isHidden = true
            lockButton.isHidden = true
            logoutButton.isHidden = true
            orderHistoryButtonIpad.isHidden = true
            addNoteView.isHidden = true
            btnHomeBottom.setTitle("Back To Payment", for: .normal)
        }
    }
}

extension OrderViewController: socketForVC {
    func callForSocketVC(str: String) {
        var receiptModelForSocket = ReceiptModelForSocket()
        receiptModelForSocket.change_due = self.labelChangeDue.text?.replacingOccurrences(of: "$", with: "") ?? ""
        receiptModelForSocket.email = self.emailTextField.text ?? ""
        receiptModelForSocket.order_id = Double(self.orderId) ?? 0.0
        receiptModelForSocket.phone = self.phoneTextField.text ?? ""
        receiptModelForSocket.session_id = DataManager.sessionID
        receiptModelForSocket.paymentMethod = ""
        MainSocketManager.shared.onOpenRecieptModal(receiptModelForSocket: receiptModelForSocket)
    }
    
}

//MARK: SWRevealViewControllerDelegate
extension OrderViewController: SWRevealViewControllerDelegate {
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

extension OrderViewController: PaymentTypeDelegate {
    func didPerformSegueWith(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
}

//MARK: PrinterManagerDelegate
extension OrderViewController: PrinterManagerDelegate {
    
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
                if paymentType == "cash" || paymentType == "check" {
                    BluetoothPrinter.sharedInstance.openCashDraer()
                }
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


//MARK: OfflineDataManagerDelegate
extension OrderViewController: HieCORPinDelegate {
    func didGetSuccess() {
        if !isHomeTapped {
            self.showOrderHistoryScreeen()
            return
        }
        self.showHomeScreeen()
    }
}
//MARK: UITableViewDataSource, UITableViewDelegate
extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SplitTableViewCell") as! SplitTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let arrayPayment = array[indexPath.row]
        if DataManager.isBalanceDueData == true {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                let name = paymentType.replacingOccurrences(of: "_", with: " ")
                if name == "pax pay" {
                    cell.labelPaymentValue.text = " " + "EMV"
                    cell.labelPaymentValue.textAlignment = .left
                } else {
                    cell.labelPaymentValue.text = " " + name.capitalized
                    cell.labelPaymentValue.textAlignment = .left
                }
                
            }else{
                cell.labelPaymentValue.text = arrayPayment
            }
        }else{
            cell.labelPaymentValue.text = arrayPayment
        }
        
        
        return cell
    }
}
//MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension OrderViewController: UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderDeliveryStatusArry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomOrderStatusCell", for: indexPath)
        let lbl_Name = cell.contentView.viewWithTag(1) as? UILabel
        let view_check = cell.contentView.viewWithTag(121)
        let view_bg = cell.contentView.viewWithTag(118)
        view_bg?.cornerRadius = 5.0
        lbl_Name?.text = orderDeliveryStatusArry[indexPath.row].name
        lbl_Name?.textColor = .black
        // remove dotted border
        for layer in view_bg!.layer.sublayers! {
            if layer.isKind(of: CAShapeLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
        // Set Dotted Border
        if orderDeliveryStatusArry[indexPath.row].isSelected == true && DataManager.isBalanceDueData == false {
            view_check?.isHidden = false
            let color1 = UIColor(hexCode: orderDeliveryStatusArry[indexPath.row].color)
            view_bg?.addDashBorder(color: color1?.darker(by: 20) ?? .green)
        }else{
            view_check?.isHidden = true
        }
        // Set Background color
        if orderDeliveryStatusArry[indexPath.row].color == "" {
            view_bg?.backgroundColor = #colorLiteral(red: 0, green: 0.5450556278, blue: 0.8285357952, alpha: 1)
        }else{
            let color1 = UIColor(hexCode: orderDeliveryStatusArry[indexPath.row].color)
            view_bg?.backgroundColor = color1
        }
        //Add Shadow
        cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if orderDeliveryStatusArry[indexPath.row].isDisabled {
            return
        }
        let status_id = orderDeliveryStatusArry[indexPath.row].status_id
        self.callAPItoPostUpdateDeliveryStatus(status_id: status_id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let arrcount = orderDeliveryStatusArry.count
            var count = 3
            if arrcount < 4 {
                count = 1
            }else if  arrcount >= 4 && arrcount <= 6 {
                count = 2
            }else if  arrcount >= 7 && arrcount <= 9 {
                count = 3
            }else if  arrcount >= 10 && arrcount <= 12 {
                count = 4
            }else {
                count = 5
            }
            self.deliveryOrderStatusViewHeightConst.constant = CGFloat((52 * count) + 70 )
            return CGSize(width: (width/3)-10, height: 40)
        } else {
            let arrcount = orderDeliveryStatusArry.count
            var count = 3
            if arrcount.isMultiple(of: 2) {
                let arrcount1 = arrcount / 2
                count = arrcount1
                print("Number is even")
            } else {
                let arrcount1 = arrcount / 2
                count = arrcount1 + 1
                print("Number is odd")
            }
            self.deliveryOrderStatusViewHeightConst.constant = CGFloat((45 * count) + 70 )
            return CGSize(width: (width/2) - 10, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
extension OrderViewController:  StarIoExtManagerDelegate {
    func openCashDrawer(){
       // self.starIoExtManager.connect()
        let commands: Data
        
//        switch LoadStarPrinter.getSelectedIndex() {
//        case 0, 1 :
            commands = CashDrawerFunctions.createData(LoadStarPrinter.getEmulation(), channel: SCBPeripheralChannel.no1)
//      case 2, 3 :
//        default   :
//            commands = CashDrawerFunctions.createData(LoadStarPrinter.getEmulation(), channel: SCBPeripheralChannel.no2)
//        }
        
//        switch LoadStarPrinter.getSelectedIndex()    {
//        case 0, 2 :
//
        if self.starIoExtManager != nil {
            self.starIoExtManager.lock.lock()
            
            GlobalQueueManager.shared.serialQueue.async {
                _ = Communication.sendCommands(commands,
                                               port: self.starIoExtManager.port,
                                               completionHandler: { (communicationResult: CommunicationResult) in
                    DispatchQueue.main.async {
//                        self.showSimpleAlert(title: "Communication Result",
//                                             message: Communication.getCommunicationResultMessage(communicationResult),
//                                             buttonTitle: "OK",
//                                             buttonStyle: .cancel)
                        
                        self.starIoExtManager.lock.unlock()
                        self.starIoExtManager.disconnect()
                        
                    }
                })
            }
        }
            
    }
    
    func didPrinterImpossible(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Printer Impossible."
//
//        self.commentLabel.textColor = UIColor.red
//
//        self.beginAnimationCommantLabel()
    }
    
    func didCashDrawerOpen(_ manager: StarIoExtManager!) {

//        self.commentLabel.text = "Cash Drawer Open."
        
        NSLog("%@", MakePrettyFunction())
//      self.commentLabel.textColor = UIColor.red
//        self.commentLabel.textColor = UIColor.magenta
//
//        self.beginAnimationCommantLabel()
    }
    
    func didCashDrawerClose(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Cash Drawer Close."
//
//        self.commentLabel.textColor = UIColor.blue
//
//        self.beginAnimationCommantLabel()
    }
    
    func didAccessoryConnectSuccess(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Accessory Connect Success."
//
//        self.commentLabel.textColor = UIColor.blue
//
//        self.beginAnimationCommantLabel()
    }
    
    func didAccessoryConnectFailure(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Accessory Connect Failure."
//
//        self.commentLabel.textColor = UIColor.red
//
//        self.beginAnimationCommantLabel()
    }
    
    func didAccessoryDisconnect(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Accessory Disconnect."
//
//        self.commentLabel.textColor = UIColor.red
//
//        self.beginAnimationCommantLabel()
    }
    
    func didStatusUpdate(_ manager: StarIoExtManager!, status: String!) {
        NSLog("%@", MakePrettyFunction())
        
//      self.commentLabel.text = status
//
//      self.commentLabel.textColor = UIColor.green
//
//      self.beginAnimationCommantLabel()
    }

}
extension OrderViewController: StarCloudPRNTVCDelegate {
    func didTapOnStarCloudPrintButton() {
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            if DataManager.isBalanceDueData {
                self.navigationController?.popViewController(animated: true)
                MainSocketManager.shared.oncloseRecieptModal()
                self.offSocketEvent()
            }else{
                MainSocketManager.shared.oncloseRecieptModal()
                MainSocketManager.shared.onreset()
                self.showHomeScreeen()
            }
        } else{
            if DataManager.isBalanceDueData {
                self.navigationController?.popViewController(animated: true)
            }else{
                self.showHomeScreeen()
            }
        }
        if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter {
            
            //let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            if DataManager.isBalanceDueData {
                self.callAPItoGetTransactionPrintReceiptContent(transactionID: self.transactionId)
            } else {
                self.callAPItoGetReceiptContent()
            }
        }
        
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.oncloseRecieptModal()
            if !DataManager.isBalanceDueData {
                 MainSocketManager.shared.onreset()
            }
            //self.showHomeScreeen()
            
        }
    }
}
////MARK: EPSignatureDelegate
//extension OrderViewController: EPSignatureDelegate {
//    func epSignature(_: MultipleSignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
//        <#code#>
//    }
//
//    func epSignature(_: SignatureViewController, didSign signatureImage: UIImage, boundingRect: CGRect) {
//        self.signatureImage = signatureImage
//        //prepareForPlaceOrder()
//    }
//}


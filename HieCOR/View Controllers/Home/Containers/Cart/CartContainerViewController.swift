//
//  CartContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 12/02/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import CoreData
import AVFoundation
import MediaPlayer
import SocketIO

class CartContainerViewController: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Variables
    var selectedProductIds = String()
    var selectedtag = Int()
    var cartProductsArray = Array<Any>()
    var SubTotalPrice = Double()
    var TotalPrice = Double()
    var CustomerObj = CustomerListModel()
    var array_TaxList = [TaxListModel]()
    var taxModelObj = TaxListModel()
    var taxTitle = "Default"
    var taxAmountValue = "0"
    var taxType = "Fixed"
    var array_RegoinsList = [RegionsListModel]()
    var regionsModelObj = RegionsListModel()
    var selectedCutomerIndex = Int()
    var selectedPickerIndex = Int()
    var stockInt = Double()
    var heightKeyboard : CGFloat?
    var isShippingHandling = Bool()
    var isAddDiscount = Bool()
    var isAddCoupon = Bool()
    var isAddNote = Bool()
    var str_depositAmount = String()
    var isAllDataRemoved = false
    var str_ShippingANdHandling = String()
    var str_BalanceDue = Double()
    var str_AddDiscount = String()
    var str_AddDiscountPercent = String()
    var str_AddCouponName = String()
    var str_AddNote = String()
    var str_AddCustomer = String()
    var str_SelectedCustomerID = String()
    var str_TaxPercentage = String()
    var str_TaxAmount = String()
    var discountTextField = UITextField()
    var shippingTextField = UITextField()
    var QuantityTextField = UITextField()
    var newPrice = "0.00"
    var oldPrice = "0.00"
    static var isPickerSelected = false
    var isShippingPriceChanged = false
    var isDefaultTaxChanged = false
    var isDefaultTaxSelected = false
    var isCoupanApplyOnAllProducts = false
    var index = 0
    var isCreditCardNumberDetected = false
    var isOrderPrepare = false
    var isCustomerAddrUpdateFlag = false
    var delegate: CartContainerViewControllerDelegate?
    var catAndProductDelegate: CatAndProductsViewControllerDelegate?
    var cartViewDelegate: CartViewControllerDelegate?
    var shippingDelegate: ShippingDelegate?
    var customerDelegate: CustomerDelegates?
    var editProductDelegate: EditProductsContainerViewDelegate?
    var showDetailsDelegateOne: showDetailsDelegate?
    static var updatedProductIndex: Int? = nil
    var orderType: OrderType = .newOrder
    var orderInfoObj = OrderInfoModel()
    var paymentType = String()
    var sectionArray = [String]()
    var stringQty = Double()
    var StringShowQty = Double()
    var duebalance = Double()
    var isQtyChanged = false
    var stringChangedQty = String()
    var selectedIndex = Int()
    //var productAttributeDetails = [ProductAttributeDetail]()
    var delegateEditProduct: EditProductDelegate?
    var str_showImagesFunctionality = String()
    var str_showProductCodeFunctionality = String()
    var str_showShipOrderInPos = String()
    var homeRefresh : RefreshHomeCartDelegate?
    var strShiping = ""
    var selectPaymentMethod = false
    var selectaMethod = ""
    var str_addDeviceName = String()
    var array_PaxDeviceList = [PAXDeviceList]()
    var selectPaymentMethodValue = ""
    var str_internalGiftCardNumber = String()
    var str_externalGiftCardNumber = String()
    var str_paxUrl = String()
    var strCouponNameCapture = ""
    var versionOb = Int()
    var selectRemaingAmount = [Bool]()
    var array_ItemList = ["Select Condition", "New/Unopened","New/Open Box", "Used", "Damaged"]
    var strStatusItem : NSMutableArray = []
    var indexPathItem = NSIndexPath()
    var indexItem = Int()
    var indexCellItem = 0
    var showItems = [String]()
    var isCheckItem = false
    var arrRefundAmount = [Double]()
    var selectIndexAmount = Int()
    var RefundAmount = Double()
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
    var tipRefund = 0.0
    var isinternalGift = true
    var strSubscriptionValue = String()
    var tranCheckBoxSelected = false
    var selecVCObj = SelectCustomerViewController()
    var taxableAmtData = Double()
    var discountPointTaxable = Double()
    var discountPointWithoutCouponTaxable = Double()
    var tempWithoutCoupon = Double()
    var CouponTotal = Double()
    var withoutCouponTotal = Double()
    var isDeviceSelected = false
    var arrPaxDeviceData = NSMutableArray()
    var arrTempPaxDeviceData = NSMutableArray()
    var indexPaxItem = Int()
    var taxDef = Double()
    var deviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
    // by sudama offline
    var taxData = Array<Any>()
    var dictTax = [String: Any]()
    var radioCount = 0
    var arrTempAttId = [String]()
    var arrTempVarId = [String]()
    var str_ShippingANdHandlingForRefund = String()
    //MARK: Private Variables
    private var ACCEPTABLE_CHARACTERS = "0123456789"
    private var isCheckShippingBilling = Bool()
    private var str_qtyTextfieldText = String()
    private var taxToolbar: UIToolbar!
    private var str_CouponDiscount = String()
    private var subTotalFinal = Double()
    private var taxableCouponTotal = Double()
    private var isAddNewButtonSelected = false
    private var controller: UIViewController?
    private var isPercentageDiscountApplied = false
    let reuseIdentifier = "AddPaymentCollectionCell"
    
    var dictSocket = [String: Any]()
    var productsArraySocket = Array<Any>()
    var MainproductsArraySocket = [Int: Any]()
    var isSelectEMVPayment = false
    var ignoreSubcriptionCheck = false
    var isOpenToOrderHistory = false

    //MARK: IBOutlets
    
    @IBOutlet weak var AddSubscription: UIView!
    @IBOutlet weak var storeCreditView: UIStackView!
    @IBOutlet weak var lblStoreCreditAmt: UILabel!
    @IBOutlet weak var labelAmtBalanceDue: UILabel!
    @IBOutlet weak var viewBalanceDue: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet var viewKeyBoardUpBottomConstraint: NSLayoutConstraint!
    @IBOutlet var lbl_CustomerName: UILabel!
    @IBOutlet weak var addCustomerIcon: UIImageView!
    @IBOutlet var lbl_TaxStateName: UILabel?
    @IBOutlet var icon_AddCustomer: UIImageView!
    @IBOutlet var lbl_ShippingAndHandling: UILabel!
    @IBOutlet var lbl_Tax: UILabel!
    @IBOutlet var lbl_SubTotal: UILabel?
    @IBOutlet var lbl_AddDiscount: UILabel!
    @IBOutlet var btn_Pay: UIButton?
    @IBOutlet var icon_btnShipping: UIButton?
    @IBOutlet var crossButton: UIButton!
    @IBOutlet var icon_btnAddNote: UIButton!
    @IBOutlet var icon_btnAddCoupon: UIButton!
    @IBOutlet var btn_ViewKeyboardDone: UIButton?
    @IBOutlet var btn_TfTax: UITextField!
    @IBOutlet var tf_AddDiscount: UITextField?
    @IBOutlet var viewKeyboardAddDiscount: UIView?
    @IBOutlet var tbl_Cart: UITableView!
    @IBOutlet var lbl_ViewKeyboardTitle: UILabel!
    @IBOutlet var view_Tax: UIView?
    @IBOutlet var tf_Tax: UITextField!
    @IBOutlet var txt_Note: UITextView?
    @IBOutlet weak var lbl_AppliedCouponAmount: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var lbl_AppliedCouponName: UILabel!
    @IBOutlet weak var view_AddCustomer: UIView!
    @IBOutlet weak var emptyCartImageView: UIImageView!
    @IBOutlet weak var addDiscountView: UIView!
    @IBOutlet weak var subtotalView: UIStackView!
    @IBOutlet weak var applyCouponView: UIStackView!
    @IBOutlet weak var discountView: UIStackView!
    @IBOutlet weak var shippingView: UIStackView!
    @IBOutlet weak var taxView: UIStackView!
    @IBOutlet weak var cartPaymentSectionView: UIView!
    @IBOutlet weak var shippingRefundButton: UIButton!
    @IBOutlet weak var totalNameLabel: UILabel!
    @IBOutlet weak var cartSubtotalBackView: UIView!
    @IBOutlet weak var cartTotalBackView: UIView!
    @IBOutlet weak var productSearchBackView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet weak var collectionPayExchange: UICollectionView!
    @IBOutlet weak var exchangePaymentView: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var exchangePaymentMainView: UIView!
    @IBOutlet weak var lblRefundTotalRemaining: UILabel!
    @IBOutlet weak var txfInternalGiftCardNumber: UITextField!
    @IBOutlet weak var viewInternalGift: UIView!
    @IBOutlet weak var viewTip: UIStackView!
    @IBOutlet weak var lblTipAmount: UILabel!
    @IBOutlet weak var btnTipSelect: UIButton!
    @IBOutlet weak var lblShippngHead: UILabel!
    
    @IBOutlet weak var internalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedOptionHieght: NSLayoutConstraint!
    @IBOutlet weak var lblSelectedOption: UILabel!
    @IBOutlet weak var viewForSelectedOption: UIView!
    @IBOutlet weak var remainingViewHeight: NSLayoutConstraint!
    
    //MARK: ViewController Variables
    private lazy var addCustomerContainer: iPadSelectCustomerViewController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "iPadSelectCustomerViewController") as! iPadSelectCustomerViewController
        //self.customerDelegate = vc
        //vc.customerDelegate = self
        //vc.customerDelegateForAddNewCustomer = self
        return vc
    }()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        remainingViewHeight.constant = 0
        indexCellItem = 0
        DataManager.isSideMenuSwiperCard = false
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
            MainSocketManager.shared.connect()
            MainSocketManager.shared.onConnect {
                MainSocketManager.shared.userJoinOnConnect(deviceId: DataManager.roomID)
                self.selecVCObj.searchCustomerSocket()
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
                    if self.cartProductsArray.count > 0 {
                        //    appDelegate.showToast(message: "tretete")
                    }else{
                        //  appDelegate.showToast(message: "oooo")
                        MainSocketManager.shared.onreset()
                        
                    }
                }
                
            }
        }

        storeCreditView.isHidden = true

        array_ItemList = ["Select Condition", "New/Unopened","New/Open Box", "Used", "Damaged"]

        self.versionOb = Int(DataManager.appVersion)!

        shippingRefundButton.isSelected = DataManager.isshipOrderButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.RefreshHome(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        
        updateCartData()
        
        self.customizeUI()
        //Get Coupon List
        if DataManager.isCouponList {
            self.callAPIToGetCouponList()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateData()
            self.updateCouponAndCartTotal()
            if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                self.array_TaxList = [TaxListModel]()
                self.array_TaxList = HomeVM.shared.taxList
                var taxList = [TaxListModel]()
                if DataManager.posTaxListData?.count != 0 {
                    if HomeVM.shared.taxList.count == 0 {
                        
                        if let arrayTaxData = DataManager.posTaxListData!["tax_rows"] as? Array<Dictionary<String,AnyObject>>
                        {
                            if arrayTaxData.count > 0
                            {
                                for i in (0...arrayTaxData.count-1)
                                {
                                    let taxData = (arrayTaxData as AnyObject).object(at: i)
                                    let  taxModelObj = TaxListModel()
                                    taxModelObj.tax_title = (taxData as AnyObject).value(forKey: "title") as? String ?? ""
                                    taxModelObj.tax_type = (taxData as AnyObject).value(forKey: "type") as? String ?? ""
                                    taxModelObj.tax_amount = ((taxData as AnyObject).value(forKey: "amount") as? String ?? "").replacingOccurrences(of: ",", with: "")
                                    taxList.append(taxModelObj)
                                }
                            }
                        }
                        self.array_TaxList = taxList
                    }
                }
                
                if let userObject = UserDefaults.standard.value(forKey: "userdata") as? NSData {
                    let userdata = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data)
                    if(((userdata as AnyObject).value(forKey: "user_tax_lock")) == nil || ((userdata as AnyObject).value(forKey: "user_tax_lock") as? String ?? "") == "")
                    {
                        if(self.taxModelObj.tax_title == "countrywide")
                        {
                            self.taxTitle = self.taxModelObj.tax_title
                            self.taxType = self.taxModelObj.tax_type
                            self.taxAmountValue = self.taxModelObj.tax_amount
                            
                            self.lbl_TaxStateName?.text = "Tax (\(self.taxModelObj.tax_title))"
                        }
                        
                    }
                    else
                    {
                        self.taxModelObj.tax_title = (userdata as AnyObject).value(forKey: "user_tax_lock")as? String ?? ""
                        if(self.taxModelObj.tax_title == (userdata as AnyObject).value(forKey: "user_tax_lock")as? String ?? "")
                        {
                            self.taxTitle = self.taxModelObj.tax_title
                            self.taxType = self.taxModelObj.tax_type
                            self.taxAmountValue = self.taxModelObj.tax_amount
                            
                            DataManager.cartData!["taxAmountValue"]  = self.taxModelObj.tax_amount
                            DataManager.cartData!["taxTitle"]  = self.taxModelObj.tax_title
                            DataManager.cartData!["taxType"]  = self.taxModelObj.tax_type
                            
                            self.lbl_TaxStateName?.text = "Tax (\(self.taxModelObj.tax_title))"
                        }
                    }
                }
                print(DataManager.posTaxListData)
            } else {
                self.getTaxListService()
            }
        }
        //Initialize Swipe Class
        if UI_USER_INTERFACE_IDIOM() == .pad {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                SwipeAndSearchVC.shared.initialize()
            }
        }
        //Reset Cart If Contain Refund-Exchange Product
        if orderType == .newOrder {
            if let cartArray = DataManager.cartProductsArray {
                for data in cartArray {
                    let isRefundProduct = (data as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
                    if isRefundProduct {
                        self.resetCartData(isShowMessage: false)
                        self.calculateTotalCart()
                        break
                    }
                }
            }
        }
        
        if DataManager.isCaptureButton {
            
            str_AddCouponName = ""
            self.tf_AddDiscount?.text = ""
            if let CouponCode = DataManager.OrderDataModel?["str_CouponCode"] {
                strCouponNameCapture = CouponCode as! String
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                if self.strCouponNameCapture != "" {
                    self.str_AddCouponName = self.strCouponNameCapture
                    self.tf_AddDiscount?.text = self.strCouponNameCapture
                    if (self.strCouponNameCapture.count>0)
                    {
                        //New Coupon Applied
                        self.callAPItoGetCoupanProductIds(coupan: self.strCouponNameCapture)
                    }else {
                        self.resetCoupan()
                    }
                }
                self.calculateTotal()
            }
        }
//        if isOpenToOrderHistory {
//            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                self.performSegue(withIdentifier: "paymenttype", sender: nil)
//            }
//        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        viewForSelectedOption.isHidden = true
        super.viewWillAppear(animated)
        if isOpenToOrderHistory {
            saveCustomerData()
        }
        self.btn_Pay?.setTitleColor(.white, for: .normal)
        self.btn_Pay?.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
        //for socket sudama
     //   if UI_USER_INTERFACE_IDIOM() == .pad {
            if DataManager.socketAppUrl == "" && DataManager.showCustomerFacing {
                SettingListDataValue()
     //       }
        }
        //
        if DataManager.showShippingCalculatiosInPos == "false" {
            lblShippngHead.addDashedBorder = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        } else {
            if self.orderType == .refundOrExchangeOrder {
                lblShippngHead.addDashedBorder = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }else{
               lblShippngHead.addDashedBorder = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
            }
           
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if DataManager.isTaxOn {
                self.lbl_TaxStateName?.addDashedBorder = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
                
            }else{
                self.lbl_TaxStateName?.addDashedBorder = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }
        
        if orderInfoObj.Exchange_Payment_Method_arr.count > 0 {
            switch orderInfoObj.paymentMethod {
            case "cash" :
                selectaMethod = "Cash"
                break
            case "credit":
                selectaMethod = "Credit Card"
                break
            case "external":
                selectaMethod = "External"
                break
            case "EMV":
                selectaMethod = "EMV"
                break
            case "external_gift":
                selectaMethod = "External Gift Card"
                break
            case "STORE_CREDIT":
                selectaMethod = "Internal Gift Card"
                break
            case "GIFT_CARD":
                selectaMethod = "Gift Card"
                break
            case "check":
                selectaMethod = "Check"
                break
            case "ach_check":
                selectaMethod = "Ach Check"
                break
            default:
                selectaMethod = orderInfoObj.paymentMethod
                break
            }
            selectPaymentMethod = true
            
            if orderInfoObj.transactionArray.count > 0 {
                
                if orderInfoObj.transactionArray.count > 3 {
                    collectionViewHeight.constant = 150
                } else {
                    collectionViewHeight.constant = CGFloat(orderInfoObj.transactionArray.count * 50)
                }
                exchangePaymentView.constant = collectionViewHeight.constant + 50
                //collectionViewHeight.constant = exchangePaymentView.constant
                
                arrRefundAmount.removeAll()
                for i in 0..<orderInfoObj.transactionArray.count {
                    orderInfoObj.transactionArray[i].availableRefundAmount = orderInfoObj.transactionArray[i].availableRefundAmountCopy
                    let val = orderInfoObj.transactionArray[i].availableRefundAmount
                    arrRefundAmount.append(val)
                }
                
                collectionPayExchange.layoutSubviews()
                collectionPayExchange.layoutIfNeeded()
            } else {
                collectionViewHeight.constant = 20
                exchangePaymentView.constant = collectionViewHeight.constant + 70
                
            }
            self.tbl_Cart.backgroundColor = UI_USER_INTERFACE_IDIOM() == .phone ? UIColor.white : #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
            self.view.backgroundColor = UI_USER_INTERFACE_IDIOM() == .phone ? #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) : #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
            
        }else{
            self.tbl_Cart.backgroundColor = UI_USER_INTERFACE_IDIOM() == .phone ? UIColor.white : #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
            self.view.backgroundColor = UI_USER_INTERFACE_IDIOM() == .phone ? UIColor.white : #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        }
        shippingRefundButton.isSelected = DataManager.isshipOrderButton
        self.idleChargeButton()
        //Add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "ShowKeyboard"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "SaveApplicationData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveApplicationData(_:)), name: Notification.Name(rawValue: "SaveApplicationData"), object: nil)
        //Disable IQKeyboardManager
        if UI_USER_INTERFACE_IDIOM() == .pad {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        SwipeAndSearchVC.shared.isProductSearching = true
        blurView.isHidden = true
        self.viewKeyboardAddDiscount?.isHidden = true
        //Enable Swipe and Search Class
        //if UI_USER_INTERFACE_IDIOM() == .phone {
            SwipeAndSearchVC.delegate = nil
            SwipeAndSearchVC.delegate = self
            SwipeAndSearchVC.shared.enableTextField()
       // }
        
        if UI_USER_INTERFACE_IDIOM() == .phone && orderType == .refundOrExchangeOrder {
            self.cartSubtotalBackView.alpha = 0
            UIView.animate(withDuration: 1.0) {
                self.cartSubtotalBackView.alpha = 1.0
            }
        }
        self.cartTotalBackView.isHidden = UI_USER_INTERFACE_IDIOM() == .phone && orderType == .newOrder
        self.cartSubtotalBackView.layer.cornerRadius = UI_USER_INTERFACE_IDIOM() == .phone ? 0 : 5
        self.addDiscountView.layer.borderWidth = UI_USER_INTERFACE_IDIOM() == .phone ? 0 : 1
        self.addDiscountView.layer.cornerRadius = UI_USER_INTERFACE_IDIOM() == .phone ? 0 : 4
        
        self.isCreditCardNumberDetected = false
        SwipeAndSearchVC.shared.enableTextField()
        //Hide View When Internet Off
        //self.taxView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.shippingView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.applyCouponView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.addDiscountView.isHidden = orderType == .refundOrExchangeOrder
        if DataManager.posDisableDiscountFeature == "true" {
            self.addDiscountView.isHidden = true
        }
        self.productSearchBackView.isHidden = orderType == .newOrder || UI_USER_INTERFACE_IDIOM() == .pad
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            self.view_AddCustomer.isHidden = true
        }else {
            self.view_AddCustomer.isHidden = !DataManager.isCustomerManagementOn || orderType == .refundOrExchangeOrder
        }
        if DataManager.isshippingRefundOnly || DataManager.isTipRefundOnly {
            self.productSearchBackView.isHidden =  true
        }
        //OfflineDataManager Delegate
        OfflineDataManager.shared.cartContainerDelegate = self
        
        //Update Logo
        if let logoUrl = DataManager.logoImageUrl {
            if let url = URL(string: logoUrl) {
                self.emptyCartImageView.kf.setImage(with: url)
            }
        }
        
        self.updateData()
        self.refreshCart()
        if let val = DataManager.showShipOrderInPos {
            self.str_showShipOrderInPos = val
        }
        //self.str_showShipOrderInPos = DataManager.showShipOrderInPos!
        if self.str_showShipOrderInPos == "true" || self.lbl_ShippingAndHandling.text != "$0.00" {
            if str_showShipOrderInPos == "true" {
                self.shippingRefundButton.isHidden = false
            }else{
                self.shippingRefundButton.isHidden = true
            } //self.orderType == .newOrder
        }else{
            shippingRefundButton.isHidden = true
        }
        if orderType == .refundOrExchangeOrder {
          if  self.lbl_ShippingAndHandling.text != "$0.00" {
                self.shippingRefundButton.isHidden = false
            }
        }
        if !Keyboard._isExternalKeyboardAttached() {
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        }
        self.updatePaymentMethods()
        
        if versionOb < 4 {
            shippingRefundButton.isHidden = true
        }
        if isOpenToOrderHistory {
            if str_AddCouponName == "" {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    DataManager.isBalanceDueData = true
                    self.performSegue(withIdentifier: "paymenttype", sender: nil)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        saveAllData()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "ShowKeyboard"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "SaveApplicationData"), object: nil)
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = true
        //Remove Observer
        NotificationCenter.default.removeObserver(self)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            SwipeAndSearchVC.delegate = nil
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        controller?.dismiss(animated: true, completion: nil)
        if CartContainerViewController.isPickerSelected {
            let array = self.array_TaxList.compactMap({$0.tax_title})
            self.setPickerView(textField: self.btn_TfTax, array: array)
        }
    }
    
    @objc func saveApplicationData(_ sender: Notification) {
        saveAllData()
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
                                           //------ sudama add surcharge variation value start ------//
                                            name = val["attribute_value"] as? String ?? ""
                                           isShowDetails = select!
                                          // newString.append("\(key): \(name)\n") // poS
                                           dictSocket["key"] = key
                                          // dictSocket["value"] = name
                                           dictSocket["value"] = "\(name)\(surchargVariationValue)"
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
                                       isShowDetails = true
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
    
    //MARK: IBAction Method
    
    @objc func actionTapQuantity(sender: UITapGestureRecognizer){
        
        //let indexPath = IndexPath(item: sender., section: 0)
        //let cellindex = self.tbl_Cart?.cellForItem(at: indexPath) as? AddPaymentCollectionCell
        
        
        let recognizer: UIGestureRecognizer = sender
        let tag: Int = recognizer.view!.tag
        self.selectedIndex = tag
        
        //let indexPath = IndexPath(item: tag, section: 0)
        //let cellindex = self.tbl_Cart?.cellForRow(at: indexPath) as? CartTableCell
        
        let cartProductsArray = self.cartProductsArray[tag]
        
        let dataQty = (cartProductsArray as AnyObject).value(forKey: "available_qty_refund") as? Double ?? 1
        
        let alert = UIAlertController(title: "Quantity" , message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            self.QuantityTextField = textField
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.tag = 2001
            textField.placeholder = "Enter quantity"
            textField.text = String(fabs(dataQty))
            textField.selectAll(nil)
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.handleQuantity(textField: textField)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.catAndProductDelegate?.hideView?(with: "alertblurcancel")
        }))
        self.catAndProductDelegate?.hideView?(with: "alertblur")
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnTipRefundButton(_ sender: Any) {
        self.view.endEditing(true)
        btnTipSelect.isSelected = !btnTipSelect.isSelected
        //DataManager.isTipRefundOnly = btnTipSelect.isSelected
        orderInfoObj.isTipRefundSelected = btnTipSelect.isSelected
        calculateTotalCart()
    }
    @IBAction func shippingRefundButton(_ sender: UIButton) {
        if isOpenToOrderHistory{
            return
        }
        //if CustomerObj.str_address != "" && CustomerObj.str_city != ""  && CustomerObj.str_region != "" && CustomerObj.str_postal_code != "" && CustomerObj.country != "" {
        self.view.endEditing(true)
        shippingRefundButton.isSelected = !shippingRefundButton.isSelected
        DataManager.isshipOrderButton = shippingRefundButton.isSelected
        orderInfoObj.isshippingRefundSelected = shippingRefundButton.isSelected
        calculateTotalCart()
        //        } else {
        //            self.showAlert(message: "Please enter Customer address.")
        //        }
        //
        
    }
    
    @IBAction func addDiscountViewButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if isOpenToOrderHistory{
            return
        }
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddDiscountPopupVC") as! AddDiscountPopupVC
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
    
    @IBAction func btn_AddCustomerAction(_ sender: Any) {
        self.view.endEditing(true)
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        if isOpenToOrderHistory{
            return
        }
        view_AddCustomer.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.view_AddCustomer.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        CartContainerViewController.isPickerSelected = false
        SwipeAndSearchVC.shared.enableTextField()
        isAddNewButtonSelected = true
        self.customerDelegate?.didSelectAddCustomerButton?()
        self.customerDelegate?.didSelectCustomer?(data: CustomerObj)
        DataManager.isPaymentBtnAddCustomer = false
        if DataManager.isCustomerManagementOn
        {
            if UI_USER_INTERFACE_IDIOM() == .pad
            {
                self.catAndProductDelegate?.hideView?(with: "addcustomerBtn_ActionIPAD")
            }
            else
            {
                performSegue(withIdentifier: "selectcustomer", sender: nil)
            }
        }
    }
    
    @IBAction func serachTextFieldDidChange(_ sender: UITextField) {
        
    }
    
    @IBAction func btn_TfTaxAction(_ sender: UITextField) {
        if isOpenToOrderHistory{
            return
        }
        isCheckItem = false
        if DataManager.isTaxOn
        {
            if self.array_TaxList.count == 0 {
                self.view.endEditing(true)
                self.cartViewDelegate?.didHideView(with: "customviewhide")
                self.btn_TfTax.resignFirstResponder()
//                self.showAlert(message: "No Tax List found.")
                appDelegate.showToast(message: "No Tax List found.")
                return
            }
            
            isAddDiscount = false
            isAddCoupon = false
            isAddNote = false
            isShippingHandling = false
            self.cartViewDelegate?.didHideView(with: "customviewunhidetax")
            
            setView(view: (viewKeyboardAddDiscount)!, hidden: true)
            self.pickerDelegate = self
            let array = self.array_TaxList.compactMap({$0.tax_title})
            CartContainerViewController.isPickerSelected = true
            self.setPickerView(textField: self.btn_TfTax, array: array)
        }
        else
        {
            btn_TfTax?.resignFirstResponder()
//            self.showAlert(message: "Tax setting is OFF")
         //   appDelegate.showToast(message: "Tax setting is OFF")
        }
    }
    
    @IBAction func removeCoupanAction(_ sender: Any) {
        self.view.endEditing(true)
        if isOpenToOrderHistory{
            return
        }
        CartContainerViewController.isPickerSelected = false
        str_AddCouponName = ""
        isCoupanApplyOnAllProducts = false
        lbl_AppliedCouponName.text = "Apply Coupon"
        str_CouponDiscount = ""
        taxableCouponTotal = 0.0
        HomeVM.shared.coupanDetail.code = ""
        crossButton.isHidden = true
        self.calculateTotalCart()
    }
    
    @IBAction func actionCancelSubscription(_ sender: Any) {
        if isOpenToOrderHistory{
            return
        }
        if UI_USER_INTERFACE_IDIOM() == .pad{
            self.delegateEditProduct?.showSubscriptionView?()
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SubscriptionContainerViewController") as! SubscriptionContainerViewController
            controller.modalPresentationStyle = .overCurrentContext
            controller.subDelegate = self
            controller.strSubscriptionValueCheck = strSubscriptionValue
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    @IBAction func btn_ShippingCalculateAction(_ sender: Any) {
        if isOpenToOrderHistory{
            return
        }
        //if CustomerObj.str_address != "" && CustomerObj.str_city != ""  && CustomerObj.str_region != "" && CustomerObj.str_postal_code != "" && CustomerObj.country != "" {
        
        if orderType == .refundOrExchangeOrder {
            return
        }
        
        if DataManager.showShippingCalculatiosInPos == "true" {
            if Int(DataManager.appVersion)! < 4 {
                //Devd
            }else{
                if(UI_USER_INTERFACE_IDIOM() == .pad)
                {
                    self.delegateEditProduct?.didShowShippingAddress?(data: CustomerObj)
                    self.delegateEditProduct?.getCartProductsArray?(data:cartProductsArray)
                    self.delegateEditProduct?.showShippingCard?()
                }else {
                    self.delegateEditProduct?.didShowShippingAddress?(data: CustomerObj)
                    self.delegateEditProduct?.getCartProductsArray?(data:cartProductsArray)
                    self.delegateEditProduct?.showShippingCard?()
                }
            }
        }
        //        } else {
        //            self.showAlert(message: "Please enter Customer address.")
        //        }
        
    }
    
    @IBAction func btn_ShippingAndHandlingAction(_ sender: Any) {
        if isOpenToOrderHistory{
            return
        }
        //if CustomerObj.str_address != "" && CustomerObj.str_city != ""  && CustomerObj.str_region != "" && CustomerObj.str_postal_code != "" && CustomerObj.country != "" {
        
        if orderType == .refundOrExchangeOrder {
            return
        }
        
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        self.view.endEditing(true)
        CartContainerViewController.isPickerSelected = false
        
        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            let alert = UIAlertController(title: "Shipping & Handling", message: "", preferredStyle: .alert)
            alert.addTextField { (textField) in
                self.shippingTextField = textField
                textField.delegate = self
                textField.keyboardType = .decimalPad
                textField.tag = 2000
                textField.placeholder = "Please enter Manual Shipping ($)"
                textField.setDollar(color: UIColor.darkGray, font: textField.font!)
                //self.str_ShippingANdHandling = self.str_ShippingANdHandling.replacingOccurrences(of: ".00", with: "")
                //self.str_ShippingANdHandling = self.str_ShippingANdHandling.replacingOccurrences(of: ".0", with: "")
                textField.text = self.str_ShippingANdHandling == "0.0" ? "" : self.str_ShippingANdHandling
                textField.selectAll(nil)
            }
            alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0]
                self.handleShippingAndHandling(textField: textField)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                self.catAndProductDelegate?.hideView?(with: "alertblurcancel")
            }))
            self.catAndProductDelegate?.hideView?(with: "alertblur")
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            tf_AddDiscount?.rightView = nil
            tf_AddDiscount?.inputView = nil
            tf_AddDiscount?.inputAccessoryView = nil
            tf_AddDiscount?.keyboardType = .decimalPad
            tf_AddDiscount?.reloadInputViews()
            //tf_AddDiscount?.setDollar(color: UIColor.darkGray, font: tf_AddDiscount!.font!)
            blurView.isHidden = true
            isShippingHandling = true
            isAddCoupon = false
            isAddDiscount = false
            isAddNote = false
            setView(view: viewKeyboardAddDiscount!, hidden: false)
            var shipping = self.str_ShippingANdHandling.replacingOccurrences(of: "$", with: "")
            shipping = shipping.replacingOccurrences(of: " ", with: "")
            tf_AddDiscount?.text = Double(shipping) ?? 0.00 == 0.00 ? "": "\(shipping)"
            tf_AddDiscount?.selectAll(nil)
            lbl_ViewKeyboardTitle.text = "Shipping & Handling"
            tf_AddDiscount?.keyboardType = UIKeyboardType.decimalPad
            tf_AddDiscount?.becomeFirstResponder()
            tf_AddDiscount?.placeholder = "Please enter Manual Shipping ($)"
            tf_AddDiscount?.setDollar(color: UIColor.darkGray, font: tf_AddDiscount!.font!)
            self.cartViewDelegate?.didHideView(with: "customviewunhide")
            self.view.layoutIfNeeded()
        }
        
        //        } else {
        //            self.showAlert(message: "Please enter Customer address.")
        //        }
    }
    
    @IBAction func btn_AddDiscountAction(_ sender: Any) {
        if isOpenToOrderHistory{
            return
        }
        self.isPercentageDiscountApplied = false
        self.handleAddDiscountAction()
    }
    
    @IBAction func btn_AddNoteAction(_ sender: Any) {
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        
    }
    
    @IBAction func btn_AddCouponAction(_ sender: Any)
    {
        if isOpenToOrderHistory{
            return
        }
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        if(UI_USER_INTERFACE_IDIOM() == .pad) {
            self.showApplyCouponIPad()
        } else {
            self.showApplyCouponIphone()
        }
    }
    
    @IBAction func btn_TaxCancelAction(_ sender: Any) {
        setView(view: view_Tax!, hidden: true)
        self.cartViewDelegate?.didHideView(with: "customviewhide")
        self.cartViewDelegate?.didHideView(with: "customviewhide")
    }
    
    @IBAction func btn_TaxDoneAction(_ sender: Any)
    {
        if tf_Tax?.text == "" {
            return
        }
        setView(view: view_Tax!, hidden: true)
        self.cartViewDelegate?.didHideView(with: "customviewhide")
        lbl_TaxStateName?.text = "Tax (\(tf_Tax?.text ?? ""))"
        calculateTotalCart()
        tf_Tax?.text = ""
    }
    
    @IBAction func btn_AddDiscountDoneAction(_ sender: Any)
    {
        self.handleTickButtonActionForIPhone()
    }
    
    @IBAction func btn_AddDiscountCancelAction(_ sender: Any) {
        blurView.isHidden = true
        if (isShippingHandling)
        {
            isShippingHandling = false
            tf_AddDiscount?.resignFirstResponder()
            setView(view: viewKeyboardAddDiscount!, hidden: true)
            self.cartViewDelegate?.didHideView(with: "customviewhide")
            tf_AddDiscount?.text = ""
            btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-inactive"), for: .normal)
        }
        else if(isAddCoupon)
        {
            isAddCoupon = false
            tf_AddDiscount?.resignFirstResponder()
            setView(view: viewKeyboardAddDiscount!, hidden: true)
            self.cartViewDelegate?.didHideView(with: "customviewhide")
            tf_AddDiscount?.text = ""
            btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-inactive"), for: .normal)
        }
        else if(isAddNote)
        {
            isAddNote = false
            txt_Note?.resignFirstResponder()
            setView(view: viewKeyboardAddDiscount!, hidden: true)
            self.cartViewDelegate?.didHideView(with: "customviewhide")
            tf_AddDiscount?.isHidden = false
            txt_Note?.isHidden = true
            tf_AddDiscount?.text = ""
            txt_Note?.text = ""
            btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-inactive"), for: .normal)
        }
        else
        {
            isAddDiscount = false
            tf_AddDiscount?.resignFirstResponder()
            setView(view: viewKeyboardAddDiscount!, hidden: true)
            self.cartViewDelegate?.didHideView(with: "customviewhide")
            tf_AddDiscount?.text = ""
            btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-inactive"), for: .normal)
        }
    }
    
    func futureSubcriptionHandle(){
        let refreshAlert = UIAlertController(title: "", message: "Active subscription(s) exists on this account, would you like to cancel them or ignore", preferredStyle: UIAlertControllerStyle.alert)
    
        let ignor = UIAlertAction(title: "Ignore", style: .destructive, handler: { (action) in
            self.ignoreSubcriptionCheck = true
            self.btn_PayAction(self)
            
        })
        let cancel = UIAlertAction(title: "Cancel Subscription", style: .default, handler: { (action) in
            if UI_USER_INTERFACE_IDIOM() == .pad{
                self.delegateEditProduct?.showSubscriptionView?()
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "SubscriptionContainerViewController") as! SubscriptionContainerViewController
                controller.modalPresentationStyle = .overCurrentContext
                controller.subDelegate = self
                controller.strSubscriptionValueCheck = self.strSubscriptionValue
                self.present(controller, animated: true, completion: nil)
            }
            return
        })
        refreshAlert.addAction(cancel)
        refreshAlert.addAction(ignor)
        present(refreshAlert, animated: true, completion: nil)
      
    }
    @IBAction func btn_PayAction(_ sender: Any) {
        
        if self.AddSubscription.isHidden == false {
            if !ignoreSubcriptionCheck {
                if strSubscriptionValue == "" || strSubscriptionValue == "no_change" {
                    futureSubcriptionHandle()
                    return
                }
            }
        }
        
        var isBlueColor = false
        if btn_Pay?.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isBlueColor = false
        }else {
            isBlueColor = true
        }
        
        UIView.animate(withDuration: 0.1,
                       animations: {
                        //Fade-out
                        // cell?.alpha = 0.3
                        if self.orderType == .newOrder {
                            if(UI_USER_INTERFACE_IDIOM() == .pad){
                                self.btn_Pay?.backgroundColor = isBlueColor ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
                                
                            }else {
                                self.btn_Pay?.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
                            }
                        }else {
                            if(UI_USER_INTERFACE_IDIOM() == .pad){
                                self.btn_Pay?.backgroundColor = isBlueColor ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
                                
                            }else {
                                self.btn_Pay?.backgroundColor =  #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
                            }
                        }
                        
                        
                        //isBlueColor ? #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1) : #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        
                       }) { (completed) in
            DispatchQueue.main.async {
                
                var isfull = true
                for i in 0..<self.cartProductsArray.count {
                    let cart =  self.cartProductsArray[i]
                    let isRefundProduct = (cart as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? true
                    if !isRefundProduct {
                        isfull = false
                    }
                }
                
                if isfull {
                    
                } else {
                    if  self.lblRefundTotalRemaining.text == "$0.00" {
                        
                    } else {
                        
                        if  self.TotalPrice < 0{
                            //self.showAlert(message: "Remaining amount must be zero.")
                            appDelegate.showToast(message: "Remaining amount must be zero.")
                            return
                        }
                    }
                }
                
                if isfull {
                    
                } else {
                    if DataManager.isshippingRefundOnly  ||  self.shippingRefundButton.isSelected {
                        if  self.lblRefundTotalRemaining.text == "$0.00" {
                            
                        } else {
                            appDelegate.showToast(message: "Remaining amount must be zero.")
                            return
                        }
                    }
                }
                
                
                appDelegate.isCustomerPageOpen = false
                appDelegate.isVoidPayment = false
                
                self.delegate?.callOpenOrCloseCustomer?()
                
                if appDelegate.isCustomerPageOpen {
                    appDelegate.isCustomerPageOpen = false
                    return
                }
                
                if iPadSelectCustomerViewController.isSelectCustomerOpen == true {
                    //            self.showAlert(message: "Please first save the customer information.")
                    appDelegate.showToast(message: "Please first save the customer information.")
                    return
                }
                
                if appDelegate.str_Refundvalue != "" {
                    self.idleChargeButton()
                    DispatchQueue.main.async {
                        self.handlePayButtonAction()
                    }
                    return
                }
                
                if(UI_USER_INTERFACE_IDIOM() == .phone){
                    DataManager.isPaymentBtnAddCustomer = true
                    if  self.shippingRefundButton.isSelected { //}|| Double(self.str_ShippingANdHandling) ?? 0.00 > 0 {
                        self.view.endEditing(true)
                        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
                        CartContainerViewController.isPickerSelected = false
                        SwipeAndSearchVC.shared.enableTextField()
                        self.isAddNewButtonSelected = true
                        self.customerDelegate?.didSelectCustomer?(data:  self.CustomerObj)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let secondVC = storyboard.instantiateViewController(withIdentifier: "AddNewCutomerViewController") as! AddNewCutomerViewController
                        secondVC.selectedUser =  self.CustomerObj
                        if DataManager.isCheckUncheckShippingBilling {
                            if  self.CustomerObj.str_address == "" &&  self.CustomerObj.str_city == "" &&  self.CustomerObj.str_region == "" &&  self.CustomerObj.str_postal_code == "" {
                                self.present(secondVC, animated: true, completion: nil)
                            }else{
                                if  self.CustomerObj.str_address == "" &&  self.CustomerObj.str_address2 == "" {
                                    self.present(secondVC, animated: true, completion: nil)
                                }else if  self.CustomerObj.str_city == "" {
                                    self.present(secondVC, animated: true, completion: nil)
                                }else if  self.CustomerObj.str_region == "" {
                                    self.present(secondVC, animated: true, completion: nil)
                                }else if  self.CustomerObj.str_postal_code == "" {
                                    self.present(secondVC, animated: true, completion: nil)
                                }else{
                                    self.idleChargeButton()
                                    DispatchQueue.main.async {
                                        self.handlePayButtonAction()
                                    }
                                }
                            }
                        }else{
                            if  self.CustomerObj.str_Shippingaddress == "" &&  self.CustomerObj.str_Shippingcity == "" &&  self.CustomerObj.str_Shippingregion == "" &&  self.CustomerObj.str_Shippingpostal_code == "" {
                                self.present(secondVC, animated: true, completion: nil)
                            }else{
                                if  self.CustomerObj.str_Shippingaddress == "" &&  self.CustomerObj.str_Shippingaddress2 == "" {
                                    self.present(secondVC, animated: true, completion: nil)
                                }else if  self.CustomerObj.str_Shippingcity == "" {
                                    self.present(secondVC, animated: true, completion: nil)
                                }else if  self.CustomerObj.str_Shippingregion == "" {
                                    self.present(secondVC, animated: true, completion: nil)
                                }else if  self.CustomerObj.str_Shippingpostal_code == "" {
                                    self.present(secondVC, animated: true, completion: nil)
                                }else{
                                    self.idleChargeButton()
                                    DispatchQueue.main.async {
                                        self.handlePayButtonAction()
                                    }
                                }
                            }
                            
                        }
                        
                    }else{
                        self.idleChargeButton()
                        DispatchQueue.main.async {
                            self.handlePayButtonAction()
                        }
                    }
                }else{
                    DataManager.isPaymentBtnAddCustomer = true
                    if  self.shippingRefundButton.isSelected { //}|| Double(self.str_ShippingANdHandling) ?? 0.00 > 0 {
                        self.view.endEditing(true)
                        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
                        CartContainerViewController.isPickerSelected = false
                        SwipeAndSearchVC.shared.enableTextField()
                        self.isAddNewButtonSelected = true
                        self.customerDelegate?.didSelectCustomer?(data:  self.CustomerObj)
                        
                        if DataManager.isCheckUncheckShippingBilling {
                            if  self.CustomerObj.str_address == "" &&  self.CustomerObj.str_city == "" &&  self.CustomerObj.str_region == "" &&  self.CustomerObj.str_postal_code == "" {
                                self.catAndProductDelegate?.hideView?(with: "paymentActionAddCustomer")
                            }else{
                                if  self.CustomerObj.str_address == "" &&  self.CustomerObj.str_address2 == "" {
                                    self.catAndProductDelegate?.hideView?(with: "paymentActionAddCustomer")
                                }else if  self.CustomerObj.str_city == "" {
                                    self.catAndProductDelegate?.hideView?(with: "paymentActionAddCustomer")
                                }else if  self.CustomerObj.str_region == "" {
                                    self.catAndProductDelegate?.hideView?(with: "paymentActionAddCustomer")
                                }else if  self.CustomerObj.str_postal_code == "" {
                                    self.catAndProductDelegate?.hideView?(with: "paymentActionAddCustomer")
                                }else{
                                    self.idleChargeButton()
                                    DispatchQueue.main.async {
                                        self.handlePayButtonAction()
                                    }
                                }
                            }
                        }else{
                            if  self.CustomerObj.str_Shippingaddress == "" &&  self.CustomerObj.str_Shippingcity == "" &&  self.CustomerObj.str_Shippingregion == "" &&  self.CustomerObj.str_Shippingpostal_code == "" {
                                self.catAndProductDelegate?.hideView?(with: "paymentActionAddCustomer")
                            }else{
                                if  self.CustomerObj.str_Shippingaddress == "" &&  self.CustomerObj.str_Shippingaddress2 == "" {
                                    self.catAndProductDelegate?.hideView?(with: "paymentActionAddCustomer")
                                }else if  self.CustomerObj.str_Shippingcity == "" {
                                    self.catAndProductDelegate?.hideView?(with: "paymentActionAddCustomer")
                                }else if  self.CustomerObj.str_Shippingregion == "" {
                                    self.catAndProductDelegate?.hideView?(with: "paymentActionAddCustomer")
                                }else if  self.CustomerObj.str_Shippingpostal_code == "" {
                                    self.catAndProductDelegate?.hideView?(with: "paymentActionAddCustomer")
                                }else{
                                    self.idleChargeButton()
                                    DispatchQueue.main.async {
                                        self.handlePayButtonAction()
                                    }
                                }
                            }
                            
                        }
                        
                    }else{
                        self.idleChargeButton()
                        DispatchQueue.main.async {
                            self.handlePayButtonAction()
                        }
                    }
                }
                
                //                self.SetBtnColor()
            }
        }
        
        
    }
    
    //MARK: Private Functions
    private func idleChargeButton(by time: Double = 0.5) {
        if NetworkConnectivity.isConnectedToInternet() {
            self.btn_Pay?.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                self.btn_Pay?.isUserInteractionEnabled = true
            }
        }else {
            self.btn_Pay?.isUserInteractionEnabled = true
        }
    }
    // for socket sudama
    func SettingListDataValue() {
        HomeVM.shared.getSetting(responseCallBack: { (success, message, error) in
            //  Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                
                print("succes value in data")
                
                for data in HomeVM.shared.settingList {
                    
                    let keyData = data.settingKey
                    let valueData = data.settingValue
                    //let option = data.settingOption
                    
                    switch keyData {
                    // socket sudama
                    case "socket_app_url":
                        if valueData != "" || valueData != "NULL" {
                            DataManager.socketAppUrl = valueData!
                    } else {
                        DataManager.socketAppUrl = "https://node.hiecor.com"
                    }
                    default: break
                        
                    }
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
    //
    private func enableSwipeReader() {
        //Check For External Accessory
        DispatchQueue.main.async {
            if Keyboard._isExternalKeyboardAttached() {
                self.view.endEditing(true)
                SwipeAndSearchVC.shared.enableTextField()
                return
            }
        }
    }
    
    
    private func resetCoupan() {
        //Reset Coupan
        self.crossButton.isHidden = true
        self.str_AddCouponName = ""
        self.taxableCouponTotal = 0.0
        self.lbl_AppliedCouponName.text = "Apply Coupon"
        self.lbl_AppliedCouponAmount.text = "$0.00"
        self.crossButton.isHidden = true
        self.str_CouponDiscount = ""
        HomeVM.shared.coupanDetail.code = ""
        CartContainerViewController.isPickerSelected = false
        self.calculateTotalCart()
    }
    
    private func parseRefundOrderData(obj: OrderInfoModel) {
        orderInfoObj = obj
        
        var jsonArray = JSONArray()
        strStatusItem.removeAllObjects()
        for product in obj.productsArray {
            showItems.removeAll()
            strStatusItem.add("Unopened")
            
            
            var dict = JSONDictionary()
            dict["productqty"] = -(product.qty)
            dict["actualproductqty"] = -(product.availableQtyRefund)
            //dict["productprice"] = product.mainPrice/product.qty
            dict["productprice"] = product.price //product.refundAmount/product.qty
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
            dict["returnToStock"] = true // 18-Oct-2022 for check return to inventry
            dict["isRefundProduct"] = true
            dict["selectionInventory"] = ""
            dict["isTaxExempt"] = product.isLineTaxExempt ? "Yes" : "No"
            dict["shippingPrice"] = product.shippingPrice
            dict["salesID"] = product.salesID
            dict["productistaxable"] = product.isTaxable
            dict["payment_method"] = product.paymentMethod
            dict["selectedAttributes"] = product.selectedAttributesData
            dict["variationData"] = product.attributesData
            dict["is_taxable"] = product.isTaxable
            dict["meta_fieldsDictionary"] = product.meta_fieldsDictionary
            
            self.str_ShippingANdHandling = obj.shipping.roundToTwoDecimal
            jsonArray.append(dict)
        }
        str_ShippingANdHandlingForRefund = self.orderInfoObj.shipping.description
        //        tipRefund = obj.tip
        //
        //        if obj.tip > 0 {
        //            viewTip.isHidden = false
        //            lblTipAmount.text = tipRefund.currencyFormat
        //        }
        
        self.cartProductsArray = jsonArray
        DataManager.cartProductsArray = self.cartProductsArray
    }
    
    private func handleTickButtonActionForIPhone() {
        blurView.isHidden = true
        if (isShippingHandling)
        {
            str_ShippingANdHandling = (tf_AddDiscount?.text!)!
            tf_AddDiscount?.resignFirstResponder()
            setView(view: (viewKeyboardAddDiscount)!, hidden: true)
            self.cartViewDelegate?.didHideView(with: "customviewhide")
            str_ShippingANdHandling = str_ShippingANdHandling.replacingOccurrences(of: "$", with: "")
            let shipping = Double(str_ShippingANdHandling) ?? 0.00
            
            lbl_ShippingAndHandling.text = shipping.currencyFormat
            self.isShippingPriceChanged = true
            calculateTotalCart()
        }
        else if(isAddCoupon)
        {
            self.handleApplyCouponIphone()
        }
        else if(isAddNote)
        {
            str_AddNote = (txt_Note?.text)!
            txt_Note?.resignFirstResponder()
            setView(view: viewKeyboardAddDiscount!, hidden: true)
            self.cartViewDelegate?.didHideView(with: "customviewhide")
            tf_AddDiscount?.isHidden = false
            txt_Note?.isHidden = true
            txt_Note?.text = ""
            icon_btnAddNote.setImage(UIImage(named: "edit-icon"), for: .normal)
        }
        else
        {
            
            if self.isPercentageDiscountApplied {
                self.str_AddDiscountPercent = (tf_AddDiscount!.text ?? "").replacingOccurrences(of: "$", with: "")
                //var discount = Double(self.str_AddDiscountPercent) ?? 0.00
            } else {
                self.str_AddDiscount = (tf_AddDiscount!.text ?? "").replacingOccurrences(of: "$", with: "")
                //var discount = Double(self.str_AddDiscount) ?? 0.00
            }
            //
            //            //var discount = self.isPercentageDiscountApplied ? ()
            //
            //            var discount = self.isPercentageDiscountApplied ? (Double(self.str_AddDiscountPercent) ?? 0.0) : (Double(self.str_AddDiscount) ?? 0.0)
            
            
            self.str_AddDiscount = (tf_AddDiscount?.text ?? "").replacingOccurrences(of: "$", with: "")
            tf_AddDiscount?.resignFirstResponder()
            setView(view: viewKeyboardAddDiscount!, hidden: true)
            self.cartViewDelegate?.didHideView(with: "customviewhide")
            var discount = Double(str_AddDiscount) ?? 0.00
            if self.isPercentageDiscountApplied {
                discount = ((Double(self.str_AddDiscount) ?? 0.00) / 100) * self.SubTotalPrice
                discount = discount < 0 ? 0 : discount
            }
            self.str_AddDiscount = "\(discount)"
            self.lbl_AddDiscount.text = discount.currencyFormat
        }
        calculateTotalCart()
    }
    
    private func handlePayButtonAction() {
        
        if DataManager.isCaptureButton {
            orderType = .refundOrExchangeOrder
        }
        
        saveAllData()
        self.isOrderPrepare = false
        self.view.endEditing(true)
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        CartContainerViewController.updatedProductIndex = nil
        CartContainerViewController.isPickerSelected = false
        
        var tax = Double(self.str_TaxAmount) ?? 0.0
        tax = tax < 0 ? 0 : tax
        self.str_TaxAmount = tax.roundToTwoDecimal
        
        let shipping = Double(self.str_ShippingANdHandling) ?? 0.0
        self.str_ShippingANdHandling = shipping.roundToTwoDecimal
        
        if self.cartProductsArray.count > 0 {
            if orderType == .newOrder {
                self.moveToPayment()
            }else {
                
                if TotalPrice > 0 {
                    if orderInfoObj.cardDetail?.number != nil {
                        var number  = orderInfoObj.cardDetail!.number
                        if number != "" {
                            number = "************"+number!
                        }
                        PaymentsViewController.paymentDetailDict["data"] = ["cardnumber":number!,"mm":orderInfoObj.cardDetail?.month, "yyyy":orderInfoObj.cardDetail?.year, "cvv": ""]
                    }
                    if DataManager.isCaptureButton {
                        DataManager.isSplitPayment = false
                        prepareOrderForCapture()
                        return
                    }
                    
                    self.moveToPayment()
                }else {
                    if orderInfoObj.Exchange_Payment_Method_arr.count > 0 {
                        switch selectaMethod {
                        case "Cash" :
                            selectPaymentMethodValue = "cash"
                            prepareOrderForExchange()
                            break
                        case "Credit Card":
                            selectPaymentMethodValue = "credit"
                            prepareOrderForExchange()
                            break
                        case "External":
                            selectPaymentMethodValue = "external"
                            prepareOrderForExchange()
                            break
                        case "EMV":
                            //if str_addDeviceName != "" {
                                selectPaymentMethodValue = "EMV"
                                prepareOrderForExchange()
//                            }else {
//                                callAPItoGetPayPAXDeviceList()
//                                //showAlert(message: "Please select device")
//                            }
                            break
                        case "External Gift Card":
                            if str_externalGiftCardNumber != ""{
                                selectPaymentMethodValue = "external_gift"
                                prepareOrderForExchange()
                            }else {
                                //externalGiftCardAlertPopUp()
                                prepareOrderForExchange()
                                //showAlert(message: "Please enter gift card number")
                            }
                            break
                        case "Internal Gift Card":
                            if str_internalGiftCardNumber != "" {
                                selectPaymentMethodValue = "STORE_CREDIT"
                                prepareOrderForExchange()
                            }else{
                                //internalGiftCardAlertPopUp()
                                prepareOrderForExchange()
                                //showAlert(message: "Please enter gift card number")
                            }
                            break
                        case "Gift Card":
                            selectPaymentMethodValue = "gift_card"
                            prepareOrderForExchange()
                            break
                        case "Check":
                            selectPaymentMethodValue = "check"
                            prepareOrderForExchange()
                            break
                        case "Ach Check":
                            selectPaymentMethodValue = "ach_check"
                            prepareOrderForExchange()
                            break
                        default:
                            selectPaymentMethodValue = "credit"
                            prepareOrderForExchange()
                            break
                        }
                    }
                    // self.prepareOrderForExchange()
                }
            }
        }else {
            if DataManager.isshippingRefundOnly || DataManager.isTipRefundOnly {
                prepareOrderForExchange()
            } else {
                Indicator.sharedInstance.hideIndicator()
                //            showAlert(message: "Please add atleast one product in cart.")
                appDelegate.showToast(message: "Please add atleast one product in cart.")

            }
         }
    }
    
    private func moveToPayment() {
//        if (self.revealViewController().frontViewPosition != FrontViewPositionLeft) {
//            self.revealViewController()?.revealToggle(animated: true)
//        }
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            let couponTotal = taxableCouponTotal < 0 ? 0 : taxableCouponTotal
            
            let cartData = ["isDefaultTaxSelected": isDefaultTaxSelected , "isDefaultTaxChanged" : isDefaultTaxChanged, "shippingRefundButtonSelected" : shippingRefundButton.isSelected,"orderInfoObj":self.orderInfoObj, "isShippingPriceChanged":self.isShippingPriceChanged, "cartArray":self.cartProductsArray, "subTotal":self.SubTotalPrice, "addDiscount":str_AddDiscount, "tax":self.str_TaxAmount, "taxType":self.taxType,"taxAmountValue":self.taxAmountValue, "ShippingHandling":self.str_ShippingANdHandling, "notes":self.str_AddNote, "taxStateName":self.taxTitle, "Total":self.TotalPrice, "customerObj":self.CustomerObj, "couponName":str_AddCouponName, "couponAmount":couponTotal] as [String : Any]
            self.delegate?.didTapOnPayButton?(dict: cartData)
        }
        else
        {
            Indicator.sharedInstance.hideIndicator()
            
            // by sudama add sub
            var isAddSubscription = false
            if self.cartProductsArray.count > 0 {
                for i in 0..<cartProductsArray.count {
                    let addSubcriptionCheck = (cartProductsArray[i] as AnyObject).value(forKey: "addSubscription") as? Bool ?? false
                    if addSubcriptionCheck {
                        isAddSubscription = true
                    }
                }
            }
            print(isAddSubscription)
            
            if isAddSubscription {
                var paymentName = PaymentsViewController.paymentDetailDict["key"] as? String ?? ""
                if paymentName != ""{
                    if paymentName.uppercased() != "PAX PAY" && paymentName.uppercased() != "CREDIT" {
                        appDelegate.strPaymentType = ""
                        PaymentsViewController.paymentDetailDict["key"] = ""
                        //  showAlert(message: "Please select Credit payment type because cart having subscription product.")
                        // return
                    }
                    if DataManager.paxTokenizationEnable != "true" && paymentName.uppercased() != "CREDIT"{
                        PaymentsViewController.paymentDetailDict["key"] = ""
                        appDelegate.strPaymentType = ""
                        //showAlert(message: "Please select Credit payment type because cart having subscription product.")
                        // return
                    }
                }
            }
            //
            if let topVC = UIApplication.topViewController() as? SWRevealViewController {
                if let nav = topVC.frontViewController as? UINavigationController {
                    for vc in nav.viewControllers {
                        if vc.isKind(of: PaymentsViewController.self)  || vc.isKind(of: PaymentTypeViewController.self) {
                            //  return
                            // this comment for exchnage retrun true. so that we need to payment controller but second time this contion default true but we need only return false exchange time.
                        }
                    }
                }
            }
            
            if isCreditCardNumberDetected {
                self.paymentType = "CREDIT"
                
                self.performSegue(withIdentifier: "payments", sender: nil)
                return
            }
            
            //            if let dict = UserDefaults.standard.value(forKey: "SelectedCustomer") as? NSDictionary, UI_USER_INTERFACE_IDIOM() == .phone {
            //                let cardDetail = decode(dict: dict as! [String : Any])
            //                if let number = cardDetail.cardNumber , number.count == 4 {
            //                    self.paymentType = "CREDIT"
            //                    self.performSegue(withIdentifier: "payments", sender: nil)
            //                    return
            //                }
            //            }
            
            if self.sectionArray.count == 1 {
                self.paymentType = self.sectionArray[0]
                self.performSegue(withIdentifier: "payments", sender: nil)
                return
            } else if self.sectionArray.count == 2 && (sectionArray.contains("MULTI CARD")){
                if let index = sectionArray.index(of: "MULTI CARD") {
                    if index == 0 {
                        self.paymentType = self.sectionArray[1]
                        self.performSegue(withIdentifier: "payments", sender: nil)
                        return
                     
                    }else{
                        self.paymentType = self.sectionArray[0]
                        self.performSegue(withIdentifier: "payments", sender: nil)
                        return
                      
                    }
                }
            }
            
            if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key != "" {
                self.paymentType = key.uppercased()
                self.performSegue(withIdentifier: "payments", sender: nil)
                return
            }
            
            if appDelegate.IS_DEFAULT_PAYMENT_FUNCTIONLITY {
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
                        
                        //                    switch paymentName {
                        //                    case "CREDIT":
                        //                        creditCardDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "CASH":
                        //                        cashDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "INVOICE":
                        //                        invoiceDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "ACH CHECK":
                        //                        achCheckDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "GIFT CARD":
                        //                        giftCardDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "EXTERNAL GIFT CARD":
                        //                        externalGiftCardDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "INTERNAL GIFT CARD":
                        //                        internalGiftCardDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "CHECK":
                        //                        checkDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "EXTERNAL":
                        //                        externalCardDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "NOTES":
                        //                        notesDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "PAX PAY":
                        //                        paxDelegate?.saveData?()
                        //                        break
                        //
                        //                    case "MULTI CARD":
                        //                        multicardDelegate?.saveData?()
                        //                        break
                        
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
                        
                        if type == "pax_pay" {
                            type = "PAX PAY"
                        }
                        
                        
                        
                        
                        
                        if (id == DataManager.appUserID) && (url == DataManager.loginBaseUrl) {
                            self.paymentType = type!.localizedUppercase
                            //self.performSegue(withIdentifier: "paymenttype", sender: nil)
                            self.performSegue(withIdentifier: "payments", sender: nil)
                            return
                        }
                    }
                }
            }
            
            
            
            self.performSegue(withIdentifier: "paymenttype", sender: nil)
        }
    }
    
    //    private func getNewData(customerList: CustomerListModel) -> CustomerListModel {
    //
    //        let CustomerObjData = UserDefaults.standard.object(forKey: "CustomerObj") as AnyObject
    //
    //        let d = CustomerObjData.value(forKey: "")
    //
    //        let data = customerList
    //        //Shipping
    //        data.str_shipping_first_name = firstNameTextField.text ?? ""
    //        data.str_shipping_last_name = lastNameTextField.text ?? ""
    //        data.str_Shippingemail = emailTextField.text ?? ""
    //        data.str_Shippingphone = phoneTextField.text ?? ""
    //        data.str_Shippingaddress = addressTextField.text ?? ""
    //        data.str_Shippingaddress2 = address2TextField.text ?? ""
    //        data.str_Shippingcity = cityTextField.text ?? ""
    //        data.str_Shippingregion = stateTextField.text ?? ""
    //        data.str_Shippingpostal_code = zipTextField.text ?? ""
    //        data.shippingCountry = countryTextField.text ?? ""
    //        //Billing
    //        data.str_billing_first_name = billingFirstNameTextField.text ?? ""
    //        data.str_billing_last_name = billingLastNameTextField.text ?? ""
    //        data.str_Billingemail = billingEmailTextField.text ?? ""
    //        data.str_Billingphone = billingPhoneTextField.text ?? ""
    //        data.str_Billingaddress = billingAddressTextField.text ?? ""
    //        data.str_Billingaddress2 = billingAddress2TextField.text ?? ""
    //        data.str_Billingcity = billingCityTextField.text ?? ""
    //        data.str_Billingregion = billingStateTextField.text ?? ""
    //        data.str_Billingpostal_code = billingZipTextField.text ?? ""
    //        data.billingCountry = billingCountryTextField.text ?? ""
    //        //First & last Name
    //        data.str_first_name = billingFirstNameTextField.text ?? ""
    //        data.str_last_name = billingLastNameTextField.text ?? ""
    //        data.str_email = billingEmailTextField.text ?? ""
    //        data.str_phone = billingPhoneTextField.text ?? ""
    //        data.str_address = billingAddressTextField.text ?? ""
    //        data.str_address2 = billingAddress2TextField.text ?? ""
    //        data.str_city = billingCityTextField.text ?? ""
    //        data.str_region = billingStateTextField.text ?? ""
    //        data.str_postal_code = billingZipTextField.text ?? ""
    //        data.country = billingCountryTextField.text ?? ""
    //        //
    //        data.userCoupan = customerList.userCoupan
    //        data.userCustomTax = customerList.userCustomTax
    //        data.cardDetail = customerList.cardDetail
    //        data.isDataAdded = customerList.isDataAdded
    //        data.str_bpid = customerList.str_bpid
    //        data.str_display_name = customerList.str_display_name
    //        data.str_order_id = customerList.str_order_id
    //        data.str_userID = customerList.str_userID
    //
    //        return data
    //    }
    
    private func saveAllData() {
        
        //        let CustomerObjData = UserDefaults.standard.object(forKey: "CustomerObj") as AnyObject
        //
        //        CustomerObj = CustomerObjData as! CustomerListModel
        
        if orderType == .newOrder {
            // UserDefaults.standard.removeObject(forKey: "CustomerObj")
            // UserDefaults.standard.synchronize()
            
            //            if HomeVM.shared.DueShared > 0 {
            //                duebalance = TotalPrice
            //                DataManager.duebalanceData = duebalance
            //            }
            
            //Save cart Data
            let cartData = ["tipAmount_due" : HomeVM.shared.tipValue,"MultiTipAmount_due": HomeVM.shared.MultiTipValue,"isDefaultTaxSelected": isDefaultTaxSelected,"isDefaultTaxChanged": isDefaultTaxChanged, "str_AddDiscountPercent":str_AddDiscountPercent, "balance_due":duebalance, "isPercentageDiscountApplied":isPercentageDiscountApplied,"taxType":taxType , "taxTitle":taxTitle, "taxAmountValue":taxAmountValue, "str_ShippingANdHandling":str_ShippingANdHandling,"isShippingPriceChanged": isShippingPriceChanged, "str_AddDiscount":str_AddDiscount, "str_TaxPercentage":str_TaxPercentage, "str_AddCoupon":str_AddCouponName, "str_CouponDiscount":str_CouponDiscount,"str_AddNote":str_AddNote,"isAddNote":isAddNote, "isAddCoupon":isAddCoupon, "isAddDiscount":isAddDiscount, "isShippingHandling":isShippingHandling, "taxableCouponTotal":taxableCouponTotal] as [String : Any]
            //let customerObj = ["country": CustomerObj.country, "billingCountry":CustomerObj.billingCountry,"shippingCountry":CustomerObj.shippingCountry,"coupan": str_AddCouponName, "str_first_name":CustomerObj.str_first_name, "str_last_name":CustomerObj.str_last_name, "str_address":CustomerObj.str_address, "str_bpid":CustomerObj.str_bpid, "str_city":CustomerObj.str_city, "str_order_id":CustomerObj.str_order_id, "str_email":CustomerObj.str_email, "str_userID":CustomerObj.str_userID, "str_phone":CustomerObj.str_phone,"str_region":CustomerObj.str_region, "str_address2":CustomerObj.str_address2, "str_Billingcity":CustomerObj.str_Billingcity, "str_postal_code":CustomerObj.str_postal_code, "str_Billingphone":CustomerObj.str_Billingphone, "str_Billingaddress":CustomerObj.str_Billingaddress, "str_Billingaddress2":CustomerObj.str_Billingaddress2, "str_Billingregion":CustomerObj.str_Billingregion, "str_Billingpostal_code":CustomerObj.str_Billingpostal_code,"shippingPhone": CustomerObj.str_Shippingphone,"shippingAddress" : CustomerObj.str_Shippingaddress, "shippingAddress2": CustomerObj.str_Shippingaddress2, "shippingCity": CustomerObj.str_Shippingcity, "shippingRegion" : CustomerObj.str_Shippingregion, "shippingPostalCode": CustomerObj.str_Shippingpostal_code, "billing_first_name":CustomerObj.str_billing_first_name, "billing_last_name":CustomerObj.str_billing_last_name,"user_custom_tax":CustomerObj.userCustomTax,"shipping_first_name":CustomerObj.str_shipping_first_name, "shipping_last_name":CustomerObj.str_shipping_last_name,"shippingEmail": CustomerObj.str_Shippingemail,"str_Billingemail": CustomerObj.str_Billingemail]
            
            var isDataSave = false
            
            //            for (key, value) in customerObj {
            //                if value != "" && key != "coupan" {
            //                    isDataSave = true
            //                }
            //            }
            
            //            if !isAllDataRemoved {
            DataManager.cartData = cartData
            //            }
            
            //            if isDataSave {
            //                DataManager.customerObj = customerObj
            //            }
        }
    }
    
    private func saveCustomerData() {
        let customerObj = ["country": CustomerObj.country, "billingCountry":CustomerObj.billingCountry,"shippingCountry":CustomerObj.shippingCountry,"coupan": str_AddCouponName, "str_first_name":CustomerObj.str_first_name, "str_last_name":CustomerObj.str_last_name, "str_address":CustomerObj.str_address, "str_bpid":CustomerObj.str_bpid, "str_city":CustomerObj.str_city, "str_order_id":CustomerObj.str_order_id, "str_email":CustomerObj.str_email, "str_userID":CustomerObj.str_userID, "str_phone":CustomerObj.str_phone,"str_region":CustomerObj.str_region, "str_address2":CustomerObj.str_address2, "str_Billingcity":CustomerObj.str_Billingcity, "str_postal_code":CustomerObj.str_postal_code, "str_Billingphone":CustomerObj.str_Billingphone, "str_Billingaddress":CustomerObj.str_Billingaddress, "str_Billingaddress2":CustomerObj.str_Billingaddress2, "str_Billingregion":CustomerObj.str_Billingregion, "str_Billingpostal_code":CustomerObj.str_Billingpostal_code,"shippingPhone": CustomerObj.str_Shippingphone,"str_company": CustomerObj.str_company,"shippingAddress" : CustomerObj.str_Shippingaddress, "shippingAddress2": CustomerObj.str_Shippingaddress2, "shippingCity": CustomerObj.str_Shippingcity, "shippingRegion" : CustomerObj.str_Shippingregion, "shippingPostalCode": CustomerObj.str_Shippingpostal_code, "billing_first_name":CustomerObj.str_billing_first_name, "billing_last_name":CustomerObj.str_billing_last_name,"user_custom_tax":CustomerObj.userCustomTax,"shipping_first_name":CustomerObj.str_shipping_first_name, "shipping_last_name":CustomerObj.str_shipping_last_name,"shippingEmail": CustomerObj.str_Shippingemail,"str_Billingemail": CustomerObj.str_Billingemail, "str_BillingCustom1TextField": CustomerObj.str_CustomText1, "str_BillingCustom2TextField": CustomerObj.str_CustomText2, "loyalty_balance" : CustomerObj.doubleloyalty_balance, "emv_card_count": CustomerObj.emv_card_Count,"office_phone":CustomerObj.str_office_phone,"contact_source": CustomerObj.str_contact_source, "customer_status": CustomerObj.str_customer_status] as [String : Any]
        DataManager.customerObj = customerObj
    }
    
    private func saveCartData() {
        let cartData = ["isDefaultTaxSelected": isDefaultTaxSelected,"isDefaultTaxChanged": isDefaultTaxChanged, "str_AddDiscountPercent":str_AddDiscountPercent, "balance_due": duebalance, "isPercentageDiscountApplied":isPercentageDiscountApplied,"taxType":taxType , "taxTitle":taxTitle, "taxAmountValue":taxAmountValue, "str_ShippingANdHandling":str_ShippingANdHandling,"isShippingPriceChanged": isShippingPriceChanged, "str_AddDiscount":str_AddDiscount, "str_TaxPercentage":str_TaxPercentage, "str_AddCoupon":str_AddCouponName, "str_CouponDiscount":str_CouponDiscount,"str_AddNote":str_AddNote,"isAddNote":isAddNote, "isAddCoupon":isAddCoupon, "isAddDiscount":isAddDiscount, "isShippingHandling":isShippingHandling, "taxableCouponTotal":taxableCouponTotal] as [String : Any]
        DataManager.cartData = cartData
    }
    
    private func handleAddDiscountAction() {
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            
            self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
            
            let strData = self.isPercentageDiscountApplied ? "Percentage Discount" : "Dollar Discount"
            let alert = UIAlertController(title: strData, message: "", preferredStyle: .alert)
            alert.addTextField { (textField) in
                self.discountTextField = textField
                textField.delegate = self
                textField.keyboardType = .decimalPad
                
                //var manualDiscount = 0.0 //Double(self.str_AddDiscount) ?? 0.0
                
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
                self.catAndProductDelegate?.hideView?(with:  "alertblurcancel")
                
            }))
            self.catAndProductDelegate?.hideView?(with:  "alertblur")
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            tf_AddDiscount?.rightView = nil
            tf_AddDiscount?.inputView = nil
            tf_AddDiscount?.inputAccessoryView = nil
            tf_AddDiscount?.keyboardType = .default
            tf_AddDiscount?.reloadInputViews()
            blurView.isHidden = true
            isShippingHandling = false
            isAddCoupon = false
            isAddDiscount = true
            isAddNote = false
            tf_AddDiscount?.keyboardType = UIKeyboardType.decimalPad
            setView(view: viewKeyboardAddDiscount!, hidden: false)
            
            var manualDiscount = Double(str_AddDiscount) ?? 0.0
            
            if self.isPercentageDiscountApplied {
                manualDiscount = manualDiscount / self.SubTotalPrice * 100
                manualDiscount = manualDiscount > 100 ? 100 : manualDiscount
            }
            
            tf_AddDiscount?.text = manualDiscount == 0 ? "" : manualDiscount.roundToTwoDecimal
            tf_AddDiscount?.selectAll(nil)
            
            lbl_ViewKeyboardTitle.text = self.isPercentageDiscountApplied ? "Manual Discount %" : "Manual Discount"
            tf_AddDiscount?.placeholder = self.isPercentageDiscountApplied ? "Please enter discount amount (%)" : "Please enter discount amount"
            tf_AddDiscount?.becomeFirstResponder()
            
            if !isPercentageDiscountApplied {
                tf_AddDiscount?.setDollar(color: UIColor.darkGray, font: tf_AddDiscount!.font!)
            } else {
                tf_AddDiscount?.setDollar(color: UIColor.clear, font: tf_AddDiscount!.font!)
            }
            self.cartViewDelegate?.didHideView(with: "customviewunhide")
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func handleDiscount(textField: UITextField) {
        
        if self.isPercentageDiscountApplied {
            self.str_AddDiscountPercent = (textField.text ?? "").replacingOccurrences(of: "$", with: "")
            //var discount = Double(self.str_AddDiscountPercent) ?? 0.00
        } else {
            self.str_AddDiscount = (textField.text ?? "").replacingOccurrences(of: "$", with: "")
            //var discount = Double(self.str_AddDiscount) ?? 0.00
        }
        
        //var discount = self.isPercentageDiscountApplied ? ()
        
        var discount = self.isPercentageDiscountApplied ? (Double(self.str_AddDiscountPercent) ?? 0.0) : (Double(self.str_AddDiscount) ?? 0.0)
        
        self.catAndProductDelegate?.hideView?(with:  "alertblurdone")
        
        let subTotal = self.SubTotalPrice.currencyFormatA
        let stringToDoublTotal = Double(subTotal) ?? 0.00
        
        if self.isPercentageDiscountApplied {
            discount = (discount / 100) * stringToDoublTotal
            discount = discount < 0 ? 0 : discount
        }
        self.str_AddDiscount = "\(discount)"
        
        if DataManager.isCaptureButton {
            DataManager.OrderDataModel?["str_DiscountPrize"] = "\(discount)"
        }
        
        if !self.isPercentageDiscountApplied {
            discount = (100 * discount) / stringToDoublTotal
            discount = discount < 0 ? 0 : discount
            self.str_AddDiscountPercent = "\(discount)"
        }
        
        
        self.lbl_AddDiscount.text = discount.currencyFormat
        self.calculateTotalCart()
    }
    
    
    private func showApplyCouponIPad() {
        self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
        
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
            self.catAndProductDelegate?.hideView?(with:  "alertblurcancel")
        }))
        self.catAndProductDelegate?.hideView?(with:  "alertblur")
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showApplyCouponIphone() {
        tf_AddDiscount?.rightView = nil
        tf_AddDiscount?.inputView = nil
        tf_AddDiscount?.inputAccessoryView = nil
        tf_AddDiscount?.keyboardType = .asciiCapable
        tf_AddDiscount?.reloadInputViews()
        blurView.isHidden = true
        isShippingHandling = false
        isAddCoupon = true
        isAddDiscount = false
        isAddNote = false
        tf_AddDiscount?.keyboardType = UIKeyboardType.asciiCapable
        tf_AddDiscount?.tintColor = UIColor.blue
        tf_AddDiscount?.text = str_AddCouponName
        tf_AddDiscount?.resignFirstResponder()
        
        if DataManager.isCouponList {
            let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
            let iconView  = UIImageView(frame: CGRect(x: 20, y: 7, width: 10, height: 7))
            iconView.image = UIImage(named: "dropdown-arrow")
            outerView.isUserInteractionEnabled = true
            iconView.isUserInteractionEnabled = true
            outerView.addSubview(iconView)
            tf_AddDiscount?.rightView = outerView
            tf_AddDiscount?.rightViewMode = .always
            
            let array = HomeVM.shared.coupanList.compactMap({$0.str_coupon_code})
            if array.count > 0 {
                self.pickerDelegate = self
                tf_AddDiscount?.text = array.first
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-active"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = true
                self.setPickerView(textField: tf_AddDiscount ?? UITextField(), array: array)
            }
        }
        
        setView(view: viewKeyboardAddDiscount!, hidden: false)
        tf_AddDiscount?.placeholder = "Please enter coupon code"
        tf_AddDiscount?.selectAll(nil)
        tf_AddDiscount?.tag = 10000
        lbl_ViewKeyboardTitle.text = "Apply Coupon"
        crossButton.isHidden = true
        self.cartViewDelegate?.didHideView(with: "customviewunhide")
        self.view.layoutIfNeeded()
    }
    
    private func updateCouponAndCartTotal() {   //First Time only
        //Update Coupan
        if str_AddCouponName != "" {
            //New Coupon Applied
            self.callAPItoGetCoupanProductIds(coupan: str_AddCouponName)
            return
        }
        //Update Coupan
        if CustomerObj.userCoupan != "" {
            str_AddCouponName = CustomerObj.userCoupan
            //New Coupon Applied
            self.callAPItoGetCoupanProductIds(coupan: str_AddCouponName)
            return
        }
        str_AddCouponName = ""
        lbl_AppliedCouponName.text = "Apply Coupon"
        str_CouponDiscount = ""
        taxableCouponTotal = 0.0
        crossButton.isHidden = true
        //Calculate Cart Total
        self.calculateTotalCart()
    }
    
    private func checkCartEmpty() {
        if orderType == .newOrder {
            exchangePaymentMainView.isHidden = true
            AddSubscription.isHidden = true
            if let array = DataManager.cartProductsArray, array.count > 0 {
                emptyCartImageView.isHidden = true
            }else {
                emptyCartImageView.isHidden = false
                self.cartProductsArray.removeAll()
                self.tbl_Cart.reloadData()
            }
        }else {
            if orderInfoObj.showSubscriptionsCancel == true{
                AddSubscription.isHidden = false
            }else{
                AddSubscription.isHidden = true
            }
            exchangePaymentMainView.isHidden = false
            if let array = DataManager.cartProductsArray, array.count > 0 {
                emptyCartImageView.isHidden = true
                exchangePaymentMainView.isHidden = false
            }else {
                emptyCartImageView.isHidden = false
                exchangePaymentMainView.isHidden = true
            }
            self.tbl_Cart.reloadData()
        }
    }
    
    private func handleApplyCouponIphone() {
        tf_AddDiscount?.tag = 0
        tf_AddDiscount?.resignFirstResponder()
        setView(view: viewKeyboardAddDiscount!, hidden: true)
        cartViewDelegate?.didHideView(with: "customviewhide")
        str_AddCouponName = (tf_AddDiscount?.text!)!
        tf_AddDiscount?.text = ""
        
        if (self.str_AddCouponName.count>0)
        {
            //New Coupon Applied
            self.callAPItoGetCoupanProductIds(coupan: str_AddCouponName)
        }else {
            self.resetCoupan()
        }
    }
    
    private func handleApplyCoupon(textField: UITextField) {
        self.catAndProductDelegate?.hideView?(with:  "alertblurdone")
        SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
        self.str_AddCouponName = (textField.text)!
        self.tf_AddDiscount?.text = self.str_AddCouponName
        if (self.str_AddCouponName.count>0)
        {
            //New Coupon Applied
            self.callAPItoGetCoupanProductIds(coupan: self.str_AddCouponName)
        }else {
            self.resetCoupan()
        }
    }
    
    private func handlePax(textField: UITextField) {
        self.catAndProductDelegate?.hideView?(with:  "alertblurdone")
        SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
        //self.str_internalGiftCardNumber = (textField.text)!
        //self.tf_AddDiscount?.text = self.str_AddCouponName
        if self.str_addDeviceName != ""  {
            prepareOrderForExchange()
        }
        if (self.str_addDeviceName.count>0)
        {
            //New Coupon Applied
            //  self.callAPItoGetCoupanProductIds(coupan: self.str_AddCouponName)
        }else {
            //  self.resetCoupan()
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
        //DataManager.shippingValue = shipping
        self.lbl_ShippingAndHandling.text = shipping.currencyFormat
        self.isShippingPriceChanged = true
        self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        self.calculateTotalCart()
    }
    
    private func handleShippingAddRate(shiipingRate: String){
        self.str_ShippingANdHandling = shiipingRate
        self.str_ShippingANdHandling = self.str_ShippingANdHandling.replacingOccurrences(of: "$", with: "")
        let shipping = Double(self.str_ShippingANdHandling) ?? 0.00
        //DataManager.shippingValue = shipping
        self.lbl_ShippingAndHandling.text = shipping.currencyFormat
        self.isShippingPriceChanged = true
        self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        self.calculateTotalCart()
        
    }
    
    
    private func handleQuantity(textField: UITextField) {
        self.isQtyChanged = true
        self.stringChangedQty = (textField.text)!
        
        //let indexPath = IndexPath(item: tag, section: 0)
        //let cellindex = self.tbl_Cart?.cellForRow(at: indexPath) as? CartTableCell
        
        let cartProductsArray = self.cartProductsArray[self.selectedIndex]
        
        let dataQty = (cartProductsArray as AnyObject).value(forKey: "actualproductqty") as? Double ?? 1
        
        if let ob = Double(self.stringChangedQty) , 0 == ob {
//            self.showAlert(message: "Please enter valid quantity")
            appDelegate.showToast(message: "Please enter valid quantity")
            self.stringChangedQty = ""
            self.catAndProductDelegate?.hideView?(with: "alertblurdone")
            return
        }
        
        if let ob = Double(self.stringChangedQty) , dataQty == -ob || dataQty < -ob {
            print("enter value one")
            callQuantity()
        } else {
//            self.showAlert(message: "Please enter available quantity")
            appDelegate.showToast(message: "Please enter available quantity")
            self.stringChangedQty = ""
            self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        }
        
        //        if let ob = Double(self.stringChangedQty) , -ob >= dataQty {
        //            print("enter value two")
        //        }
        //
        //        if  let ob = Double(self.stringChangedQty), ob < 0 || Double(self.stringChangedQty) == 0 {
        //            self.showAlert(message: "Please enter available quantity")
        //            self.stringChangedQty = ""
        //            self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        //            return
        //        }
        //        if (Double(stringChangedQty))! > Double(fabs(stringQty)) || Double(self.stringChangedQty) == 0{
        //            self.showAlert(message: "Please enter available quantity")
        //            self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        //            return
        //        }
        //        callQuantity()
    }
    
    func callQuantity()  {
        if var dict = DataManager.cartProductsArray?[selectedIndex] as? JSONDictionary {
            dict["available_qty_refund"] = -(Double(stringChangedQty)!)
            DataManager.cartProductsArray![selectedIndex] = dict
            delegateEditProduct?.didClickOnDoneButton?()
            delegate?.refreshCart?()
            self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        }
    }
    
    
    
    private func handleIPadEditPrice() {
        self.view.endEditing(true)
        self.catAndProductDelegate?.hideView?(with:  "alertblurcancel")
        CartContainerViewController.isPickerSelected = false
        
        var newData = self.cartProductsArray[self.selectedtag] as! [String: Any]
        
        var value = self.newPrice.replacingOccurrences(of: "$", with: "")
        value = value.replacingOccurrences(of: "X", with: "")
        value = value.replacingOccurrences(of: " ", with: "")
        value = value.replacingOccurrences(of: ",", with: "")
        value = value.replacingOccurrences(of: ".00", with: "")
        
        newData["productprice"] = value
        self.cartProductsArray[self.selectedtag] = newData
        UserDefaults.standard.setValue(self.cartProductsArray, forKey: "cartProductsArray")
        UserDefaults.standard.synchronize()
        self.tbl_Cart.reloadData()
        DispatchQueue.main.async {
            self.calculateTotalCart()
        }
    }
    
    private func updateCustomerData() {
        if let customerObj = DataManager.customerObj {
            CustomerObj.str_userID = customerObj["str_userID"] as? String ?? ""
            CustomerObj.str_bpid = customerObj["str_bpid"] as? String ?? ""
            CustomerObj.userCustomTax = customerObj["user_custom_tax"] as? String ?? ""
            CustomerObj.userCoupan = customerObj["coupan"] as? String ?? ""
            CustomerObj.cardCount = customerObj["card_count"] as? Int ?? 0
            
            
            CustomerObj.str_first_name = customerObj["str_first_name"] as? String ?? ""
            CustomerObj.str_last_name = customerObj["str_last_name"] as? String ?? ""
            CustomerObj.str_email = customerObj["str_email"] as? String ?? ""
            CustomerObj.str_phone = customerObj["str_phone"] as? String ?? ""
            CustomerObj.str_company = customerObj["str_company"] as? String ?? ""
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
            CustomerObj.str_office_phone = customerObj["office_phone"]as? String ?? ""
            CustomerObj.str_contact_source = customerObj["contact_source"]as? String ?? ""
            CustomerObj.str_customer_status = customerObj["customer_status"]as? String ?? ""
            
            CustomerObj.isDataAdded = true
            
            if CustomerObj.str_first_name == "" && CustomerObj.str_last_name == ""  {
                
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    if DataManager.customerObj == nil  || CustomerObj.str_userID == "" {
                        lbl_CustomerName.text = "Add Customer"
                    } else {
                        lbl_CustomerName.text = "Customer #" + CustomerObj.str_userID
                    }
                    //lbl_CustomerName.text = "Customer #" + CustomerObj.str_userID
                    
                    
                } else {
                    
                    if DataManager.customerObj == nil  || CustomerObj.str_userID == "" {
                        lbl_CustomerName.text = "Add Customer"
                    } else {
                        lbl_CustomerName.text = "Customer #" + CustomerObj.str_userID
                    }
                    //lbl_CustomerName.text = "Customer #" + CustomerObj.str_userID
                    
                    
                }
                
            }else{
                lbl_CustomerName.text = CustomerObj.str_first_name + " " + CustomerObj.str_last_name
            }
            icon_AddCustomer.image = #imageLiteral(resourceName: "edit-icon1")
        }
    }
    
    private func updateCartData() {
        
        if let val = DataManager.showShipOrderInPos {
            self.str_showShipOrderInPos = val
        }
        if DataManager.isLoginByPin {
            resetCoupan()
            DataManager.cartData?.removeAll()
            DataManager.isLoginByPin = false
            return
        }
        //self.str_showShipOrderInPos = DataManager.showShipOrderInPos!
        if let cartData = DataManager.cartData {
            str_BalanceDue = cartData["balance_due"] as? Double ?? 0
            str_ShippingANdHandling = cartData["str_ShippingANdHandling"] as? String ?? ""
            isShippingPriceChanged = cartData["isShippingPriceChanged"] as? Bool ?? false
            isDefaultTaxChanged = cartData["isDefaultTaxChanged"] as? Bool ?? false
            isDefaultTaxSelected = cartData["isDefaultTaxSelected"] as? Bool ?? false
            str_AddDiscount = cartData["str_AddDiscount"] as? String ?? ""
            str_AddCouponName = cartData["str_AddCoupon"] as? String ?? ""
            str_CouponDiscount = cartData["str_CouponDiscount"] as? String ?? ""
            taxableCouponTotal = cartData["taxableCouponTotal"] as? Double ?? 0.0
            str_AddNote = cartData["str_AddNote"] as? String ?? ""
            str_TaxPercentage = cartData["str_TaxPercentage"] as? String ?? ""
            taxAmountValue = cartData["taxAmountValue"] as? String ?? ""
            taxTitle = cartData["taxTitle"] as? String ?? ""
            taxType = cartData["taxType"] as? String ?? ""
            isShippingHandling = cartData["isShippingHandling"] as? Bool ?? false
            isAddCoupon = cartData["isAddCoupon"] as? Bool ?? false
            isAddDiscount = cartData["isAddDiscount"] as? Bool ?? false
            isAddNote = cartData["isAddNote"] as? Bool ?? false
            isPercentageDiscountApplied = cartData["isPercentageDiscountApplied"] as? Bool ?? false
            str_AddDiscountPercent = cartData["str_AddDiscountPercent"] as? String ?? ""
            isPercentageDiscountApplied = cartData["isPercentageDiscountApplied"] as? Bool ?? false
            str_ShippingANdHandling = str_ShippingANdHandling.replacingOccurrences(of: "$", with: "")
            str_AddDiscount = str_AddDiscount.replacingOccurrences(of: "$", with: "")
            str_AddDiscountPercent = str_AddDiscountPercent.replacingOccurrences(of: "$", with: "")
            duebalance = cartData["balance_due"] as? Double ?? 0.0
            
            var shipping = Double(str_ShippingANdHandling) ?? 0.00
            
            if shipping == 0.00 {
                shipping = DataManager.shippingValue ?? 0.00
            }
            
            let discount = Double(str_AddDiscount) ?? 0.00
            lbl_ShippingAndHandling.text = shipping.currencyFormat
            lbl_AddDiscount.text = discount.currencyFormat
            str_TaxAmount = taxAmountValue
            self.calculateTotalCart()
        }
    }
    
    private func updateData() {
        self.updateCartData()
        self.updateCustomerData()
        //Update Tax If Available
        if CustomerObj.userCustomTax != "" {
            self.taxTitle = CustomerObj.userCustomTax
            self.lbl_TaxStateName?.text = "Tax (\(CustomerObj.userCustomTax))"
        }
    }
    
    @objc func tapDone() {
        self.view.endEditing(true)
    }
    
    private func customizeUI() {
        self.txfInternalGiftCardNumber.addCancelDoneOnKeyboardWithTarget(self, cancelAction: #selector(tapDone), doneAction: #selector(tapDone), shouldShowPlaceholder: false)
        crossButton.isHidden = true
        tbl_Cart.tableFooterView = UIView()
        txt_Note?.delegate = self
        tf_Tax?.delegate = self
        btn_TfTax?.hideAssistantBar()
        btn_TfTax?.delegate = self
        view_Tax?.isHidden = true
        txt_Note?.isHidden = true
        
        isCheckShippingBilling = false
        icon_btnShipping?.isHidden = false
        tf_AddDiscount?.addLeftSidePadding()
        tf_AddDiscount?.delegate = self
        tf_AddDiscount?.layer.masksToBounds = true
        tf_AddDiscount?.layer.cornerRadius = 2.0
        tf_AddDiscount?.layer.borderWidth = 1.0
        tf_AddDiscount?.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        viewKeyboardAddDiscount?.layer.masksToBounds = true
        viewKeyboardAddDiscount?.layer.cornerRadius = 2.0
        viewKeyboardAddDiscount?.layer.borderWidth = 0.5
        viewKeyboardAddDiscount?.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        
        txt_Note?.layer.masksToBounds = true
        txt_Note?.layer.cornerRadius = 2.0
        txt_Note?.layer.borderWidth = 1.0
        txt_Note?.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        
        tf_Tax?.delegate = self
        tf_Tax?.layer.masksToBounds = true
        tf_Tax?.layer.cornerRadius = 2.0
        tf_Tax?.layer.borderWidth = 1.0
        tf_Tax?.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        
        btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-inactive"), for: .normal)
        btn_ViewKeyboardDone?.isUserInteractionEnabled = false
        
        let padding = 8
        let size = 20
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size))
        let iconView  = UIImageView(frame: CGRect(x: 6, y: 6, width: 18, height: 12))
        iconView.image = UIImage(named: "dropdown-arrow")
        outerView.addSubview(iconView)
        tf_Tax?.rightView = outerView
        tf_Tax?.rightViewMode = .always
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            btn_Pay?.setCornerRadius(cornerRadius: 5.0)
            view_AddCustomer.setCornerRadius(cornerRadius: 5.0)
            tbl_Cart.separatorStyle = .none
        }else {
            btn_Pay?.setCornerRadius(cornerRadius: 0)
            view_AddCustomer.setCornerRadius(cornerRadius: 0)
            tbl_Cart.separatorStyle = .singleLine
        }
        //CheckCartEmpty
        self.checkCartEmpty()
    }
    
    private func updatePaymentMethods() {
        if DataManager.selectedPayment != nil {
            if orderType == .newOrder {
                sectionArray = DataManager.selectedPayment!
            }else {
                sectionArray.removeAll()
                
                for method in DataManager.selectedPayment! {
                    if refundPaymentMethods.contains(method) {
                        sectionArray.append(method)
                    }
                }
            }
        }else{
            sectionArray = ["CREDIT"]
        }
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            var tempArray = [String]()
            
            for method in sectionArray {
                let temp = method.uppercased() == "EXTERNAL GIFT CARD" ? "EXTERNAL_GIFT" : method.uppercased()
                if offlinePaymentArray.contains(temp) {
                    tempArray.append(method)
                }
            }
            sectionArray = tempArray
        }
    }
    
    private func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    
    private func resetCartData(isShowMessage: Bool = true)
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
        
        PaymentsViewController.paymentDetailDict.removeAll()
        self.cartProductsArray.removeAll()
        self.updateDefaultTax()
        // UserDefaults.standard.removeObject(forKey: "RemaingAmt")
        UserDefaults.standard.removeObject(forKey: "recentOrder")
        UserDefaults.standard.removeObject(forKey: "recentOrderID")
        UserDefaults.standard.removeObject(forKey: "isCheckUncheckShippingBilling")
        UserDefaults.standard.removeObject(forKey: "cartdata")
        UserDefaults.standard.removeObject(forKey: "CustomerObj")
        UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
        UserDefaults.standard.removeObject(forKey: "cartProductsArray")
        UserDefaults.standard.synchronize()
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
        DataManager.CardCount = 0
        DataManager.EmvCardCount = 0
        DataManager.IngenicoCardCount = 0
        DataManager.isPaymentBtnAddCustomer = false
        DataManager.selectedFullfillmentId = ""
        DataManager.cartShippingProductsArray?.removeAll()
        DataManager.isshipOrderButton = false
        DataManager.cartData?.removeAll()
        DataManager.isCheckUncheckShippingBilling = true
        DataManager.OrderDataModel = nil
//        DispatchQueue.global(qos: .userInitiated).async {
//            DispatchQueue.main.async {
                DataManager.selectedPaxDeviceName = ""
                DataManager.isUserPaxToken = ""
                DataManager.shippingaddressCount = 0
                DataManager.Bbpid = ""
                DataManager.customerId = ""
                HomeVM.shared.customerUserId = ""
                DataManager.customerForShippingAddressId = ""
                DataManager.shippingValue = 0.0
                DataManager.shippingValueForAddress = 0.0
                DataManager.recentOrderID = nil
                DataManager.recentOrder = JSONDictionary()
                DataManager.isBalanceDueData = false
                HomeVM.shared.amountPaid = 0.0
                HomeVM.shared.tipValue = 0.0
                HomeVM.shared.DueShared = 0.0
                HomeVM.shared.errorTip = 0.0
                appDelegate.amount = 0.0
                DataManager.selectedCarrier = ""
                DataManager.selectedCarrierName = ""
                DataManager.selectedService = ""
                DataManager.selectedServiceName = ""
                DataManager.selectedServiceId = ""
                DataManager.automatic_upsellData.removeAll()
                HomeVM.shared.searchProductsArray.removeAll()
                DataManager.isUPSellProduct = false
                //Reset Cart
                if DataManager.isCaptureButton == true {
                    DataManager.cartProductsArray?.removeAll()
                    DataManager.isCaptureButton = false
                }
//            }
//        }
        str_AddCouponName = ""
        lbl_AppliedCouponName.text = "Apply Coupon"
        isAddCoupon = false
        str_CouponDiscount = ""
        str_AddDiscountPercent = ""
        str_AddDiscount = ""
        isPercentageDiscountApplied = false
        str_ShippingANdHandling = ""
        taxableCouponTotal = 0.0
        crossButton.isHidden = true
        str_TaxAmount = ""
        lbl_TaxStateName?.text = "Tax (Default)"
        str_TaxPercentage = ""
        duebalance = 0.0
        HomeVM.shared.DueShared = 0.0
        DataManager.duebalanceData = 0.0
        HomeVM.shared.coupanDetail.code = ""
        
        self.str_CouponDiscount=""
        self.str_AddDiscount = ""
        self.str_AddCouponName = ""
        self.str_ShippingANdHandling = ""
        CustomerObj = CustomerListModel()
        lbl_CustomerName.text = "Add Customer"
        //lbl_CustomerName.text = "Customer #"
        DataManager.customerId = ""
        HomeVM.shared.customerUserId = ""
        DataManager.Bbpid = ""
        icon_AddCustomer.image = #imageLiteral(resourceName: "add-button-inside-black-circle")
        self.lbl_AddDiscount.text = "$0.00"
        self.lbl_ShippingAndHandling.text = "$0.00"
        self.isShippingPriceChanged = false
        self.isAllDataRemoved = true
        self.calculateTotalCart()
        if UI_USER_INTERFACE_IDIOM() != .pad && orderType == .newOrder && isShowMessage {
//            self.showAlert(title: "Alert", message: "Cart items removed!", otherButtons: nil, cancelTitle: kOkay) { (action) in
                self.setRootViewControllerForIphone()
                appDelegate.showToast(message: "Cart items removed!")
//            }
        }
        
        //        updateLoggedInCustomer()
        //
        //        updateCustomerData()
        //
        //        self.customerDelegate?.didSelectCustomer?(data: CustomerObj)
        //
        shippingRefundButton.isSelected = DataManager.isshipOrderButton
    }
    
    private func updateViewConstraint() {
        viewKeyBoardUpBottomConstraint.constant = heightKeyboard!
        viewKeyboardAddDiscount?.frame = CGRect(x: 0, y:self.view.frame.size.height-heightKeyboard! , width: self.view.frame.size.width, height: (viewKeyboardAddDiscount?.frame.size.height)!)
        cartViewDelegate?.didUpdateView(with: self.view.frame.size.height-heightKeyboard! - 65)
        self.view.addSubview((viewKeyboardAddDiscount)!)
        self.view.layoutIfNeeded()
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
        var isVationOn = false
        var TextDict = JSONDictionary()
        var arrTextAttribute = JSONArray()

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
    
    
    func dataReloadAfterAPI() {
        if self.cartProductsArray.count > 0 {
            tbl_Cart.reloadData()
            if let val = DataManager.showShipOrderInPos {
                self.str_showShipOrderInPos = val
            }
            //self.str_showShipOrderInPos = DataManager.showShipOrderInPos!
            
            if str_showShipOrderInPos == "true" {
                self.shippingRefundButton.isHidden = false
            } else {
                self.shippingRefundButton.isHidden = true
            }
        }
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let data = HomeVM.shared.coupanDetail.totalAmount {
            let valueOne = NSString(string: HomeVM.shared.coupanDetail.totalAmount)
            let couponAmount = valueOne.doubleValue
            
            if SubTotalPrice <= couponAmount {
                str_AddCouponName = ""
            }
        }
        
        
        if segue.identifier == "selectcustomer"
        {
            let scvc = segue.destination as! SelectCustomerViewController
            scvc.str_CustomerId = str_SelectedCustomerID
            scvc.str_AddCustomer = str_AddCustomer
            scvc.selectedUser = self.CustomerObj
            scvc.delegate = self
        }
        
        if segue.identifier == "payments"
        {
            let controller = segue.destination as! PaymentsViewController
            controller.paymentName = self.paymentType
            controller.totalAmount = self.TotalPrice
            controller.CustomerObj = self.CustomerObj
            controller.cartProductsArray = self.cartProductsArray
            controller.str_AddNote = self.str_AddNote
            controller.str_AddDiscount = self.str_AddDiscount
            controller.str_AddCouponName = self.str_AddCouponName
            controller.str_ShippingANdHandling = self.str_ShippingANdHandling
            controller.SubTotalPrice = self.SubTotalPrice
            controller.str_TaxAmount = self.str_TaxAmount
            controller.str_RegionName = self.taxTitle
            controller.isCreditCardNumberDetected = self.isCreditCardNumberDetected
            controller.orderType = self.orderType
            controller.orderInfoObj = self.orderInfoObj
        }
        
        if segue.identifier == "paymenttype"
        {
            let ptvc = segue.destination as! PaymentTypeViewController
            ptvc.CustomerObj = self.CustomerObj
            ptvc.cartProductsArray = self.cartProductsArray
            ptvc.str_AddNote = self.str_AddNote
            ptvc.str_AddDiscount = self.str_AddDiscount
            ptvc.str_AddCouponName = self.str_AddCouponName
            ptvc.str_ShippingANdHandling = self.str_ShippingANdHandling
            ptvc.TotalPrice = self.TotalPrice
            ptvc.SubTotalPrice = self.SubTotalPrice
            ptvc.str_TaxAmount = self.str_TaxAmount
            ptvc.str_RegionName = taxTitle
            ptvc.isCreditCardNumberDetected = isCreditCardNumberDetected
            ptvc.orderType = self.orderType
            ptvc.orderInfoObj = self.orderInfoObj
            ptvc.isOpenToOrderHistory = isOpenToOrderHistory
        }
        //        checkCartEmpty()
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        super.performSegue(withIdentifier: identifier, sender: sender)
        
        if identifier == "paymenttype" {
            if orderType == .newOrder {
                var navStackArray : [UIViewController] = self.navigationController!.viewControllers
                let cartViewController = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                cartViewController.orderType = self.orderType
                navStackArray.insert(cartViewController, at: navStackArray.count - 1)
                self.navigationController!.setViewControllers(navStackArray, animated:false)
            }
        }
        
        if identifier == "payments" {
            var navStackArray : [UIViewController] = self.navigationController!.viewControllers
            
            let cartViewController = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            cartViewController.orderType = self.orderType
            let paymentTypeViewController = self.storyboard?.instantiateViewController(withIdentifier: "PaymentTypeViewController") as! PaymentTypeViewController
            paymentTypeViewController.CustomerObj = self.CustomerObj
            paymentTypeViewController.cartProductsArray = self.cartProductsArray
            paymentTypeViewController.str_AddNote = self.str_AddNote
            paymentTypeViewController.str_AddDiscount = self.str_AddDiscount
            paymentTypeViewController.str_AddCouponName = self.str_AddCouponName
            paymentTypeViewController.str_ShippingANdHandling = self.str_ShippingANdHandling
            paymentTypeViewController.TotalPrice = self.TotalPrice
            paymentTypeViewController.SubTotalPrice = self.SubTotalPrice
            paymentTypeViewController.str_TaxAmount = self.str_TaxAmount
            paymentTypeViewController.str_RegionName = taxTitle
            paymentTypeViewController.isCreditCardNumberDetected = isCreditCardNumberDetected
            paymentTypeViewController.orderType = self.orderType
            paymentTypeViewController.orderInfoObj = self.orderInfoObj
            
            if orderType == .newOrder {
                navStackArray.insert(cartViewController, at: navStackArray.count - 1)
            }
            navStackArray.insert(paymentTypeViewController, at: navStackArray.count - 1)
            self.navigationController!.setViewControllers(navStackArray, animated:false)
        }
        
    }
    
    //Handle Notifications
    @objc func keyboardShown(notification: NSNotification) {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
                let rawFrame = (infoKey as AnyObject).cgRectValue {
                let keyboardFrame = view.convert(rawFrame, from: nil)
                self.heightKeyboard = keyboardFrame.size.height
                
//                let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
//                if #available(iOS 11.0, *) {
//                    let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
//                    let intersection = safeAreaFrame.intersection(keyboardFrameInView)
//
//
//                    let keyboardAnimationDuration = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]
//                    let animationDuration: TimeInterval = (keyboardAnimationDuration as? NSNumber)?.doubleValue ?? 0
//                    let animationCurveRawNSN = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSNumber
//                    let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
//                    let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
//                    print(animationCurve)
//                    print(intersection.height)
//                } else {
//                    // Fallback on earlier versions
//                }
//                if #available(iOS 11.0, *) {
//                    print("Keyboard :- \(view.safeAreaInsets.bottom)")
//                    self.heightKeyboard = keyboardFrame.size.height - view.safeAreaInsets.bottom
//                } else {
//                    // Fallback on earlier versions
//                }

                self.updateViewConstraint()
            }
        }
    }
    
    @objc func RefreshHome(_ notification: NSNotification) {
        //       self.tbl_Cart.reloadData()
        //         self.str_showShipOrderInPos = DataManager.showShipOrderInPos!
        //        if self.str_showShipOrderInPos == "true" {
        //            self.shippingRefundButton.isHidden = false
        //        }else{
        //            self.shippingRefundButton.isHidden = true
        //        }
    }
    
    func callHomeFromCart() {
        // for Prompt Add Customer
        //        if DataManager.isPromptAddCustomer
        //        {
        //            if DataManager.customerObj == nil  || CustomerObj.str_userID == "" {
        //                DataManager.isPaymentBtnAddCustomer = false
        //                if UI_USER_INTERFACE_IDIOM() == .pad
        //                {
        //                    self.catAndProductDelegate?.hideView?(with: "addcustomerBtn_ActionIPAD")
        //                }
        //                else
        //                {
        //                    performSegue(withIdentifier: "selectcustomer", sender: nil)
        //                }
        //            }
        //        }
        self.tbl_Cart.reloadData()
        if let val = DataManager.showShipOrderInPos {
            self.str_showShipOrderInPos = val
        }
        //self.str_showShipOrderInPos = DataManager.showShipOrderInPos!
        
        if versionOb < 4 {
            self.shippingRefundButton.isHidden = true
        } else {
            if self.str_showShipOrderInPos == "true" || self.lbl_ShippingAndHandling.text != "$0.00"{
                if str_showShipOrderInPos == "true" {
                    self.shippingRefundButton.isHidden = false
                }else{
                    self.shippingRefundButton.isHidden = true
                }
                
                if orderType == .refundOrExchangeOrder {
                    self.shippingRefundButton.setTitle("Refund", for: .normal)
                    if DataManager.isshippingRefundOnly {
                        self.shippingRefundButton.isHidden = true
                    }else{
                        self.shippingRefundButton.isHidden = false
                    }
                } else {
                    self.shippingRefundButton.setTitle("Ship Order", for: .normal)
                }
                
            }else{
                self.shippingRefundButton.isHidden = true
            }
        }
    }
    
}
// MARK: - UICollectionViewDelegate protocol
extension CartContainerViewController {
    
    
    func callAPItoGetPayPAXDeviceList() {
        self.selectaMethod = "EMV"
        selectPaymentMethodValue = "EMV"
        HomeVM.shared.getPaxDeviceList(responseCallBack: { (success, message, error) in
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                self.array_PaxDeviceList = HomeVM.shared.paxDeviceList
                
                
                if HomeVM.shared.paxDeviceList.count == 1 {
                    let deviceName = HomeVM.shared.paxDeviceList[0].name
                    self.str_addDeviceName = (deviceName)!
                    self.str_paxUrl = HomeVM.shared.paxDeviceList[0].url
                    if self.str_addDeviceName != "" {
                        self.prepareOrderForExchange()
                        self.catAndProductDelegate?.hideView?(with:  "alertblurdone")
                        SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
                    }
               } else {
                    let alert = UIAlertController(title: "Select PAX Device", message: "", preferredStyle: .alert)
                    alert.addTextField { (textField) in
                        textField.keyboardType = .asciiCapable
                        textField.text = self.str_addDeviceName
                        textField.tag = 6000
                        textField.delegate = self
                        textField.placeholder = "Please Select Device"
                        textField.selectAll(nil)
                        
                        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
                        let iconView  = UIImageView(frame: CGRect(x: 25, y: 7, width: 10, height: 7))
                        iconView.image = UIImage(named: "dropdown-arrow")
                        outerView.isUserInteractionEnabled = true
                        iconView.isUserInteractionEnabled = true
                        outerView.addSubview(iconView)
                        
                        textField.rightView = outerView
                        textField.rightViewMode = .always
                        
                        let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
                        self.str_paxUrl = HomeVM.shared.paxDeviceList[0].url
                        if array.count > 0 {
                            self.pickerDelegate = self
                            textField.text = array.first
                            self.setPickerView(textField: textField, array: array)
                        }
                    }
                    alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
                        let textField = alert!.textFields![0]
                        self.str_addDeviceName = (textField.text)!
                        if self.str_addDeviceName != "" {
                            self.prepareOrderForExchange()
                            self.catAndProductDelegate?.hideView?(with:  "alertblurdone")
                            SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
                        }
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        self.catAndProductDelegate?.hideView?(with:  "alertblurcancel")
                    }))
                    self.catAndProductDelegate?.hideView?(with:  "alertblur")
                    // 4. Present the alert.
                    self.present(alert, animated: true, completion: nil)

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
    
    func internalGiftCardAlertPopUp(){
        selectaMethod = "Internal Gift Card"
        self.selectPaymentMethodValue = "STORE_CREDIT"
        let alert = UIAlertController(title: selectaMethod , message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.keyboardType = .decimalPad
            textField.tag = 7000
            textField.placeholder = "Please enter Gift Card Number"
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.str_internalGiftCardNumber = (textField.text)!
            if self.str_internalGiftCardNumber != "" {
                self.prepareOrderForExchange()
                self.catAndProductDelegate?.hideView?(with:  "alertblurdone")
                SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.catAndProductDelegate?.hideView?(with: "alertblurcancel")
        }))
        //self.catAndProductDelegate?.hideView?(with: "alertblur")
        self.present(alert, animated: true, completion: nil)
    }
    func externalGiftCardAlertPopUp(){
        selectaMethod = "External Gift Card"
        selectPaymentMethodValue = "external_gift_card"
        let alert = UIAlertController(title: selectaMethod , message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.delegate = self
            textField.keyboardType = .decimalPad
            textField.tag = 7000
            textField.placeholder = "Please enter Gift Card Number"
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.str_externalGiftCardNumber = (textField.text)!
            if self.str_externalGiftCardNumber != "" {
                self.prepareOrderForExchange()
                self.catAndProductDelegate?.hideView?(with:  "alertblurdone")
                SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.catAndProductDelegate?.hideView?(with: "alertblurcancel")
        }))
        //self.catAndProductDelegate?.hideView?(with: "alertblur")
        self.present(alert, animated: true, completion: nil)
    }
    func showExchangeRefundAmountOnButton() {
        var totalEditAmount = 0.0
        tranCheckBoxSelected = false
        remainingViewHeight.constant = 0
        exchangePaymentView.constant = collectionViewHeight.constant + 10
        if strSubscriptionValue != "" && strSubscriptionValue != "no_change" {
            if isinternalGift == false {
                exchangePaymentView.constant = collectionViewHeight.constant + 70
            }else{
                exchangePaymentView.constant = collectionViewHeight.constant + 50
            }
        }
        if  orderInfoObj.transactionArray.count > 0 {
            for i in 0..<self.orderInfoObj.transactionArray.count {
                if self.orderInfoObj.transactionArray[i].isSelectedRefund{
                    remainingViewHeight.constant = 40
                    tranCheckBoxSelected = true
                    if strSubscriptionValue == "" || strSubscriptionValue == "no_change" {
                    if orderInfoObj.transactionArray[i].cardType == "Internal Gift Card" {
                        exchangePaymentView.constant = collectionViewHeight.constant + 70
                    }else{
                        exchangePaymentView.constant = collectionViewHeight.constant + 50
                    }
                    }else{
                        if orderInfoObj.transactionArray[i].cardType == "Internal Gift Card" {
                            exchangePaymentView.constant = collectionViewHeight.constant + 100
                        }else{
                            exchangePaymentView.constant = collectionViewHeight.constant + 70
                        }
                    }
                    
                    totalEditAmount = totalEditAmount + self.orderInfoObj.transactionArray[i].availableRefundAmount
                }
            }
        }
        if totalEditAmount > 0 {
            self.btn_Pay?.setTitle("Exchange/Refund" + " $" + totalEditAmount.currencyFormatA , for: .normal)
        }else{
            self.btn_Pay?.setTitle("Exchange/Refund" , for: .normal)
        }
        //  print(totalEditAmount)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderInfoObj.transactionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! AddPaymentCollectionCell
        
        if orderInfoObj.transactionArray.count == 0 {
            return cell
        }
        
        if selectRemaingAmount.count == 0 {
            return cell
        }
        
        
        cell.txfAmount.setDollar()
        cell.txfPaxDevice.setDropDown()
        
        if orderInfoObj.transactionArray[indexPath.row].txnLabel != "" {
            if orderInfoObj.transactionArray[indexPath.row].cardType == "Internal Gift Card" {
                viewInternalGift.isHidden = true
                self.internalViewHeight.constant = 0
                isinternalGift = true
            }
            cell.lblTransactionName.text =  orderInfoObj.transactionArray[indexPath.row].txnLabel
        } else {
            cell.lblTransactionName.text =  orderInfoObj.transactionArray[indexPath.row].cardType
            
            if cell.lblTransactionName.text == "Internal Gift Card" {
                viewInternalGift.isHidden = true
                self.internalViewHeight.constant = 0
                isinternalGift = true
            }
        }
        
        let isSelect = selectRemaingAmount[indexPath.row]
        
        if isSelect {
            cell.txfAmount.backgroundColor = UIColor.white
            cell.txfAmount.isUserInteractionEnabled = true
            cell.btncheckAmount.isSelected = isSelect
            if DataManager.isTipRefundOnly {
                cell.txfAmount.isUserInteractionEnabled = false
            } else {
                cell.txfAmount.isUserInteractionEnabled = true
            }
            
            //let data = orderInfoObj.transactionArray[indexPath.row].availableRefundAmount
            orderInfoObj.transactionArray[indexPath.row].isSelectedRefund = isSelect
            if orderInfoObj.transactionArray[indexPath.row].availableRefundAmount > 0 {
                
                if orderInfoObj.transactionArray[indexPath.row].availableRefundAmount.rounded(toPlaces: 2) == 0.0 {
                    self.lblRefundTotalRemaining.text = "$0.00"
                    //btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                } else {
                    //btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                }
                SetBtnColor()
                cell.txfAmount.text = orderInfoObj.transactionArray[indexPath.row].availableRefundAmount.currencyFormatA
                
            } else {
                let val = self.lblRefundTotalRemaining.text?.replacingOccurrences(of: "$", with: "")
                
                cell.txfAmount.text = val
            }
            
            if cell.lblTransactionName.text == "Internal Gift Card" {
                viewInternalGift.isHidden = false
                self.internalViewHeight.constant = 28
                isinternalGift = false
                
                if lblSelectedOption.text == "No changes" {
                    exchangePaymentView.constant = collectionViewHeight.constant + 70   //i2  //-gc
                } else {
                    exchangePaymentView.constant = collectionViewHeight.constant + 100 //skb //cs+gc-gc
                }
                
                //exchangePaymentView.constant = collectionViewHeight.constant + 100  //gc  //cs+gc
            }
            
        } else {
            orderInfoObj.transactionArray[indexPath.row].isSelectedRefund = isSelect
            cell.txfAmount.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.9137254902, blue: 0.9294117647, alpha: 1)
            cell.txfAmount.isUserInteractionEnabled = false
            cell.txfAmount.text = ""
            cell.btncheckAmount.isSelected = isSelect
            
            if cell.lblTransactionName.text == "Internal Gift Card" {
                viewInternalGift.isHidden = true
                self.internalViewHeight.constant = 0
                isinternalGift = true
                if lblSelectedOption.text == "No changes" {
                    if orderInfoObj.transactionArray[indexPath.row].isSelectedRefund {
                        exchangePaymentView.constant = collectionViewHeight.constant + 50  //i2  //-gc
                    }else{
                        exchangePaymentView.constant = collectionViewHeight.constant + 10
                    }
                      
                } else {
                    if orderInfoObj.transactionArray[indexPath.row].isSelectedRefund {
                        exchangePaymentView.constant = collectionViewHeight.constant + 70 //skb //cs+gc-gc
                    }else{
                        exchangePaymentView.constant = collectionViewHeight.constant + 40
                    }
                }
                
            }
        }
        
        cell.txfAmount.tag = indexPath.row
        cell.txfAmount.addTarget(self, action: #selector(handleAmountTextField(sender:)), for: .editingDidBegin)
        
        
        cell.txfPaxDevice.tag = indexPath.row
        cell.txfPaxDevice.addTarget(self, action: #selector(handleItemsPaxDevice(sender:)), for: .editingDidBegin)
        
        if arrTempPaxDeviceData.count > 0 {
            let  datavv = arrTempPaxDeviceData[indexPath.row] as? NSDictionary
            
            let  name = datavv?.value(forKey: "strName") as! String
            cell.txfPaxDevice.text = "  \(name)"
        }
        
        cell.btncheckAmount.tag = indexPath.row
        //cell.btncheckAmount.isSelected = returnToStock
        cell.btncheckAmount.addTarget(self, action:#selector(btn_AmountCheckAction(sender:)), for: .touchUpInside)
        
        cell.payemntCellView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        SetBtnColor()
        
        showExchangeRefundAmountOnButton()
        
        if orderInfoObj.transactionArray[indexPath.row].cardType == "EMV" {
            let isSelect = selectRemaingAmount[indexPath.row]
            if isSelect {
                if orderInfoObj.transactionArray[indexPath.row].show_pax_device {
                    if HomeVM.shared.paxDeviceList.count > 1{
                        cell.viewEMV.isHidden = false
                    } else {
                        cell.viewEMV.isHidden = true
                    }
                }else{
                    cell.viewEMV.isHidden = true
                }
                
                //return CGSize(width: collectionView.frame.width, height: 100)
            } else {
                cell.viewEMV.isHidden = true
                //return CGSize(width: collectionView.frame.width, height: 45)
            }
        } else {
            cell.viewEMV.isHidden = true
           // return CGSize(width: collectionView.frame.width, height: 45)
        }
      
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        //        if indexPath.item == orderInfoObj.Exchange_Payment_Method_arr.count || orderInfoObj.Exchange_Payment_Method_arr[indexPath.row].label == "Internal Gift Card" {
        //            internalGiftCardAlertPopUp()
        //        }else if orderInfoObj.Exchange_Payment_Method_arr[indexPath.row].label == "External Gift Card" {
        //            externalGiftCardAlertPopUp()
        //        } else if orderInfoObj.Exchange_Payment_Method_arr[indexPath.row].label == "EMV" {
        //            callAPItoGetPayPAXDeviceList()
        //
        //
        //        }else{
        //            selectPaymentMethodValue = orderInfoObj.Exchange_Payment_Method_arr[indexPath.row].value
        //            selectaMethod = orderInfoObj.Exchange_Payment_Method_arr[indexPath.row].label
        //        }
        //        self.btn_Pay?.setTitle("Exchange/Refund" + "(" + (self.selectaMethod) + ")", for: .normal)
        //
        //        selectPaymentMethod = true
        //        collectionPayExchange.reloadData()
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if selectRemaingAmount.count == 0 {
            return CGSize(width: collectionView.frame.width, height: 45)
        } else {
            if orderInfoObj.transactionArray[indexPath.row].cardType == "EMV" {
                let isSelect = selectRemaingAmount[indexPath.row]
                if isSelect {
                    if HomeVM.shared.paxDeviceList.count > 1{
                        return CGSize(width: collectionView.frame.width, height: 85)
                    } else {
                        return CGSize(width: collectionView.frame.width, height: 45)
                    }
                } else {
                    return CGSize(width: collectionView.frame.width, height: 45)
                }
            } else {
                return CGSize(width: collectionView.frame.width, height: 45)
            }
        }
    }
    
    func SetBtnColor() {
        
        if orderType == .refundOrExchangeOrder {
            if self.lblRefundTotalRemaining.text == "$0.00" {
                print("Zerooooo")
                print(TotalPrice)
                if isinternalGift == false {
                    if txfInternalGiftCardNumber.text != "" {
                        btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        btn_Pay?.isUserInteractionEnabled = true
                    } else {
                        btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        btn_Pay?.isUserInteractionEnabled = false
                    }
                } else {
                    btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                    btn_Pay?.isUserInteractionEnabled = true
                }
                
            } else {
                print("Value")
                print(TotalPrice)
                btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                if TotalPrice < 0 {
                    btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    btn_Pay?.isUserInteractionEnabled = false
                } else {
                    btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                    btn_Pay?.isUserInteractionEnabled = true
                }
            }
            
            var isfull = true
            for i in 0..<cartProductsArray.count {
                let cart = cartProductsArray[i]
                let isRefundProduct = (cart as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
                if !isRefundProduct {
                    isfull = false
                }
            }
            
            if isfull {
                let val = self.lblRefundTotalRemaining.text?.replacingOccurrences(of: "$", with: "")
                
                //let valPrice = (val?.toDouble()?.rounded(toPlaces: 2) ?? 0) - (orderInfoObj.transactionArray[indexPath.row].availableRefundAmount.rounded(toPlaces: 2))
                let tt = -TotalPrice
                if tt > val?.toDouble()?.rounded(toPlaces: 2) ?? 0 {
                    
                    if isinternalGift == false {
                        if txfInternalGiftCardNumber.text != "" {
                            btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                            btn_Pay?.isUserInteractionEnabled = true
                        } else {
                            btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                            btn_Pay?.isUserInteractionEnabled = false
                        }
                    } else {
                        btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        btn_Pay?.isUserInteractionEnabled = true
                    }
                    
                   // btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                   // btn_Pay?.isUserInteractionEnabled = true
                    //self.lblRefundTotalRemaining.text = valTotal.currencyFormat
                } else {
                    
                    btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    btn_Pay?.isUserInteractionEnabled = false
                    //self.lblRefundTotalRemaining.text = valPrice.currencyFormat
                }
            }
            
            if shippingRefundButton.isSelected || DataManager.isTipRefundOnly || btnTipSelect.isSelected  {
                if self.lblRefundTotalRemaining.text == "$0.00" {
                    if isinternalGift == false {
                        if txfInternalGiftCardNumber.text != "" {
                            btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                            btn_Pay?.isUserInteractionEnabled = true
                        } else {
                            btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                            btn_Pay?.isUserInteractionEnabled = false
                        }
                    } else {
                        btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        btn_Pay?.isUserInteractionEnabled = true
                    }
                    //btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                    //btn_Pay?.isUserInteractionEnabled = true
                } else {
                    if TotalPrice < 0 {
                        btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                        btn_Pay?.isUserInteractionEnabled = false
                    } else {
                        if isinternalGift == false {
                            if txfInternalGiftCardNumber.text != "" {
                                btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                                btn_Pay?.isUserInteractionEnabled = true
                            } else {
                                btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                                btn_Pay?.isUserInteractionEnabled = false
                            }
                        } else {
                            btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                            btn_Pay?.isUserInteractionEnabled = true
                        }
                        //btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        //btn_Pay?.isUserInteractionEnabled = true
                    }
                    //btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    //btn_Pay?.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    @objc func btn_AmountCheckAction(sender: UIButton)
    {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let cellindex = self.collectionPayExchange?.cellForItem(at: indexPath) as? AddPaymentCollectionCell
        
        
        if !sender.isSelected {
            if self.lblRefundTotalRemaining.text == "$0.00" {
                selectRemaingAmount[sender.tag] = false
            } else {
                selectRemaingAmount[sender.tag] = true
                if self.TotalPrice >= orderInfoObj.transactionArray[indexPath.row].availableRefundAmount {
                    
                    let val = self.lblRefundTotalRemaining.text?.replacingOccurrences(of: "$", with: "")
                    
                    let valPrice = (val?.toDouble()?.rounded(toPlaces: 2) ?? 0) - (orderInfoObj.transactionArray[indexPath.row].availableRefundAmount.rounded(toPlaces: 2))
                    
                    self.lblRefundTotalRemaining.text = valPrice.currencyFormat
                    SetBtnColor()
                    // cellindex?.txfAmount.text =  orderInfoObj.transactionArray[indexPath.row].availableRefundAmount.currencyFormatA
                } else {
                    // cellindex?.txfAmount.text =  orderInfoObj.transactionArray[indexPath.row].availableRefundAmount.currencyFormatA
                    
                    
                    let val = self.lblRefundTotalRemaining.text?.replacingOccurrences(of: "$", with: "")
                    
                    let valPrice = (val?.toDouble()?.rounded(toPlaces: 2) ?? 0) - (orderInfoObj.transactionArray[indexPath.row].availableRefundAmount.rounded(toPlaces: 2))
                    
                    if valPrice < 0 {
                        let value = orderInfoObj.transactionArray[indexPath.row].availableRefundAmount + valPrice
                        //cell.txfAmount.text = value.currencyFormatA
                        orderInfoObj.transactionArray[indexPath.row].availableRefundAmount = value
                        self.lblRefundTotalRemaining.text = "$0.00"
                        SetBtnColor()
                        //btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        
                    } else {
                        if orderInfoObj.transactionArray[indexPath.row].availableRefundAmount == 0.0 {
                            self.lblRefundTotalRemaining.text = "$0.00"
                            SetBtnColor()
                            orderInfoObj.transactionArray[indexPath.row].availableRefundAmount = valPrice
                        } else {
                            //btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                            self.lblRefundTotalRemaining.text = valPrice.currencyFormat
                        }
                    }
                }
            }
            
        } else {
            let valTotal = -(self.TotalPrice)
            
            let val = self.lblRefundTotalRemaining.text?.replacingOccurrences(of: "$", with: "")
            
            let valPrice = (val?.toDouble()?.rounded(toPlaces: 2) ?? 0) + (orderInfoObj.transactionArray[indexPath.row].availableRefundAmount.rounded(toPlaces: 2))
            
            if valPrice > valTotal{
                self.lblRefundTotalRemaining.text = valTotal.currencyFormat
            } else {
                self.lblRefundTotalRemaining.text = valPrice.currencyFormat
            }
            
            if orderInfoObj.transactionArray[indexPath.row].availableRefundAmount.rounded(toPlaces: 2) == 0.0 {
                self.lblRefundTotalRemaining.text = valTotal.currencyFormat
            }
            orderInfoObj.transactionArray[indexPath.row].availableRefundAmount = orderInfoObj.transactionArray[indexPath.row].availableRefundAmountCopy
            
            
            
            //self.lblRefundTotalRemaining.text = valPrice.currencyFormat
            selectRemaingAmount[sender.tag] = false
        }
        SetBtnColor()
        //sender.isSelected = !sender.isSelected
        
        var indexPaths = [IndexPath]()
        indexPaths.append(indexPath)
        
        if let collectionView = collectionPayExchange {
            collectionView.reloadItems(at: indexPaths)
        }
        tbl_Cart.reloadData()
        //collectionPayExchange.reloadData()
    }
    
    @objc func handleAmountTextField(sender: UITextField) {
        if DataManager.isTipRefundOnly {
            return
        }
        selectIndexAmount = sender.tag
        let AmountVal = orderInfoObj.transactionArray[sender.tag].availableRefundAmount.rounded(toPlaces: 2)
        
        RefundAmount = orderInfoObj.transactionArray[sender.tag].availableRefundAmountCopy.rounded(toPlaces: 2)
        
        if RefundAmount == 0.0 {
            let val = self.lblRefundTotalRemaining.text?.replacingOccurrences(of: "$", with: "")
            
            let valData = val?.toDouble()?.rounded(toPlaces: 2) ?? 0
            
            RefundAmount = AmountVal + valData
        } else {
            if self.lblRefundTotalRemaining.text == "$0.00" {
                
                if orderInfoObj.transactionArray[sender.tag].availableRefundAmountCopy > AmountVal {
                    print("enter one")
                    RefundAmount = AmountVal
                } else {
                    print("enter Two")
                }
                
                //RefundAmount = AmountVal
            } else {
                let val = self.lblRefundTotalRemaining.text?.replacingOccurrences(of: "$", with: "")
                let valData = val?.toDouble()?.rounded(toPlaces: 2) ?? 0
                
                if orderInfoObj.transactionArray[sender.tag].availableRefundAmountCopy > AmountVal {
                    print("enter Three")
                    RefundAmount = AmountVal + valData
                } else {
                    print("enter Four")
                }
                
                //RefundAmount = AmountVal + valData
            }
            
        }
        
        let alert = UIAlertController(title: "Amount" , message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            self.QuantityTextField = textField
            textField.delegate = self
            textField.keyboardType = .decimalPad
            textField.tag = 007
            textField.placeholder = "Enter Amount"
            textField.text = String(fabs(AmountVal).currencyFormatA)
            textField.setDollar(color: UIColor.darkGray, font: textField.font!)
            textField.selectAll(nil)
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.handleAmountForIndex(textField: textField)
            self.tbl_Cart.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.catAndProductDelegate?.hideView?(with: "alertblurcancel")
        }))
        self.catAndProductDelegate?.hideView?(with: "alertblur")
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func handleAmountForIndex(textField: UITextField) {
        
        var AmountVal = 0.0
        var Amount = ""
        
        if orderInfoObj.transactionArray[selectIndexAmount].txnLabel != "" {
            
            AmountVal = orderInfoObj.transactionArray[selectIndexAmount].availableRefundAmountCopy
            
            Amount = (textField.text)!
        } else {
            Amount = (textField.text)!
            
            let val = self.lblRefundTotalRemaining.text?.replacingOccurrences(of: "$", with: "")
            
            let valData = val?.toDouble()?.rounded(toPlaces: 2) ?? 0
            
            if let valPrice = Double(Amount) {
                AmountVal = valPrice + valData
            }
        }
        
        
        if let ob = Double(Amount) , 0 == ob {
//            self.showAlert(message: "Please enter valid Amount")
            appDelegate.showToast(message: "Please enter valid Amount")
            self.catAndProductDelegate?.hideView?(with: "alertblurdone")
            return
        }
        
        if let ob = Double(Amount) , AmountVal >= ob {
            print("enter value one")
            let val = self.lblRefundTotalRemaining.text?.replacingOccurrences(of: "$", with: "")
            
            let valData = (val?.toDouble()?.rounded(toPlaces: 2) ?? 0) + orderInfoObj.transactionArray[selectIndexAmount].availableRefundAmount
            
            let valPrice = valData - (ob.rounded(toPlaces: 2))
            
            if valPrice < 0 {
                self.lblRefundTotalRemaining.text = "$0.00"
                //btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            } else {
                // btn_Pay?.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                self.lblRefundTotalRemaining.text = valPrice.currencyFormat
            }
            
            SetBtnColor()
            callAmountValue(strVal: Amount)
        } else {
//            self.showAlert(message: "Please enter available Amount")
            appDelegate.showToast(message: "Please enter available Amount")
            self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        }
        
        //        if let ob = Double(self.stringChangedQty) , -ob >= dataQty {
        //            print("enter value two")
        //        }
        //
        //        if  let ob = Double(self.stringChangedQty), ob < 0 || Double(self.stringChangedQty) == 0 {
        //            self.showAlert(message: "Please enter available quantity")
        //            self.stringChangedQty = ""
        //            self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        //            return
        //        }
        //        if (Double(stringChangedQty))! > Double(fabs(stringQty)) || Double(self.stringChangedQty) == 0{
        //            self.showAlert(message: "Please enter available quantity")
        //            self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        //            return
        //        }
        //        callQuantity()
    }
    
    func callAmountValue(strVal:String)  {
        
        orderInfoObj.transactionArray[selectIndexAmount].availableRefundAmount = (Double(strVal)!)
        //delegateEditProduct?.didClickOnDoneButton?()
        //delegate?.refreshCart?()
        collectionPayExchange.reloadData()
        self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        //        if var dict = DataManager.cartProductsArray?[selectedIndex] as? JSONDictionary {
        //            dict["productqty"] = -(Double(stringChangedQty)!)
        //            DataManager.cartProductsArray![selectedIndex] = dict
        //            delegateEditProduct?.didClickOnDoneButton?()
        //            delegate?.refreshCart?()
        //            self.catAndProductDelegate?.hideView?(with: "alertblurdone")
        //        }
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension CartContainerViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if DataManager.isshippingRefundOnly {
            return 0
        } else {
            return self.cartProductsArray.count
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cartProductsArray = self.cartProductsArray[indexPath.row]
        
        let isRefundProduct = (cartProductsArray as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
        
        if let val = DataManager.showImagesFunctionality {
            self.str_showImagesFunctionality = val
        }
        if let productCode = DataManager.showProductCodeFunctionality {
            self.str_showProductCodeFunctionality = productCode
        }
        
        //self.str_showImagesFunctionality = DataManager.showImagesFunctionality!
        var newString = ""
        var isShowDetails = false
        
        if !isRefundProduct {   //New Product
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartcell", for: indexPath) as! CartTableCell
            
            let qty = Double((cartProductsArray as AnyObject).value(forKey: "productqty") as? String ?? "") ?? 1
            let price = Double((cartProductsArray as AnyObject).value(forKey: "productprice") as? String ?? "") ?? 0
            let isAllowDecimal = (cartProductsArray as AnyObject).value(forKey: "qty_allow_decimal") as? Bool ?? false
            
            cell.productName.text = (cartProductsArray as AnyObject).value(forKey: "producttitle") as? String
            let notesText = (cartProductsArray as AnyObject).value(forKey: "productNotes") as? String ?? ""
                         
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
                        var strPrize = ""
                            
                        let key = value["attributeName"] as? String ?? ""
                            if let data = value["jsonArray"] as? JSONArray {
                                
                                for val in data {
                                    let select = val["isSelect"] as? Bool
                                    if select == true {
                                        name = val["attribute_value"] as? String ?? ""
                                        strPrize = value["surchargePrize"] as? String ?? ""
                                        isShowDetails = select!
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
                                                                 //   newString.append("\(key): \(name)\(surchargVariationValue)\n")
                                    //------ sudama add surcharge variation value start ------//
                                        if i == 1 {
                                            i = i+1
                                            //newString.append("\(key): \(name)\n")
                                            newString.append("\(key): \(name)\(surchargVariationValue)\n")
                                        } else {
                                           // newString.append("\(name)\n")
                                            newString.append("\(name)\(surchargVariationValue)\n")
                                        }
                                        
                                    }
                                }
                            }
                            if tyoe == "text" {
                                name = value["attribute_value"] as? String ?? ""
                                if name != "" {
                                   //newString.append("\(key): \(name)\n")
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
            cell.totalLabel.text = (qty * price).currencyFormat
            cell.priceQtyLabel.text = price.currencyFormat + " X " + (isAllowDecimal ? qty.roundToTwoDecimal : qty.roundOFF)
            
            //cell.btnShowDetails.isHidden = true
            
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
                cell.productCodeLabel.text = ""
                cell.productCodeLabel.isHidden = true
            }
            
           // cell.productCodeLabel.text = code
            cell.productDiscountLabel.text = discount
           // cell.productCodeLabel.isHidden = code == ""
            cell.productDiscountLabel.isHidden = discount == ""
            
            if self.str_showImagesFunctionality == "true" {
                cell.productImageView.isHidden = false
                if str_showProductCodeFunctionality == "true" {
                      cell.proImgWidthConstarint.constant = 50
                     cell.proImgHeightConstarint.constant = 50
                }else{
                    cell.proImgWidthConstarint.constant = 30
                    cell.proImgHeightConstarint.constant = 30
                }
                cell.contentView.layoutIfNeeded()
                cell.contentView.setNeedsLayout()
                cell.contentView.setNeedsDisplay()
                
                let image = UIImage(named: "category-bg")
                cell.productImageView.image = #imageLiteral(resourceName: "m-payment")
                if let url = URL(string: (cartProductsArray as AnyObject).value(forKey: "productimage") as? String ?? "") {
                    cell.productImageView.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
                }else {
                    if  let data = (cartProductsArray as AnyObject).value(forKey: "productimagedata") as? Data {
                        cell.productImageView?.image = UIImage(data: data)
                    }
                }
                
            }else{
                cell.productImageView.isHidden = true
                cell.proImgWidthConstarint.constant = 0
                cell.proImgHeightConstarint.constant = 0
                cell.contentView.layoutIfNeeded()
                cell.contentView.setNeedsLayout()
                cell.contentView.setNeedsDisplay()
            }
            
            
            cell.crossButton.tag = indexPath.row
            cell.crossButton.addTarget(self, action:#selector(btn_DeleteAction(sender:)), for: .touchUpInside)
            
           // cell.btnShowDetails.tag = indexPath.row
        //    cell.btnShowDetails.addTarget(self, action:#selector(btn_ShowDetailsAction(sender:)), for: .touchUpInside)
            
            cell.contentView.backgroundColor = UI_USER_INTERFACE_IDIOM() == .phone ? UIColor.white : UIColor.clear
            
            if UI_USER_INTERFACE_IDIOM() == .phone {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            }
            return cell
            
        }
        
        //Refund or Exchange
        let cell = tableView.dequeueReusableCell(withIdentifier: "refundcell", for: indexPath) as! CartTableCell
        
        let qty = (cartProductsArray as AnyObject).value(forKey: "available_qty_refund") as? Double ?? 1
        let price = (cartProductsArray as AnyObject).value(forKey: "productprice") as? Double ?? 0
        let isAllowDecimal = (cartProductsArray as AnyObject).value(forKey: "qty_allow_decimal") as? Bool ?? false
        
        cell.priceQtyLabel.tag = indexPath.row
        cell.totalLabel.tag = indexPath.row
        cell.productName.text = (cartProductsArray as AnyObject).value(forKey: "producttitle") as? String
        //cell.attributeLabel.text = ""//(cartProductsArray as AnyObject).value(forKey: "attributeString") as? String
        cell.totalLabel.text = (qty * price).currencyFormat
        
        stringQty = (cartProductsArray as AnyObject).value(forKey: "productqty") as? Double ?? 1
        StringShowQty = (cartProductsArray as AnyObject).value(forKey: "productqty") as? Double ?? 1
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.actionTapQuantity))
        cell.priceQtyLabel?.isUserInteractionEnabled = true
        cell.priceQtyLabel?.addGestureRecognizer(tapGestureRecognizer)
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
            cell.stackViewLeading1.constant = 18
            cell.stackViewLeading2.constant = 18
            cell.stackViewLeading3.constant = 18
            cell.stackViewLeading4.constant = 18
            cell.proImgHeightConstarint.constant = 0
            cell.proImgWidthConstarint.constant = 0
            cell.productImageView.isHidden = true
            cell.contentView.layoutIfNeeded()
            cell.contentView.setNeedsLayout()
            cell.contentView.setNeedsDisplay()
        }
        
        let returnToStock = (cartProductsArray as AnyObject).value(forKey: "returnToStock") as? Bool ?? false
        
        //if UI_USER_INTERFACE_IDIOM() == .pad {
        ///cell.returnToStockButtoniPhone.isHidden = true
        cell.returnToStockButton.tag = indexPath.row
        cell.returnToStockButton.isSelected = returnToStock
        
        cell.returnToStockButton.addTarget(self, action:#selector(btn_ReturnToStockAction(sender:)), for: .touchUpInside)
        cell.btn_DeleteProduct.tag = indexPath.row
        cell.btn_DeleteProduct.addTarget(self, action:#selector(btn_DeleteAction(sender:)), for: .touchUpInside)
        if let data = HomeVM.shared.cartCalculationDetail.amount_available_for_refund {
            print(data)
            let valPrice = -(self.TotalPrice)
            if self.lblRefundTotalRemaining.text == "$0.00" {
                cell.returnToStockButton.isHidden = false
                if cell.returnToStockButton.isSelected{
                    cell.tfSelectCondition.isHidden = false
                }else{
                    cell.tfSelectCondition.isHidden = true
                }
            } else {
                if self.lblRefundTotalRemaining.text == valPrice.currencyFormat {
                    cell.returnToStockButton.isHidden = false
                    if cell.returnToStockButton.isSelected{
                        cell.tfSelectCondition.isHidden = false
                    }else{
                        cell.tfSelectCondition.isHidden = true
                    }
                } else {
                    let val = self.lblRefundTotalRemaining.text?.replacingOccurrences(of: "$", with: "")
                    let valDouble = Double(val ?? "0")
                    if valDouble ?? 0 > -(self.TotalPrice) {
                        cell.returnToStockButton.isHidden = false
                        if cell.returnToStockButton.isSelected{
                            cell.tfSelectCondition.isHidden = false
                        }else{
                            cell.tfSelectCondition.isHidden = true
                        }
                    }else{
                        cell.returnToStockButton.isHidden = true
                        cell.tfSelectCondition.isHidden = true
                    }
                }
            }
        }
//        cell.returnToStockButton.isHidden = false
//        if cell.returnToStockButton.isSelected{
//            cell.tfSelectCondition.isHidden = false
//        }else{
//            cell.tfSelectCondition.isHidden = true
//        }
//        cell.returnToStockButton.isHidden = false
//        if cell.returnToStockButton.isSelected{
//            cell.tfSelectCondition.isHidden = false
//        }else{
//            cell.tfSelectCondition.isHidden = true
//        }
        
        //}else {
        //cell.returnToStockButton.isHidden = true
        //cell.returnToStockButtoniPhone.tag = indexPath.row
        //cell.returnToStockButtoniPhone.backgroundColor = returnToStock ? UIColor.HieCORColor.blue.colorWith(alpha: 1.0) : UIColor.white
        //cell.returnToStockButtoniPhone.setTitleColor(!returnToStock ? UIColor.HieCORColor.blue.colorWith(alpha: 1.0) : UIColor.white, for: .normal)
        //cell.returnToStockButtoniPhone.addTarget(self, action:#selector(btn_ReturnToStockAction(sender:)), for: .touchUpInside)
        //}
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
//        var variationText = orderInfoObj.productsArray[indexPath.row ].metaFeildsStringValue.replacingOccurrences(of: ",", with: "\n") + "\n" + orderInfoObj.productsArray[indexPath.row].attribute.replacingOccurrences(of: ",", with: "\n")
        if variationText != "" {
            cell.showAttributeLabel.text = variationText
            cell.showAttributeLabel.isHidden = false
        }else{
            cell.showAttributeLabel.isHidden = true
        }
//
//        cell.btnShowDetails.tag = indexPath.row
//        cell.btnShowDetails.addTarget(self, action:#selector(btn_ShowDetailsAction(sender:)), for: .touchUpInside)
      //  cell.showAttributeLabel.text = newString
        cell.tfSelectCondition.tag = indexPath.row
        cell.tfSelectCondition.setPaddingleft()
        cell.tfSelectCondition.setDropDown()
        cell.tfSelectCondition.addTarget(self, action: #selector(handleItemsTextField(sender:)), for: .editingDidBegin)
        
        let ob = strStatusItem[indexPath.row] as? String
        
        if  ob  == "Select Condition"  {
            cell.tfSelectCondition.text = array_ItemList[0] as? String
        }else if ob  == "New/Unopened"  {
            cell.tfSelectCondition.text = array_ItemList[1] as? String
        }else if ob  == "New/Open Box"  {
            cell.tfSelectCondition.text = array_ItemList[2] as? String
        }else if ob  == "Used"  {
            cell.tfSelectCondition.text = array_ItemList[3] as? String
        }else if ob  == "Damaged"  {
            cell.tfSelectCondition.text = array_ItemList[4] as? String
        }
        
        if !cell.returnToStockButton.isSelected{
            strStatusItem[indexPath.row] = ob
            for product in orderInfoObj.productsArray {
                showItems.removeAll()
                strStatusItem[indexPath.row] = "Select Condition"
            }
        }
        
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        if isOpenToOrderHistory{
            return
        }
        DataManager.isEditProductForUpsell = true
        let cartProductsArray = self.cartProductsArray[indexPath.row]
        let isRefundProduct = (cartProductsArray as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
        
        if !isRefundProduct {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                self.catAndProductDelegate?.didEditProduct?(index: indexPath.row)
            }else {
                self.editProductDelegate?.didEditProduct?(index: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
//                        if tyoe == "text" {
//                            name = value["attribute_value"] as? String ?? ""
//                            if name != "" {
//                                newString.append("\(key): \(name)\n")
//                            }
//                        }
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
        return newString
    }
    
    @objc func handleItemsTextField(sender: UITextField) {
        self.pickerDelegate = self
        isCheckItem = true
        indexItem = sender.tag
        indexPathItem = NSIndexPath(row: indexItem, section: 0)
        showItems.removeAll()
        self.setPickerView(textField: sender, array: array_ItemList as! [String])
    }
    
    @objc func handleItemsPaxDevice(sender : UITextField) {
        isDeviceSelected = true
        indexPaxItem = sender.tag
        if HomeVM.shared.paxDeviceList.count > 0 {
            
            self.arrPaxDeviceData.removeAllObjects()
            
            for i in 0..<HomeVM.shared.paxDeviceList.count {
                var list = [String:String]()
                list["strUrl"] = HomeVM.shared.paxDeviceList[i].url
                list["strPort"] = HomeVM.shared.paxDeviceList[i].port
                list["strName"] = HomeVM.shared.paxDeviceList[i].name
                list["strIndex"] = "0"
                self.arrPaxDeviceData.add(list)
            }
            print(self.arrPaxDeviceData)
            let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
            //tf_SelectDevice.text = HomeVM.shared.paxDeviceList[0].name
            //url = HomeVM.shared.paxDeviceList[0].url
            if array.count == 1 {
                //self.tf_SelectDevice.resignFirstResponder()
                return
            }
            self.pickerDelegate = self
            self.setPickerView(textField: sender, array: array)
        }else {
            //tf_SelectDevice.resignFirstResponder()
            self.callAPItoGetPAXDeviceList()
        }
    }

    //    @objc func handleAmountTextField(sender: UITextField) {
    //        //        self.pickerDelegate = self
    //        //        isCheckItem = true
    //        //        indexItem = sender.tag
    //        //        indexPathItem = NSIndexPath(row: indexItem, section: 0)
    //        //        showItems.removeAll()
    //        //        self.setPickerView(textField: sender, array: array_ItemList as! [String])
    //    }
    
    
    @objc func btn_DeleteAction(sender: UIButton)
    {
        if isOpenToOrderHistory{
            return
        }
        cartProductsArray.remove(at: sender.tag)
        DataManager.cartProductsArray = cartProductsArray
        if cartProductsArray.count == 0 {
            if CustomerObj.userCoupan == "" {
                isCoupanApplyOnAllProducts = false
                DataManager.shippingWeight = 0
                DataManager.shippingWidth = 0
                DataManager.shippingLength = 0
                DataManager.shippingHeight = 0
                DataManager.cartShippingProductsArray?.removeAll()
                DataManager.selectedFullfillmentId = ""
                DataManager.cartData = nil
                str_AddCouponName = ""
                lbl_AppliedCouponName.text = "Apply Coupon"
                isAddCoupon = false
                str_CouponDiscount = ""
                str_AddDiscountPercent = ""
                str_AddDiscount = ""
                isPercentageDiscountApplied = false
                str_ShippingANdHandling = ""
                taxableCouponTotal = 0.0
                crossButton.isHidden = true
                taxTitle = ""
                str_TaxAmount = ""
                lbl_TaxStateName?.text = "Tax (Default)"
                str_TaxPercentage = ""
                DataManager.defaultTaxID = ""
                duebalance = 0.0
                lbl_Tax.text = 0.currencyFormat
                lbl_SubTotal?.text = 0.currencyFormat
                totalLabel.text = 0.currencyFormat
            }
        }
        calculateTotalCart()
        tbl_Cart.reloadData()
        if DataManager.cartProductsArray?.count == 0 && UI_USER_INTERFACE_IDIOM() == .phone {
//            self.showAlert(title: "Alert", message: "Cart items removed!", otherButtons: nil, cancelTitle: kOkay) { (action) in
            if orderType == .newOrder {
                self.navigationController?.popToRootViewController(animated: true)
                appDelegate.showToast(message: "Cart items removed!")
            }
//            }
        }
    }
    
    @objc func btn_ShowDetailsAction(sender: UIButton)
    {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            print("enter Btn Click")
            self.showDetailsDelegateOne?.didShowDetailsAtrribute?(index: sender.tag, cartArray: [cartProductsArray[sender.tag] as AnyObject])
        }else {
            
            self.showDetailsDelegateOne?.didShowDetailsAtrribute?(index: sender.tag, cartArray: [cartProductsArray[sender.tag] as AnyObject])
            //            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            //            let controller = storyboard.instantiateViewController(withIdentifier: "ShowDetailsVC") as! ShowDetailsVC
            //            self.navigationController?.pushViewController(controller, animated: false)
        }
        
    }
    
    @objc func btn_ReturnToStockAction(sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        if var dict = self.cartProductsArray[sender.tag] as? JSONDictionary {
            dict["returnToStock"] = sender.isSelected
            self.cartProductsArray[sender.tag] = dict as AnyObject
        }
        
        DataManager.cartProductsArray = self.cartProductsArray
        tbl_Cart.reloadData()
    }
    
    
}

//MARK: UITextFieldDelegate
extension CartContainerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            //Handle Data
            switch textField.tag {
            case 1000:
                self.handleIPadEditPrice()
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
            case 6000:
                self.handlePax(textField: textField)
                break
            default: break
            }
            //Remove Alerts
            switch textField.tag {
            case 1000,2000,3000,5000,6000:
                SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
                break
            default: break
            }
            
        }else {
            if textField.tag == 10000 && isAddCoupon {
                self.handleApplyCouponIphone()
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        
        if Keyboard._isExternalKeyboardAttached() && UI_USER_INTERFACE_IDIOM() == . phone {
            self.heightKeyboard = 0
            self.updateViewConstraint()
        }
        
        if textField == searchTextField {
            if DataManager.isshippingRefundOnly || DataManager.isTipRefundOnly {
                return
            }
            textField.resignFirstResponder()
            self.view.endEditing(true)
            self.cartViewDelegate?.didTapOnSearchbar()
            return
        }
        
        if isCheckItem {
            textField.selectAll(nil)
            return
        }
        
        switch textField.tag {
        case 1000,2000,3000,4000,5000,007,2001:
            textField.selectAll(nil)
            break
        default: break
        }
        
        if textField.tag == 3 {
            textField.resignFirstResponder()
            
            self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
            
            let alert = UIAlertController(title: "Edit Price", message: "", preferredStyle: .alert)
            alert.addTextField { (txtfield) in
                var value = textField.text?.replacingOccurrences(of: "$", with: "")
                value = value?.replacingOccurrences(of: "X", with: "")
                value = value?.replacingOccurrences(of: " ", with: "")
                value = value?.replacingOccurrences(of: ",", with: "")
                value = value?.replacingOccurrences(of: ".00", with: "")
                self.oldPrice = value ?? "0.00"
                self.newPrice = value ?? "0.00"
                txtfield.text = value
                txtfield.tag = 1000
                txtfield.keyboardType = .decimalPad
                self.selectedtag = textField.superview?.tag ?? 0
                txtfield.delegate = self
                txtfield.selectAll(nil)
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (success) in
                self.view.endEditing(true)
                self.catAndProductDelegate?.hideView?(with:  "alertblurcancel")
                CartContainerViewController.isPickerSelected = false
                
                var newData = self.cartProductsArray[self.selectedtag] as! [String: Any]
                newData["productprice"] = self.oldPrice
                self.cartProductsArray[self.selectedtag] = newData
                UserDefaults.standard.setValue(self.cartProductsArray, forKey: "cartProductsArray")
                UserDefaults.standard.synchronize()
                self.tbl_Cart.reloadData()
                DispatchQueue.main.async {
                    self.calculateTotalCart()
                }
            }))
            alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { (success) in
                self.handleIPadEditPrice()
            }))
            self.catAndProductDelegate?.hideView?(with:  "alertblur")
            self.present(alert, animated: true, completion: nil)
        }
        
        if textField == btn_TfTax
        {
            textField.tintColor = UIColor.clear
            tf_Tax?.resignFirstResponder()
            _ = DataManager.isTaxOn ? nil : btn_TfTax?.resignFirstResponder()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        
        if Keyboard._isExternalKeyboardAttached() && UI_USER_INTERFACE_IDIOM() == . phone && textField ==  tf_AddDiscount {
            self.heightKeyboard = 0
            self.updateViewConstraint()
            self.handleTickButtonActionForIPhone()
        }
        
        if textField ==  tf_AddDiscount
        {
            self.viewKeyboardAddDiscount?.isHidden = true
            self.cartViewDelegate?.didHideView(with: "customviewhide")
        }
        SetBtnColor()
        //Check For External Accessory
        DispatchQueue.main.async {
            if Keyboard._isExternalKeyboardAttached() {
                self.view.endEditing(true)
                SwipeAndSearchVC.shared.enableTextField()
                return
            }
        }
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
        
        if textField.tag == 2000 {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 15
        }
        
        if textField.tag == 007 {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            
            let amount = Double(text) ?? 0.0
            
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= RefundAmount
        }
        
        if textField.tag == 5000 {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            
            let qty = Double(text) ?? 0.0
            
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 15 && qty <= stockInt
        }
        
        if textField.tag == 3000 {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let value = Double(replacementText.replacingOccurrences(of: "$", with: "")) ?? 0
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 15 && (self.isPercentageDiscountApplied ? value <= 100 : value <= SubTotalPrice)
        }
        
        if textField.tag == 7000 || textField == txfInternalGiftCardNumber || textField.tag == 2001{
            
            var replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            
            if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
                return false
            }
            
            if string == " " {
                return false
            }
            if string == "-" {
                return false
            }
            
            if string == "\t" {
                return false
            }
            
            let charactersCount = replacementText.utf16.count + (string.utf16).count - range.length
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            return string == filtered
            
            //replacementText = replacementText.replacingOccurrences(of: "$", with: "")
            //return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
        
        //        if textField.tag == 1000 || textField == self.discountTextField || textField == self.shippingTextField {
        //            if textField.tag == 1000 {
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        //                    self.newPrice = textField.text ?? "0.00"
        //                }
        //            }
        //
        //            let currentText = textField.text ?? ""
        //            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        //            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 15
        //        }
        
        
        
        if textField == txfInternalGiftCardNumber {
            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            //callValidateToChangeColor()
            return string == filtered
        }
        
        //        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
        //            return false
        //        }
        
        
        //        if textField == txfInternalGiftCardNumber {
        //            if string == " " {
        //                return false
        //            }
        //            replacementText = replacementText.replacingOccurrences(of: "$", with: "")
        //            return replacementText.isValidDecimal(maximumFractionDigits: 0)
        //        }
        var startingLength = Int()
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        var newLength = Int()
        
        if (isAddCoupon)
        {
            startingLength = tf_AddDiscount?.text?.count ?? 0
            newLength = startingLength + lengthToAdd - lengthToReplace
            if (newLength > 0)
            {
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-active"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = true
            }
            else
            {
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-inactive"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = false
            }
        }
        else if (isShippingHandling)
        {
            startingLength = tf_AddDiscount?.text?.count ?? 0
            newLength = startingLength + lengthToAdd - lengthToReplace
            if (newLength > 0)
            {
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-active"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = true
            }
            else
            {
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-inactive"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = false
            }
            if textField == tf_AddDiscount {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 15
            }
        }
        else if (isAddDiscount)
        {
            startingLength = tf_AddDiscount?.text?.count ?? 0
            newLength = startingLength + lengthToAdd - lengthToReplace
            if (newLength > 0)
            {
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-active"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = true
            }
            else
            {
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-inactive"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = false
            }
            
            if textField == tf_AddDiscount {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                let value = Double(replacementText.replacingOccurrences(of: "$", with: "")) ?? 0
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 15 && (self.isPercentageDiscountApplied ? value <= 100 : value <= SubTotalPrice)
            }
        }
        else
        {
            startingLength = tf_AddDiscount?.text?.count ?? 0
            newLength = startingLength + lengthToAdd - lengthToReplace
            if (newLength > 0)
            {
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-active"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = true
            }
            else
            {
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-inactive"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = false
            }
            if textField == tf_AddDiscount {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 15
            }
        }
        return true
    }
}

//MARK: UITextViewDelegate
extension CartContainerViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        //Enable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textView.resignFirstResponder()
            //Inilialize SearchProductVC
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if range.location == 0 && text == " " {
            return false
        }
        
        let length = textView.text.count + (text.count - range.length)
        if (isAddNote)
        {
            if (length > 0)
            {
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-active"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = true
            }
            else
            {
                btn_ViewKeyboardDone?.setImage(UIImage(named: "tick-inactive"), for: .normal)
                btn_ViewKeyboardDone?.isUserInteractionEnabled = false
            }
        }
        return true
    }
}

//MARK: SelectedCutomerDelegate
extension CartContainerViewController: SelectedCutomerDelegate {
    func selectedCustomerData(customerdata: CustomerListModel)
    {
        if UI_USER_INTERFACE_IDIOM() == .pad && isAddNewButtonSelected {
            isAddNewButtonSelected = false
            return
        }
        
        CustomerObj = customerdata
        //        saveCustomerData()
        if DataManager.customerObj != nil {
            if customerdata.str_first_name == "" && customerdata.str_last_name == "" {
                lbl_CustomerName.text = "Customer #" + customerdata.str_userID
            }else{
                lbl_CustomerName.text = customerdata.str_first_name + " " + customerdata.str_last_name
            }
            icon_AddCustomer.image = #imageLiteral(resourceName: "edit-icon1")
        }
        
        str_AddCustomer = customerdata.str_display_name
        str_SelectedCustomerID = customerdata.str_userID
        
        //Update Coupon If Available
        if CustomerObj.userCoupan != "" {
            if str_AddCouponName != CustomerObj.userCoupan {
                str_AddCouponName = CustomerObj.userCoupan
                //New Coupon Applied
                self.callAPItoGetCoupanProductIds(coupan: str_AddCouponName)
            }
        } else {
            if str_AddCouponName == "" {
                str_AddCouponName = ""
                self.resetCoupan()
            }
        }
        //Update Tax If Availablefdd
        if customerdata.userCustomTax != "" {
            self.isDefaultTaxChanged = false
            self.isDefaultTaxSelected = false
            self.lbl_TaxStateName?.text = "Tax (\(customerdata.userCustomTax))"
        }
        
        self.calculateTotalCart()
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if CustomerObj.str_customerTags == ""{
               // self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
            }
            
        }else {
            if customerdata.user_has_open_invoice == "true" {
                print("true")
                self.dismiss(animated: true, completion: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController2 = storyboard.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
                    self.navigationController?.pushViewController(viewController2, animated: true)
               // }
            }
        }
    }
}

//MARK: Caculate Cart Total
extension CartContainerViewController {
    func calculateTotalCart(){
        self.checkCartEmpty()
        
        if let array = DataManager.cartProductsArray {
            isAllDataRemoved = false
            cartProductsArray = array
        }
        
        if orderType == .newOrder {
            
            if DataManager.customerObj == nil && !isDefaultTaxChanged {
                updateDefaultTax()
            }
            
            if DataManager.customerObj != nil && !isDefaultTaxChanged {
                //Update User Custom Tax
                if !(lbl_TaxStateName?.text?.contains("Default"))! {
                    if let userCustomTax = DataManager.customerObj?["user_custom_tax"] as? String {
                        if let index = array_TaxList.index(where: {$0.tax_title == userCustomTax}) {
                            taxType = array_TaxList[index].tax_type
                            taxTitle = array_TaxList[index].tax_title
                            taxAmountValue = array_TaxList[index].tax_amount
                            DataManager.defaultTaxID = array_TaxList[index].tax_title
                        }
                    }
                }
                
                if (lbl_TaxStateName?.text?.contains("Default"))! {
                    updateCustomerTax()
                }
            }
        }else {
            if !isDefaultTaxChanged {
                // updateDefaultTax()
            }
        }
        
        self.calculateTotal()
    }
    
    func updateDefaultTax() {
        if let userObject = UserDefaults.standard.value(forKey: "userdata") as? NSData {
            let userdata = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data)
            
            if orderType == .refundOrExchangeOrder {
                //taxType = orderInfoObj
                taxTitle = orderInfoObj.customTax
                taxAmountValue = "\(orderInfoObj.tax)"
                DataManager.defaultTaxID = orderInfoObj.customTax
//                DataManager.cartData?.removeAll()
                return
            }
            
            if appDelegate.isPinlogin {
                appDelegate.isPinlogin = false
            } else {
                if self.taxTitle == "Default" || taxTitle == "countrywide" {
                    if let index = array_TaxList.index(where: {$0.tax_title == "countrywide"}) {
                        taxType = array_TaxList[index].tax_type
                        taxTitle = "Default"
                        taxAmountValue = array_TaxList[index].tax_amount
                        DataManager.defaultTaxID = array_TaxList[index].tax_title
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
                if let index = array_TaxList.index(where: {$0.tax_title == id}) {
                    taxType = array_TaxList[index].tax_type
                    taxTitle = array_TaxList[index].tax_title
                    taxAmountValue = array_TaxList[index].tax_amount
                    DataManager.defaultTaxID = array_TaxList[index].tax_title
                    return
                }
            }
            
            if let region = (userdata as AnyObject).value(forKey: "region") as? String {
                if let index = array_TaxList.index(where: {$0.tax_title == region}) {
                    taxType = array_TaxList[index].tax_type
                    taxTitle = "Default"
                    taxAmountValue = array_TaxList[index].tax_amount
                    DataManager.defaultTaxID = array_TaxList[index].tax_title
                    return
                }
            }
            
            if let city = (userdata as AnyObject).value(forKey: "city") as? String {
                if let index = array_TaxList.index(where: {$0.tax_title == city}) {
                    taxType = array_TaxList[index].tax_type
                    taxTitle = "Default"
                    taxAmountValue = array_TaxList[index].tax_amount
                    DataManager.defaultTaxID = array_TaxList[index].tax_title
                    return
                }
            }
            
            if let cartData = DataManager.cartData {
                taxAmountValue = cartData["taxAmountValue"] as? String ?? "0"
                taxTitle = cartData["taxTitle"] as? String ?? "Default"
                taxType = cartData["taxType"] as? String ?? "Fixed"
                DataManager.defaultTaxID = taxTitle
                return
            }
            
            taxType = "Fixed"
            taxTitle = "Default"
            taxAmountValue = "0"
            DataManager.defaultTaxID = "Default"
        }
    }
    
    func updateCustomerTax() {
        let CustomerObjData = UserDefaults.standard.object(forKey: "CustomerObj")
        
        if let region = (CustomerObjData as AnyObject).value(forKey: "str_region") as? String {
            if let index = array_TaxList.index(where: {$0.tax_title == region}) {
                taxType = array_TaxList[index].tax_type
                taxTitle = "Default"
                taxAmountValue = array_TaxList[index].tax_amount
                DataManager.defaultTaxID = array_TaxList[index].tax_title
                return
            }
        }
        
        if let city = (CustomerObjData as AnyObject).value(forKey: "str_city") as? String {
            if let index = array_TaxList.index(where: {$0.tax_title == city}) {
                taxType = array_TaxList[index].tax_type
                taxTitle = "Default"
                taxAmountValue = array_TaxList[index].tax_amount
                DataManager.defaultTaxID = array_TaxList[index].tax_title
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
            
            var total = 0.0
            if price == 0 {
                total = 0.0
            } else {
                total = qty * price
            }
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
    
    func taxDataCalculation() -> Double {
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
           
            var total = 0.0
            if price == 0 {
                total = 0.0
            } else {
                total = qty * price
            }
            
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
                                        taxDef = 0.0
                                        total = total * (Double(str_TaxPercentage) ?? 0) / 100
                                        total = total > 0 ? total : 0
//                                        var strT = "\(total)"
//                                        var strIn = ""
//                                        if let range = strT.range(of: ".") {
//                                            let num = strT[range.upperBound...]
//                                            print(num)
//                                            strT = String(num)
//                                        }
//
//                                        strIn = strT[0 ..< 3]
//                                        var newtaxTotal = total.rounded(toPlaces: 3)
//
//                                        let strLastDigitFive = strIn.last
//                                        if strLastDigitFive == "5" {
//                                            newtaxTotal = newtaxTotal + 0.001
//                                            newtaxTotal = newtaxTotal.rounded(toPlaces: 2)
//                                            total = newtaxTotal
//                                        } else {
//                                            total = total.rounded(toPlaces: 2)
//                                        }
                                        taxableAmtData += total
                                        str_TaxAmount = taxableAmtData.currencyFormatA
                                
                                    }
                                    
                                    if (taxType == "Fixed") {
                                        taxDef = 0.0
                                        if versionOb < 4 {
                                            total = (Double(str_TaxPercentage) ?? 0)
                                            total = total > 0 ? total : 0
                                            
                                            total = total.roundedTax()
                                            taxableAmtData += total
                                            //taxDef = tax
                                            str_TaxAmount = taxableAmtData.currencyFormatA
                                        } else {
                                            if taxableAmount > 0.0 {
                                                total = (Double(str_TaxPercentage) ?? 0)
                                                total = total > 0 ? total : 0
                                                //taxDef = tax
                                                total = total.roundedTax()
                                                taxableAmtData += total
                                                //taxDef = tax
                                                str_TaxAmount = taxableAmtData.currencyFormatA
                                            }
                                        }
                                        
                //                        if !DataManager.isCaptureButton {
                //                            if (self.taxModelObj.tax_settings["charge_shipping_tax"] != nil) {
                //                                if DataManager.posTaxOnShippingHandlingFunctionality == "true" {
                //                                    var shippingHandlingTax = (Double(str_ShippingANdHandling) ?? 0.0) * ((Double(str_TaxPercentage) ?? 0.0)/100)
                //                                    //                    shippingHandlingTax = shippingHandlingTax < 0 ? 0 : shippingHandlingTax
                //                                    if orderType == .refundOrExchangeOrder && !shippingRefundButton.isSelected && !newProductFound {
                //                                        shippingHandlingTax = 0
                //                                    }
                //                                    taxDef = tax + shippingHandlingTax
                //                                    str_TaxAmount = "\(tax + shippingHandlingTax)"
                //                                }
                //                            }
                //                        }
                                        //str_TaxAmount = tax.roundToTwoDecimal change by Devendra (rond function)
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
                                        taxableAmtData += taxd.roundedTax()
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
            }
            
//            if (taxable == "Yes") && (isTaxExempt == "No") {
//                taxNewAmount += total
//                if taxDetails.count == 0 {
//                    print(taxDetails.count)
//
//                    let valTo = discountPointTaxable * total
//                    total = total - valTo
//                    taxableAmount += total
//
//
//                    if (taxType == "Percentage") {
//                        taxDef = 0.0
//                        total = total * (Double(str_TaxPercentage) ?? 0) / 100
//                        total = total > 0 ? total : 0
//                        //taxDef = tax
//                        total = total.rounded(toPlaces: 2)
//                        taxableAmtData += total
//                        str_TaxAmount = taxableAmtData.currencyFormatA
//
//                    }
//
//                    if (taxType == "Fixed") {
//                        taxDef = 0.0
//                        if versionOb < 4 {
//                            total = (Double(str_TaxPercentage) ?? 0)
//                            total = total > 0 ? total : 0
//
//                            total = total.rounded(toPlaces: 2)
//                            taxableAmtData += total
//                            //taxDef = tax
//                            str_TaxAmount = taxableAmtData.currencyFormatA
//                        } else {
//                            if taxableAmount > 0.0 {
//                                total = (Double(str_TaxPercentage) ?? 0)
//                                total = total > 0 ? total : 0
//                                //taxDef = tax
//                                total = total.rounded(toPlaces: 2)
//                                taxableAmtData += total
//                                //taxDef = tax
//                                str_TaxAmount = taxableAmtData.currencyFormatA
//                            }
//                        }
//
////                        if !DataManager.isCaptureButton {
////                            if (self.taxModelObj.tax_settings["charge_shipping_tax"] != nil) {
////                                if DataManager.posTaxOnShippingHandlingFunctionality == "true" {
////                                    var shippingHandlingTax = (Double(str_ShippingANdHandling) ?? 0.0) * ((Double(str_TaxPercentage) ?? 0.0)/100)
////                                    //                    shippingHandlingTax = shippingHandlingTax < 0 ? 0 : shippingHandlingTax
////                                    if orderType == .refundOrExchangeOrder && !shippingRefundButton.isSelected && !newProductFound {
////                                        shippingHandlingTax = 0
////                                    }
////                                    taxDef = tax + shippingHandlingTax
////                                    str_TaxAmount = "\(tax + shippingHandlingTax)"
////                                }
////                            }
////                        }
//                        //str_TaxAmount = tax.roundToTwoDecimal change by Devendra (rond function)
//                    }
//                } else {
//                    print(taxDetails.count)
//                    taxDetailAmt += total
//                    let typeT = taxDetails["type"] as? String
//                    let AmtT = taxDetails["amount"] as? Double
//                    let valTo = discountPointTaxable * total
//
//                    total = total - valTo
//                    print(typeT)
//
//                    if (typeT == "Percentage") {
//                        var taxd = 0.0
//                        taxd = AmtT ?? 0.0
//
//                        taxd = (taxd * total) / 100
//                        taxd = taxd > 0 ? taxd : 0
//                        taxableAmtData += taxd.rounded(toPlaces: 2)
//                    }
//
//                    if (typeT == "Fixed") {
//                        var taxd = 0.0
//                        if versionOb < 4 {
//                            taxd = AmtT ?? 0.0
//                            taxableAmtData += taxd
//                            //taxd = taxd.rounded(toPlaces: 2)
//                            //str_TaxAmount = taxd.currencyFormatA
//                        } else {
//                            //if taxableAmount > 0.0 {
//                            taxd = AmtT ?? 0.0
//                            taxableAmtData += taxd
//                            //                                taxd = taxd.rounded(toPlaces: 2)
//                            //                                str_TaxAmount = taxd.currencyFormatA
//                            //}
//                        }
//                        //str_TaxAmount = tax.roundToTwoDecimal change by Devendra (rond function)
//                    }
//
//                }
//                //taxableAmount += total
//            }
        }
        
        return taxableAmount
    }
    
    func calculateTotal() {
        if orderType == .refundOrExchangeOrder {
            
            if HomeVM.shared.paxDeviceList.count == 0 {
                for i in 0..<orderInfoObj.transactionArray.count {
                    if orderInfoObj.transactionArray[i].cardType == "EMV" {
                        callAPItoGetPAXDeviceList()
                        break
                    }
                }
            } else {
                arrPaxDeviceData.removeAllObjects()
                arrTempPaxDeviceData.removeAllObjects()
                for i in 0..<HomeVM.shared.paxDeviceList.count {
                    var list = [String:String]()
                    list["strUrl"] = HomeVM.shared.paxDeviceList[i].url
                    list["strPort"] = HomeVM.shared.paxDeviceList[i].port
                    list["strName"] = HomeVM.shared.paxDeviceList[i].name
                    list["strIndex"] = "0"
                    self.arrPaxDeviceData.add(list)
                }
                
                print(self.arrPaxDeviceData)
                
                for j in 0..<self.orderInfoObj.transactionArray.count {
                    var listData = [String:String]()
                    if DataManager.selectedPaxDeviceName != "" {
                        listData["strName"] = DataManager.selectedPaxDeviceName
                    }else{
                        listData["strName"] = HomeVM.shared.paxDeviceList[0].name
                    }
                    //listData["strName"] = HomeVM.shared.paxDeviceList[0].name
                    listData["strIndex"] = "\(j)"
                    self.arrTempPaxDeviceData.add(listData)
                }
                
                print(self.arrTempPaxDeviceData)
            }

            calculateRefundExchangeTotal()
            return
        } else {
            print("value data not refund exchange value on data")
        }
        
        print("****************************************************** Start Calculation ******************************************************")
        
        self.shippingView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        //Remove Coupan & Discount
        if cartProductsArray.count == 0 {
            self.str_AddDiscount = ""
            self.lbl_AddDiscount.text = "$0.00"
            self.isShippingPriceChanged = false
            self.str_ShippingANdHandling = ""
            self.lbl_ShippingAndHandling.text = "$0.00"
        }
        // Start ..... by priya loyalty change
        strCustLoyaltyBalance = CustomerObj.str_loyalty_balance
        doubleCustLoyaltyBalance = CustomerObj.doubleloyalty_balance
        print("strCustLoyaltyBalance",strCustLoyaltyBalance)
        print("doubleCustLoyaltyBalance",doubleCustLoyaltyBalance)
        
        //Update Shipping
        updateShippingTotal()
        //Update Coupon
        updateCouponTotal()
        //Reset Values
        SubTotalPrice = 0.0
        str_TaxAmount = "0.00"
        str_TaxPercentage = taxAmountValue as String
        if isOpenToOrderHistory{
            str_TaxAmount = taxAmountValue as String
        }
        subTotalLoyaltyCredit = 0
        subTotalLoyaltyPurchase = 0
        
        
        var taxableAmount = Double()
        var taxDetailAmt = Double()
        var taxNewAmount = Double()
        
        var subTotal:Double = 0
        var newProductFound = false
        
        taxableAmtData = 0.0
        
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
            
            var total = 0.0
            if price == 0 {
                total = 0.0
            } else {
                total = qty * price
            }
            subTotal = total + subTotal
            var taxDetails = JSONDictionary()
            if versionOb > 3 {
                taxDetails = (obj as AnyObject).value(forKey: "tax_detail") as? JSONDictionary ?? [:]
            }
            //let taxDetails =
    
            if (taxable == "Yes") && (isTaxExempt == "No") {
                taxNewAmount += total
                if taxDetails.count == 0 {
                    print(taxDetails.count)
                    taxableAmount += total
                } else {
                    print(taxDetails.count)
                    
                    let typeT = taxDetails["type"] as? String
                    let AmtT = taxDetails["amount"] as? Double

                    print(typeT)

                    if (typeT == "Percentage") {
                        var taxd = 0.0
                        taxd = AmtT ?? 0.0

                        taxd = (taxd * (total) ?? 0) / 100
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
            } else {
                taxDetailAmt += total
            }
            
            //            if DataManager.isCaptureButton {
            //                if let taxCode = DataManager.OrderDataModel?["str_CustomTaxId"] {
            //                    taxableAmount += total
            //                }
            //            }
            
            isLoyaltyAllowCreditProduct = (obj as AnyObject).value(forKey: "allow_credit_product") as? Bool ?? false
            isLoyaltyAllowPurchaseProduct = (obj as AnyObject).value(forKey: "allow_purchase_product") as? Bool ?? false
            
            if isLoyaltyAllowCreditProduct {
                storeCreditView.isHidden = false
                lblStoreCreditAmt.isHidden = false
                let total = qty * price
                subTotalLoyaltyCredit = total + subTotalLoyaltyCredit
                allowPurchaseTotalLoyalty = total + subTotalLoyaltyPurchase
                print("subTotalLoyaltyCredit",subTotalLoyaltyCredit)
                print("allowPurchaseTotalLoyalty",allowPurchaseTotalLoyalty)
            }else{
                storeCreditView.isHidden = true
                lblStoreCreditAmt.isHidden = true
            }
            if isLoyaltyAllowPurchaseProduct {
                storeCreditView.isHidden = false
                lblStoreCreditAmt.isHidden = false
                let total = qty * price
                subTotalLoyaltyPurchase = total + subTotalLoyaltyPurchase
                allowPurchaseTotalLoyalty = total + subTotalLoyaltyPurchase
                print("subTotalLoyaltyPurchase",subTotalLoyaltyPurchase)
            }else{
                storeCreditView.isHidden = true
                lblStoreCreditAmt.isHidden = true
            }
        }
                            
        if isLoyaltyAllowPurchaseProduct{
            if DataManager.loyaltyPercentSaving == "" {
                storeCreditView.isHidden = true
                lblStoreCreditAmt.isHidden = true
            } else {
                if let ob = DataManager.loyaltyPercentSaving {
                    if ob != "" {
                        subTotalLoyaltyCredit = (subTotalLoyaltyCredit*Double(ob)!)/100
                        subTotalLoyaltyPurchase = (subTotalLoyaltyPurchase*Double(ob)!)/100
                        print("subTotalLoyaltyCredit",subTotalLoyaltyCredit)
                        print("subTotalLoyaltyPurchase",subTotalLoyaltyPurchase)
                    }
                }
                
                if let amount = DataManager.loyaltyMaxSaveOrder {
                    if subTotalLoyaltyPurchase < Double(amount) ?? 0.0{
                        storeCreditView.isHidden = false
                        lblStoreCreditAmt.isHidden = false
                        lblStoreCreditAmt.text = subTotalLoyaltyCredit.currencyFormat
                        
                        if strCustLoyaltyBalance != ""{
                            totalLoyalty = subTotalLoyaltyCredit + (Double(strCustLoyaltyBalance) ?? 0.0)//Double(strCustLoyaltyBalance) ?? 0.0 + subTotalLoyaltyCredit
                        }else{
                            totalLoyalty = doubleCustLoyaltyBalance + subTotalLoyaltyCredit
                        }
                        
                    }
                    
                    if Double(amount) ?? 0.0 < subTotalLoyaltyPurchase{
                        lblStoreCreditAmt.text = Double(amount)?.currencyFormat
                        subTotalLoyaltyPurchase = Double(amount) ?? 0.0
                        print("subTotalLoyaltyPurchase",subTotalLoyaltyPurchase)
                    }
                    if totalLoyalty > allowPurchaseTotalLoyalty{
                        rewardPoints = allowPurchaseTotalLoyalty
                        print("rewardPoints",rewardPoints)
                    }else{
                        rewardPoints = totalLoyalty
                        print("rewardPoints",rewardPoints)
                    }
                    if strCustLoyaltyBalance != "" || doubleCustLoyaltyBalance != 0.0{
                        taxableAmount = taxableAmount - rewardPoints
                        print("taxableAmount",taxableAmount)
                    }
                }
            }
            
        }else{
            storeCreditView.isHidden = true
            lblStoreCreditAmt.isHidden = true
        }
        
        
        if isLoyaltyAllowCreditProduct {
            storeCreditView.isHidden = false
            lblStoreCreditAmt.isHidden = false
        }else{
            storeCreditView.isHidden = true
            lblStoreCreditAmt.isHidden = true
        }
        
        //Tax
        var tax = Double()
        
        print("Tax Title:",taxTitle ,"Tax Type:",taxType , "& Tax Value:", str_TaxPercentage)
        
        //Manual Discount
        print("manual ;_",Double(self.str_AddDiscount) ?? 0.00)
        
        
        var manualDiscount = self.isPercentageDiscountApplied ? (Double(self.str_AddDiscountPercent) ?? 0.0) : (Double(self.str_AddDiscount) ?? 0.0)
        let subTotalONe = subTotal.currencyFormatA
        let stringToDoublTotal = Double(subTotalONe) ?? 0.00
        if manualDiscount > 0 {
            if self.isPercentageDiscountApplied {
                manualDiscount = (manualDiscount / 100) * stringToDoublTotal
                manualDiscount = manualDiscount < 0 ? 0 : manualDiscount
            }
            self.str_AddDiscount = "\(manualDiscount)"
            self.lbl_AddDiscount.text = manualDiscount.currencyFormat
            
            discountPointTaxable = manualDiscount/stringToDoublTotal
            
            let dd = taxDataCalculation()
            
            if manualDiscount > subTotal {
                print("enter value data")
                
                manualDiscount = 0
                
                self.str_AddDiscount = "\(manualDiscount)"
                self.lbl_AddDiscount.text = manualDiscount.currencyFormat
                
            }
        } else {
            manualDiscount = 0
            
            self.str_AddDiscount = "\(manualDiscount)"
            self.lbl_AddDiscount.text = manualDiscount.currencyFormat
        }
        
        
        if DataManager.isCaptureButton {
            if let discout = DataManager.OrderDataModel?["str_DiscountPrize"] {
                self.str_AddDiscount = discout as! String
                self.lbl_AddDiscount.text = discout as! String
            }
        }
        
        //        let manualDiscount: Double = Double(self.str_AddDiscount) ?? 0.00
        //
        //        if isPercentageDiscountApplied {
        //
        //        }
        
        //If isCoupanApplyOnAllProducts
        if isCoupanApplyOnAllProducts {
            
            if taxableCouponTotal > 0 {
                discountPointTaxable = taxableCouponTotal/CouponTotal
                
                discountPointTaxable = discountPointTaxable + (manualDiscount.rounded(toPlaces: 2)/subTotal)
                discountPointWithoutCouponTaxable = manualDiscount.rounded(toPlaces: 2)/subTotal
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
        
        
        if strCustLoyaltyBalance != "" || doubleCustLoyaltyBalance != 0.0{
            
        }else{
            if (isLoyaltyAllowCreditProduct || isLoyaltyAllowPurchaseProduct) || (isLoyaltyAllowCreditProduct && isLoyaltyAllowPurchaseProduct){
                tax = tax - rewardPoints
                print("tax",tax)
            }
        }
        
        //end......priya
        
        if DataManager.isCaptureButton {
            if let taxCode = DataManager.OrderDataModel?["str_CustomTaxId"] {
                for i in (0...HomeVM.shared.taxList.count-1)
                {
                    self.taxModelObj = TaxListModel()
                    self.taxModelObj.tax_title = HomeVM.shared.taxList[i].tax_title
                    self.taxModelObj.tax_type = HomeVM.shared.taxList[i].tax_type
                    self.taxModelObj.tax_amount = HomeVM.shared.taxList[i].tax_amount
                    self.array_TaxList.append(self.taxModelObj)
                    
                    let code = taxCode as! String
                    
                    if(self.taxModelObj.tax_title == code)
                    {
                        
                        self.lbl_TaxStateName?.text = ""
                        self.lbl_TaxStateName?.text = "Tax(\(self.taxModelObj.tax_title))"
                        self.taxTitle = self.taxModelObj.tax_title
                        self.taxType = self.taxModelObj.tax_type
                        self.taxAmountValue = self.taxModelObj.tax_amount
                        self.str_TaxPercentage  = self.taxAmountValue
                    }
                }
            }
        }
        
        //        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline  {
        //            taxType = ""
        //        }
        
        //If Tax Type Percentage
        if (taxType == "Percentage") {
//            taxDef = 0.0
//            tax = tax * (Double(str_TaxPercentage) ?? 0) / 100
//            tax = tax > 0 ? tax : 0
//            //taxDef = tax
//            tax = tax.rounded(toPlaces: 2)
//            taxDef = tax
//            str_TaxAmount = tax.currencyFormatA
            
            if !DataManager.isCaptureButton {
                if (self.taxModelObj.tax_settings["charge_shipping_tax"] != nil) {
                    if DataManager.posTaxOnShippingHandlingFunctionality == "true" {
                        var shippingHandlingTax = (Double(str_ShippingANdHandling) ?? 0.0) * ((Double(str_TaxPercentage) ?? 0.0)/100)
                        //                    shippingHandlingTax = shippingHandlingTax < 0 ? 0 : shippingHandlingTax
                        if orderType == .refundOrExchangeOrder && !shippingRefundButton.isSelected && !newProductFound {
                            shippingHandlingTax = 0
                        }
                        taxableAmtData = taxableAmtData + shippingHandlingTax
                        str_TaxAmount = "\(taxableAmtData + shippingHandlingTax)"
                    }
                }
            }
        }
        
        //If Tax Type Fixed
        if (taxType == "Fixed") {
//            taxDef = 0.0
//            if versionOb < 4 {
//                tax = (Double(str_TaxPercentage) ?? 0)
//                tax = tax > 0 ? tax : 0
//
//                tax = tax.rounded(toPlaces: 2)
//                taxDef = tax
//                str_TaxAmount = tax.currencyFormatA
//            } else {
//                if taxableAmount > 0.0 {
//                    tax = (Double(str_TaxPercentage) ?? 0)
//                    tax = tax > 0 ? tax : 0
//                    //taxDef = tax
//                    tax = tax.rounded(toPlaces: 2)
//                    taxDef = tax
//                    str_TaxAmount = tax.currencyFormatA
//                }
//            }
            
            if !DataManager.isCaptureButton {
                if (self.taxModelObj.tax_settings["charge_shipping_tax"] != nil) {
                    if DataManager.posTaxOnShippingHandlingFunctionality == "true" {
                        var shippingHandlingTax = (Double(str_ShippingANdHandling) ?? 0.0) * ((Double(str_TaxPercentage) ?? 0.0)/100)
                        //                    shippingHandlingTax = shippingHandlingTax < 0 ? 0 : shippingHandlingTax
                        if orderType == .refundOrExchangeOrder && !shippingRefundButton.isSelected && !newProductFound {
                            shippingHandlingTax = 0
                        }
                        taxableAmtData = taxableAmtData + shippingHandlingTax
                        str_TaxAmount = "\(taxableAmtData + shippingHandlingTax)"
                    }
                }
            }
            //str_TaxAmount = tax.roundToTwoDecimal change by Devendra (rond function)
        }
        if isOrderPrepare{
            if let cartData = DataManager.cartData {
                str_TaxPercentage = cartData["str_TaxPercentage"] as? String ?? ""
                taxAmountValue = cartData["taxAmountValue"] as? String ?? ""
                taxTitle = cartData["taxTitle"] as? String ?? ""
                taxType = cartData["taxType"] as? String ?? ""
                str_TaxAmount = taxAmountValue
                taxableAmtData = (Double(str_TaxAmount) ?? 0.0)
                TotalPrice = self.orderInfoObj.total
            }
        }
        
        //Update Subtotal
        SubTotalPrice = subTotal
        //Update Labels
        updateLabels()
        //lbl_TaxStateName = addDotLineunderLabel(label: lbl_TaxStateName!, width: 10, color: UIColor.clear)
        var rect: CGRect = lbl_TaxStateName!.frame //get frame of label
        rect.size = (lbl_TaxStateName?.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: lbl_TaxStateName!.font.fontName , size: lbl_TaxStateName!.font.pointSize)!]))! //Calculate as per label font
        //labelWidth.constant = rect.width // set width to Constraint outlet
        print("rect.width === \(rect.width)")
        
        // lbl_TaxStateName = addDotLineunderLabel(label: lbl_TaxStateName!, width: rect.width, color: #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1))
        
        print("****************************************************** End Calculation ****************************************************")
        
        if UI_USER_INTERFACE_IDIOM() == .pad && self.cartProductsArray.count == 0 {
            self.delegate?.didRemoveCartArray?()
        }
    }
    
    func updateLabels() {
        //strShiping = self.lbl_ShippingAndHandling.text!
        
        if versionOb < 4 {
            self.shippingRefundButton.isHidden = true
        } else {
            if self.str_showShipOrderInPos == "true" || self.lbl_ShippingAndHandling.text != "$0.00" {
                if str_showShipOrderInPos == "true" {
                    self.shippingRefundButton.isHidden = false
                }else{
                    self.shippingRefundButton.isHidden = true
                }
                
                if orderType == .refundOrExchangeOrder {
                    self.shippingRefundButton.setTitle("Refund", for: .normal)
                } else {
                    self.shippingRefundButton.setTitle("Ship Order", for: .normal)
                }
                if self.orderType == .refundOrExchangeOrder {
                  if  self.lbl_ShippingAndHandling.text != "$0.00" {
                        self.shippingRefundButton.isHidden = false
                      self.shippingRefundButton.setTitle("Refund", for: .normal)
                    }
                }

                //self.shippingRefundButton.setTitle("Ship Order", for: .normal)
            }else{
                self.shippingRefundButton.isHidden = true
            }
        }
        
        
        
        let couponDiscount = NSString(string: String(describing: taxableCouponTotal))
        var discountAmount = Double(self.str_AddDiscount) ?? 0.00
        let shipping = Double(lbl_ShippingAndHandling.text?.replacingOccurrences(of: "$", with: "") ?? "0") ?? 0
        
        DataManager.shippingValueForAddress = shipping
        
        let taxAmount = NSString(string: str_TaxAmount)
        //let discountAnt = (discountAmount.currencyFormatA as NSString).doubleValue
        //let disString: Double  = str_AddDiscount.toDouble() ?? 0.00
        
        //let disCoveryt = disString.currencyFormatA
        
        //        let val = (SubTotalPrice.rounded(toPlaces: 2) * taxAmountValue)/ 100
        //
        //        print(<#T##items: Any...##Any#>)
        print("data show in tax === --- \(taxableAmtData)")
        
        let formattergg = NumberFormatter()
        formattergg.maximumFractionDigits = 2
        formattergg.roundingMode = .down
        //let TS = formattergg.string(from: NSNumber(value: taxableAmtData))
        //print("data show in taxxxxx === --- \(TS)")
        
        //let Taxaa = TS?.toDouble() ?? 0.0
        let Taxaa = taxableAmtData
        var subtotal = (SubTotalPrice-discountAmount)-taxableCouponTotal
        
        if orderType == .newOrder {
            subtotal = subtotal < 0 ? 0 : subtotal
        }
        if taxDef.isNaN{
            taxDef = 0.0
        }
        TotalPrice = (shipping + taxableAmtData  +  subtotal)
        
        self.lbl_AddDiscount.text = "$" + discountAmount.currencyFormatA
        
        //        let text = SubTotalPrice.currencyFormat as? NSAttributedString
        //
        //        let attrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDash.rawValue | NSUnderlineStyle.styleSingle.rawValue]
        //
        //        text.addAttributes(attrs, range: NSRange(location: 0, length: text.length))
        //
        //        lbl_SubTotal!.attributedText = text
        
        lbl_SubTotal!.attributedText = NSAttributedString(string: SubTotalPrice.currencyFormat, attributes:
            [.underlineStyle: NSUnderlineStyle.patternDashDotDot.rawValue])
        
        //lbl_SubTotal?.text = SubTotalPrice.currencyFormat
        
        //        if 172.845 == taxableCouponTotal {
        //            taxableCouponTotal =  172.846
        //        }
        //        let val : Int = Int(couponDiscount.character(at: couponDiscount.length - 1))
        
        let hh = taxableCouponTotal.rounded(toPlaces: 2)
        
        lbl_AppliedCouponAmount.text = couponDiscount == "" ? "$0.00" : hh.currencyFormat
        //lbl_AppliedCouponAmount.text = "\((couponDiscount as NSString).doubleValue)"
        self.lbl_TaxStateName?.text = " "
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
            self.lbl_TaxStateName?.text = (self.taxTitle == "" || self.taxTitle == "countrywide" || self.taxTitle == "Default") ? "Tax (Default)" :  "Tax (\(self.taxTitle))"
        }
        lbl_Tax.text = taxAmount.doubleValue.rounded(toPlaces: 2).currencyFormat
        
        let dataval = taxableAmtData
        lbl_Tax.text = dataval.currencyFormat
        print("CSubTotalPrice", SubTotalPrice.currencyFormatA)
        print("CcouponDiscount:", couponDiscount)
        print("CdiscountAmount:", discountAmount.currencyFormatA)
        print("Cshipping:", shipping.currencyFormatA)
        print("CtaxAmount:", taxAmount.doubleValue.currencyFormatA)
        print("Ctotl:", TotalPrice.currencyFormatA)
        
        
        // socket sudama
        if appDelegate.str_Refundvalue == "" {
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                var cartModelObj = CartDataSocketModel()
                cartModelObj.balance_due = str_BalanceDue
                cartModelObj.total = TotalPrice
                cartModelObj.subTotal = SubTotalPrice
                cartModelObj.balance_due = HomeVM.shared.DueShared
                cartModelObj.tax = dataval//taxableAmtData
                cartModelObj.coupon = taxTitle
                cartModelObj.couponDiscount = taxableCouponTotal
                cartModelObj.manualDiscount = Double(self.str_AddDiscount) ?? 0.0
                cartModelObj.strAddCouponName = str_AddCouponName
                cartModelObj.shippingAmount = shipping
                MainSocketManager.shared.connect()
                let socketConnectionStatus = MainSocketManager.shared.socket.status
                
                switch socketConnectionStatus {
                case SocketIOStatus.connected:
                    print("socket connected")
                    productsArraySocket.removeAll()
                    MainproductsArraySocket.removeAll()
                    if DataManager.sessionID != "" {
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
        //
        
        print(SubTotalPrice - discountAmount)
        
        let taxdata = SubTotalPrice - discountAmount
        
        if SubTotalPrice == taxableCouponTotal {
            discountAmount = 0.0
            lbl_AddDiscount.text = "$0.00"
            //discountView.isHidden = true
        }
        
        if SubTotalPrice == discountAmount {
            taxableCouponTotal = 0.0
            lbl_AppliedCouponAmount.text = "$0.00"
            //discountView.isHidden = true
        }
        
        //        if discountAmount > 0 {
        //            if taxableCouponTotal > 0 {
        //                taxableCouponTotal = SubTotalPrice - discountAmount
        //
        //                if taxableCouponTotal > 0 {
        //                    lbl_AppliedCouponAmount.text = taxableCouponTotal.currencyFormat
        //                } else {
        //                    lbl_AppliedCouponAmount.text = "$0.00"
        //                }
        //            }
        //        }
        
        let CSubTotalPrice = SubTotalPrice.rounded(toPlaces: 2)//Double(SubTotalPrice.currencyFormatA)
        let CcouponDiscount = taxableCouponTotal.rounded(toPlaces: 2) //Double(taxableCouponTotal.currencyFormatA)
        
        let CdiscountAmount = discountAmount.rounded(toPlaces: 2)//Double(discountAmount.currencyFormatA)
        let Cshipping = shipping.rounded(toPlaces: 2)//Double(shipping.currencyFormatA)
        
        let dataT = taxableAmtData
        let CtaxAmount = dataT.rounded(toPlaces: 2)//Double(taxAmount.doubleValue.currencyFormatA)
        //        TotalPrice = (Cshipping + CtaxAmount + CSubTotalPrice)
        
        if (isLoyaltyAllowCreditProduct || isLoyaltyAllowPurchaseProduct) || (isLoyaltyAllowCreditProduct && isLoyaltyAllowPurchaseProduct){
            
            //            if strCustLoyaltyBalance != "" || doubleCustLoyaltyBalance != 0.0{
            //                CdiscountAmount = CdiscountAmount + rewardPoints
            //                discountAmount =  CdiscountAmount - Double(rewardsPoint)
            //            }
            
            //            self.lbl_AddDiscount.text = "$" + discountAmount.currencyFormatA
            
            //            let loyaltyBonus = subTotalLoyaltyPurchase.rounded(toPlaces: 2)
            //            let newtotal = CSubTotalPrice + Cshipping + CtaxAmount
            let loyaltyBonus = rewardPoints.rounded(toPlaces: 2)
            let newtotal = CSubTotalPrice + Cshipping + CtaxAmount
            let minusTotal = CdiscountAmount + CcouponDiscount + loyaltyBonus
            let finalTotal = newtotal - minusTotal
            print("finalTotal", finalTotal.currencyFormatA)
            if finalTotal < 0 {
                TotalPrice =  0.00
                totalLabel.text = "$0.00"
            }else{
                TotalPrice =  (finalTotal.currencyFormatA as NSString).doubleValue//finalTotal.currencyFormat
                totalLabel.text = "$" + "\(finalTotal.currencyFormatA)"
            }
            
            UserDefaults.standard.set(finalTotal, forKey: "balancefinalCart")
            
            if strCustLoyaltyBalance != "" || doubleCustLoyaltyBalance != 0.0{
                //           CdiscountAmount =  CdiscountAmount - Double(rewardPoints)
                ///              self.lbl_AddDiscount.text = "$" + CdiscountAmount.currencyFormatA
                lblStoreCreditAmt.text = rewardPoints.currencyFormat
                storeCreditView.isHidden = false
                lblStoreCreditAmt.isHidden = false
            }
            
        }else {
            
            var tip = 0.0
            
//            if let strTip = DataManager.OrderDataModel?["str_TipAmount"] as? Double {
//                if strTip > 0 {
//                    tip = strTip
//                    tipRefund = tip
//                    self.viewTip.isHidden = false
//                    self.lblTipAmount.text = strTip.currencyFormat
//                    btnTipSelect.isHidden = true
//                }
//            }
            
            let newtotal = CSubTotalPrice + Cshipping + CtaxAmount + tip
            let minusTotal = CdiscountAmount + CcouponDiscount
            let finalTotal = newtotal - minusTotal
            print("finalTotal", finalTotal.currencyFormatA)
            
            if finalTotal < 0 {
                TotalPrice =  0.00
                totalLabel.text = "$0.00"
            }else{
                TotalPrice =  (finalTotal.currencyFormatA as NSString).doubleValue//finalTotal.currencyFormat
                totalLabel.text = "$" + "\(finalTotal.currencyFormatA)"
            }
            
            UserDefaults.standard.set(finalTotal, forKey: "balancefinalCart")
        }
        
        if isOpenToOrderHistory{
            if let cartData = DataManager.cartData {
                str_TaxPercentage = cartData["str_TaxPercentage"] as? String ?? ""
                taxAmountValue = cartData["taxAmountValue"] as? String ?? ""
                taxTitle = cartData["taxTitle"] as? String ?? ""
                taxType = cartData["taxType"] as? String ?? ""
                str_TaxAmount = taxAmountValue
                taxableAmtData = (Double(str_TaxAmount) ?? 0.0)
                TotalPrice = self.orderInfoObj.total
                HomeVM.shared.amountPaid = TotalPrice - (Double(self.orderInfoObj.balanceDue.replacingOccurrences(of: ",", with: "")) ?? 0)
            }
        }
        //TotalPrice =  (finalTotal.currencyFormatA as NSString).doubleValue//finalTotal.currencyFormat
        //totalLabel.text = "$" + "\(finalTotal.currencyFormatA)"
        if UI_USER_INTERFACE_IDIOM() == .phone && orderType == .newOrder {
            
            
            if DataManager.isCaptureButton {
                self.btn_Pay?.setTitle("Capture", for: .normal)
            } else {
                self.btn_Pay?.setTitle("Charge \(TotalPrice.currencyFormat)", for: .normal)
            }
            
        }
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if HomeVM.shared.DueShared > 0{
                viewBalanceDue.isHidden = false
                labelAmtBalanceDue.text = "$\((HomeVM.shared.DueShared).roundToTwoDecimal)"
                
                if DataManager.isCaptureButton {
                    self.btn_Pay?.setTitle("Capture", for: .normal)
                } else {
                    self.btn_Pay?.setTitle("Charge $\((HomeVM.shared.DueShared).roundToTwoDecimal)", for: .normal)
                }
                
            }else{
                viewBalanceDue.isHidden = true
                if DataManager.isCaptureButton {
                    self.btn_Pay?.setTitle("Capture", for: .normal)
                } else {
                    self.btn_Pay?.setTitle("Charge \(TotalPrice.currencyFormat)", for: .normal)
                }
            }
        }
        //Hide If Amount Is Zero
        discountView.isHidden = lbl_AddDiscount.text == "$0.00"
        applyCouponView.isHidden = lbl_AppliedCouponName.text == "Apply Coupon"
        crossButton.isHidden = lbl_AppliedCouponName.text == "Apply Coupon"
        self.addDiscountView.isHidden = orderType == .refundOrExchangeOrder
        if DataManager.posDisableDiscountFeature == "true" {
            self.addDiscountView.isHidden = true
        }
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            self.view_AddCustomer.isHidden = true
        }else {
            self.view_AddCustomer.isHidden = !DataManager.isCustomerManagementOn || orderType == .refundOrExchangeOrder
        }
        //self.taxView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        
        if CtaxAmount > 0 {
            self.taxView.isHidden = false
        }
        
        if lblStoreCreditAmt.text == "$0.00"{
            self.storeCreditView.isHidden = true
        }
        
        //self.shippingView.isHidden = self.lbl_ShippingAndHandling.text == "$0.00"
        
        //Hide If Cart Empty
        btn_Pay?.isHidden = cartProductsArray.count == 0
        cartPaymentSectionView.isHidden = cartProductsArray.count == 0
        
        saveAllData()
        
        if DataManager.isCaptureButton {
            btn_Pay?.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
        }
        
        totalLabel!.attributedText = NSAttributedString(string: TotalPrice.currencyFormat, attributes:
            [.underlineStyle: NSUnderlineStyle.patternDashDotDot.rawValue])
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
            self.lbl_ShippingAndHandling.text = totalShipping.currencyFormat
            
            if DataManager.isCaptureButton {
                if let shipping = DataManager.OrderDataModel?["str_ShippingRate"] {
                    let ship = shipping as? Double
                    if ship != nil {
                        self.lbl_ShippingAndHandling.text = ship?.currencyFormat
                    }
                }
            }
        }
    }
    
    func updateCouponTotal() {
        if self.cartProductsArray.count == 0 || HomeVM.shared.coupanDetail.code == nil || str_AddCouponName == "" ||  HomeVM.shared.coupanDetail.amount == nil {
            return
        }
        
        //Calculate Coupan Total
        var isCoupanApplied = false
        var totalAMT = Double()
        var totalQTY = Double()
        var taxableTotalQTY = Double()
        var nonTaxableTotalQTY = Double()
        let coupon = NSString(string: HomeVM.shared.coupanDetail.amount)
        tempWithoutCoupon = 0.0
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
            
            totalAMT = total + totalAMT
            totalQTY += qty
        }
        
        //let value = NSString(string: totalAMT)
        //let AmountVal = totalAMT.doubleValue
        
        let valueOne = NSString(string: HomeVM.shared.coupanDetail.totalAmount)
        let couponAmount = valueOne.doubleValue
        
        if totalAMT < couponAmount {
            
            self.taxableCouponTotal = 0
            isCoupanApplied = false
            self.lbl_AppliedCouponName.text = "Apply Coupon"
            self.crossButton.isHidden = true
            //str_AddCouponName = ""
            
            return
        }
        
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
                        self.taxableCouponTotal = coupon.doubleValue
                    }
                } else {
                    withoutCouponTotal += total
                    print("product name data === \(total)")
                }
            }
        }
        
        if !isCoupanApplied {
            if HomeVM.shared.coupanDetail.productList.count == 0 {
                
                let TotalVal = (totalAMT.currencyFormatA as NSString).doubleValue
                //check taotal amomut
                CouponTotal = TotalVal
                //isCoupanApplied = true
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
                self.lbl_AppliedCouponName.text = "Apply Coupon"
                self.crossButton.isHidden = true
            }
            
            if(HomeVM.shared.coupanDetail.amount.contains(".00"))
            {
                let str = HomeVM.shared.coupanDetail.amount.components(separatedBy: ".")
                //self.lbl_AppliedCouponName.text = "\(str[0])% Coupon Applied"
                self.lbl_AppliedCouponName.text = "Coupon (\(str_AddCouponName))"
                self.crossButton.isHidden = false
            }else {
                self.lbl_AppliedCouponName.text = "Coupon (\(str_AddCouponName))"
                //self.lbl_AppliedCouponName.text = "\(String(describing: HomeVM.shared.coupanDetail.amount ?? "0"))% Coupon Applied"
                self.crossButton.isHidden = false
            }
        }else {
            self.lbl_AppliedCouponName.text = "Coupon (\(str_AddCouponName))"
            //self.lbl_AppliedCouponName.text = "$\(HomeVM.shared.coupanDetail.amount ?? "") Coupon Applied"
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
                    self.lbl_ShippingAndHandling.text = totalShipping.currencyFormat
                }
                
                if HomeVM.shared.coupanDetail.productList.count == 0 {
                    let totalShipping = 0.0
                    
                    str_ShippingANdHandling = "\(totalShipping)"
                    self.lbl_ShippingAndHandling.text = totalShipping.currencyFormat
                }
            }
            
        }
        
        self.isCoupanApplyOnAllProducts = isCoupanApplied
        
    }
    
    func addDotLineunderLabel(label: UILabel, width: CGFloat, color: UIColor) -> UILabel {
        //self.layoutIfNeeded()
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        //let frameSize = label.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: width, height: 0)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: width/2, y: 20)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 0.50
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [3,2]
        //shapeLayer.lineDashPattern = [2,3.5]
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x:0, y: shapeRect.height, width: shapeRect.width,height: 0), cornerRadius: 0).cgPath
        label.frame.size.width = width
        label.layer.addSublayer(shapeLayer)
        return label
    }
    
    func didvariationPrizeAtrribute(cartArray: Array<Any>, index:Int) -> Double {
        var newString = ""
        var amount = 0.0
        print(cartArray)
        radioCount = 0
        arrTempAttId.removeAll()
        arrTempVarId.removeAll()
                
        if let selectedAttribute = (cartArray[index] as AnyObject).value(forKey: "surchargVariationArray") as? [JSONDictionary] {
            
            for value in selectedAttribute {
                if let dataVar = value["values"] as? JSONArray {
                    
                    for value in dataVar {
                        
                        if let isTaxVal = value["variation_taxable"] as? Bool {
                            print(isTaxVal)
                            if !isTaxVal {
                                if let prize = value["variation_price_surchargeClone"] as? String {
                                    print(prize)
                                    let DPrize = Double(prize) ?? 0.0
                                    //amount += DPrize
                                }
                            }
                        }
                    }
                }
            }
        }
        
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
                                                                                
//1                                                                                if let prize = value["variationUseParentPrice"] as? String {
//1
//1                                                                                } else {
//1
//1                                                                                }
//1
//1
//1                                                                                if($variationData['variation_use_parent_price']=='Yes'){
//1                                                                                    $variationPrice = $productDetail['price'];
//1                                                                                }else{
//1                                                                                    $variationPrice = $variationData['variation_price'];
//1                                                                                }
                                                                                let DPrize = Double(prize) ?? 0.0
                                                                                //amount += DPrize
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
}

//MARK: HieCORPickerDelegate
extension CartContainerViewController : HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        
        if isDeviceSelected {
            let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
            pickerTextfield.text = "  \(array[index])"
            return
        }
        if pickerTextfield.tag == 4000 || pickerTextfield.tag == 10000 {
            let array = HomeVM.shared.coupanList.compactMap({$0.str_coupon_code})
            pickerTextfield.text = array[index]
            return
        }
        if pickerTextfield.tag == 6000 {
            let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
            pickerTextfield.text = array[index]
            return
        }
        if pickerTextfield == self.btn_TfTax {
            tf_Tax?.text = "\(self.array_TaxList[index].tax_title)"
        }
        
        if isCheckItem {
            if indexCellItem == 0 {
                indexCellItem = index
            }else if indexCellItem == 1 {
                indexCellItem = index
            }else if indexCellItem == 2 {
                indexCellItem = index
            }else if  indexCellItem == 3 {
                indexCellItem = index
            }else if  indexCellItem == 4 {
                indexCellItem = index
            }
        }
    }
    
    func didClickOnPickerViewDoneButton() {
        self.view.endEditing(true)
        if pickerTextfield.tag == 4000 {
            self.handleApplyCoupon(textField: pickerTextfield)
            pickerTextfield.resignFirstResponder()
            SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
            return
        }
        
        if pickerTextfield.tag == 6000 {
            self.str_addDeviceName = pickerTextfield.text ?? ""
            self.handlePax(textField: pickerTextfield)
            pickerTextfield.resignFirstResponder()
            SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
            return
        }
        if pickerTextfield.tag == 10000 {
            self.handleApplyCouponIphone()
            return
        }
        
        if isDeviceSelected {
            isDeviceSelected = false
            let arrtemp = NSMutableArray()
            for i in 0..<arrTempPaxDeviceData.count {
                
                var listData = [String:String]()
//                                       listData["strName"] = HomeVM.shared.paxDeviceList[0].name
//                                       listData["strIndex"] = "\(j)"
//                                       self.arrTempPaxDeviceData.add(listData)
                let datap = arrTempPaxDeviceData[i] as? NSDictionary
                let name = datap?.value(forKey: "strName")
                let index = datap?.value(forKey: "strIndex")
                let nmdata = pickerTextfield.text?.replacingOccurrences(of: "  ", with: "")
                if indexPaxItem == i {
                    listData["strName"] = nmdata
                    listData["strIndex"] = "\(indexPaxItem)"
                } else {
                    listData["strName"] = name as! String
                    listData["strIndex"] = index as! String
                }
                
                arrtemp.add(listData)
            }
           
            arrTempPaxDeviceData.removeAllObjects()
            arrTempPaxDeviceData = arrtemp
            
        }
        
        if pickerTextfield == self.btn_TfTax {
            self.cartViewDelegate?.didHideView(with: "customviewhide")
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
                self.lbl_TaxStateName?.text = "Tax (Default)"
                if CustomerObj.userCustomTax != "" {
                    CustomerObj.userCustomTax = taxTitle
                }
            }
            else
            {
                let str = array_TaxList[pickerView.selectedRow(inComponent: 0)]
                taxTitle = str.tax_title
                taxType = str.tax_type
                taxAmountValue = str.tax_amount
                
                isDefaultTaxChanged = true
                isDefaultTaxSelected = false
                
                if orderType == .refundOrExchangeOrder {
                    if let cartdataOne = DataManager.cartData {
                        DataManager.cartData!["taxAmountValue"]  = str.tax_amount
                        DataManager.cartData!["taxTitle"]  = str.tax_title
                        DataManager.cartData!["taxType"]  = str.tax_type
                    }
                }
                
                self.lbl_TaxStateName?.text = "Tax (\(str.tax_title))"
                
                if DataManager.isCaptureButton {
                    DataManager.OrderDataModel?["str_CustomTaxId"] = str.tax_title
                }
                
                if CustomerObj.userCustomTax != "" {
                    CustomerObj.userCustomTax = taxTitle
                }
            }
            
            self.pickerTextfield.resignFirstResponder()
            self.tbl_Cart.reloadData()
            self.calculateTotalCart()
        }
        
        if isCheckItem {
            
            var obj = ""
            
            if indexCellItem == 0 {
                obj = "Select Condition"
                showItems.append(obj)
            }else if indexCellItem == 1 {
                obj = "New/Unopened"
                showItems.append(obj)
            }else if indexCellItem == 2 {
                obj = "New/Open Box"
                showItems.append(obj)
            }else if  indexCellItem == 3 {
                obj = "Used"
                showItems.append(obj)
            }else if  indexCellItem == 4  {
                obj = "Damaged"
                showItems.append(obj)
            }
            
            if var dict = self.cartProductsArray[indexItem] as? JSONDictionary {
                dict["selectionInventory"] = obj
                self.cartProductsArray[indexItem] = dict as AnyObject
                DataManager.cartProductsArray = self.cartProductsArray
            }
            
            strStatusItem.replaceObject(at: indexItem, with: obj)
            
            self.tbl_Cart.beginUpdates()
            self.tbl_Cart.reloadRows(at: [indexPathItem as IndexPath], with: .fade)
            self.tbl_Cart.endUpdates()
            //pickerTextfield.text = (self.array_ItemList[index] as AnyObject).capitalized
        }
    }
    
    func didClickOnPickerViewCancelButton() {
        if pickerTextfield.tag == 4000 || pickerTextfield.tag == 10000 {
            pickerTextfield.text = ""
            self.view.endEditing(true)
            self.catAndProductDelegate?.hideView?(with:  "alertblurcancel")
            SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
            return
        }
        if pickerTextfield.tag == 6000  {
            pickerTextfield.text = ""
            self.view.endEditing(true)
            self.catAndProductDelegate?.hideView?(with:  "alertblurcancel")
            SwipeAndSearchVC.shared.dismissAlertControllerIfPresent()
            return
        }
        CartContainerViewController.isPickerSelected = false
        self.view.endEditing(true)
        tf_Tax?.text = ""
        tf_Tax?.resignFirstResponder()
        self.cartViewDelegate?.didHideView(with: "customviewhide")
        btn_TfTax?.resignFirstResponder()
        
        if isCheckItem {
            self.tbl_Cart.beginUpdates()
            self.tbl_Cart.reloadRows(at: [indexPathItem as IndexPath], with: .fade)
            self.tbl_Cart.endUpdates()
        }
    }
}

//MARK: CartContainerViewControllerDelegate
extension CartContainerViewController: CartContainerViewControllerDelegate {
    func didPlaceOrderWithCardInformation() {
        self.updateData()
        self.calculateTotalCart()
        DispatchQueue.main.async {
            self.moveNextScreen()
        }
    }
    
    func callDataSendRate() {
        print("enter")
        handleShippingAddRate(shiipingRate: DataManager.selectedShippingRate ?? "")
    }
    
    func addSubscriptionString(string: String) {
        strSubscriptionValue = string
        if string == "cancel_all"{
            if isinternalGift == false {
                selectedOptionHieght.constant = 28
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 100       //gc+cs  //cs///////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 70
                }
                viewForSelectedOption.isHidden = false
                self.lblSelectedOption.text = "Cancel all subscription associated with this users."
            } else {
                selectedOptionHieght.constant = 28
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 70       //gc+cs  //cs///////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 40
                }
                viewForSelectedOption.isHidden = false
                self.lblSelectedOption.text = "Cancel all subscription associated with this users."
            }
            
        } else if string == "cancel_order" {
            if isinternalGift == false {
                selectedOptionHieght.constant = 28
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 100       //gc+cs  //cs///////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 70
                }
                viewForSelectedOption.isHidden = false
                self.lblSelectedOption.text = "Cancel all subscription associated with this order only."
            } else {
                selectedOptionHieght.constant = 28
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 70       //gc+cs  //cs///////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 40
                }
                viewForSelectedOption.isHidden = false
                self.lblSelectedOption.text = "Cancel all subscription associated with this order only."
            }
        } else if string == "no_change" {
            if isinternalGift == false {
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 70   //gc+cs-cs  //-cs////////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 40
                }
                selectedOptionHieght.constant = 2
                viewForSelectedOption.isHidden = true
                self.lblSelectedOption.text = "No changes"
                
            } else {
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 50 //gc+cs-cs  //-cs////////////////
                }else{
                  exchangePaymentView.constant = collectionViewHeight.constant + 10
                }
                  
                selectedOptionHieght.constant = 2
                viewForSelectedOption.isHidden = true
                self.lblSelectedOption.text = "No changes"
                
            }
        }
        print("string",string)
    }
    
    func refreshCart(isNewOrder: Bool) {
        
        HomeVM.shared.DueShared = 0.0
        self.orderType = isNewOrder ? .newOrder : .refundOrExchangeOrder
        self.refreshCart()
    }
    
    func refreshCart() {
        if let cartProductsArray = DataManager.cartProductsArray {
            self.cartProductsArray = cartProductsArray
        }
        DispatchQueue.main.async {
            self.tbl_Cart.reloadData {
                
                if let index = CartContainerViewController.updatedProductIndex {
                    if index < self.cartProductsArray.count {
                        let indexPath = IndexPath(row: index, section: 0)
                        if let indexPaths = self.tbl_Cart.indexPathsForVisibleRows {
                            if indexPaths.contains(indexPath) {
                                return
                            }
                        }
                        if self.cartProductsArray.count != 0 {
                            self.tbl_Cart.scrollToRow(at: indexPath, at: .bottom , animated: false)
                        }
                        return
                    }
                }
                
                if self.cartProductsArray.count > 0 {
                    self.tbl_Cart.scrollToBottom()
                }
            }
        }
        updateData()
        self.calculateTotalCart()
    }
    
    func didUpdateCart(with identifier: String) {
        if (identifier == "cartbackbuttonaction")
        {
            self.saveCustomerData()
            self.saveCartData()
        }
        if (identifier == "cartresetbuttonaction")
        {
            
            let refreshAlert = UIAlertController(title: "Alert", message: "All cart items will be removed.\n Please confirm.", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                //...
            }))
            refreshAlert.addAction(UIAlertAction(title: "Proceed", style: .destructive, handler: { (action: UIAlertAction!) in
                self.isDefaultTaxChanged = false
                self.isDefaultTaxSelected = false
                self.taxTitle = DataManager.defaultTaxID
                DataManager.isBalanceDueData = false
                PaymentsViewController.paymentDetailDict.removeAll()
                self.resetCartData()
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
        
        if (identifier == "refreshCart")
        {
            self.refreshCart()
        }
        
        if (identifier == "refreshCartForAddNewCustomerIPAD")
        {
            if DataManager.customerObj == nil && CustomerObj.str_userID == "" {
                self.lbl_CustomerName.text = "Add Customer"
                //self.lbl_CustomerName.text = "Customer #"
                icon_AddCustomer.image = #imageLiteral(resourceName: "add-button-inside-black-circle")
                self.CustomerObj = CustomerListModel()
            }
            isCustomerAddrUpdateFlag = false
            updateCustomerData()
            calculateTotalCart()
            self.catAndProductDelegate?.hideView?(with: "addnewcustomerCancelIPAD")
        }
    }
    
    func didUpdateCartCountAndSubtotalPriceCoupon(dict: JSONDictionary) {
        if let value = dict["subtotal"] as? Double {
            SubTotalPrice = value
        }
    }
}

//MARK: CustomerDelegates
extension CartContainerViewController: CustomerDelegates {
    func didAddNewCustomer() {
        lbl_CustomerName.text = "Add Customer"
        //lbl_CustomerName.text = "Customer #"
        icon_AddCustomer.image = #imageLiteral(resourceName: "add-button-inside-black-circle")
        CustomerObj = CustomerListModel()
        str_AddCouponName = ""
        lbl_AppliedCouponName.text = "Apply Coupon"
        lbl_AddDiscount.text = "$0.00"
        str_AddDiscount = "0.00"
        str_CouponDiscount = ""
        taxableCouponTotal = 0.0
        crossButton.isHidden = true
        calculateTotalCart()
    }
    
    func didSelectCustomer(data: CustomerListModel) {
        selectedCustomerData(customerdata: data)
    }
}

//MARK: AddNewCutomerViewControllerDelegate
extension CartContainerViewController: AddNewCutomerViewControllerDelegate {
    func didAddNewCustomer(data: CustomerListModel) {
        self.updateCustomerData()
        
        if CustomerObj.str_first_name == "" && CustomerObj.str_last_name == "" {
            lbl_CustomerName.text = "Customer #" + CustomerObj.str_userID
            
        }else{
            lbl_CustomerName.text = CustomerObj.str_first_name + " " + CustomerObj.str_last_name
        }
        icon_AddCustomer.image = #imageLiteral(resourceName: "edit-icon1")
        
        calculateTotalCart()
        self.catAndProductDelegate?.hideView?(with: "addnewcustomerCancelIPAD")
    }
}

//MARK: ResetCartDelegate
extension CartContainerViewController: ResetCartDelegate {
    func updateCart(with isRefundProduct: Bool, data: JSONDictionary?) {
        self.orderType = isRefundProduct ? .refundOrExchangeOrder : .newOrder
        if isRefundProduct {
            //            if let obj = data?["data"] as? OrderInfoModel {
            //                self.parseRefundOrderData(obj: obj)
            //            }
            let obj = data?["data"] as? OrderInfoModel
            if  (obj != nil) {
                self.parseRefundOrderData(obj: obj!)
            }
            
            // let totalObj = Int((obj?.total)!)
            
            
            if self.TotalPrice > 0 {
                self.btn_Pay?.setTitle("Refund/Exchange", for: .normal)
            }else{
                if DataManager.isshippingRefundOnly {
                    self.btn_Pay?.setTitle("Refund/Exchange", for: .normal)

                } else {
                    self.btn_Pay?.setTitle("Refund/Exchange" + "(" + (obj?.paymentMethod)! + ")", for: .normal)

                }
            }
            
            //self.totalNameLabel.text = "Total to be Charge/Refund"
            if self.str_showShipOrderInPos == "true" || self.lbl_ShippingAndHandling.text != "$0.00" {
                if str_showShipOrderInPos == "true" {
                    self.shippingRefundButton.isHidden = false
                }else{
                    self.shippingRefundButton.isHidden = true
                    if self.orderType == .refundOrExchangeOrder {
                      if  self.lbl_ShippingAndHandling.text != "$0.00" {
                            self.shippingRefundButton.isHidden = false
                          self.shippingRefundButton.setTitle("Refund", for: .normal)
                        }
                    }
                }
                self.shippingRefundButton.setTitle("Refund", for: .normal)
            }else{
                self.shippingRefundButton.isHidden = true
            }
            self.view_AddCustomer.isHidden = true
            self.applyCouponView.isHidden = true
            self.isShippingPriceChanged = false
            self.tbl_Cart.reloadData()
        }else {
            resetHomeCart()
        }
    }
    
    func resetHomeCart() {
        self.view.endEditing(true)
        
        self.viewTip.isHidden = true
        if let val = DataManager.showShipOrderInPos {
            self.str_showShipOrderInPos = val
        }
        //self.str_showShipOrderInPos = DataManager.showShipOrderInPos!
        self.totalNameLabel.text = "Total"
        
        if versionOb < 4 {
            self.shippingRefundButton.isHidden = true
        } else {
            if self.str_showShipOrderInPos == "true" || self.lbl_ShippingAndHandling.text != "$0.00"{
                if str_showShipOrderInPos == "true" {
                    self.shippingRefundButton.isHidden = false
                }else{
                    self.shippingRefundButton.isHidden = true
                }
                
                if orderType == .refundOrExchangeOrder {
                    self.shippingRefundButton.setTitle("Refund", for: .normal)
                } else {
                    self.shippingRefundButton.setTitle("Ship Order", for: .normal)
                }
                
                //self.shippingRefundButton.setTitle("Ship Order", for: .normal)
            }else{
                self.shippingRefundButton.isHidden = true
            }
        }
        
        
        if DataManager.isCaptureButton == true {
            self.btn_Pay?.setTitle("Capture", for: .normal)
        } else {
            self.btn_Pay?.setTitle("Payment", for: .normal)
        }
        
        //self.btn_Pay?.setTitle("Payment", for: .normal)
        self.applyCouponView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            self.view_AddCustomer.isHidden = true
        }else {
            self.view_AddCustomer.isHidden = !DataManager.isCustomerManagementOn || orderType == .refundOrExchangeOrder
        }
        
        if self.orderType == .newOrder {
            if let cartArray = DataManager.cartProductsArray {
                self.cartProductsArray = cartArray
            }
        }else {
            self.cartProductsArray.removeAll()
            appDelegate.strPaymentType = ""
            PaymentsViewController.paymentDetailDict.removeAll()
            DataManager.cartProductsArray = self.cartProductsArray
        }
        
        self.orderType = .newOrder
        self.tbl_Cart.reloadData()
        self.calculateTotalCart()
    }
    
    func resetCart() {
        self.view.endEditing(true)
        CartContainerViewController.updatedProductIndex = nil
        isDefaultTaxChanged = false
        isDefaultTaxSelected = false
        isCoupanApplyOnAllProducts = false
        //taxTitle = "Default"
        //DataManager.defaultTaxID = "Default"
        PaymentsViewController.paymentDetailDict.removeAll()
        self.resetCartData()
        self.tbl_Cart.reloadData()
        self.calculateTotalCart()
        self.getTaxListService()
        if DataManager.isCouponList {
            self.callAPIToGetCouponList()
        }
    }
}

//MARK: SwipeAndSearchDelegate
extension CartContainerViewController: SwipeAndSearchDelegate {
    func didSearchingProduct() {
        print("Searching")
    }
    
    func didSearchedProduct(product: ProductsModel) {
        self.editProductDelegate?.didSelectProduct?(with: "productDetails")
        self.editProductDelegate?.didReceiveProductDetail?(data: product)
        self.calculateTotalCart()
    }
    
    func noProductFound() {
        print("no product found")
//        self.showAlert(message: "No Product Found.")
        appDelegate.showToast(message: "No Product Found.")
        self.editProductDelegate?.hideDetailView?()
    }
    
    func didGetCardDetail() {
        //appDelegate.showToast(message: "enter value swiper3")
        self.moveNextScreen()
    }
    
    func didGetCardDetail(number: String, month: String, year: String) {
        //appDelegate.showToast(message: "enter value swiper2")
        self.moveNextScreen()
    }
    
    func noCardDetailFound() {
        isCreditCardNumberDetected = false
    }
    
    func moveNextScreen() {
        isCreditCardNumberDetected = true
        self.updateCustomerData()
        CartContainerViewController.isPickerSelected = false
        if let array = DataManager.selectedPayment {
            if !array.contains("CREDIT") {
//                self.showAlert(message: "Please add payment method credit card from Settings.")
                appDelegate.showToast(message: "Please add payment method credit card from Settings.")
                return
            }
        }
        if self.cartProductsArray.count > 0 {
            PaymentsViewController.paymentDetailDict.removeAll()
            
            if DataManager.isSwipeToPay {
                
                self.prepareOrder()
            }else {
                if TotalPrice > 0 {
                    self.handlePayButtonAction()
                }
            }
        }else {
//            self.showAlert(message: "Please add atleast one product in cart for make payment.")
            appDelegate.showToast(message: "Please add atleast one product in cart for make payment.")
        }
    }
}

//MARK: AddDiscountPopupVCDelegate
extension CartContainerViewController: AddDiscountPopupVCDelegate {
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
        if(UI_USER_INTERFACE_IDIOM() == .pad){
            self.showApplyCouponIPad()
        }
        else
        {
            self.showApplyCouponIphone()
        }
    }
}

//MARK: UIPopoverControllerDelegate
extension CartContainerViewController {
    override func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        cartViewDelegate?.didUpdateView(with: UIScreen.main.bounds.size.height)
        self.cartViewDelegate?.didHideView(with: "customviewhide")
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
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        cartViewDelegate?.didUpdateView(with: UIScreen.main.bounds.size.height)
        self.cartViewDelegate?.didHideView(with: "customviewunhide")
    }
    
}

//MARK: iPad_PaymentTypesViewControllerDelegate
extension CartContainerViewController: iPad_PaymentTypesViewControllerDelegate {
    func didUpdateShippingRefund(isselected: Bool) {
        shippingRefundButton.isSelected = isselected
        calculateTotalCart()
    }
    
    func didResetCart() {
        PaymentsViewController.paymentDetailDict.removeAll()
        self.resetCartData()
    }
    func didAddShippingRate(rate: String){
        handleShippingAddRate(shiipingRate: rate)
    }
    
    func didUpdateCoupon(name: String, amount: Double) {
        self.str_CouponDiscount = amount.roundToTwoDecimal
        self.str_AddCouponName = name
        if name == "" && amount == 0.0 {
            self.resetCoupan()
        }
    }
    
    func didUpdateManualDiscount(amount: Double, isPercentage: Bool) {
        self.str_AddDiscount = "\(amount)"
        self.lbl_AddDiscount.text = amount.currencyFormat
        self.calculateTotalCart()
    }
    
    func didUpdateTax(amount: Double, type: String, title: String) {
        taxTitle = title
        taxType = type
        taxAmountValue = amount.roundToTwoDecimal
        isDefaultTaxChanged = true
        isDefaultTaxSelected = false
        self.lbl_TaxStateName?.text = "Tax (\(title))"
    }
    
    func didUpdateShipping(amount: Double) {
        self.str_ShippingANdHandling = amount.roundToTwoDecimal
        let shipping = amount
        self.lbl_ShippingAndHandling.text = shipping.currencyFormat
        self.isShippingPriceChanged = true
        self.calculateTotalCart()
    }
    
    func didUpdateCustomer(data: CustomerListModel) {
        selectedCustomerData(customerdata: data)
    }
    
}

//MARK: OfflineDataManagerDelegate
extension CartContainerViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        self.updatePaymentMethods()
        self.controller?.dismiss(animated: true, completion: nil)
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            self.view_AddCustomer.isHidden = true
            self.CustomerObj = CustomerListModel()
            UserDefaults.standard.removeObject(forKey: "isCheckUncheckShippingBilling")
            //UserDefaults.standard.removeObject(forKey: "CustomerObj")
            //UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
            UserDefaults.standard.synchronize()
            PaymentsViewController.paymentDetailDict.removeAll()
            lbl_CustomerName.text = "Add Customer"
            //lbl_CustomerName.text = "Customer #"
            icon_AddCustomer.image = #imageLiteral(resourceName: "add-button-inside-black-circle")
        }else {
            self.view_AddCustomer.isHidden = !DataManager.isCustomerManagementOn || orderType == .refundOrExchangeOrder
        }
        
        if DataManager.isOffline {
            self.taxView.isHidden = !isOn
            self.shippingView.isHidden = !isOn
            self.applyCouponView.isHidden = !isOn
            if !isOn {
                self.resetCoupan()
            }
        }
        
        if isOn {
            self.calculateTotalCart()
            self.getTaxListService()
            if DataManager.isCouponList {
                self.callAPIToGetCouponList()
            }
        }
        
        self.addDiscountView.isHidden = orderType == .refundOrExchangeOrder
        if DataManager.posDisableDiscountFeature == "true" {
            self.addDiscountView.isHidden = true
        }
    }
}

//MARK: API Methods
extension CartContainerViewController {
    func prepareOrder() {
        if orderType == .refundOrExchangeOrder {
            if TotalPrice > 0 {
                self.prepareOrderForExchange()
            }
            return
        }
        
        if isOrderPrepare {
            return
        }
        
        var cust_str_postal = ""
        if CustomerObj.str_postal_code != "" {
            cust_str_postal = phoneNumberFormateRemoveText(number: CustomerObj.str_postal_code)
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
        
        self.isOrderPrepare = true
        //Disable Swipe Reader
        self.view.endEditing(true)
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        SwipeAndSearchVC.shared.imagReadLib?.stop()
        SwipeAndSearchVC.delegate = nil
        
        //Device Name
        var str_DeviceName = deviceName
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        
        var dict = [String: Any]()
        var productsArray = Array<Any>()
        var isAllManualProducts = [Bool]()
        
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
            
            var variationsArray = JSONArray()
            
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
            }
            
            //            if let productDetailArray = (obj as AnyObject).value(forKey: "attributesArray") as? JSONArray {
            //
            //                let productDetail = ProductModel.shared.getProductDetailStruct(jsonArray: productDetailArray)
            //                for i in 0..<productDetail.count {      //DDD
            //                    let arrayData  = productDetail[i].valuesAttribute as [AttributesModel] as NSArray
            //                    let attributeModel = arrayData[0] as! AttributesModel
            //                    let jsonArray = attributeModel.jsonArray
            //                    if let hh = jsonArray {
            //                        let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
            //                        //print(arrayAttrData)
            //
            //                        for value in arrayAttrData {
            //
            //                            if value.isSelect {
            //                                var variationsDict = JSONDictionary()
            //                                variationsDict["variation_id"] = "0"
            //                                variationsDict["attribute_id"] = value.attribute_id
            //                                variationsDict["attribute_value_id"] = value.attribute_value_id
            //                                //selectedIDArray.append(Int(value.attribute_value_id) ?? 0)
            //                                variationsArray.append(variationsDict)
            //                            }
            //                        }
            //                    }
            //                }
            //
            //
            //
            ////                let productDetail = ProductModel.shared.getProductDetailStruct(jsonArray: productDetailArray)
            ////                for detail in productDetail {
            //////                    for value in detail.values { //DDD
            //////                        if value.isSelected {
            //////                            var variationsDict = JSONDictionary()
            //////                            variationsDict["variation_id"] = value.variationId
            //////                            variationsDict["attribute_id"] = value.attributeId
            //////                            variationsDict["attribute_value_id"] = value.attributeValueId
            //////                            variationsArray.append(variationsDict)
            //////                        }
            //////                    }
            ////                }
            //            }
            let value = getVariationValueForProduct(attributeObj: attributeArrayDetails, variationObj: variationArrayDetails, surchargeObj: surchargvariationArrayDetails)
            
            dict["variations"] = value
            var metaFieldsDict = JSONDictionary()
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
        
        let taxID = self.taxTitle == "Default" ? DataManager.defaultTaxID : self.taxTitle
        let starMacAddrs = DataManager.isGooglePrinter ? DataManager.starCloudMACaAddress ?? "" : ""
        //Prepare Parameters For Create Order
        var parameters: Parameters = [
            "cust_id": CustomerObj.str_userID,
            "customer_status": CustomerObj.str_customer_status,
            "custom_text_1": CustomerObj.str_CustomText1,
            "custom_text_2": CustomerObj.str_CustomText2,
            "customer_info": [
                "first_name": CustomerObj.str_first_name,
                "last_name": CustomerObj.str_last_name,
                "email": CustomerObj.str_email,
                "phone": cust_str_phone,
                "address": CustomerObj.str_address,
                "address2": CustomerObj.str_address2,
                "city": CustomerObj.str_city,
                "state": CustomerObj.str_region,
                "zip":cust_str_postal,
                "country": CustomerObj.country,
                "office_phone":CustomerObj.str_office_phone,
                "contact_source": CustomerObj.str_contact_source,
                "company":CustomerObj.str_company,
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
                "bill_phone": cust_str_Billingphone
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
                "coupon": str_AddCouponName,
                "products": productsArray,
                "subtotal": SubTotalPrice.roundToTwoDecimal,
                "discount": "",
                "manual_discount": self.str_AddDiscount,
                "shipping_handling": str_ShippingANdHandling,
                "tax": "",
                "custom_tax_id": taxID,
                "total": TotalPrice.roundToTwoDecimal,
                "sub_action" : strSubscriptionValue
            ],
            "merchant_id": "",
            "payment_type": "credit",
            "payment_method": "AUTH_CAPTURE",
            "credit": [
                "cc_account": SwipeAndSearchVC.shared.cardData.number ?? "",
                "cc_exp_mo": SwipeAndSearchVC.shared.cardData.month ?? "",
                "cc_exp_yr": SwipeAndSearchVC.shared.cardData.year ?? "",
                "cc_cvv": "",
                "tip": "",
                "total": "",
                "digital_signature": ""
            ],
            "cash": [
                "amount": "",
                "tip": "",
                "total": ""
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
                "dl_state": "",
                "check_type": "",
                "sec_code": "",
                "account_type": "",
                "tip": "",
                "total": ""
            ],
            "gift_card": [
                "gift_card_number": "",
                "gift_card_pin": "",
                "tip": "",
                "total": ""
            ],
            "external_gift": [
                "gift_card_number": "",
                "tip": "",
                "total": ""
            ],
            "internal_gift_card": [
                "gift_card_number": "",
                "tip": "",
                "total": ""
            ],
            "multi_card": "",
            "check": [
                "check_amount": "",
                "check_number": "",
                "tip": "",
                "total": ""
            ],
            "external": [
                "external_amount": "",
                "tip": "",
                "total": ""
            ],
            "pax_pay": [
                "pax_payment_type": "",
                "pax_url": "",
                "device_name": "",
                "tip": "",
                "amount": "",
                "pax_pay_receipt" : DataManager.isSingatureOnEMV
            ],
            "order_source": str_DeviceName,
            "digital_signature": "",
            "orderId": 0,
            "notes": "",
            "campaign_code": "",
            "sub_id": "",
            "crm_partner_order_id": "",
            "enable_split_row": DataManager.isSplitRow,
            "isOfflineTransction" : false,
            "cloud_printer_app_status" : DataManager.isGooglePrinter,
            "cloud_printer_address" : starMacAddrs
        ]
        
        let newOrderData = parameters.filter({$0.key == "cust_id" || $0.key == "customer_info" || $0.key == "bill_profile_id" || $0.key == "billing_info" || $0.key == "shipping_info" || $0.key == "is_billing_same" || $0.key == "cart_info" || $0.key == "order_source" || $0.key == "notes" })
        
        if newOrderData == DataManager.recentOrder {
            if let recentOrderID = DataManager.recentOrderID {
                parameters["orderId"] = recentOrderID
            }
        }
        
        UserDefaults.standard.removeObject(forKey: "changeAmountKey")
        UserDefaults.standard.synchronize()
        
        print("****************************************************** Order Parameters Start ******************************************************")
        print(parameters)
        print("****************************************************** Order Parameters End ******************************************************")
        
        //Call API To Make Order
        self.callAPIToCreateOrder(parameters: parameters, isInvoice: false, isAllManualProducts: !isAllManualProducts.contains(false))
    }
    
    func prepareOrderForCapture() {
        //Disable Swipe Reader
        self.view.endEditing(true)
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        SwipeAndSearchVC.shared.imagReadLib?.stop()
        SwipeAndSearchVC.delegate = nil
        
        var cust_str_postal = ""
        if CustomerObj.str_postal_code != "" {
            cust_str_postal = phoneNumberFormateRemoveText(number: CustomerObj.str_postal_code)
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
        var str_DeviceName = deviceName
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        
        var dict = [String: Any]()
        var productsArray = Array<Any>()
        var isAllManualProducts = [Bool]()
        
        //Load Products
        for i in (0..<self.cartProductsArray.count)
        {
            let obj = (cartProductsArray as AnyObject).object(at: i)
            dict["product_id"] = (obj as AnyObject).value(forKey: "productid") as! String
            let isRefundProduct = (obj as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
            if isRefundProduct {
                dict["man_price"] = Double((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0).roundToTwoDecimal
                dict["qty"] = (obj as AnyObject).value(forKey: "productqty") as? Double ?? 1
                dict["title"] = (obj as AnyObject).value(forKey: "producttitle") as? String ?? ""
                dict["is_taxable"] = (obj as AnyObject).value(forKey: "is_taxable") as? String ?? ""
                dict["isRefunded"] = false
                dict["is_refund_item"] = true
                
                dict["sales_id"] = (obj as AnyObject).value(forKey: "salesID") as? String ?? ""
                //dict["selectionInventory"] = (obj as AnyObject).value(forKey: "selectionInventory") as? String ?? ""
                dict["backToStock"] = (obj as AnyObject).value(forKey: "returnToStock") as? Bool ?? false
            } else {
                dict["man_price"] = Double((obj as AnyObject).value(forKey: "productprice") as! String)?.roundToTwoDecimal
                dict["qty"] = (obj as AnyObject).value(forKey: "productqty") as! String
            }
            
            dict["row_id"] = i + 1
            dict["manual_description"] = (obj as AnyObject).value(forKey: "productNotes") as? String ?? ""
            let isTaxExempt = ((obj as AnyObject).value(forKey: "isTaxExempt") as? String ?? "No").lowercased()
            dict["tax_exempt"] = isTaxExempt == "no" ? false : true
            let isManualProduct = (obj as AnyObject).value(forKey: "isManualProduct") as? Bool ?? false
            isAllManualProducts.append(isManualProduct)
            
            var variationsArray = JSONArray()
            
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
            }
            
            let value = getVariationValueForProduct(attributeObj: attributeArrayDetails, variationObj: variationArrayDetails, surchargeObj: surchargvariationArrayDetails)
            
            dict["variations"] = value
            var metaFieldsDict = JSONDictionary()
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
        
        let taxID = self.taxTitle == "Default" ? DataManager.defaultTaxID : self.taxTitle
        
        var shipping = Double(self.str_ShippingANdHandling) ?? 0
        if orderType == .refundOrExchangeOrder {
            shipping =  self.shippingRefundButton.isSelected ? -shipping : shipping
        }
        
        if let val = DataManager.OrderDataModel?["str_paymentMethod"] {
            selectPaymentMethodValue = val as! String
        }
        
        var cardNumberVal = ""
        var cardYearVal = ""
        var cardMonthVal = ""
        var orderIdVal = ""
        if let cardNumber = DataManager.OrderDataModel?["str_cardNumber"] {
            cardNumberVal = cardNumber as! String
            print(cardNumberVal)
        }
        
        if let cardYear = DataManager.OrderDataModel?["str_cardYear"] {
            cardYearVal = cardYear as! String
            print(cardYearVal)
        }
        
        if let cardMonth = DataManager.OrderDataModel?["str_cardMonth"] {
            cardMonthVal = cardMonth as! String
            print(cardMonthVal)
        }
        
        if let orderId = DataManager.OrderDataModel?["str_OrderId"] {
            orderIdVal = orderId as! String
        }
        
        
        //Prepare Parameters For Create Order
        var parameters: Parameters = [
            "cust_id": CustomerObj.str_userID,
            "smartlist_id": "",
            "customer_status": CustomerObj.str_customer_status,
            "customer_info": [
                "first_name": CustomerObj.str_first_name,
                "last_name": CustomerObj.str_last_name,
                "email": CustomerObj.str_email,
                "phone": cust_str_phone,
                "address": CustomerObj.str_address,
                "address2": CustomerObj.str_address2,
                "city": CustomerObj.str_city,
                "state": CustomerObj.str_region,
                "zip":cust_str_postal,
                "company":CustomerObj.str_company,
                "country": CustomerObj.country,
                "office_phone": CustomerObj.str_office_phone,
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
                "subtotal": SubTotalPrice.roundToTwoDecimal,
                "discount": "",
                "manual_discount": self.str_AddDiscount,
                "shipping_handling": shipping.roundToTwoDecimal,
                "tax": "",
                "custom_tax_id": taxID,
                "total": TotalPrice.roundToTwoDecimal,
                "sub_action" : strSubscriptionValue
            ],
            "merchant_id": "",
            "payment_type": selectPaymentMethodValue,
            "payment_method": "CAPTURE",
            "custom_text_1": CustomerObj.str_CustomText1,
            "custom_text_2": CustomerObj.str_CustomText2,
            "credit": [
                "cc_account": "************\(cardNumberVal)" ,
                "cc_exp_mo": cardMonthVal ,
                "cc_exp_yr": cardYearVal ,
                "cc_cvv": "",
                "tip": "",
                "total": "",
                "digital_signature": ""
            ],
            "cash": [
                "amount": "",
                "tip": "",
                "total": ""
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
                "dl_state": "",
                "check_type": "",
                "sec_code": "",
                "account_type": "",
                "tip": "",
                "total": ""
            ],
            "gift_card": [
                "gift_card_number": "",
                "gift_card_pin": "",
                "tip": "",
                "total": ""
            ],
            "external_gift": [
                "gift_card_number": "",
                "tip": "",
                "total": ""
            ],
            "internal_gift_card": [
                "gift_card_number": "",
                "tip": "",
                "total": ""
            ],
            "multi_card": "",
            "check": [
                "check_amount": "",
                "check_number": "",
                "tip": "",
                "total": ""
            ],
            "external": [
                "external_amount": "",
                "tip": "",
                "total": ""
            ],
            "pax_pay": [
                "pax_payment_type": "",
                "pax_url": "",
                "device_name": "",
                "tip": "",
                "amount": "",
                "pax_pay_receipt" : DataManager.isSingatureOnEMV
            ],
            "isOrderRefund": false,
            "order_source": str_DeviceName,
            "digital_signature": "",
            "orderId": orderIdVal,
            "notes": "",
            "campaign_code": "",
            "sub_id": "",
            "crm_partner_order_id": "",
            "enable_split_row": DataManager.isSplitRow,
            "isOfflineTransction" : false
        ]
        
        let newOrderData = parameters.filter({$0.key == "cust_id" || $0.key == "customer_info" || $0.key == "bill_profile_id" || $0.key == "billing_info" || $0.key == "shipping_info" || $0.key == "is_billing_same" || $0.key == "cart_info" || $0.key == "order_source" || $0.key == "notes" })
        
        if newOrderData == DataManager.recentOrder {
            if let recentOrderID = DataManager.recentOrderID {
                parameters["orderId"] = recentOrderID
            }
        }
        
        UserDefaults.standard.removeObject(forKey: "changeAmountKey")
        UserDefaults.standard.synchronize()
        
        print("****************************************************** Order Parameters Start ******************************************************")
        print(parameters)
        print("****************************************************** Order Parameters End ******************************************************")
        
        //Call API To Make Order
        self.callAPIToCreateOrder(parameters: parameters, isInvoice: false, isAllManualProducts: !isAllManualProducts.contains(false))
    }
    
    func prepareOrderForExchange() {
        //Disable Swipe Reader
        self.view.endEditing(true)
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        SwipeAndSearchVC.shared.imagReadLib?.stop()
        SwipeAndSearchVC.delegate = nil
        
        
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
        
        
        //Device Name
        var str_DeviceName = deviceName
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        
        var dict = [String: Any]()
        var productsArray = Array<Any>()
        var productsArrayTemp = Array<Any>()
        var isAllManualProducts = [Bool]()
        self.isSelectEMVPayment = false

        //Load Products
        for i in (0..<self.cartProductsArray.count)
        {
            
            
            let obj = (cartProductsArray as AnyObject).object(at: i)
            dict["product_id"] = (obj as AnyObject).value(forKey: "productid") as! String
            let isRefundProduct = (obj as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
            if isRefundProduct {
                let manPriceData = (Double((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0) + ((obj as AnyObject).value(forKey: "per_product_tax") as? Double ?? 0)) - ((obj as AnyObject).value(forKey: "per_product_discount") as? Double ?? 0)
                dict["base_price"] = "\((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0)"
                dict["man_price"] = manPriceData.roundToTwoDecimal
                dict["price"] = "\((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0)"
                dict["qty"] = "\((obj as AnyObject).value(forKey: "available_qty_refund") as? Double ?? 1)"
                dict["title"] = (obj as AnyObject).value(forKey: "producttitle") as? String ?? ""
                dict["is_taxable"] = (obj as AnyObject).value(forKey: "is_taxable") as? String ?? ""
                //dict["actual_qty"] = -((obj as AnyObject).value(forKey: "actualproductqty") as? Double ?? 1)
                dict["isRefunded"] = false
                dict["is_refund_item"] = true
                dict["product_condition"]  = (obj as AnyObject).value(forKey: "selectionInventory") as? String ?? ""
                dict["sales_id"] = (obj as AnyObject).value(forKey: "salesID") as? String ?? ""
                //dict["selectionInventory"] = (obj as AnyObject).value(forKey: "selectionInventory") as? String ?? ""
                dict["backToStock"] = (obj as AnyObject).value(forKey: "returnToStock") as? Bool ?? false
            } else {
                dict["man_price"] = Double((obj as AnyObject).value(forKey: "productprice") as! String)?.roundToTwoDecimal
                dict["qty"] = (obj as AnyObject).value(forKey: "productqty") as! String
            }
            dict["per_product_discount"] = (obj as AnyObject).value(forKey: "per_product_discount") as? Double ?? 0
            dict["per_product_tax"] = (obj as AnyObject).value(forKey: "per_product_tax") as? Double ?? 0
            
            dict["row_id"] = "\(i + 1)"
            dict["manual_description"] = (obj as AnyObject).value(forKey: "productNotes") as? String ?? ""
            let isTaxExempt = ((obj as AnyObject).value(forKey: "isTaxExempt") as? String ?? "No").lowercased()
            //dict["tax_exempt"] = isTaxExempt == "no" ? false : true
            let isManualProduct = (obj as AnyObject).value(forKey: "isManualProduct") as? Bool ?? false
            isAllManualProducts.append(isManualProduct)
            
            var variationsArray = JSONArray()
            
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
            }
            
            //            if let productDetailArray = (obj as AnyObject).value(forKey: "attributesArray") as? JSONArray {
            //                let productDetail = ProductModel.shared.getProductDetailStruct(jsonArray: productDetailArray)
            //                for i in 0..<productDetail.count {      //DDD
            //                    let arrayData  = productDetail[i].valuesAttribute as [AttributesModel] as NSArray
            //                    let attributeModel = arrayData[0] as! AttributesModel
            //                    let jsonArray = attributeModel.jsonArray
            //                    if let hh = jsonArray {
            //                        let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
            //                        //print(arrayAttrData)
            //
            //                        for value in arrayAttrData {
            //
            //                            if value.isSelect {
            //                                var variationsDict = JSONDictionary()
            //                                variationsDict["variation_id"] = "0"
            //                                variationsDict["attribute_id"] = value.attribute_id
            //                                variationsDict["attribute_value_id"] = value.attribute_value_id
            //                                //selectedIDArray.append(Int(value.attribute_value_id) ?? 0)
            //                                variationsArray.append(variationsDict)
            //                            }
            //                        }
            //                    }
            //                }
            //
            ////                    for value in detail.values {  //DDD
            ////                        if value.isSelected {
            ////                            var variationsDict = JSONDictionary()
            ////                            variationsDict["variation_id"] = value.variationId
            ////                            variationsDict["attribute_id"] = value.attributeId
            ////                            variationsDict["attribute_value_id"] = value.attributeValueId
            ////                            variationsArray.append(variationsDict)
            ////                        }
            ////                    }
            //
            //                }
            
            let value = getVariationValueForProduct(attributeObj: attributeArrayDetails, variationObj: variationArrayDetails, surchargeObj: surchargvariationArrayDetails)
            
            dict["variations"] = value
            var metaFieldsDict = JSONDictionary()
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
            if isRefundProduct {
                if let metaFields = (obj as AnyObject).value(forKey: "meta_fieldsDictionary") as? JSONDictionary {
                    metaFieldsDict = metaFields
                }
            }
            dict["meta_fields"] = metaFieldsDict
            productsArray.append(dict)
        }
        
        let taxID = self.taxTitle == "Default" ? DataManager.defaultTaxID : self.taxTitle
        
        var shipping = Double(self.str_ShippingANdHandling) ?? 0
        var tipAmtVal = Double(appDelegate.tipRefundOnly) ?? 0
        if orderType == .refundOrExchangeOrder {
            shipping =  self.shippingRefundButton.isSelected ? -shipping : shipping
            tipAmtVal =  self.btnTipSelect.isSelected ? -tipAmtVal : tipAmtVal
        }
        
        var dictOne = [String: Any]()
        var productsArrayOne = Array<Any>()
        
        for i in 0..<orderInfoObj.transactionArray.count
        {
            //let indexPath = IndexPath(item: i, section: 0)
            //let cellindex = self.collectionPayExchange?.cellForItem(at: indexPath) as? AddPaymentCollectionCell
            
//            for j in 0..<arrPaxDeviceData.count
//            {
//                let  datavv = arrPaxDeviceData[j] as? NSDictionary
//
//                let name = datavv?.value(forKey: "strName")
//
//                let port = datavv?.value(forKey: "strPort")
//
//                print(name)
//
//            }
            
            if orderInfoObj.transactionArray[i].isSelectedRefund  {
                var port = ""
                var name = ""
                if orderInfoObj.transactionArray[i].cardType == "EMV" {
                    
                    let paxval = arrTempPaxDeviceData[i] as? NSDictionary
                    
                    let nm = paxval?.value(forKey: "strName") as! String
                    
                    for k in 0..<arrPaxDeviceData.count {
                        let  datavv = arrPaxDeviceData[k] as? NSDictionary
                        
                        let mn = datavv?.value(forKey: "strName") as! String
                        
                       // if mn == nm {
                            if  orderInfoObj.transactionArray[i].show_pax_device {
                                self.isSelectEMVPayment = true
                                if mn == nm {
                                    name = datavv?.value(forKey: "strName") as! String
                                    port = datavv?.value(forKey: "strPort") as! String
                                }
                            }else {
                                name = ""
                                port = ""
                            }
                       // }
                    }
                    
                }
                
                //dictOne["IsFullRefund"] = orderInfoObj.transactionArray[i].paymentType
                //dictOne["IsPartialRefund"] = false
                //dictOne["IsSelection"] = false
                //dictOne["IsShownCancelBtn"] = false
                dictOne["amount"] = orderInfoObj.transactionArray[i].availableRefundAmount
                //dictOne["editTextFocus"] = false
                //dictOne["fullRefundAmount"] = "0"
                //dictOne["isRefund"] = false
                //dictOne["isVoid"] = false
                //dictOne["isVoidClick"] = false
                //dictOne["partialEditTextValue"] = ""
                //dictOne["refund_amount"] = "0"
                //dictOne["selectedCardType"] = orderInfoObj.transactionArray[i].cardType
                dictOne["gift_card_number"] = txfInternalGiftCardNumber.text
                dictOne["transaction_type"] = orderInfoObj.transactionArray[i].type
                dictOne["terminal_port"] = port
                dictOne["device_name"] = name
                dictOne["txnID"] = orderInfoObj.transactionArray[i].txnId
                
                if orderInfoObj.transactionArray[i].txnId == "" && orderInfoObj.transactionArray[i].type == "STORE_CREDIT" {
                    if txfInternalGiftCardNumber.text == "" {
//                        self.showAlert(message: "Please Enter Gift Card Number")
                        appDelegate.showToast(message: "Please Enter Gift Card Number")
                        return
                    }
                }
                //dictOne["voidRefundValue"] = "0"
                productsArrayOne.append(dictOne)
            }
        }
        //{txnID: "108334", amount: "30.85", transaction_type: "credit", gift_card_number: ""}
        
        //Prepare Parameters For Create Order
        
        var parameters: Parameters = [:]
        let starMacAddrs = DataManager.isGooglePrinter ? DataManager.starCloudMACaAddress ?? "" : ""

        if DataManager.isshippingRefundOnly || DataManager.isTipRefundOnly {
            parameters = [
                "cust_id": orderInfoObj.userID,
                "customer_status": CustomerObj.str_customer_status,
                "custom_text_1": CustomerObj.str_CustomText1,
                "custom_text_2": CustomerObj.str_CustomText2,
                "customer_info": [
                    "first_name": orderInfoObj.firstName,
                    "last_name": orderInfoObj.lastName,
                    "email": orderInfoObj.email,
                    "phone": ord_str_phone,
                    "address": orderInfoObj.addressLine1,
                    "address2": orderInfoObj.addressLine2,
                    "city": orderInfoObj.city,
                    "state": orderInfoObj.region,
                    "zip":ord_str_postal,
                    "country": CustomerObj.country,
                    "office_phone":CustomerObj.str_office_phone,
                    "contact_source": CustomerObj.str_contact_source,
                    "company":CustomerObj.str_company,

                ],
                "bill_profile_id": orderInfoObj.bpId,
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
                    "bill_phone": ord_str_phone
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
                    "coupon": "",
                    "products": productsArrayTemp,
                    "subtotal": 0.0,
                    "discount": "",
                    "manual_discount": "",
                    "shipping_handling": appDelegate.shippingRefundOnly,
                    "tip": appDelegate.tipRefundOnly,
                    "tax": "",
                    "custom_tax_id": taxID,
                    "total": 0.0,
                    "sub_action" : strSubscriptionValue
                ],
                "merchant_id": orderInfoObj.merchantId,
                "payment_type": TotalPrice == 0 ? "cash" : selectPaymentMethodValue,
                "payment_method": "",//TotalPrice > 0 ? "AUTH_CAPTURE" : "CAPTURE",
                "credit": [
                    "cc_account": TotalPrice > 0 ? (SwipeAndSearchVC.shared.cardData.number ?? "") : "" ,
                    "cc_exp_mo": TotalPrice > 0 ? (SwipeAndSearchVC.shared.cardData.month ?? "") : "" ,
                    "cc_exp_yr": TotalPrice > 0 ? (SwipeAndSearchVC.shared.cardData.year ?? "") : "" ,
                    "cc_cvv": "",
                    "tip": "",
                    "total": "",
                    "digital_signature": ""
                ],
                "cash": [
                    "amount": "",
                    "tip": "",
                    "total": ""
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
                    "dl_state": "",
                    "check_type": "",
                    "sec_code": "",
                    "account_type": "",
                    "tip": "",
                    "total": ""
                ],
                "gift_card": [
                    "gift_card_number": "",
                    "gift_card_pin": "",
                    "tip": "",
                    "total": ""
                ],
                "external_gift": [
                    "gift_card_number": TotalPrice > 0 ? "" : str_externalGiftCardNumber,
                    "tip": "",
                    "total": ""
                ],
                "internal_gift_card": [
                    "gift_card_number": TotalPrice > 0 ? "" : str_internalGiftCardNumber,
                    "tip": "",
                    "total": ""
                ],
                "multi_card": "",
                "check": [
                    "check_amount": "",
                    "check_number": "",
                    "tip": "",
                    "total": ""
                ],
                "external": [
                    "external_amount": "",
                    "tip": "",
                    "total": ""
                ],
                "pax_pay": [
                    "pax_payment_type": "",
                    "pax_url": TotalPrice > 0 ? "" : str_paxUrl,
                    "device_name": TotalPrice > 0 ? "" : str_addDeviceName,
                    "tip": "",
                    "amount": "",
                    "pax_pay_receipt" : DataManager.isSingatureOnEMV
                ],
                "isOrderRefund": true,
                "order_source": str_DeviceName,
                "isPartialRefund": false,
                "isShippingRefund": DataManager.isshippingRefundOnly,
                "isTipRefund": DataManager.isTipRefundOnly,
                "digital_signature": "",
                "orderId": orderInfoObj.orderID,
                "notes": "",
                "campaign_code": "",
                "sub_id": "",
                "crm_partner_order_id": "",
                "enable_split_row": DataManager.isSplitRow,
                "transactionsList": productsArrayOne,
                "isOfflineTransction" : false,
                "cloud_printer_app_status" : DataManager.isGooglePrinter,
                "cloud_printer_address" : starMacAddrs
            ]
        } else {
            var isfull = true
//            for i in 0..<cartProductsArray.count {
//                let cart = cartProductsArray[i]
//                let isRefundProduct = (cart as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
//                if !isRefundProduct {
//                    isfull = false
//                }
//            }
            
            if lblRefundTotalRemaining.text == "$0.00" {
                isfull = false
            } else {
                
                if TotalPrice < 0{
                    isfull = true
                    //self.showAlert(message: "Remaining amount must be zero.")
                    //appDelegate.showToast(message: "Remaining amount must be zero.")
                    //return
                }
            }
            
            if self.shippingRefundButton.isSelected {
                shipping = -appDelegate.shippingRefundOnly
            } else {
                if  self.lbl_ShippingAndHandling.text != "$0.00" {
                    str_ShippingANdHandlingForRefund = str_ShippingANdHandlingForRefund.replacingOccurrences(of: "$", with: "")
                     shipping = Double(str_ShippingANdHandlingForRefund) ?? 0.00
                }
            }
            
//            if self.btnTipSelect.isSelected {
//                shipping = -appDelegate.shippingRefundOnly
//            } else {
//                //shipping = appDelegate.shippingRefundOnly
//            }
            parameters = [
                "cust_id": orderInfoObj.userID,
                "customer_status": CustomerObj.str_customer_status,
                "custom_text_1": CustomerObj.str_CustomText1,
                "custom_text_2": CustomerObj.str_CustomText2,
                "customer_info": [
                    "first_name": orderInfoObj.firstName,
                    "last_name": orderInfoObj.lastName,
                    "email": orderInfoObj.email,
                    "phone": ord_str_phone,
                    "address": orderInfoObj.addressLine1,
                    "address2": orderInfoObj.addressLine2,
                    "city": orderInfoObj.city,
                    "state": orderInfoObj.region,
                    "zip":ord_str_postal,
                    "country": CustomerObj.country,
                    "office_phone":CustomerObj.str_office_phone,
                    "contact_source": CustomerObj.str_contact_source,
                    "company":CustomerObj.str_company,
                ],
                "bill_profile_id": orderInfoObj.bpId,
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
                    "bill_phone": ord_str_phone
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
                    "coupon": "",
                    "products": productsArray,
                    "subtotal": SubTotalPrice.roundToTwoDecimal,
                    "discount": "",
                    "manual_discount": "",
                    "shipping_handling": shipping.roundToTwoDecimal,
                    "tax": "",
                    "custom_tax_id": taxID,
                    "tipAmount" : tipAmtVal,
                    "total": TotalPrice.roundToTwoDecimal,
                    "sub_action" : strSubscriptionValue
                ],
                "merchant_id": orderInfoObj.merchantId,
                "payment_type": TotalPrice == 0 ? "cash" : selectPaymentMethodValue,
                "payment_method": "",//TotalPrice > 0 ? "AUTH_CAPTURE" : "CAPTURE",
                "credit": [
                    "cc_account": TotalPrice > 0 ? (SwipeAndSearchVC.shared.cardData.number ?? "") : "" ,
                    "cc_exp_mo": TotalPrice > 0 ? (SwipeAndSearchVC.shared.cardData.month ?? "") : "" ,
                    "cc_exp_yr": TotalPrice > 0 ? (SwipeAndSearchVC.shared.cardData.year ?? "") : "" ,
                    "cc_cvv": "",
                    "tip": "",
                    "total": "",
                    "digital_signature": ""
                ],
                "cash": [
                    "amount": "",
                    "tip": "",
                    "total": ""
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
                    "dl_state": "",
                    "check_type": "",
                    "sec_code": "",
                    "account_type": "",
                    "tip": "",
                    "total": ""
                ],
                "gift_card": [
                    "gift_card_number": "",
                    "gift_card_pin": "",
                    "tip": "",
                    "total": ""
                ],
                "external_gift": [
                    "gift_card_number": TotalPrice > 0 ? "" : str_externalGiftCardNumber,
                    "tip": "",
                    "total": ""
                ],
                "internal_gift_card": [
                    "gift_card_number": TotalPrice > 0 ? "" : str_internalGiftCardNumber,
                    "tip": "",
                    "total": ""
                ],
                "multi_card": "",
                "check": [
                    "check_amount": "",
                    "check_number": "",
                    "tip": "",
                    "total": ""
                ],
                "external": [
                    "external_amount": "",
                    "tip": "",
                    "total": ""
                ],
                "pax_pay": [
                    "pax_payment_type": "",
                    "pax_url": TotalPrice > 0 ? "" : str_paxUrl,
                    "device_name": TotalPrice > 0 ? "" : str_addDeviceName,
                    "tip": "",
                    "amount": "",
                    "pax_pay_receipt" : DataManager.isSingatureOnEMV
                ],
                "isOrderRefund": true,
                "order_source": str_DeviceName,
                "isPartialRefund": isfull,
                "isShippingRefund": false,
                "isTipRefund": false,
                "digital_signature": "",
                "orderId": orderInfoObj.orderID,
                "notes": "",
                "campaign_code": "",
                "sub_id": "",
                "crm_partner_order_id": "",
                "enable_split_row": DataManager.isSplitRow,
                "transactionsList": productsArrayOne,
                "isOfflineTransction" : false,
                "cloud_printer_app_status" : DataManager.isGooglePrinter,
                "cloud_printer_address" : starMacAddrs
            ]
        }
        
        
        
        let newOrderData = parameters.filter({$0.key == "cust_id" || $0.key == "customer_info" || $0.key == "bill_profile_id" || $0.key == "billing_info" || $0.key == "shipping_info" || $0.key == "is_billing_same" || $0.key == "cart_info" || $0.key == "order_source" || $0.key == "notes" })
        
        if newOrderData == DataManager.recentOrder {
            if let recentOrderID = DataManager.recentOrderID {
                parameters["orderId"] = recentOrderID
            }
        }
        
        UserDefaults.standard.removeObject(forKey: "changeAmountKey")
        UserDefaults.standard.synchronize()
        
        print("****************************************************** Order Parameters Start ******************************************************")
        print(parameters)
        print("****************************************************** Order Parameters End ******************************************************")
        
        //Call API To Make Order
        self.callAPIToCreateOrder(parameters: parameters, isInvoice: false, isAllManualProducts: !isAllManualProducts.contains(false))
    }
    
    func callAPIToCreateOrder(parameters: JSONDictionary, isInvoice: Bool, isAllManualProducts: Bool) {
        Indicator.sharedInstance.hideIndicator()
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            if !isAllManualProducts {
//                self.showAlert(title: "Oops!", message: "Only Manual Payment Products is available in offline mode.", otherButtons: nil, cancelTitle: kOkay) { (_) in
                    self.enableSwipeReader()
                    self.isOrderPrepare = false
                    appDelegate.showToast(message: "Only Manual Payment Products is available in offline mode.")
//                }
                return
            }
            
            let selectedPayment = (parameters["payment_type"] as? String ?? "").uppercased()
            //            if !offlinePaymentArray.contains(selectedPayment) {
            //                self.showAlert(title: "Oops!", message: "Payment with \(selectedPayment.replacingOccurrences(of: "_", with: " ").lowercased().capitalized) is not available in offline mode.", otherButtons: nil, cancelTitle: kOkay) { (_) in
            //                    self.enableSwipeReader()
            //                    self.isOrderPrepare = false
            //                }
            //                return
            //            }
        }
        
        //Save Order For Future Check
        let recentOrder = parameters.filter({$0.key == "cust_id" || $0.key == "customer_info" || $0.key == "bill_profile_id" || $0.key == "billing_info" || $0.key == "shipping_info" || $0.key == "is_billing_same" || $0.key == "cart_info" || $0.key == "order_source" || $0.key == "notes" })
        DataManager.recentOrder = recentOrder
        
        let cart = recentOrder["cart_info"] as? JSONDictionary
        
        let total = (cart!["total"] as? String)?.toDouble()
        
        let Subtotal = (cart!["subtotal"] as? String)?.toDouble()
        
        let discountVal = (cart!["manual_discount"] as? String)?.toDouble()
        if orderType == .newOrder {
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                
                let selectedPaymentType = (parameters["payment_type"] as? String ?? "").uppercased()
                MainSocketManager.shared.onOrderProcessignloader(paymentType: selectedPaymentType)
                
            }
        }
        
        if self.isSelectEMVPayment {
            Indicator.isEnabledIndicator = false
            Indicator.sharedInstance.showIndicatorGifEMV(false)
        }

        //Call API
        HomeVM.shared.createOrder(parameters: parameters, isInvoice: isInvoice) { (success, message, error) in
            
            if success == 1 {
                DispatchQueue.main.async {
                    Indicator.sharedInstance.hideGif()
                }
                PaymentsViewController.paymentDetailDict.removeAll()
                self.isOrderPrepare = false
                self.resetCartData(isShowMessage: false)
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    //Move To Success Screen
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
                    if !HomeVM.shared.userData.isEmpty {
                        vc.OrderedData = HomeVM.shared.userData
                        HomeVM.shared.userData.removeAll()
                    }
                    vc.total = total ?? 0.0
                    vc.subTotal = Subtotal ?? 0.0
                    vc.paymentType = "credit"
                    vc.discountV = discountVal?.currencyFormat ?? "0.0"
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.cartViewDelegate?.moveToSuccessScreen()
                }
            }else {
                DispatchQueue.main.async {
                    Indicator.sharedInstance.hideGif()
                }
                //                if self.orderType == .newOrder {
                //                    //Move To Payment Screen
                //                    self.handlePayButtonAction()
                //                    return
                //                }
                //Show Error
                if message != nil {
                    //                    self.showAlert(message: message!)
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
                //Reset Values
                self.isOrderPrepare = false
                //Enable Swipe Reader
                SwipeAndSearchVC.shared.imagReadLib?.start()
                SwipeAndSearchVC.delegate = self
                if Keyboard._isExternalKeyboardAttached() {
                    SwipeAndSearchVC.shared.enableTextField()
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
        
        HomeVM.shared.getCoupanProductIDList(coupan: text , responseCallBack: { (success, message, error) in
            if success == 1 {
                if HomeVM.shared.coupanDetail.id != nil {
                    self.str_CouponDiscount = HomeVM.shared.coupanDetail.amount
                    self.str_AddCouponName = coupan
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.calculateTotalCart()
                    }
                    if self.isOpenToOrderHistory {
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                            DataManager.isBalanceDueData = true
                            self.performSegue(withIdentifier: "paymenttype", sender: nil)
                        }
                    }
                }
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
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
    
    func getTaxListService() {
        HomeVM.shared.getTaxList { (success, message, error) in
            if success == 1 {
                //Update Data
                self.array_TaxList = [TaxListModel]()
                self.taxModelObj.tax_title = "Default"
                self.taxModelObj.tax_type = "Fixed"
                self.taxModelObj.tax_amount = "0"
                self.array_TaxList.insert(self.taxModelObj, at: 0)
                
                //Update Data
                if HomeVM.shared.taxList.count > 0 {
                    
                    for i in (0...HomeVM.shared.taxList.count-1)
                    {
                        self.taxModelObj = TaxListModel()
                        self.taxModelObj.tax_title = HomeVM.shared.taxList[i].tax_title
                        self.taxModelObj.tax_type = HomeVM.shared.taxList[i].tax_type
                        self.taxModelObj.tax_amount = HomeVM.shared.taxList[i].tax_amount
                        self.array_TaxList.append(self.taxModelObj)
                        
                        self.updateDefaultTax()
                        
                        if let taxCode = DataManager.OrderDataModel?["str_CustomTaxId"] {
                            let code = taxCode as! String
                            
                            print(code)
                            
                            if(self.taxModelObj.tax_title == "countrywide")
                            {
                                self.taxTitle = self.taxModelObj.tax_title
                                self.taxType = self.taxModelObj.tax_type
                                self.taxAmountValue = self.taxModelObj.tax_amount
                            }
                        }
                        
                        if !self.isDefaultTaxSelected && !self.isDefaultTaxChanged
                        {
                            
                            //self.updateDefaultTax()
                            if let userObject = UserDefaults.standard.value(forKey: "userdata") as? NSData {
                                let userdata = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data)
                                if(((userdata as AnyObject).value(forKey: "user_tax_lock")) == nil || ((userdata as AnyObject).value(forKey: "user_tax_lock") as? String ?? "") == "")
                                {
                                    if(self.taxModelObj.tax_title == "countrywide")
                                    {
                                        self.taxTitle = self.taxModelObj.tax_title
                                        self.taxType = self.taxModelObj.tax_type
                                        self.taxAmountValue = self.taxModelObj.tax_amount
                                    }
                                    
                                }
                                else
                                {
                                    if(self.taxModelObj.tax_title == (userdata as AnyObject).value(forKey: "user_tax_lock")as? String ?? "")
                                    {
                                        self.taxTitle = self.taxModelObj.tax_title
                                        self.taxType = self.taxModelObj.tax_type
                                        self.taxAmountValue = self.taxModelObj.tax_amount
                                    }
                                }
                            }
                        }
                    }
                }
                
                self.taxModelObj.tax_settings = HomeVM.shared.taxSetting["tax_settings"] as? Dictionary<String,AnyObject> ?? Dictionary<String,AnyObject>()
                self.calculateTotalCart()
            }
            else {
                if !Indicator.isEnabledIndicator {
                    return
                }
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    if NetworkConnectivity.isConnectedToInternet() && !DataManager.isOffline{
                        self.showErrorMessage(error: error)
                    }
                }
            }
        }
    }
    
    func callAPIToGetCouponList() {
        HomeVM.shared.getCoupanList { (success, message, error) in
            if success == 1 {
                //...
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
}

//MARK: Refund Calculation With API
extension CartContainerViewController {
    
    func calculateRefundExchangeTotal() {
            
        if cartProductsArray.count == 0 {
                    if DataManager.isshippingRefundOnly || DataManager.isTipRefundOnly {
                        self.exchangePaymentMainView.isHidden = false
                        if self.orderInfoObj.showSubscriptionsCancel == true{
                            self.AddSubscription.isHidden = false
                        }else{
                            self.AddSubscription.isHidden = true
                        }
                        self.btn_Pay?.isHidden = false
                        self.btn_Pay?.setTitle("Exchange/Refund", for: .normal)
                        self.totalNameLabel.text = "Amount eligible for refund"
                        self.cartPaymentSectionView.isHidden = false
                        self.arrRefundAmount.removeAll()
                        for i in 0..<self.orderInfoObj.transactionArray.count {
                            self.orderInfoObj.transactionArray[i].availableRefundAmount = self.orderInfoObj.transactionArray[i].availableRefundAmountCopy
                            let val = self.orderInfoObj.transactionArray[i].availableRefundAmount
                            self.arrRefundAmount.append(val)
                        }
                        self.selectRemaingAmount.removeAll()
                        for i in 0..<self.orderInfoObj.transactionArray.count {
                            self.selectRemaingAmount.append(false)
                        }
                        //if DataManager.isshippingRefundOnly {
                            self.subtotalView.isHidden = true
                            self.discountView.isHidden = true
                            self.applyCouponView.isHidden = true
                            self.crossButton.isHidden = true
                            self.addDiscountView.isHidden = true
                            self.AddSubscription.isHidden = true
                            self.taxView.isHidden = true
                            self.shippingRefundButton.isHidden = true
                        var totalprize = 0.0
                        var totalLable = 0.0
                        var totalRemaining = 0.0
                        if DataManager.isTipRefundOnly {
                            self.viewTip.isHidden = false
                            self.btnTipSelect.isHidden = true
                            totalprize = appDelegate.tipRefundOnly - (appDelegate.tipRefundOnly * 2)
                            self.lblTipAmount.text = appDelegate.tipRefundOnly.currencyFormat
                            totalLable = appDelegate.tipRefundOnly
                            totalRemaining = appDelegate.tipRefundOnly
                        } else {
                            self.viewTip.isHidden = true
                        }
                        
                        if DataManager.isshippingRefundOnly {
                            self.shippingView.isHidden = false
                            totalprize = (appDelegate.shippingRefundOnly - (appDelegate.shippingRefundOnly * 2)) + totalprize
                            self.lbl_ShippingAndHandling.text = appDelegate.shippingRefundOnly.currencyFormat
                            totalLable = appDelegate.shippingRefundOnly + totalLable
                            totalRemaining = appDelegate.shippingRefundOnly + totalRemaining
                        } else {
                            self.shippingView.isHidden = true
                        }
                        
                        self.TotalPrice =  totalprize
                            self.totalLabel.text = "-\(totalLable.currencyFormat)"
                        self.lblRefundTotalRemaining.text = totalRemaining.currencyFormat
                        //}
                        self.collectionPayExchange.reloadData()
                    }
            return
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
        
        let taxID = self.taxTitle == "Default" ? DataManager.defaultTaxID : self.taxTitle
        
        lbl_TaxStateName?.text = "\(taxID)"
        self.taxTitle = "\(taxID)"
        
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
                dict["base_price"] = Double((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0).roundToTwoDecimal

                dict["price"] = Double((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0).roundToTwoDecimal
                dict["man_price"] = manPriceData
                dict["qty"] = (obj as AnyObject).value(forKey: "available_qty_refund") as? Double ?? 0
                dict["isRefunded"] = false
                dict["limit_qty"] = (obj as AnyObject).value(forKey: "limit_qty") as? Double ?? 0
                dict["is_refund_item"] = true
                dict["stock"] = 0
                dict["actual_qty"] = "\(-((obj as AnyObject).value(forKey: "actualproductqty") as? Double ?? 1))"
                //dict["selectionInventory"] = (obj as AnyObject).value(forKey: "selectionInventory") as? String ?? ""
                
                dict["sales_id"] = (obj as AnyObject).value(forKey: "salesID") as? String ?? ""
                dict["backToStock"] = (obj as AnyObject).value(forKey: "returnToStock") as? Bool ?? false
                dict["product_image"] = (obj as AnyObject).value(forKey: "product_image") as? String ?? ""
                dict["stock"] = (obj as AnyObject).value(forKey: "stock") as? Double ?? 0
                dict["title"] = (obj as AnyObject).value(forKey: "title") as? String ?? ""
            }else {
                dict["base_price"] = Double((obj as AnyObject).value(forKey: "productprice") as? Double ?? 0).roundToTwoDecimal

                dict["actual_qty"] = "\(-((obj as AnyObject).value(forKey: "actualproductqty") as? Double ?? 1))"
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
            //dict["is_additional_product"] = true
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
        
        
        
        let value : String = self.lbl_ShippingAndHandling.text!.replacingOccurrences(of: "$", with: "")
        let valueOne : String = value.replacingOccurrences(of: "-", with: "")
        
        var shipping = Double(valueOne) ?? 0
        var tipAmt = appDelegate.tipRefundOnly
        
        
        shipping = appDelegate.shippingRefundOnly
        
        //var refundTip = tipRefund
        
        //if self.shippingRefundButton.isSelected {
            if orderInfoObj.isshippingRefundSelected && orderInfoObj.productsArray[0].isExchangeSelected {
                self.shippingRefundButton.isSelected = true
            } else {
                self.shippingRefundButton.isSelected = false
            }
        
        if orderInfoObj.isTipRefundSelected && orderInfoObj.productsArray[0].isExchangeSelected {
            self.btnTipSelect.isSelected = true
        } else {
            self.btnTipSelect.isSelected = false
        }
//        } else {
//            self.shippingRefundButton.isSelected = false
//        }
        
        
        if orderType == .refundOrExchangeOrder {
            shipping =  self.shippingRefundButton.isSelected ? -shipping : shipping
            tipAmt = self.btnTipSelect.isSelected ? -tipAmt : tipAmt
        }
        
        //        if orderType == .refundOrExchangeOrder {
        //            refundTip =  self.btnTipSelect.isSelected ? -refundTip : refundTip
        //        }
        if orderInfoObj.showRefundTip {
            self.btnTipSelect.isHidden = false
        } else {
            self.btnTipSelect.isHidden = true
        }
        
        tipRefund = 0.0
        
        let parameters: JSONDictionary = [
            "cust_id": orderInfoObj.userID,
            "customer_info": [
                "first_name": orderInfoObj.firstName,
                "last_name": orderInfoObj.lastName,
                "email": orderInfoObj.email,
                "phone": ord_str_phone,
                "address": orderInfoObj.addressLine1,
                "address2": orderInfoObj.addressLine2,
                "city": orderInfoObj.city,
                "state": orderInfoObj.region,
                "zip":ord_str_postal,
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
                "bill_postal_code": ord_str_postal,
                "bill_email": orderInfoObj.email,
                "bill_phone": ord_str_phone
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
                "products": productDict,
                "manual_discount": self.str_AddDiscount,
                "shipping_handling": shipping.roundToTwoDecimal,
                "deposit_amount": 0,
                "custom_tax_id": taxID,
                "tip" : "\(tipAmt)",
                "sub_action" : strSubscriptionValue,
            ],
            "isOrderRefund": true,
            "is_loyalty": true,
            "enable_split_row": DataManager.isSplitRow,
            "orderId": orderInfoObj.orderID,
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
        print(parameters)
//        if DataManager.isshippingRefundOnly {
//            self.exchangePaymentMainView.isHidden = false
//            if self.orderInfoObj.showSubscriptionsCancel == true{
//                self.AddSubscription.isHidden = false
//            }else{
//                self.AddSubscription.isHidden = true
//            }
//            self.btn_Pay?.setTitle("Exchange/Refund", for: .normal)
//            self.totalNameLabel.text = "Total to be Refunded"
//            self.cartPaymentSectionView.isHidden = false
//            self.arrRefundAmount.removeAll()
//            for i in 0..<self.orderInfoObj.transactionArray.count {
//                self.orderInfoObj.transactionArray[i].availableRefundAmount = self.orderInfoObj.transactionArray[i].availableRefundAmountCopy
//                let val = self.orderInfoObj.transactionArray[i].availableRefundAmount
//                self.arrRefundAmount.append(val)
//            }
//            self.collectionPayExchange.reloadData()
//        } else {
            //Call API
            self.callAPIToCalculateCartTotal(parameters: parameters)

        //}
    }
    
    func callAPIToCalculateCartTotal(parameters: JSONDictionary) {
        HomeVM.shared.calculateCart(parameters: parameters) { (success, message, error) in
            if success == 1 {
                
                self.arrRefundAmount.removeAll()
                for i in 0..<self.orderInfoObj.transactionArray.count {
                    self.orderInfoObj.transactionArray[i].availableRefundAmount = self.orderInfoObj.transactionArray[i].availableRefundAmountCopy
                    let val = self.orderInfoObj.transactionArray[i].availableRefundAmount
                    self.arrRefundAmount.append(val)
                }
                
                let detail = HomeVM.shared.cartCalculationDetail
                self.collectionPayExchange.reloadData()
                
                self.SubTotalPrice = detail.subTotal
                self.TotalPrice = detail.amount_available_for_refund
                self.str_TaxAmount = detail.tax.roundToTwoDecimal
                self.selectRemaingAmount.removeAll()
                for i in 0..<self.orderInfoObj.transactionArray.count {
                    self.selectRemaingAmount.append(false)
                }
                
                if self.orderType == .refundOrExchangeOrder {
                    if self.shippingRefundButton.isSelected == true {
                        self.lbl_ShippingAndHandling.text = detail.shipping.currencyFormat
                    } else {
                        self.lbl_ShippingAndHandling.text = detail.shipping.currencyFormat
                    }
                } else {
                    self.lbl_ShippingAndHandling.text = detail.shipping.currencyFormat
                }
                
                self.lbl_AddDiscount.text = detail.discount.currencyFormat
                
                self.lbl_SubTotal?.text = detail.subTotal.currencyFormat
                self.lbl_AppliedCouponAmount.text = detail.couponDiscount.currencyFormat
                self.lbl_TaxStateName?.text = (self.taxTitle == "" || self.taxTitle == "countrywide" || self.taxTitle == "Default") ? "Tax (Default)" :  "Tax (\(self.taxTitle))"
                self.lbl_Tax.text = detail.tax.currencyFormat
                self.totalLabel.text = detail.amount_available_for_refund.currencyFormat
                
                if self.TotalPrice > 0 {
                    let valPrice = detail.total.currencyFormat
                    self.totalLabel.text = valPrice
                    self.lblRefundTotalRemaining.text = valPrice
                } else {
                    let valPrice = -(self.TotalPrice)
                    self.lblRefundTotalRemaining.text = valPrice.currencyFormat
                }
                
                self.SetBtnColor()
                
                if detail.tax > 0 {
                    self.taxView.isHidden = false
                }else{
                    self.taxView.isHidden = true
                }
                
                
                if self.str_showShipOrderInPos == "true" || self.lbl_ShippingAndHandling.text != "$0.00" {
                    if self.str_showShipOrderInPos == "true" {
                        self.shippingRefundButton.isHidden = false
                    }else{
                        self.shippingRefundButton.isHidden = true
                        if self.orderType == .refundOrExchangeOrder {
                          if  self.lbl_ShippingAndHandling.text != "$0.00" {
                                self.shippingRefundButton.isHidden = false
                              self.shippingRefundButton.setTitle("Refund", for: .normal)
                            }
                        }
                    }
                    self.shippingRefundButton.setTitle("Refund", for: .normal)
                }else{
                    self.shippingRefundButton.isHidden = true
                    if self.orderType == .refundOrExchangeOrder {
                      if  self.lbl_ShippingAndHandling.text != "$0.00" {
                            self.shippingRefundButton.isHidden = false
                          self.shippingRefundButton.setTitle("Refund", for: .normal)
                        }
                    }
                }
                
                if self.TotalPrice >= 0 {
                    self.exchangePaymentMainView.isHidden = true
                    if self.orderInfoObj.showSubscriptionsCancel == true{
                        self.AddSubscription.isHidden = false
                    }else{
                        self.AddSubscription.isHidden = true
                    }
                    self.btn_Pay?.setTitle("Exchange/Refund", for: .normal)
                    self.totalNameLabel.text = "Total to be Charged"
                }else{
                    self.exchangePaymentMainView.isHidden = false
                    if self.orderInfoObj.showSubscriptionsCancel == true{
                        self.AddSubscription.isHidden = false
                    }else{
                        self.AddSubscription.isHidden = true
                    }
                    self.btn_Pay?.setTitle("Exchange/Refund", for: .normal)
                    self.totalNameLabel.text = "Amount eligible for refund"
                }
                
                
                //Hide If Amount Is Zero
                self.discountView.isHidden = self.lbl_AddDiscount.text == "$0.00"
                self.applyCouponView.isHidden = self.lbl_AppliedCouponName.text == "Apply Coupon"
                self.crossButton.isHidden = self.lbl_AppliedCouponName.text == "Apply Coupon"
                self.addDiscountView.isHidden = self.orderType == .refundOrExchangeOrder
                if DataManager.posDisableDiscountFeature == "true" {
                    self.addDiscountView.isHidden = true
                }
                // hide for double value
                
                
                //self.shippingView.isHidden = detail.shipping == 0
                
                if detail.tax == 0 {
                    self.shippingView.isHidden = true
                    if DataManager.shippingValue == 0.00 {
                        self.shippingView.isHidden = true
                    } else {
                        
                        if self.orderType == .refundOrExchangeOrder {
                            if self.shippingRefundButton.isSelected == true {
                                self.lbl_ShippingAndHandling.text = "-\(appDelegate.shippingRefundOnly.currencyFormat ?? "0.0")"
                            } else {
                                self.lbl_ShippingAndHandling.text = appDelegate.shippingRefundOnly.currencyFormat
                            }
                            if self.btnTipSelect.isSelected == true {
                                self.lblTipAmount.text = "-\(appDelegate.tipRefundOnly.currencyFormat ?? "0.0")"
                            } else {
                                self.lblTipAmount.text = appDelegate.tipRefundOnly.currencyFormat
                            }
                           // self.lbl_ShippingAndHandling.text = shippingRefundButton.currencyFormat

                            self.lblShippngHead.addDashedBorder = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                            self.lbl_TaxStateName?.addDashedBorder = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                            self.lblShippngHead.addDashedBorderWidth = 0
                            
                        } else {
                            self.lbl_ShippingAndHandling.text = appDelegate.shippingRefundOnly.currencyFormat
                        }
                        
                        self.shippingView.isHidden = false
                    }
                } else {
                    self.shippingView.isHidden = false
                }
                
                self.shippingView.isHidden = self.lbl_ShippingAndHandling.text == "$0.00"
                
                if DataManager.isshippingRefundOnly {
                    self.subtotalView.isHidden = true
                    self.discountView.isHidden = true
                    self.applyCouponView.isHidden = true
                    self.crossButton.isHidden = true
                    self.addDiscountView.isHidden = true
                    self.AddSubscription.isHidden = true
                    self.shippingRefundButton.isHidden = true
                    self.lbl_ShippingAndHandling.text = appDelegate.shippingRefundOnly.currencyFormat
                    self.totalLabel.text = "-\(appDelegate.shippingRefundOnly.currencyFormat)"
                    self.lblRefundTotalRemaining.text = appDelegate.shippingRefundOnly.currencyFormat
                } else {
                    
                }
                
                if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                    self.view_AddCustomer.isHidden = true
                }else {
                    self.view_AddCustomer.isHidden = !DataManager.isCustomerManagementOn || self.orderType == .refundOrExchangeOrder
                }
                
                if appDelegate.tipRefundOnly == 0.0 {
                    self.viewTip.isHidden = true
                    self.lblTipAmount.text = appDelegate.tipRefundOnly.currencyFormat
                } else {
                    self.viewTip.isHidden = false
                    if self.btnTipSelect.isSelected == true {
                        self.lblTipAmount.text = "-\(appDelegate.tipRefundOnly.currencyFormat ?? "0.0")"
                    } else {
                        self.lblTipAmount.text = appDelegate.tipRefundOnly.currencyFormat
                    }
                    //self.lblTipAmount.text = appDelegate.tipRefundOnly.currencyFormat

                }
                 
                //Hide If Cart Empty
                self.btn_Pay?.isHidden = self.cartProductsArray.count == 0
                self.cartPaymentSectionView.isHidden = self.cartProductsArray.count == 0
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
//MARK: EditProductDelegate
extension CartContainerViewController: EditProductDelegate {
    func didShowShippingAddress(data: CustomerListModel){
        delegateEditProduct?.didShowShippingAddress?(data: data)
    }
}
extension CartContainerViewController: SubscriptionDelegate {
    func sendSelectedSubscriptionForiPhone(StrSubscription: String) {
        print(StrSubscription)
        strSubscriptionValue = StrSubscription
        if StrSubscription == "cancel_all"{
            if isinternalGift == false {
                selectedOptionHieght.constant = 28
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 100       //gc+cs  //cs///////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 70
                }
                viewForSelectedOption.isHidden = false
                self.lblSelectedOption.text = "Cancel all subscription associated with this users."
            } else {
                selectedOptionHieght.constant = 28
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 70       //gc+cs  //cs///////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 40
                }
                viewForSelectedOption.isHidden = false
                self.lblSelectedOption.text = "Cancel all subscription associated with this users."
            }
            
        } else if StrSubscription == "cancel_order" {
            if isinternalGift == false {
                selectedOptionHieght.constant = 28
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 100       //gc+cs  //cs///////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 70
                }
                viewForSelectedOption.isHidden = false
                self.lblSelectedOption.text = "Cancel all subscription associated with this order only."
            } else {
                selectedOptionHieght.constant = 28
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 70       //gc+cs  //cs///////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 40
                }
                viewForSelectedOption.isHidden = false
                self.lblSelectedOption.text = "Cancel all subscription associated with this order only."
            }
        } else if StrSubscription == "no_change" {
            if isinternalGift == false {
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 70   //gc+cs-cs  //-cs////////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 40
                }
                selectedOptionHieght.constant = 2
                viewForSelectedOption.isHidden = true
                self.lblSelectedOption.text = "No changes"
                
            } else {
                if tranCheckBoxSelected {
                    exchangePaymentView.constant = collectionViewHeight.constant + 50   //gc+cs-cs  //-cs////////////////
                }else{
                    exchangePaymentView.constant = collectionViewHeight.constant + 10
                }
                selectedOptionHieght.constant = 2
                viewForSelectedOption.isHidden = true
                self.lblSelectedOption.text = "No changes"
                
            }
        }
    }
}

//MARK: API Methods
extension CartContainerViewController {
    
    func callAPItoGetPAXDeviceList() {
        HomeVM.shared.getPaxDeviceList(responseCallBack: { (success, message, error) in
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                //self.tf_SelectDevice.isHidden = HomeVM.shared.paxDeviceList.count == 1
                if HomeVM.shared.paxDeviceList.count > 0 {
                    
                    self.arrPaxDeviceData.removeAllObjects()
                    self.arrTempPaxDeviceData.removeAllObjects()
                    for i in 0..<HomeVM.shared.paxDeviceList.count {
                        var list = [String:String]()
                        list["strUrl"] = HomeVM.shared.paxDeviceList[i].url
                        list["strPort"] = HomeVM.shared.paxDeviceList[i].port
                        list["strName"] = HomeVM.shared.paxDeviceList[i].name
                        list["strIndex"] = "0"
                        self.arrPaxDeviceData.add(list)
                    }
                    
                    print(self.arrPaxDeviceData)
                    
                    for j in 0..<self.orderInfoObj.transactionArray.count {
                        var listData = [String:String]()
                        if DataManager.selectedPaxDeviceName != "" {
                            listData["strName"] = DataManager.selectedPaxDeviceName
                        }else{
                            listData["strName"] = HomeVM.shared.paxDeviceList[0].name
                        }
                        listData["strIndex"] = "\(j)"
                        self.arrTempPaxDeviceData.add(listData)
                    }
                    
                    print(self.arrTempPaxDeviceData)
                    
//                    if self.tf_SelectDevice.isEmpty {
//                        if DataManager.selectedPaxDeviceName != "" {
//                            self.tf_SelectDevice.text = DataManager.selectedPaxDeviceName
//                        }else{
//                            self.tf_SelectDevice.text = HomeVM.shared.paxDeviceList[0].name
//                        }
//                        self.url = HomeVM.shared.paxDeviceList[0].url
//                    }
                }
                if self.isDeviceSelected {
                    //self.tf_SelectDevice.becomeFirstResponder()
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
    
}


extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

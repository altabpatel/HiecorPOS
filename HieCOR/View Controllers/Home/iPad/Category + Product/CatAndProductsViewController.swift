
//
//  CatAndProductsViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 12/02/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire
import AssetsLibrary
import Photos
import SocketIO

enum OrderType {
    case newOrder
    case refundOrExchangeOrder
}

class CatAndProductsViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var posLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var editProductDetailContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageController_Products: UIPageControl!
    @IBOutlet weak var pageController_Categories: UIPageControl!
    @IBOutlet weak var containerViewShippingAndBilling: UIView!
    @IBOutlet weak var containerViewAddCustomer: UIView!
    @IBOutlet weak var containerViewSelectCustomer: UIView!
    @IBOutlet weak var containerViewEditProduct: UIView!
    @IBOutlet var btn_Menu: UIButton!
    @IBOutlet weak var editProductDetailContainer: UIView!
    @IBOutlet weak var editProductBlurView: UIView!
    @IBOutlet weak var manualPaymentContainer: UIView!
    @IBOutlet weak var lockLineView: UIView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var refreshLineView: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var audioLineView: UIView!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoutLineView: UIView!
    @IBOutlet weak var showDetailsContainer: UIView!
    @IBOutlet weak var shippingContainer: UIView!
    
    @IBOutlet weak var txtTemp: UITextField!
    @IBOutlet weak var subscriptionContainer: UIView!
    
    @IBOutlet weak var view_bgPopup: UIView!
    @IBOutlet weak var btnDeviceName: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btn_InStockCheck: UIButton!
    //by anand sharma
    @IBOutlet weak var containerViewIpadProductInfo:UIView!
    
    //MARK: Delegates
    weak var paymentTypeDelegate: iPad_PaymentTypesViewControllerDelegate?
    weak var productResetDelegate: ResetCartDelegate?
    weak var cartResetDelegate: ResetCartDelegate?
    weak var categoryResetDelegate: ResetCartDelegate?
    weak var categoryDelegate: CategoriesContainerViewControllerDelegate?
    weak var productDelegate: ProductsContainerViewControllerDelegate?
    weak var delegate: CartContainerViewControllerDelegate?
    weak var cartContainerDelegate: CartContainerViewControllerDelegate?
    weak var customerDelegatesForCart: CustomerDelegates?
    weak var customerDelegatesForSelectNew: CustomerDelegates?
    weak var customerDelegatesForCartSelectNew: CustomerDelegates?
    weak var customerDelegatesForAddNew: CustomerDelegates?
    weak var shippingDelegate: ShippingDelegate?
    weak var shippingDelegateNew: ShippingDelegate?
    weak var cartDelegate: CartContainerViewControllerDelegate?
    weak var selectedCutomerDelegate: SelectedCutomerDelegate?
    weak var selectedCutomerCartDelegate: AddNewCutomerViewControllerDelegate?
    weak var editProductDetailDelegate: CatAndProductsViewControllerDelegate?
    weak var showDetailsDelegateOne : showDetailsDelegate?
    weak var showShippingDelegateOne : EditProductDelegate?
    weak var subScriptionDelegateOne : EditProductDelegate?
    var getProductsDelegate: ProductsViewControllerDelegate?
    var productsContainerDelegate: ProductsViewControllerDelegate?
    var searchProductDelegate: SwipeAndSearchDelegate?
    var manualPaymentDelegate: CatAndProductsViewControllerDelegate?
    var delegateOne: iPadTableViewCellDelegate?
    var isCreditCardNumberDetected = false
    var invoiceEmail = String()
    var orderType: OrderType = .newOrder
    var refundOrder: JSONDictionary?
    var EditUpdateVC : EditProductVC?
    var delegateUpdate : AttributeUpdateDeleget?
    var deviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
    //MARK: Variables
    private var CartObjectData:AnyObject = () as AnyObject
    static var visualEffectView = UIVisualEffectView()
    
    var arrVariationValue = [ProductVariationDetail]()
    var arrSurchargeValue = [ProductSurchageVariationDetail]()
    var arrAttributeValue = [ProductAttributeDetail]()
    var arrItemMetaDataValue = [ProductItemMetaFieldsDetail]()
    
    var searchProductsArray = [ProductsModel]()
    var selectedAttribute = JSONArray()
    
    var controller: UIViewController?
    var sourcesList = [String]()
    var tempSourcesName = ""
    var isInStock = false
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //OfflineDataManager Delegate
        //   for deeplinking (13 sept 200) by altab
        // Move to order history
        appDelegate.isOderHistoryOpen  = false
//        appDelegate.isOpenToOrderHistory = false
        appDelegate.orderDataClear = false
        appDelegate.isIngenicoDataFail = false // DD for Ingnico case fail 08 nov 2022
        DataManager.ingenicoOflineCaseData = nil // DD for Ingnico case fail 08 nov 2022
        appDelegate.arrIngenicoJsonArrayData.removeAll()
        if appDelegate.isOpenUrl {
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "iPad_OrdersHistoryViewController") as! iPad_OrdersHistoryViewController
           // appDelegate.isOpenUrl = false
            controller.recentOrderID = appDelegate.openUrlOrderId
            self.navigationController?.pushViewController(controller, animated: true)
        }
        OfflineDataManager.shared.delegate = self
        HomeVM.shared.isAllDataLoaded = [false, false, false]
        self.automaticallyAdjustsScrollViewInsets = false
        containerViewEditProduct.isHidden = true
        
        self.view.layoutIfNeeded()
        hideAllContainer()
        //Add Observer
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "ShowKeyboard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard(_:)), name: Notification.Name(rawValue: "ShowKeyboard"), object: nil)
        self.updateUI()
        
        print("base url \(BaseURL)")
        
        //        https://del.hiecor.biz
        //        https://devd.hiecor.biz
        //        https://mike.hiecor.com
        
        tempSourcesName = DataManager.deviceNameText ?? deviceName
        
        //        if DataManager.isSettingCRM {
        //            SettingListDataValue()
        //            DataManager.isTaxOn = true
        //            DataManager.isSettingCRM = false
        //        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isCreditCardNumberDetected = false
        SwipeAndSearchVC.shared.connectionDelegate = self
        self.audioButton.isSelected = SwipeAndSearchVC.shared.isJackReaderConnected
        if orderType == .refundOrExchangeOrder {
          
            btn_InStockCheck.isHidden = true
        }else{
            if !DataManager.posHideOutofStockFunctionality &&  DataManager.showProductInStockCheckbox == "true" {
                btn_InStockCheck.isHidden = false
            }else{
                btn_InStockCheck.isHidden = true
            }
        }
       
        if !manualPaymentContainer.isHidden {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Update Name
        if let name = DataManager.deviceNameText {
            posLabel.text = name
        }else {
            posLabel.text = deviceName
        }
        //
        pageController_Products.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        pageController_Categories.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ipadpayment"
        {
            let vc = segue.destination as! iPad_PaymentTypesViewController
            vc.cartObjectData = self.CartObjectData
            vc.orderType = self.orderType
            vc.invoiceEmail = invoiceEmail
            vc.isCreditCardNumberDetected = isCreditCardNumberDetected
            vc.delegate = self
            vc.showDetailsDelegateOne = self
        }
        
        if segue.identifier == "EditProductVC"
        {
            let vc = segue.destination as! EditProductVC
            vc.delegate = self
            vc.orderType = self.orderType
            vc.editProductDelegate = self
            vc.delegateForProductInfo = self
            editProductDetailDelegate = vc
        }
        
        
        if segue.identifier == "SubscriptionContainerViewController"
        {
            let vc = segue.destination as! SubscriptionContainerViewController
            vc.delegate = self
            subScriptionDelegateOne = vc
        }
        
        if segue.identifier == "ShowDetailsVC"
        {
            let vc = segue.destination as! ShowDetailsVC
            vc.delegate = self
            showDetailsDelegateOne = vc
        }
        if segue.identifier == "ShippingVC"
        {
            let vc = segue.destination as! ShippingVC
            vc.delegate = self
            showShippingDelegateOne = vc
            
        }
        
        if segue.identifier == "ManualPaymentVC"
        {
            let vc = segue.destination as! ManualPaymentVC
            vc.delegate = self
            manualPaymentDelegate = vc
        }
        
        if segue.identifier == "CategoryContainerSegue" {
            let vc = segue.destination as! CategoriesContainerViewController
            vc.delegate = self
            vc.updatePagerDelegate = self
            categoryResetDelegate = vc
        }
        if segue.identifier == "ProductContainerSegue" {
            let vc = segue.destination as! ProductsContainerViewController
            vc.delegate = self
            getProductsDelegate = vc
            categoryDelegate = vc
            vc.catAndProductDelegate = self
            vc.editProductDelegate = self
            productResetDelegate = vc
            vc.ordertype = orderType
        }
        
        if segue.identifier == "EditProductContainerViewController" {
            let vc = segue.destination as! EditProductContainerViewController
            productDelegate = vc
            vc.editProductDelegate = self
        }
        //by anand sharma
        if segue.identifier == "iPad_ProductInfoViewController" {
            let vc = segue.destination as! iPad_ProductInfoViewController
            productDelegate = vc
            vc.cancelProductDelegate = self
        }
        
        if segue.identifier == "CartContainerSegue" {
            let vc = segue.destination as! CartContainerViewController
            vc.delegate = self
            vc.catAndProductDelegate = self
            cartContainerDelegate = vc
            customerDelegatesForCart = vc
            cartDelegate = vc
            vc.shippingDelegate = self
            vc.customerDelegate = self
            selectedCutomerDelegate = vc
            selectedCutomerCartDelegate = vc
            customerDelegatesForCartSelectNew = vc
            cartResetDelegate = vc
            paymentTypeDelegate = vc
            vc.showDetailsDelegateOne = self
            vc.delegateEditProduct = self
            
        }
        
        if segue.identifier == "iPadSelectCustomerViewController" {
            let vc = segue.destination as! iPadSelectCustomerViewController
            vc.catAndProductDelegate = self
            vc.customerDelegate = self
            vc.delegate = self
            vc.customerDelegateForAddNewCustomer = self
            customerDelegatesForSelectNew = vc
            shippingDelegateNew = vc
        }
    }
    
    @objc func handleShowKeyboard(_ sender: Notification) {
        if SwipeAndSearchVC.shared.isSearchWithScanner || !DataManager.isBarCodeReaderOn {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if !Keyboard._isExternalKeyboardAttached() {
                    self.productResetDelegate?.updateKeyboardStatus?(isShow: self.manualPaymentContainer.isHidden)
                }
            }
        }
    }
    
    @objc func handlebackButtonAction(_ sender: UIButton) {
        DataManager.cartData = nil
        paymentTypeDelegate?.didResetCart?()
        PaymentsViewController.paymentDetailDict.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Private Functions
    private func updateUI() {
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            setView(view: manualPaymentContainer, hidden: false)
            setView(view: containerViewSelectCustomer, hidden: true)
            lockButton.isHidden = true
            logoutButton.isHidden = true
            logoutLineView.isHidden = true
            lockLineView.isHidden = true
            
        }else {
            lockButton.isHidden = false
            lockLineView.isHidden = false
            logoutButton.isHidden = false
            logoutLineView.isHidden = false
        }
        
        
        if DataManager.isCaptureButton == true {
            print("enter value capture")
            print(refundOrder)
            
            
            DataManager.isshippingRefundOnly = false
            DataManager.isTipRefundOnly  = false
            headerLabel.text = "Cart"
            btn_Menu.removeTarget(self, action: nil, for: .touchUpInside)
            cartResetDelegate?.updateCart?(with: false, data: nil)
            refreshButton.isHidden = false
            btnHome.isHidden = false
            posLabel.isHidden = false
            refreshLineView.isHidden = false
            btnDeviceName.isHidden = false
            btn_Menu.setImage(UIImage(named: "menu-blue"), for: .normal)
            getProductsDelegate?.didReceiveRefundProductIds?(string: "")
            cartDelegate?.refreshCart?(isNewOrder: true)
            DataManager.collectTips = DataManager.collectTips ? DataManager.collectTips : DataManager.tempCollectTips
            
            //Setup RevealViewController
            if (self.revealViewController() != nil)
            {
                revealViewController().delegate = self
                btn_Menu.isHidden = false
                btn_Menu?.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
            if let obj = refundOrder?["data"] as? OrderInfoModel {
                
                DataManager.cartProductsArray?.removeAll()
                var tempProducts = ProductsModel()
                
                for productsData in obj.productsArray {
                    let ProductsModelObj = ProductsModel()
                    ProductsModelObj.str_title = productsData.title
                    //ProductsModelObj.str_external_prod_id = ((productsData as AnyObject).value(forKey: "external_prod_id")) as? String ?? ""
                    ProductsModelObj.str_price = "\(productsData.price)"
                    ProductsModelObj.mainPrice = "\(productsData.mainPrice)"
                    ProductsModelObj.shippingPrice = productsData.shippingPrice
                    ProductsModelObj.str_stock = productsData.stock
                    ProductsModelObj.str_product_id = productsData.productID
                    //ProductsModelObj.str_product_code = ((productsData as AnyObject).value(forKey: "product_code")) as? String ?? ""
                    //ProductsModelObj.str_long_description = ((productsData as AnyObject).value(forKey: "long_description")) as? String ?? ""
                    //ProductsModelObj.str_short_description = ((productsData as AnyObject).value(forKey: "short_description")) as? String ?? ""
                    ProductsModelObj.str_product_image = productsData.image
                    //ProductsModelObj.str_limit_qty = productsData.limit_qty
                    if DataManager.isCaptureButton {
                        ProductsModelObj.str_limit_qty = String(productsData.qty)
                    }else{
                        ProductsModelObj.str_limit_qty = productsData.limit_qty
                    }
                    ProductsModelObj.is_taxable = productsData.isTaxable
                    ProductsModelObj.unlimited_stock = productsData.unlimited_stock
                    //ProductsModelObj.str_keywords = ((productsData as AnyObject).value(forKey: "keywords")) as? String ?? ""
                    //ProductsModelObj.str_fileID = ((productsData as AnyObject).value(forKey: "fileID")) as? String ?? ""
                    ProductsModelObj.isAllowDecimal = productsData.qtyAllowDecimal
                    ProductsModelObj.isEditPrice = productsData.isEditPrice
                    ProductsModelObj.isEditQty = productsData.isEditQty
                    //ProductsModelObj.variations = (productsData as AnyObject).value(forKey: "variation_display") as? JSONDictionary ?? JSONDictionary()
                    //ProductsModelObj.surchargeVariations = (productsData as AnyObject).value(forKey: "surcharge_variations_display") as? JSONDictionary ?? JSONDictionary()
                    ProductsModelObj.attributesData = productsData.attributesData      //DD
                    ProductsModelObj.variationsData = productsData.variationsData      //DD
                    ProductsModelObj.surchagevariationsData =  productsData.surchagevariationsData    //DD
                    ProductsModelObj.selectedAttributesData = productsData.selectedAttributesData
                    ProductsModelObj.width =  0.0
                    ProductsModelObj.height =  0.0
                    ProductsModelObj.length =  0.0
                    ProductsModelObj.weight =  0.0
                    selectedAttribute = productsData.selectedAttributesData
                    
                    didAddNewProductCapture(data: ProductsModelObj, productDetail: ProductsModelObj)
                }
            }
            //return
        } else {
            if orderType == .newOrder {
                headerLabel.text = "Cart"
                btn_Menu.removeTarget(self, action: nil, for: .touchUpInside)
                cartResetDelegate?.updateCart?(with: false, data: nil)
                refreshButton.isHidden = false
                btnHome.isHidden = false
                posLabel.isHidden = false
                btnDeviceName.isHidden = false
                refreshLineView.isHidden = false
                btn_Menu.setImage(UIImage(named: "menu-blue"), for: .normal)
                getProductsDelegate?.didReceiveRefundProductIds?(string: "")
                cartDelegate?.refreshCart?(isNewOrder: true)
                DataManager.collectTips = DataManager.collectTips ? DataManager.collectTips : DataManager.tempCollectTips
                DataManager.isshippingRefundOnly = false
                DataManager.isTipRefundOnly  = false
                //Setup RevealViewController
                if (self.revealViewController() != nil)
                {
                    revealViewController().delegate = self
                    btn_Menu.isHidden = false
                    btn_Menu?.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
                }
                
            }else {
                headerLabel.text = "Exchange/Refund"
                btn_Menu.setImage(UIImage(named: "back-arrow-black"), for: .normal)
                btn_Menu.removeTarget(self, action: nil, for: .touchUpInside)
                btn_Menu.addTarget(self, action: #selector(handlebackButtonAction(_:)), for: .touchUpInside)
                cartResetDelegate?.updateCart?(with: true, data: refundOrder)
                
                DataManager.tempCollectTips = DataManager.collectTips
                DataManager.collectTips = false
                
                var refundIDS = String()
                if let obj = refundOrder?["data"] as? OrderInfoModel {
                    for product in obj.productsArray {
                        if product.isRefundSelected || product.isExchangeSelected {
                            if refundIDS != "" {
                                refundIDS += ","
                            }
                            refundIDS += "\(product.productID)"
                        }
                    }
                }
                
                getProductsDelegate?.didReceiveRefundProductIds?(string: refundIDS)
                refreshButton.isHidden = true
                btnHome.isHidden = true
                refreshLineView.isHidden = true
                posLabel.isHidden = true
                btnDeviceName.isHidden = true
                self.view.gestureRecognizers = nil
            }
        }
    }
    
    private func addBlurView() {
        let blurEffect = UIBlurEffect(style: .regular)
        CatAndProductsViewController.visualEffectView = UIVisualEffectView(effect: blurEffect)
        CatAndProductsViewController.visualEffectView.frame = view.frame
        self.view.addSubview(CatAndProductsViewController.visualEffectView)
    }
    
    private func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    
    private func hideAllContainer() {
        //Hide All Containers
        self.containerViewShippingAndBilling.isHidden = true
        self.containerViewAddCustomer.isHidden = true
        self.containerViewSelectCustomer.isHidden = true
        self.containerViewEditProduct.isHidden = true
        self.editProductDetailContainer.isHidden = true
        self.editProductBlurView.isHidden = true
        self.manualPaymentContainer.isHidden = true
        self.showDetailsContainer.isHidden = true
        self.containerViewIpadProductInfo.isHidden = true
    }
    
    func searchUpcCodeInVariation(strUPC:String, prod: ProductsModel) -> Bool {
        
        var isVariation = false
        
        let productAttribute = self.arrAttributeValue
        
        let productDetail = self.arrVariationValue
        
        for detail in productDetail {
            
            for variationValue in detail.valuesVariation {
                
                if variationValue.variation_use_parent_upc == "No" {
                    
                    if(variationValue.variation_upc.caseInsensitiveCompare(strUPC) == .orderedSame) || (variationValue.variation_product_code.caseInsensitiveCompare(strUPC) == .orderedSame){
                        print("voila")
                        
                        for data in variationValue.jsonArray!{
                            
                            let attValId = (data as NSDictionary).value(forKey: "attribute_value_id") as! String
                            let attId = (data as NSDictionary).value(forKey: "attribute_id") as! String
                            
                            for i in 0..<productAttribute.count {
                                let arrayData  = productAttribute[i].valuesAttribute as [AttributesModel] as NSArray
                                var attributeModel = arrayData[0] as! AttributesModel
                                
                                if attId == attributeModel.attribute_id {
                                    let jsonArray = attributeModel.jsonArray
                                    if let hh = jsonArray {
                                        var arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                                        
                                        for j in 0..<arrayAttrData.count {
                                            let val = arrayAttrData[j].attribute_value_id
                                            if val == attValId {
                                                print("this is right way")
                                                
                                                arrayAttrData[j].isSelect = true
                                                
                                                arrayAttrData = AttributeSubCategory.shared.getUpdateAttribute(with: jsonArray!, isSelected: arrayAttrData[j].isSelect, index: j, type: attributeModel.attribute_type, attributeId: attributeModel.attribute_id)
                                                
                                                let jso = AttributeSubCategory.shared.attributevalueConvertJSon(with: arrayAttrData, attributeId: attributeModel.attribute_id)
                                                
                                                attributeModel.jsonArray = jso
                                                
                                                arrAttributeValue[i].valuesAttribute = [attributeModel]
                                                
                                                isVariation = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        appDelegate.strSearch = ""
        print("arr============ \(productAttribute)")
        return isVariation
    }
    
    func selectCaptureInVariation(prod: ProductsModel) -> Bool {
        
        var isCapture = false
        
        let productAttribute = self.arrAttributeValue
        
        for value in selectedAttribute {
            
            let attribute_id = value["attribute_id"] as? String
            
            let attributevalueIdData = value["attribute_value_id"] as? NSArray
            
            for i in 0..<productAttribute.count {
                let arrayData  = productAttribute[i].valuesAttribute as [AttributesModel] as NSArray
                var attributeModel = arrayData[0] as! AttributesModel
                
                if attribute_id == attributeModel.attribute_id {
                    let jsonArray = attributeModel.jsonArray
                    if let hh = jsonArray {
                        var arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                        
                        for j in 0..<arrayAttrData.count {
                            let val = arrayAttrData[j].attribute_value_id
                            
                            for data in attributevalueIdData! {
                                let id = data as? String
                                
                                if val == id {
                                    print("this is right way")
                                    
                                    arrayAttrData[j].isSelect = true
                                    
                                    //  arrayAttrData = AttributeSubCategory.shared.getUpdateAttribute(with: jsonArray!, isSelected: arrayAttrData[j].isSelect, index: j, type: attributeModel.attribute_type, attributeId: attributeModel.attribute_id)
                                    
                                    // | thia comment for multiple checkbox attribute show in cart list so commwnt this line by sudama
                                    
                                    let jso = AttributeSubCategory.shared.attributevalueConvertJSon(with: arrayAttrData, attributeId: attributeModel.attribute_id)
                                    
                                    attributeModel.jsonArray = jso
                                    
                                    arrAttributeValue[i].valuesAttribute = [attributeModel]
                                    
                                    isCapture = true
                                }
                            }
                        }
                    }
                }
            }
            
        }
        print("arr============ \(productAttribute)")
        return isCapture
    }
    
    
    func didAddNewProductCapture(data: ProductsModel, productDetail: Any) {
        let (successOne, variationValue) = ProductModel.shared.parseVariationData(productData: data)
        print(variationValue as Any)
        
        if successOne {
            editProductDetailDelegate?.didSaveProductVariationData?(data: data, productData: variationValue as Any)
            arrVariationValue = variationValue!
        }
        
        let (successOneItemMeta, itemMetaValue) = ProductModel.shared.parseItemMetaFieldsData(productData: data)
        print(itemMetaValue as Any)
        
        if successOneItemMeta {
            editProductDetailDelegate?.didSaveProductItemMetaFieldsData?(data: data, productData: itemMetaValue as Any)
            arrItemMetaDataValue = itemMetaValue!
        }
        
        let (successSurcharge, surchageValue) = ProductModel.shared.parseSurchargeVariationData(productData: data)
        print(surchageValue as Any)
        
        if successSurcharge {
            editProductDetailDelegate?.didSaveProductVariationSurchargeData?(data: data, productData: surchageValue as Any)
            arrSurchargeValue = surchageValue!
        }
        
        
        let (success, value) = ProductModel.shared.parseAttribute(productData: data)
        if !success || (data.isEditQty || data.isEditPrice || (variationValue?.count)! > 0 || (surchageValue?.count)! > 0 || (value?.count)! > 0) {
            
            arrAttributeValue = value!
            
            editProductDetailDelegate?.didSaveProductAttributeData!(data: data, productData: value as Any)
            
            let isvalue = selectCaptureInVariation(prod: data)
            
            let dataOne = self.arrAttributeValue
            
            editProductDetailDelegate?.didSaveNewProduct?(data: data, productDetail: dataOne as Any)
        }else {
            editProductDetailDelegate?.didSaveNewProduct?(data: data, productDetail: value as Any)
        }
    }
    
    //MARK: IBAction
    @IBAction func refreshBtnTapped(_ sender: UIButton){
        self.view.endEditing(true)
        DataManager.isshippingRefundOnly = false
        DataManager.isTipRefundOnly  = false
        appDelegate.tipRefundOnly = 0.0
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
        
        HomeVM.shared.isAllDataLoaded = [false, false, false]
        Indicator.sharedInstance.showIndicator()
        DataManager.isCheckUncheckShippingBilling = false
        DataManager.OrderDataModel = nil
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                //DataManager.selectedPaxDeviceName = ""
                DataManager.isUserPaxToken = ""
                DataManager.shippingaddressCount = 0
                DataManager.CardCount = 0
                DataManager.EmvCardCount = 0
                DataManager.IngenicoCardCount = 0
                DataManager.Bbpid = ""
                DataManager.customerId = ""
                HomeVM.shared.customerUserId = ""
                DataManager.customerForShippingAddressId = ""
                DataManager.shippingValue = 0.0
                DataManager.shippingValueForAddress = 0.0
                self.refundOrder = nil
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
                self.categoryResetDelegate?.resetCart?()
                self.productResetDelegate?.resetCart?()
                self.cartResetDelegate?.resetCart?()
                self.customerDelegatesForSelectNew?.resetCart?()
                //Hide All Containers
                self.hideAllContainer()
                self.orderType = .newOrder
                self.updateUI()
                //Automatically Show When Internet Off
                if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                    Indicator.sharedInstance.hideIndicator()
                    self.setView(view: self.manualPaymentContainer, hidden: false)
                }
            }
            
            self.callAPIToGetIngenico()
        }
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        //            self.updateLoggedInCustomer()
        //        }
    }
    
    @IBAction func lockBtnTapped(_ sender: UIButton){
        //...
        appDelegate.tipRefundOnly = 0.0
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
            }
        self.containerViewSelectCustomer.isHidden = true
    }
    
    @IBAction func btn_LogOutAction(_ sender: Any) {
        appDelegate.tipRefundOnly = 0.0
       /* if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
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
        }*/
        alertForLogOut()
    }
    
    
    @IBAction func btn_HomeAction(_ sender: Any) {
        self.view.endEditing(true)
        DataManager.isshippingRefundOnly = false
        DataManager.isTipRefundOnly  = false
        appDelegate.tipRefundOnly = 0.0
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.connect()
            let socketConnectionStatus = MainSocketManager.shared.socket.status
            
            switch socketConnectionStatus {
            case SocketIOStatus.connected:
                print("socket connected")
            // MainSocketManager.shared.onreset()
            case SocketIOStatus.connecting:
                print("socket connecting")
            case SocketIOStatus.disconnected:
                print("socket disconnected")
            case SocketIOStatus.notConnected:
                print("socket not connected")
            }
        }
        HomeVM.shared.isAllDataLoaded = [false, false, false]
        Indicator.sharedInstance.showIndicator()
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.refundOrder = nil
                
                if DataManager.isCaptureButton == true {
                    DataManager.cartProductsArray?.removeAll()
                    DataManager.isCaptureButton = false
                    DataManager.customerObj?.removeAll()
                }
                
                self.categoryResetDelegate?.resetHomeCart?()
                self.productResetDelegate?.resetHomeCart?()
                self.cartResetDelegate?.resetHomeCart?()
                self.hideAllContainer()
                self.orderType = .newOrder
                self.updateUI()
                //Automatically Show When Internet Off
                if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                    Indicator.sharedInstance.hideIndicator()
                    self.setView(view: self.manualPaymentContainer, hidden: false)
                }
            }
            self.callAPIToGetIngenico()
        }
    }
    
    
    @IBAction func btnDeviceName_action(_ sender: UIButton) {
        if !DataManager.isDrawerOpen{
            
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(false)
            
            let storyboard = UIStoryboard.init(name: "iPad", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChangeDeviceNamePopupVC") as! ChangeDeviceNamePopupVC
            vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.popover
            vc.preferredContentSize = CGSize(width: 220, height:  121)
            controller = vc
            
            let popController = controller?.popoverPresentationController
            popController?.permittedArrowDirections = .up
            popController?.backgroundColor = UIColor.white
            
            popController?.delegate = self
            popController?.sourceRect = CGRect(x: 5, y: 20 , width: 3, height: 3)
            popController?.sourceView = sender
            if let controller = controller {
                self.view_bgPopup.isHidden = false
                self.present(controller, animated: true, completion: {
                    controller.view.superview?.layer.cornerRadius = 3
                })
            }
        }
    }
    @IBAction func btnInStockCheck_action(_ sender: Any) {
        isInStock.toggle()
        btn_InStockCheck.setImage(isInStock ? #imageLiteral(resourceName: "boxSelect") : #imageLiteral(resourceName: "uncheckGray"), for: .normal)
        productResetDelegate?.didShowInStockItemOnly?(isStock: isInStock)
    }
    
}

//MARK: CategoriesContainerViewControllerDelegate
extension CatAndProductsViewController: CategoriesContainerViewControllerDelegate {
    func didTapOnManualPayment() {
        self.view.endEditing(true)
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        manualPaymentDelegate?.didTapOnManualPayment?()
        setView(view: manualPaymentContainer, hidden: false)
    }
    
    func getProduct(withCategory name: String) {
        categoryDelegate?.getProduct?(withCategory: name)
    }
    
    func didRefresh() {
        self.cartResetDelegate?.resetHomeCart?()
    }
}

//MARK: ProductsContainerViewControllerDelegate
extension CatAndProductsViewController: ProductsContainerViewControllerDelegate {
    func didSelectEditButton(data: ProductsModel, index: Int, isSearching: Bool) {
        productDelegate?.didSelectEditButton?(data: data, index: index, isSearching: isSearching)
    }
    
    func didGetCardDetail() {
        if !containerViewSelectCustomer.isHidden {
//            self.showAlert(message: "Please first save the customer information.")
            appDelegate.showToast(message: "Please first save the customer information.")
            Indicator.sharedInstance.hideIndicator()
            return
        }
        //appDelegate.showToast(message: "enter value swiper1")
        self.isCreditCardNumberDetected = true
        cartContainerDelegate?.didGetCardDetail?()
    }
    
    func noCardDetailFound() {
        self.isCreditCardNumberDetected = false
        cartContainerDelegate?.noCardDetailFound?()
    }
    
}
//MARK: showDetailsDelegate
extension CatAndProductsViewController: showDetailsDelegate {
    
    func didShowDetailsAtrribute(index: Int, cartArray: Array<AnyObject>) {
        showDetailsDelegateOne?.didShowDetailsAtrribute?(index: index, cartArray: cartArray)
        setView(view: showDetailsContainer, hidden: false)
    }
}

//MARK: CatAndProductsViewControllerDelegate
extension CatAndProductsViewController: CatAndProductsViewControllerDelegate {
    
    func didAddNewProduct(data: ProductsModel, productDetail: Any) {
        let (successOne, variationValue) = ProductModel.shared.parseVariationData(productData: data)
        print(variationValue as Any)
        
        if successOne {
            editProductDetailDelegate?.didSaveProductVariationData?(data: data, productData: variationValue as Any)
            arrVariationValue = variationValue!
        }
        
        let (successOneItemMeta, itemMetaValue) = ProductModel.shared.parseItemMetaFieldsData(productData: data)
        print(itemMetaValue as Any)
        
        if successOneItemMeta {
            editProductDetailDelegate?.didSaveProductItemMetaFieldsData?(data: data, productData: itemMetaValue as Any)
            arrItemMetaDataValue = itemMetaValue!
        }
        
        let (successSurcharge, surchageValue) = ProductModel.shared.parseSurchargeVariationData(productData: data)
        print(surchageValue as Any)
        
        if successSurcharge {
            editProductDetailDelegate?.didSaveProductVariationSurchargeData?(data: data, productData: surchageValue as Any)
            arrSurchargeValue = surchageValue!
        }
        
        
        let (success, value) = ProductModel.shared.parseAttribute(productData: data)
        if !success || (data.isEditQty || data.isEditPrice || (variationValue?.count)! > 0 || (surchageValue?.count)! > 0 || (value?.count)! > 0) {
            
            arrAttributeValue = value!
            
            editProductDetailDelegate?.didSaveProductAttributeData!(data: data, productData: value as Any)
            
            let isvalue = searchUpcCodeInVariation(strUPC: appDelegate.strSearch, prod: data)
            
            if isvalue {
                
                let dataOne = self.arrAttributeValue
                
                if !data.isShowEditModel {
                    //let maindata = self.arrAttributeValue
                    editProductDetailDelegate?.didSaveNewProduct?(data: data, productDetail: dataOne as Any)
                }else{
                    editProductDetailDelegate?.didAddNewProduct?(data: data, productDetail: value as Any)
                    showEditProduct()
                }
                
               // editProductDetailDelegate?.didSaveNewProduct?(data: data, productDetail: dataOne as Any)
            } else {
                var isSingleAttribute = false
                
                if Int(DataManager.appVersion)! < 4 {
                    if arrAttributeValue.count >= 1 {
                        for detail in self.arrAttributeValue {
                            for variationValue in detail.valuesAttribute {
                                if variationValue.jsonArray?.count ?? 0 >= 1 {
                                    for data in variationValue.jsonArray!{
                                        
                                        let attValId = (data as NSDictionary).value(forKey: "attribute_value_id") as! String
                                        
                                        for i in 0..<arrAttributeValue.count {
                                            let arrayData  = arrAttributeValue[i].valuesAttribute as [AttributesModel] as NSArray
                                            var attributeModel = arrayData[0] as! AttributesModel
                                            let jsonArray = attributeModel.jsonArray
                                            if let hh = jsonArray {
                                                var arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                                                if arrayAttrData.count == 1 {
                                                    for j in 0..<arrayAttrData.count {
                                                        let val = arrayAttrData[j].attribute_value_id
                                                        if val == attValId {
                                                            print("this is right way")
                                                            
                                                            arrayAttrData[j].isSelect = true
                                                            
                                                            arrayAttrData = AttributeSubCategory.shared.getUpdateAttribute(with: jsonArray!, isSelected: arrayAttrData[j].isSelect, index: j, type: attributeModel.attribute_type, attributeId: attributeModel.attribute_id)
                                                            
                                                            let jso = AttributeSubCategory.shared.attributevalueConvertJSon(with: arrayAttrData, attributeId: attributeModel.attribute_id)
                                                            
                                                            attributeModel.jsonArray = jso
                                                            
                                                            arrAttributeValue[i].valuesAttribute = [attributeModel]
                                                            
                                                            isSingleAttribute = true
                                                        }
                                                    }
                                                } else {
                                                    isSingleAttribute = false
                                                    break
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    isSingleAttribute = false
                                }
                            }
                        }
                    }else {
                        isSingleAttribute = false
                    }
                }else {
                    if arrAttributeValue.count == 1 {
                        for detail in self.arrAttributeValue {
                            for variationValue in detail.valuesAttribute {
                                if variationValue.jsonArray?.count == 1 {
                                    for data in variationValue.jsonArray!{
                                        
                                        let attValId = (data as NSDictionary).value(forKey: "attribute_value_id") as! String
                                        
                                        for i in 0..<arrAttributeValue.count {
                                            let arrayData  = arrAttributeValue[i].valuesAttribute as [AttributesModel] as NSArray
                                            var attributeModel = arrayData[0] as! AttributesModel
                                            let jsonArray = attributeModel.jsonArray
                                            if let hh = jsonArray {
                                                var arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                                                
                                                for j in 0..<arrayAttrData.count {
                                                    let val = arrayAttrData[j].attribute_value_id
                                                    if val == attValId {
                                                        print("this is right way")
                                                        
                                                        arrayAttrData[j].isSelect = true
                                                        
                                                        arrayAttrData = AttributeSubCategory.shared.getUpdateAttribute(with: jsonArray!, isSelected: arrayAttrData[j].isSelect, index: j, type: attributeModel.attribute_type, attributeId: attributeModel.attribute_id)
                                                        
                                                        let jso = AttributeSubCategory.shared.attributevalueConvertJSon(with: arrayAttrData, attributeId: attributeModel.attribute_id)
                                                        
                                                        attributeModel.jsonArray = jso
                                                        
                                                        arrAttributeValue[i].valuesAttribute = [attributeModel]
                                                        
                                                        isSingleAttribute = true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    isSingleAttribute = false
                                }
                            }
                        }
                    }else {
                        isSingleAttribute = false
                    }
                }
                if isSingleAttribute {
                    let maindata = self.arrAttributeValue
                    editProductDetailDelegate?.didSaveNewProduct?(data: data, productDetail: maindata as Any)
                }else{
                    editProductDetailDelegate?.didAddNewProduct?(data: data, productDetail: value as Any)
                    showEditProduct()
                }
                
            }
        }else {
            if DataManager.isUPSellProduct{
                editProductDetailDelegate?.didAddNewProduct?(data: data, productDetail: value as Any)
                showEditProduct()
                DataManager.isUPSellProduct = false
            } else {
                editProductDetailDelegate?.didSaveNewProduct?(data: data, productDetail: value as Any)
            }
        }
    }
    
    func didEditProduct(index: Int) {
        editProductDetailDelegate?.didEditProduct?(index: index)
        showEditProduct()
    }
    
    func showEditProduct() {
        setView(view: editProductDetailContainer, hidden: false)
        self.editProductBlurView.isHidden = false
        self.editProductBlurView.alpha = 0
        UIView.animate(withDuration: Double(0.5), animations: {
            self.editProductBlurView.alpha = 0.4
            self.editProductDetailContainerTopConstraint.constant = 180
            self.view.layoutIfNeeded()
        })
    }
    
    func hideView(with identifier: String) {
        if (identifier == "alertblur") {
            self.addBlurView()
        }
        if (identifier == "paymentActionAddCustomer")
        {
            iPadSelectCustomerViewController.selectCustomerViewType = .selectOrNew
            setView(view: manualPaymentContainer, hidden: true)
            setView(view: containerViewAddCustomer, hidden: true)
            setView(view: containerViewShippingAndBilling, hidden: true)
            setView(view: containerViewSelectCustomer, hidden: false)
        }
        if (identifier == "alertblurdone") {
            CatAndProductsViewController.visualEffectView.removeFromSuperview()
        }
        if (identifier == "alertblurcancel") {
            CatAndProductsViewController.visualEffectView.removeFromSuperview()
        }
        else if (identifier == "addcustomerBtn_ActionIPAD")
        {
            iPadSelectCustomerViewController.selectCustomerViewType = .selectOrNew
            setView(view: manualPaymentContainer, hidden: true)
            setView(view: containerViewAddCustomer, hidden: true)
            setView(view: containerViewShippingAndBilling, hidden: true)
            setView(view: containerViewSelectCustomer, hidden: false)
        }
        else if (identifier == "shippingBtn_ActionIPAD")
        {
            setView(view: containerViewAddCustomer, hidden: true)
            setView(view: containerViewShippingAndBilling, hidden: true)
            setView(view: containerViewSelectCustomer, hidden: false)
        }
        else if (identifier == "addcustomerCancelIPAD")
        {
            setView(view: containerViewSelectCustomer, hidden: true)
        }
        else if (identifier == "addnewcustomerBtn_ActionIPAD")
        {
            setView(view: containerViewAddCustomer, hidden: false)
        }
        else if (identifier == "addnewcustomerCancelIPAD")
        {
            setView(view: containerViewAddCustomer, hidden: true)
        }
        else if (identifier == "shippingandbillingBtn_ActionIPAD")
        {
            setView(view: containerViewAddCustomer, hidden: true)
            setView(view: containerViewShippingAndBilling, hidden: true)
            setView(view: containerViewSelectCustomer, hidden: false)
            
        }
        else if (identifier == "shippingandbillingCancelIPAD")
        {
            setView(view: containerViewShippingAndBilling, hidden: true)
        }
    }
    
    func updatePager(dict: JSONDictionary, isCategory: Bool) {
        if isCategory {
            if let value = dict["numberofpages"] as? Int {
                pageController_Categories.numberOfPages = value
            }
            
            if let value = dict["pageCount"] as? Int {
                pageController_Categories.currentPage = value
            }
        }else {
            if let value = dict["numberofpages"] as? Int {
                pageController_Products.numberOfPages = value
            }
            
            if let value = dict["pageCount"] as? Int {
                pageController_Products.currentPage = value
            }
        }
    }
    
    func didTapToRefreshHome() {
        self.cartContainerDelegate?.callHomeFromCart!()
        customerDelegatesForSelectNew?.didRefreshNewCustomer?()
        if orderType == .refundOrExchangeOrder {
            btn_InStockCheck.isHidden = true
        }else{
            if !DataManager.posHideOutofStockFunctionality &&  DataManager.showProductInStockCheckbox == "true" {
                btn_InStockCheck.isHidden = false
            }else{
                btn_InStockCheck.isHidden = true
            }
        }
    }
}

//MARK: EditProductsContainerViewDelegate
extension CatAndProductsViewController: EditProductsContainerViewDelegate {
    func refreshCart() {
        self.cartContainerDelegate?.refreshCart?()
    }
    
    func didEditProduct(with identiifier: String) {
        if (identiifier == "editproductIPAD")
        {
            setView(view: containerViewEditProduct, hidden: false)
        }
        else if (identiifier == "btn_ProductEditCancelAction")
        {
            setView(view: containerViewEditProduct, hidden: true)
        }
        else if (identiifier == "btn_ProductEditCancelActionIPAD")
        {
            setView(view: containerViewEditProduct, hidden: true)
        }
        else if (identiifier == "updateproductIPAD")
        {
            setView(view: containerViewEditProduct, hidden: true)
            getProductsDelegate?.getProductList?()
        }
        //by anand shrma
        else if (identiifier == "iPad_ProductInfoViewController"){
            self.view_bgPopup.isHidden = false
            setView(view: containerViewIpadProductInfo, hidden: false)
        }
        // by anand cancel product info popup
        else if (identiifier == "ipad_CancelProductInfo"){
            self.view_bgPopup.isHidden = true
            setView(view: containerViewIpadProductInfo, hidden: true)
        }
    }
    
    func didReceiveProductDetail(data: ProductsModel) {
        self.productsContainerDelegate?.didReceiveProductDetail?(data: data)
    }
}

//MARK: CartContainerViewControllerDelegate
extension CatAndProductsViewController: CartContainerViewControllerDelegate {
    func didTapOnPayButton(dict: JSONDictionary) {
        if !containerViewSelectCustomer.isHidden {
//            self.showAlert(message: "Please first save the customer information.")
            appDelegate.showToast(message: "Please first save the customer information.")
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        if dict["cartArray"] != nil {
            CartObjectData = dict as AnyObject
        }
        
        if let topVC = UIApplication.topViewController() as? SWRevealViewController {
            if let nav = topVC.frontViewController as? UINavigationController {
                if (nav.viewControllers.last?.isKind(of: CatAndProductsViewController.self)) ?? false {
                    self.performSegue(withIdentifier: "ipadpayment", sender: nil)
                }
            }
        }
    }
    
    func callOpenOrCloseCustomer() {
        if !containerViewSelectCustomer.isHidden {
//            self.showAlert(message: "Please first save the customer information.")
            appDelegate.showToast(message: "Please first save the customer information.")
            Indicator.sharedInstance.hideIndicator()
            appDelegate.isCustomerPageOpen = true
            return
        }
    }
    
    func didRemoveCartArray() {
        delegate?.didRemoveCartArray?()
    }
    
    func didUpdateCart(with identifier: String) {
        cartDelegate?.didUpdateCart?(with: identifier)
    }
    
    func didUpdateCartCountAndSubtotalPriceCoupon(dict: JSONDictionary) {
        cartContainerDelegate?.didUpdateCartCountAndSubtotalPriceCoupon?(dict: dict)
    }
}

//MARK: CustomerDelegates
extension CatAndProductsViewController: CustomerDelegates {
    
    func didEditCustomer(dict: JSONDictionary) {
        customerDelegatesForAddNew?.didEditCustomer?(dict: dict)
    }
    
    func didSelectAddCustomerButton() {
        customerDelegatesForSelectNew?.didSelectAddCustomerButton?()
        customerDelegatesForAddNew?.didSelectAddCustomerButton?()
    }
    func didAddNewCustomer() {
        customerDelegatesForCart?.didAddNewCustomer?()
        customerDelegatesForSelectNew?.didAddNewCustomer?()
        customerDelegatesForAddNew?.didAddNewCustomer?()
    }
    
    func didRefreshNewCustomer() {
        if let email = DataManager.customerObj?["str_email"] as? String  {
            invoiceEmail = email
        }
        cartContainerDelegate?.didUpdateCart?(with: "refreshCartForAddNewCustomerIPAD")
        if appDelegate.isHomeProductAPICall == true {
            appDelegate.isHomeProductAPICall = false
            productResetDelegate?.didShowInStockItemOnly?(isStock: isInStock) // 7dec2022 for wholesale
        }
    }
    
    func didSelectCustomer(data: CustomerListModel) {
        invoiceEmail = data.str_email
        customerDelegatesForCartSelectNew?.didSelectCustomer?(data: data)
        customerDelegatesForSelectNew?.didSelectCustomer?(data: data)
    }
}


//MARK: ShippingDelegate
extension CatAndProductsViewController: ShippingDelegate {
    func didSelectShipping(data: CustomerListModel) {
        shippingDelegate?.didSelectShipping?(data: data)
        shippingDelegateNew?.didSelectShipping?(data: data)
    }
}

//MARK: AddNewCutomerViewControllerDelegate
extension CatAndProductsViewController: SelectedCutomerDelegate {
    func selectedCustomerData(customerdata: CustomerListModel) {
        selectedCutomerDelegate?.selectedCustomerData(customerdata: customerdata)
    }
}

//MARK: EditProductDelegate
extension CatAndProductsViewController: EditProductDelegate {
    func didClickOnDoneButton() {
        hideEditView(isDone: true)
        cartDelegate?.refreshCart?()
    }
    
    func didClickOnCrossButton() {
        hideEditView(isDone: false)
    }
    
    func hideEditView(isDone: Bool) {
        setView(view: editProductDetailContainer, hidden: true)
        if isDone{
            productResetDelegate?.didAutoUpSellDataValue?()
        }
        
        UIView.animate(withDuration: Double(0.5), animations: {
            self.editProductDetailContainerTopConstraint.constant = UIScreen.main.bounds.height
            self.view.layoutIfNeeded()
            self.editProductBlurView.alpha = 0
            self.editProductBlurView.isHidden = true
        })
    }
    
    func didClickOnCloseButton() {
        setView(view: showDetailsContainer, hidden: true)
    }
    
    func hideShippingCard() {
        //self.paymentTypeDelegate?.didAddShippingRate?(rate: "40")
        setView(view: shippingContainer, hidden: true)
    }
    
    func doneShippingCard(rate: String) {
        self.paymentTypeDelegate?.didAddShippingRate?(rate: rate)
        setView(view: shippingContainer, hidden: true)
    }
    
    func showShippingCard() {
        setView(view: shippingContainer, hidden: false)
    }
    func didShowShippingAddress(data: CustomerListModel){
        showShippingDelegateOne?.didShowShippingAddress?(data: data)
    }
    func getCartProductsArray(data: Array<Any>){
        showShippingDelegateOne?.getCartProductsArray?(data: data)
    }
    func showSubscriptionView() {
        setView(view: subscriptionContainer, hidden: false)
    }
    
    func hideSubscriptionView() {
        setView(view: subscriptionContainer, hidden: true)
    }
    
    func sendSelectedSubscription(StrSubscription: String) {
        print("StrSubscription",StrSubscription)
        cartDelegate?.addSubscriptionString?(string: StrSubscription)
        
        setView(view: subscriptionContainer, hidden: true)
    }
    
}

//MARK: iPad_PaymentTypesViewControllerDelegate
extension CatAndProductsViewController: iPad_PaymentTypesViewControllerDelegate {
    func didUpdateShippingRefund(isselected: Bool) {
        self.paymentTypeDelegate?.didUpdateShippingRefund?(isselected: isselected)
    }
    func didResetCart() {
        self.paymentTypeDelegate?.didResetCart?()
    }
    
    func didUpdateCoupon(name: String, amount: Double) {
        self.paymentTypeDelegate?.didUpdateCoupon?(name: name, amount: amount)
    }
    
    func didUpdateManualDiscount(amount: Double, isPercentage: Bool) {
        self.paymentTypeDelegate?.didUpdateManualDiscount?(amount: amount, isPercentage: isPercentage)
    }
    
    func didUpdateTax(amount: Double, type: String, title: String) {
        self.paymentTypeDelegate?.didUpdateTax?(amount: amount, type: type, title: title)
    }
    
    func didUpdateShipping(amount: Double) {
        self.paymentTypeDelegate?.didUpdateShipping?(amount: amount)
    }
    
    func didUpdateCustomer(data: CustomerListModel) {
        self.paymentTypeDelegate?.didUpdateCustomer?(data: data)
    }
    
}

//MARK: ManualPaymentDelegate
extension CatAndProductsViewController: ManualPaymentDelegate {
    func didUpdateHeight(isKeyboardOpen: Bool) {
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            UIView.animate(withDuration: Double(0.5), animations: {
                self.editProductDetailContainerTopConstraint.constant =  isKeyboardOpen ? 20 : 180
            })
        }
    }
    
    func didTapOnCrossButton() {
        setView(view: manualPaymentContainer, hidden: true)
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
    
    func didTapOnAddButton() {
        self.cartContainerDelegate?.refreshCart?()
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
}

//MARK: OfflineDataManagerDelegate
extension CatAndProductsViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        pageController_Categories.isHidden = !isOn
        pageController_Products.isHidden = !isOn
        logoutButton.isHidden = !isOn
        logoutLineView.isHidden = !isOn
        
        if !isOn && DataManager.isOffline {
            setView(view: manualPaymentContainer, hidden: false)
        }else {
            categoryResetDelegate?.resetHomeCart?()
            productResetDelegate?.resetHomeCart?()
            cartResetDelegate?.resetHomeCart?()
        }
        
        self.updateUI()
        productResetDelegate?.updateKeyboardStatus?(isShow: manualPaymentContainer.isHidden)
        
    }
}

//MARK: OfflineDataManagerDelegate
extension CatAndProductsViewController: SwipeAndSearchConnectionDelegate {
    func didUpdateJackReader(isConnected: Bool) {
        self.audioButton.isSelected = isConnected
    }
}

//MARK: SWRevealViewControllerDelegate
extension CatAndProductsViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
}
//MARK: UITextFieldDelegate
extension CatAndProductsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return true
    }
}

//MARK: device name

extension CatAndProductsViewController {
    override func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        view_bgPopup.isHidden = true
    }
    override func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
}

extension CatAndProductsViewController: ChangeDeviceNamePopupVCDelegate {
    func deviceNameUpdatePopup(with string: String) {
        
        controller?.dismiss(animated: true, completion: nil)
        if string.trimmingCharacters(in: .whitespaces) == "" {
            view_bgPopup.isHidden = true
            DataManager.deviceNameText = deviceName.condenseWhitespace() == "" ? "POS" : deviceName
            posLabel.text = DataManager.deviceNameText
            self.tempSourcesName = DataManager.deviceNameText!
        }else {
            if  !HomeVM.shared.sourcesList.contains(string)  && tempSourcesName != string {
                           self.showAlert(title:"Confirm", message: "This will generate a new location, are you sure you want to proceed?", otherButtons: [kCancel:{ (_) in
                               //...
                            self.view_bgPopup.isHidden = true
                               
                               }], cancelTitle:"OK") { (_) in
                                self.view_bgPopup.isHidden = true
                                   if string != "" {
                                    var name = string.condenseWhitespace()
                                       name = name.trimmingCharacters(in: .whitespaces)
                                    name = name == "" ? self.deviceName : name
                                       DataManager.deviceNameText = name
                                       // self.delegate?.deviceNameUpdate?(with: name)
                                       
                                   }else {
                                    DataManager.deviceNameText = self.deviceName
                                       
                                   }
                                self.tempSourcesName = DataManager.deviceNameText!
                                   self.posLabel.text = DataManager.deviceNameText
                           }
                           
                       }else{
                view_bgPopup.isHidden = true
                if string != "" {
                    var name = string.condenseWhitespace()
                    name = name.trimmingCharacters(in: .whitespaces)
                    name = name == "" ? deviceName : name
                    DataManager.deviceNameText = name
                    // self.delegate?.deviceNameUpdate?(with: name)
                    
                }else {
                    DataManager.deviceNameText = deviceName
                }
                self.tempSourcesName = DataManager.deviceNameText!
                posLabel.text = DataManager.deviceNameText
            }
        }
        
    }
    
    func deviceNamePopHieght(with height: Float) {
        let heightView = self.view.frame.size.height - 150
        if Double(heightView) > Double(height)  {
            self.controller?.preferredContentSize = CGSize(width: 220, height: Int(height))
        }else {
            self.controller?.preferredContentSize = CGSize(width: 220, height: heightView)
        }
        
    }
    
    func deviceNamePopHide() {
        view_bgPopup.isHidden = true
        controller?.dismiss(animated: true, completion: nil)
    }
    
}

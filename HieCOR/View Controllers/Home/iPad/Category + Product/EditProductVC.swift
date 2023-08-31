//
//  EditProductVC.swift
//  HieCOR
//
//  Created by Deftsoft on 24/10/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SocketIO

class EditProductVC: BaseViewController {
    
    //MARK: Variables
    var delegate: EditProductDelegate?
    var productData = ProductsModel()
    var isVariationSelected = Bool()
    var isEditProduct = Bool()
    var apppliedDiscount: Double = 1000
    var productAttributeDetails = [ProductAttributeDetail]()
    var productVariationDetails = [ProductVariationDetail]()
    var productSurchargVariationDetails = [ProductSurchageVariationDetail]()
    var productItemMetaDetails = [ProductItemMetaFieldsDetail]()
    var isLandscape = true
    var availableProductQty = Double()
    var oldPrice = String()
    var oldDiscount = String()
    var ACCEPTABLE_CHARACTERS = "0123456789"
    var textViewPlaceholder = String()
    var iPadTableView = iPadTableViewCell()
    var arraySuchargevariation = JSONArray()
    var strVariationPrize = 0.0
    var arrRequried = JSONArray()
    var radioCount = 0
    var variationCount = 0
    var arrSelectRadio : [AttributeValues] = []
    //var arrayVariationData = JSONArray()
    var requiredCount = 0
    var isvariationparantPrize = true
    var variationsArray = JSONArray()
    var dictStockValue = JSONDictionary()
    var checkSingleVariation_attribute = false
    
    var arrTempAttSlct = [String]()
    var arrTempVar = [String]()
    var strDiscount = ""
    var strEditedPrize = ""
    
    var arrIntVariationQuantity = [Double]()
    var variationQuantity = 0.00001
    var variationRadioPrice = 0.0
    var surchargeCheckBoxPrice = 0.0
    var variationEditPrice = 0.0
    var variationEditPriceOn = 0.0
    var variationEditPriceEdit = 0.0
    //var variationRadioPrice = 0.0
    var tempsurchargeCheckBoxPrice = 0.0
    var isFirstOpen = true
    var versionOb = Int()
    var index = 0.0
    var dictSocket = [String: Any]()
    var productsArraySocket = Array<Any>()
    var MainproductsArraySocket = [Int: Any]()
    typealias responseCallBack = ((Bool) -> ())
    var delegateForProductInfo: ProductsContainerViewControllerDelegate?
    var editProductDelegate: EditProductsContainerViewDelegate?
    var selectedCollectionIndex = Int()
    var array_Products = [ProductsModel]()
    private var controller: PopViewController?
    var isDiscount = false
    var strCustomeStatus = ""
    var orderType: OrderType = .newOrder
    //MARK: IBOutlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var taxExemptButtton: UIButton!
    @IBOutlet weak var defaultDiscountButton: UIButton!
    @IBOutlet weak var tenPerDiscountButton: UIButton!
    @IBOutlet weak var twentyPerDiscountButton: UIButton!
    @IBOutlet weak var seventyPerDiscountButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customtextField: UITextField!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet var textView: UITextView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var discountTextField: UITextField!
    @IBOutlet var discountView: UIView!
    @IBOutlet var discountViewWidthConstraint: NSLayoutConstraint!
    // discountBackView: UIView!
    @IBOutlet weak var btnDiscount: UIButton!
    var str_showImagesFunctionality = String()
    
    @IBOutlet var discountEqualWidthConstraint: NSLayoutConstraint!
    @IBOutlet var discountStackView: UIStackView!
    @IBOutlet var minusButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet var qtyTextFieldWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var discountBackView: UIView!
    @IBOutlet weak var lblQuantityNew: UILabel!
    @IBOutlet weak var lblPriceNew: UILabel!
    @IBOutlet weak var lblTotalNew: UILabel!
    
    // by sudama add sub
    @IBOutlet weak var addSubscriptionBtn: UIButton!
    @IBOutlet weak var subscriptionDetailStackView: UIStackView!
    @IBOutlet weak var frequencySubTF: UITextField!
    @IBOutlet weak var daymnthTF: UITextField!
    @IBOutlet weak var unlimitedBtn: UIButton!
    @IBOutlet weak var numberOfOccuTF: UITextField!
    @IBOutlet weak var addSubHeaderView: UIView!
    @IBOutlet weak var footerViewForColletion: UIView!
    @IBOutlet weak var footerCollectionView: UICollectionView!
    // Create by Altab (17-oct-2022)
    @IBOutlet weak var hieghtConstOfSubscriptonDetailView: NSLayoutConstraint!
    @IBOutlet weak var hieghtOfAddSubscriptionBtnView: NSLayoutConstraint!
    
    @IBOutlet weak var btnProductInfo: UIButton!  // Create by Altab (17-oct-2022)
    @IBOutlet weak var btnDiscountIphone: UIButton!
    @IBOutlet weak var leadingConstTaxExemptButton: NSLayoutConstraint!
    var selectDaysMnth = ""
    var showArray = ["Days", "Months"]
    var serialNumberAry = [String]()
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.versionOb = Int(DataManager.appVersion)!
        self.setupTextFields()
        self.addGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isLandscape = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        variationEditPrice = 0.0
        let strNotes = productData.item_notes_title
        self.textViewPlaceholder = UI_USER_INTERFACE_IDIOM() == .pad ? strNotes : "Add a note      "
        self.customizeUI()
        self.updateButtonUI(tag: 1000)
        self.updateButtonTitle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.endEditing(true)
        self.tableView.reloadData()
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if productData.is_additional_product {
                discountViewWidthConstraint.constant = 0
            }else{
                if DataManager.isDiscountOptions {
                    discountViewWidthConstraint.constant = (UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height) ? 200 : 140
                }else{
                    discountViewWidthConstraint.constant = 0
                }
            }
        }
        if orderType == .refundOrExchangeOrder {
            discountViewWidthConstraint.constant = 0
        }
        //tableFooterViewHeight()
        tableHeaderViewHeight()
        footerCollectionView.reloadData()
    }
    
    func tableFooterViewHeight(){
        isLandscape = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        if productItemMetaDetails.count > 0 {
            let arrcount = productItemMetaDetails.count
            footerViewForColletion.isHidden = false
            if UI_USER_INTERFACE_IDIOM() == .pad {
                
                var count = 1
                if isLandscape {
                    print("Landscape")
                    if arrcount >= 4 {
                        count = 2
                    }else if arrcount >= 7 {
                        count = 3
                    }
                }else{
                    print("Portrait")
                    if arrcount.isMultiple(of: 2) {
                        let arrcount1 = arrcount / 2
                        count = arrcount1
                        //print("Number is even")
                    } else {
                        let arrcount1 = arrcount / 2
                        count = arrcount1 + 1
                        // print("Number is odd")
                    }
                }
                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((86 * count) + 84))
            }else{
                tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((84 * arrcount) + 60))
            }
        }else{
            footerViewForColletion.isHidden = true
            //  tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 71)
        }
        
    }
    // Create by Altab (17-oct-2022) for show model and serial number in header
    func tableHeaderViewHeight(){
        var showSubscriptionHight = 0
        if DataManager.showSubscription {
            
            hieghtOfAddSubscriptionBtnView.constant = 35
            if addSubscriptionBtn.isSelected {
                showSubscriptionHight = 170
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    hieghtConstOfSubscriptonDetailView.constant = 100
                } else {
                    showSubscriptionHight = 80
                    hieghtConstOfSubscriptonDetailView.constant = 100
                }
            }else {
                showSubscriptionHight = 35
                hieghtConstOfSubscriptonDetailView.constant = 0.0
            }
        }else{
            hieghtConstOfSubscriptonDetailView.constant = 0.0
            hieghtOfAddSubscriptionBtnView.constant = 0.0
        }
        //DataManager.showSubscription =
     //   addSubscriptionBtn.isSelected = 170 , 45
        isLandscape = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        if productItemMetaDetails.count > 0 {
            addSubHeaderView.isHidden = false
            let arrcount = productItemMetaDetails.count
            footerViewForColletion.isHidden = false
            if UI_USER_INTERFACE_IDIOM() == .pad {
                
                var count = 1
                if isLandscape {
                    print("Landscape")
                    if arrcount >= 4 {
                        count = 2
                    }else if arrcount >= 7 {
                        count = 3
                    }
                }else{
                    print("Portrait")
                    if arrcount.isMultiple(of: 2) {
                        let arrcount1 = arrcount / 2
                        count = arrcount1
                        //print("Number is even")
                    } else {
                        let arrcount1 = arrcount / 2
                        count = arrcount1 + 1
                        // print("Number is odd")
                    }
                }
                tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((86 * count) + showSubscriptionHight))
            }else{
                if addSubscriptionBtn.isSelected  {
                    showSubscriptionHight = 110
                    hieghtConstOfSubscriptonDetailView.constant = 100
                    tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((84 * arrcount) + showSubscriptionHight + 40))
                }else {
                    showSubscriptionHight = 35
                    tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat((84 * arrcount) + showSubscriptionHight))
                }
            }
        }else{
            if UI_USER_INTERFACE_IDIOM() == .pad {
                tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(showSubscriptionHight))
            }else{
                if addSubscriptionBtn.isSelected  {
                    showSubscriptionHight = 140
                    hieghtConstOfSubscriptonDetailView.constant = 120
                    tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(showSubscriptionHight + 30))
                }else{
                    tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(showSubscriptionHight))

                }
            }
            footerViewForColletion.isHidden = true
            //  tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: 71)
        }
        tableView.reloadData()
       // footerCollectionView.reloadData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Private FUnctions
    private func customizeUI() {
        
        // by sudama add sub
        if DataManager.showSubscription {
            unlimitedBtn.isSelected = true
            numberOfOccuTF.isEnabled = false
            numberOfOccuTF.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8941176471, blue: 0.9098039216, alpha: 1)
            addSubscriptionBtn.isHidden = false
            
            addSubHeaderView.isHidden = false
            frequencySubTF.setPadding()
            frequencySubTF.setRightPadding()
            daymnthTF.setPadding()
            daymnthTF.setRightPadding()
            numberOfOccuTF.setPadding()
            numberOfOccuTF.setRightPadding()
            daymnthTF.setDropDown()
            tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(45))
            
        }else{
            addSubscriptionBtn.isHidden = true
            addSubHeaderView.isHidden = true
            tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(0))
            
        }
        //
      //  tableFooterViewHeight()
        tableHeaderViewHeight()
        if UI_USER_INTERFACE_IDIOM() == .pad {
            discountTextField.setDropDown()
            self.discountTextField.isHidden = !DataManager.isDiscountOptions
            self.btnDiscount.isHidden = !DataManager.isDiscountOptions
            if DataManager.isDiscountOptions {
                self.discountTextField.isHidden = orderType == .refundOrExchangeOrder
                self.btnDiscount.isHidden = orderType == .refundOrExchangeOrder
            }
            let outerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
            discountTextField.leftView = outerView2
            discountTextField.leftViewMode = .always
        } else {
            self.btnDiscountIphone.isHidden = !DataManager.isDiscountOptions
            //self.discountBackView.isHidden = !DataManager.isDiscountOptions
            if DataManager.isDiscountOptions {
                self.btnDiscountIphone.isHidden = orderType == .refundOrExchangeOrder
                //self.discountBackView.isHidden = orderType == .refundOrExchangeOrder
            }
            if UIScreen.main.bounds.width < 375 {
                self.discountStackView.axis = .vertical
                self.discountEqualWidthConstraint.isActive = false
                self.minusButtonWidthConstraint.constant = 30
                self.qtyTextFieldWidthConstraint.constant = 45
            } else {
                self.qtyTextFieldWidthConstraint.isActive = false
            }
        }
        customtextField.setPlaceholder(color: #colorLiteral(red: 1, green: 0.2784860432, blue: 0.9018586278, alpha: 1))
        self.taxExemptButtton.isHidden = !DataManager.isLineItemTaxExempt
        self.taxExemptButtton.isHidden = orderType == .refundOrExchangeOrder
        self.btnProductInfo.isHidden = DataManager.isPosProductViewInfo == "true" ? false : true
        //Set Padding
        priceTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        priceTextField.leftViewMode = .always
        priceTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        priceTextField.rightViewMode = .always
        priceTextField.isUserInteractionEnabled = orderType == .newOrder
        //Set padding
        let outerView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        customtextField.leftView = outerView1
        customtextField.leftViewMode = .always
        tableView.tableFooterView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(60))
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.discountView.isHidden = true
        }
    }
    
    private func setupTextFields() {
        //Set Delegate To Self
        
        qtyTextField.delegate = self
        //by sudama
        frequencySubTF.delegate = self
        numberOfOccuTF.delegate = self
        daymnthTF.delegate = self
        daymnthTF.addTarget(self, action: #selector(handleSelectfDayMnthTextField(sender:)), for: .editingDidBegin)
        daymnthTF.text = "Days"
        
        //
        customtextField.delegate = self
        customtextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func updateQuantity(isAdd: Bool = false, isButtonAction: Bool = false) {
        var availableqty:Double = 1
        self.getVariationSurchageValue()
        
        let selectedIDArray = self.getSelectedIDArray()
        var productQtyInCart = self.getPreviousQty(productId: self.productData.str_product_id, productAttributesID: selectedIDArray)
        
        if productData.unlimited_stock == "Yes" {
            availableqty = 9999
        }else if (productData.unlimited_stock == "No" && productData.str_limit_qty == "0") {
            availableqty = Double(productData.str_stock) ?? 0
        } else {
            availableqty = Double(productData.str_limit_qty) ?? 0
        }
        
        let limitqty = Double(self.productData.str_limit_qty) ?? 0
        
        availableProductQty = availableqty
        
        if let value = Double(qtyTextField.text ?? "") {
            
            if DataManager.noInventoryPurchase == "false" {
                
                availableqty = Double(productData.str_stock) ?? 0
                availableProductQty = availableqty
                //                if availableqty > 0 {
                //                    if Int((productQtyInCart + value)) > Int(availableqty) {
                //                        self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                //                        return
                //                    }
                //                }
                //                    productQtyInCart = value
                //                    if limitqty > 0 {
                //                        if Int( value)) > Int(limitqty) {
                //                            self.showAlert(title: "Warning!", message: "\(productData.str_title) Has Limited Purchase - \(availableqty.newValue)")
                //                            return
                //                        }
                //                    }
                if limitqty > 0 {
                    availableProductQty = limitqty
                }
                
                
                if productData.unlimited_stock == "Yes" {
                    availableqty = 9999999
                    availableProductQty = availableqty
                } else {
                    if variationQuantity != 0.00001 {
                        if Double((productQtyInCart + value)) > variationQuantity {
                            //                            print("enterrrrrrrr")
                            //                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(variationQuantity)")
                            //                            return
                            availableProductQty = variationQuantity
                        } else {
                            availableqty = Double(variationQuantity)
                            availableProductQty = availableqty
                            print("ouuuuuutttterrerrerre")
                        }
                    }
                }
            } else {
                availableqty = 9999999
                if limitqty > 0 {
                    //                    if Int((productQtyInCart + value)) > Int(limitqty) {
                    //                        self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                    //                        return
                    //                    }
                }
            }
            
            //            if (value + 1) > availableqty {
            //                self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
            //                return
            //            } else if productQtyInCart + (value - 1) > availableqty {
            //                self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(availableqty.newValue)")
            //                return
            //            }
            //            qtyTextField.text = productData.isAllowDecimal ? (value + 1).roundToTwoDecimal : (value + 1).roundOFF
            //
            //            //lblPriceNew.text = "$\((price).roundToTwoDecimal)"
            //            lblQuantityNew.text = qtyTextField.text
            //
            //            var price = self.lblPriceNew.text ?? ""
            //            price = price.replacingOccurrences(of: " ", with: "")
            //            price = price.replacingOccurrences(of: "$", with: "")
            //            let newPrice = price.toDouble()
            //            let qty = qtyTextField.text?.toDouble()
            //            let totalPrice = newPrice! * qty!
            //            lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
        }
        
        var currentQty = 0.0
        
        if let index = DataManager.cartProductsArray?.index(where: {(($0 as! JSONDictionary)["row_id"] as? Double ?? 0.0 == self.productData.row_id)}) {
            if var dict = DataManager.cartProductsArray?[index] as? JSONDictionary {
                currentQty = Double(dict["productqty"] as? String ?? "") ?? 0
            }
        }
        
        //Add By One
        if isAdd && isButtonAction {
            
            if let value = Double(qtyTextField.text ?? "") {
                
                if DataManager.noInventoryPurchase == "false" {
                    
                    availableqty = Double(productData.str_stock) ?? 0
                    availableProductQty = availableqty
                    if availableqty > 0 {
                        
                        //if DataManager.isSplitRow == true {
                        
                        if Int((productQtyInCart + value + 1) - currentQty) > Int(availableqty) {
                            //                                self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                            appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                            return
                        }
                        //                        } else {
                        //                            if Int((productQtyInCart - value) + value) > Int(availableqty) {
                        //                                self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                        //                                return
                        //                            }
                        //                        }
                    }
                    //                    productQtyInCart = value
                    //                    if limitqty > 0 {
                    //                        if Int( value)) > Int(limitqty) {
                    //                            self.showAlert(title: "Warning!", message: "\(productData.str_title) Has Limited Purchase - \(availableqty.newValue)")
                    //                            return
                    //                        }
                    //                    }
                    if limitqty > 0 {
                        availableProductQty = limitqty
                        if isEditProduct {
                            if Int((productQtyInCart + value + 1) - currentQty) > Int(limitqty) {
                                //                                self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                return
                            }
                        } else {
                            if Int((productQtyInCart + value )) > Int(limitqty) {
                                //                                self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                return
                            }
                        }
                        
                        //                        if Int((productQtyInCart + value)) > Int(limitqty) {
                        //                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                        //                            return
                        //                        }
                    }
                    
                    
                    if productData.unlimited_stock == "Yes" {
                        availableqty = 9999999
                        availableProductQty = availableqty
                    } else {
                        if variationQuantity != 0.00001 {
                            
                            if isEditProduct {
                                if Double((value)) > variationQuantity {
                                    print("enterrrrrrrr")
                                    //                                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(variationQuantity)")
                                    appDelegate.showToast(message:  "\(self.productName.text ?? "") Has Limited Stock - \(variationQuantity)")
                                    return
                                } else {
                                    availableqty = Double(variationQuantity)
                                    availableProductQty = availableqty
                                    print("ouuuuuutttterrerrerre")
                                }
                            } else {
                                if Double((productQtyInCart + value)) > variationQuantity {
                                    print("enterrrrrrrr")
                                    //                                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(variationQuantity)")
                                    appDelegate.showToast(message:"\(self.productName.text ?? "") Has Limited Stock - \(variationQuantity)")
                                    return
                                } else {
                                    availableqty = Double(variationQuantity)
                                    availableProductQty = availableqty
                                    print("ouuuuuutttterrerrerre")
                                }
                            }
                            
                            
                        }
                    }
                    
                    
                    
                } else {
                    availableqty = 9999999
                    if limitqty > 0 {
                        if Int((productQtyInCart + value)) > Int(limitqty) {
                            //                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                            appDelegate.showToast(message:"\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                            return
                        }
                    }
                }
                
                if (value + 1) > availableqty {
                    //                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                    appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                    return
                } else if productQtyInCart + (value - 1) > availableqty && !isEditProduct {
                    //                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(availableqty.newValue)")
                    appDelegate.showToast(message:"\(self.productName.text ?? "") Has Limited Purchase - \(availableqty.newValue)")
                    return
                } else if (value - 1) > availableqty && isEditProduct {
                    //                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(availableqty.newValue)")
                    appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Purchase - \(availableqty.newValue)")
                    return
                }
                qtyTextField.text = productData.isAllowDecimal ? (value + 1).roundToTwoDecimal : (value + 1).roundOFF
                
                //lblPriceNew.text = "$\((price).roundToTwoDecimal)"
                lblQuantityNew.text = qtyTextField.text
                
                var price = self.lblPriceNew.text ?? ""
                price = price.replacingOccurrences(of: " ", with: "")
                price = price.replacingOccurrences(of: "$", with: "")
                let newPrice = price.toDouble()
                let qty = qtyTextField.text?.toDouble()
                let totalPrice = newPrice! * qty!
                lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
            }
            return
        }
        
        //Sub By One
        if !isAdd && isButtonAction {
            if let value = Double(qtyTextField.text ?? "") {
                if (value - 1) <= 0 {
                    return
                }
                
                index = +1
                
                qtyTextField.text = productData.isAllowDecimal ? (value - 1).roundToTwoDecimal : (value - 1).roundOFF
                lblQuantityNew.text = qtyTextField.text
                
                var price = self.lblPriceNew.text ?? ""
                price = price.replacingOccurrences(of: " ", with: "")
                price = price.replacingOccurrences(of: "$", with: "")
                let newPrice = price.toDouble()
                let qty = qtyTextField.text?.toDouble()
                let totalPrice = newPrice! * qty!
                lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
            }
            return
        }
    }
    
    private func updateTotal() {
        var discount = apppliedDiscount
        
        switch apppliedDiscount {
        case 1000:
            discount = 0
            break
        case 2000:
            discount = DataManager.tenDiscountValue
            break
        case 3000:
            discount = DataManager.twentyDiscountValue
            break
        case 4000:
            discount = DataManager.seventyDiscountValue
            break
        default: break
        }
        
        self.updateTotal(with: discount)
    }
    
    private func updateTotal(with discount: Double, isNoDiscount: Bool = false, isEdited: Bool = false) {
        var price = (Double(isEditProduct ? productData.mainPrice : productData.str_price) ?? 0)
        //var addOnAmount = Double()
        
        getVariationSurchageValue()
        
        var variationPrice = 0.0
        
        if isvariationparantPrize == true {
            
            if strEditedPrize != "" {
                price = strEditedPrize.toDouble()!
            }
            
            variationPrice = price
            
            if strVariationPrize > 0 {
                variationEditPrice = 0.0
            }
            
        } else {
            variationPrice = 0.0
        }
        
        price = variationPrice + strVariationPrize
        
        if variationEditPrice != 0.0 {
            price = variationEditPrice
        }
        
//        if variationEditPriceEdit != 0.0 {
//            if strEditedPrize == "" {
//
//            } else {
//                price = strEditedPrize.toDouble()!
//            }
//            if discount > 0 {
//                variationEditPriceEdit = price
//            } else {
//                variationEditPriceEdit = price
//            }
//            price = variationEditPriceEdit
//        }   // for variation 18may
        
        if isDiscount {
            isDiscount = false
            if variationEditPriceEdit != 0.0 {
                let strval = self.priceTextField.text
                let newString = strval?.replacingOccurrences(of: "$", with: "", options: .literal, range: nil)
                print(newString?.toDouble())
                price = newString?.toDouble() ?? 0.0
                variationEditPriceEdit = price
            }
        }
        
        
        if variationEditPriceOn != 0.0 {
            price = variationEditPriceOn
        }
        
        
        
        self.priceTextField.text = "$\((price).roundToTwoDecimal)"
        
        if discount > 0 {
            price = price - (price/100 * discount)
            
            if textView.text == textViewPlaceholder || textView.text == "" {
                textView.text = ""
                textView.textColor = UIColor.black
            }
            
            let hh = self.textView.text.replacingOccurrences(of: strDiscount, with: "")
            
            self.textView.text = "\(hh) \(discount.currencyFormatA)% Discount".condenseWhitespace()
            
            strDiscount = "\(discount.currencyFormatA)% Discount".condenseWhitespace()
            
            tempsurchargeCheckBoxPrice = 0.0
            
            //            lblPriceNew.text = "$\((price).roundToTwoDecimal)"
            //
            //            lblQuantityNew.text = qtyTextField.text
            
            
            lblPriceNew.text = "$\((price).roundToTwoDecimal)"
            lblQuantityNew.text = qtyTextField.text
            
            if qtyTextField.text == "" {
                qtyTextField.text = productData.isAllowDecimal ? "1.00" : "1"
            }
            let qty = qtyTextField.text?.toDouble()
            let totalPrice = price * qty!
            lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
            
        } else {
            
            let hh = self.textView.text.replacingOccurrences(of: strDiscount, with: "")
            
            self.textView.text = hh.condenseWhitespace()
            
            if textView.text == "" {
                textView.text = textViewPlaceholder.condenseWhitespace()
                textView.textColor = UIColor.darkGray
            }
            
            if !isNoDiscount {
                price = variationPrice + strVariationPrize
            }
            if variationEditPrice != 0.0 {
                
                price = variationEditPrice
                
            }
            lblPriceNew.text = "$\((price).roundToTwoDecimal)"
            lblQuantityNew.text = qtyTextField.text
            
            if qtyTextField.text == "" {
                qtyTextField.text = productData.isAllowDecimal ? "1.00" : "1"
            }
            let qty = qtyTextField.text?.toDouble()
            let totalPrice = price * qty!
            lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
        }
        
        price = price < 0 ? 0 : price
        
        if variationEditPriceOn != 0.0 {
            variationEditPrice = 0.0
        }
    }
    
    
    private func updateTotalTextField(with discount: Double, Amount: Double) {
        var price = Amount
        //var addOnAmount = Double()
        
        //        if strEditedPrize != "" {
        //            price = strEditedPrize.toDouble()!
        //        }
        //
        //        getVariationSurchageValue()
        //
        //        var variationPrice = 0.0
        //
        //        if isvariationparantPrize == true {
        //            variationPrice = price
        //        } else {
        //            variationPrice = 0.0
        //        }
        
        //price = variationPrice + strVariationPrize
        
        // getVariationSurchageValue()
        
        //        if isvariationparantPrize == true {
        //            //price = Amount
        //        } else {
        //            strEditedPrize = ""
        //            //variationPrice = 0.0
        //        }
        
        
        self.priceTextField.text = "$\((price).roundToTwoDecimal)"
        
        if discount > 0 {
            price = price - (price/100 * discount)
            
            if textView.text == textViewPlaceholder || textView.text == "" {
                textView.text = ""
                textView.textColor = UIColor.black
            }
            
            let hh = self.textView.text.replacingOccurrences(of: strDiscount, with: "")
            
            self.textView.text = "\(hh) \(Int(discount))% Discount".condenseWhitespace()
            
            strDiscount = "\(Int(discount))% Discount".condenseWhitespace()
            
            lblPriceNew.text = "$\((price).roundToTwoDecimal)"
            
            lblQuantityNew.text = qtyTextField.text
            
            
            let qty = qtyTextField.text?.toDouble()
            let totalPrice = price * qty!
            lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
            
        } else {
            
            let hh = self.textView.text.replacingOccurrences(of: strDiscount, with: "")
            
            self.textView.text = hh.condenseWhitespace()
            
            if textView.text == "" {
                textView.text = textViewPlaceholder
                textView.textColor = UIColor.darkGray
            }
            
            //lblPriceNew.text = "$\((price).roundToTwoDecimal)"
            lblPriceNew.text = "$\((price).roundToTwoDecimal)"
            lblQuantityNew.text = qtyTextField.text
            
            
            let qty = qtyTextField.text?.toDouble()
            let totalPrice = price * qty!
            lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
        }
        
        
        if self.isvariationparantPrize {
            
        } else {
            variationEditPrice = 0.0
            strEditedPrize = ""
        }
        
        price = price < 0 ? 0 : price
    }
    
    private func updateButtonTitle() {
        tenPerDiscountButton.setTitle("\(DataManager.tenDiscountValue.newValue)% of Sale", for: .normal)
        twentyPerDiscountButton.setTitle("\(DataManager.twentyDiscountValue.newValue)% of Sale", for: .normal)
        seventyPerDiscountButton.setTitle("\(DataManager.seventyDiscountValue.newValue)% of Sale", for: .normal)
    }
    
    private func updateButtonUI(tag: Int) {
        switch tag {
        case 1000:
            apppliedDiscount = 1000
            customtextField.text = ""
            if UI_USER_INTERFACE_IDIOM() == .phone {
                defaultDiscountButton.setTitleColor(UIColor.white, for: .normal)
                defaultDiscountButton.backgroundColor = #colorLiteral(red: 0, green: 0.5098039216, blue: 0.831372549, alpha: 1) //#colorLiteral(red: 0, green: 0.5098039216, blue: 0.7450980392, alpha: 1) //UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0)
                
                tenPerDiscountButton.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
                tenPerDiscountButton.backgroundColor = UIColor.white
                twentyPerDiscountButton.setTitleColor(UIColor.blue, for: .normal)
                twentyPerDiscountButton.backgroundColor = UIColor.white
                seventyPerDiscountButton.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
                seventyPerDiscountButton.backgroundColor = UIColor.white
            } else {
                discountTextField.text = "No Discount"
                self.discountView.isHidden = true
            }
            
            break
        case 2000:
            apppliedDiscount = 2000
            customtextField.text = ""
            if UI_USER_INTERFACE_IDIOM() == .phone {
                defaultDiscountButton.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
                defaultDiscountButton.backgroundColor = UIColor.white
                tenPerDiscountButton.setTitleColor(UIColor.white, for: .normal)
                tenPerDiscountButton.backgroundColor = #colorLiteral(red: 0, green: 0.5098039216, blue: 0.831372549, alpha: 1) //UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
                twentyPerDiscountButton.setTitleColor(UIColor.blue, for: .normal)
                twentyPerDiscountButton.backgroundColor = UIColor.white
                seventyPerDiscountButton.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
                seventyPerDiscountButton.backgroundColor = UIColor.white
            } else {
                discountTextField.text = DataManager.tenDiscountValue.newValue + "% Discount"
                self.discountView.isHidden = true
            }
            
            break
        case 3000:
            apppliedDiscount = 3000
            customtextField.text = ""
            if UI_USER_INTERFACE_IDIOM() == .phone {
                defaultDiscountButton.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
                defaultDiscountButton.backgroundColor = UIColor.white
                tenPerDiscountButton.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
                tenPerDiscountButton.backgroundColor = UIColor.white
                twentyPerDiscountButton.setTitleColor(UIColor.white, for: .normal)
                twentyPerDiscountButton.backgroundColor = #colorLiteral(red: 0, green: 0.5098039216, blue: 0.831372549, alpha: 1) //UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
                seventyPerDiscountButton.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
                seventyPerDiscountButton.backgroundColor = UIColor.white
            } else {
                discountTextField.text = DataManager.twentyDiscountValue.newValue + "% Discount"
                self.discountView.isHidden = true
            }
            
            break
        case 4000:
            apppliedDiscount = 4000
            customtextField.text = ""
            if UI_USER_INTERFACE_IDIOM() == .phone {
                defaultDiscountButton.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
                defaultDiscountButton.backgroundColor = UIColor.white
                tenPerDiscountButton.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
                tenPerDiscountButton.backgroundColor = UIColor.white
                twentyPerDiscountButton.setTitleColor(UIColor.blue, for: .normal)
                twentyPerDiscountButton.backgroundColor = UIColor.white
                seventyPerDiscountButton.setTitleColor(UIColor.white, for: .normal)
                seventyPerDiscountButton.backgroundColor = #colorLiteral(red: 0, green: 0.5098039216, blue: 0.831372549, alpha: 1) // UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            } else {
                discountTextField.text = DataManager.seventyDiscountValue.newValue + "% Discount"
                self.discountView.isHidden = true
            }
            
            break
        case 5000:
            //apppliedDiscount = Double(tag)
            if UI_USER_INTERFACE_IDIOM() == .phone {
                defaultDiscountButton.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
                defaultDiscountButton.backgroundColor = UIColor.white
                tenPerDiscountButton.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
                tenPerDiscountButton.backgroundColor = UIColor.white
                twentyPerDiscountButton.setTitleColor(UIColor.blue, for: .normal)
                twentyPerDiscountButton.backgroundColor = UIColor.white
                seventyPerDiscountButton.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
                seventyPerDiscountButton.backgroundColor = UIColor.white
            }
            
            break
            
        default: break
        }
    }
    
    private func updateProductDetail(with index: Int? = nil) {
        selectedCollectionIndex = index ?? 0
        if let val = DataManager.showImagesFunctionality {
            self.str_showImagesFunctionality = val
        }
        textViewPlaceholder = productData.item_notes_title
        if textViewPlaceholder == "" {
            textViewPlaceholder = "Notes"
        }
        self.productImage.image = #imageLiteral(resourceName: "m-payment")  //Dummy
        self.availableProductQty = 0
        if isEditProduct {
            guard let index = index else { return }
            if let dict = DataManager.cartProductsArray?[index] as? JSONDictionary {
                //Update Label
                let qty = Double(dict["productqty"] as? String ?? "") ?? 0
                let imageURL = dict["productimage"] as? String ?? ""
                let imageData = dict["productimagedata"] as? Data
                let price = Double(dict["productprice"] as? String ?? "") ?? 0
                let mainPrice = Double(dict["mainprice"] as? String ?? "") ?? 0
                let isTaxable = dict["productistaxable"] as? String ?? ""
                let isTaxExempt = dict["isTaxExempt"] as? String ?? "No"
                let notes = dict["productNotes"] as? String ?? ""
                let pricetext = Double(dict["textPrice"] as? String ?? "") ?? 0
                strEditedPrize = "\(pricetext)"
                apppliedDiscount = dict["apppliedDiscount"] as? Double ?? 1000
                productData.str_product_id = dict["productid"] as? String ?? ""
                productData.str_stock = dict["productstock"] as? String ?? ""
                productData.str_limit_qty = dict["productlimitqty"] as? String ?? ""
                productData.is_taxable = dict["productistaxable"] as? String ?? ""
                productData.unlimited_stock = dict["productunlimitedstock"] as? String ?? ""
                productData.shippingPrice = dict["shippingPrice"] as? String ?? ""
                productData.str_long_description = dict["productdesclong"] as? String ?? ""
                productData.str_price = price.roundToTwoDecimal
                productData.mainPrice = mainPrice.roundToTwoDecimal
                strEditedPrize = "\(mainPrice.roundToTwoDecimal)" // for variation 18may
                if isEditProduct{
                    strEditedPrize = "\(pricetext.roundToTwoDecimal)" // for variation 16feb
                }
                productData.variations = dict["variations"] as? JSONDictionary ?? JSONDictionary()
                productData.surchargeVariations = dict["surcharge_variations"] as? JSONDictionary ?? JSONDictionary()
                productData.taxDetails = dict["tax_detail"] as? JSONDictionary ?? JSONDictionary()
                productData.isAllowDecimal = dict["qty_allow_decimal"] as? Bool ?? false
                productData.isEditPrice = dict["prompt_for_price"] as? Bool ?? false
                productData.isEditQty = dict["prompt_for_quantity"] as? Bool ?? false
                productData.width = dict["width"] as? Double ?? 0.0
                productData.height = dict["height"] as? Double ?? 0.0
                productData.length = dict["length"] as? Double ?? 0.0
                productData.weight = dict["weight"] as? Double ?? 0.0
                productData.allow_credit_product = dict["allow_credit_product"] as? Bool ?? false
                productData.allow_purchase_product = dict["allow_purchase_product"] as? Bool ?? false
                productData.is_additional_product = dict["is_additional_product"] as? Bool ?? false
                
                // by sudama add sub
                let frequencySub = dict["frequencySub"] as? String ?? ""
                let daymnth = dict["daymnth"] as? String ?? ""
                let numberOfOcc = dict["numberOfOcc"] as? String
                let unlimitedCheck = dict["unlimitedCheck"] as? Bool ?? false
                let addSubscription = dict["addSubscription"] as? Bool ?? false
                
                frequencySubTF.text = frequencySub
                numberOfOccuTF.text = numberOfOcc
                daymnthTF.text = daymnth
                unlimitedBtn.isSelected = unlimitedCheck != false
                if unlimitedBtn.isSelected {
                    numberOfOccuTF.isEnabled = false
                    numberOfOccuTF.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8941176471, blue: 0.9098039216, alpha: 1)
                }else {
                    numberOfOccuTF.isEnabled = true
                    numberOfOccuTF.backgroundColor = .white
                }
                addSubscriptionBtn.isSelected = addSubscription != false
                if addSubscriptionBtn.isSelected {
                    subscriptionDetailStackView.isHidden = false
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(145))
                    }else{
                        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(170))
                    }
                    
                }else{
                    subscriptionDetailStackView.isHidden = true
                    if DataManager.showSubscription {
                        addSubscriptionBtn.isHidden = false
                        addSubHeaderView.isHidden = false
                        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(45))
                    }else{
                        addSubscriptionBtn.isHidden = true
                        addSubHeaderView.isHidden = true
                        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(0))
                    }
                    
                }
                
                //
                let itemMetaFieldsArray = dict["itemMetaFieldsArray"] as? JSONArray ?? JSONArray()
                self.productItemMetaDetails = ProductModel.shared.getProductItemMetaFieldsStruct(jsonArray: itemMetaFieldsArray)
                
         //       tableFooterViewHeight()
                tableHeaderViewHeight()
                self.productData.row_id = dict["row_id"] as? Double ?? 0.0
                let attributesArray = dict["attributesArray"] as? JSONArray ?? JSONArray()
                self.productAttributeDetails = ProductModel.shared.getProductDetailStruct(jsonArray: attributesArray)
                
                let variationArray = dict["variationArray"] as? JSONArray ?? JSONArray()
                self.productVariationDetails = ProductModel.shared.getProductDetailVariationStruct(jsonArray: variationArray)
                
                let surchageVariationArray = dict["surchargVariationArray"] as? JSONArray ?? JSONArray()
                self.productSurchargVariationDetails = ProductModel.shared.getProductDetailSurchargeVariationStruct(jsonArray: surchageVariationArray)
                
                self.getSurchageData()
                
                if self.str_showImagesFunctionality == "true" {
                    let image = UIImage(named: "category-bg")
                    if let url = URL(string: imageURL) {
                        self.productImage.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
                    }else {
                        if  let data = imageData {
                            self.productImage?.image = UIImage(data: data)
                        }
                    }
                }else{
                    self.productImage.image = self.productImage.image?.withRenderingMode(.alwaysTemplate)
                    self.productImage.tintColor =  #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
                }
                
                
                var textPrice = Double(dict["textPrice"] as? String ?? "") ?? 0
                
                if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                    self.priceTextField.text = "$\(price.roundToTwoDecimal)"
                } else {
                    self.priceTextField.text = "$\(textPrice.roundToTwoDecimal)"
                }
                
                self.descriptionLabel.text = productData.str_long_description
                self.textView.text = notes == "" ? textViewPlaceholder : notes
                self.textView.textColor = notes == "" ? #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1) : UIColor.black
                let strCode = dict["productCode"] as? String ?? ""
                let strName = dict["producttitle"] as? String ?? ""
                self.productName.text = strCode + ":" + strName
                self.qtyTextField.text = productData.isAllowDecimal ? qty.roundToTwoDecimal : qty.roundOFF
                //self.priceTextField.text = "$\(price.roundToTwoDecimal)"
                self.taxExemptButtton.isSelected = isTaxExempt.lowercased() != "no"
                self.taxExemptButtton.isHidden = !DataManager.isLineItemTaxExempt || isTaxable.lowercased() == "no"
                variationEditPriceEdit = price
                var discounttext = dict["apppliedDiscountString"] as? String ?? ""
                if discounttext != "" {
                    discounttext = discounttext.replacingOccurrences(of: "% Discount", with: "")
                    let dis = Double(discounttext)
                    if dis! > 0 {
                        let Prices = Double(dict["textPrice"] as? String ?? "") ?? 0
                        let data = Prices - (Prices/100 * dis!)
                        lblPriceNew.text = "$\(data.roundToTwoDecimal)"
                        
                        lblQuantityNew.text = qtyTextField.text
                        let qtyOne = qtyTextField.text?.toDouble()
                        let totalPrice = price * qtyOne!
                        lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
                    }
                } else {
                    lblPriceNew.text = "$\(price.roundToTwoDecimal)"
                    lblQuantityNew.text = qtyTextField.text
                    let qtyOne = qtyTextField.text?.toDouble()
                    let totalPrice = price * qtyOne!
                    lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
                }
                
                
                
                
                self.parserDictDataToModel(dict: dict)
                
                // price = price.replacingOccurrences(of: "$", with: "")
                
            }
            if !Keyboard._isExternalKeyboardAttached() {
                if productData.isEditQty == true && productData.isEditPrice == true{
                    self.qtyTextField.becomeFirstResponder()
                    self.qtyTextField.selectAll(nil)
                }else if productData.isEditQty == true {
                    self.qtyTextField.becomeFirstResponder()
                    self.qtyTextField.selectAll(nil)
                }else if productData.isEditPrice == true {
                    self.priceTextField.becomeFirstResponder()
                    self.priceTextField.selectAll(nil)
                }
            }
            
            
        } else {
            
            variationEditPriceEdit = 0.0
            variationRadioPrice = 0.0
            strVariationPrize = 0.0
            variationEditPrice = 0.0
            strEditedPrize = ""
            variationEditPriceOn = 0.0
            
            self.getSurchageData()
            
            
            if self.str_showImagesFunctionality == "true" {
                let image = UIImage(named: "category-bg")
                if let url = URL(string: productData.str_product_image) {
                    self.productImage.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
                } else {
                    if  let data = productData.productImageData {
                        self.productImage?.image = UIImage(data: data)
                    }
                }
            }else{
                self.productImage.image = self.productImage.image?.withRenderingMode(.alwaysTemplate)
                self.productImage.tintColor =  #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
            }
            self.apppliedDiscount = 1000
            self.productName.text = productData.str_product_code + ":" + productData.str_title
            self.priceTextField.text = "$\((Double(productData.str_price) ?? 0.0).roundToTwoDecimal)"
            self.descriptionLabel.text = productData.str_long_description
            
            textView.text = textViewPlaceholder
            textView.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
            
            self.qtyTextField.text =  productData.isAllowDecimal ? "1.00" : "1"
            if let customerStatus = DataManager.customerObj?["customer_status"] as? String  {
                strCustomeStatus = customerStatus
            } else {
                if orderType == .refundOrExchangeOrder {
                    strCustomeStatus = (OrderVM.shared.orderInfo.customer_status == "WHOLESALE CUSTOMER") ? "WHOLESALE CUSTOMER" : ""
                } else {
                    strCustomeStatus = ""
                }
            }
            if strCustomeStatus == "WHOLESALE CUSTOMER" || strCustomeStatus == "Wholesale Customer"{//} && productData.Wholesale_use_parent_price {
                if productData.str_price_wholesale != "" && productData.str_price_wholesale != "0"{
                    self.priceTextField.text = "$\((Double(productData.str_price_wholesale) ?? 0.0).roundToTwoDecimal)"
                    lblPriceNew.text = "$\((Double(productData.str_price_wholesale) ?? 0.0).roundToTwoDecimal)"
                    productData.str_price = productData.str_price_wholesale
                } else {
                    self.priceTextField.text = "$\((Double(productData.str_price) ?? 0.0).roundToTwoDecimal)"
                    lblPriceNew.text = "$\((Double(productData.str_price) ?? 0.0).roundToTwoDecimal)"
                }
            } else {
                //productData.str_price = "$\((Double(productData.mainPrice) ?? 0.0).roundToTwoDecimal)"
                self.priceTextField.text = "$\((Double(productData.str_price) ?? 0.0).roundToTwoDecimal)"
                lblPriceNew.text = "$\((Double(productData.str_price) ?? 0.0).roundToTwoDecimal)"
            }
            
            self.taxExemptButtton.isSelected = false
            
            lblQuantityNew.text = productData.isAllowDecimal ? "1.00" : "1"
            
            // by sudama add sub
            frequencySubTF.text = ""
            numberOfOccuTF.text = ""
            unlimitedBtn.isSelected = true
            numberOfOccuTF.isEnabled = false
            numberOfOccuTF.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8941176471, blue: 0.9098039216, alpha: 1)
            daymnthTF.text = "Days"
            addSubscriptionBtn.isSelected = false
            if DataManager.showSubscription  {
                addSubscriptionBtn.isHidden = false
                addSubHeaderView.isHidden = false
                tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(45))
                
            }else{
                addSubscriptionBtn.isHidden = true
                addSubHeaderView.isHidden = true
                tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(0))
            }
          //  tableFooterViewHeight()
            tableHeaderViewHeight()
            subscriptionDetailStackView.isHidden = true
            
            var price = self.lblPriceNew.text ?? ""
            price = price.replacingOccurrences(of: " ", with: "")
            price = price.replacingOccurrences(of: "$", with: "")
            let newPrice = price.toDouble()
            let qty = qtyTextField.text?.toDouble()
            let totalPrice = newPrice! * qty!
            lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
            
            //lblTotalNew.text
            
            //            if productData.isEditQty == true && productData.isEditPrice == true{
            //                self.qtyTextField.becomeFirstResponder()
            //            }else if productData.isEditQty == true {
            //                self.qtyTextField.becomeFirstResponder()
            //            }else if productData.isEditPrice == true {
            //                self.priceTextField.becomeFirstResponder()
            //            }
            
            self.taxExemptButtton.isHidden = !DataManager.isLineItemTaxExempt || productData.is_taxable.lowercased() == "no"
            if productData.isEditQty == true && productData.isEditPrice == true{
                self.qtyTextField.becomeFirstResponder()
                self.qtyTextField.selectAll(nil)
            }else if productData.isEditQty == true {
                self.qtyTextField.becomeFirstResponder()
                self.qtyTextField.selectAll(nil)
            }else if productData.isEditPrice == true {
                self.priceTextField.becomeFirstResponder()
                self.priceTextField.selectAll(nil)
            }
        }
        
        var isCustomeDiscount = false
        
        if apppliedDiscount > 0 && apppliedDiscount < 101 {
            customtextField.text = "\(self.apppliedDiscount.roundToTwoDecimal)%"
            if UI_USER_INTERFACE_IDIOM() == .phone {
                btnDiscountIphone.isSelected = true
                btnDiscountIphone.backgroundColor = #colorLiteral(red: 0, green: 0.5450455546, blue: 0.8285293579, alpha: 1)
                btnDiscountIphone.setTitleColor(.white, for: .normal)
                discountBackView.isHidden = false
                isCustomeDiscount = true
                
                defaultDiscountButton.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
                defaultDiscountButton.backgroundColor = UIColor.white
                tenPerDiscountButton.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
                tenPerDiscountButton.backgroundColor = UIColor.white
                twentyPerDiscountButton.setTitleColor(UIColor.blue, for: .normal)
                twentyPerDiscountButton.backgroundColor = UIColor.white
                seventyPerDiscountButton.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
                seventyPerDiscountButton.backgroundColor = UIColor.white
            }
        }
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if Int(apppliedDiscount) == 2000 || Int(apppliedDiscount) == 3000 || Int(apppliedDiscount) == 4000 || Int(apppliedDiscount) == 5000 {
                btnDiscountIphone.isSelected = true
                btnDiscountIphone.backgroundColor = #colorLiteral(red: 0, green: 0.5450455546, blue: 0.8285293579, alpha: 1)
                btnDiscountIphone.setTitleColor(.white, for: .normal)
                discountBackView.isHidden = false
            } else {
                if !isCustomeDiscount {
                    isDiscount = true
                    //self.updateButtonUI(tag: 1000)
                    //self.updateTotal(with: 0, isNoDiscount: true)
                    btnDiscountIphone.isSelected = false
                    btnDiscountIphone.backgroundColor = .white
                    btnDiscountIphone.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
                    discountBackView.isHidden = true
                }
            }
        }
        
        self.updateButtonUI(tag: Int(apppliedDiscount))
        
//        tableHeaderViewHeight()
        
        self.tableView.reloadData {
            if self.tableView.numberOfSections > 0 {
                if self.tableView.numberOfRows(inSection: 0) != 0 {
                    //self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true) // by sudama add sub
                }
            }
        }
        
        self.updateQuantity()
        
        self.getVariationSurchageValue()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            self.footerCollectionView.reloadData()
            self.tableHeaderViewHeight()
        })
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if productData.is_additional_product {
                discountTextField.isHidden = true
                priceTextField.isUserInteractionEnabled = false
                btnDiscount.isHidden = true
                textView.isHidden = true
                discountViewWidthConstraint.constant = 0
            }else{
                priceTextField.isUserInteractionEnabled = true
                self.discountTextField.isHidden = !DataManager.isDiscountOptions
                self.btnDiscount.isHidden = !DataManager.isDiscountOptions
                if DataManager.isDiscountOptions && orderType == .newOrder {
                    self.discountTextField.isHidden = orderType == .refundOrExchangeOrder
                    self.btnDiscount.isHidden = orderType == .refundOrExchangeOrder
                    discountViewWidthConstraint.constant = (UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height) ? 200 : 140
                }else{
                    discountViewWidthConstraint.constant = 0
                }
                textView.isHidden = false
            }
        }else{
            if productData.is_additional_product {
                discountBackView.isHidden = true
                btnDiscountIphone.isHidden = true
                priceTextField.isUserInteractionEnabled = false
                textView.isHidden = true
            }else{
                textView.isHidden = false
                priceTextField.isUserInteractionEnabled = true
                self.btnDiscountIphone.isHidden = !DataManager.isDiscountOptions
                //self.discountBackView.isHidden = !DataManager.isDiscountOptions
                if DataManager.isDiscountOptions {
                    self.btnDiscountIphone.isHidden = orderType == .refundOrExchangeOrder
                    //self.discountBackView.isHidden = orderType == .refundOrExchangeOrder
                }
            }
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if orderType == .refundOrExchangeOrder {
                taxExemptButtton.isHidden = true
                discountTextField.isHidden = true
               // priceTextField.isUserInteractionEnabled = false
                btnDiscount.isHidden = true
                addSubscriptionBtn.isHidden = true
                addSubHeaderView.isHidden = true
                
            }
        }else{
            if orderType == .refundOrExchangeOrder {
                taxExemptButtton.isHidden = true
                btnDiscountIphone.isHidden = true
                self.discountBackView.isHidden = true
              //  priceTextField.isUserInteractionEnabled = false
                addSubscriptionBtn.isHidden = true
                addSubHeaderView.isHidden = true
            }
        }
        if DataManager.isPosProductViewInfo == "true"{
            self.btnProductInfo.isHidden = orderType == .refundOrExchangeOrder
        }
        
        if isEditProduct{
            let val = (Double(strEditedPrize) ?? 0) - Double(strVariationPrize)
            strEditedPrize = "\(val.roundToTwoDecimal)" // for variation 16feb
        }
    }
    
    private func enableSwipeTextField() {
        if Keyboard._isExternalKeyboardAttached() {
            DispatchQueue.main.async {
                SwipeAndSearchVC.shared.enableTextField()
            }
        }
    }
    func parserDictDataToModel(dict:JSONDictionary) { // Get data from Data Manager
        productData.str_product_image = dict["productimage"] as? String ?? ""
        productData.str_title = dict["producttitle"] as? String ?? ""
        productData.str_product_code = dict["productCode"] as? String ?? ""
        productData.str_price = dict["str_price"] as? String ?? ""
        productData.v_product_stock  = dict["v_product_stock"] as? String ?? ""
        productData.v_product_attributes_name = dict["v_product_attributes_name"] as? String ?? ""
        productData.Wholesale_use_parent_price = dict["Wholesale_use_parent_price"] as? Bool ?? false
        
        productData.v_product_attributes_values = dict["v_product_attributes_values"] as? Array<String> ?? [""]
        productData.str_brand = dict["str_brand"] as? String ?? ""
        productData.str_supplier = dict["str_supplier"] as? String ?? ""
        productData.str_short_description = dict["str_short_description"] as? String ?? ""
        productData.str_website_Link = dict["str_website_Link"] as? String ?? ""
        productData.str_keywords = dict["str_keywords"] as? String ?? ""
        productData.on_order = dict["on_order"] as? String ?? ""
        productData.str_website_Link = dict["str_website_Link"] as? String ?? ""
        productData.str_price_wholesale = dict["wholesale_price"] as? String ?? ""
        productData.customFieldsArr.removeAll()
        if let termsObj = dict["customFieldsArr"] as? JSONArray{
            for dict in termsObj {
                //if let dict = temp {
                    var customFields = CustomFieldsModel()
                    customFields.label = dict["label"] as? String ?? ""
                    customFields.value = dict["value"] as? String ?? ""
                    productData.customFieldsArr.append(customFields)
               // }
            }
        }
        array_Products = [productData]
    }
    private func updateCartButton() {
        self.addToCartButton.isEnabled = true
        self.addToCartButton.alpha = 1.0
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.tickButton.isEnabled = true
            self.tickButton.alpha = 1.0
        }
        
        requiredCount = 0
        
        if productAttributeDetails.count > 0 {
            for detail in productAttributeDetails {
                for value in detail.valuesAttribute {
                    let req = value.attribute_required
                    if req == "Yes" {
                        requiredCount += 1
                    }
                }
            }
            
            print("required count == \(requiredCount)")
            
            var valueCount = 0
            
            for i in 0..<productAttributeDetails.count {
                let arrayData  = productAttributeDetails[i].valuesAttribute as [AttributesModel] as NSArray
                let attributeModel = arrayData[0] as! AttributesModel
                //let jsonArray = attributeModel.jsonArray
                
                let req = attributeModel.attribute_required
                if req == "Yes" {
                    if attributeModel.attribute_type == "text" {
                        if attributeModel.attribute_value != "" {
                            valueCount += 1
                        }
                    }
                    if attributeModel.attribute_type == "text_calendar" {
                        if attributeModel.attribute_value != "" {
                            valueCount += 1
                        }
                    }
                    if let hh = attributeModel.jsonArray {
                        let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                        //print(arrayAttrData)
                        
                        for value in arrayAttrData {
                            //let val = value.attribute_value_id
                            let isSelect = value.isSelect
                            
                            print(isSelect as Any)
                            
                            if isSelect! {
                                
                                valueCount += 1
                                
                                print("select enter data ==== \(valueCount)")
                                
                                break
                            }
                        }
                    }
                }
            }
            
            if valueCount == requiredCount {
                self.addToCartButton.isEnabled = true
                self.addToCartButton.alpha = 1.0
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    self.tickButton.isEnabled = true
                    self.tickButton.alpha = 1.0
                }
            } else {
                self.addToCartButton.isEnabled = false
                self.addToCartButton.alpha = 0.5
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    self.tickButton.isEnabled = false
                    self.tickButton.alpha = 0.5
                }
            }
            
            
            //            if radioProductArray.count > 0 {          //DDD
            //                if !(radioProductArray.last?.valuesData.contains(where: {$0.isSelected == true}) ?? false) {
            //                    self.addToCartButton.isEnabled = false
            //                    self.addToCartButton.alpha = 0.5
            //
            //                    if UI_USER_INTERFACE_IDIOM() == .pad {
            //                        self.tickButton.isEnabled = false
            //                        self.tickButton.alpha = 0.5
            //                    }
            //                }
            //            }
        }
    }
    
    func getPreviousQty(productId: String, productAttributesID: [String]) -> Double {
        var productPrevQty: Double = 0
        if let cartArray = DataManager.cartProductsArray {
            for cartProd in cartArray {
                let prevQty = Double((cartProd as AnyObject).value(forKey: "productqty") as? String ?? "") ?? 0
                let id = (cartProd as AnyObject).value(forKey: "productid") as? String ?? ""
                let attributesID = (cartProd as AnyObject).value(forKey: "attributesID") as? [String] ?? [String]()
                
                //                let dat = (cartProd as AnyObject).value(forKey: "variation_use_parent_stock") as? String ?? ""
                //                print(dat)
                
                let stock_Check = Double(self.productData.str_stock) ?? 0
                let limt_Check = Double(self.productData.str_limit_qty) ?? 0
                
                if stock_Check > 0.0 && productData.unlimited_stock == "No" {
                    if productId == id {//&& productAttributesID.containsSameElements(as: attributesID) {
                        productPrevQty += prevQty
                    }
                } else if limt_Check > 0.0 {
                    if productId == id {//&& productAttributesID.containsSameElements(as: attributesID) {
                        productPrevQty += prevQty
                    }
                } else {
                    if productId == id && productAttributesID.containsSameElements(as: attributesID) {
                        productPrevQty += prevQty
                    }
                }
            }
        }
        return productPrevQty
    }
    
    func getAvailableQty(unlimited: String, limitQty: Double, stock: Double ) -> Double {
        var availableQty: Double = 9999
        if(unlimited.uppercased()=="YES"){
            if(limitQty>0){
                availableQty = limitQty
            }
        }else if(unlimited.uppercased()=="NO"){
            if(stock<=0){
                availableQty=0;
            }else if(limitQty>0 && stock>0){
                if(limitQty>stock){
                    availableQty = stock
                }else{
                    availableQty = limitQty
                }
            }else if(limitQty==0 && stock>0){
                availableQty = stock
            }
        }
        return availableQty
    }
    
    func handleDoneAction(sender: UIButton? = nil) {
        
        if isEditProduct {
            if let index = DataManager.cartProductsArray?.index(where: {(($0 as! JSONDictionary)["row_id"] as? Double ?? 0.0 == self.productData.row_id)}) {
                if var dict = DataManager.cartProductsArray?[index] as? JSONDictionary {
                    
                    let productId = dict["productid"] as? String ?? ""
                    let productAttributesID = dict["attributesID"] as? [String] ?? [String]()
                    
                    let stock = Double(dict["productstock"] as? String ?? "") ?? 0
                    let unlimitedstock = dict["productunlimitedstock"] as? String ?? ""
                    let limitqty = Double(dict["productlimitqty"] as? String ?? "") ?? 0
                    
                    var availableqty = self.getAvailableQty(unlimited: unlimitedstock, limitQty: limitqty, stock: stock)
                    let productQtyInCart = self.getPreviousQty(productId: productId, productAttributesID: productAttributesID)
                    let currentQty = Double(dict["productqty"] as? String ?? "") ?? 0
                    let textfieldQty = (Double(self.qtyTextField.text ?? "") ?? 0)
                    
                    if availableqty < 0 {
                        //                        self.showAlert(message: "Product out of stock.")
                        appDelegate.showToast(message: "Product out of stock.")
                        return
                    }
                    
                    if DataManager.noInventoryPurchase == "false" {
                        
                        availableqty = Double(productData.str_stock) ?? 0
                        //availableProductQty = availableqty
                        if availableqty > 0 {
                            if isEditProduct {
                                if Int((productQtyInCart + textfieldQty) - currentQty) > Int(availableqty) {
                                    //                                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                                    appDelegate.showToast(message:"\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                                    return
                                }
                            } else {
                                if Int((productQtyInCart + textfieldQty)) > Int(availableqty) {
                                    //                                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                                    appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                                    return
                                }
                            }
                            
                        }
                        //                    productQtyInCart = value
                        //                    if limitqty > 0 {
                        //                        if Int( value)) > Int(limitqty) {
                        //                            self.showAlert(title: "Warning!", message: "\(productData.str_title) Has Limited Purchase - \(availableqty.newValue)")
                        //                            return
                        //                        }
                        //                    }
                        if limitqty > 0 {
                            if isEditProduct {
                                if Int((productQtyInCart + textfieldQty) - currentQty) > Int(limitqty) {
                                    //                                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                    appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                    return
                                }
                            } else {
                                if Int((productQtyInCart + textfieldQty )) > Int(limitqty) {
                                    //                                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                    appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                    return
                                }
                            }
                        }
                        
                        
                        if productData.unlimited_stock == "Yes" {
                            availableqty = 9999999
                            //availableProductQty = availableqty
                        } else {
                            if variationQuantity != 0.00001 {
                                
                                if isEditProduct {
                                    if Double((textfieldQty)) > variationQuantity {
                                        print("enterrrrrrrr")
                                        //                                        self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(variationQuantity)")
                                        appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Stock - \(variationQuantity)")
                                        return
                                    } else {
                                        availableqty = Double(variationQuantity)
                                        //availableProductQty = availableqty
                                        print("ouuuuuutttterrerrerre")
                                    }
                                } else {
                                    if Double((productQtyInCart + textfieldQty)) > variationQuantity {
                                        print("enterrrrrrrr")
                                        //                                        self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(variationQuantity)")
                                        appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                        return
                                    } else {
                                        availableqty = Double(variationQuantity)
                                        //availableProductQty = availableqty
                                        print("ouuuuuutttterrerrerre")
                                    }
                                }
                                
                                
                            }
                        }
                    } else {
                        availableqty = 9999999
                        if limitqty > 0 {
                            if isEditProduct {
                                if Int((textfieldQty)) > Int(limitqty) {
                                    //                                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                    appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                    return
                                }
                            } else {
                                if Int((productQtyInCart + textfieldQty)) > Int(limitqty) {
                                    //                                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                    appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                    return
                                }
                            }
                            
                        }
                    }
                    
                    //                    if (productQtyInCart + textfieldQty - currentQty) > availableqty {
                    //
                    //                        if Double((productQtyInCart + textfieldQty - currentQty)) > variationQuantity {
                    //                            print("enterrrrrrrr")
                    //
                    //                            if limitqty > 0 {
                    //                                if (productQtyInCart + textfieldQty - currentQty) <= limitqty {
                    //                                    print("enterrrrrrrrrrrrrrrrrrrrrrrrlimit")
                    //                                } else {
                    //                                    self.showAlert(title: "Warning!", message: "\(self.self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                    //                                    return
                    //                                }
                    //                            }
                    //
                    //                            //self.showAlert(title: "Warning!", message: "\(self.productData.str_title) Has Limited Purchase - \(availableqty.newValue)")
                    //                            //return
                    //                        } else {
                    //
                    //                            if limitqty > 0 {
                    //                                if (productQtyInCart + textfieldQty - currentQty) <= limitqty {
                    //                                    print("enterrrrrrrrrrrrrrrrrrrrrrrrlimit")
                    //                                } else {
                    //                                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(availableqty.newValue)")
                    //                                    return
                    //                                }
                    //                            }
                    //
                    //                            print("ouuuuuutttterrerrerre")
                    //                        }
                    //
                    ////                        self.showAlert(title: "Warning!", message: "\(self.productData.str_title) Has Limited Purchase - \(availableqty.newValue)")
                    ////                        return
                    //                    }
                    
                    dict["productqty"] = String(textfieldQty)
                    dict["productNotes"] = self.textView.text == textViewPlaceholder ? "" : (self.textView.text ?? "")
                    var price = self.lblPriceNew.text ?? ""
                    price = price.replacingOccurrences(of: " ", with: "")
                    price = price.replacingOccurrences(of: "$", with: "")
                    dict["productprice"] = price
                    
                    var pricetext = self.priceTextField.text ?? ""
                    pricetext = pricetext.replacingOccurrences(of: " ", with: "")
                    pricetext = pricetext.replacingOccurrences(of: "$", with: "")
                    dict["textPrice"] = pricetext
                    
                    // by sudama add sub
                    dict["frequencySub"] = self.frequencySubTF.text
                    dict["daymnth"] = self.daymnthTF.text
                    dict["numberOfOcc"] = self.numberOfOccuTF.text
                    dict["unlimitedCheck"] = unlimitedBtn.isSelected ? true : false
                    dict["addSubscription"] = addSubscriptionBtn.isSelected ? true : false
                    //
                    
                    if DataManager.isLineItemTaxExempt {
                        dict["isTaxExempt"] = taxExemptButtton.isSelected ? "Yes" : "No"
                    }
                    
                    var selectedIDArray = [Int]()
                    
                    for i in 0..<productAttributeDetails.count {
                        let arrayData  = productAttributeDetails[i].valuesAttribute as [AttributesModel] as NSArray
                        let attributeModel = arrayData[0] as! AttributesModel
                        let jsonArray = attributeModel.jsonArray
                        if let hh = jsonArray {
                            let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                            //print(arrayAttrData)
                            
                            for value in arrayAttrData {
                                
                                if value.isSelect {
                                    selectedIDArray.append(Int(value.attribute_value_id) ?? 0)
                                }
                            }
                        }
                    }
                    
                    selectedIDArray = selectedIDArray.sorted()
                    if selectedIDArray.count > 0 {
                        dict["attributesID"] = selectedIDArray
                    }
                    for i in 0..<productAttributeDetails.count {
                        let arrayData  = productAttributeDetails[i].valuesAttribute as [AttributesModel] as NSArray
                        let attributeModel = arrayData[0] as! AttributesModel
                        if attributeModel.attribute_type == "text" {
                            
                            let indexPath = IndexPath(item: 0, section: i)
                            let cell = self.tableView?.cellForRow(at: indexPath) as? iPadTableViewCell
                            if cell != nil {
                            productAttributeDetails[i].valuesAttribute[0].attribute_value = cell?.textTypeTextView.text
                            }
                            
                        } else if attributeModel.attribute_type == "text_calendar"{
                            let indexPath = IndexPath(item: 0, section: i)
                            let cell = self.tableView?.cellForRow(at: indexPath) as? iPadTableViewCell
                            if cell != nil {
                            productAttributeDetails[i].valuesAttribute[0].attribute_value = cell?.txtDatePicker.text
                            }
                        }
                    }
                    
                    for i in 0..<productItemMetaDetails.count {
                        let indexPath = IndexPath(item: i, section: 0)
                        let cell = footerCollectionView?.cellForItem(at:indexPath) as? iPadSMCollectionViewCell
                        if cell != nil {
                            productItemMetaDetails[i].valuesMetaFields[0].itemMetaValue = cell?.smNumerTF.text
                        }
                    }
                    
                    dict["attributesArray"] = ProductModel.shared.getProductDetailDictionary(productDetails: self.productAttributeDetails)
                    dict["itemMetaFieldsArray"] = ProductModel.shared.getProductItemMetaFieldsDetailDictionary(productDetails: productItemMetaDetails)
                    dict["variationArray"] = ProductModel.shared.getProductDetailVariationDictionary(productDetails: self.productVariationDetails)
                    dict["surchargVariationArray"] = ProductModel.shared.getProductDetailSurchargeVariationDictionary(productDetails: self.productSurchargVariationDetails)
                    //dict["attributesArray"] = productData.attributesData
                    dict["apppliedDiscount"] = self.apppliedDiscount
                    dict["apppliedDiscountString"] = self.getCurrentDiscount()
                    dict["is_additional_product"] = productData.is_additional_product
                    DataManager.cartProductsArray![index] = dict
                    isFirstOpen = true
                }
            }else {
                self.scannerAlert(title: "Oops!", msg: "It seems like this product has been removed from cart.", target: self)
                
                //self.showAlert(title: "Oops!", message: "It seems like this product has been removed from cart.")
                return
            }
            variationEditPrice = 0.0
            delegate?.didClickOnDoneButton?()
            self.enableSwipeTextField()
        }else {
            self.addToCart(sender: sender)
        }
    }
    
    private func getSelectedIDArray() -> [String] {
        var selectedIDArray = [String]()
        
        for i in 0..<productAttributeDetails.count {
            let arrayData  = productAttributeDetails[i].valuesAttribute as [AttributesModel] as NSArray
            let attributeModel = arrayData[0] as! AttributesModel
            let jsonArray = attributeModel.jsonArray
            
            if attributeModel.attribute_type == "radio" {
                
                if let hh = jsonArray {
                    let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                    //print(arrayAttrData)
                    
                    for value in arrayAttrData {
                        if value.isSelect {
                            selectedIDArray.append(value.attribute_value_id ?? "")
                        }
                    }
                }
            }else if attributeModel.attribute_type == "checkbox" {
                
                if let hh = jsonArray{
                    let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                    //print(arrayAttrData)
                    
                    for value in arrayAttrData {
                        if value.isSelect {
                            selectedIDArray.append(value.attribute_value_id ?? "")
                        }
                    }
                }
            }
        }
        
        return selectedIDArray.sorted()
    }
    
    private func addToCart(sender: UIButton? = nil) {
        var cartProductsArray = Array<Any>()
        
        if let cartArray = DataManager.cartProductsArray {
            cartProductsArray = cartArray
        }
        
        
        
        if Int(self.productData.str_stock) == 0 && self.productData.unlimited_stock == "No"{
            if productData.isOutOfStock == 1 && DataManager.noInventoryPurchase == "false" {
                
                //                self.showAlert(message: "Product out of stock.")
                appDelegate.showToast(message: "Product out of stock.")
                return
            }
            //self.showAlert(message: "Product out of stock.")
            //return
        }
        
        //if
        
        
        let selectedIDArray = self.getSelectedIDArray()
        let productQtyInCart = self.getPreviousQty(productId: self.productData.str_product_id, productAttributesID: selectedIDArray)
        
        if let index = cartProductsArray.index(where: {(($0 as! JSONDictionary)["productid"] as? String ?? "" == self.productData.str_product_id) && ((($0 as! JSONDictionary)["attributesID"] as? [String] ?? [String]()).containsSameElements(as: selectedIDArray))}), !DataManager.isSplitRow {
            var tempCartArray = cartProductsArray
            let cartProd = cartProductsArray[index]
            if (cartProd as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false {
                let stock = Double(self.productData.str_stock) ?? 0
                let unlimitedstock = self.productData.unlimited_stock
                let limitqty = Double(self.productData.str_limit_qty) ?? 0
                
                let availableqty = self.getAvailableQty(unlimited: unlimitedstock, limitQty: limitqty, stock: stock)
                let textfieldQty = Double(self.qtyTextField.text ?? "") ?? 0
                
                if availableqty < 0 {
                    //                self.showAlert(message: "Product out of stock.")
                    appDelegate.showToast(message: "Product out of stock.")
                    return
                }
                
                if productData.isOutOfStock == 1 {
                    print("enter value data ")
                }
                
                
                
                if (productQtyInCart + textfieldQty) > availableqty {
                    
                    print("variationQuantity========\(variationQuantity)")
                    
                    if DataManager.noInventoryPurchase == "false" {
                        
                        
                        if limitqty > 0 {
                            if Int((productQtyInCart + textfieldQty)) > Int(limitqty) {
                                self.scannerAlert(title: "Warning!", msg: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", target: self)
                                
                                //                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                                //                                if sender == nil {
                                //                                    self.enableSwipeTextField()
                                //                                }
                                //                            }
                                delegate?.didClickOnDoneButton?()
                                return
                            }
                        }
                        
                        if Double((productQtyInCart + textfieldQty)) > variationQuantity {
                            print("enterrrrrrrr")
                            self.scannerAlert(title: "Warning!", msg: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)", target: self)
                            
                            //                        self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                            //                            if sender == nil {
                            //                                self.enableSwipeTextField()
                            //                            }
                            //                        }
                            delegate?.didClickOnDoneButton?()
                            return
                        } else {
                            print("ouuuuuutttterrerrerre")
                        }
                    } else {
                        if limitqty > 0 {
                            if Int((productQtyInCart + textfieldQty)) > Int(limitqty) {
                                
                                self.scannerAlert(title: "Warning!", msg: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", target: self)
                                
                                //                            let alert = UIAlertController(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", preferredStyle: UIAlertControllerStyle.alert)
                                //                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                                //                                (result: UIAlertAction) -> Void in
                                //                                //if sender == nil {
                                //                                    self.enableSwipeTextField()
                                //                                //}
                                //                            })
                                //                            self.present(alert, animated: true, completion: nil)
                                
                                delegate?.didClickOnDoneButton?()
                                return
                                
                                //                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                                //                                if sender == nil {
                                //                                    self.enableSwipeTextField()
                                //                                }
                                //                            }
                                //                            delegate?.didClickOnDoneButton?()
                                //                            return
                            }
                        }
                    }
                }
                
                var cartDict = JSONDictionary()
                cartDict["producttitle"] = self.productData.str_title
                cartDict["productid"] = self.productData.str_product_id
                //cartDict["productqty"] = String(textfieldQty)
                if DataManager.isCaptureButton {
                    cartDict["productqty"] = self.productData.str_limit_qty
                }else{
                    cartDict["productqty"] = String(textfieldQty)
                }
                var price = self.lblPriceNew.text ?? ""
                price = price.replacingOccurrences(of: " ", with: "")
                price = price.replacingOccurrences(of: "$", with: "")
                cartDict["productprice"] = price
                cartDict["mainprice"] = self.productData.str_price
                var pricetext = self.priceTextField.text ?? ""
                pricetext = pricetext.replacingOccurrences(of: " ", with: "")
                pricetext = pricetext.replacingOccurrences(of: "$", with: "")
                cartDict["textPrice"] = pricetext
                cartDict["productimage"] = self.productData.str_product_image
                cartDict["productimagedata"] = self.productData.productImageData
                cartDict["productdesclong"] = self.productData.str_long_description
                cartDict["productdescshort"] = self.productData.str_short_description
                cartDict["productstock"] = self.productData.str_stock
                cartDict["productlimitqty"] = self.productData.str_limit_qty
                cartDict["productistaxable"] = self.productData.is_taxable
                cartDict["productunlimitedstock"] = self.productData.unlimited_stock
                cartDict["shippingPrice"] = self.productData.shippingPrice
                cartDict["productNotes"] = self.textView.text == textViewPlaceholder ? "" : (self.textView.text ?? "")
                
                // by sudama add sub
                cartDict["frequencySub"] = self.frequencySubTF.text == frequencySubTF.placeholder ? "" : (self.frequencySubTF.text ?? "")
                cartDict["daymnth"] = self.daymnthTF.text
                cartDict["numberOfOcc"] = self.numberOfOccuTF.text
                
                cartDict["unlimitedCheck"] = unlimitedBtn.isSelected ? true : false
                cartDict["addSubscription"] = addSubscriptionBtn.isSelected ? true : false
                
                //
                
                
                if DataManager.isLineItemTaxExempt {
                    cartDict["isTaxExempt"] = taxExemptButtton.isSelected ? "Yes" : "No"
                }
                
                if selectedIDArray.count > 0 {
                    cartDict["attributesID"] = selectedIDArray
                }
                cartDict["tax_detail"] = self.productData.taxDetails
                cartDict["variations"] = self.productData.variations
                cartDict["surcharge_variations"] = self.productData.surchargeVariations
                cartDict["qty_allow_decimal"] = self.productData.isAllowDecimal
                cartDict["prompt_for_price"] = self.productData.isEditPrice
                cartDict["prompt_for_quantity"] = self.productData.isEditQty
                
                for i in 0..<productAttributeDetails.count {
                    let arrayData  = productAttributeDetails[i].valuesAttribute as [AttributesModel] as NSArray
                    let attributeModel = arrayData[0] as! AttributesModel
                    if attributeModel.attribute_type == "text" {
                        
                        let indexPath = IndexPath(item: 0, section: i)
                        let cell = self.tableView?.cellForRow(at: indexPath) as? iPadTableViewCell
                        if cell != nil {
                        productAttributeDetails[i].valuesAttribute[0].attribute_value = cell?.textTypeTextView.text
                        }
                        
                    } else if attributeModel.attribute_type == "text_calendar" {
                        let indexPath = IndexPath(item: 0, section: i)
                        let cell = self.tableView?.cellForRow(at: indexPath) as? iPadTableViewCell
                        if cell != nil {
                        productAttributeDetails[i].valuesAttribute[0].attribute_value = cell?.txtDatePicker.text
                        }
                    }
                }
                for i in 0..<productItemMetaDetails.count {
                    let indexPath = IndexPath(item: i, section: 0)
                    let cell = footerCollectionView?.cellForItem(at:indexPath) as? iPadSMCollectionViewCell
                    if cell != nil {
                        productItemMetaDetails[i].valuesMetaFields[0].itemMetaValue = cell?.smNumerTF.text
                    }
                }
                cartDict["attributesArray"] = ProductModel.shared.getProductDetailDictionary(productDetails: self.productAttributeDetails)
                cartDict["variationArray"] = ProductModel.shared.getProductDetailVariationDictionary(productDetails: self.productVariationDetails)
                cartDict["itemMetaFieldsArray"] = ProductModel.shared.getProductItemMetaFieldsDetailDictionary(productDetails: self.productItemMetaDetails)
                cartDict["surchargVariationArray"] = ProductModel.shared.getProductDetailSurchargeVariationDictionary(productDetails: self.productSurchargVariationDetails)
                
                //cartDict["attributesArray"] = productData.attributesData
                cartDict["apppliedDiscount"] = self.apppliedDiscount
                cartDict["apppliedDiscountString"] = self.getCurrentDiscount()
                cartDict["productCode"] = self.productData.str_product_code
                cartDict["row_id"] = Date().millisecondsSince1970  //For Local Use
                cartDict["width"] = self.productData.width
                cartDict["height"] = self.productData.height
                cartDict["length"] = self.productData.length
                cartDict["weight"] = self.productData.weight
                cartDict["allow_credit_product"] = self.productData.allow_credit_product
                cartDict["allow_purchase_product"] = self.productData.allow_purchase_product
                
                cartProductsArray.append(cartDict)
                UserDefaults.standard.setValue(cartProductsArray, forKey: "cartProductsArray")
                UserDefaults.standard.synchronize()
                variationEditPrice = 0.0
                delegate?.didClickOnDoneButton?()
                isFirstOpen = true
                
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    // socket sudama
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        var cartModelObj = CartDataSocketModel()
                        cartModelObj.balance_due = HomeVM.shared.DueShared
                        cartModelObj.total = DataManager.subTotalForSocket ?? 0.0
                        cartModelObj.subTotal = DataManager.subTotalForSocket ?? 0.0
                        //                        cartModelObj.balance_due = HomeVM.shared.DueShared
                        //                        cartModelObj.tax = taxAmount.doubleValue
                        //                        cartModelObj.coupon = taxTitle
                        //                        cartModelObj.couponDiscount = taxableCouponTotal
                        //                        cartModelObj.manualDiscount = Double(self.str_AddDiscount) ?? 0.0
                        //                        cartModelObj.strAddCouponName = str_AddCouponName
                        //                        cartModelObj.shippingAmount = shipping
                        MainSocketManager.shared.connect()
                        let socketConnectionStatus = MainSocketManager.shared.socket.status
                        
                        switch socketConnectionStatus {
                        case SocketIOStatus.connected:
                            print("socket connected")
                            if DataManager.sessionID != "" {
                                MainSocketManager.shared.onCartUpdate(Arr: cartProductsArray, cartDataSocketModel: cartModelObj, variationData: MainproductsArraySocket)
                            }
                        case SocketIOStatus.connecting:
                            print("socket connecting")
                        case SocketIOStatus.disconnected:
                            print("socket disconnected")
                        case SocketIOStatus.notConnected:
                            print("socket not connected")
                        }
                        //
                    }
                }
            }else{
                let stock = Double((cartProd as AnyObject).value(forKey: "productstock") as? String ?? "") ?? 0
                let unlimitedstock = (cartProd as AnyObject).value(forKey: "productunlimitedstock") as? String ?? ""
                let limitqty = Double((cartProd as AnyObject).value(forKey: "productlimitqty") as? String ?? "") ?? 0
                let currentQty = Double((cartProd as AnyObject).value(forKey: "productqty") as? String ?? "") ?? 0
                let availableqty = self.getAvailableQty(unlimited: unlimitedstock, limitQty: limitqty, stock: stock)
                let textfieldQty = (Double(self.qtyTextField.text ?? "") ?? 0)
                
                if availableqty < 0 {
                    //                self.showAlert(message: "Product out of stock.")
                    appDelegate.showToast( message: "Product out of stock.")
                    return
                }
                
                if (productQtyInCart + textfieldQty) > availableqty {
                    
                    print("variationQuantity========\(variationQuantity)")
                    
                    if DataManager.noInventoryPurchase == "false" {
                        if limitqty > 0 {
                            if Int((productQtyInCart + textfieldQty)) > Int(limitqty) {
                                self.scannerAlert(title: "Warning!", msg: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", target: self)
                                
                                //                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                                //                                if sender == nil {
                                //                                    self.enableSwipeTextField()
                                //                                }
                                //                            }
                                delegate?.didClickOnDoneButton?()
                                return
                            }
                        }
                        
                        if availableqty > 0 {
                            if Double((productQtyInCart + textfieldQty)) > availableqty {
                                self.scannerAlert(title: "Warning!", msg: "\(self.productName.text ?? "") Has Limited Purchase - \(availableqty.newValue)", target: self)
                                
                                //                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(availableqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                                //                                if sender == nil {
                                //                                    self.enableSwipeTextField()
                                //                                }
                                //                            }
                                delegate?.didClickOnDoneButton?()
                                return
                            }
                            print(availableqty)
                        }
                        
                        if Double((productQtyInCart + textfieldQty)) > variationQuantity {
                            print("enterrrrrrrr")
                            self.scannerAlert(title: "Warning!", msg: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)", target: self)
                            
                            //                        self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                            //                            if sender == nil {
                            //                                self.enableSwipeTextField()
                            //                            }
                            //                        }
                            delegate?.didClickOnDoneButton?()
                            return
                        } else {
                            print("ouuuuuutttterrerrerre")
                        }
                    } else {
                        if limitqty > 0 {
                            if Int((productQtyInCart + textfieldQty)) > Int(limitqty) {
                                
                                self.scannerAlert(title: "Warning!", msg: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", target: self)
                                
                                
                                //                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                                //                                if sender == nil {
                                //                                    self.enableSwipeTextField()
                                //                                }
                                //                            }
                                delegate?.didClickOnDoneButton?()
                                return
                            }
                        }
                    }
                }
                
                
                //            if (productQtyInCart + textfieldQty) > availableqty {
                //                print("variationQuantity========\(variationQuantity)")
                //
                //                if Int((productQtyInCart + textfieldQty)) > variationQuantity {
                //                    print("enterrrrrrrr")
                //                    self.showAlert(title: "Warning!", message: "\(self.productData.str_title) Has Limited Purchase - \(availableqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                //                        if sender == nil {
                //                            self.enableSwipeTextField()
                //                        }
                //                    }
                //                    return
                //                } else {
                //
                //                    if limitqty != 0 {
                //                        if productQtyInCart + textfieldQty <= limitqty {
                //                            print("enterrrrrrrrrrrrrrrrrrrrrrrrlimit")
                //                        } else {
                //                            self.showAlert(title: "Warning!", message: "\(self.productData.str_title) Has Limited Purchase - \(availableqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                //                                if sender == nil {
                //                                    self.enableSwipeTextField()
                //                                }
                //                            }
                //                            return
                //                        }
                //                    }
                //                    print("ouuuuuutttterrerrerre")
                //                }
                //
                //
                //            }
                
                var temDic :[String:AnyObject] = tempCartArray[index] as! [String:AnyObject]
                temDic["productqty"] =  "\(textfieldQty + currentQty)" as AnyObject
                temDic["mainprice"] = self.productData.str_price as AnyObject
                temDic["shippingPrice"] = self.productData.shippingPrice as AnyObject
                temDic["productimage"] = self.productData.str_product_image as AnyObject
                temDic["productimagedata"] = (self.productData.productImageData == nil ? "" as AnyObject : self.productData.productImageData as AnyObject)
                temDic["apppliedDiscountString"] = temDic["apppliedDiscountString"] as AnyObject
                temDic["apppliedDiscount"] = self.apppliedDiscount as AnyObject
                temDic["apppliedDiscountString"] = self.getCurrentDiscount() as AnyObject
                
                var price = priceTextField.text
                
                let discount = temDic["apppliedDiscountString"] as! String
                if discount == "" {
                    temDic["apppliedDiscount"] = self.apppliedDiscount as AnyObject
                    temDic["apppliedDiscountString"] = self.getCurrentDiscount() as AnyObject
                    price = price!.replacingOccurrences(of: " ", with: "")
                    price = price!.replacingOccurrences(of: "$", with: "")
                    temDic["productprice"] = price as AnyObject
                }else{
                    //var price = priceTextField.text   //self.priceTextField.text ?? ""
                    price = price!.replacingOccurrences(of: " ", with: "")
                    price = price!.replacingOccurrences(of: "$", with: "")
                    temDic["productprice"] = price as AnyObject
                }
                
                temDic["textPrice"] = price as AnyObject
                
                if selectedIDArray.count > 0 {
                    temDic["attributesID"] = selectedIDArray as AnyObject
                }
                
                temDic["attributesArray"] = ProductModel.shared.getProductDetailDictionary(productDetails: self.productAttributeDetails) as AnyObject
                temDic["itemMetaFieldsArray"] = ProductModel.shared.getProductItemMetaFieldsDetailDictionary(productDetails: self.productItemMetaDetails) as AnyObject
                temDic["variationArray"] = ProductModel.shared.getProductDetailVariationDictionary(productDetails: self.productVariationDetails) as AnyObject
                temDic["surchargVariationArray"] = ProductModel.shared.getProductDetailSurchargeVariationDictionary(productDetails: self.productSurchargVariationDetails) as AnyObject
                
                //temDic["attributesArray"] = productData.attributesData as AnyObject
                
                temDic["productNotes"] = (self.textView.text == textViewPlaceholder ? "" : (self.textView.text ?? "")) as AnyObject
                
                // by sudama add sub
                temDic["frequencySub"] = self.frequencySubTF.text as AnyObject?
                temDic["daymnth"] = self.daymnthTF.text as AnyObject?
                temDic["numberOfOcc"] = self.numberOfOccuTF.text as AnyObject?
                temDic["unlimitedCheck"] = unlimitedBtn.isSelected ? true as AnyObject : false as AnyObject
                temDic["addSubscription"] = addSubscriptionBtn.isSelected ? true as AnyObject : false as AnyObject
                
                //
                
                
                if DataManager.isLineItemTaxExempt {
                    temDic["isTaxExempt"] = taxExemptButtton.isSelected ? "Yes"  as AnyObject : "No"  as AnyObject
                }
                
                tempCartArray[index] = temDic
                CartContainerViewController.updatedProductIndex = index
                cartProductsArray = tempCartArray
                UserDefaults.standard.setValue(cartProductsArray, forKey: "cartProductsArray")
                UserDefaults.standard.synchronize()
                variationEditPrice = 0.0
                delegate?.didClickOnDoneButton?()
                isFirstOpen = true
            }
      
        }
        else {
            let stock = Double(self.productData.str_stock) ?? 0
            let unlimitedstock = self.productData.unlimited_stock
            let limitqty = Double(self.productData.str_limit_qty) ?? 0
            
            let availableqty = self.getAvailableQty(unlimited: unlimitedstock, limitQty: limitqty, stock: stock)
            let textfieldQty = Double(self.qtyTextField.text ?? "") ?? 0
            
            if availableqty < 0 {
                //                self.showAlert(message: "Product out of stock.")
                appDelegate.showToast(message: "Product out of stock.")
                return
            }
            
            if productData.isOutOfStock == 1 {
                print("enter value data ")
            }
            
            
            
            if (productQtyInCart + textfieldQty) > availableqty {
                
                print("variationQuantity========\(variationQuantity)")
                
                if DataManager.noInventoryPurchase == "false" {
                    
                    
                    if limitqty > 0 {
                        if Int((productQtyInCart + textfieldQty)) > Int(limitqty) {
                            self.scannerAlert(title: "Warning!", msg: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", target: self)
                            
                            //                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                            //                                if sender == nil {
                            //                                    self.enableSwipeTextField()
                            //                                }
                            //                            }
                            delegate?.didClickOnDoneButton?()
                            return
                        }
                    }
                    
                    if Double((productQtyInCart + textfieldQty)) > variationQuantity {
                        print("enterrrrrrrr")
                        self.scannerAlert(title: "Warning!", msg: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)", target: self)
                        
                        //                        self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                        //                            if sender == nil {
                        //                                self.enableSwipeTextField()
                        //                            }
                        //                        }
                        delegate?.didClickOnDoneButton?()
                        return
                    } else {
                        print("ouuuuuutttterrerrerre")
                    }
                } else {
                    if limitqty > 0 {
                        if Int((productQtyInCart + textfieldQty)) > Int(limitqty) {
                            
                            self.scannerAlert(title: "Warning!", msg: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", target: self)
                            
                            //                            let alert = UIAlertController(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", preferredStyle: UIAlertControllerStyle.alert)
                            //                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                            //                                (result: UIAlertAction) -> Void in
                            //                                //if sender == nil {
                            //                                    self.enableSwipeTextField()
                            //                                //}
                            //                            })
                            //                            self.present(alert, animated: true, completion: nil)
                            
                            delegate?.didClickOnDoneButton?()
                            return
                            
                            //                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)", otherButtons: nil, cancelTitle: kOkay) { (_) in
                            //                                if sender == nil {
                            //                                    self.enableSwipeTextField()
                            //                                }
                            //                            }
                            //                            delegate?.didClickOnDoneButton?()
                            //                            return
                        }
                    }
                }
            }
            
            var cartDict = JSONDictionary()
            cartDict["producttitle"] = self.productData.str_title
            cartDict["productid"] = self.productData.str_product_id
            //cartDict["productqty"] = String(textfieldQty)
            if DataManager.isCaptureButton {
                cartDict["productqty"] = self.productData.str_limit_qty
            }else{
                cartDict["productqty"] = String(textfieldQty)
            }
            var price = self.lblPriceNew.text ?? ""
            price = price.replacingOccurrences(of: " ", with: "")
            price = price.replacingOccurrences(of: "$", with: "")
            cartDict["productprice"] = price
            cartDict["mainprice"] = self.productData.str_price
            var pricetext = self.priceTextField.text ?? ""
            pricetext = pricetext.replacingOccurrences(of: " ", with: "")
            pricetext = pricetext.replacingOccurrences(of: "$", with: "")
            cartDict["textPrice"] = pricetext
            cartDict["wholesalePrice"] = self.productData.str_price_wholesale
            print(self.productData.str_price_wholesale)
//            if DataManager.customerStatusDefaultName == "WHOLESALE CUSTOMER" {
//                cartDict["productprice"] = self.productData.str_price_wholesale
//            }
            
            if let customerStatus = DataManager.customerObj?["customer_status"] as? String  {
                strCustomeStatus = customerStatus
            } else {
                if orderType == .refundOrExchangeOrder {
                    strCustomeStatus = (OrderVM.shared.orderInfo.customer_status == "WHOLESALE CUSTOMER") ? "WHOLESALE CUSTOMER" : ""
                } else {
                    strCustomeStatus = ""
                }
            }
            
            let isParentPrice = self.productData.Wholesale_use_parent_price
            if strCustomeStatus == "WHOLESALE CUSTOMER" || strCustomeStatus == "Wholesale Customer"{//} && isParentPrice {
//                    if productData.str_price_wholesale != "" && productData.str_price_wholesale != "0"{
//                        cartDict["productprice"] = self.productData.str_price_wholesale
//                    } else {
                    cartDict["productprice"] = price
//                    }
            }
            
//            if let customerStatus = DataManager.customerObj?["customer_status"] as? String  {
//                strCustomeStatus = customerStatus
//
//            }
            cartDict["productimage"] = self.productData.str_product_image
            cartDict["productimagedata"] = self.productData.productImageData
            cartDict["productdesclong"] = self.productData.str_long_description
            cartDict["productdescshort"] = self.productData.str_short_description
            cartDict["productstock"] = self.productData.str_stock
            cartDict["productlimitqty"] = self.productData.str_limit_qty
            cartDict["productistaxable"] = self.productData.is_taxable
            cartDict["productunlimitedstock"] = self.productData.unlimited_stock
            cartDict["shippingPrice"] = self.productData.shippingPrice
            cartDict["productNotes"] = self.textView.text == textViewPlaceholder ? "" : (self.textView.text ?? "")
            
            // by sudama add sub
            cartDict["frequencySub"] = self.frequencySubTF.text == frequencySubTF.placeholder ? "" : (self.frequencySubTF.text ?? "")
            cartDict["daymnth"] = self.daymnthTF.text
            cartDict["numberOfOcc"] = self.numberOfOccuTF.text
            
            cartDict["unlimitedCheck"] = unlimitedBtn.isSelected ? true : false
            cartDict["addSubscription"] = addSubscriptionBtn.isSelected ? true : false
            
            //
            
            
            if DataManager.isLineItemTaxExempt {
                cartDict["isTaxExempt"] = taxExemptButtton.isSelected ? "Yes" : "No"
            }
            
            if selectedIDArray.count > 0 {
                cartDict["attributesID"] = selectedIDArray
            }
            cartDict["tax_detail"] = self.productData.taxDetails
            cartDict["variations"] = self.productData.variations
            cartDict["surcharge_variations"] = self.productData.surchargeVariations
            cartDict["qty_allow_decimal"] = self.productData.isAllowDecimal
            cartDict["prompt_for_price"] = self.productData.isEditPrice
            cartDict["prompt_for_quantity"] = self.productData.isEditQty
            
            for i in 0..<productAttributeDetails.count {
                let arrayData  = productAttributeDetails[i].valuesAttribute as [AttributesModel] as NSArray
                let attributeModel = arrayData[0] as! AttributesModel
                if attributeModel.attribute_type == "text" {
                    
                    let indexPath = IndexPath(item: 0, section: i)
                    let cell = self.tableView?.cellForRow(at: indexPath) as? iPadTableViewCell
                    if cell != nil {
                    productAttributeDetails[i].valuesAttribute[0].attribute_value = cell?.textTypeTextView.text
                    }
                    
                } else if attributeModel.attribute_type == "text_calendar" {
                    let indexPath = IndexPath(item: 0, section: i)
                    let cell = self.tableView?.cellForRow(at: indexPath) as? iPadTableViewCell
                    if cell != nil {
                    productAttributeDetails[i].valuesAttribute[0].attribute_value = cell?.txtDatePicker.text
                    }
                }
            }
            
            for i in 0..<productItemMetaDetails.count {
                let indexPath = IndexPath(item: i, section: 0)
                let cell = footerCollectionView?.cellForItem(at:indexPath) as? iPadSMCollectionViewCell
                if cell != nil {
                    productItemMetaDetails[i].valuesMetaFields[0].itemMetaValue = cell?.smNumerTF.text
                }
            }
            cartDict["attributesArray"] = ProductModel.shared.getProductDetailDictionary(productDetails: self.productAttributeDetails)
            cartDict["itemMetaFieldsArray"] = ProductModel.shared.getProductItemMetaFieldsDetailDictionary(productDetails: self.productItemMetaDetails)
            cartDict["variationArray"] = ProductModel.shared.getProductDetailVariationDictionary(productDetails: self.productVariationDetails)
            cartDict["surchargVariationArray"] = ProductModel.shared.getProductDetailSurchargeVariationDictionary(productDetails: self.productSurchargVariationDetails)
            
            //cartDict["attributesArray"] = productData.attributesData
            cartDict["apppliedDiscount"] = self.apppliedDiscount
            cartDict["apppliedDiscountString"] = self.getCurrentDiscount()
            cartDict["productCode"] = self.productData.str_product_code
            cartDict["row_id"] = Date().millisecondsSince1970  //For Local Use
            cartDict["width"] = self.productData.width
            cartDict["height"] = self.productData.height
            cartDict["length"] = self.productData.length
            cartDict["weight"] = self.productData.weight
            cartDict["allow_credit_product"] = self.productData.allow_credit_product
            cartDict["allow_purchase_product"] = self.productData.allow_purchase_product
            
            // For product inforamtion screen
            cartDict["str_product_code"] = productData.str_product_code
            cartDict["str_price"]  =  productData.str_price
            cartDict["v_product_stock"] = productData.v_product_stock
            cartDict["v_product_attributes_name"] = productData.v_product_attributes_name
            cartDict["Wholesale_use_parent_price"] = productData.Wholesale_use_parent_price
            
            cartDict["v_product_attributes_values"] = productData.v_product_attributes_values
            cartDict["str_brand"] = productData.str_brand
            cartDict["str_supplier"] = productData.str_supplier
            cartDict["str_short_description"] = productData.str_short_description
            cartDict["str_website_Link"] = productData.str_website_Link
            cartDict["str_keywords"] = productData.str_keywords
            cartDict["on_order"] = productData.on_order
            cartDict["is_additional_product"] = productData.is_additional_product
            //  cartDict["str_website_Link"] =  productData.str_website_Link
            //  cartDict["customFieldsArr"] =  productData.customFieldsArr
            var dictArray = JSONArray()
            if productData.customFieldsArr.count > 0 {
                for ar in productData.customFieldsArr {
                    var dict = JSONDictionary()
                    dict["label"] = ar.label
                    dict["value"] = ar.value
                    dictArray.append(dict)
                }
            }
            cartDict["customFieldsArr"] =  dictArray
            cartDict["wholesale_price"] = productData.str_price_wholesale
            //
            cartProductsArray.append(cartDict)
            UserDefaults.standard.setValue(cartProductsArray, forKey: "cartProductsArray")
            UserDefaults.standard.synchronize()
            variationEditPrice = 0.0
            delegate?.didClickOnDoneButton?()
            isFirstOpen = true
            
            if UI_USER_INTERFACE_IDIOM() == .phone {
                // socket sudama
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                    var cartModelObj = CartDataSocketModel()
                    cartModelObj.balance_due = HomeVM.shared.DueShared
                    cartModelObj.total = DataManager.subTotalForSocket ?? 0.0
                    cartModelObj.subTotal = DataManager.subTotalForSocket ?? 0.0
                    //                        cartModelObj.balance_due = HomeVM.shared.DueShared
                    //                        cartModelObj.tax = taxAmount.doubleValue
                    //                        cartModelObj.coupon = taxTitle
                    //                        cartModelObj.couponDiscount = taxableCouponTotal
                    //                        cartModelObj.manualDiscount = Double(self.str_AddDiscount) ?? 0.0
                    //                        cartModelObj.strAddCouponName = str_AddCouponName
                    //                        cartModelObj.shippingAmount = shipping
                    MainSocketManager.shared.connect()
                    let socketConnectionStatus = MainSocketManager.shared.socket.status
                    
                    switch socketConnectionStatus {
                    case SocketIOStatus.connected:
                        print("socket connected")
                        if DataManager.sessionID != "" {
                            MainSocketManager.shared.onCartUpdate(Arr: cartProductsArray, cartDataSocketModel: cartModelObj, variationData: MainproductsArraySocket)
                        }
                    case SocketIOStatus.connecting:
                        print("socket connecting")
                    case SocketIOStatus.disconnected:
                        print("socket disconnected")
                    case SocketIOStatus.notConnected:
                        print("socket not connected")
                    }
                    //
                }
            }
        }
        self.enableSwipeTextField()
    }
    
    private func getCurrentDiscount() -> String {
        var discountInString = String()
        
        switch apppliedDiscount {
        case 0: //No Discount
            break
        case 1000: //No Discount
            break
        case 2000:
            discountInString = DataManager.tenDiscountValue.newValue + "% Discount"
            break
        case 3000:
            discountInString = DataManager.twentyDiscountValue.newValue + "% Discount"
            break
        case 4000:
            discountInString = DataManager.seventyDiscountValue.newValue + "% Discount"
            break
        case 5000: //No Discount
            break
        default:
            discountInString = apppliedDiscount.newValue + "% Discount"
            break
        }
        
        return discountInString
    }
    
    private func getSurchageData() {
        
        arraySuchargevariation.removeAll()
        
        let productDetail = self.productSurchargVariationDetails
        for detail in productDetail {
            
            for valueOne in detail.valuesSurchargeVariation {
                
                for list in valueOne.jsonArray! {
                    let attvalueId = (list as NSDictionary).value(forKey: "attribute_value_id") as! String
                    let attId = (list as NSDictionary).value(forKey: "attribute_id") as! String
                    
                    for i in 0..<productAttributeDetails.count {
                        let arrayData  = productAttributeDetails[i].valuesAttribute as [AttributesModel] as NSArray
                        let attributeModel = arrayData[0] as! AttributesModel
                        let jsonArray = attributeModel.jsonArray
                        if let hh = jsonArray {
                            let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                            //print(arrayAttrData)
                            
                            for value in arrayAttrData {
                                let val = value.attribute_value_id
                                var dict = JSONDictionary()
                                if attvalueId == val {
                                    
                                    dict["attributeName"] = value.attribute_value!
                                    dict["attributevalueId"] = value.attribute_value_id!
                                    dict["surchargePrize"] = valueOne.variation_price_surcharge!
                                    dict["surchargePrizeClone"] = valueOne.variation_price_surchargeClone!
                                    dict["attributeId"] = attId
                                    dict["attribute_value"] = value.attribute_value
                                    dict["isSelect"] = value.isSelect
                                    dict["showAdditinalPriceInput"] = valueOne.showAdditinalPriceInput
                                    arraySuchargevariation.append(dict)
                                    print(arraySuchargevariation)
                                    
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getVariationSurchageValue() {
        // print((data as AnyObject).value(forKey: "surchargVariationArray") as Any)
        
        strVariationPrize = 0.0
        radioCount = 0
        arrSelectRadio.removeAll()
        variationCount = 0
        isvariationparantPrize = true
        arrTempAttSlct.removeAll()
        variationsArray.removeAll()
        arrIntVariationQuantity.removeAll()
        variationRadioPrice = 0.0
        surchargeCheckBoxPrice = 0.0
        //variationQuantity = 0.0
        
        if productAttributeDetails.count == 0 {
            if productData.str_stock != "" {
                variationQuantity = Double(productData.str_stock)!
            }
          }
        
        for i in 0..<productAttributeDetails.count {
            let arrayData  = productAttributeDetails[i].valuesAttribute as [AttributesModel] as NSArray
            let attributeModel = arrayData[0] as! AttributesModel
            let jsonArray = attributeModel.jsonArray
            
            if attributeModel.attribute_type == "radio" {
                
                if let hh = jsonArray {
                    let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                    //print(arrayAttrData)
                    
                    for value in arrayAttrData {
                        //let val = value.attribute_value_id
                        var dict = JSONDictionary()
                        let isSelect = value.isSelect
                        
                        print(isSelect as Any)
                        
                        if isSelect! {
                            radioCount += 1
                            print("radio count value==== \(radioCount)")
                            
                            dict["attributeName"] = value.attribute_value!
                            dict["attributevalueId"] = value.attribute_value_id!
                            dict["attributeId"] = attributeModel.attribute_id
                            
                            arrTempAttSlct.append(value.attribute_value_id!)
                            
                            arrSelectRadio.append(value)
                        }
                    }
                }
                
            } else {
                
                if let hh = jsonArray {
                    let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
                    //print(arrayAttrData)
                    
                    for value in arrayAttrData {
                        let isSelect = value.isSelect
                        
                        if isSelect! {
                            let productDetail = self.productSurchargVariationDetails
                            for detail in productDetail {
                                
                                for valueOne in detail.valuesSurchargeVariation {
                                    
                                    //let hh = valueOne.
                                    for list in valueOne.jsonArray! {
                                        let attvalueId = (list as NSDictionary).value(forKey: "attribute_value_id") as! String
                                        
                                        if attvalueId == value.attribute_value_id {
                                            print(valueOne.variation_price_surcharge)
                                            if valueOne.variation_price_surcharge == valueOne.variation_price_surchargeClone {
                                                strVariationPrize += Double(valueOne.variation_price_surcharge)!
                                                surchargeCheckBoxPrice += Double(valueOne.variation_price_surcharge)!
                                                tempsurchargeCheckBoxPrice = Double(valueOne.variation_price_surcharge)!
                                            } else {
                                                strVariationPrize += Double(valueOne.variation_price_surchargeClone)!
                                                surchargeCheckBoxPrice += Double(valueOne.variation_price_surchargeClone)!
                                                tempsurchargeCheckBoxPrice = Double(valueOne.variation_price_surchargeClone)!
                                            }
                                            
                                            
                                            if valueOne.variation_use_parent_stock == "No" {
                                                arrIntVariationQuantity.append(Double(valueOne.variation_stock)!)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            print(strVariationPrize)
        }
        
        if versionOb < 4 {
            if productVariationDetails.count == 0 {
                variationQuantity = Double(productData.str_stock)!
            }
        }
        let productDetail = self.productVariationDetails
        for detail in productDetail {
            
            for variationValue in detail.valuesVariation {
                
                if variationValue.variation_use_parent_stock == "No" {
                    arrIntVariationQuantity.append(Double(variationValue.variation_stock)!)
                    
                }
                let count = variationValue.jsonArray?.count
                
                if count == radioCount {
                    
                    print("enter variation value")
                    
                    print(arrSelectRadio)
                    
                    for val in arrSelectRadio {
                        let attValId = val.attribute_value_id
                        let attId = val.attribute_id
                        arrTempVar.removeAll()
                        for data in variationValue.jsonArray!{
                            
                            if count == radioCount {
                                let attId = (data as NSDictionary).value(forKey: "attribute_value_id") as! String
                                
                                arrTempVar.append(attId)
                                
                                //                                if Id == attId {
                                //                                    print(variationValue.variation_price_surcharge)
                                //                                    variationCount += 1
                                //
                                //
                                //                                    print("variation Id == \(variationValue.variation_id)")
                                //                                }
                            }
                        }
                        
                        arrTempAttSlct = arrTempAttSlct.sorted()
                        arrTempVar = arrTempVar.sorted()
                        
                        print(arrTempAttSlct)
                        print(arrTempVar)
                        
                        
                        
                        if arrTempAttSlct == arrTempVar {
                            
                            if variationValue.variation_use_parent_price == "No" {
                                
                                let spec = Double(variationValue.variation_price_special)!
                                if let customerStatus = DataManager.customerObj?["customer_status"] as? String  {
                                    strCustomeStatus = customerStatus
                                } else {
                                    if orderType == .refundOrExchangeOrder {
                                        strCustomeStatus = (OrderVM.shared.orderInfo.customer_status == "WHOLESALE CUSTOMER") ? "WHOLESALE CUSTOMER" : ""
                                    } else {
                                        strCustomeStatus = ""
                                    }
                                }
                                if strCustomeStatus == "WHOLESALE CUSTOMER" || strCustomeStatus == "Wholesale Customer" {
                                    if productData.str_price_wholesale != "" && productData.str_price_wholesale != "0"{
                                        
                                        variationRadioPrice += Double(productData.str_price_wholesale)!
                                        
                                        strVariationPrize += Double(productData.str_price_wholesale)!
                                        
                                    } else {
                                        variationRadioPrice += Double(variationValue.variation_original_price)!
                                        
                                        strVariationPrize += Double(variationValue.variation_original_price)!
                                    }
                                } else {
                                    if spec == 0.0 {
                                        variationRadioPrice += Double(variationValue.variation_original_price)!
                                        
                                        strVariationPrize += Double(variationValue.variation_original_price)!
                                    } else  {
                                        variationRadioPrice += Double(variationValue.variation_original_price)!
                                        
                                        strVariationPrize += Double(variationValue.variation_price_special)!
                                    }
                                }
//                                if spec == 0.0 {
//                                    variationRadioPrice += Double(variationValue.variation_original_price)!
//
//                                    strVariationPrize += Double(variationValue.variation_original_price)!
//                                } else  {
//                                    variationRadioPrice += Double(variationValue.variation_original_price)!
//
//                                    strVariationPrize += Double(variationValue.variation_price_special)!
//                                }
                                variationQuantity = Double(variationValue.variation_stock)!
                                
                                
                                if variationValue.variation_use_parent_stock == "Yes" {
                                    variationQuantity = Double(productData.str_stock)!
                                }
                                
                                print("special prize value \(spec)")
                                
                                isvariationparantPrize = false
                                
                            } else {
                                isvariationparantPrize = true
                            }
                            
                            
                            
                            variationQuantity = Double(variationValue.variation_stock)!
                            
                            if variationValue.variation_use_parent_stock == "Yes" {
                                variationQuantity = Double(productData.str_stock)!
                            }
                            
                            variationRadioPrice += Double(variationValue.variation_price_surcharge)!
                            
                            strVariationPrize += Double(variationValue.variation_price_surcharge)!
                            break
                        }
                    }
                }
            }
        }
        
        //arrIntVariationQuantity.sorted()
        
        print("quantity value In \(arrIntVariationQuantity.sorted().first)")
        
    }
    
    
    private func getVariationRadioSurchageValue() {
        // print((data as AnyObject).value(forKey: "surchargVariationArray") as Any)
        
        strVariationPrize = 0.0
        radioCount = 0
        arrSelectRadio.removeAll()
        variationCount = 0
        isvariationparantPrize = true
        arrTempAttSlct.removeAll()
        variationsArray.removeAll()
        arrIntVariationQuantity.removeAll()
        variationRadioPrice = 0.0
        surchargeCheckBoxPrice = 0.0
        //        for i in 0..<productAttributeDetails.count {
        //            let arrayData  = productAttributeDetails[i].valuesAttribute as [AttributesModel] as NSArray
        //            let attributeModel = arrayData[0] as! AttributesModel
        //            let jsonArray = attributeModel.jsonArray
        //
        //            if attributeModel.attribute_type == "radio" {
        //
        //                if let hh = jsonArray {
        //                    let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
        //                    //print(arrayAttrData)
        //
        //                    for value in arrayAttrData {
        //                        //let val = value.attribute_value_id
        //                        var dict = JSONDictionary()
        //                        let isSelect = value.isSelect
        //
        //                        print(isSelect as Any)
        //
        //                        if isSelect! {
        //                            radioCount += 1
        //                            print("radio count value==== \(radioCount)")
        //
        //                            dict["attributeName"] = value.attribute_value!
        //                            dict["attributevalueId"] = value.attribute_value_id!
        //                            dict["attributeId"] = attributeModel.attribute_id
        //
        //                            arrTempAttSlct.append(value.attribute_value_id!)
        //
        //                            arrSelectRadio.append(value)
        //                        }
        //                    }
        //                }
        //
        //            } else {
        //
        //                if let hh = jsonArray {
        //                    let arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
        //                    //print(arrayAttrData)
        //
        //                    for value in arrayAttrData {
        //                        let isSelect = value.isSelect
        //
        //                        if isSelect! {
        //                            let productDetail = self.productSurchargVariationDetails
        //                            for detail in productDetail {
        //
        //                                for valueOne in detail.valuesSurchargeVariation {
        //
        //                                    //let hh = valueOne.
        //                                    for list in valueOne.jsonArray! {
        //                                        let attvalueId = (list as NSDictionary).value(forKey: "attribute_value_id") as! String
        //
        //                                        if attvalueId == value.attribute_value_id {
        //                                            print(valueOne.variation_price_surcharge)
        //
        //                                            strVariationPrize += Double(valueOne.variation_price_surcharge)!
        //                                            surchargeCheckBoxPrice += Double(valueOne.variation_price_surcharge)!
        //                                            tempsurchargeCheckBoxPrice = Double(valueOne.variation_price_surcharge)!
        //
        //                                            if valueOne.variation_use_parent_stock == "No" {
        //                                                arrIntVariationQuantity.append(Int(valueOne.variation_stock)!)
        //                                            }
        //                                        }
        //                                    }
        //                                }
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //            print(strVariationPrize)
        //        }
        
        let productDetail = self.productVariationDetails
        for detail in productDetail {
            
            for variationValue in detail.valuesVariation {
                
                if variationValue.variation_use_parent_stock == "No" {
                    arrIntVariationQuantity.append(Double(variationValue.variation_stock)!)
                }
                let count = variationValue.jsonArray?.count
                
                if count == radioCount {
                    
                    print("enter variation value")
                    
                    print(arrSelectRadio)
                    
                    for val in arrSelectRadio {
                        let attValId = val.attribute_value_id
                        let attId = val.attribute_id
                        arrTempVar.removeAll()
                        for data in variationValue.jsonArray!{
                            
                            if count == radioCount {
                                let attId = (data as NSDictionary).value(forKey: "attribute_value_id") as! String
                                
                                arrTempVar.append(attId)
                                
                                //                                if Id == attId {
                                //                                    print(variationValue.variation_price_surcharge)
                                //                                    variationCount += 1
                                //
                                //
                                //                                    print("variation Id == \(variationValue.variation_id)")
                                //                                }
                            }
                        }
                        
                        arrTempAttSlct = arrTempAttSlct.sorted()
                        arrTempVar = arrTempVar.sorted()
                        
                        print(arrTempAttSlct)
                        print(arrTempVar)
                        
                        
                        
                        if arrTempAttSlct == arrTempVar {
                            
                            if variationValue.variation_use_parent_price == "No" {
                                
                                let spec = Double(variationValue.variation_price_special)!
                                
                                if spec == 0.0 {
                                    variationRadioPrice += Double(variationValue.variation_original_price)!
                                    
                                    //strVariationPrize += Double(variationValue.variation_original_price)!
                                } else  {
                                    variationRadioPrice += Double(variationValue.variation_original_price)!
                                    
                                    //strVariationPrize += Double(variationValue.variation_price_special)!
                                }
                                variationQuantity = Double(variationValue.variation_stock)!
                                
                                if variationValue.variation_use_parent_stock == "Yes" {
                                    variationQuantity = Double(productData.str_stock)!
                                }
                                
                                print("special prize value \(spec)")
                                
                                isvariationparantPrize = false
                            } else {
                                isvariationparantPrize = true
                            }
                            variationRadioPrice += Double(variationValue.variation_price_surcharge)!
                            
                            //strVariationPrize += Double(variationValue.variation_price_surcharge)!
                            break
                        }
                    }
                }
            }
        }
        
        //arrIntVariationQuantity.sorted()
        
        print("quantity value In \(arrIntVariationQuantity.sorted().first)")
        
    }
    
    
    //MARK: IBAction
    @IBAction func discountButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.discountView.isHidden = false
        }
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        self.view.endEditing(true)
        handleDoneAction(sender: sender)
    }
    
    @IBAction func crossAction(_ sender: Any) {
        self.view.endEditing(true)
        isFirstOpen = true
        strEditedPrize = ""
        variationEditPrice = 0.0
        DataManager.isUPSellProduct = false
        HomeVM.shared.searchProductsArray.removeAll()
        DataManager.automatic_upsellData.removeAll()
        delegate?.didClickOnCrossButton?()
        self.enableSwipeTextField()
    }
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // by sudama add sub
        if addSubscriptionBtn.isSelected {
            if frequencySubTF.text == "" {
                //                showAlert(message: "Please enter frequency subscription")
                appDelegate.showToast(message: "Please enter frequency subscription")
                return
            }
            if !unlimitedBtn.isSelected && numberOfOccuTF.text == "" {
                //                showAlert(message: "Please enter number of occurrence in subscription")
                appDelegate.showToast(message: "Please enter number of occurrence in subscription")
                return
            }
            //
        }
        handleDoneAction(sender: sender)
        if strEditedPrize != "" {
            //productData.str_price = strEditedPrize
            //productData.mainPrice = strEditedPrize
        }
        strEditedPrize = ""
    }
        
    @IBAction func plusButtonAction(_ sender: Any) {
        self.updateQuantity(isAdd: true, isButtonAction: true)
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        self.updateQuantity(isAdd: false, isButtonAction: true)
    }
    
    @IBAction func defaultDiscountButtonAction(_ sender: Any) {
        isDiscount = true
        self.updateButtonUI(tag: 1000)
        self.updateTotal(with: 0, isNoDiscount: true)
    }
    
    @IBAction func tenPerSaleAction(_ sender: Any) {
        if adminUserCheck(){
            pinAlertTF(type: "Discount"){(result) -> () in
                if result {
                    self.isDiscount = true
                    self.updateButtonUI(tag: 2000)
                    self.updateTotal(with: DataManager.tenDiscountValue)
                }
            }
        }else{
            isDiscount = true
            self.updateButtonUI(tag: 2000)
            self.updateTotal(with: DataManager.tenDiscountValue)
        }
    }
    
    
    
    @IBAction func twentyPerSaleAction(_ sender: Any) {
        
        if adminUserCheck(){
            pinAlertTF(type: "Discount"){(result) -> () in
                if result {
                    self.isDiscount = true
                    self.updateButtonUI(tag: 3000)
                    self.updateTotal(with: DataManager.twentyDiscountValue)
                }
            }
        }else{
            isDiscount = true
            self.updateButtonUI(tag: 3000)
            self.updateTotal(with: DataManager.twentyDiscountValue)
        }
        
    }
    
    @IBAction func seventyPersaleAction(_ sender: Any) {
        
        if adminUserCheck(){
            pinAlertTF(type: "Discount"){(result) -> () in
                if result {
                    self.isDiscount = true
                    self.updateButtonUI(tag: 4000)
                    self.updateTotal(with: DataManager.seventyDiscountValue)
                }
            }
        }else{
            isDiscount = true
            self.updateButtonUI(tag: 4000)
            self.updateTotal(with: DataManager.seventyDiscountValue)
        }
        
    }
    
    @IBAction func taxExemptAction(_ sender: UIButton) {
        taxExemptButtton.isSelected = !taxExemptButtton.isSelected
    }
    
    // by sudama add sub
    @IBAction func addSubscriptionBtnAction(_ sender: Any) {
        if addSubscriptionBtn.isSelected {
            addSubscriptionBtn.isSelected = false
            subscriptionDetailStackView.isHidden = true
            if UI_USER_INTERFACE_IDIOM() == .pad {
                tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(45))
            }else{
                tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(45))
            }
            
            tableView.reloadData()
        }else{
            addSubscriptionBtn.isSelected = true
            subscriptionDetailStackView.isHidden = false
            if UI_USER_INTERFACE_IDIOM() == .pad {
                tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(145))
            }else{
                tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(170))
            }
            
            tableView.reloadData()
        }
        tableHeaderViewHeight()
    }
    // by sudama add sub
    @IBAction func unlimitedBtnAction(_ sender: Any) {
        if unlimitedBtn.isSelected {
            unlimitedBtn.isSelected = false
            numberOfOccuTF.isEnabled = true
            numberOfOccuTF.backgroundColor = .white
            
        }else{
            numberOfOccuTF.text = ""
            unlimitedBtn.isSelected = true
            numberOfOccuTF.isEnabled = false
            numberOfOccuTF.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8941176471, blue: 0.9098039216, alpha: 1)
        }
    }
    
    // by sudama add sub
    @objc func handleSelectfDayMnthTextField(sender: UITextField) {
        
        pickerDelegate = self
        self.setPickerView(textField: sender, array: showArray)
    }
    //
    
    @IBAction func btn_ProductInfo(_ sender: Any) {
        isFirstOpen = true
        strEditedPrize = ""
        variationEditPrice = 0.0
        delegate?.didClickOnCrossButton?()
        self.enableSwipeTextField()
        delegateForProductInfo?.didSelectEditButton?(data: array_Products.first ?? productData, index: selectedCollectionIndex, isSearching: false)
        
        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            self.editProductDelegate?.didEditProduct?(with: "iPad_ProductInfoViewController")
        }
        else
        {
            self.editProductDelegate?.didSelectProduct?(with: "editproduct")
        }
        
        // controller?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDiscountIphoneAction(_ sender: Any) {
        if btnDiscountIphone.isSelected {
            customtextField.text = ""
            isDiscount = true
            self.updateButtonUI(tag: 1000)
            self.updateTotal(with: 0, isNoDiscount: true)
            btnDiscountIphone.isSelected = false
            btnDiscountIphone.backgroundColor = .white
            btnDiscountIphone.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
            discountBackView.isHidden = true
        } else {
            btnDiscountIphone.isSelected = true
            btnDiscountIphone.backgroundColor = #colorLiteral(red: 0, green: 0.5450455546, blue: 0.8285293579, alpha: 1)
            btnDiscountIphone.setTitleColor(.white, for: .normal)
            discountBackView.isHidden = false
        }
    }

}

//MARK: UITableViewDelegate, UITableViewDataSource
extension EditProductVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productAttributeDetails.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iPadTableViewCell", for: indexPath) as! iPadTableViewCell
        cell.delegate = self
        cell.collectionView.tag = indexPath.section
        
        let arrayData  = productAttributeDetails[indexPath.section].valuesAttribute as [AttributesModel] as NSArray
        let attributeModel = arrayData[0] as! AttributesModel
        let jsonArray = attributeModel.jsonArray
        
        dictStockValue = [:]
        checkSingleVariation_attribute = false
        if let attributeDict = jsonArray {
            for valData in attributeDict {
                for detail in self.productVariationDetails {
                    for variationValue in detail.valuesVariation {
                        let key = valData["attribute_value_id"] as? String ?? ""
                        let value = variationValue.variation_stock
                        if variationValue.variation_use_parent_stock == "No" {
                            if let newValue = variationValue.jsonArray {
                                if newValue.count == 1 {
                                    for i in newValue {
                                        if key == i["attribute_value_id"] as? String ?? "" {
                                            dictStockValue[key] = value
                                            checkSingleVariation_attribute = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        cell.stockDictValue = dictStockValue
        cell.checkSingleVariation_attribute = checkSingleVariation_attribute
        
        if let hh = jsonArray {
            cell.arrayAttrData = AttributeSubCategory.shared.getAttribute(with: hh, attrId: attributeModel.attribute_id)
            print(cell.arrayAttrData)
            
            cell.arraySurchageVariation = arraySuchargevariation
            cell.arraySurchageModel.removeAll()
            cell.arraySurchageModel = ProductModel.shared.getProductDetailSurchargeVariationDictionary(productDetails: self.productSurchargVariationDetails)
        }
        
        cell.arrayAttributeValue = jsonArray!
        cell.arrayAttributes = productAttributeDetails[indexPath.section].valuesAttribute
        
        if let alignedFlowLayout = cell.collectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout {
            alignedFlowLayout.horizontalAlignment = .left
            alignedFlowLayout.verticalAlignment = .center
            alignedFlowLayout.minimumInteritemSpacing = 10
            alignedFlowLayout.minimumLineSpacing = 5
        }
        cell.txtDatePicker.delegate = self
        cell.txtDatePickerView.isHidden = true
        cell.collectionView.reloadData()
        let height = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
        if attributeModel.attribute_type == "text" {
            cell.textTypeTextView.tag = indexPath.section
            cell.textFieldVIew.isHidden = false
            cell.collectionView.isHidden = true
            cell.textTypeTextView.text = attributeModel.attribute_value
            if UI_USER_INTERFACE_IDIOM() == .pad {
                cell.collectionViewHeightConstraint.constant = height + 50
            }else{
                cell.collectionViewHeightConstraint.constant = height + 50
            }
            
        } else if attributeModel.attribute_type == "text_calendar" {
            cell.txtDatePicker.tag = indexPath.section
            cell.textFieldVIew.isHidden = true
            cell.collectionView.isHidden = true
            cell.txtDatePickerView.isHidden = false
            cell.txtDatePicker.placeholder = "MM/DD/YYYY"
            cell.txtDatePicker.text = attributeModel.attribute_value
            cell.showDatePickerCustomeText1()
            if UI_USER_INTERFACE_IDIOM() == .pad {
                cell.collectionViewHeightConstraint.constant = height + 40
            }else{
                cell.collectionViewHeightConstraint.constant = height + 50
            }
        } else {
            cell.collectionView.isHidden = false
            cell.textFieldVIew.isHidden = true
            cell.collectionViewHeightConstraint.constant = height - 10
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViewcell = tableView.dequeueReusableCell(withIdentifier: "cellproductdetailsHeader")!
        let titleLabel = headerViewcell.contentView.viewWithTag(3) as? UILabel
        let requiredButton = headerViewcell.contentView.viewWithTag(2) as? UIButton
        let requiredImageView = headerViewcell.contentView.viewWithTag(4) as? UIImageView
        //titleLabel?.text = productDetails[section].key
        
        requiredButton?.isHidden = true
        requiredImageView?.isHidden = true
        
        //DD
        let arrayData  = productAttributeDetails[section].valuesAttribute as [AttributesModel] as NSArray
        let attributeModel = arrayData[0] as! AttributesModel
        
//        if attributeModel.attribute_type == "text" {
//            titleLabel?.text = attributeModel.attribute_name
//        } else {
//            let name = attributeModel.attribute_name
//            titleLabel?.text = name
//        }
        if attributeModel.attribute_required == "Yes" {
            let name = attributeModel.attribute_name ?? ""
            let mainString = name + "*"
            let range = (mainString as NSString).range(of: "*")
            let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
            titleLabel?.attributedText = mutableAttributedString
        }else{
            titleLabel?.text = attributeModel.attribute_name
        }
        return headerViewcell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let arrayData  = productAttributeDetails[section].valuesAttribute as [AttributesModel] as NSArray
        let attributeModel = arrayData[0] as! AttributesModel
        
        if attributeModel.attribute_type == "text" {
            return 32
        } else {
            return 32
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}


//MARK: TextViewDelegate
extension EditProductVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        updateCartButton()
        
        delegate?.didUpdateHeight?(isKeyboardOpen: true)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.discountView.isHidden = true
        }
        if textView.text == textViewPlaceholder || textView.text == "" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = true
            IQKeyboardManager.shared.enable = true
        }
    }
    
    func textViewDidEndEditing(_ textViewForEdit: UITextView) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
        delegate?.didUpdateHeight?(isKeyboardOpen: false)
        if textViewForEdit.text == textViewPlaceholder || textViewForEdit.text == "" || (textViewForEdit.text)!.trimmingCharacters(in: .whitespaces).isEmpty {
            if textViewForEdit == textView {
                textViewForEdit.text = textViewPlaceholder
                textViewForEdit.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
            }
            
        }
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
            IQKeyboardManager.shared.enable = false
        }
        updateCartButton()
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        if let text11 = textView.text, let textRange = Range(range, in: text11) {
            var updatedText = text11.replacingCharacters(in: textRange,with: text)
            print(updatedText)
            updatedText = updatedText.trimmingCharacters(in: .whitespaces).condenseWhitespace()
            if updatedText == " " {
                return false
            }
            if productAttributeDetails.count > 0 {
                //  for i in 0..<productAttributeDetails.count {
                let tempArrayData  = productAttributeDetails[ textView.tag].valuesAttribute as [AttributesModel] as NSArray
                let tempAttributeModel = tempArrayData[0] as! AttributesModel
                if tempAttributeModel.attribute_type == "text" {
                    
                    let indexPath = IndexPath(item: 0, section: textView.tag)
                    let cell = self.tableView?.cellForRow(at: indexPath) as? iPadTableViewCell
                    if cell != nil {
                        print("cell not nil")
                        productAttributeDetails[ textView.tag].valuesAttribute[0].attribute_value = updatedText
                    }
                    
                }
                // }
            }
            
            //            let cs1 = NSCharacterSet(charactersIn: "'!@#$%^&*()-+_=?/.,;:" + "\"").inverted
            //            let cs2 = NSCharacterSet.alphanumerics.inverted
            //            let filtered1 = text.components(separatedBy: cs1).joined(separator: "")
            //            let filtered2 = text.components(separatedBy: cs2).joined(separator: "")
            //            return (text == filtered1 || text == filtered2)
        }
        return true
    }
}

//MARK: TextFieldDelegate
extension EditProductVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // by sudama add sub
        // for model numer serial numer sudama
        if productItemMetaDetails.count > 0 {
            let indexPath = IndexPath(item: textField.tag, section: 0)
            let cell = footerCollectionView?.cellForItem(at:indexPath) as? iPadSMCollectionViewCell
            if cell != nil {
                // if UI_USER_INTERFACE_IDIOM() == .pad {
                IQKeyboardManager.shared.enableAutoToolbar = false
                delegate?.didUpdateHeight?(isKeyboardOpen: true)
                // }
                //productItemMetaDetails[i].valuesMetaFields[0].itemMetaValue = cell?.smNumerTF.text
            }
            if textField.placeholder == "Serial Number" { // By Altab 18 Aug 2022
                self.showSerialNumberTableView(self, sourceView: textField, productId: self.productData.str_product_id) { (text) in
                    textField.text = text
                }
            }
        }
        if productAttributeDetails.count > 0 {
            //  for i in 0..<productAttributeDetails.count {
            let tempArrayData  = productAttributeDetails[ textField.tag == 999 ? 0 : textField.tag].valuesAttribute as [AttributesModel] as NSArray
            let tempAttributeModel = tempArrayData[0] as! AttributesModel
            if tempAttributeModel.attribute_type == "text_calendar" {
                
                let indexPath = IndexPath(item: 0, section: textField.tag)
                let cell = self.tableView?.cellForRow(at: indexPath) as? iPadTableViewCell
                if textField == cell?.txtDatePicker {
                    if cell != nil {
                        
                        print("cell not nil")
                        print("vslur \(textField.text)")
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            IQKeyboardManager.shared.enableAutoToolbar = false
                        }
                        
                        delegate?.didUpdateHeight?(isKeyboardOpen: true)
                       // productAttributeDetails[textField.tag].valuesAttribute[0].attribute_value = textField.text
                    }
                }
                
            }
            // }
        }
        if textField == frequencySubTF || textField == daymnthTF || textField == numberOfOccuTF{
            if UI_USER_INTERFACE_IDIOM() == .pad {
                IQKeyboardManager.shared.enableAutoToolbar = false
            }
            
            delegate?.didUpdateHeight?(isKeyboardOpen: true)
        }
        //
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enable = true
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
        
        if textField == priceTextField || textField == customtextField || textField == frequencySubTF || textField == numberOfOccuTF{
            textField.selectAll(nil)
        }
        
        if textField == customtextField {
            updateButtonUI(tag: 5000)
            let text = Double((textField.text ?? "").replacingOccurrences(of: "%", with: "")) ?? 0.0
            customtextField.text = text == 0 ? "" : text.roundToTwoDecimal
            oldDiscount = textField.text ?? ""
            oldDiscount = oldDiscount.replacingOccurrences(of: "$", with: "")
        }
        
        if textField == priceTextField {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                self.discountView.isHidden = true
            }
            let text = Double((textField.text ?? "").replacingOccurrences(of: "$", with: "")) ?? 0.0
            textField.text = text == 0 ? "" : text.roundToTwoDecimal
            //self.updateButtonUI(tag: 1000)
            
            let hh = self.textView.text.replacingOccurrences(of: strDiscount, with: "")
            
            self.textView.text = hh
            
            if textView.text == "" {
                textView.text = textViewPlaceholder
                textView.textColor = UIColor.darkGray
            }
        }
        
        
        if textField == priceTextField || textField == customtextField || textField == frequencySubTF || textField == numberOfOccuTF{
            textField.selectAll(nil)
        }
        
        if textField == priceTextField {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                self.discountView.isHidden = true
            }
            oldPrice = textField.text ?? ""
            oldPrice = oldPrice.replacingOccurrences(of: "$", with: "")
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if textField == discountTextField {
                textField.tintColor = UIColor.clear
                textField.resignFirstResponder()
            }
        }
        if textField == qtyTextField {
            qtyTextField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // by sudama add sub
        // for model numer serial numer sudama
        if productItemMetaDetails.count > 0 {
            let indexPath = IndexPath(item: textField.tag, section: 0)
            let cell = footerCollectionView?.cellForItem(at:indexPath) as? iPadSMCollectionViewCell
            if cell != nil {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    IQKeyboardManager.shared.enableAutoToolbar = true
                    delegate?.didUpdateHeight?(isKeyboardOpen: false)
                }
                //productItemMetaDetails[i].valuesMetaFields[0].itemMetaValue = cell?.smNumerTF.text
            }
        }
        if textField == frequencySubTF || textField == daymnthTF || textField == numberOfOccuTF {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                IQKeyboardManager.shared.enableAutoToolbar = true
            }
            delegate?.didUpdateHeight?(isKeyboardOpen: false)
        }
        if productAttributeDetails.count > 0 {
            //  for i in 0..<productAttributeDetails.count {
            let tempArrayData  = productAttributeDetails[ textField.tag == 999 ? 0 : textField.tag].valuesAttribute as [AttributesModel] as NSArray
            let tempAttributeModel = tempArrayData[0] as! AttributesModel
            if tempAttributeModel.attribute_type == "text_calendar" {
                
                let indexPath = IndexPath(item: 0, section: textField.tag)
                let cell = self.tableView?.cellForRow(at: indexPath) as? iPadTableViewCell
                if textField == cell?.txtDatePicker {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        IQKeyboardManager.shared.enableAutoToolbar = true
                    }
                    delegate?.didUpdateHeight?(isKeyboardOpen: false)
                    if cell != nil {
                        print("cell not nil")
                        print("vslur \(textField.text)")
                        productAttributeDetails[textField.tag].valuesAttribute[0].attribute_value = textField.text
                    }
                }
                
            }
            // }
        }
        if textField == qtyTextField {
            let text = Double(textField.text ?? "") ?? 0.0
            
            if productData.isAllowDecimal {
                textField.text = text <= 0 ? "1.00" : text.roundToTwoDecimal
            }else {
                textField.text = text <= 0 ? "1" : text.roundOFF
            }
            qtyTextField.delegate = self
            if let value = Double(qtyTextField.text ?? "") {
                if (value - 1) <= 0 {
                    return
                }
                lblQuantityNew.text = qtyTextField.text
                var price = self.lblPriceNew.text ?? ""
                price = price.replacingOccurrences(of: " ", with: "")
                price = price.replacingOccurrences(of: "$", with: "")
                let newPrice = price.toDouble()
                let qty = qtyTextField.text?.toDouble()
                let totalPrice = newPrice! * qty!
                lblTotalNew.text = "$\((totalPrice).roundToTwoDecimal)"
            }
        }
        
        if textField == priceTextField  {
            let text = Double((textField.text ?? "").replacingOccurrences(of: "$", with: "")) ?? 0.0
            
            let price = Double(oldPrice) ?? 0
            
            if isVariationSelected && text < price {
                for i in 0..<productAttributeDetails.count {
                    for j in 0..<productAttributeDetails[i].valuesAttribute.count {
                        //                        if !productAttributeDetails[i].values[j].isRadio {
                        //                            productAttributeDetails[i].values[j].isSelected = false
                        //                        }
                    }
                }
                self.tableView.reloadData()
            }
            
            textField.text = "$\(text.roundToTwoDecimal)"
            //productData.str_price = text.roundToTwoDecimal
            //productData.mainPrice = text.roundToTwoDecimal
            variationEditPriceEdit = 0.0
            // strEditedPrize = text.roundToTwoDecimal
            
            if isvariationparantPrize {
                var discout = getCurrentDiscount()
                
                //var discounttext = dict["apppliedDiscountString"] as? String ?? ""
                if discout != "" {
                    discout = discout.replacingOccurrences(of: "% Discount", with: "")
                    let dis = Double(discout)
                    if dis! > 0 {
                        
                        if adminUserCheck() {
                            if text != price {
                                pinAlertTF(type: "PriceTF"){(result) -> () in
                                    if result {
                                        self.strEditedPrize = text.roundToTwoDecimal
                                        self.variationEditPrice = Double(self.strEditedPrize)!
                                        self.variationEditPriceOn = 0.0
                                        self.updateTotalTextField(with: dis!, Amount: Double(text.roundToTwoDecimal)!)
                                        
                                    }else{
                                        let priceOld = Double(self.oldPrice) ?? 0
                                        self.priceTextField.text =  "$\(priceOld.roundToTwoDecimal)"
                                    }
                                }
                            }
                        }else{
                            strEditedPrize = text.roundToTwoDecimal
                            variationEditPrice = Double(strEditedPrize)!
                            variationEditPriceOn = 0.0
                            updateTotalTextField(with: dis!, Amount: Double(text.roundToTwoDecimal)!)
                        }
                        
                    }
                } else {
                    
                    if adminUserCheck() {
                        if text != price {
                            pinAlertTF(type: "PriceTF"){(result) -> () in
                                if result {
                                    self.strEditedPrize = text.roundToTwoDecimal
                                    self.variationEditPrice = Double(self.strEditedPrize)!
                                    self.variationEditPriceOn = 0.0
                                    self.updateTotalTextField(with: 0, Amount: Double(text.roundToTwoDecimal)!)
                                }else{
                                    let priceOld = Double(self.oldPrice) ?? 0
                                    self.priceTextField.text =  "$\(priceOld.roundToTwoDecimal)"
                                }
                            }
                        }
                    } else {
                        strEditedPrize = text.roundToTwoDecimal
                        variationEditPrice = Double(strEditedPrize)!
                        variationEditPriceOn = 0.0
                        updateTotalTextField(with: 0, Amount: Double(text.roundToTwoDecimal)!)
                    }
                }
            } else {
                var discout = getCurrentDiscount()
                
                //var discounttext = dict["apppliedDiscountString"] as? String ?? ""
                if discout != "" {
                    discout = discout.replacingOccurrences(of: "% Discount", with: "")
                    let dis = Double(discout)
                    if dis! > 0 {
                        
                        if adminUserCheck() {
                            if text != price {
                                pinAlertTF(type: "PriceTF"){(result) -> () in
                                    if result {
                                        self.strEditedPrize = text.roundToTwoDecimal
                                        self.variationEditPriceOn = Double(self.strEditedPrize)!
                                        self.updateTotalTextField(with: dis!, Amount: Double(text.roundToTwoDecimal)!)
                                        
                                    }else{
                                        let priceOld = Double(self.oldPrice) ?? 0
                                        self.priceTextField.text =  "$\(priceOld.roundToTwoDecimal)"
                                    }
                                }
                            }
                        } else {
                            strEditedPrize = text.roundToTwoDecimal
                            variationEditPriceOn = Double(strEditedPrize)!
                            updateTotalTextField(with: dis!, Amount: Double(text.roundToTwoDecimal)!)
                        }
                        
                    }
                } else {
                    
                    if adminUserCheck() {
                        if text != price {
                            pinAlertTF(type: "PriceTF"){(result) -> () in
                                if result {
                                    self.strEditedPrize = text.roundToTwoDecimal
                                    self.variationEditPriceOn = Double(self.strEditedPrize)!
                                    self.updateTotalTextField(with: 0, Amount: Double(text.roundToTwoDecimal)!)
                                    
                                }else{
                                    let priceOld = Double(self.oldPrice) ?? 0
                                    self.priceTextField.text =  "$\(priceOld.roundToTwoDecimal)"
                                }
                            }
                        }
                    } else {
                        strEditedPrize = text.roundToTwoDecimal
                        variationEditPriceOn = Double(strEditedPrize)!
                        updateTotalTextField(with: 0, Amount: Double(text.roundToTwoDecimal)!)
                    }
                }
            }
            
            //self.updateButtonUI(tag: Int(apppliedDiscount))
        }
        
        if textField == customtextField {
            let text = Double((textField.text ?? "").replacingOccurrences(of: "%", with: "")) ?? 0.0
            if text == 0 {
                //self.updateButtonUI(tag: 1000)
                //self.updateTotal(with: 0, isNoDiscount: true)
                return
            }
            
            if adminUserCheck(){
                pinAlertTF(type: "Discount"){(result) -> () in
                    if result {
                        self.updateButtonUI(tag: 5000)
                        let amountInPer = Double((textField.text ?? "").replacingOccurrences(of: "%", with: "")) ?? 0.0
                        self.updateTotal(with: amountInPer)
                        self.customtextField.text = "\(text.roundToTwoDecimal)%"
                        self.apppliedDiscount = text
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            self.discountTextField.text = "\(text.roundToTwoDecimal)%"
                        }
                        
                    }else{
                        if self.oldDiscount == "" || self.oldDiscount == "0" || self.oldDiscount == "0.0" || self.oldDiscount == "0.00" {
                            self.customtextField.text = ""
                        }else {
                            self.customtextField.text = "\(self.oldDiscount)%"
                        }
                        
                    }
                    
                }
            }else{
                customtextField.text = "\(text.roundToTwoDecimal)%"
                apppliedDiscount = text
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    self.discountTextField.text = "\(text.roundToTwoDecimal)%"
                }
                
                self.updateButtonUI(tag: 5000)
                let amountInPer = Double((textField.text ?? "").replacingOccurrences(of: "%", with: "")) ?? 0.0
                self.updateTotal(with: amountInPer)
            }
            
            
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.discountView.isHidden = true
        }
        updateCartButton()
    }
    
    func adminUserCheck() -> Bool {
        if let data = UserDefaults.standard.object(forKey: "account_type") as? String {
            if data != "Administrator" && (Double(productData.mainPrice) ?? 0) != 0  {
                if (DataManager.allowUserPriceChange == "false") {
                    return true
                }
            }
        }
        
        return false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        //        if adminUserCheck() {
        //            if textField == priceTextField  {
        //                let text = Double((textField.text ?? "").replacingOccurrences(of: "$", with: "")) ?? 0.0
        //                let price = Double(oldPrice) ?? 0
        //                if text != price {
        //                    pinAlertTF(type: "PriceTF"){(result) -> () in
        //                        print(result)
        //                    }
        //                }
        //            }
        //
        //            if textField == customtextField {
        //
        //            }
        //
        //
        //        }
        
        return true
    }
    
    func pinAlertTF(type: String, responseCallBack: @escaping responseCallBack)  {
        //Step : 1
        let alert = UIAlertController(title: "Enter Admin Pin!", message: "", preferredStyle: UIAlertController.Style.alert )
        //Step : 2
        let save = UIAlertAction(title: "Validate", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                //Read TextFields text data
                print(textField.text!)
                print("TF  : \(textField.text!)")
                self.callAPIToValidatePIN(pin: textField.text!) { (result) -> () in
                    // do stuff with the result
                    print(result)
                    responseCallBack(result)
                }
                
            } else {
                responseCallBack(false)
                appDelegate.showToast(message: "Please Enter Pin!")
                //self.showAlert(message: "Please Enter Pin!")
                print("TF is Empty...")
                if type == "PriceTF"{
                    self.priceTextField.text =  "$\((Double(self.productData.str_price) ?? 0.0).roundToTwoDecimal)"
                    let val = (Double(self.productData.str_price) ?? 0.0)
                    self.updateTotalTextField(with: 0, Amount: Double(val.roundToTwoDecimal)!)
                }
                
            }
            
        }
        
        //Step : 3
        alert.addTextField { (textField) in
            textField.placeholder = "Admin Pin"
            textField.delegate = self
            textField.keyboardType = .decimalPad
            textField.tag = 999
            textField.isSecureTextEntry = true
        }
        
        //Step : 4
        
        //Cancel action
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
            responseCallBack(false)
        }
        alert.addAction(cancel)
        alert.addAction(save)
        self.present(alert, animated:true, completion: nil)
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        var replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }
        
        if string == "\t" {
            return false
        }
        
        if textField == customtextField {
            if string == " " {
                return false
            }
            let amount = Double(replacementText) ?? 0.0
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
        }
        if textField.tag == 999  {
            if string == "." {
                return false
            }
            if string == " " {
                return false
            }
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 7
        }
        
        if textField == priceTextField {
            if string == " " {
                return false
            }
            replacementText = replacementText.replacingOccurrences(of: "$", with: "")
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount <= 8
        }
        
        if textField == frequencySubTF {
            if string == " " {
                return false
            }
            replacementText = replacementText.replacingOccurrences(of: "$", with: "")
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount <= 8
        }
        
        if textField == numberOfOccuTF {
            if string == " " {
                return false
            }
            replacementText = replacementText.replacingOccurrences(of: "$", with: "")
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount <= 8
        }
        
        if textField == qtyTextField  {
            if string == " " {
                return false
            }
            if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
                return false
            }
            let charactersCount = replacementText.utf16.count + (string.utf16).count - range.length
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            
            replacementText = filtered
            
            if productData.isAllowDecimal {
                if DataManager.noInventoryPurchase == "true" {
                     return replacementText.isValidDecimal(maximumFractionDigits: 2) && (Double(replacementText) ?? 0.0) <= 9999
                } else {
                    return replacementText.isValidDecimal(maximumFractionDigits: 2) && (Double(replacementText) ?? 0.0) <= availableProductQty
                }

            }else {
                
                if string == "." {
                    return false
                }
                
                if let index = DataManager.cartProductsArray?.index(where: {(($0 as! JSONDictionary)["row_id"] as? Double ?? 0.0 == self.productData.row_id)}) {
                    if var dict = DataManager.cartProductsArray?[index] as? JSONDictionary {
                        
                        let stock = Double(dict["productstock"] as? String ?? "") ?? 0
                        let unlimitedstock = dict["productunlimitedstock"] as? String ?? ""
                        let limitqty = Double(dict["productlimitqty"] as? String ?? "") ?? 0
                        
                        var availableqty = self.getAvailableQty(unlimited: unlimitedstock, limitQty: limitqty, stock: stock)
                        
                        let selectedIDArray = self.getSelectedIDArray()
                        
                        let productQtyInCart = self.getPreviousQty(productId: self.productData.str_product_id, productAttributesID: selectedIDArray)
                        
                        
                        if ((Double(replacementText) ?? 0.0)) > availableqty {
                            
                            print("variationQuantity========\(variationQuantity)")
                            
                            if DataManager.noInventoryPurchase == "false" {
                                if Double(((Double(replacementText) ?? 0.0))) > variationQuantity {
                                    print("enterrrrrrrr")
                                    //                                    self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                                    appDelegate.showToastCenter(message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                                    return false
                                } else {
                                    print("ouuuuuutttterrerrerre")
                                }
                            } else {
                                availableqty = 9999
                                if limitqty > 0 {
                                    if Int(((Double(replacementText) ?? 0.0))) > Int(limitqty) {
                                        //                                        self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                        appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                        return false
                                    }
                                }
                            }
                        }
                        
                        // self.showAlert(title: "Warning!", message: "\(self.productData.str_title) Has Limited Purchase - \(availableqty.newValue)")
                        // return false
                        
                        //let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
                        //let filtered = string.components(separatedBy: cs).joined(separator: "")
                        
                        if string == filtered && (Double(replacementText) ?? 0.0) <= availableqty {
                            return string == filtered && (Double(replacementText) ?? 0.0) <= availableqty
                        } else {
                            let selectedIDArray = self.getSelectedIDArray()
                            
                            let productQtyInCart = self.getPreviousQty(productId: self.productData.str_product_id, productAttributesID: selectedIDArray)
                            
                            let strVal = Double(replacementText) ?? 0.0
                            
                            if (productQtyInCart + Double(strVal)) > availableqty {
                                
                                print("variationQuantity========\(variationQuantity)")
                                
                                if DataManager.noInventoryPurchase == "false" {
                                    if Double((productQtyInCart + Double(strVal))) > variationQuantity {
                                        print("enterrrrrrrr")
                                        //                                        self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                                        appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Stock - \(availableqty.newValue)")
                                        return false
                                    } else {
                                        print("ouuuuuutttterrerrerre")
                                    }
                                } else {
                                    if limitqty > 0 {
                                        if Int((productQtyInCart + Double(strVal))) > Int(limitqty) {
                                            //                                            self.showAlert(title: "Warning!", message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                            appDelegate.showToast(message: "\(self.productName.text ?? "") Has Limited Purchase - \(limitqty.newValue)")
                                            return false
                                        }
                                    }
                                }
                            }
                            
                            // self.showAlert(title: "Warning!", message: "\(self.productData.str_title) Has Limited Purchase - \(availableqty.newValue)")
                            // return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //        if textField == customtextField {
        //            self.updateButtonUI(tag: 5000)
        //            let amountInPer = Double((textField.text ?? "").replacingOccurrences(of: "%", with: "")) ?? 0.0
        //            self.updateTotal(with: amountInPer)
        //        }
    }
}

//MARK: iPadTableViewCellDelegate
extension EditProductVC :iPadTableViewCellDelegate {
    func didUpdateAttribute(indexPath: IndexPath, attributes: [AttributesModel], isRadio: String, isSelect: Bool, price: Double) {
        self.productAttributeDetails[indexPath.section].valuesAttribute = attributes
        //       self.parseProductData(indexPath: indexPath, isDefaultParsing: false)
        //self.updateButtonUI(tag: 1000)
        
        print(isRadio)
        
        if isFirstOpen {
            if !isvariationparantPrize {
                strEditedPrize = ""
            }
        }
        
        isFirstOpen = false
        //        else {
        //            value = strEditedPrize
        //        }
        //        else {
        //            variationEditPrice = strEditedPrize.toDouble()!
        //        }
        
        //getVariationSurchageValue()
        updateQuantity()
        
        if isRadio == "radio" {
            variationEditPriceEdit = 0.0
            if !isvariationparantPrize {
                variationEditPrice = 0.0
                variationEditPriceOn = 0.0
            } else {
                variationEditPriceOn = 0.0
            }
        } else {
            if variationEditPrice != 0.0 {
                if isSelect {
                    variationEditPrice = variationEditPrice + price
                } else {
                    variationEditPrice = variationEditPrice - price
                    if variationEditPrice == 0.0 {
                        strEditedPrize = "0.00"
                    }
                }
            }
            if variationEditPriceOn != 0.0 {
                if isSelect {
                    variationEditPrice = variationEditPriceOn + price
                    variationEditPriceOn = 0.0
                } else {
                    variationEditPrice = variationEditPriceOn - price
                    variationEditPriceOn = 0.0
                }
            }
            
            if variationEditPriceEdit != 0.0 {
                if isSelect {
                    variationEditPriceEdit = variationEditPriceEdit + price
                    //variationEditPriceOn = 0.0
                } else {
                    variationEditPriceEdit = variationEditPriceEdit - price
                    //variationEditPriceOn = 0.0
                }
            }
            //variationEditPrice = variationEditPrice - surchargeCheckBoxPrice
        }
        
        print("inter value data ==== \(variationEditPrice)")
        
        
        
        self.updateTotal()
        self.updateCartButton()
        
        self.tableView.reloadData {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.section), at: .bottom, animated: false)
            
            //self.tableView.beginUpdates()
            //self.tableview.insertRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: .None)
            //self.tableView.endUpdates()
        }
    }
    
    func didUpdateSurchargeAttribute(indexPath: IndexPath, attributes: [AttributesModel], isRadio: String, isSelect: Bool, price: Double, isSurchargeValueChange: Bool, arraySuchargevariationData : JSONArray, arrSurchargeModel: [ProductSurchageVariationDetail]) {
        self.productAttributeDetails[indexPath.section].valuesAttribute = attributes
        //       self.parseProductData(indexPath: indexPath, isDefaultParsing: false)
        //self.updateButtonUI(tag: 1000)
        
        print(isRadio)
        
        if isFirstOpen {
            if !isvariationparantPrize {
                strEditedPrize = ""
            }
        }
        
        isFirstOpen = false
        //        else {
        //            value = strEditedPrize
        //        }
        //        else {
        //            variationEditPrice = strEditedPrize.toDouble()!
        //        }
        
        //getVariationSurchageValue()
        updateQuantity()
        
        if isRadio == "radio" {
            variationEditPriceEdit = 0.0
            if !isvariationparantPrize {
                variationEditPrice = 0.0
                variationEditPriceOn = 0.0
            } else {
                variationEditPriceOn = 0.0
            }
        } else {
            
//            if isSurchargeValueChange {
//                if isSelect {
//                    variationEditPrice = variationEditPrice + price
//                    strVariationPrize = variationEditPrice
//                } else {
//                    variationEditPrice = variationEditPrice - price
//                    if variationEditPrice == 0.0 {
//                        strEditedPrize = "0.00"
//                    }
//                }
//            }
            arraySuchargevariation.removeAll()
            arraySuchargevariation = arraySuchargevariationData
            
            productSurchargVariationDetails.removeAll()
            productSurchargVariationDetails = arrSurchargeModel
            
            
            //let hh = AttributeSubCategory.shared.getUpdateSurchargeVariation(with: arraySuchargevariation, index: indexSurchargeText, price: text.roundToTwoDecimal)
            
            //let surchageVariationArray = arrSurchargeModel as? JSONArray ?? JSONArray()
            //self.productSurchargVariationDetails[0].valuesSurchargeVariation = arrSurchargeModel
            //getSurchageData()
            
//            if variationEditPrice != 0.0 {
//                if isSelect {
//                    variationEditPrice = variationEditPrice + price
//                } else {
//                    variationEditPrice = variationEditPrice - price
//                    if variationEditPrice == 0.0 {
//                        strEditedPrize = "0.00"
//                    }
//                }
//            }
//            if variationEditPriceOn != 0.0 {
//                if isSelect {
//                    variationEditPrice = variationEditPriceOn + price
//                    variationEditPriceOn = 0.0
//                } else {
//                    variationEditPrice = variationEditPriceOn - price
//                    variationEditPriceOn = 0.0
//                }
//            }
//
//            if variationEditPriceEdit != 0.0 {
//                if isSelect {
//                    variationEditPriceEdit = variationEditPriceEdit + price
//                    //variationEditPriceOn = 0.0
//                } else {
//                    variationEditPriceEdit = variationEditPriceEdit - price
//                    //variationEditPriceOn = 0.0
//                }
//            }
            
            
            //variationEditPrice = variationEditPrice - surchargeCheckBoxPrice
        }
        
        print("inter value data ==== \(variationEditPrice)")
        
        
        
        self.updateTotal()
        self.updateCartButton()
        
        self.tableView.reloadData {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.section), at: .bottom, animated: false)
            
            //self.tableView.beginUpdates()
            //self.tableview.insertRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: .None)
            //self.tableView.endUpdates()
        }
    }
}

extension EditProductVC: AttributeUpdateDeleget {
    func didUpdateAttributeProduct(index: Int, attributes: [AttributesModel]) {
        print("enter code value")
    }
}

//MARK: CatAndProductsViewControllerDelegate
extension EditProductVC: CatAndProductsViewControllerDelegate {
    func didEditProduct(index: Int) {
        self.productAttributeDetails.removeAll()
        self.productData = ProductsModel()
        self.isEditProduct = true
        self.updateProductDetail(with: index)
        self.updateCartButton()
        self.btnProductInfo.isHidden = DataManager.isPosProductViewInfo == "true" ? false : true
        if let val = DataManager.showImagesFunctionality {
            self.str_showImagesFunctionality = val
        }
        addSubscriptionDesignSet()
        //self.str_showImagesFunctionality = DataManager.showImagesFunctionality!
    }
    
    func addSubscriptionDesignSet(){
        if DataManager.showSubscription {
            frequencySubTF.setPadding()
            frequencySubTF.setRightPadding()
            daymnthTF.setPadding()
            daymnthTF.setRightPadding()
            numberOfOccuTF.setPadding()
            numberOfOccuTF.setRightPadding()
            daymnthTF.setDropDown()
        }
    }
    
    func didAddNewProduct(data: ProductsModel, productDetail: Any) {
        self.btnProductInfo.isHidden = DataManager.isPosProductViewInfo == "true" ? false : true
        self.productAttributeDetails.removeAll()
        if let value = productDetail as? [ProductAttributeDetail] {
            self.productAttributeDetails = value
        }
        HomeVM.shared.SerialNumberDataListAry.removeAll()
        self.productData = ProductsModel()
        self.productData = data
        array_Products = [data]
        if let customerStatus = DataManager.customerObj?["customer_status"] as? String  {
            strCustomeStatus = (customerStatus == "WHOLESALE CUSTOMER") ? "WHOLESALE CUSTOMER" : ""
        } else {
            if orderType == .refundOrExchangeOrder {
                strCustomeStatus = (OrderVM.shared.orderInfo.customer_status == "WHOLESALE CUSTOMER") ? "WHOLESALE CUSTOMER" : ""
            }
        }
        self.isEditProduct = false
        self.updateProductDetail()
        //self.parseProductData()
        self.updateCartButton()
        addSubscriptionDesignSet()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.7) {
            if self.productData.serialNumberSearch != "" {
                for i in 0..<self.productItemMetaDetails.count {
                    if self.productItemMetaDetails[i].valuesMetaFields[0].label == "Serial Number"{
                        self.productItemMetaDetails[i].valuesMetaFields[0].itemMetaValue = self.productData.serialNumberSearch
                        HomeVM.shared.searchProductsArray[0].serialNumberSearch = ""
                        self.footerCollectionView.reloadData()
                        break
                    }
                }
            }
        }
    }
    
    func didSaveProductVariationSurchargeData(data: ProductsModel, productData: Any) {
        self.productSurchargVariationDetails.removeAll()
        HomeVM.shared.SerialNumberDataListAry.removeAll()
        if let value = productData as? [ProductSurchageVariationDetail] {
            self.productSurchargVariationDetails = value
        }
    }
    
    func didSaveProductAttributeData(data: ProductsModel, productData: Any) {
        self.productAttributeDetails.removeAll()
        if let value = productData as? [ProductAttributeDetail] {
            self.productAttributeDetails = value
        }
    }
    
    func didSaveProductItemMetaFieldsData(data: ProductsModel, productData: Any) {
        self.productItemMetaDetails.removeAll()
        if let value = productData as? [ProductItemMetaFieldsDetail] {
            self.productItemMetaDetails = value
        }
    }
    
    func didSaveProductVariationData(data: ProductsModel, productData: Any) {
        self.productVariationDetails.removeAll()
        if let value = productData as? [ProductVariationDetail] {
            self.productVariationDetails = value
        }
    }
    
    func didSaveNewProduct(data: ProductsModel, productDetail: Any) {
        self.productAttributeDetails.removeAll()
        if let value = productDetail as? [ProductAttributeDetail] {
            self.productAttributeDetails = value
        }
        self.productData = ProductsModel()
        self.productData = data
        self.isEditProduct = false
        self.updateProductDetail()
        self.updateButtonUI(tag: 1000)
        self.updateTotal()
        self.updateCartButton()
        self.handleDoneAction()
    }
    
    func didUpdatevalueatrribute(index: Int, attribute: AnyObject) {
        
        self.productAttributeDetails[index].valuesAttribute = attribute as? [AttributesModel]
        //       self.parseProductData(indexPath: indexPath, isDefaultParsing: false)
        //self.updateButtonUI(tag: 1000)
        //self.updateTotal()
        //self.updateCartButton()
        
        self.tableView.reloadData {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .bottom, animated: false)
            
            //self.tableView.beginUpdates()
            //self.tableview.insertRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: .None)
            //self.tableView.endUpdates()
        }
        
        print("enter value in side")
    }
    
}

//MARK: Scanner
extension EditProductVC {
    func scannerAlert(title:String, msg:String, target: UIViewController) {
        appDelegate.showToast(message: msg)
        //        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        //        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
        //            (result: UIAlertAction) -> Void in
        //            self.enableSwipeTextField()
        //        })
        //        target.present(alert, animated: true, completion: nil)
    }
}


//MARK: Parse Product Data
extension EditProductVC {
    
    /* func parseProductData(indexPath: IndexPath = IndexPath(row: 0, section: 0), isDefaultParsing: Bool = true) {
     
     //Variations
     if isDefaultParsing {
     productAttributeDetails.removeAll()
     if let children = productData.variations["children"] as? JSONArray {
     let productDetail = ProductModel.shared.getVariation(with: children)
     if productDetail.values.count > 0 {
     productAttributeDetails.append(productDetail)
     }
     }
     } else {
     let selectedAttribute = productAttributeDetails[indexPath.section].valuesAttribute[indexPath.row] //DD
     //Remove Previous Values If Selected
     for _ in 0..<productAttributeDetails.count {
     if indexPath.section + 1 < productAttributeDetails.count {
     if productAttributeDetails[indexPath.section + 1].values.first?.isRadio ?? false {
     productAttributeDetails.remove(at: indexPath.section + 1)
     }
     }
     }
     //Add New Variation
     if let children = selectedAttribute.jsonArray {
     let productDetail = ProductModel.shared.getVariation(with: children)
     if productDetail.values.count > 0 {
     if productAttributeDetails.count > indexPath.section + 1 {
     productAttributeDetails.insert(productDetail, at: indexPath.section + 1)
     }else {
     productAttributeDetails.append(productDetail)
     }
     }
     }
     }
     
     if isDefaultParsing {
     //Surcharge Variations
     self.parseSurchargeVariations()
     }else {
     //Reload Table On Variations Selected
     if productAttributeDetails[indexPath.section].valuesAttribute[indexPath.row].attribute_type == "radio" {
     self.tableView.reloadData {
     self.tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.section + 1), at: .top, animated: false)
     }
     }
     }
     }*/
    
    func parseSurchargeVariations() {
        var tempProductDetail = [ProductAttributeDetail]()
        for (key, value) in productData.surchargeVariations {
            if let dict = value as? JSONDictionary {
                tempProductDetail.append(ProductAttributeDetail(key: key, valuesAttribute: nil))       //DD
            }
        }
        tempProductDetail.sort { (d1, d2) -> Bool in
            return d1.key < d2.key
        }
        for detail in tempProductDetail {
            self.productAttributeDetails.append(detail)
        }
        self.tableView.reloadData()
    }
    
}

// by sudama add sub
//MARK: HieCORPickerDelegate
extension EditProductVC: HieCORPickerDelegate {
    func didClickOnPickerViewDoneButton() {
        daymnthTF.text = selectDaysMnth
        
    }
    func didSelectPickerViewAtIndex(index: Int) {
        selectDaysMnth = showArray[index]
        
    }
}

//API Methods
extension EditProductVC {
    func callAPIToValidatePIN(pin: String, successCallBack: @escaping responseCallBack) {
        LoginVM.shared.nonAdminValidatePIN(pin: pin) { (success, message, error) in
            if success == 1 {
                self.dismiss(animated: true, completion: nil)
                successCallBack(true)
                
            }else {
                successCallBack(false)
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    self.discountView.isHidden = true
                }
                
                if message != nil {
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    // By Altab 18 Aug 2022
    func callGetSerialNumberApi(){
        if  productData.str_product_id == "" {
            return
        }
        HomeVM.shared.SerialNumberDataListAry.removeAll()
        HomeVM.shared.getSerialNumberApi(productId: productData.str_product_id) { (success, message, error) in
            if success == 1 {
                //self.dismiss(animated: true, completion: nil)
                print("Featch serial number")
                print(HomeVM.shared.SerialNumberDataListAry)
                self.serialNumberAry = HomeVM.shared.SerialNumberDataListAry.map { String("\($0.serial_number.uppercased()) - \($0.location_name.uppercased())") }
                self.footerCollectionView.reloadData()
                
            }else {
                if message != nil {
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
}

//MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension EditProductVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productItemMetaDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iPadSMCollectionViewCell", for: indexPath) as! iPadSMCollectionViewCell
        if productItemMetaDetails.count > 0 {
            let arrayData  = productItemMetaDetails[indexPath.row].valuesMetaFields as [ItemMetaFieldssModel] as NSArray
            var attributeModel = arrayData[0] as! ItemMetaFieldssModel

            //cell.smNumerTF.tag = indexPath.row
            cell.smNumerTF.delegate = self
            cell.smNumerTF.placeholder = attributeModel.label
            if attributeModel.label == "Model Number" {
               // cell.smNumerTF.text = productData.str_product_code
                if productData.str_product_code != "" {
                    attributeModel.itemMetaValue = productData.str_product_code
                }
               
                cell.smNumerTF.text = attributeModel.itemMetaValue
            }else{
                cell.smNumerTF.text = attributeModel.itemMetaValue
            }
        }
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if isLandscape {
                return CGSize(width: (width/3)-10, height: 70)
            }else{
                return CGSize(width: (width/2)-10, height: 70)
            }
        
          
        } else {
   
            return CGSize(width: width, height: 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}

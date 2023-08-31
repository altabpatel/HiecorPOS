//
//  ProductsViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 30/11/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import AssetsLibrary
import Photos

class ProductsViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var containerViewProductDetails: UIView!
    @IBOutlet weak var containerViewProductSearch: UIView!
    @IBOutlet weak var containerViewEditProduct: UIView!
    @IBOutlet var view_KeyBoardUpBottomConstraint: NSLayoutConstraint!
    @IBOutlet var btn_CartSubtotal: UIButton!
    @IBOutlet var view_CartView: UIView!
    @IBOutlet var lbl_Subtotal: UILabel!
    @IBOutlet var view_Transparent: UIView!
    @IBOutlet weak var view_TransparentEdit: UIView!
    @IBOutlet var btn_Search: UIButton!
    @IBOutlet var seacrhBar: UISearchBar!
    @IBOutlet var btn_QuickPayDone: UIButton!
    @IBOutlet var tf_QuickPay: UITextField!
    @IBOutlet var viewKeyboardQuickPay: UIView!
    @IBOutlet var lbl_Category: UILabel!
    @IBOutlet var btn_Menu: UIButton!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_categoryInStocks: UIView!
    @IBOutlet weak var lbl_catagoryName: UILabel!
    
    @IBOutlet weak var btnInStock: UIButton!
    //MARK: Variables
    var CartTotalPrice = Double()
    var cartProductsArray = Array<Any>()
    var cartDict =  [String:Any]()
    var array_SelectStock = Array<Any>()
    var selectedProductCollectionIndex = Int()
    var selectedCollectionIndex = Int()
    var array_Products = [ProductsModel]()
    var controller = PopViewController()
    var selectedIndexSection1 = Int()
    var arraySected = [String]()
    var heightKeyboard : CGFloat?
    var customView = UIView()
    var str_CategoryName = String()
    var editProductDetailDelegate: CatAndProductsViewControllerDelegate?
    var searchDelegate: ProductsViewControllerDelegate?
    var productDelegate: ProductsViewControllerDelegate?
    var catAndProductDelegate: CatAndProductsViewControllerDelegate?
    var cartDelegate: CartContainerViewControllerDelegate?
    var editProductDelegate: ProductsContainerViewControllerDelegate?
    var productContainerDelegate: ProductSearchContainerDelegate?
    let gradient = CAGradientLayer()
    var selectedAttributes = [JSONDictionary]()
    
    
    var arrVariationValue = [ProductVariationDetail]()
    var arrSurchargeValue = [ProductSurchageVariationDetail]()
    var arrAttributeValue = [ProductAttributeDetail]()
    var isInStock = false
    //MARK: Private Variables
    private var isViewPresent = Bool()
    private var view_gradient = UIView()
    private var myPickerView: UIPickerView!
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide Keyboard
        appDelegate.isOpenToOrderHistory = false
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        if (self.revealViewController() != nil)
        {
            revealViewController().delegate = self
            btn_Menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        if !DataManager.posHideOutofStockFunctionality &&  DataManager.showProductInStockCheckbox == "true" {
            view_categoryInStocks.isHidden = false
        }else{
            view_categoryInStocks.isHidden = true
        }
        self.checkCart()
        self.customizeUI()
        self.productDelegate?.didSelectCategory?(string: str_CategoryName)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isViewPresent = true
        //Add Observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        viewKeyboardQuickPay.isHidden = true
        cartSubtotalAndCount()
//        view_categoryInStocks.isHidden = DataManager.posHideOutofStockFunctionality
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.isViewPresent = false
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        view_gradient.frame = CGRect(x: 0, y: self.view.frame.size.height-15, width: self.view.frame.size.width, height: 15)
        gradient.frame = view.bounds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "success" {
            let vc = segue.destination as! OrderViewController
            if !HomeVM.shared.userData.isEmpty {
                vc.OrderedData = HomeVM.shared.userData
                HomeVM.shared.userData.removeAll()
            }
        }

        if segue.identifier == "cartcontainer" {
            let pcvc = segue.destination as! CartContainerViewController
            cartDelegate = pcvc
            pcvc.cartViewDelegate = self
        }
        
        if segue.identifier == "cart"
        {
            let cvc = segue.destination as! CartViewController
            if UserDefaults.standard.value(forKey: "cartProductsArray") != nil
            {
                cvc.cartProductsArray = UserDefaults.standard.value(forKey: "cartProductsArray") as! [Any]
            }
            else
            {
                cvc.cartProductsArray = cartProductsArray
            }
        }
        
        if segue.identifier == "containerproducts" {
            let pcvc = segue.destination as! ProductsContainerViewController
            productDelegate = pcvc
            pcvc.editProductDelegate = self
            pcvc.str_SelectedCategoryName = str_CategoryName
            pcvc.delegate = self
            pcvc.isInStockCheck = isInStock
            productContainerDelegate = pcvc
        }
        
        if segue.identifier == "containereditproduct" {
            let vc = segue.destination as! EditProductContainerViewController
            vc.editProductDelegate = self
            self.editProductDelegate = vc
        }
        
        if segue.identifier == "EditProductVC" {
            let vc = segue.destination as! EditProductVC
            vc.delegate = self
            editProductDetailDelegate = vc
            vc.editProductDelegate = self
            vc.delegateForProductInfo = self
        }
        
        if segue.identifier == "productsearch" {
            let vc = segue.destination as! ProductSearchContainerViewController
            vc.delegate = self
            vc.str_SelectedCategoryName = str_CategoryName
            searchDelegate = vc
        }
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        super.performSegue(withIdentifier: identifier, sender: sender)
        
        if identifier == "cart" {
            // now the vc3 was already pushed on the navigationStack
            var navStackArray : [UIViewController] = self.navigationController!.viewControllers
            // insert vc2 at second last position
            let viewController2 = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
            navStackArray.insert(viewController2, at: navStackArray.count - 1)
            // update navigationController viewControllers
            self.navigationController!.setViewControllers(navStackArray, animated:false)
        }
    }

    //MARK: Private Functions
    private func customizeUI() {
        str_CategoryName = DataManager.selectedCategory                    
        lbl_Category.text = DataManager.selectedCategory
        lbl_catagoryName.text = DataManager.selectedCategory

        //if UIScreen.main.bounds.width < 375 {
            topConstraint.constant = 40
        //}
        view_Transparent.isHidden = true
        view_Transparent.isUserInteractionEnabled = true
        customView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height))
        customView.backgroundColor = UIColor.black
        customView.alpha = 0.5
        customView.isUserInteractionEnabled = false
        customView.isHidden = true
        self.view.addSubview(customView)
        
        tf_QuickPay.delegate = self
        tf_QuickPay.layer.masksToBounds = true
        tf_QuickPay.layer.cornerRadius = 2.0
        tf_QuickPay.layer.borderWidth = 1.0
        tf_QuickPay.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        viewKeyboardQuickPay.layer.masksToBounds = true
        viewKeyboardQuickPay.layer.cornerRadius = 2.0
        viewKeyboardQuickPay.layer.borderWidth = 0.5
        viewKeyboardQuickPay.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0 , width: 15, height: self.tf_QuickPay.frame.height)) //UIView(frame: CGRectMake(0, 0, 15, self.tf_AddDiscount.frame.height))
        tf_QuickPay.leftView = paddingView
        tf_QuickPay.leftViewMode = UITextFieldViewMode.always
        
        btn_QuickPayDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
        btn_QuickPayDone.isUserInteractionEnabled = false
        
        view_gradient = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-15, width: self.view.frame.size.width, height: 15))
        gradient.colors = [UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3).cgColor,UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 0.5).cgColor]
        gradient.frame = view.bounds
        view_gradient.layer.insertSublayer(gradient, at: 0)
        self.view.addSubview(view_gradient)
        
        view_gradient.isHidden = false
        view_TransparentEdit.isUserInteractionEnabled = true
    }
    
    private func checkCart() {
        if let cartArray = DataManager.cartProductsArray {
            for i in 0..<cartArray.count {
                let obj = (cartArray as AnyObject).object(at: i)
                let isRefundProduct = (obj as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
                if isRefundProduct {
                    DataManager.cartProductsArray = nil
                    PaymentsViewController.paymentDetailDict.removeAll()
                    view_CartView.isHidden = true
                    return
                }
            }
        }
    }
    
    func cartSubtotalAndCount()
    {
        CartTotalPrice = Double()
        cartProductsArray = Array<Any>()
        var cartCount = String()
        DataManager.subTotalForSocket = 0.0
        if UserDefaults.standard.value(forKey: "cartProductsArray") != nil{ //value(forKey: "cartProductsArray") {
            
            let cartProd = UserDefaults.standard.value(forKey: "cartProductsArray") as! Array<Any>
            for i in (0..<cartProd.count)
            {
                let obj = (cartProd as AnyObject).object(at: i)
                let price = Double((obj as AnyObject).value(forKey: "productprice") as? String  ?? "0") ?? 0.00
                let qty = Double((obj as AnyObject).value(forKey: "productqty") as? String ?? "0") ?? 0.00
                let total: Double = qty * price
                cartCount = "\((Double(cartCount) ?? 0) + qty)"
                CartTotalPrice = total + CartTotalPrice
                cartProductsArray.append(obj)
            }
            DataManager.subTotalForSocket = CartTotalPrice
            let SpaceSTr = "  "
            btn_CartSubtotal.setImage(UIImage(named:"carticon"), for: .normal)
            cartCount = cartCount.count > 4 ? "\(cartCount.prefix(3)).." : cartCount
            cartCount = cartCount == "" ? "0": cartCount
            btn_CartSubtotal.setTitle(SpaceSTr+cartCount, for: .normal)
            
            let dollerSymbol = "$"
            let amountText = NSMutableAttributedString.init(string: "Subtotal ")
            amountText.setAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 15.0)!,
                                      NSAttributedStringKey.foregroundColor: UIColor.white],
                                     range: NSMakeRange(0, 9))
            let amount = NSMutableAttributedString.init(string: "\(dollerSymbol)\(CartTotalPrice.roundToTwoDecimal)")
            amount.setAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 20.0)!,
                                  NSAttributedStringKey.foregroundColor: UIColor.white],
                                 range: NSMakeRange(0, "\(CartTotalPrice.roundToTwoDecimal)".count+1))
            let attrStr = NSMutableAttributedString()
            attrStr.append(amountText)
            attrStr.append(amount)
            
            lbl_Subtotal.attributedText = attrStr
        }
        else
        {
            let SpaceSTr = "  "
            let amountText = NSMutableAttributedString.init(string: "Subtotal ")
            amountText.setAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 15.0)!,
                                      NSAttributedStringKey.foregroundColor: UIColor.white],
                                     range: NSMakeRange(0, 9))
            let amount = NSMutableAttributedString.init(string: "$0.00")
            amount.setAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 20.0)!,
                                  NSAttributedStringKey.foregroundColor: UIColor.white],
                                 range: NSMakeRange(0, 5))
            let attrStr = NSMutableAttributedString()
            attrStr.append(amountText)
            attrStr.append(amount)
            lbl_Subtotal.attributedText = attrStr
            btn_CartSubtotal.setTitle(SpaceSTr+"0", for: .normal)
        }
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            self.heightKeyboard = keyboardFrame.size.height
            self.view.addSubview(viewKeyboardQuickPay)
            viewKeyboardQuickPay.frame = CGRect(x: 0, y:rawFrame.origin.y-viewKeyboardQuickPay.frame.size.height , width: self.view.frame.size.width, height: viewKeyboardQuickPay.frame.size.height)
        }
        
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    
    //MARK: IBAction Method
    @IBAction func btn_SelectCategoryAction(_ sender: Any) {
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        vc.delegate = self
        vc.productContainerDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_CartSubtotalAction(_ sender: Any) {
        self.view.endEditing(true)
        view_CartView.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view_CartView.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if (self.revealViewController().frontViewPosition != FrontViewPositionLeft) {
            self.revealViewController()?.revealToggle(animated: true)
        }
        if(cartProductsArray.count>0) {
            self.performSegue(withIdentifier: "cart", sender: nil)
        } else {
            appDelegate.showToast(message: "Cart is empty!")
//            let alertController = UIAlertController(title: "Alert", message: "Cart is empty!", preferredStyle:.alert)
//
//            alertController.addAction(UIAlertAction.init(title: kOkay, style: .default, handler: { (UIAlertAction) in alertController.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func tf_QuickPayAction(_ sender: Any) {
        self.view.endEditing(true)
        setView(view: viewKeyboardQuickPay, hidden: false)
    }
    
    @IBAction func btn_QuickPayAction(_ sender: Any)
    {
        self.view.endEditing(true)
        setView(view: viewKeyboardQuickPay, hidden: false)
        customView.isHidden = false
        customView.isUserInteractionEnabled = true
        tf_QuickPay.becomeFirstResponder()
        view_KeyBoardUpBottomConstraint.constant = heightKeyboard!
        viewKeyboardQuickPay.frame = CGRect(x: 0, y:self.view.frame.size.height-heightKeyboard! , width: self.view.frame.size.width, height: viewKeyboardQuickPay.frame.size.height)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btn_QuickPayCancelAction(_ sender: Any) {
        self.view.endEditing(true)
        tf_QuickPay.resignFirstResponder()
        setView(view: viewKeyboardQuickPay, hidden: true)
        customView.isHidden = true
        tf_QuickPay.text = ""
        btn_QuickPayDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
        btn_QuickPayDone.isUserInteractionEnabled = false
    }
    
    @IBAction func btn_QuickPayDoneAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btn_SearchAction(_ sender: Any)  {
        self.view.endEditing(true)
        self.searchDelegate?.didTapOnSearchButton?()
        containerViewProductSearch.isHidden = false
    }
    @IBAction func btnInStock_action(_ sender: Any) {
        isInStock.toggle()
        btnInStock.setImage(isInStock ? #imageLiteral(resourceName: "boxSelect") : #imageLiteral(resourceName: "uncheckGray"), for: .normal)
       // productResetDelegate?.didShowInStockItemOnly?(isStock: isInStock)
        productDelegate?.didShowInStockItemOnly?(inStock: isInStock)
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
    
}

//MARK:- TextField Delegate Methods
extension ProductsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let startingLength = tf_QuickPay.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        if (newLength > 0)
        {
            btn_QuickPayDone.setImage(UIImage(named: "tick-active"), for: .normal)
            btn_QuickPayDone.isUserInteractionEnabled = true
        }
        else
        {
            btn_QuickPayDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
            btn_QuickPayDone.isUserInteractionEnabled = false
        }
        return true
    }
}

//MARK: ProductSearchContainerDelegate
extension ProductsViewController: ProductSearchContainerDelegate {
    func didSearchCancel() {
        containerViewProductSearch.isHidden = true
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }

    func didSearchComplete(with product: ProductsModel) {
        productContainerDelegate?.didSearchComplete(with: product)
    }
}

//MARK:- SWRevealViewController Delegates
extension ProductsViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionRight {
            self.view.alpha = 0.5
            // Disable the topViewController's interaction
            setView(view: viewKeyboardQuickPay, hidden: true)
            customView.isHidden = true
            tf_QuickPay.resignFirstResponder()
            self.view.endEditing(true)
            
        }
        else if position == FrontViewPositionLeft {
            // Menu will close
            self.view.alpha = 1.0
        }
        //Hide Keyboard
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
}

//MARK: EditProductsContainerViewDelegate
extension ProductsViewController: EditProductsContainerViewDelegate {
    func hideDetailView() {
        customView.isHidden = true
        setView(view: containerViewProductDetails, hidden: true)
        view_Transparent.isHidden = true
    }
    
    func refreshCart() {
        productDelegate?.getProductList?()
    }
    
    func didSelectProduct(with identifier: String) {
        if (identifier == "editproduct")
        {
            setView(view: containerViewEditProduct, hidden: false)
            view_TransparentEdit.isHidden = false
        }
        else if (identifier == "btn_ProductEditCancelAction")
        {
            setView(view: containerViewEditProduct, hidden: true)
            view_TransparentEdit.isHidden = true
        }
            
        else if (identifier == "updateproduct")
        {
            setView(view: containerViewEditProduct, hidden: true)
            view_TransparentEdit.isHidden = true
            view_gradient.isHidden = false
        }else if (identifier == "productDetails")
        {
            setView(view: containerViewProductDetails, hidden: false)
            view_Transparent.isHidden = false
            view_gradient.isHidden = true
        }
            
        else if (identifier == "productDetailsCancel")
        {
            setView(view: containerViewProductDetails, hidden: true)
            view_Transparent.isHidden = true
            view_gradient.isHidden = false
        }
        else if (identifier == "customviewHide")
        {
            customView.isHidden = true
        }
        else if (identifier == "customviewUnHide")
        {
            customView.isHidden = false
        }
            
        else if (identifier == "addedtocart")
        {
            customView.isHidden = true
            setView(view: containerViewProductDetails, hidden: true)
            view_Transparent.isHidden = true
        }
    }
    
    func didCalculateCartTotal() {
        self.cartSubtotalAndCount()
    }
    
    func didReceiveProductDetail(data: ProductsModel) {
        let (successOne, variationValue) = ProductModel.shared.parseVariationData(productData: data)
        print(variationValue as Any)
        
        if successOne {
            editProductDetailDelegate?.didSaveProductVariationData?(data: data, productData: variationValue as Any)
        }
        let (successOneItemMeta, itemMetaValue) = ProductModel.shared.parseItemMetaFieldsData(productData: data)
        print(itemMetaValue as Any)
        
        if successOneItemMeta {
            editProductDetailDelegate?.didSaveProductItemMetaFieldsData?(data: data, productData: itemMetaValue as Any)
            //  arrItemMetaDataValue = itemMetaValue!
        }
        let (successSurcharge, surchageValue) = ProductModel.shared.parseSurchargeVariationData(productData: data)
        print(surchageValue as Any)
        
        if successSurcharge {
            editProductDetailDelegate?.didSaveProductVariationSurchargeData?(data: data, productData: surchageValue as Any)
        }
        
        let (success, value) = ProductModel.shared.parseAttribute(productData: data)
        if !success || (data.isEditQty || data.isEditPrice || (variationValue?.count)! > 0 || (surchageValue?.count)! > 0 || (value?.count)! > 0) {
           // editProductDetailDelegate?.didAddNewProduct?(data: data, productDetail: value as Any)
           // setView(view: containerViewProductDetails, hidden: false)
           // view_Transparent.isHidden = false
           // view_gradient.isHidden = true
                arrAttributeValue = value!
                
                editProductDetailDelegate?.didSaveProductAttributeData!(data: data, productData: value as Any)
                
                let isvalue = searchUpcCodeInVariation(strUPC: appDelegate.strSearch, prod: data)
                
                if isvalue {
                    
                    let dataOne = self.arrAttributeValue
                    
                    editProductDetailDelegate?.didSaveNewProduct?(data: data, productDetail: dataOne as Any)
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
                         setView(view: containerViewProductDetails, hidden: false)
                         view_Transparent.isHidden = false
                         view_gradient.isHidden = true
                    }
                }
            
        }else {
            editProductDetailDelegate?.didSaveNewProduct?(data: data, productDetail: value as Any)
        }
    }
}

//MARK: ProductsContainerViewControllerDelegate
extension ProductsViewController: ProductsContainerViewControllerDelegate {
    func didGetCardDetail() {
        cartDelegate?.didPlaceOrderWithCardInformation?()
    }
    
    func didUpdateInternet(isOn: Bool) {
        if !isViewPresent || isOn {
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController") as! CategoriesViewController
        vc.delegate = self
        vc.productContainerDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectEditButton(data: ProductsModel, index: Int, isSearching: Bool) {
        self.editProductDelegate?.didSelectEditButton?(data: data, index: index, isSearching: isSearching)
    }
    func didGetProductListData() {
        if !DataManager.posHideOutofStockFunctionality &&  DataManager.showProductInStockCheckbox == "true" {
            view_categoryInStocks.isHidden = false
        }else{
            view_categoryInStocks.isHidden = true
        }
    }
}

//MARK: EditProductDelegate
extension ProductsViewController: EditProductDelegate {
    func didUpdateHeight(isKeyboardOpen: Bool) {
        UIView.animate(withDuration: Double(0.5), animations: {
            self.topConstraint.constant =  40//isKeyboardOpen ? 40 : UIScreen.main.bounds.width < 375 ? 40 : 120
        })
    }
// MARK:-  DD for Iphone Upsell manage
    func didClickOnDoneButton() {
        hideEditView(isDone: true)
        cartSubtotalAndCount()
    }
    
    func didClickOnCrossButton() {
        hideEditView(isDone: false)
    }
    
    func hideEditView(isDone:Bool) {
        setView(view: containerViewProductDetails, hidden: true)
        view_Transparent.isHidden = true
        view_gradient.isHidden = false
        if isDone{
            productDelegate?.didAutoUpSellDataValueIphone?()
        }
    }
}

//MARK: ProductsViewControllerDelegate
extension ProductsViewController: ProductsViewControllerDelegate {
    func didSelectCategory(string: String) {
        self.str_CategoryName = string
        self.lbl_Category.text = string
        self.lbl_catagoryName.text = string
        productDelegate?.didSelectCategory?(string: string)
    }
}

//MARK: ProductsViewControllerDelegate
extension ProductsViewController: CartViewControllerDelegate {
    func didHideView(with identifier: String) {
        //...
    }
    
    func didUpdateView(with OriginY: CGFloat) {
        //...
    }
    
    func didTapOnSearchbar() {
        //...
    }
    
    func moveToSuccessScreen() {
        self.performSegue(withIdentifier: "success", sender: nil)
    }
}

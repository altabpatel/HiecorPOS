//
//  CartViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 04/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire

class CartViewController: BaseViewController{
    
    //MARK: IBOutlets
    @IBOutlet weak var containerViewProductDetails: UIView!
    @IBOutlet weak var containerViewProductSearch: UIView!
    @IBOutlet var view_Transparent: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var showDetailsContainer: UIView!
    @IBOutlet weak var shippingContainer: UIView!
    @IBOutlet weak var productInfoContainer: UIView!
//    showDetailsContainer
    //MARK: Variables
    var cartProductsArray = Array<Any>()
    var selectedAttributes = [JSONDictionary]()
    var delegate: CartContainerViewControllerDelegate?
    var cartResetDelegate: ResetCartDelegate?
    var editProductDetailDelegate: CatAndProductsViewControllerDelegate?
    var refundOrder: JSONDictionary?
    var orderType: OrderType = .newOrder
    var searchDelegate: ProductsViewControllerDelegate?
    weak var showDetailsDelegateOne : showDetailsDelegate?
    weak var showShippingDelegateOne : EditProductDelegate?
    weak var subScriptionDelegateOne : EditProductDelegate?

    var arrAttributeValue = [ProductAttributeDetail]()
    var selectedAttribute = JSONArray()
    var editProductDelegate: ProductsContainerViewControllerDelegate?
    var isOpenToOrderHistory = false
    var orderInfoObj = OrderInfoModel()
    //MARK: Private Variables
    private var customView = UIView()
    private var customViewForTax = UIView()
    var CustomerObj = CustomerListModel()
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeUI()
        self.updateUI()
        
        showDetailsContainer.isHidden = true
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if orderType == .refundOrExchangeOrder {
            SwipeAndSearchVC.shared.isEnable = true
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if orderType == .refundOrExchangeOrder {
            SwipeAndSearchVC.shared.isEnable = false
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        customViewForTax.frame = CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        //if UIScreen.main.bounds.width < 375 {
            topConstraint.constant = 40
        //}
        customViewForTax = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height))
        customViewForTax.backgroundColor = UIColor.black
        customViewForTax.alpha = 0.5
        customViewForTax.isUserInteractionEnabled = false
        customViewForTax.isHidden = true
        self.view.addSubview(customViewForTax)
        
        customView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height-344))
        customView.backgroundColor = UIColor.black
        customView.alpha = 0.5
        customView.isUserInteractionEnabled = false
        customView.isHidden = true
        self.view.addSubview(customView)
    }
    
    private func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    
    func didReceiveCptureProductDetail(data: ProductsModel) {
        let (successOne, variationValue) = ProductModel.shared.parseVariationData(productData: data)
        print(variationValue as Any)
        
        if successOne {
            editProductDetailDelegate?.didSaveProductVariationData?(data: data, productData: variationValue as Any)
        }
        
        let (successOneItemMeta, itemMetaValue) = ProductModel.shared.parseItemMetaFieldsData(productData: data)
        print(itemMetaValue as Any)
        
        if successOneItemMeta {
            editProductDetailDelegate?.didSaveProductItemMetaFieldsData?(data: data, productData: itemMetaValue as Any)
            // arrItemMetaDataValue = itemMetaValue!
        }
        
        let (successSurcharge, surchageValue) = ProductModel.shared.parseSurchargeVariationData(productData: data)
        print(surchageValue as Any)
        
        if successSurcharge {
            editProductDetailDelegate?.didSaveProductVariationSurchargeData?(data: data, productData: surchageValue as Any)
        }
        
        let (success, value) = ProductModel.shared.parseAttribute(productData: data)
        if !success || (data.isEditQty || data.isEditPrice || (variationValue?.count)! > 0 || (surchageValue?.count)! > 0 || (value?.count)! > 0) {
            editProductDetailDelegate?.didAddNewProduct?(data: data, productDetail: value as Any)
            setView(view: containerViewProductDetails, hidden: false)
            view_Transparent.isHidden = false
        }else {
            editProductDetailDelegate?.didSaveNewProduct?(data: data, productDetail: value as Any)
        }
    }
    
    private func updateUI() {
        
        if DataManager.isCaptureButton {
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
                    ProductsModelObj.str_limit_qty = productsData.limit_qty
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
                    ProductsModelObj.width =  0.0
                    ProductsModelObj.height =  0.0
                    ProductsModelObj.length =  0.0
                    ProductsModelObj.weight =  0.0
                    selectedAttribute = productsData.selectedAttributesData
                    
                    didReceiveCptureProductDetail(data: ProductsModelObj)
                    
                    //didAddNewProductCapture(data: ProductsModelObj, productDetail: ProductsModelObj)
                }
            }
        }
        
        if orderType == .newOrder {
            headerLabel.text = "Cart"
            resetButton.isHidden = false
            DataManager.collectTips = DataManager.collectTips ? DataManager.collectTips : DataManager.tempCollectTips
        }else {
            headerLabel.text = "Exchange/Refund"
            resetButton.isHidden = true
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
            
            searchDelegate?.didReceiveRefundProductIds?(string: refundIDS)
        }
    }

    //MARK: IBAction Method
    @IBAction func btn_BackAction(_ sender: Any) {
        self.view.endEditing(true)
        self.delegate?.didUpdateCart?(with: "cartbackbuttonaction")
        if orderType == .newOrder {
            if !NetworkConnectivity.isConnectedToInternet() {
                if let vcs = self.navigationController?.viewControllers {
                    for vc in vcs {
                        if vc.isKind(of: CategoriesViewController.self) {
                            self.navigationController?.popToViewController(vc, animated: true)
                            return
                        }
                    }
                }
            }
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btn_ResetAction(_ sender: Any) {
        self.view.endEditing(true)
        self.delegate?.didUpdateCart?(with: "cartresetbuttonaction")
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cartcontainer"
        {
            let vc = segue.destination as! CartContainerViewController
            vc.cartProductsArray = cartProductsArray
            vc.cartViewDelegate = self
            vc.editProductDelegate = self
            delegate = vc
            cartResetDelegate = vc
            vc.showDetailsDelegateOne = self
            vc.delegateEditProduct = self
            vc.isOpenToOrderHistory = isOpenToOrderHistory
            vc.orderType = orderType
            if isOpenToOrderHistory{
                vc.orderInfoObj =  orderInfoObj
                vc.CustomerObj = CustomerObj
            }
        }
        
        if segue.identifier == "EditProductVC" {
            let vc = segue.destination as! EditProductVC
            vc.delegate = self
            editProductDetailDelegate = vc
            vc.editProductDelegate = self
            vc.delegateForProductInfo = self
            vc.orderType = orderType
            // self.editProductDelegate = vc.editProductDelegate
        }
        if segue.identifier == "containereditproduct" {
            let vc = segue.destination as! EditProductContainerViewController
            vc.editProductDelegate = self
            self.editProductDelegate = vc
        }
        
        if segue.identifier == "ShowDetailsIphoneVC"
        {
            let vc = segue.destination as! ShowDetailsIphoneVC
            vc.delegate = self
            showDetailsDelegateOne = vc
        }
        
        if segue.identifier == "SubscriptionContainerViewController"
        {
            let vc = segue.destination as! SubscriptionContainerViewController
            vc.delegate = self
            subScriptionDelegateOne = vc
        }
        
	   if segue.identifier == "ShippingIphoneVC"
        {
            let vc = segue.destination as! ShippingIphoneVC
            vc.delegate = self
            showShippingDelegateOne = vc
        }
        
        if segue.identifier == "success" {
            let vc = segue.destination as! OrderViewController
            if !HomeVM.shared.userData.isEmpty {
                vc.OrderedData = HomeVM.shared.userData
                HomeVM.shared.userData.removeAll()
            }
        }
        
        if segue.identifier == "productsearch" {
            let vc = segue.destination as! ProductSearchContainerViewController
            vc.delegate = self
            searchDelegate = vc
            vc.orderType = orderType
        }
    }
    
}

//MARK: ProductSearchContainerDelegate
extension CartViewController: ProductSearchContainerDelegate {
    func didSearchCancel() {
        containerViewProductSearch.isHidden = true
    }
    
    func didSearchComplete(with product: ProductsModel) {
        didReceiveProductDetail(data: product)
    }
}

//MARK: CartViewControllerDelegate
extension CartViewController: CartViewControllerDelegate {
    func didTapOnSearchbar() {
        searchDelegate?.didTapOnSearchButton?()
        containerViewProductSearch.isHidden = false
    }
    
    func moveToSuccessScreen() {
        performSegue(withIdentifier: "success", sender: nil)
    }
    
    func didUpdateView(with OriginY: CGFloat) {
        customView.frame = CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: OriginY)
    }
    
    func didHideView(with identifier: String) {
        if (identifier == "customviewunhide") {
            customView.isHidden = false
            customView.isUserInteractionEnabled = true
        }
        else if(identifier == "customviewhide")
        {
            customViewForTax.isHidden = true
            customView.isHidden = true
        }
        else if(identifier == "customviewunhidetax")
        {
            customViewForTax.isHidden = false
            customViewForTax.isUserInteractionEnabled = true
        }
    }
}

//MARK: EditProductsContainerViewDelegate
extension CartViewController: EditProductsContainerViewDelegate {
    
    func didSelectProduct(with identifier: String) {
        if (identifier == "productDetails")
        {
            setView(view: containerViewProductDetails, hidden: false)
            view_Transparent.isHidden = false
        }
        
        if (identifier == "productDetailsCancel")
        {
            setView(view: containerViewProductDetails, hidden: true)
            view_Transparent.isHidden = true
        }
            
        else if (identifier == "addedtocart")
        {
            customView.isHidden = true
            setView(view: containerViewProductDetails, hidden: true)
            view_Transparent.isHidden = true
        } else if (identifier == "editproduct"){
            setView(view: productInfoContainer, hidden: false)
            view_Transparent.isHidden = false
            containerViewProductDetails.isHidden = true
        } else if (identifier == "btn_ProductEditCancelAction") {
            setView(view: productInfoContainer, hidden: true)
            view_Transparent.isHidden = true
        }
    }
    
    func didCalculateCartTotal() {
        delegate?.refreshCart?()
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
            // arrItemMetaDataValue = itemMetaValue!
        }
        
        let (successSurcharge, surchageValue) = ProductModel.shared.parseSurchargeVariationData(productData: data)
        print(surchageValue as Any)
        
        if successSurcharge {
            editProductDetailDelegate?.didSaveProductVariationSurchargeData?(data: data, productData: surchageValue as Any)
        }
        
        let (success, value) = ProductModel.shared.parseAttribute(productData: data)
        if !success || (data.isEditQty || data.isEditPrice || (variationValue?.count)! > 0 || (surchageValue?.count)! > 0 || (value?.count)! > 0) {
            editProductDetailDelegate?.didAddNewProduct?(data: data, productDetail: value as Any)
            setView(view: containerViewProductDetails, hidden: false)
            view_Transparent.isHidden = false
        }else {
            editProductDetailDelegate?.didSaveNewProduct?(data: data, productDetail: value as Any)
        }
    }
    
    func didEditProduct(index: Int) {
        editProductDetailDelegate?.didEditProduct?(index: index)
        setView(view: containerViewProductDetails, hidden: false)
        view_Transparent.isHidden = false
    }
}

//MARK: EditProductDelegate
extension CartViewController: EditProductDelegate {
    func didUpdateHeight(isKeyboardOpen: Bool) {
        UIView.animate(withDuration: Double(0.5), animations: {
            self.topConstraint.constant =  40//isKeyboardOpen ? 0 : UIScreen.main.bounds.width < 375 ? 40 : 150
        })
    }

    func didClickOnDoneButton() {
        hideEditView(isDone: true)
        delegate?.refreshCart?()
    }
    
    func didClickOnCrossButton() {
        hideEditView(isDone: false)
    }
    
    func hideEditView(isDone:Bool) {
        setView(view: containerViewProductDetails, hidden: true)
        view_Transparent.isHidden = true
        if isDone {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.searchDelegate?.didAutoUpSellDataValueIphone?()
            }
        }
    }
    
    func didClickOnCloseButton() {
        setView(view: showDetailsContainer, hidden: true)
    }
    func showShippingCard(){
        //shippingDelegateOne?.showShippingCard?()
        setView(view: shippingContainer, hidden: false)
    }
    func hideShippingCard() {
         setView(view: shippingContainer, hidden: true)
        //delegate?.callDataSendRate?()
    }
    func hideShippingCardFromDoneBtn(){
        setView(view: shippingContainer, hidden: true)
        delegate?.callDataSendRate?()
    }
    func didShowShippingAddress(data: CustomerListModel){
        showShippingDelegateOne?.didShowShippingAddress?(data: data)
    }
    func getCartProductsArray(data: Array<Any>){
        showShippingDelegateOne?.getCartProductsArray?(data: data)
    }
}

//MARK: showDetailsDelegate
extension CartViewController: showDetailsDelegate {
    
    func didShowDetailsAtrribute(index: Int, cartArray: Array<AnyObject>) {
        showDetailsDelegateOne?.didShowDetailsAtrribute?(index: index, cartArray: cartArray)
        setView(view: showDetailsContainer, hidden: false)
    }
}
//MARK: ProductsContainerViewControllerDelegate
extension CartViewController: ProductsContainerViewControllerDelegate {
    
    func didSelectEditButton(data: ProductsModel, index: Int, isSearching: Bool) {
        editProductDelegate?.didSelectEditButton?(data: data, index: index, isSearching: isSearching)
    }
}

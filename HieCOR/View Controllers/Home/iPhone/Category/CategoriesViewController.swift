//
//  CategoriesViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 28/11/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: BaseViewController
{
    
    //MARK: IBOutlets
    @IBOutlet var view_CartView: UIView!
    @IBOutlet var lbl_Subtotal: UILabel!
    @IBOutlet var btn_CartSubtotal: UIButton!
    @IBOutlet var viewKeyBoardUpBottomConstraint: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var btn_QuickPayDone: UIButton!
    @IBOutlet var tf_QuickPay: UITextField!
    @IBOutlet var viewKeyboardUp: UIView!
    @IBOutlet var btn_Menu: UIButton?
    @IBOutlet weak var containerViewProductDetails: UIView!
    @IBOutlet weak var manualPaymentContainerView: UIView!
    @IBOutlet var view_Transparent: UIView!
    
    //MARK: Variables
    var heightKeyboard : CGFloat?
    var customView = UIView()
    var array_Categories = [CategoriesModel]()
    var productDelegate: ProductsViewControllerDelegate?
    var delegate: ProductsViewControllerDelegate?
    var productContainerDelegate: ProductsContainerViewControllerDelegate?
    var editProductDetailDelegate: CatAndProductsViewControllerDelegate?
    var manualPaymentDelegate: CatAndProductsViewControllerDelegate?
    var cartProductsArray = Array<Any>()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.revealViewController() != nil)
        {
            revealViewController().delegate = self
            btn_Menu?.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
        }
        self.checkCart()
        self.customizeUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.orderDataClear = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.upadateCart()
        viewKeyboardUp.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "catsearch"
        {
            let csvc = segue.destination as! CategorySearchViewController
            csvc.array_Categories = array_Categories
            csvc.delegate = self
        }
        
        if segue.identifier == "cart"
        {
            let cvc = segue.destination as! CartViewController
            if UserDefaults.standard.value(forKey: "cartProductsArray") != nil{
                cvc.cartProductsArray = UserDefaults.standard.value(forKey: "cartProductsArray") as! [Any]
            }
            
        }
        
        if segue.identifier == "CategoriesContainerViewController" {
            let pcvc = segue.destination as! CategoriesContainerViewController
            pcvc.editProductDelegate = self
            pcvc.delegate = self
            pcvc.productDelegate = self
        }
        
        if segue.identifier == "ManualPaymentVC" {
            let vc = segue.destination as! ManualPaymentVC
            vc.delegate = self
            manualPaymentDelegate = vc
        }
        
        if segue.identifier == "EditProductVC" {
            let vc = segue.destination as! EditProductVC
            vc.delegate = self
            editProductDetailDelegate = vc
            vc.editProductDelegate = self
            vc.delegateForProductInfo = self
        }
        
    }
    
    //MARK: Private Functions
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
    
    private func upadateCart() {
        if DataManager.cartProductsArray != nil{
            
            let cartProd = UserDefaults.standard.value(forKey: "cartProductsArray") as! Array<Any>
            var CartPrice = Double()
            var cartCount = String()
            
            if(cartProd.count>0)
            {
                for i in (0..<cartProd.count)
                {
                    let obj = (cartProd as AnyObject).object(at: i)
                    let price = Double((obj as AnyObject).value(forKey: "productprice") as? String  ?? "0") ?? 0.00
                    let qty = Double((obj as AnyObject).value(forKey: "productqty") as? String ?? "0") ?? 0.00
                    let total: Double = qty * price
                    CartPrice = total + CartPrice
                    cartCount = "\((Double(cartCount) ?? 0) + qty)"
                }
                
                //if !DataManager.isOffline || NetworkConnectivity.isConnectedToInternet() {
                    view_CartView.isHidden = false
                //}
            }
            else
            {
                view_CartView.isHidden = true
            }
            
            let SpaceSTr = "  "
            btn_CartSubtotal.setImage(UIImage(named:"carticon"), for: .normal)
            cartCount = cartCount.count > 4 ? "\(cartCount.prefix(3)).." : cartCount
            btn_CartSubtotal.setTitle(SpaceSTr+cartCount, for: .normal)

            let dollerSymbol = "$"
            let amountText = NSMutableAttributedString.init(string: "Subtotal ")
            amountText.setAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 15.0)!,
                                      NSAttributedStringKey.foregroundColor: UIColor.white],
                                     range: NSMakeRange(0, 9))
            let amount = NSMutableAttributedString.init(string: "\(dollerSymbol)\(CartPrice.roundToTwoDecimal)")
            amount.setAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 20.0)!,
                                  NSAttributedStringKey.foregroundColor: UIColor.white],
                                 range: NSMakeRange(0, "\(CartPrice.roundToTwoDecimal)".count+1))
            let attrStr = NSMutableAttributedString()
            attrStr.append(amountText)
            attrStr.append(amount)
            
            lbl_Subtotal.attributedText = attrStr
        }
        else
        {
            view_CartView.isHidden = true
        }
    }
    
    private func customizeUI() {
        //if UIScreen.main.bounds.width < 375 {
            topConstraint.constant = 40
        //}
        UIApplication.shared.isStatusBarHidden = false
        customView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height))
        customView.backgroundColor = UIColor.black
        customView.alpha = 0.5
        customView.isUserInteractionEnabled = true
        customView.isHidden = true
        self.view.addSubview(customView)
        
        tf_QuickPay.layer.masksToBounds = true
        tf_QuickPay.layer.cornerRadius = 2.0
        tf_QuickPay.layer.borderWidth = 1.0
        tf_QuickPay.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        viewKeyboardUp.layer.masksToBounds = true
        viewKeyboardUp.layer.cornerRadius = 2.0
        viewKeyboardUp.layer.borderWidth = 0.5
        viewKeyboardUp.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0 , width: 15, height: self.tf_QuickPay.frame.height)) //UIView(frame: CGRectMake(0, 0, 15, self.tf_AddDiscount.frame.height))
        tf_QuickPay.leftView = paddingView
        tf_QuickPay.leftViewMode = UITextFieldViewMode.always
        
        btn_QuickPayDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
        btn_QuickPayDone.isUserInteractionEnabled = false
        
        self.automaticallyAdjustsScrollViewInsets = false
        //view_CartView.isHidden = true
    }
    
    private func cartSubtotalAndCount()
    {
        var cartTotalPrice = Double()
        cartProductsArray = Array<Any>()
        var cartCount = String()
        
        if let array = DataManager.cartProductsArray {
            if array.count > 0 {
                let cartProd = array
                for i in (0..<cartProd.count)
                {
                    let obj = (cartProd as AnyObject).object(at: i)
                    let price = Double((obj as AnyObject).value(forKey: "productprice") as? String  ?? "0") ?? 0.00
                    let qty = Double((obj as AnyObject).value(forKey: "productqty") as? String ?? "0") ?? 0.00
                    let total: Double = qty * price
                    cartCount = "\((Double(cartCount) ?? 0) + qty)"
                    cartTotalPrice = total + cartTotalPrice
                    cartProductsArray.append(obj)
                }
                
                let SpaceSTr = "  "
                btn_CartSubtotal.setImage(UIImage(named:"carticon"), for: .normal)
                cartCount = cartCount.count > 4 ? "\(cartCount.prefix(3)).." : cartCount
                btn_CartSubtotal.setTitle(SpaceSTr+cartCount, for: .normal)

                let dollerSymbol = "$"
                let amountText = NSMutableAttributedString.init(string: "Subtotal ")
                amountText.setAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 15.0)!,
                                          NSAttributedStringKey.foregroundColor: UIColor.white],
                                         range: NSMakeRange(0, 9))
                let amount = NSMutableAttributedString.init(string: "\(dollerSymbol)\(cartTotalPrice.roundToTwoDecimal)")
                amount.setAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 20)!,
                                      NSAttributedStringKey.foregroundColor: UIColor.white],
                                     range: NSMakeRange(0, "\(cartTotalPrice.roundToTwoDecimal)".count+1))
                let attrStr = NSMutableAttributedString()
                attrStr.append(amountText)
                attrStr.append(amount)
                
                lbl_Subtotal.attributedText = attrStr
                
                view_CartView.isHidden = false
            }else {
                view_CartView.isHidden = true
            }
        }else {
            view_CartView.isHidden = true
        }
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        if let infoKey  = notification.userInfo?[UIKeyboardFrameEndUserInfoKey],
            let rawFrame = (infoKey as AnyObject).cgRectValue {
            let keyboardFrame = view.convert(rawFrame, from: nil)
            self.heightKeyboard = keyboardFrame.size.height
            self.view.addSubview(viewKeyboardUp)
            viewKeyboardUp.frame = CGRect(x: 0, y:rawFrame.origin.y-viewKeyboardUp.frame.size.height , width: self.view.frame.size.width, height: viewKeyboardUp.frame.size.height)
        }
    }
    
    //MARK: IBActions Method
    @IBAction func btn_SearchAction(_ sender: Any)
    {
        performSegue(withIdentifier: "catsearch", sender: nil)
    }
    
    @IBAction func btn_QuickPayAction(_ sender: Any)
    {
        setView(view: viewKeyboardUp, hidden: false)
        customView.isHidden = false
        tf_QuickPay.becomeFirstResponder()
        viewKeyBoardUpBottomConstraint.constant = heightKeyboard!
        viewKeyboardUp.frame = CGRect(x: 0, y:self.view.frame.size.height-heightKeyboard! , width: self.view.frame.size.width, height: viewKeyboardUp.frame.size.height)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btn_QuickPayCancelAction(_ sender: Any) {
        tf_QuickPay.resignFirstResponder()
        setView(view: viewKeyboardUp, hidden: true)
        customView.isHidden = true
        tf_QuickPay.text = ""
        btn_QuickPayDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
        btn_QuickPayDone.isUserInteractionEnabled = false
    }
    
    @IBAction func btn_CartAction(_ sender: Any) {
        view_CartView.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.view_CartView.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if (self.revealViewController().frontViewPosition != FrontViewPositionLeft) {
            self.revealViewController()?.revealToggle(animated: true)
        }
        self.performSegue(withIdentifier: "cart", sender: nil)
    }
    
}

//MARK: UITextFieldDelegate
extension CategoriesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
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

//MARK: EditProductsContainerViewDelegate
extension CategoriesViewController: EditProductsContainerViewDelegate {
    func hideDetailView() {
        customView.isHidden = true
        setView(view: containerViewProductDetails, hidden: true)
        view_Transparent.isHidden = true
    }
    
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
}

//MARK: EditProductDelegate
extension CategoriesViewController: EditProductDelegate {
    func didUpdateHeight(isKeyboardOpen: Bool) {
        UIView.animate(withDuration: Double(0.5), animations: {
            self.topConstraint.constant =  40//isKeyboardOpen ? 0 : UIScreen.main.bounds.width < 375 ? 40 : 150
        })
    }

    func didClickOnDoneButton() {
        hideEditView()
        cartSubtotalAndCount()
    }
    
    func didClickOnCrossButton() {
        hideEditView()
    }
    
    func hideEditView() {
        setView(view: containerViewProductDetails, hidden: true)
        view_Transparent.isHidden = true
    }
}

//MARK: SWRevealViewController Delegates
extension CategoriesViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionRight
        {
            self.view.alpha = 0.5
            setView(view: viewKeyboardUp, hidden: true)
            customView.isHidden = true
            tf_QuickPay.resignFirstResponder()
        }
        else if position == FrontViewPositionLeft
        {
            self.view.alpha = 1.0
        }
        //Hide Keyboard
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
}

//MARK:-  ManualPaymentDelegate
extension CategoriesViewController: ManualPaymentDelegate {
    func didTapOnCrossButton() {
        setView(view: manualPaymentContainerView, hidden: true)
        self.upadateCart()
    }
    
    func didTapOnAddButton() {
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            self.performSegue(withIdentifier: "cart", sender: nil)
            return
        }
        //        setView(view: manualPaymentContainerView, hidden: true)
        self.upadateCart()
    }
}

//MARK: CategoriesContainerViewControllerDelegate
extension CategoriesViewController: CategoriesContainerViewControllerDelegate {
    func getProduct(withCategory name: String) {
        delegate?.didSelectCategory?(string: name)                  
    }

    func didTapOnManualPayment() {
        self.view.endEditing(true)
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
//        view_CartView.isHidden = true
        setView(view: manualPaymentContainerView, hidden: false)
        manualPaymentDelegate?.didTapOnManualPayment?()
    }
}

//MARK: UIPresentationControllerDelegate
extension CategoriesViewController {
    override func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

//MARK: ProductsContainerViewControllerDelegate
extension CategoriesViewController: ProductsContainerViewControllerDelegate {
    func didGetCardDetail() {
        productContainerDelegate?.didGetCardDetail?()
    }
    
    func noCardDetailFound() {
        productContainerDelegate?.noCardDetailFound?()
    }
}

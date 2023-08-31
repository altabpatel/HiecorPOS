//
//  LoginViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 28/11/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class LoginViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet var baseUrlTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var homePageLogo: UIImageView!
    @IBOutlet var tilteLable: UILabel!
    @IBOutlet var headingTitleLbl: UILabel!
    
    private var arraySelectedPaymet = [String]()
    var versionOb = Int()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup TextField
        baseUrlTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        baseUrlTextField.autocorrectionType = .no
        baseUrlTextField.autocapitalizationType = .none
        baseUrlTextField.returnKeyType = .next
        usernameTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        
        DataManager.userTypeFlag = false
             if DataManager.userTypeFlag == true{
                 homePageLogo.image = UIImage(named: ("logo1"))
                 baseUrlTextField.placeholder = "HieCOR base URL"
                 tilteLable.text = "Welcome to HieCOR POS"
             }else{
                 homePageLogo.isHidden = true
                 baseUrlTextField.placeholder = "Site URL"
                 tilteLable.text = "Log in to your account of POS "
                 headingTitleLbl.text = "Let's Get Stared"
                 tilteLable.font = UIFont.systemFont(ofSize: 17.0)
             }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fillUserDetail()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.customizeUI()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.customizeUI()
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        //Set Border
        baseUrlTextField.setBorder()
        usernameTextField.setBorder()
        passwordTextField.setBorder()
        //Set Padding
        baseUrlTextField.setPadding(with: #imageLiteral(resourceName: "urlicon"))
        usernameTextField.setPadding(with: #imageLiteral(resourceName: "usericon"))
        passwordTextField.setPadding(with: #imageLiteral(resourceName: "passwordicon"))
    }
    
    //Fill User Detail
    private func fillUserDetail() {
        //baseUrlTextField.text = DataManager.loginBaseUrl
        if DataManager.urlTextFeildValue == "" {
            baseUrlTextField.text = DataManager.loginBaseUrl
        }else{
            baseUrlTextField.text = DataManager.urlTextFeildValue
        }
        usernameTextField.text = DataManager.loginUsername
        passwordTextField.text = DataManager.loginPassword
    }
    
    //Validate Data
    private func isValidData() -> Bool {
        if baseUrlTextField.isEmpty {
            if DataManager.userTypeFlag == true{
                baseUrlTextField.setCustomError(text: "Please enter Base URL.")
            }
            else{
                baseUrlTextField.setCustomError(text: "Please enter Site URL.")
            }
            
            return false
        }
        
        if isValidUrl(urlString: BaseURL) {
            print("URL valid")
        }else{
            print("URL invalid")
            if BaseURL.contains("walrathlandscapesupply") {
                
            } else {
                if DataManager.userTypeFlag == true{
                    baseUrlTextField.setCustomError(text: "Please enter valid Base URL.")
                }
                else{
                    baseUrlTextField.setCustomError(text: "Please enter valid Site URL.")
                }
                
                return false
            }
            
        }
        
        if usernameTextField.isEmpty {
            usernameTextField.setCustomError(text: "Please enter User ID.")
            return false
        }
        
        if passwordTextField.isEmpty {
            passwordTextField.setCustomError(text: "Please enter Password.")
            return false
        }
        return true
    }
    
    //MARK: IBActions
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        ResetAllCartData()
        self.callAPIToPing()
    }
}

//MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case baseUrlTextField:
            textField.resignFirstResponder()
            usernameTextField.becomeFirstResponder()
            break
        case usernameTextField:
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            textField.resignFirstResponder()
            //Validate Data
            appendBaseUrl()
            if self.isValidData() {
                ResetAllCartData()
                self.callAPIToPing()
            }
            break
        default: break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
            return false
        }
        if range.location == 0 && string == " " {
            return false
        }
        return textField == baseUrlTextField ? string != " " : true
    }
}

//MARK: API Methods
extension LoginViewController {
    
    func appendBaseUrl() {
        if self.baseUrlTextField.text!.contains("https://")
        {
            BaseURL = self.baseUrlTextField.text!.trimmingCharacters(in: .whitespaces)
        }
        else
        {
            BaseURL = "https://" + self.baseUrlTextField.text!.trimmingCharacters(in: .whitespaces)
        }
        
        if (!BaseURL.contains(".com") && !BaseURL.contains(".biz") && !BaseURL.contains(".net")){
            BaseURL = BaseURL + ".hiecor.com"
        }
        
    }
    
    func callAPIToPing() {
        //Update Base URL
        appendBaseUrl()
        
        //Validate Data
        if !isValidData() {
            return
        }
        var parameters = JSONDictionary()
        parameters[APIKeys.kUsername] = self.usernameTextField.text!
        parameters[APIKeys.kPassword] = self.passwordTextField.text!
        self.callAPIToLogin(parameters: parameters)
        
        //
//        LoginVM.shared.ping { (success, message, error) in
//            if success == 1 {
//                var parameters = JSONDictionary()
//                parameters[APIKeys.kUsername] = self.usernameTextField.text!
//                parameters[APIKeys.kPassword] = self.passwordTextField.text!
//                //Call API
//                self.callAPIToLogin(parameters: parameters)
//            }else {
//                if message != nil {
////                    self.showAlert(message: message)
//                    appDelegate.showToast(message: message!)
//                }else {
//                    self.showErrorMessage(error: error)
//                }
//            }
//        }
    }
    
    func checkPreviousloginBaseUrl() -> Bool{
        
        let baseURLFirstIndex = BaseURL.components(separatedBy: ".")
        let dbBaseURLFirstIndex = DataManager.loginBaseUrl.components(separatedBy: ".")
        if baseURLFirstIndex[0].replacingOccurrences(of: "https://", with: "") == dbBaseURLFirstIndex[0].replacingOccurrences(of: "https://", with: ""){
            return true
        }
        return false
    }
    func checkPreviousBaseUrlData() -> Bool{
        
        let baseURLFirstIndex = BaseURL.components(separatedBy: ".")
        let dbBaseURLFirstIndex = DataManager.BaseUrlData.components(separatedBy: ".")
        if baseURLFirstIndex[0].replacingOccurrences(of: "https://", with: "") == dbBaseURLFirstIndex[0].replacingOccurrences(of: "https://", with: ""){
            return true
        }
        return false
    }
    
    
    func callAPIToLogin(parameters: JSONDictionary) {
        LoginVM.shared.login(parametersDict: parameters) { (success, message, error) in
            if success == 1 {
                self.CheckCRMSettings()
                //Update Data Manager
                // DataManager.loginBaseUrl = self.baseUrlTextField.text!
                //sudama -- start
                DataManager.urlTextFeildValue = self.baseUrlTextField.text!
                DataManager.loginBaseUrl = BaseURL//self.baseUrlTextField.text!
                // end
                DataManager.loginUsername = self.usernameTextField.text!
                DataManager.loginPassword = self.passwordTextField.text!
                DataManager.isUserLogin = true
                DataManager.receipt = true
                DataManager.isFirstTimeUserLogin = true
                DataManager.isBalanceDueData = false
                HomeVM.shared.tipValue = 0.0
                HomeVM.shared.amountPaid = 0.0
                HomeVM.shared.DueShared = 0.0
                self.versionOb = Int(DataManager.appVersion)!
                if BaseURL != DataManager.BaseUrlData && !self.checkPreviousBaseUrlData() {
                    DataManager.BaseUrlData = BaseURL
                    DataManager.isCardReader = false
                    DataManager.showContactSourceBoxAllInOne = ""
                    DataManager.showOfficePhoneAllInOne = ""
                    DataManager.showCustomerStatusAllInOne = ""
                    self.customerStatusArrayData?.removeAll()
                    self.SettingListDataValue()
                    DataManager.isTaxOn = true
                    //DataManager.isGooglePrinter = true
                    DataManager.isCustomerManagementOn = true
                    DataManager.isPromptAddCustomer = false
                    DataManager.isDrawerOpen = false
                    DataManager.starCloudMACaAddress = ""
                } else {
                    self.setRootViewControllerForIphone()
                }
           
                
                
            }else {
                if message != nil {
//                    self.showAlert(message: message)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    func CheckCRMSettings() {
       // if self.baseUrlTextField.text != DataManager.loginBaseUrl {
         if BaseURL != DataManager.loginBaseUrl && !checkPreviousloginBaseUrl(){
            //Reset Settings
            DataManager.isTaxOn = false
            DataManager.isCustomerManagementOn = false
            DataManager.isPromptAddCustomer = false
            DataManager.selectedPayment = nil
            DataManager.selectedPAX = ["CREDIT"]
            DataManager.signature = false
            DataManager.tempSignature = false
            DataManager.receipt = false
            DataManager.pinloginEveryTransaction = false
            DataManager.deviceName = false
            DataManager.deviceNameText = nil
            DataManager.cardReaders = false
            DataManager.isGiftCard = false
            DataManager.isInternalGift = false
            DataManager.isSingatureOnEMV = false
            DataManager.isPaxPayGiftCard = false
            
            DataManager.printers = false
            DataManager.isBarCodeReaderOn = false
            DataManager.collectTips = false
            DataManager.tempCollectTips = false
            DataManager.isAuthentication = false
            DataManager.isCouponList = false
            DataManager.isShowCountry = false
            DataManager.isBluetoothPrinter = false
          //DataManager.isGooglePrinter = false
            DataManager.selectedCountry = "US"
            DataManager.isSplitRow = false
            DataManager.isDiscountOptions = false
            DataManager.tenDiscountValue = 10
            DataManager.twentyDiscountValue = 20
            DataManager.seventyDiscountValue = 70
            DataManager.isLineItemTaxExempt = false
            DataManager.isProductEdit = false
            DataManager.isSwipeToPay = false
            DataManager.posCollectSignatureOnEveryOrder = false
            DataManager.showProductInStockCheckbox = ""
            DataManager.showPaymentMethodCcInvoice = false
            DataManager.customerStatusType?.removeAll()
            DataManager.customerStatusDefaultName = ""
        }
    }
    
}

//MARK: API Methods
extension LoginViewController {
    
    func SettingListDataValue() {
        HomeVM.shared.getSetting(responseCallBack: { (success, message, error) in
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                
                print("succes value in data")
                for data in HomeVM.shared.settingList {// for parse setting of on only credit card and invoice payment method
                    let keyData = data.settingKey
                    let valueData = data.settingValue
                    switch keyData {
                    case "show_payment_method_cc_invoice":
                        if valueData == "true" {
                            DataManager.showPaymentMethodCcInvoice = true
                        } else {
                            DataManager.showPaymentMethodCcInvoice = false
                        }
                    default: break
                    }
                }
                for data in HomeVM.shared.settingList {
                    
                    let keyData = data.settingKey
                    let valueData = data.settingValue
                    //let option = data.settingOption
                    
                    switch keyData {
                        
                    case "pos_enablededitproduct":
                        if valueData == "true" {
                            DataManager.isProductEdit = true
                        } else {
                            DataManager.isProductEdit = false
                        }
                        
                    case "pos_giftcard_functionality":
                        if valueData == "true" {
                            if !DataManager.showPaymentMethodCcInvoice {
                                DataManager.isGiftCard = true
                                self.arraySelectedPaymet.append("GIFT CARD")
                            }else{
                                DataManager.isGiftCard = false
                            }
                            //self.arraySelectedPaymet.append("GIFT CARD")
                            
                        } else {
                            DataManager.isGiftCard = false
                        }
                        
                    case "pos_external_gift_certifcates_functionality":
                        if valueData == "true" {
                            if !DataManager.showPaymentMethodCcInvoice {
                                self.arraySelectedPaymet.append("EXTERNAL GIFT CARD")
                            }
                            //self.arraySelectedPaymet.append("EXTERNAL GIFT CARD")
                        }
                        
                    case "pos_pax_gift_card_functionality":
                        if valueData == "true" {
                            DataManager.selectedPAX.append("GIFT")
                            DataManager.isPaxPayGiftCard = true
                        } else {
                            DataManager.isPaxPayGiftCard = false
                        }
                        
                    case "pos_external_functionality":
                        if valueData == "true" {
                            if !DataManager.showPaymentMethodCcInvoice {
                                self.arraySelectedPaymet.append("EXTERNAL")
                            }
                            //self.arraySelectedPaymet.append("EXTERNAL")
                        }
                        
                    case "pos_internal_gift":
                        
                        if valueData == "true" {
                            if !DataManager.showPaymentMethodCcInvoice {
                                DataManager.isInternalGift = true
                                self.arraySelectedPaymet.append("INTERNAL GIFT CARD")
                            }else{
                                DataManager.isInternalGift = false
                            }
//                            DataManager.isInternalGift = false
                            //self.arraySelectedPaymet.append("INTERNAL GIFT CARD")
                        } else {
                            DataManager.isInternalGift = false
                        }
                        
                    case "pos_pax_debit_card_functionality":
                        if valueData == "true" {
                            DataManager.selectedPAX.append("DEBIT")
                        }
                        
                    case "pos_pax_functionality":
                        if valueData == "true" {
                            if !DataManager.showPaymentMethodCcInvoice {
                                self.arraySelectedPaymet.append("PAX PAY")
                            }
                            //self.arraySelectedPaymet.append("PAX PAY")
                        }
                        
                    case "pos_multi_card_functionality":
                        
                        if valueData == "true" {
                            self.arraySelectedPaymet.append("MULTI CARD")
                        }
//                        if valueData == "true" {
//                            if self.versionOb > 3 {
//                                //self.arraySelectedPaymet.append("MULTI CARD")
//                            }
//                            if !DataManager.showPaymentMethodCcInvoice {
//                                self.arraySelectedPaymet.append("MULTI CARD")
//                            }
//                        }
                        
                    case "pos_invoice_functionality":
                        if !DataManager.showPaymentMethodCcInvoice {
                            if valueData == "true" {
                                self.arraySelectedPaymet.append("INVOICE")
                            }
                        }else{
                            self.arraySelectedPaymet.append("INVOICE")
                        }
//                        //if valueData == "true" {
//                            self.arraySelectedPaymet.append("INVOICE")
//                        //}
                        
                    case "pos_check_functionality":
                        if valueData == "true" {
                            if !DataManager.showPaymentMethodCcInvoice {
                                self.arraySelectedPaymet.append("ACH CHECK")
                            }
                            //self.arraySelectedPaymet.append("ACH CHECK")
                        }
                        
                    case "pos_paper_check_functionality":
                        if valueData == "true" {
                            if !DataManager.showPaymentMethodCcInvoice {
                                self.arraySelectedPaymet.append("CHECK")
                            }
                            //self.arraySelectedPaymet.append("CHECK")
                        }
                        
                    case "pos_credit_functionality":
                        if !DataManager.showPaymentMethodCcInvoice {
                            if valueData == "true" {
                                self.arraySelectedPaymet.append("CREDIT")
                            }
                        }else{
                            self.arraySelectedPaymet.append("CREDIT")
                        }
                        //if valueData == "true" {
//                            self.arraySelectedPaymet.append("CREDIT")
                        //}
                        
                    case "pos_cash_functionality":
                        if valueData == "true" {
                            if !DataManager.showPaymentMethodCcInvoice {
                                self.arraySelectedPaymet.append("CASH")
                            }
                            //self.arraySelectedPaymet.append("CASH")
                        }
                        
                    case "pos_coupon_list_functionality":
                        if valueData == "true" {
                            DataManager.isCouponList = true
                        } else {
                            DataManager.isCouponList = false
                        }
                        
                    case "pos_enable_access_functionality":
                        if valueData == "true" {
                            DataManager.pinloginEveryTransaction = true
                        } else {
                            DataManager.pinloginEveryTransaction = false
                        }
                        
                    case "pos_tip_functionality":
                        if valueData == "true" {
                            DataManager.collectTips = true
                        } else {
                            DataManager.collectTips = false
                        }
                        
                    case "pos_auth_functionality":
                        if valueData == "true" {
                            DataManager.isAuthentication = true
                        } else {
                            DataManager.isAuthentication = false
                        }
                        
                    case "pos_cart_functionality":
                        if valueData == "true" {
                            DataManager.isSplitRow = true
                        } else {
                            DataManager.isSplitRow = false
                        }
                        
                    case "pos_discount_percentage_functionality":
                        if valueData == "true" {
                            DataManager.isDiscountOptions = true
                        } else {
                            DataManager.isDiscountOptions = false
                        }
                        
                    case "pos_tax_exempt_functionality":
                        if valueData == "true" {
                            DataManager.isLineItemTaxExempt = true
                        } else {
                            DataManager.isLineItemTaxExempt = false
                        }
                        
                    case "signatureline_status":
                        if valueData == "true" {
                            DataManager.signatureOnReceipt = true
                        } else {
                            DataManager.signatureOnReceipt = false
                        }
                        
                    case "pos_signature_functionality":
                        if valueData == "true" {
                            DataManager.signature = true
                        } else {
                            DataManager.signature = false
                        }
                        
                    case "pax_signature_functionality":
                        if valueData == "true" {
                            DataManager.isSingatureOnEMV = true
                        } else {
                            DataManager.isSingatureOnEMV = false
                        }
                        
                    case "pos_line_item_discount":
                        
                        let arr = valueData!.components(separatedBy: ",")
                        for i in 0..<arr.count {
                            if i == 0 {
                                DataManager.tenDiscountValue = arr[i].toDouble() ?? 0.0
                            } else if i == 1 {
                                DataManager.twentyDiscountValue = arr[i].toDouble() ?? 0.0
                            } else if i == 2 {
                                DataManager.seventyDiscountValue = arr[i].toDouble() ?? 0.0
                            }
                        }
                    case "pos_cloud_receipt_mode" :
                                                                    
                        // if regionsModelObj.settingValue == "true" {
                        DataManager.isGooglePrinter =  valueData == "true"  ? true : false
                        //DataManager.isGooglePrinter = false
                        DataManager.isBluetoothPrinter = false
                    //                        }else {
                    //                            DataManager.isCloudReceiptPrinter = false
                    //                            DataManager.isBluetoothPrinter = true
                    //                        }
                        
                    // socket sudama
                    case "socket_app_url":
                        if valueData != "" || valueData != "NULL" {
                            DataManager.socketAppUrl = valueData!
                        } else {
                            DataManager.socketAppUrl = "https://node.hiecor.com"
                        } //
                    
                    case "customer_status":
                        let arr = valueData!.components(separatedBy: ",")
                        for i in 0..<arr.count{
                            HomeVM.shared.customerStatusArray.append(arr[i])
                        }
                        DataManager.customerStatusType = HomeVM.shared.customerStatusArray
                        
                    case "default_customer_status":
                        if valueData != "" || valueData != "NULL" {
                            DataManager.customerStatusDefaultName = valueData ?? ""
                        } else {
                            DataManager.customerStatusDefaultName = ""
                        }
                        
                    case "show_customer_status_all_in_one":
                        if valueData != "" || valueData != "NULL" {
                            DataManager.showCustomerStatusAllInOne = valueData ?? ""
                        } else {
                            DataManager.showCustomerStatusAllInOne = ""
                        }
                        
                    case "pos_default_payment_method":
                        if valueData != "" || valueData != "NULL" {
                            DataManager.posDefaultPaymentMethod = valueData ?? ""
                        } else {
                            DataManager.posDefaultPaymentMethod = ""
                        }
                    case "pos_hide_out_of_stock_functionality":
                        if valueData == "true" {
                            DataManager.posHideOutofStockFunctionality = true
                        } else {
                            DataManager.posHideOutofStockFunctionality = false
                        }
                        
                    case "pos_collect_signature_on_every_order":
                        if valueData == "true" {
                            DataManager.posCollectSignatureOnEveryOrder = true
                        } else {
                            DataManager.posCollectSignatureOnEveryOrder = false
                        }
                    case "show_office_phone_box":
                        if valueData != "" || valueData != "NULL" {
                            DataManager.showOfficePhoneAllInOne = valueData ?? ""
                        } else {
                            DataManager.showOfficePhoneAllInOne = ""
                        }
                        
                    case "show_contact_source_box":
                        if valueData != "" || valueData != "NULL" {
                            DataManager.showContactSourceBoxAllInOne = valueData ?? ""
                        } else {
                            DataManager.showContactSourceBoxAllInOne = ""
                        }
                        
                    default: break
                        
                    }
                    
                }
                
                DataManager.selectedPayment = self.arraySelectedPaymet
                
                self.setRootViewControllerForIphone()
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

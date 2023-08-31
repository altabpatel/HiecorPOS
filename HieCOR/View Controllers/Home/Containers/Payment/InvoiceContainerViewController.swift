//
//  InvoiceContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class InvoiceContainerViewController: BaseViewController {
    
    //MARK: IBOutlet
    
    @IBOutlet weak var tf_DueDate: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tf_FirstName: UITextField!
    @IBOutlet weak var tf_LastName: UITextField!
    @IBOutlet weak var tf_Phone: UITextField!
    @IBOutlet weak var tf_Notes: UITextField!
    @IBOutlet weak var tf_Rep: UITextField!
    @IBOutlet weak var tf_Terms: UITextField!
    @IBOutlet weak var tf_PONumber: UITextField!
    @IBOutlet weak var tf_InvoiceTitle: UITextField!
    @IBOutlet weak var tf_Zip: UITextField!
    @IBOutlet weak var tf_City: UITextField!
    @IBOutlet weak var tf_Region: UITextField!
    @IBOutlet weak var tf_Country: UITextField!
    @IBOutlet weak var tf_AddressSecond: UITextField!
    @IBOutlet weak var tf_Address: UITextField!
    @IBOutlet weak var tf_Company: UITextField!
    @IBOutlet weak var tf_InvoiceDate: UITextField!
    @IBOutlet weak var tf_MM: UITextField!
    @IBOutlet weak var tf_YYYY: UITextField!
    @IBOutlet weak var tf_CreditCard: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var countryStackView: UIStackView!
    @IBOutlet weak var btnAddCustomer: UIButton!
    
    @IBOutlet weak var tf_selectTamplate: UITextField!
    //MARK: Variables
    var myPickerView: UIPickerView!
    var repID = String()
    var termsText = String()
    var isNotificationFired = Bool()
    var array_RepresentativesList = [RepresentativesListForInvoiceModel]()
    var dummyCardNumber = String()
    var ACCEPTABLE_CHARACTERS = "0123456789"
    var invoiceEmail = String()
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var MM_Array = [String]()
    var isMM = Bool()
    var YY_Array = [String]()
    var selectedYear = String()
    var customerObj = CustomerListModel()
    var TermsArray = Array<Any>()
    var productSettingObj = ProductSettingTerms()
    var productSettingObjData = [ProductSettingTerms]()
    var versionOb = Int()
    var total = Double()
    
    var strMonth = ""
    var strYear = ""
    var strDateInvoice = ""
    var strSelectTemplateName = ""
    var strSelectTemplateID = ""
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            MultiCardContainerViewController.isClassLoaded = false
        }
        
        //Update Previous Data If Available
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key.lowercased() == "invoice" {
            if let data = PaymentsViewController.paymentDetailDict["data"] as? JSONDictionary {
                
                let objterm  = data["terms"] as? String ?? ""
                if let cartProductsArray = DataManager.productTermsData {
                    for i in  0..<cartProductsArray.count {
                        if let dict = cartProductsArray[i] as? JSONDictionary {
                            let text = dict["text"] as? String
                            let id = dict["id"] as? String
                            if objterm == id {
                                tf_Terms.text = text
                            }
                        }
                    }
                }
                
                emailTextField.text = data["email"] as? String ?? ""
                tf_FirstName.text = data["first_name"] as? String ?? ""
                repID = data["rep"] as? String ?? ""
                tf_PONumber.text = data["ponumber"] as? String ?? ""
                tf_Notes.text = data["notesInvoice"] as? String ?? ""
                tf_InvoiceDate.text = data["invoiceDate"] as? String ?? ""
                tf_InvoiceTitle.text = data["invoiceTitle"] as? String ?? ""
                tf_DueDate.text = data["duedate"] as? String ?? ""
                tf_CreditCard.text = data["cardNumber"] as? String ?? ""
                tf_MM.text = data["MM"] as? String ?? ""
                tf_YYYY.text = data["YYYY"] as? String ?? ""
                selectedYear = tf_YYYY.text ?? ""
                customerObj = data["customerObj"] as? CustomerListModel ?? CustomerListModel()
                callValidateToChangeColor()
            }
        }
        //Fill Detail
        self.fillCustomerDetail()
        //Set Border
        DispatchQueue.main.async {
            self.setBorder()
        }
        emailTextField.addTarget(self, action: #selector(handleEmailTextField(sender:)), for: .editingChanged)
        tf_FirstName.addTarget(self, action: #selector(handleFirstNameTextField(sender:)), for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        versionOb = Int(DataManager.appVersion)!
        self.customizeUI()
        //        self.setCrossButton()
        self.upadateMonthArray()
        if tf_DueDate.text == "" {
            tf_DueDate.text = Date.getCurrentDate()
            
        }
        if tf_InvoiceDate.text == ""{
            tf_InvoiceDate.text = Date.getCurrentDate()
        }
            
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        callValidateToChangeColor()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        emailTextField.updateCustomBorder()
        tf_Notes.updateCustomBorder()
        tf_Region.updateCustomBorder()
        self.setBorder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleEmailTextField(sender: UITextField) {
        
        callValidateToChangeColor()
    }
    
    @objc func handleFirstNameTextField(sender: UITextField) {
        
        callValidateToChangeColor()
    }
    
    //MARK: Private Functions
    private func upadateMonthArray() {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        YY_Array.removeAll()
        MM_Array.removeAll()
        
        if selectedYear == "\(year)" {
            for i in (month..<13) {
                MM_Array.append(String(format: "%02d", i))
            }
        }else {
            MM_Array = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        }
        
        for i in (year..<2050) {
            YY_Array.append("\(i)")
        }
    }
    
    private func fillCustomerDetail() {
        //self.emailTextField.text = repID != "" ? self.emailTextField.text : invoiceEmail
        
        self.emailTextField.text = self.customerObj.str_email
        self.tf_Company.text = self.customerObj.str_company
        self.tf_FirstName.text = self.customerObj.str_billing_first_name
        self.tf_LastName.text = self.customerObj.str_billing_last_name
        self.tf_Phone.text = formattedPhoneNumber(number: self.customerObj.str_Billingphone)
        self.tf_Address.text = self.customerObj.str_Billingaddress
        self.tf_AddressSecond.text = self.customerObj.str_Billingaddress2
        self.tf_Country.text = self.customerObj.billingCountry
        self.tf_Region.text = self.customerObj.str_Billingregion
        self.tf_City.text = self.customerObj.str_Billingcity
        self.tf_Zip.text = formattedZIPCodeNumber(number: self.customerObj.str_Billingpostal_code)
        if let val = self.customerObj.cardDetail?.cardNumber {
            self.tf_CreditCard.text =  val
        } else {
            self.tf_CreditCard.text = ""
        }
        self.tf_MM.text = self.customerObj.cardDetail?.month
        self.tf_YYYY.text = self.customerObj.cardDetail?.year
        
        if let dict = UserDefaults.standard.value(forKey: "SelectedCustomer") as? NSDictionary {
            let cardDetail = decode(dict: dict as! [String : Any])
            var number = cardDetail.cardNumber ?? ""
            if number.count == 4 {
                number = "************" + number
            }
            tf_CreditCard.text = number
            tf_MM.text = cardDetail.month
            tf_YYYY.text = cardDetail.year
        }
        
        self.tf_Country.text = self.tf_Country.isEmpty ? DataManager.selectedCountry : self.tf_Country.text
        if DataManager.customerObj != nil{
            //btnAddCustomer.setTitle("Edit Customer", for: .normal)
           // btnAddCustomer.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            if  self.customerObj.str_first_name != "" || self.customerObj.str_email != "" {
                btnAddCustomer.isHidden = true
            }else{
                btnAddCustomer.isHidden = false
            }
        }else{
            btnAddCustomer.setTitle("Add Customer", for: .normal)
            btnAddCustomer.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
            btnAddCustomer.isHidden = false
        }
    }
    
    private func updateCustomerDetail() {
        self.customerObj.company = self.tf_Company.text ?? ""
        
        self.customerObj.str_billing_first_name = self.tf_FirstName.text ?? ""
        self.customerObj.str_billing_last_name = self.tf_LastName.text ?? ""
        self.customerObj.str_Billingemail = self.emailTextField.text ?? ""
        self.customerObj.str_Billingphone = phoneNumberFormateRemoveText(number: self.tf_Phone.text!)
        self.customerObj.str_Billingaddress = self.tf_Address.text ?? ""
        self.customerObj.str_Billingaddress2 = self.tf_AddressSecond.text ?? ""
        self.customerObj.billingCountry = self.tf_Country.text ?? ""
        self.customerObj.str_Billingregion = self.tf_Region.text ?? ""
        self.customerObj.str_Billingcity = self.tf_City.text ?? ""
        self.customerObj.str_Billingpostal_code = self.tf_Zip.text?.replacingOccurrences(of: "-", with: "") ?? ""
        self.customerObj.str_company = self.tf_Company.text ?? ""
        
        self.customerObj.str_first_name = self.tf_FirstName.text ?? ""
        self.customerObj.str_last_name = self.tf_LastName.text ?? ""
        self.customerObj.str_email = self.emailTextField.text ?? ""
        self.customerObj.str_phone = phoneNumberFormateRemoveText(number: self.tf_Phone.text!)
        self.customerObj.str_address = self.tf_Address.text ?? ""
        self.customerObj.str_address2 = self.tf_AddressSecond.text ?? ""
        self.customerObj.country = self.tf_Country.text ?? ""
        self.customerObj.str_region = self.tf_Region.text ?? ""
        self.customerObj.str_city = self.tf_City.text ?? ""
        self.customerObj.str_postal_code = self.tf_Zip.text?.replacingOccurrences(of: "-", with: "") ?? ""
        
        self.customerObj.cardDetail?.cardNumber = self.tf_CreditCard.text ?? ""
        self.customerObj.cardDetail?.month = self.tf_MM.text ?? ""
        self.customerObj.cardDetail?.year = self.tf_YYYY.text ?? ""
        
        if !tf_Company.isEmpty || !emailTextField.isEmpty || !tf_FirstName.isEmpty || !tf_LastName.isEmpty || !tf_Phone.isEmpty || !tf_Address.isEmpty || !tf_AddressSecond.isEmpty || !(tf_Country.text == DataManager.selectedCountry) || !tf_Region.isEmpty || !tf_City.isEmpty || !tf_Zip.isEmpty {
            self.customerObj.isDataAdded = true
        }else {
            self.customerObj.billingCountry = ""
            self.customerObj.country = ""
        }
    }
    
    private func customizeUI() {
        //if DataManager.productTermsData?.count != 0{
          tf_Terms.setDropDown()
       // }
        
        //Set DropDown
        tf_Rep.setDropDown()
        //tf_InvoiceDate.setDropDown()
        tf_MM.setDropDown()
        tf_YYYY.setDropDown()
        tf_Region.setDropDown()
        tf_Country.setDropDown()
        tf_selectTamplate.setDropDown()
        //Set Placeholder
        emailTextField.setPlaceholder()
        tf_FirstName.setPlaceholder()
        tf_LastName.setPlaceholder()
        tf_Phone.setPlaceholder()
        tf_Company.setPlaceholder()
        tf_Address.setPlaceholder()
        tf_AddressSecond.setPlaceholder()
        tf_Country.setPlaceholder()
        tf_Region.setPlaceholder()
        tf_City.setPlaceholder()
        tf_Zip.setPlaceholder()
        tf_Notes.setPlaceholder()
        tf_Rep.setPlaceholder()
        tf_DueDate.setPlaceholder()
        tf_Terms.setPlaceholder()
        tf_PONumber.setPlaceholder()
        tf_InvoiceTitle.setPlaceholder()
        tf_InvoiceDate.setPlaceholder()
        tf_CreditCard.setPlaceholder()
        tf_YYYY.setPlaceholder()
        tf_MM.setPlaceholder()
        tf_CreditCard.tintColor = UIColor.blue
        tf_CreditCard.keyboardType = .numberPad
        self.tf_Rep.tintColor = UIColor.clear
        
        //       self.tf_Country.isHidden = !DataManager.isShowCountry
        //        self.countryStackView.isHidden = !DataManager.isShowCountry
        
        if DataManager.posInvoicePoNumber == "true"{
            tf_PONumber.isHidden = false
        }else{
            tf_PONumber.isHidden = true
        }
        if DataManager.posInvoiceRep == "true"{
            tf_Rep.isHidden = false
        }else{
            tf_Rep.isHidden = true
        }
        if DataManager.posInvoiceDate == "true"{
            tf_InvoiceDate.isHidden = false
        }else{
            tf_InvoiceDate.isHidden = true
        }
        if DataManager.posInvoiceTerms == "true"{
            tf_Terms.isHidden = false
        }else{
            tf_Terms.isHidden = true
        }
        if DataManager.posInvoiceTitle == "true"{
            
            tf_InvoiceTitle.isHidden = false
        }else{
            tf_InvoiceTitle.isHidden = true
        }
        if DataManager.posInvoiceCountry == "true" && DataManager.isShowCountry{
            tf_Country.isHidden = false
            self.countryStackView.isHidden = false
        }else{
            tf_Country.isHidden = true
            self.countryStackView.isHidden = true
        }
        
        if versionOb < 4 {
            tf_DueDate.isHidden = true
        }else{
            tf_DueDate.isHidden = false
        }
        
    }
    
    private func setBorder() {
        emailTextField.setBorder()
        tf_FirstName.setBorder()
        tf_LastName.setBorder()
        tf_Phone.setBorder()
        tf_Company.setBorder()
        tf_Address.setBorder()
        tf_AddressSecond.setBorder()
        tf_Country.setBorder()
        tf_Region.setBorder()
        tf_City.setBorder()
        tf_Zip.setBorder()
        tf_Notes.setBorder()
        tf_Rep.setBorder()
        tf_DueDate.setBorder()
        tf_Terms.setBorder()
        tf_PONumber.setBorder()
        tf_InvoiceTitle.setBorder()
        tf_InvoiceDate.setBorder()
        tf_CreditCard.setBorder()
        tf_YYYY.setBorder()
        tf_MM.setBorder()
    }
    
    private func setCrossButton() {
        tf_InvoiceDate.setCrossButton()
        emailTextField.setCrossButton()
        tf_FirstName.setCrossButton()
        tf_LastName.setCrossButton()
        tf_Phone.setCrossButton()
        tf_Company.setCrossButton()
        tf_Address.setCrossButton()
        tf_AddressSecond.setCrossButton()
        tf_City.setCrossButton()
        tf_DueDate.setCrossButton()
        tf_Zip.setCrossButton()
        tf_Notes.setCrossButton()
        tf_Terms.setCrossButton()
        tf_PONumber.setCrossButton()
        tf_InvoiceTitle.setCrossButton()
        tf_CreditCard.setCrossButton()
    }
    
    //MARK: IBActions
    
    @IBAction func tf_Terms(_ sender: Any) {
//        TermsArray.removeAll()
//        productSettingObjData.removeAll()
//        if let cartProductsArray = DataManager.productTermsData {
//            for i in  0..<cartProductsArray.count {
//                if let dict = cartProductsArray[i] as? JSONDictionary {
//                    let text = dict["text"] as? String
//                    let id = dict["id"] as? String
//                    productSettingObj.id = id ?? ""
//                    productSettingObj.text = text ?? ""
//                    TermsArray.append(text)
//                    productSettingObjData.append(productSettingObj)
//                }
//            }
//            self.pickerDelegate = self
//            var obj = productSettingObjData.compactMap({$0.text})
//            if obj.count > 0{
//                self.pickerDelegate = self
//                self.setPickerView(textField: tf_Terms, array: obj)
//            }
//
//        }
        self.pickerDelegate = self
        let obj = productSettingObjData.compactMap({$0.text})
        if obj.count > 0{
            self.pickerDelegate = self
            self.setPickerView(textField: tf_Terms, array: obj)
        }
    }
    
    @IBAction func tf_RepAction(_ sender: Any)
    {
        let array = array_RepresentativesList.compactMap({$0.display_name})
        if array.count > 0 {
            self.pickerDelegate = self
            self.setPickerView(textField: tf_Rep, array: array)
        }else {
            tf_Rep.resignFirstResponder()
            self.callAPItoGetRepresentativesList(isTextField: true)
        }
    }
    
    @IBAction func tf_MMAction(_ sender: Any) {
        self.upadateMonthArray()
        self.pickerDelegate = self
        self.setPickerView(textField: tf_MM, array: MM_Array)
    }
    
    @IBAction func tf_YYYYAction(_ sender: Any) {
        self.pickerDelegate = self
        self.setPickerView(textField: tf_YYYY, array: YY_Array)
    }
    @IBAction func btnAddCustomer_action(_ sender: Any) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            delegate?.showCustomerViewfromInvoice?()
        } else {
            DataManager.isPaymentBtnAddCustomer = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "SelectCustomerViewController") as! SelectCustomerViewController
//            secondVC.isNewUser = true
//            secondVC.isPhoneInvoice = true
            secondVC.delegate = self
            self.present(secondVC, animated: true, completion: nil)
        }
    }
    
    func callValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if (emailTextField.text != "" && !(emailTextField.isValidEmail())) && tf_FirstName.text != "" {
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "INVOICE")
            } else if (emailTextField.text != "" && emailTextField.isValidEmail())  {
                delegate?.checkPayButtonColorChange?(isCheck: true, text: "INVOICE")
            }else if tf_FirstName.text != "" {
                delegate?.checkPayButtonColorChange?(isCheck: true, text: "INVOICE")
            }else{
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "INVOICE")
            }
        }else{
            if (emailTextField.text != "" && !(emailTextField.isValidEmail())) && tf_FirstName.text != "" {
                delegate?.checkIphonePayButtonColorChange?(isCheck: false , text: "INVOICE")
            } else if (emailTextField.text != "" && emailTextField.isValidEmail())  {
                delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "INVOICE")
            }else if tf_FirstName.text != "" {
                delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "INVOICE")
            }else{
                delegate?.checkIphonePayButtonColorChange?(isCheck: false , text: "INVOICE")
            }
        }
    }
    
    func disableValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if emailTextField.text != ""  || tf_FirstName.text != "" {
                delegate?.checkPayButtonColorChange?(isCheck: true, text: "INVOICE")
            }else{
                if emailTextField.text == ""  || tf_FirstName.text == "" {
                    delegate?.checkPayButtonColorChange?(isCheck: false, text: "INVOICE")
                }
            }
        }else{
            if emailTextField.text != ""  || tf_FirstName.text != "" {
                delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "INVOICE")
            }else{
                if emailTextField.text == ""  || tf_FirstName.text == "" {
                    delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "INVOICE")
                }
            }
        }
        
    }
    // 08 nov 220 for invoice template by altab
    func changeInvoiceTemplate(){
        for ar in HomeVM.shared.objInvoiceTemplateModel.aryTemplatesSettings {
            if ar.template_name == strSelectTemplateName {
                tf_PONumber.isHidden = ar.settings.show_po_number_setting == "true" ? false : true
                strSelectTemplateID = ar.id
                tf_InvoiceDate.isHidden = ar.settings.show_invoice_date_setting == "true" ? false : true
                tf_Rep.isHidden = ar.settings.show_representative_setting == "true" ? false : true
                tf_Terms.isHidden = ar.settings.show_payment_terms_setting == "true" ? false : true
                tf_InvoiceTitle.isHidden = ar.settings.show_invoice_title_setting == "true" ? false : true
                productSettingObjData = ar.settings.payment_terms_values
                if self.productSettingObjData.count == 0 {
                    self.tf_Terms.isHidden = true
                }
                setBorder()
                break
            }
           
        }
        if HomeVM.shared.objInvoiceTemplateModel.aryTemplatesSettings.count > 1 {
            tf_selectTamplate.isHidden = false
        }else{
            tf_selectTamplate.isHidden = true
            if HomeVM.shared.objInvoiceTemplateModel.aryTemplatesSettings.count == 0 {
                if self.productSettingObjData.count == 0 {
                    self.tf_Terms.isHidden = true
                }
            }
        }
        setBorder()
    }
}

//MARK: PaymentTypeDelegate
extension InvoiceContainerViewController: PaymentTypeDelegate {
    func didUpdateCustomer(data: CustomerListModel) {
        self.customerObj = data
        self.fillCustomerDetail()
    }
    
    func didUpdateTotal(amount: Double , subToal : Double) {
        total = amount
        callValidateToChangeColor()
    }
    
    func sendInvoiceData(isSaveInvoice: Bool, isIPad: Bool) {
        self.updateCustomerDetail()
        
        if DataManager.productTermsData?.count == 0 {
            termsText = tf_Terms.text ?? ""
        }
        
        let Obj: JSONDictionary = ["customerObj": self.customerObj ,"first_name": tf_FirstName.text ?? "", "email": emailTextField.text ?? "","notesInvoice":tf_Notes.text ?? "", "rep":repID, "duedate":tf_DueDate.text ?? "", "terms":termsText, "ponumber":tf_PONumber.text ?? "","invoiceDate": tf_InvoiceDate.text ?? "", "invoiceTitle": tf_InvoiceTitle.text ?? "", "cardNumber": tf_CreditCard.text!, "MM": tf_MM.text ?? "", "YYYY": tf_YYYY.text ?? "", "isSaveInvoice": isSaveInvoice, "total":total ,"spliteAmount":total.description,"title": tf_InvoiceTitle.text ?? "","invoiceTemplateId":strSelectTemplateID]
        delegate?.getPaymentData?(with: Obj)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func enableCardReader() {
        delegate?.disableCardReaders?()
        SwipeAndSearchVC.delegate = nil
        SwipeAndSearchVC.delegate = self
        //        SwipeAndSearchVC.shared.enableTextField()
    }
    
    func updateError(textfieldIndex: Int, message: String) {
        switch textfieldIndex {
        case 1:
            appDelegate.showToast(message: "Please select customer.")
            emailTextField.setCustomError(text: message, bottomSpace: 2)
            break
        case 2:
            tf_Notes.setCustomError(text: message, bottomSpace: 2)
            break
        default: break
        }
    }
    
    
    func loadClassData() {
        self.callAPItoGetRepresentativesList()
        if strSelectTemplateName == "" { // 08 nov 220 for invoice template by altab
            callAPIToGetInvoiceTemplate()
        }else{
            changeInvoiceTemplate()
        }
        if DataManager.customerObj != nil{
            fillCustomerDetail()
        }
    }
    
    func saveData() {
        self.view.endEditing(true)
        self.updateCustomerDetail()
        let data : JSONDictionary = ["email": emailTextField.text ?? "","first_name": tf_FirstName.text ?? "","notesInvoice":tf_Notes.text ?? "", "rep":repID, "duedate":tf_DueDate.text ?? "", "terms":termsText, "ponumber":tf_PONumber.text ?? "", "invoiceDate": tf_InvoiceDate.text ?? "","invoiceDueDate": tf_DueDate.text ?? "", "cardNumber": tf_CreditCard.text!, "MM": tf_MM.text ?? "", "YYYY": tf_YYYY.text ?? "", "invoiceTitle": tf_InvoiceTitle.text ?? "", "customerObj": self.customerObj]
        PaymentsViewController.paymentDetailDict["data"] = data
    }
    
    func reset() {
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            emailTextField.text = ""
            tf_PONumber.text = ""
            tf_Terms.text = ""
            tf_Notes.text = ""
            tf_FirstName.text = ""
            tf_LastName.text = ""
            tf_Phone.text = ""
            tf_Company.text = ""
            tf_Address.text = ""
            tf_AddressSecond.text = ""
            tf_Country.text = ""
            tf_Region.text = ""
            tf_City.text = ""
            tf_Zip.text = ""
            tf_CreditCard.text = ""
            tf_MM.text = ""
            tf_YYYY.text = ""
            tf_DueDate.text = ""
        }
        self.tf_Country.text = self.tf_Country.isEmpty ? DataManager.selectedCountry : self.tf_Country.text
        
        emailTextField.resetCustomError(isAddAgain: true)
        tf_Notes.resetCustomError(isAddAgain: true)
        tf_Region.resetCustomError(isAddAgain: true)
        
        if self.customerObj.str_email == "" {
            emailTextField.text = ""
        }
        if self.customerObj.str_first_name == "" || self.customerObj.str_billing_first_name == ""{
            tf_FirstName.text = ""
        }
        
        if let index = self.array_RepresentativesList.index(where: {(Int($0.id) ?? -1) == (Int(DataManager.userID) ?? -2)}) {
            self.tf_Rep.text = self.array_RepresentativesList[index].display_name
            self.repID = "\(self.array_RepresentativesList[index].id)"
        }
        disableValidateToChangeColor()
    }
    
}
//MARK: UITextFieldDelegate
extension InvoiceContainerViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.hideAssistantBar()
        
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        
        self.dummyCardNumber = ""
        
        if textField == tf_InvoiceDate {
            self.pickerDelegate = self
            
            let date = Date()
            let calendar = Calendar.current
            
            //self.setDatePicker(textField: textField, datePickerMode: .date, maximunDate: nil, minimumDate: )
            self.setDatePicker(textField: textField, datePickerMode: .date, maximunDate: nil, minimumDate: Date())
        }
        if textField == tf_selectTamplate {
            
            self.showInvoiceTamplate(self, sourceView: tf_selectTamplate, contactSource: "") { text, index in
                self.tf_selectTamplate.text = text
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    if self.strSelectTemplateName != self.tf_selectTamplate.text {
                    
                        self.showAlert(title:"Confirm", message: "All data will lose if you change template. Are you still want to change template.", otherButtons: [kCancel:{ (_) in
                            //...
                         //self.view_bgPopup.isHidden = true
                            self.tf_selectTamplate.text = self.strSelectTemplateName
                        }], cancelTitle:"OK") { (_) in
                            self.strSelectTemplateName = self.tf_selectTamplate.text ?? ""
                            self.changeInvoiceTemplate()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                self.tf_PONumber.text = ""
                                self.tf_InvoiceDate.text = Date.getCurrentDate()
                                self.tf_Terms.text = ""
                                self.tf_InvoiceTitle.text = ""
                                self.termsText = ""
                                if self.productSettingObjData.count == 0 {
                                    self.tf_Terms.isHidden = true
                                }
                            }
                        }
                    }else{
                        self.strSelectTemplateName = text
                    }
                }
                
            }
//            let array = HomeVM.shared.objInvoiceTemplateModel.aryTemplatesSettings.compactMap({$0.template_name})
//            if array.count > 0 {
//                self.pickerDelegate = self
//                self.setPickerView(textField: tf_selectTamplate, array: array)
//            }
        }
        if textField == tf_DueDate {
            self.pickerDelegate = self
            self.setDatePicker(textField: textField, datePickerMode: .date, maximunDate: nil, minimumDate: Date())
            strDateInvoice = textField.text ?? ""
            print(strDateInvoice)
        }
        
        if textField == tf_MM {
            if MM_Array.count > 0 {
                tf_MM?.text = "\(MM_Array[0])"
                strMonth = "\(MM_Array[0])"
            }
        }
        
        if textField == tf_YYYY {
            //tf_MM.text = ""
            if YY_Array.count > 0 {
                tf_YYYY?.text = "\(YY_Array[0])"
                selectedYear = "\(YY_Array[0])"
                strYear = "\(YY_Array[0])"
            }
        }
        
        if textField == tf_Region {
            textField.tintColor = UIColor.clear
            if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (tf_Country.text ?? "")}) {
                let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                    self.tf_Region.text = text
                }
            }else {
                textField.resignFirstResponder()
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                }
                //Offline
                if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
//                    self.showAlert(title: "Oops!", message: "Regions are not avalable in the offline mode!")
                    appDelegate.showToast(message: "Regions are not avalable in the offline mode!")
                    return
                }
                
                //Online
                textField.setCustomError(text: "Please select country.",bottomSpace: 2)
            }
        }
        
        if textField == tf_Country {
            textField.tintColor = UIColor.clear
            self.tf_Region.text = ""
            self.showCustomTableView(self, sourceView: textField, countryName: "") { (text) in
                textField.text = text
            }
        }
        
        if textField == emailTextField || textField == tf_FirstName {
            emailTextField.resetCustomError(isAddAgain: true)
            setBorder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = true
            IQKeyboardManager.shared.enable = true
            textField.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Handle Swipe Reader Data
        if textField == tf_CreditCard  {
            let isSingleBeepSwiper = String(describing: dummyCardNumber.prefix(1)) == ";"
            
            if (String(describing: dummyCardNumber.prefix(2)) != "%B" && !isSingleBeepSwiper) || (String(describing: dummyCardNumber.prefix(1)) != ";" && isSingleBeepSwiper) {
                self.tf_CreditCard.tintColor = UIColor.blue
                self.dummyCardNumber = ""
                textField.resignFirstResponder()
                return true
            }
            
            let cardNumberArray = dummyCardNumber.split(separator: isSingleBeepSwiper ? "=" : "^")
            if isSingleBeepSwiper ? cardNumberArray.count > 1 : cardNumberArray.count > 2 {
                let number = String(describing: String(describing: cardNumberArray.first ?? "").dropFirst(isSingleBeepSwiper ? 1 : 2))
                let month = String(describing: String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(4)).dropFirst(2))
                let year = String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(2))
                
                tf_CreditCard.resetCustomError(isAddAgain: true)
                tf_CreditCard.text = number
                tf_MM.text = month
                tf_YYYY.text = "20" + year
            }else {
                if tf_CreditCard.isEmpty {
                    tf_CreditCard.setCustomError(bottomSpace: 1.5)
                }
            }
        }
        self.tf_CreditCard.tintColor = UIColor.blue
        self.dummyCardNumber = ""
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        
        if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }
        
        //Handle Swipe Reader Data
        dummyCardNumber.append(string)
        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            textField.tintColor = UIColor.clear
            return false
        }
        dummyCardNumber = ""
        
        if textField == self.tf_CreditCard {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string == filtered {
                if textField == tf_CreditCard {
                    
                    //                    let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                    //                    textField.text = newString
                    //                    return false
                    return charactersCount < 17
                }
            }else {
                return false
            }
        }
        
        if textField == emailTextField {
            if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
                return false
            }
            return true
        }
        
        if textField == tf_Phone {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedPhoneNumber(number: newString)
            return false
        }
        
        if textField == tf_PONumber {
            let cs = CharacterSet.alphanumerics.inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            return string == filtered
        }
        
        if textField == tf_Zip {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedZIPCodeNumber(number: newString)
            return false
        }
        
        if textField == tf_Phone || textField == tf_Zip || textField == tf_CreditCard {
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            return string == filtered
        }
        
        if textField == tf_Terms {
            let cs = CharacterSet.alphanumerics.inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 75 {
                return false
            }
            
            if string == " " && textField.text != "" {
                return true
            }
            return string == filtered
        }
        
        if textField == tf_Address || textField == tf_AddressSecond || textField == tf_Notes {
            if string == "" {
                return true
            }
            return charactersCount < 200
        }
        
        if charactersCount > 25 {
            return false
        }
        callValidateToChangeColor()
        //        let cs = CharacterSet.letters.inverted
        //        let filtered = string.components(separatedBy: cs).joined(separator: "")
        //        if charactersCount > 75 {
        //            return false
        //        }
        //
        //        if string == " " && textField.text != "" {
        //            return true
        //        }
        //        return string == filtered
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        disableValidateToChangeColor()
        textField.resignFirstResponder()
        return false
    }
}

//MARK: HieCORPickerDelegate
extension InvoiceContainerViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        if pickerTextfield == tf_Rep {
            pickerTextfield.text = "\(self.array_RepresentativesList[index].display_name)"
            repID = "\(self.array_RepresentativesList[index].id)"
        }
        
        
        if pickerTextfield == tf_Terms {
            pickerTextfield.text = "\(self.productSettingObjData[index].text)"
            termsText = "\(self.productSettingObjData[index].id)"
           // tf_Terms.setCrossButton()
        }
        
        
        
        if pickerTextfield == tf_MM {
            //tf_MM?.text = "\(MM_Array[index])"
            strMonth = "\(MM_Array[index])"
        }
        
        if pickerTextfield == tf_YYYY {
            //tf_YYYY?.text = "\(YY_Array[index])"
            selectedYear = "\(YY_Array[index])"
            strYear = "\(YY_Array[index])"
        }
    }
    
    override func pickerViewCancelAction() {
        if pickerTextfield == tf_Rep {
            repID = ""
            tf_Rep.text = ""
        }
        
        if pickerTextfield == tf_Terms {
            termsText = ""
            tf_Terms.text = ""
        }
        
        if pickerTextfield == tf_DueDate {
            tf_DueDate.text = ""
        }
        
        if pickerTextfield == tf_MM {
            tf_MM?.text = strMonth
        }
        
        if pickerTextfield == tf_YYYY {
            
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            
            
            if strYear == "\(year)" {
                
                let month = calendar.component(.month, from: date)
                
                if strMonth != "" {
                    if month > Int(strMonth)! {
                        tf_MM.text = ""
                    }
                }
                
                
                
            }
            
            tf_YYYY?.text = strYear
            selectedYear = strYear
        }
        
        pickerTextfield.text = ""
        pickerTextfield.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func pickerViewDoneAction() {
        
        if pickerTextfield == tf_MM {
            tf_MM?.text = strMonth
        }
        else {
            
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            
            
            if strYear == "\(year)" {
                
                let month = calendar.component(.month, from: date)
                
                //                if month > Int(strMonth)! {
                //                    tf_MM.text = ""
                //                }
                if strMonth != "" {
                    if month > Int(strMonth)! {
                        tf_MM.text = ""
                    }
                }
                
            }
            
            tf_YYYY?.text = strYear
            selectedYear = strYear
        }
        
        pickerTextfield.resignFirstResponder()
        self.view.endEditing(true)
    }
}


//MARK: API Methods
extension InvoiceContainerViewController {
    func callAPItoGetRepresentativesList(isTextField: Bool? = false) {
        HomeVM.shared.getRepresentativesList { (success, message, error) in
            if success == 1 {
                self.array_RepresentativesList = HomeVM.shared.representativesList
                if self.repID != "" {
                    if let index = self.array_RepresentativesList.index(where: {(Int($0.id) ?? -1) == (Int(self.repID) ?? -2)}) {
                        self.tf_Rep.text = self.array_RepresentativesList[index].display_name
                        self.repID = "\(self.array_RepresentativesList[index].id)"
                    }
                }else {
                    if let index = self.array_RepresentativesList.index(where: {(Int($0.id) ?? -1) == (Int(DataManager.userID) ?? -2)}) {
                        self.tf_Rep.text = self.array_RepresentativesList[index].display_name
                        self.repID = "\(self.array_RepresentativesList[index].id)"
                    }
                }
                if isTextField! {
                    self.tf_Rep.becomeFirstResponder()
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
    func callAPIToGetInvoiceTemplate(){
        HomeVM.shared.getInvoiceTemplatesListApi { (success, message, error) in
            if success == 1 {
                print(HomeVM.shared.objInvoiceTemplateModel)
               // self.strSelectTemplate = HomeVM.shared.objInvoiceTemplateModel.
                for ary in HomeVM.shared.objInvoiceTemplateModel.aryTemplatesSettings {
                    if ary.id == HomeVM.shared.objInvoiceTemplateModel.defaultID {
                        self.tf_selectTamplate.text = ary.template_name
                        self.strSelectTemplateName =  ary.template_name
                        self.strSelectTemplateID = HomeVM.shared.objInvoiceTemplateModel.defaultID
                    }
                }
                self.changeInvoiceTemplate()
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
                self.changeInvoiceTemplate()
            }
        }
    }
}

//MARK: SwipeReaderVCVCDelegate
extension InvoiceContainerViewController: SwipeAndSearchDelegate {
    func didGetCardDetail(number: String, month: String, year: String) {
        tf_CreditCard.resetCustomError(isAddAgain: true)
        tf_CreditCard.text = number
        tf_MM.text = month
        tf_YYYY.text = year
        callValidateToChangeColor()
    }
    
    func noCardDetailFound() {
        tf_CreditCard.setCustomError(bottomSpace: 1.5)
    }
    
    func didUpdateDevice() {
        tf_CreditCard.resetCustomError(isAddAgain: true)
    }
    
}
extension InvoiceContainerViewController: AddNewCutomerViewControllerDelegate {
    func didAddNewCustomer(data: CustomerListModel) {
        customerObj = data
        fillCustomerDetail()
    }
    
    
}
//MARK: SelectedCutomerDelegate
extension InvoiceContainerViewController: SelectedCutomerDelegate {
    func selectedCustomerData(customerdata: CustomerListModel)
    {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return
        }
        
        customerObj = customerdata
        fillCustomerDetail()
        //        saveCustomerData()
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

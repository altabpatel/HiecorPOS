//
//  AddNewCutomerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 05/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//
import UIKit
import Alamofire

class AddNewCutomerViewController: BaseViewController,ClassShipEditAddressDelegate {
    
    //MARK: IBOulets
    
    @IBOutlet weak var btnShippingSelectAddress: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet var tf_Zip: UITextField!
    @IBOutlet var tf_State: UITextField!
    @IBOutlet var tf_City: UITextField!
    @IBOutlet var tf_Address2: UITextField!
    @IBOutlet var tf_Address: UITextField!
    @IBOutlet var tf_PhoneNumber: UITextField!
    @IBOutlet var tf_Email: UITextField!
    @IBOutlet var tf_LastName: UITextField!
    @IBOutlet var tf_FirstName: UITextField!
    @IBOutlet var billingView: UIView!
    @IBOutlet var shippingView: UIView!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet weak var tf_Country: UITextField!
    
    @IBOutlet weak var tf_CustomText1: UITextField!
    @IBOutlet weak var tf_CustomText2: UITextField!
    
    @IBOutlet weak var stateBackVeiw: UIView!
    @IBOutlet weak var btn_ShippingSameAsBilling: UIButton!
    @IBOutlet var tf_FirstNameShipping: UITextField!
    @IBOutlet var tf_LastNameShipping: UITextField!
    @IBOutlet var tf_EmailShipping: UITextField!
    @IBOutlet var tf_PhoneNumberShipping: UITextField!
    @IBOutlet var tf_CompanyShipping: UITextField!
    @IBOutlet var tf_AddressShipping: UITextField!
    @IBOutlet var tf_Address2Shipping: UITextField!
    @IBOutlet var tf_CityShipping: UITextField!
    @IBOutlet var tf_StateShipping: UITextField!
    @IBOutlet var tf_ZipShipping: UITextField!
    @IBOutlet var tf_CountryShipping: UITextField!
    @IBOutlet var stateBackViewShipping: UIView!
    @IBOutlet var customerAddressErrorView: UIView!
    @IBOutlet weak var tf_ContactSource: UITextField!
    @IBOutlet weak var tf_SelectCustomerStatus: UITextField!
   // @IBOutlet weak var view_SourceList: UIView!
    @IBOutlet weak var tf_OfficePhone: UITextField!
   // @IBOutlet weak var tbl_SourceList: UITableView!
    
    //MARK: Variables
    var isNewUser = Bool()
    var selectedUser = CustomerListModel()
    var delegate : AddNewCutomerViewControllerDelegate?
    var customerDelegate: CustomerDelegates?
    let datePicker = UIDatePicker()
    var versionOb = Int()
    
    let checkString1 = DataManager.customText1Type ?? ""
    let checkString2 = DataManager.customText2Type ?? ""
    var isPhoneInvoice = false
    var isMutiShippingAdr = false
    //MARK: Class life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.versionOb = Int(DataManager.appVersion)!
        setDelegatesToSelf()
        customizeUI()
        customText1AndCustomText2View()
        loadData()
       // getSourcePhoneList()
    }

    
    @IBAction func errorLabelHideTFAction(_ sender: UITextField) {
        if versionOb < 4 {
            return
        }
        if !DataManager.isPaymentBtnAddCustomer {
            return
        }
        if DataManager.isshipOrderButton {
            callvalidationforBilling()
            if  DataManager.isPaymentBtnAddCustomer {
                 if DataManager.isCheckUncheckShippingBilling {
                    if sender.text == "" {
                        customerAddressErrorView.isHidden = false
                    }else{
                        if tf_City.text == "" || tf_State.text == "" || tf_Zip.text == "" {
                            if  tf_Address.text != "" || tf_Address2.text != ""{
                                customerAddressErrorView.isHidden = false
                            }else{
                                customerAddressErrorView.isHidden = true
                            }
                            
                        }else{
                            customerAddressErrorView.isHidden = true
                        }
                    }
                 }else{
                    callValidationForShipping()
                    if sender.text == "" {
                        customerAddressErrorView.isHidden = false
                    }else{
                        if tf_CityShipping.text == "" || tf_StateShipping.text == "" || tf_ZipShipping.text == "" {
        
                            if tf_AddressShipping.text != "" || tf_Address2Shipping.text != "" {
                             customerAddressErrorView.isHidden = false
                            }else{
                               customerAddressErrorView.isHidden = true
                            }
                            
                        }else{
                            customerAddressErrorView.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.setBorder()
            if self.selectedUser.isUserCustSelected == true{
                self.selectedUser.isUserCustSelected = false
                self.SetForcellyCustData()
            }
        }
       
        DispatchQueue.main.async {
            if DataManager.isPaymentBtnAddCustomer {
                if DataManager.isCheckUncheckShippingBilling {
                    self.customerInformationErrorShowForBillingForPhone()
                } else {
                    self.customerInformationErrorShowForShippingForPhone()
                }
                
            }else{
                self.customerAddressErrorView.isHidden = true
            }
        }

        
        
//       if self.btn_ShippingSameAsBilling.isSelected{
//            self.shippingView.isHidden = true
//        }else{
//            self.shippingView.isHidden = false
//        }
        if selectedUser.str_billing_first_name == "" && selectedUser.str_email == "" {
            btnShippingSelectAddress.isHidden = true
            shippingView.isHidden = true
            DataManager.isCheckUncheckShippingBilling = true
            self.btn_ShippingSameAsBilling.isSelected = true

        }
         shippingView.isHidden = DataManager.isCheckUncheckShippingBilling
//        if !self.btn_ShippingSameAsBilling.isSelected {
            if !isNewUser{
                if DataManager.customerForShippingAddressId != ""{
                    if DataManager.shippingaddressCount > 1 && DataManager.showMultipleShippingPopup == "true"{
                        
                        btnShippingSelectAddress.isHidden = false
                        shippingView.isHidden = false
                        DataManager.isCheckUncheckShippingBilling = false
                        self.btn_ShippingSameAsBilling.isSelected = false
                    }else{
//                        btnShippingSelectAddress.isHidden = true
//                        shippingView.isHidden = true
//                        DataManager.isCheckUncheckShippingBilling = true
//                        self.btn_ShippingSameAsBilling.isSelected = true
                    }
                }
            }else{
                btnShippingSelectAddress.isHidden = true
                shippingView.isHidden = true
                DataManager.isCheckUncheckShippingBilling = true
                self.btn_ShippingSameAsBilling.isSelected = true
            }
//        }else{
//            btnShippingSelectAddress.isHidden = true
//        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //Set Border
        setBorder()
    }
    
    //MARK: Private Functions
    private func setDelegatesToSelf() {
        tf_FirstNameShipping.delegate = self
        tf_LastName.delegate = self
        tf_Email.delegate = self
        tf_PhoneNumber.delegate = self
        tf_Address.delegate = self
        tf_Address2.delegate = self 
        tf_City.delegate = self
        tf_State.delegate = self
        tf_Zip.delegate = self
        tf_Country.delegate = self
        tf_FirstNameShipping.delegate = self
        tf_LastNameShipping.delegate = self                
        tf_EmailShipping.delegate = self
        tf_PhoneNumberShipping.delegate = self
        tf_CompanyShipping.delegate = self
        tf_AddressShipping.delegate = self
        tf_Address2Shipping.delegate = self
        tf_CityShipping.delegate = self
        tf_StateShipping.delegate = self
        tf_ZipShipping.delegate = self
        tf_CountryShipping.delegate = self
        tf_CustomText1.delegate = self
        tf_CustomText2.delegate  = self
        tf_OfficePhone.delegate = self
        tf_ContactSource.delegate = self
    }
    
    private func customizeUI() {
        tf_Country.isHidden = !DataManager.isShowCountry
        tf_CountryShipping.isHidden = !DataManager.isShowCountry
        tf_State.hideAssistantBar()
        tf_State.setDropDown()
        tf_StateShipping.hideAssistantBar()
        tf_StateShipping.setDropDown()
        tf_Country.hideAssistantBar()
        tf_Country.setDropDown()
        tf_CountryShipping.hideAssistantBar()
        tf_CountryShipping.setDropDown()
        tf_SelectCustomerStatus.setDropDown()
        tf_ContactSource.setDropDown()
        UIApplication.shared.isStatusBarHidden = true
    }
    
    
   
  
    //for custom text view hide / show
    private func customText1AndCustomText2View() {
        if DataManager.customFieldShow {
            tf_CustomText1.isHidden = false
            tf_CustomText2.isHidden = false
            tf_CustomText1.placeholder = DataManager.customText1Label ?? ""
            tf_CustomText2.placeholder = DataManager.customText2Label ?? ""
            
            if DataManager.customText1Type == "date" {
                tf_CustomText1.setCalendarImage()
            }
            
            
            if DataManager.customText2Type == "date" {
                tf_CustomText2.setCalendarImage()
            }
        }else{
            tf_CustomText1.isHidden = true
            tf_CustomText2.isHidden = true
            
        }
    }
    
    
    private func setBorder() {
        tf_Email.setBorder()
        tf_PhoneNumber.setBorder()
        tf_Address.setBorder()
        tf_Address2.setBorder()
        tf_City.setBorder()
        tf_State.setBorder()
        tf_Zip.setBorder()
        tf_Country.setBorder()
        tf_EmailShipping.setBorder()
        tf_PhoneNumberShipping.setBorder()
        tf_CompanyShipping.setBorder()
        tf_AddressShipping.setBorder()
        tf_Address2Shipping.setBorder()
        tf_CityShipping.setBorder()
        tf_StateShipping.setBorder()
        tf_ZipShipping.setBorder()
        tf_CountryShipping.setBorder()
        tf_CustomText1.setBorder()
        tf_CustomText2.setBorder()
        tf_OfficePhone.setBorder()
        tf_ContactSource.setBorder()
    }
    
    private func loadData() {
        if selectedUser.str_billing_first_name != "" || selectedUser.str_email != "" || selectedUser.str_userID != ""{
            isNewUser = false
        }
        headerLabel.text = isNewUser ? "Add New Customer" : "Edit Customer"
        //Shipping
        tf_FirstNameShipping.text = selectedUser.str_shipping_first_name
        tf_LastNameShipping.text = selectedUser.str_shipping_last_name
        tf_EmailShipping.text = selectedUser.str_Shippingemail != "" ? selectedUser.str_Shippingemail : selectedUser.str_email
        let phone = selectedUser.str_Shippingphone != "" ? selectedUser.str_Shippingphone : selectedUser.str_phone
        tf_PhoneNumberShipping.text = formattedPhoneNumber(number: phone)
        tf_CompanyShipping.text = selectedUser.str_company
        tf_AddressShipping.text = selectedUser.str_Shippingaddress
        tf_Address2Shipping.text = selectedUser.str_Shippingaddress2
        tf_CityShipping.text = selectedUser.str_Shippingcity
        tf_StateShipping.text = isNewUser ? DataManager.posDropdownDefaultRegionState : selectedUser.str_Shippingregion
        tf_SelectCustomerStatus.text = selectedUser.str_customer_status
        //start anand
        tf_ContactSource.text = selectedUser.str_contact_source
        let officePhone = selectedUser.str_office_phone
        tf_OfficePhone.text = formattedPhoneNumber(number: officePhone)
        //end anand
        tf_ZipShipping.text = formattedZIPCodeNumber(number: selectedUser.str_Shippingpostal_code)
        tf_CountryShipping.text = selectedUser.shippingCountry
        //Billing
        tf_CustomText1.text = selectedUser.str_CustomText1
        tf_CustomText2.text = selectedUser.str_CustomText2
        tf_FirstName.text = selectedUser.str_billing_first_name
        tf_LastName.text = selectedUser.str_billing_last_name
        tf_Email.text = selectedUser.str_Billingemail
        tf_PhoneNumber.text = formattedPhoneNumber(number: selectedUser.str_Billingphone)
        tf_Address.text = selectedUser.str_Billingaddress
        tf_Address2.text = selectedUser.str_Billingaddress2
        tf_City.text = selectedUser.str_Billingcity
        tf_State.text = isNewUser ? DataManager.posDropdownDefaultRegionState : selectedUser.str_Billingregion
        tf_Zip.text = formattedZIPCodeNumber(number: selectedUser.str_Billingpostal_code)
        tf_Country.text = selectedUser.billingCountry
        if selectedUser.str_first_name.isEmpty && selectedUser.str_email.isEmpty {
            tf_SelectCustomerStatus.text = DataManager.customerStatusDefaultName
        }
        if selectedUser.str_userID == "" {
            self.tf_CountryShipping.text = self.tf_CountryShipping.isEmpty ? DataManager.selectedCountry : self.tf_CountryShipping.text
            self.tf_Country.text = self.tf_Country.isEmpty ? DataManager.selectedCountry : self.tf_Country.text
        }
        //DataManager.isCheckUncheckShippingBilling = true
        // self.btn_ShippingSameAsBilling.isSelected = true
        //shippingView.isHidden = DataManager.isCheckUncheckShippingBilling
        //        if !self.btn_ShippingSameAsBilling.isSelected {
        if !isNewUser{
            if DataManager.customerForShippingAddressId != ""{
                if DataManager.shippingaddressCount > 1 && DataManager.showMultipleShippingPopup == "true"{
                    DataManager.isCheckUncheckShippingBilling = false
                }
            }
        }
        if DataManager.isCheckUncheckShippingBilling == false {
            if DataManager.shippingaddressCount > 1 {
                btnShippingSelectAddress.isHidden = DataManager.isCheckUncheckShippingBilling
            }
        }
        btn_ShippingSameAsBilling.isSelected = DataManager.isCheckUncheckShippingBilling
        shippingView.isHidden = DataManager.isCheckUncheckShippingBilling
        tf_StateShipping.isHidden = DataManager.isCheckUncheckShippingBilling
        
        if selectedUser.isUserCustSelected  == true{
            if selectedUser.shippingaddressCount > 1 && DataManager.showMultipleShippingPopup == "true" {
                self.isMutiShippingAdr = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isMutiShippingAdr = false
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let secondVC = storyboard.instantiateViewController(withIdentifier: "SelectShippingAddressVc") as! SelectShippingAddressVc
                    secondVC.delegateShipIphone = self
                    secondVC.StrID = DataManager.customerForShippingAddressId
                    self.present(secondVC, animated: true, completion: nil)
                }
            }else{
                if selectedUser.shippingaddressCount > 1 && DataManager.showMultipleShippingPopup == "false" {
                    self.isMutiShippingAdr = true
                }else{
                    self.isMutiShippingAdr = false
                }
                
                self.presentingViewController?
                    .presentingViewController?.dismiss(animated: false, completion: nil)
            }
            
        }
        
        if tf_CompanyShipping.text == ""{
            updateError(textfieldIndex: 11, message: "Please enter Company Name.")
        }else{
            tf_CompanyShipping.resetCustomError()
        }
        if DataManager.showCustomerStatusAllInOne != "true" {
            tf_SelectCustomerStatus.isHidden = true
        }
        
        if DataManager.showContactSourceBoxAllInOne != "true" && DataManager.showOfficePhoneAllInOne != "true" {
            tf_OfficePhone.isHidden = true
        }
        if DataManager.showContactSourceBoxAllInOne != "true" {
            tf_ContactSource.isHidden = true
        }
        if DataManager.showOfficePhoneAllInOne != "true" {
            tf_OfficePhone.isHidden = true
        }
        
    }
    private func updateShippingAddress() {
        if !isNewUser {
            return
        }
        tf_FirstNameShipping.text = tf_FirstName.text
        tf_LastNameShipping.text = tf_LastName.text
        tf_EmailShipping.text = tf_Email.text
        tf_PhoneNumberShipping.text = tf_PhoneNumber.text
    }
    
    private func getNewData(customerList: CustomerListModel) -> CustomerListModel {
        let data = customerList
        //Shipping
        data.str_shipping_first_name = tf_FirstNameShipping.text ?? ""
        data.str_shipping_last_name = tf_LastNameShipping.text ?? ""
        data.str_Shippingemail = tf_EmailShipping.text ?? ""
        data.str_Shippingphone = phoneNumberFormateRemoveText(number: tf_PhoneNumberShipping.text!)
        data.str_company = tf_CompanyShipping.text ?? ""
        data.str_Shippingaddress = tf_AddressShipping.text ?? ""
        data.str_Shippingaddress2 = tf_Address2Shipping.text ?? ""
        data.str_Shippingcity = tf_CityShipping.text ?? ""
        data.str_Shippingregion = tf_StateShipping.text ?? ""
        data.str_Shippingpostal_code = tf_ZipShipping.text?.replacingOccurrences(of: "-", with: "") ?? ""
        data.shippingCountry = tf_CountryShipping.text ?? ""
        //Billing
        data.str_CustomText1 = tf_CustomText1.text ?? ""
        data.str_CustomText2 = tf_CustomText2.text ?? ""
        data.str_billing_first_name = tf_FirstName.text ?? ""
        data.str_billing_last_name = tf_LastName.text ?? ""
        data.str_Billingemail = tf_Email.text ?? ""
        data.str_Billingphone = phoneNumberFormateRemoveText(number: tf_PhoneNumber.text!)
        data.str_Billingaddress = tf_Address.text ?? ""
        data.str_Billingaddress2 = tf_Address2.text ?? ""
        data.str_Billingcity = tf_City.text ?? ""
        data.str_Billingregion = tf_State.text ?? ""
        data.str_Billingpostal_code = tf_Zip.text?.replacingOccurrences(of: "-", with: "") ?? ""
        data.billingCountry = tf_Country.text ?? ""
        //
        data.str_office_phone = phoneNumberFormateRemoveText(number: tf_OfficePhone.text!)
        data.str_contact_source = tf_ContactSource.text ?? ""
        data.str_customer_status = tf_SelectCustomerStatus.text ?? ""
        data.str_first_name = tf_FirstName.text ?? ""
        data.str_last_name = tf_LastName.text ?? ""
        data.str_email = tf_Email.text ?? ""
        data.str_phone = phoneNumberFormateRemoveText(number: tf_PhoneNumber.text!)
        data.str_address = tf_Address.text ?? ""
        data.str_address2 = tf_Address2.text ?? ""
        data.str_city = tf_City.text ?? ""
        data.str_region = tf_State.text ?? ""
        data.str_postal_code = tf_Zip.text?.replacingOccurrences(of: "-", with: "") ?? ""
        data.country = tf_Country.text ?? ""
        //
        data.userCoupan = customerList.userCoupan
        data.userCustomTax = customerList.userCustomTax
        data.cardDetail = customerList.cardDetail
        data.isDataAdded = customerList.isDataAdded
        data.str_bpid = customerList.str_bpid
        data.str_display_name = customerList.str_display_name
        data.str_order_id = customerList.str_order_id
        data.str_userID = customerList.str_userID
        
        if !((!isNewUser || selectedUser.str_userID != "") || !tf_FirstName.isEmpty || !tf_LastName.isEmpty || !tf_Email.isEmpty || !tf_PhoneNumber.isEmpty || !tf_Address.isEmpty || !tf_Address2.isEmpty || !tf_City.isEmpty || !(tf_Country.text == DataManager.selectedCountry) || !tf_State.isEmpty || !tf_Zip.isEmpty || !tf_FirstNameShipping.isEmpty || !tf_LastNameShipping.isEmpty || !tf_EmailShipping.isEmpty || !tf_PhoneNumberShipping.isEmpty || !tf_CompanyShipping.isEmpty || !tf_AddressShipping.isEmpty || !tf_Address2Shipping.isEmpty || !tf_CityShipping.isEmpty || !(tf_CountryShipping.text == DataManager.selectedCountry) || !tf_StateShipping.isEmpty || !tf_ZipShipping.isEmpty || !tf_CustomText1.isEmpty || !tf_CustomText2.isEmpty)  {
            self.selectedUser.country = ""
            self.selectedUser.billingCountry = ""
            self.selectedUser.shippingCountry = ""
            data.country = ""
            data.billingCountry = ""
            data.shippingCountry = ""
        }

        return data
    }
    
    //MARK: IBAction
    
    @IBAction func actionSelectShipping(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "SelectShippingAddressVc") as! SelectShippingAddressVc
        secondVC.delegateShipIphone = self
        secondVC.StrID = DataManager.customerForShippingAddressId
        present(secondVC, animated: true, completion: nil)
    }
        
    @IBAction func btn_ShippingSameAsBillingAction(_ sender: Any) {
        self.view.endEditing(true)
        btn_ShippingSameAsBilling.isSelected = !btn_ShippingSameAsBilling.isSelected
        DataManager.isCheckUncheckShippingBilling = self.btn_ShippingSameAsBilling.isSelected
        tf_StateShipping.isHidden = DataManager.isCheckUncheckShippingBilling
        shippingView.isHidden = DataManager.isCheckUncheckShippingBilling
        let check = DataManager.shippingaddressCount > 1
        btnShippingSelectAddress.isHidden = check == true ? false : true

        self.updateShippingAddress()
        
//        if !btn_ShippingSameAsBilling.isSelected{
//            if DataManager.customerForShippingAddressId != ""{
//                //if !isNewUser{
//                    if DataManager.shippingaddressCount > 1{
//                        btnShippingSelectAddress.isHidden = false
//                    }else{
//                        btnShippingSelectAddress.isHidden = true
//                    }
//               // }
//            }
//        }else{
//            btnShippingSelectAddress.isHidden = true
//        }
        
        if !self.btn_ShippingSameAsBilling.isSelected {
            if  DataManager.isPaymentBtnAddCustomer {
                resetCustomerBilingInfromationError()
                customerInformationErrorShowForShippingForPhone()
                callValidationForShipping()
            }
            if !isNewUser{
                if DataManager.customerForShippingAddressId != ""{
                    if DataManager.shippingaddressCount > 1{
                        btnShippingSelectAddress.isHidden = false
                    }else{
                        btnShippingSelectAddress.isHidden = true
                    }
                }
            }
        }else{
            if  DataManager.isPaymentBtnAddCustomer {
                customerInformationErrorShowForBillingForPhone()
            }
            btnShippingSelectAddress.isHidden = true
        }
       
    }
    
    @IBAction func btn_BackAction(_ sender: Any) {
        UIApplication.shared.isStatusBarHidden = false
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_DoneAction(_ sender: Any) {
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.onCustomerFound(CustomerId: DataManager.customerId)
        }
        if DataManager.isshipOrderButton  {
            
            if  DataManager.isPaymentBtnAddCustomer {
                
                if DataManager.isCheckUncheckShippingBilling {
                    if tf_City.text == "" || tf_State.text == "" || tf_Zip.text == ""{
                        
                        customerInformationErrorShowForBillingForPhone()
                        
                        
                    }else{
                        if (tf_Address.text != "" || tf_Address2.text != "") {
                            SetForcellyCustData()
                            
                        }else{
                            customerInformationErrorShowForBillingForPhone()
                        }
                    }
                    
                }else{
                    if tf_CityShipping.text == "" || tf_StateShipping.text == "" || tf_ZipShipping.text == ""{
                        
                        customerInformationErrorShowForShippingForPhone()
                         resetCustomerBilingInfromationError()
                    }else{
                        if (tf_AddressShipping.text != "" || tf_Address2Shipping.text != "") {
                            
                            SetForcellyCustData()
                            
                        }else{
                            customerInformationErrorShowForShippingForPhone()
                             resetCustomerBilingInfromationError()
                        }
                    }
                }
                
            }else{
                SetForcellyCustData()
            }
        }else{
            SetForcellyCustData()
        }
        
    }
    
    
    @IBAction func actionCallTfValidationForBilling(_ sender: UITextField) {
        
        if DataManager.isshipOrderButton || DataManager.shippingValueForAddress ?? 0.00 > 0 {
            callvalidationforBilling()
        }
    }
    
    
    @IBAction func actionCallTfValidationForShipping(_ sender: UITextField) {
        if DataManager.isshipOrderButton || DataManager.shippingValueForAddress ?? 0.00 > 0 {
            callValidationForShipping()
        }
    }
    
    func callValidationForShipping() {
        
        
        if versionOb < 4 {
            return
        }
        if !DataManager.isPaymentBtnAddCustomer {
            return
        }
        if tf_FirstNameShipping.text == "" {
            updateError(textfieldIndex: 12, message: "Please enter First Name.")
        } else {
            tf_FirstNameShipping.resetCustomError()
        }
        if tf_LastNameShipping.text == "" {
            updateError(textfieldIndex: 13, message: "Please enter Last Name.")
        } else {
            tf_LastNameShipping.resetCustomError()
        }
        if tf_FirstNameShipping.text == "" || tf_LastNameShipping.text == ""{
            
            if (tf_FirstName.text == "" || tf_LastName.text == "") {
                if tf_CompanyShipping.text == ""{
                    updateError(textfieldIndex: 11, message: "Please enter Company Name.")
                }else{
                    tf_CompanyShipping.resetCustomError()
                    tf_LastNameShipping.resetCustomError()
                    tf_FirstNameShipping.resetCustomError()
                }
            } else if tf_CompanyShipping.text != "" {
                tf_CompanyShipping.resetCustomError()
                tf_FirstNameShipping.resetCustomError()
                tf_LastNameShipping.resetCustomError()
            } else {
                tf_CompanyShipping.resetCustomError()
            }
        }else{
            tf_CompanyShipping.resetCustomError()
            tf_FirstNameShipping.resetCustomError()
            tf_LastNameShipping.resetCustomError()
        }
        
        if tf_AddressShipping.text == "" {
            updateError(textfieldIndex: 5, message: "Please enter customer Address.")
        } else {
            tf_AddressShipping.resetCustomError()
        }
        if tf_CityShipping.text == ""{
            updateError(textfieldIndex: 6, message: "Please enter customer City.")
        }else{
            tf_CityShipping.resetCustomError()
        }
        if tf_StateShipping.text == ""{
            updateError(textfieldIndex: 7, message: "Please select State.")
        }else {
            tf_StateShipping.resetCustomError()
        }
        if tf_ZipShipping.text == ""{
            updateError(textfieldIndex: 8, message: "Please enter Zip Code.")
        }else{
            tf_ZipShipping.resetCustomError()
        }
        if tf_OfficePhone.text == ""{
            updateError(textfieldIndex: 14, message: "Please enter Office Phone.")
        }else{
            tf_OfficePhone.resetCustomError()
        }
        if tf_ContactSource.text == ""{
            updateError(textfieldIndex: 15, message: "Please enter Contact Source.")
        }else{
            tf_ContactSource.resetCustomError()
        }
        tf_FirstName.resetCustomError()
        tf_LastName.resetCustomError()
        tf_City.resetCustomError()
    }
    
    func callvalidationforBilling(){
        if versionOb < 4 {
            return
        }
        if !DataManager.isPaymentBtnAddCustomer {
            return
        }
        if DataManager.isCheckUncheckShippingBilling{
            if tf_CompanyShipping.text != "" {
                tf_LastName.resetCustomError()
                tf_FirstName.resetCustomError()
                tf_CompanyShipping.resetCustomError()
                tf_FirstNameShipping.resetCustomError()
                tf_LastNameShipping.resetCustomError()
                
            } else if (tf_FirstName.text == "" && tf_LastName.text == "" && tf_CompanyShipping.text == "") {
                updateError(textfieldIndex: 9, message: "Please enter First Name.")
                updateError(textfieldIndex: 10, message: "Please enter Last Name.")
                updateError(textfieldIndex: 11, message: "Please enter Company Name.")
                //billingLastNameTextField.setCustomError(text: "Please enter Last Name.", bottomSpace: 2)
                //billingFirstNameTextField.setCustomError(text: "Please enter First Name.", bottomSpace: 2)
                //billingCompanyTextField.setCustomError(text: "Please enter Company Name.", bottomSpace: 2)
            } else if (tf_FirstName.text == "" && tf_LastName.text == "") && tf_CompanyShipping.text != "" {
                tf_FirstName.resetCustomError()
                tf_LastName.resetCustomError()
                tf_CompanyShipping.resetCustomError()
            } else if (tf_FirstName.text != "" && tf_LastName.text != "") && tf_CompanyShipping.text == "" {
                tf_LastName.resetCustomError()
                tf_FirstName.resetCustomError()
                tf_CompanyShipping.resetCustomError()
            } else if tf_FirstName.text != "" {
                tf_FirstName.resetCustomError()
                updateError(textfieldIndex: 10, message: "Please enter Last Name.")
                updateError(textfieldIndex: 11, message: "Please enter Company Name.")
                //billingLastNameTextField.setCustomError(text: "Please enter Last Name.", bottomSpace: 2)
                //billingCompanyTextField.setCustomError(text: "Please enter Company Name.", bottomSpace: 2)
            } else if tf_LastName.text != ""{
                tf_LastName.resetCustomError()
                updateError(textfieldIndex: 9, message: "Please enter First Name.")
                updateError(textfieldIndex: 11, message: "Please enter Company Name.")
                //billingFirstNameTextField.setCustomError(text: "Please enter First Name.", bottomSpace: 2)
                //billingCompanyTextField.setCustomError(text: "Please enter Company Name.", bottomSpace: 2)
            }
            
            if tf_City.text == "" {
                updateError(textfieldIndex: 2, message: "Please enter customer City.")
            } else {
                tf_City.resetCustomError()
            }
        }
        else {
            if (tf_CompanyShipping.text != "") || (tf_FirstName.text != "" && tf_LastName.text != ""){
                tf_FirstName.resetCustomError()
                tf_LastName.resetCustomError()
                tf_CompanyShipping.resetCustomError()
                if tf_CompanyShipping.text != "" {
                    tf_FirstNameShipping.resetCustomError()
                    tf_LastNameShipping.resetCustomError()
                } else {
                    updateError(textfieldIndex: 12, message: "Please enter First Name.")
                    updateError(textfieldIndex: 13, message: "Please enter Last Name.")
                    
                }
            } else if (tf_CompanyShipping.text != "") && (tf_FirstName.text != "" && tf_LastName.text != "") {
                tf_FirstName.resetCustomError()
                tf_LastName.resetCustomError()
                tf_CompanyShipping.resetCustomError()
                tf_FirstNameShipping.resetCustomError()
                tf_LastNameShipping.resetCustomError()
            } else if (tf_CompanyShipping.text != "") {
                tf_FirstNameShipping.resetCustomError()
                tf_LastNameShipping.resetCustomError()
            } else if (tf_FirstNameShipping.text != "" && tf_LastNameShipping.text != "") {
                tf_CompanyShipping.resetCustomError()
                //updateError(textfieldIndex: 11, message: "Please enter Company Name.")
            } else {
                updateError(textfieldIndex: 11, message: "Please enter Company Name.")
            }
        }
    }
    
    func customerInformationErrorShowForBillingForPhone(){

//        if tf_Address.text == "" && tf_Address2.text == "" {
//            self.customerAddressErrorView.isHidden = false
//        }else{
//            if tf_City.text == "" || tf_State.text == "" || tf_Zip.text == "" {
//                self.customerAddressErrorView.isHidden = false
//            }else{
//                self.customerAddressErrorView.isHidden = true
//            }
//        }
        
        if versionOb < 4 {
            return
        }
        if !DataManager.isPaymentBtnAddCustomer {
            return
        }
        
        if tf_FirstName.text == "" {
            updateError(textfieldIndex: 9, message: "Please enter First Name.")
        }else{
            tf_FirstName.resetCustomError()
            
        }
        if tf_LastName.text == "" {
            updateError(textfieldIndex: 10, message: "Please enter Last Name.")
        }else{
            tf_LastName.resetCustomError()
        }
        
        
        if tf_CompanyShipping.text == ""{
            updateError(textfieldIndex: 11, message: "Please enter Company Name.")
        }else{
            tf_CompanyShipping.resetCustomError()
        }
        
        if tf_City.text == "" || tf_State.text == "" || tf_Zip.text == "" {
            customerAddressErrorView.isHidden = false
        }else{
            if tf_Address.text != "" || tf_Address2.text != "" {
                customerAddressErrorView.isHidden = true
            }else{
                customerAddressErrorView.isHidden = false
            }
        }
        
        
        if tf_Address.text == "" && tf_Address2.text == "" {
            updateError(textfieldIndex: 1, message: "Please enter customer Address.")
        }else{
            tf_Address.resetCustomError()
            tf_Address2.resetCustomError()
        }
        
        if tf_City.text == ""{
            updateError(textfieldIndex: 2, message: "Please enter customer City.")
        }else{
            tf_City.resetCustomError()
        }
        if tf_State.text == ""{
            updateError(textfieldIndex: 3, message: "Please select State.")
        }else{
            tf_State.resetCustomError()
        }
        if tf_Zip.text == ""{
            updateError(textfieldIndex: 4, message: "Please enter Zip Code.")
        }else{
            tf_Zip.resetCustomError()
        }
        
    }
    
    func customerInformationErrorShowForShippingForPhone(){
        
        if versionOb < 4 {
            return
        }
        if !DataManager.isPaymentBtnAddCustomer {
            return
        }
        
        if tf_AddressShipping.text == "" && tf_Address2Shipping.text == "" {
            self.customerAddressErrorView.isHidden = false
        }else{
            if tf_CityShipping.text == "" || tf_StateShipping.text == "" || tf_ZipShipping.text == "" {
                self.customerAddressErrorView.isHidden = false
            }else{
                self.customerAddressErrorView.isHidden = true
            }
        }
        
        if tf_FirstNameShipping.text == ""{
            updateError(textfieldIndex: 12, message: "Please enter First Name.")
        }else{
            tf_FirstNameShipping.resetCustomError()
        }
        if tf_LastNameShipping.text == ""{
            updateError(textfieldIndex: 13, message: "Please enter Last Name.")
        }else{
            tf_LastNameShipping.resetCustomError()
        }
        
        if tf_CityShipping.text == "" || tf_StateShipping.text == "" || tf_ZipShipping.text == "" {
            customerAddressErrorView.isHidden = false
        }else{
            if tf_AddressShipping.text != "" || tf_Address2Shipping.text != "" {
                customerAddressErrorView.isHidden = true
            }else{
                customerAddressErrorView.isHidden = false
            }
        }
        
        if tf_AddressShipping.text == "" && tf_Address2Shipping.text == "" {
            updateError(textfieldIndex: 5, message: "Please enter customer Address.")
        }else {
            tf_AddressShipping.resetCustomError()
            tf_Address2Shipping.resetCustomError()
        }
        if tf_CityShipping.text == ""{
            updateError(textfieldIndex: 6, message: "Please enter customer City.")
        }else{
            tf_CityShipping.resetCustomError()
        }
        if tf_StateShipping.text == ""{
            updateError(textfieldIndex: 7, message: "Please select State.")
        }else {
            tf_StateShipping.resetCustomError()
        }
        if tf_ZipShipping.text == ""{
            updateError(textfieldIndex: 8, message: "Please enter Zip Code.")
        }else{
            tf_ZipShipping.resetCustomError()
        }
        
    }
    
    
    func resetCustomerInfromationError(){
        tf_Address.resetCustomError()
        tf_Address.resetCustomError()
        tf_City.resetCustomError()
        tf_State.resetCustomError()
        tf_Zip.resetCustomError()
        
        tf_AddressShipping.resetCustomError()
        tf_Address2Shipping.resetCustomError()
        tf_CityShipping.resetCustomError()
        tf_StateShipping.resetCustomError()
        tf_ZipShipping.resetCustomError()
        
    }
    func resetCustomerBilingInfromationError (){
        tf_Address.resetCustomError()
        tf_Address.resetCustomError()
        tf_City.resetCustomError()
        tf_State.resetCustomError()
        tf_Zip.resetCustomError()
    }
    
    
    
    func updateError(textfieldIndex: Int, message: String) {
        switch textfieldIndex {
        case 1:
            tf_Address.setCustomError(text: message, bottomSpace: 2.0)
            break
        case 2:
            tf_City.setCustomError(text: message, bottomSpace: 2)
            break
        case 3:
            tf_State.setCustomError(text: message, bottomSpace: 2)
            break
        case 4:
            tf_Zip.setCustomError(text: message, bottomSpace: 2)
            break
        case 5:
            tf_AddressShipping.setCustomError(text: message, bottomSpace: 2.0)
            break
        case 6:
            tf_CityShipping.setCustomError(text: message, bottomSpace: 2)
            break
        case 7:
            tf_StateShipping.setCustomError(text: message, bottomSpace: 2)
            break
        case 8:
            tf_ZipShipping.setCustomError(text: message, bottomSpace: 2)
            break
        case 9:
            tf_FirstName.setCustomError(text: message, bottomSpace: 2)
            break
        case 10:
            tf_LastName.setCustomError(text: message, bottomSpace: 2)
            break
        case 11:
            tf_CompanyShipping.setCustomError(text: message, bottomSpace: 2)
            break
        case 12:
            tf_FirstNameShipping.setCustomError(text: message, bottomSpace: 2)
            break
        case 13:
            tf_LastNameShipping.setCustomError(text: message, bottomSpace: 2)
            break
        case 14:
            tf_OfficePhone.setCustomError(text: message, bottomSpace: 2)
            break
        case 15:
            tf_ContactSource.setCustomError(text: message, bottomSpace: 2)
            break
        default: break
        }
    }
    
    
    func SendShipAddressIphone(arrayAddress:Array<AnyObject>){
        print(arrayAddress)
        let object = arrayAddress[0] as! UserShippingAddress
        print("object firstname",object.firstname)
        print("object lastname",object.lastname)
        print("object addressline1",object.addressline1)
        print("object addressline2",object.addressline2)
        print("object region",object.region)
        print("object postalcode",object.postalcode)
        print("object city",object.city)
        print("object country",object.country)
        print("object bpid",object.bpid)
        print("object displayname",object.displayname)
        
        tf_FirstNameShipping.text = object.firstname
        tf_LastNameShipping.text = object.lastname
        tf_AddressShipping.text = object.addressline1
        tf_Address2Shipping.text = object.addressline2
        tf_CityShipping.text = object.city
        tf_StateShipping.text = object.region
        tf_ZipShipping.text = formattedZIPCodeNumber(number: object.postalcode)
        tf_CountryShipping.text = object.country
    }
    
    func SetForcellyCustData() {
        self.view.endEditing(true)
//        if tf_FirstName.text == "" && tf_Email.text == "" {
//            tf_FirstName.setCustomError(text: "Please enter name or email.", bottomSpace: 0)
//            return
//        }
        if   tf_Email.text != "" && !tf_Email.isValidEmail() {
            tf_Email.setCustomError(text: "Please enter valid email.", bottomSpace: 0)
            return
        }
        
        if !btn_ShippingSameAsBilling.isSelected {
            tf_EmailShipping.text = tf_Email.text
            if  tf_EmailShipping.text != "" && !tf_EmailShipping.isValidEmail() {
                tf_EmailShipping.setCustomError(text: "Please enter valid email.", bottomSpace: 0)
                return
            }
        }
        
        if (!isNewUser || selectedUser.str_userID != "") || !tf_FirstName.isEmpty || !tf_LastName.isEmpty || !tf_Email.isEmpty || !tf_PhoneNumber.isEmpty || !tf_Address.isEmpty || !tf_Address2.isEmpty || !tf_City.isEmpty || !(tf_Country.text == DataManager.selectedCountry) || !tf_State.isEmpty || !tf_Zip.isEmpty || !tf_FirstNameShipping.isEmpty || !tf_LastNameShipping.isEmpty || !tf_EmailShipping.isEmpty || !tf_PhoneNumberShipping.isEmpty || !tf_CompanyShipping.isEmpty || !tf_AddressShipping.isEmpty || !tf_Address2Shipping.isEmpty || !tf_CityShipping.isEmpty || !(tf_CountryShipping.text == DataManager.selectedCountry) || !tf_StateShipping.isEmpty || !tf_ZipShipping.isEmpty || !tf_CustomText1.isEmpty || !tf_CustomText2.isEmpty || !tf_OfficePhone.isEmpty || !tf_ContactSource.isEmpty   {
            let customerObj: JSONDictionary = ["country": tf_Country.text ?? "", "billingCountry":tf_Country.text ?? "","shippingCountry":tf_CountryShipping.text ?? "","coupan": selectedUser.userCoupan, "str_first_name":tf_FirstName.text ?? "", "str_last_name":tf_LastName.text ?? "", "str_address":tf_Address.text ?? "", "str_bpid":selectedUser.str_bpid, "str_city":tf_City.text ?? "", "str_order_id": selectedUser.str_order_id, "str_email":tf_Email.text ?? "", "str_userID":selectedUser.str_userID, "str_phone":tf_PhoneNumber.text ?? "","str_region":tf_State.text ?? "", "str_address2":tf_Address2.text ?? "", "str_Billingcity":tf_City.text ?? "", "str_postal_code":tf_Zip.text ?? "", "str_Billingphone": tf_PhoneNumber.text ?? "", "str_Billingaddress":tf_Address.text ?? "", "str_Billingaddress2":tf_Address2.text ?? "", "str_Billingregion":tf_State.text ?? "", "str_Billingpostal_code":tf_Zip.text ?? "","shippingPhone": tf_PhoneNumberShipping.text ?? "","str_company": tf_CompanyShipping.text ?? "","shippingAddress" : tf_AddressShipping.text ?? "", "shippingAddress2": tf_Address2Shipping.text ?? "", "shippingCity": tf_CityShipping.text ?? "", "shippingRegion" : tf_StateShipping.text ?? "", "shippingPostalCode": tf_ZipShipping.text ?? "", "billing_first_name":tf_FirstName.text ?? "", "billing_last_name":tf_LastName.text ?? "","user_custom_tax":selectedUser.userCustomTax,"shipping_first_name":tf_FirstNameShipping.text ?? "", "shipping_last_name":tf_LastNameShipping.text ?? "","shippingEmail": tf_EmailShipping.text ?? "", "str_Billingemail":tf_Email.text ?? "", "str_BillingCustom1TextField": tf_CustomText1.text ?? "", "str_BillingCustom2TextField": tf_CustomText2.text ?? "" , "loyalty_balance" : selectedUser.doubleloyalty_balance, "emv_card_count": selectedUser.emv_card_Count,"office_phone":tf_OfficePhone.text ?? "", "contact_source":tf_ContactSource.text ?? "", "customer_status":tf_SelectCustomerStatus.text ?? ""]
            DataManager.customerObj = customerObj
        }
        
        delegate?.didAddNewCustomer(data: self.getNewData(customerList: self.selectedUser))
        UIApplication.shared.isStatusBarHidden = false
        if isPhoneInvoice {
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        } else {
            if DataManager.isshipOrderButton || DataManager.shippingValueForAddress ?? 0.00 > 0 {
                if !isMutiShippingAdr {
                    self.presentingViewController?
                        .presentingViewController?.dismiss(animated: false, completion: nil)
                }
            }else{
                if !isMutiShippingAdr {
                    self.presentingViewController?
                        .presentingViewController?.dismiss(animated: false, completion: nil)
                }
            }
        }
        self.isMutiShippingAdr = false
    }
    
    // for Custom text 1 and Custom text 2
    
     
      func showDatePickerCustomeText1(){
          //Formate Date
          datePicker.datePickerMode = .date
          
          //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePickerCustomText1));
          let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
          let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePickerCustomText1));
          
          toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
          
          tf_CustomText1.inputAccessoryView = toolbar
          tf_CustomText1.inputView = datePicker
          if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
          }
      }
      
      @objc func donedatePickerCustomText1(){
          
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          tf_CustomText1.text = formatter.string(from: datePicker.date)
          self.view.endEditing(true)
      }
      
      @objc func cancelDatePickerCustomText1(){
          self.view.endEditing(true)
      }
      
      // for custome text 2
      func showDatePickerCustomeText2(){
            //Formate Date
            datePicker.datePickerMode = .date
            
            //ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePickerCustomText2));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePickerCustomText2));
            
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            
            tf_CustomText2.inputAccessoryView = toolbar
            tf_CustomText2.inputView = datePicker
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
        }
        
        @objc func donedatePickerCustomText2(){
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            tf_CustomText2.text = formatter.string(from: datePicker.date)
            self.view.endEditing(true)
        }
        
        @objc func cancelDatePickerCustomText2(){
            self.view.endEditing(true)
        }
      
 
  
}


//MARK:- Textfield Delegate Methods
extension AddNewCutomerViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == tf_FirstName {
            tf_LastName.becomeFirstResponder()
        }
        
        if textField == tf_LastName {
            tf_Email.becomeFirstResponder()
        }
        
        if textField == tf_Email {
            tf_PhoneNumber.becomeFirstResponder()
        }
        
        if textField == tf_PhoneNumber {
            tf_Address.becomeFirstResponder()
        }
        
        if textField == tf_Address {
            tf_Address2.becomeFirstResponder()
        }
        
        if textField == tf_Address2 {
            if !tf_Country.isHidden {
                tf_Country.becomeFirstResponder()
            }else {
                tf_State.becomeFirstResponder()
            }
        }
        
        if textField == tf_Country {
            tf_State.becomeFirstResponder()
        }

        if textField == tf_State {
            tf_City.becomeFirstResponder()
        }

        if textField == tf_City {
            tf_Zip.becomeFirstResponder()
        }
        
        if textField == tf_Zip {
            textField.resignFirstResponder()
        }
        
        if textField == tf_FirstNameShipping {
            tf_LastNameShipping.becomeFirstResponder()
        }
        
        if textField == tf_LastNameShipping {
            tf_EmailShipping.becomeFirstResponder()
        }
        
        if textField == tf_EmailShipping {
            tf_PhoneNumberShipping.becomeFirstResponder()
        }
        
        if textField == tf_PhoneNumberShipping {
            tf_CompanyShipping.becomeFirstResponder()
        }
        
        if textField == tf_CompanyShipping {
            tf_AddressShipping.becomeFirstResponder()
        }
        
        if textField == tf_AddressShipping {
            tf_Address2Shipping.becomeFirstResponder()
        }
        
        if textField == tf_Address2Shipping {
            if !tf_CountryShipping.isHidden {
                tf_CountryShipping.becomeFirstResponder()
            }else {
                tf_StateShipping.becomeFirstResponder()
            }
        }
        
        if textField == tf_CountryShipping {
            tf_StateShipping.becomeFirstResponder()
        }
        
        if textField == tf_StateShipping {
            tf_CityShipping.becomeFirstResponder()
        }
        
        if textField == tf_CityShipping {
            tf_ZipShipping.becomeFirstResponder()
        }
        
        if textField == tf_ZipShipping {
            textField.resignFirstResponder()
        }
        if textField == tf_CustomText1 {
            tf_CustomText1.becomeFirstResponder()
        }
        if textField == tf_CustomText2 {
            tf_CustomText2.becomeFirstResponder()
        }
        

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tf_Email || textField == tf_EmailShipping {
            textField.resetCustomError(isAddAgain: true)
        }
        textField.resetCustomError(isAddAgain: true)
        if textField == tf_State {
            textField.tintColor = UIColor.clear
            textField.resetCustomError(isAddAgain: true)
            if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (DataManager.isShowCountry ? (tf_Country.text ?? "") : DataManager.selectedCountry)}) {
                let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                    self.tf_State.text = text
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
                textField.setCustomError(text: "Please select country.",bottomSpace: 0)
            }
        }
        
        if textField == tf_StateShipping {
            textField.tintColor = UIColor.clear
            textField.resetCustomError(isAddAgain: true)
            if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (DataManager.isShowCountry ? (tf_CountryShipping.text ?? "") : DataManager.selectedCountry)}) {
                let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                    self.tf_StateShipping.text = text
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
                textField.setCustomError(text: "Please select country.",bottomSpace: 0)
            }
        }
        
        if textField == tf_Country {
            textField.tintColor = UIColor.clear
            self.tf_State.text = ""
            self.showCustomTableView(self, sourceView: textField, countryName: "") { (text) in
                textField.text = text
            }
        }
        
        if textField == tf_ContactSource{
            textField.tintColor = UIColor.clear
            self.showContactSourceCustomTableView(self, sourceView: textField, contactSource: ""){
                (text) in
                textField.text = text
            }
        }
        if textField == tf_SelectCustomerStatus {
            textField.tintColor = UIColor.clear
            textField.resignFirstResponder()
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
            self.customerStatus(self, sourceView: textField, contactSource: ""){
                (text) in
               // self.tf_SelectCustomerStatus = textField.text ?? ""
                textField.text = text
               // appDelegate.isHomeProductAPICall = true
            }
        }
        
        if textField == tf_CountryShipping {
            textField.tintColor = UIColor.clear
            self.tf_StateShipping.text = ""
            self.showCustomTableView(self, sourceView: textField, countryName: "") { (text) in
                textField.text = text
            }
        }
        
        if textField == tf_CustomText1 {
            tf_CustomText1.inputView = nil
            tf_CustomText1.reloadInputViews()
            if DataManager.customText1Type == "date" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                showDatePickerCustomeText1()
                tf_CustomText1.selectAll(nil)
            }else{
                if DataManager.customText1Type == "numeric" {
                    tf_CustomText1.keyboardType = UIKeyboardType.asciiCapableNumberPad
                }else{
                    if DataManager.customText1Type == "text" && (checkString1.lowercased().range(of:"phone") != nil){
                        //tf_CustomText1.keyboardType = UIKeyboardType.asciiCapable
                        tf_CustomText1.keyboardType = UIKeyboardType.asciiCapableNumberPad
                    }else{
                        tf_CustomText1.keyboardType = UIKeyboardType.asciiCapable
                    }
                    
                }
            }
        }
        
        // for custom text 2
        
        if textField == tf_CustomText2 {
            tf_CustomText2.inputView = nil
            tf_CustomText2.reloadInputViews()
            if DataManager.customText2Type == "date" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                showDatePickerCustomeText2()
                tf_CustomText2.selectAll(nil)
            }else{
                if DataManager.customText2Type == "numeric" {
                    tf_CustomText2.keyboardType = UIKeyboardType.asciiCapableNumberPad
                }else{
                    if DataManager.customText2Type == "text" && (checkString2.lowercased().range(of:"phone") != nil){
                       // tf_CustomText2.keyboardType = UIKeyboardType.asciiCapable
                        tf_CustomText2.keyboardType = UIKeyboardType.asciiCapableNumberPad
                    }else{
                        tf_CustomText2.keyboardType = UIKeyboardType.asciiCapable
                    }
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
       
        if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }

        if textField == tf_Email || textField == tf_EmailShipping {
            if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
                return false
            }
            return true
        }
        
        if textField == tf_FirstName || textField == tf_LastName || textField == tf_FirstNameShipping || textField == tf_LastNameShipping {
            if charactersCount > 25 {
                return false
            }
        }
    
        if textField == tf_PhoneNumber || textField == tf_PhoneNumberShipping || textField == tf_OfficePhone {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedPhoneNumber(number: newString)
            return false
        }
        
        if textField == tf_PhoneNumber || textField == tf_PhoneNumberShipping || textField == tf_OfficePhone{
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 20 {
                return false
            }
            return string == filtered
        }
        
        if textField == tf_CustomText1{
            if DataManager.customText1Type == "numeric" {
                let cs = NSCharacterSet(charactersIn: "0123456789").inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if charactersCount > 20 {
                    return false
                }
                return string == filtered
            }else if DataManager.customText1Type == "text" && (checkString1.lowercased().range(of:"phone") != nil){
                let cs = NSCharacterSet(charactersIn: "0123456789").inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if charactersCount > 20 {
                    return false
                }
                return string == filtered
            }
        }
           if textField == tf_CustomText2 {
            if DataManager.customText2Type == "numeric" {
                let cs = NSCharacterSet(charactersIn: "0123456789").inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if charactersCount > 20 {
                    return false
                }
                return string == filtered
            }else if DataManager.customText2Type == "text" && (checkString2.lowercased().range(of:"phone") != nil){
                let cs = NSCharacterSet(charactersIn: "0123456789").inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if charactersCount > 20 {
                    return false
                }
                return string == filtered
            }
        }
        
        if textField == tf_Zip || textField == tf_ZipShipping {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedZIPCodeNumber(number: newString)
            return false
        }
    
        if textField == tf_Address || textField == tf_Address2 ||  textField == tf_City || textField == tf_Zip || textField == tf_CompanyShipping || textField == tf_AddressShipping || textField == tf_Address2Shipping ||  textField == tf_CityShipping || textField == tf_ZipShipping {
            if textField.text == "" && string == " " {
                return false
            }
        }
        
        if textField == tf_Zip || textField == tf_ZipShipping {
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 20 {
                return false
            }
            return string == filtered
        }
        
        if textField == tf_Address || textField == tf_Address2 || textField == tf_CompanyShipping || textField == tf_AddressShipping || textField == tf_Address2Shipping {
            if charactersCount > 100 {
                return false
            }
        }
        
        if textField == tf_City || textField == tf_Zip || textField == tf_CityShipping || textField == tf_ZipShipping {
            let cs = CharacterSet.alphanumerics.inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 20 {
                return false
            }
            if string == " " {
                return true
            }
            return string == filtered
        }
        if DataManager.isshipOrderButton || DataManager.shippingValueForAddress ?? 0.00 > 0 {
            callValidationForShipping()
            callvalidationforBilling()
        }
        
        return true
    }
    
}

//    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        <#code#>
//    }
    


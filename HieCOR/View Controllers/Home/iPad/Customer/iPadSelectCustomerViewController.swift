//
//  iPadSelectCustomerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 04/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//
import Foundation
import UIKit
import CoreData
import IQKeyboardManagerSwift
import SocketIO

enum SelectCustomerViewType {
    case selectOrNew
    case existing
}

class iPadSelectCustomerViewController: BaseViewController  {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var viewSelectShippingAddress: UIView!
    @IBOutlet var segmentView: UIView!
    @IBOutlet var newCustomerView: UIView!
    @IBOutlet var doneCancelView: UIView!
    @IBOutlet var shippingView: UIStackView!
    @IBOutlet var isBillingSameShippingButton: UIButton!
    @IBOutlet var isBillingSameShippingTextButton: UIButton!
    @IBOutlet var newCustomerButton: UIButton!
    @IBOutlet var selectCustomerButton: UIButton!
    @IBOutlet var selectCustomerTabelView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var address2TextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var zipTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var billingFirstNameTextField: UITextField!
    @IBOutlet var billingLastNameTextField: UITextField!
    @IBOutlet var billingEmailTextField: UITextField!
    @IBOutlet var billingPhoneTextField: UITextField!
    @IBOutlet var billingCompanyTextField: UITextField!
    @IBOutlet var billingAddressTextField: UITextField!
    @IBOutlet var billingAddress2TextField: UITextField!
    @IBOutlet var billingCityTextField: UITextField!
    @IBOutlet var billingStateTextField: UITextField!
    @IBOutlet var billingZipTextField: UITextField!
    @IBOutlet var billingCountryTextField: UITextField!
    
    @IBOutlet weak var customText1CalenderImg: UIImageView!
    @IBOutlet weak var customText2CalenderImg: UIImageView!
    @IBOutlet weak var billingStackViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var billingCustom1And2MainView: UIView!
    @IBOutlet weak var billingCustom1TextField: UITextField!
    @IBOutlet weak var billingCustom2TextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var billingCountryDropDownImg: UIImageView!
    @IBOutlet weak var billingCountryLineView: UIView!
    @IBOutlet weak var countryDropDownImg: UIImageView!
    @IBOutlet weak var countryLineView: UIView!
    @IBOutlet weak var stateDropDownImg: UIImageView!
    @IBOutlet weak var stateLineView: UIView!
    
    @IBOutlet weak var btnSelectShipAddress: UIButton!
    @IBOutlet weak var viewErrorShow: UIView!
    @IBOutlet weak var viewCustomerStatusShow: UIView!
    //by anand
    @IBOutlet weak var contactSourceTextField: UITextField!
    @IBOutlet weak var officePhoneTextField: UITextField!
    @IBOutlet weak var selectCustomerStatusTextField: UITextField!
    @IBOutlet weak var imgCustomeStatisDropDown: UIImageView!
    @IBOutlet weak var viewOffficePhoneContact: UIView!
    @IBOutlet weak var viewCenterOfficeContact: UIView!
    var tempData = CustomerListModel()
    var checkString1 = DataManager.customText1Label ?? ""
    var checkString2 = DataManager.customText2Label ?? ""
    //end anand
    //MARK: Variables
    // var customerId = String()
    var addCustomer = String()
    var isSearching = Bool()
    var array_CustomersList = [CustomerListModel]()
    var array_searchCustomersList = [CustomerListModel]()
    var array_CustomerNames = Array<Any>()
    var filteredContentList = Array<Any>()
    var selectedDict = [String: Any]()
    var selectedUser = CustomerListModel()
    var delegate: SelectedCutomerDelegate?
    var customerDelegate: CustomerDelegates?
    var catAndProductDelegate: CatAndProductsViewControllerDelegate?
    static var selectCustomerViewType: SelectCustomerViewType = .selectOrNew
    static var isSelectCustomerOpen = false
    var customerDelegateForAddNewCustomer: CustomerDelegates?
    var shippingDelegate : SelectShippingDelegate?
    var addressShipping: addressShippingDelegate?
    
    //MARK: Private Variables
    private var onLineFetchLimit:Int = 30
    private var indexofPage:Int = 1
    private var isDataLoading:Bool = false
    private var isLastIndex: Bool = false
    private var isUserSelected: Bool = false
    private var isUserDataSelected: Bool = false
    private var selectedTextField = UITextField()
    private var isPaymentBtnAction:Bool = false
    var versionOb = Int()
    //for Custome text
    let datePicker = UIDatePicker()
    var str_CustomerTag = ""
    var customerListItem = 0
    var isMultiShippingAdrs = false
    var strCustomeStatusTemp = ""
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // for socket sudama
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.connect()
        }
        self.versionOb = Int(DataManager.appVersion)!
        btnSelectShipAddress.isHidden = true
        
        self.updateCountryFields()
        //CustomizeUI
        self.customizeUI()
        hideLineView(isNewselected: false)
        customText1AndCustomText2View()
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.searchCustomerSocket()
                
            }
        }
        
        if DataManager.showCustomerStatusAllInOne != "true" {
            viewCustomerStatusShow.isHidden = true
            imgCustomeStatisDropDown.isHidden = true
        }
        
        if DataManager.showContactSourceBoxAllInOne != "true" && DataManager.showOfficePhoneAllInOne != "true" {
            viewOffficePhoneContact.isHidden = true
        }
        if DataManager.showContactSourceBoxAllInOne != "true" {
            contactSourceTextField.isHidden = true
            viewCenterOfficeContact.isHidden = true
        }
        if DataManager.showOfficePhoneAllInOne != "true" {
            officePhoneTextField.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
                 self.isBillingSameShippingButton.isSelected = DataManager.isCheckUncheckShippingBilling
        self.isBillingSameShippingTextButton.isSelected = DataManager.isCheckUncheckShippingBilling
        
        iPadSelectCustomerViewController.isSelectCustomerOpen = false
        self.setPlaceholderColor()
        
        if !self.isBillingSameShippingButton.isSelected {
            if DataManager.shippingaddressCount > 1{
                btnSelectShipAddress.isHidden = false
            }else{
                btnSelectShipAddress.isHidden = true
            }
        }else{
            btnSelectShipAddress.isHidden = true
        }
        
        customizeUI()
        customText1AndCustomText2View()
        if selectedUser.str_first_name.isEmpty && selectedUser.str_email.isEmpty {
            selectCustomerStatusTextField.text = DataManager.customerStatusDefaultName
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.isBillingSameShippingButton.isSelected = DataManager.isCheckUncheckShippingBilling
        self.isBillingSameShippingTextButton.isSelected = DataManager.isCheckUncheckShippingBilling
        
        iPadSelectCustomerViewController.isSelectCustomerOpen = false
        self.setPlaceholderColor()
        
        if !self.isBillingSameShippingButton.isSelected {
            if DataManager.shippingaddressCount > 1{
                btnSelectShipAddress.isHidden = false
            }else{
                btnSelectShipAddress.isHidden = true
            }
        }else{
            btnSelectShipAddress.isHidden = true
        }
        
        customizeUI()
        customText1AndCustomText2View()
        
        
    }
    
    @IBAction func errorLabHideTFAction(_ sender: UITextField) {
        
        if versionOb < 4 {
            return
        }
        
        if !DataManager.isPaymentBtnAddCustomer {
            return
        }
        
        if DataManager.isshipOrderButton  {
            callvalidationforBilling()
            
            if  DataManager.isPaymentBtnAddCustomer {
                if DataManager.isCheckUncheckShippingBilling {
                    if sender.text == "" {
                        viewErrorShow.isHidden = false
                    }else{
                        if billingCityTextField.text == "" || billingStateTextField.text == "" || billingZipTextField.text == "" {
                            if  billingAddressTextField.text != "" || billingAddress2TextField.text != ""{
                                viewErrorShow.isHidden = false
                            }else{
                                viewErrorShow.isHidden = true
                            }
                            
                        }else{
                            viewErrorShow.isHidden = true
                        }
                    }
                }else{
                    callValidationForShipping()
                    if sender.text == "" {
                        viewErrorShow.isHidden = false
                    }else{
                        //                        if cityTextField.text == "" || stateTextField.text == "" || zipTextField.text == "" {
                        //
                        //                            if addressTextField.text == "" {
                        //                                viewErrorShow.isHidden = false
                        //                            }else{
                        //                                viewErrorShow.isHidden = true
                        //                            }
                        //
                        //                        }else{
                        //                            viewErrorShow.isHidden = true
                        //                        }
                    }
                }
            }
        }
        
    }
    
    // for socket sudama
    func searchCustomerSocket(){
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
            MainSocketManager.shared.connect()
            //  MainSocketManager.shared.onConnect {
            // MainSocketManager.shared.userJoinOnConnect(deviceId: self.deviceId!)
            
            let socketConnectionStatus = MainSocketManager.shared.socket.status
            
            switch socketConnectionStatus {
            case SocketIOStatus.connected:
                print("socket connected")
                
                MainSocketManager.shared.searchCustomerNumber { (searchCustomerForSocketObj) in
                    if DataManager.sessionID == searchCustomerForSocketObj.session_id {
                        self.getCustomerApiForSocket(customerID: searchCustomerForSocketObj.phone)
                    }
                }
                MainSocketManager.shared.emitselectCustomer { (selectCustomerForSocketObj) in
                    if DataManager.sessionID == selectCustomerForSocketObj.session_id {
                        self.getCustomerApiForSocket(customerID: selectCustomerForSocketObj.userId)
                    }
                }
                
            case SocketIOStatus.connecting:
                print("socket connecting")
            case SocketIOStatus.disconnected:
                print("socket disconnected")
            case SocketIOStatus.notConnected:
                print("socket not connected")
            }
            //     }
        }
        
    }
    
    func getCustomerApiForSocket(customerID : String){
        HomeVM.shared.getSearchCustomer(searchText: customerID, searchFetchLimit: 1, searchPageCount: 1, responseCallBack: { (success, message, error) in
            if success == 1 {
                //Update Data
                if !HomeVM.shared.isMoreSearchCustomerFound {
                    // self.indexofPage = self.indexofPage - 1
                }
                self.isSearching = true
                self.array_CustomerNames.removeAll()
                DispatchQueue.main.async {
                    self.array_searchCustomersList = HomeVM.shared.searchCustomerList
                    if self.array_searchCustomersList.count > 0 {
                        self.clickedIndex(index: 0)
                    }else{
                        MainSocketManager.shared.onSearchPhoneNoError()
                    }
                    
                    self.selectCustomerTabelView.reloadData()
                }
                // Indicator.isEnabledIndicator = true
                //Indicator.sharedInstance.hideIndicator()
            }
            else {
                MainSocketManager.shared.onSearchPhoneNoError()
                //  Indicator.isEnabledIndicator = true
                // Indicator.sharedInstance.hideIndicator()
                if message != nil {
                    //                        self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    //
    func customerInformationErrorShowForBilling(){
        
        if versionOb < 4 {
            return
        }
        
        if !DataManager.isPaymentBtnAddCustomer {
            return
        }
        
        if billingAddressTextField.text == "" && billingAddress2TextField.text == "" {
            self.viewErrorShow.isHidden = false
        }else{
            if billingCityTextField.text == "" || billingStateTextField.text == "" || billingZipTextField.text == "" {
                self.viewErrorShow.isHidden = false
            }else{
                self.viewErrorShow.isHidden = true
            }
        }
        
        if billingFirstNameTextField.text == "" {
            updateError(textfieldIndex: 9, message: "Please enter First Name.")
        }else{
            billingFirstNameTextField.resetCustomError()
            
        }
        if billingLastNameTextField.text == "" {
            updateError(textfieldIndex: 10, message: "Please enter Last Name.")
        }else{
            billingLastNameTextField.resetCustomError()
        }
        
        
        if billingCompanyTextField.text == ""{
            updateError(textfieldIndex: 11, message: "Please enter Company Name.")
        }else{
            billingCompanyTextField.resetCustomError()
            billingLastNameTextField.resetCustomError()
            billingFirstNameTextField.resetCustomError()
        }
        
        if (billingCompanyTextField.text != "") || (billingFirstNameTextField.text != "" && billingLastNameTextField.text != ""){
            billingLastNameTextField.resetCustomError()
            billingFirstNameTextField.resetCustomError()
            billingCompanyTextField.resetCustomError()
            firstNameTextField.resetCustomError()
            lastNameTextField.resetCustomError()
            if billingCompanyTextField.text != "" {
                firstNameTextField.resetCustomError()
                lastNameTextField.resetCustomError()
            } else {
                
                if firstNameTextField.text == "" {
                    updateError(textfieldIndex: 12, message: "Please enter First Name.")
                }
                if lastNameTextField.text == "" {
                    updateError(textfieldIndex: 13, message: "Please enter Last Name.")
                }
                
            }
        } else if (billingCompanyTextField.text != "") && (billingFirstNameTextField.text != "" && billingLastNameTextField.text != "") {
            billingLastNameTextField.resetCustomError()
            billingFirstNameTextField.resetCustomError()
            billingCompanyTextField.resetCustomError()
            firstNameTextField.resetCustomError()
            lastNameTextField.resetCustomError()
        } else if (billingCompanyTextField.text != "") {
            firstNameTextField.resetCustomError()
            lastNameTextField.resetCustomError()
        } else if (firstNameTextField.text != "" && lastNameTextField.text != "") {
            billingCompanyTextField.resetCustomError()
            //updateError(textfieldIndex: 11, message: "Please enter Company Name.")
        } else {
            updateError(textfieldIndex: 11, message: "Please enter Company Name.")
            if firstNameTextField.text == "" {
                updateError(textfieldIndex: 12, message: "Please enter First Name.")
            }
            if lastNameTextField.text == "" {
                updateError(textfieldIndex: 13, message: "Please enter Last Name.")
            }
        }
        
        if billingAddressTextField.text == "" && billingAddress2TextField.text == "" {
            updateError(textfieldIndex: 1, message: "Please enter customer Address.")
        }else{
            billingAddressTextField.resetCustomError()
            billingAddress2TextField.resetCustomError()
        }
        
        if billingAddressTextField.text == "" {
            updateError(textfieldIndex: 1, message: "Please enter customer Address.")
        }else{
            billingAddressTextField.resetCustomError()
        }
        
        if billingCityTextField.text == ""{
            updateError(textfieldIndex: 2, message: "Please enter customer City.")
        }else{
            billingCityTextField.resetCustomError()
        }
        if billingStateTextField.text == ""{
            updateError(textfieldIndex: 3, message: "Please select State.")
        }else{
            billingStateTextField.resetCustomError()
        }
        if billingZipTextField.text == ""{
            updateError(textfieldIndex: 4, message: "Please enter Zip Code.")
        }else{
            billingZipTextField.resetCustomError()
        }
        
        
        //Add  FN LN And C error
    }
    
    func customerInformationErrorShowForShipping(){
        
        if versionOb < 4 {
            return
        }
        
        if !DataManager.isPaymentBtnAddCustomer {
            return
        }
        
        if addressTextField.text == "" && address2TextField.text == "" {
            self.viewErrorShow.isHidden = false
        }else{
            if cityTextField.text == "" || stateTextField.text == "" || zipTextField.text == "" {
                self.viewErrorShow.isHidden = false
            }else{
                self.viewErrorShow.isHidden = true
            }
        }
        
        if firstNameTextField.text == ""{
            updateError(textfieldIndex: 12, message: "Please enter First Name.")
        }else{
            firstNameTextField.resetCustomError()
        }
        if lastNameTextField.text == ""{
            updateError(textfieldIndex: 13, message: "Please enter Last Name.")
        }else{
            lastNameTextField.resetCustomError()
        }
        if addressTextField.text == "" && address2TextField.text == "" {
            updateError(textfieldIndex: 5, message: "Please enter customer Address.")
        }else {
            addressTextField.resetCustomError()
            address2TextField.resetCustomError()
        }
        if cityTextField.text == ""{
            updateError(textfieldIndex: 6, message: "Please enter customer City.")
        }else{
            cityTextField.resetCustomError()
        }
        if stateTextField.text == ""{
            updateError(textfieldIndex: 7, message: "Please select State.")
        }else {
            stateTextField.resetCustomError()
        }
        if zipTextField.text == ""{
            updateError(textfieldIndex: 8, message: "Please enter Zip Code.")
        }else{
            zipTextField.resetCustomError()
        }
        //Add  FN LN And C error
    }
    func resetCustomerInfromationError(){
        billingAddressTextField.resetCustomError()
        billingAddress2TextField.resetCustomError()
        billingCityTextField.resetCustomError()
        billingStateTextField.resetCustomError()
        billingZipTextField.resetCustomError()
        billingCompanyTextField.resetCustomError()
        billingLastNameTextField.resetCustomError()
        billingFirstNameTextField.resetCustomError()
        
        
        addressTextField.resetCustomError()
        address2TextField.resetCustomError()
        cityTextField.resetCustomError()
        stateTextField.resetCustomError()
        zipTextField.resetCustomError()
        firstNameTextField.resetCustomError()
        lastNameTextField.resetCustomError()
        
        //Add  FN LN And C error for reset
        
    }
    func resetCustomerBilingInfromationError (){
        billingAddressTextField.resetCustomError()
        billingAddress2TextField.resetCustomError()
        billingCityTextField.resetCustomError()
        billingStateTextField.resetCustomError()
        billingZipTextField.resetCustomError()
        //  billingCompanyTextField.resetCustomError()
        billingLastNameTextField.resetCustomError()
        billingFirstNameTextField.resetCustomError()
        //Add  FN LN And C error for reset
    }
    
    
    func updateError(textfieldIndex: Int, message: String) {
        //Add  FN LN And C error for update
        switch textfieldIndex {
        case 1:
            billingAddressTextField.setCustomError(text: message, bottomSpace: 2.0)
            break
        case 2:
            billingCityTextField.setCustomError(text: message, bottomSpace: 2)
            break
        case 3:
            billingStateTextField.setCustomError(text: message, bottomSpace: 2)
            break
        case 4:
            billingZipTextField.setCustomError(text: message, bottomSpace: 2)
            break
        case 5:
            addressTextField.setCustomError(text: message, bottomSpace: 2.0)
            break
        case 6:
            cityTextField.setCustomError(text: message, bottomSpace: 2)
            break
        case 7:
            stateTextField.setCustomError(text: message, bottomSpace: 2)
            break
        case 8:
            zipTextField.setCustomError(text: message, bottomSpace: 2)
            break
        case 9:
            billingFirstNameTextField.setCustomError(text: message, bottomSpace: 4)
            break
        case 10:
            billingLastNameTextField.setCustomError(text: message, bottomSpace: 4)
            break
        case 11:
            billingCompanyTextField.setCustomError(text: message, bottomSpace: 2)
            break
        case 12:
            firstNameTextField.setCustomError(text: message, bottomSpace: 2)
            break
        case 13:
            lastNameTextField.setCustomError(text: message, bottomSpace: 2)
            break
        case 14:
            officePhoneTextField.setCustomError(text: message, bottomSpace: 2)
        case 15:
            contactSourceTextField.setCustomError(text: message, bottomSpace: 2)
            
        default: break
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.recentUIVIewController?.dismiss(animated: true, completion: nil)
        emailTextField.updateCustomBorder()
        billingEmailTextField.updateCustomBorder()
        stateTextField.updateCustomBorder()
        billingStateTextField.updateCustomBorder()
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        self.searchTextField.returnKeyType = .search
        //Set Offset
        onLineFetchLimit = 30
        selectCustomerTabelView.tableFooterView = UIView()
        self.segmentView.isHidden = iPadSelectCustomerViewController.selectCustomerViewType == .selectOrNew ? false : true
        self.isBillingSameShippingButton.isSelected = DataManager.isCheckUncheckShippingBilling
        self.isBillingSameShippingTextButton.isSelected = DataManager.isCheckUncheckShippingBilling
        self.shippingView.isHidden = DataManager.isCheckUncheckShippingBilling
        //self.emailTextField.isHidden = DataManager.isCheckUncheckShippingBilling
        
        self.stateTextField.isHidden = DataManager.isCheckUncheckShippingBilling
        self.stateDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
        
        self.countryTextField.isHidden = DataManager.isCheckUncheckShippingBilling
        self.countryLineView.isHidden = DataManager.isCheckUncheckShippingBilling
        self.countryDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
        
        if !DataManager.isShowCountry {
            self.countryTextField.isHidden = true
            self.countryLineView.isHidden = true
            self.countryDropDownImg.isHidden = true
        }
        officePhoneTextField.keyboardType = .asciiCapableNumberPad
        if selectedUser.str_userID == "" {
            billingStateTextField.text = DataManager.posDropdownDefaultRegionState
            stateTextField.text = DataManager.posDropdownDefaultRegionState
        }
        // callForAllCustValidation()
    }
    //for custom text view hide / show
    private func customText1AndCustomText2View() {
        if DataManager.customFieldShow {
            billingCustom1And2MainView.isHidden = false
            billingStackViewHeightContraint.constant = 391
            billingCustom1TextField.placeholder = DataManager.customText1Label ?? ""
            billingCustom2TextField.placeholder = DataManager.customText2Label ?? ""
            
            billingCustom1TextField.attributedPlaceholder = NSAttributedString(string: DataManager.customText1Label ?? "",
                                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            billingCustom2TextField.attributedPlaceholder = NSAttributedString(string: DataManager.customText2Label ?? "",
                                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            
            if DataManager.customText1Type == "date" {
                customText1CalenderImg.isHidden = false
            }else{
                customText1CalenderImg.isHidden = true
            }
            
            
            if DataManager.customText2Type == "date" {
                customText2CalenderImg.isHidden = false
            }else{
                customText2CalenderImg.isHidden = true
            }
            
        }else{
            
            billingStackViewHeightContraint.constant = 350
            billingCustom1And2MainView.isHidden = true
            customText2CalenderImg.isHidden = true
            customText1CalenderImg.isHidden = true
        }
        if !DataManager.isShowCountry {
            self.countryTextField.isHidden = true
            self.countryLineView.isHidden = true
            self.countryDropDownImg.isHidden = true
        }
    }
    
    
    
    
    
    private func updateCountryFields() {
        if DataManager.isShowCountry {
            self.countryTextField.isHidden = false
            self.billingCountryLineView.isHidden = false
            self.countryTextField.text = DataManager.selectedCountry
            
            self.billingCountryTextField.isHidden = false
            self.countryLineView.isHidden = false
            self.countryDropDownImg.isHidden = false
            self.billingCountryDropDownImg.isHidden = false
            self.billingCountryTextField.text = DataManager.selectedCountry
            
        }else {
            self.countryTextField.isHidden = true
            self.billingCountryLineView.isHidden = true
            self.countryTextField.text = ""
            
            self.billingCountryTextField.isHidden = true
            self.countryLineView.isHidden = true
            self.countryDropDownImg.isHidden = true
            self.billingCountryDropDownImg.isHidden = true
            self.billingCountryTextField.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectShippingAddress"
        {
            let vc = segue.destination as! SelectShippingAddressVc
            vc.shippingDelegate = self
            addressShipping = vc
        }
    }
    
    private func setPlaceholderColor() {
        //Shipping
        //by anand
        officePhoneTextField.setPlaceholder()
        contactSourceTextField.setPlaceholder()
        //end anand
        firstNameTextField.setPlaceholder()
        lastNameTextField.setPlaceholder()
        emailTextField.setPlaceholder()
        phoneTextField.setPlaceholder()
        addressTextField.setPlaceholder()
        address2TextField.setPlaceholder()
        cityTextField.setPlaceholder()
        stateTextField.setPlaceholder()
        zipTextField.setPlaceholder()
        countryTextField.setPlaceholder()
        selectCustomerStatusTextField.setPlaceholder()
        //Billing
        billingFirstNameTextField.setPlaceholder()
        billingLastNameTextField.setPlaceholder()
        billingEmailTextField.setPlaceholder()
        billingPhoneTextField.setPlaceholder()
        billingCompanyTextField.setPlaceholder()
        billingAddressTextField.setPlaceholder()
        billingAddress2TextField.setPlaceholder()
        billingCityTextField.setPlaceholder()
        billingStateTextField.setPlaceholder()
        billingZipTextField.setPlaceholder()
        billingCountryTextField.setPlaceholder()
        billingCustom1TextField.setPlaceholder()
        billingCustom2TextField.setPlaceholder()
    }
    
    private func hideLineView(isNewselected: Bool) {
        if isNewselected {
            newCustomerButton.layer.borderColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0).cgColor
            selectCustomerButton.layer.borderColor = UIColor.lightGray.cgColor
            
            newCustomerButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            selectCustomerButton.backgroundColor = UIColor.white
            
            newCustomerButton.setTitleColor(UIColor.white, for: .normal)
            selectCustomerButton.setTitleColor(UIColor.lightGray, for: .normal)
        } else {
            
            selectCustomerButton.layer.borderColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0).cgColor
            newCustomerButton.layer.borderColor = UIColor.lightGray.cgColor
            
            newCustomerButton.backgroundColor = UIColor.white
            selectCustomerButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            
            newCustomerButton.setTitleColor(UIColor.lightGray, for: .normal)
            selectCustomerButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    private func fillUserData(data: CustomerListModel) {
        //Shipping
        //firstNameTextField.text = data.str_shipping_first_name
        firstNameTextField.text = data.str_shipping_first_name != "" ? data.str_shipping_first_name : data.str_first_name
        
        lastNameTextField.text = data.str_shipping_last_name != "" ? data.str_shipping_last_name : data.str_last_name
        
        //lastNameTextField.text = data.str_shipping_last_name
        emailTextField.text = data.str_Shippingemail != "" ? data.str_Shippingemail : data.str_email
        let phone = data.str_Shippingphone != "" ? data.str_Shippingphone : data.str_phone
        phoneTextField.text = formattedPhoneNumber(number: phone)
        
        addressTextField.text = data.str_Shippingaddress
        address2TextField.text = data.str_Shippingaddress2
        cityTextField.text = data.str_Shippingcity
        stateTextField.text = data.str_Shippingregion
        zipTextField.text = formattedZIPCodeNumber(number: data.str_Shippingpostal_code)
        countryTextField.text = data.shippingCountry
        contactSourceTextField.text = data.str_contact_source
        if data.str_customer_status == "" {
            selectCustomerStatusTextField.text = DataManager.customerStatusDefaultName
        } else {
            selectCustomerStatusTextField.text = data.str_customer_status
        }
        let officePhone = data.str_office_phone
        officePhoneTextField.text = formattedPhoneNumber(number: officePhone)
        //Billing
        billingFirstNameTextField.text = data.str_billing_first_name
        billingLastNameTextField.text = data.str_billing_last_name
        billingEmailTextField.text = data.str_Billingemail
        billingPhoneTextField.text = formattedPhoneNumber(number: data.str_Billingphone)
        billingCompanyTextField.text = data.str_company
        billingAddressTextField.text = data.str_Billingaddress
        billingAddress2TextField.text = data.str_Billingaddress2
        billingCityTextField.text = data.str_Billingcity
        billingStateTextField.text = data.str_Billingregion
        billingZipTextField.text = formattedZIPCodeNumber(number: data.str_Billingpostal_code)
        billingCountryTextField.text = data.billingCountry
        billingCustom1TextField.text = data.str_CustomText1
        //billingCustom2TextField.text = data.str_CustomText2
        if data.str_userID != "" || data.str_Billingregion != "" {
            billingStateTextField.text = data.str_Billingregion
        }else {
            billingStateTextField.text = DataManager.posDropdownDefaultRegionState
            stateTextField.text = DataManager.posDropdownDefaultRegionState
        }
        if DataManager.customText2Type == "numeric" {
            billingCustom2TextField.text = formattedPhoneNumber(number: data.str_CustomText2)
        }else{
            billingCustom2TextField.text = data.str_CustomText2
        }
                
        if DataManager.customerObj == nil && DataManager.isPaymentBtnAddCustomer == false {
            iPadSelectCustomerViewController.isSelectCustomerOpen = true
            self.selectCustomerTabelView.reloadData()
            self.newCustomerView.isHidden = true
            self.selectCustomerButton.setTitleColor(UIColor.white, for: .normal)
            self.selectCustomerButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            self.newCustomerButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
            self.newCustomerButton.backgroundColor = UIColor.white
            self.hideLineView(isNewselected: false)
            
            ////            iPadSelectCustomerViewController.isSelectCustomerOpen = false
            ////            self.newCustomerView.isHidden = false
            ////            self.doneCancelView.isHidden = false
            ////            self.newCustomerButton.setTitleColor(UIColor.white, for: .normal)
            ////            self.newCustomerButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            ////            self.selectCustomerButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
            ////            self.selectCustomerButton.backgroundColor = UIColor.white
            ////            self.hideLineView(isNewselected: true)

        } else {
            iPadSelectCustomerViewController.isSelectCustomerOpen = false
            //Set UI
            if  str_CustomerTag == "" {
                self.newCustomerView.isHidden = false
            }else{
                self.newCustomerView.isHidden = true
            }
            self.newCustomerView.isHidden = false
            self.doneCancelView.isHidden = false
            self.newCustomerButton.setTitleColor(UIColor.white, for: .normal)
            self.newCustomerButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            self.selectCustomerButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
            self.selectCustomerButton.backgroundColor = UIColor.white
            self.hideLineView(isNewselected: true)
        }
        
        if data.str_userID == "" {
            self.countryTextField.text = self.countryTextField.isEmpty ? DataManager.selectedCountry : self.countryTextField.text
            self.billingCountryTextField.text = self.billingCountryTextField.isEmpty ? DataManager.selectedCountry : self.billingCountryTextField.text
        }
        
        //        if billingCompanyTextField.text == ""{
        //            updateError(textfieldIndex: 11, message: "Please enter Company Name.")
        //        }else{
        //            billingCompanyTextField.resetCustomError()
        //        }
    }
    
    private func getNewData(customerList: CustomerListModel) -> CustomerListModel {
        let data = customerList
        //Shipping
        data.str_shipping_first_name = firstNameTextField.text ?? ""
        data.str_shipping_last_name = lastNameTextField.text ?? ""
        data.str_Shippingemail = emailTextField.text ?? ""
        data.str_Shippingphone = phoneNumberFormateRemoveText(number: phoneTextField.text!)
        data.str_Shippingaddress = addressTextField.text ?? ""
        data.str_Shippingaddress2 = address2TextField.text ?? ""
        data.str_Shippingcity = cityTextField.text ?? ""
        data.str_Shippingregion = stateTextField.text ?? ""
        data.str_Shippingpostal_code = zipTextField.text?.replacingOccurrences(of: "-", with: "") ?? ""
        data.str_office_phone = phoneNumberFormateRemoveText(number: officePhoneTextField.text!)//officePhoneTextField.text ?? ""
        data.str_contact_source = contactSourceTextField.text ?? ""
        data.str_customer_status = selectCustomerStatusTextField.text ?? ""
        data.shippingCountry = countryTextField.text ?? ""
        //Billing
        data.str_CustomText1 = billingCustom1TextField.text ?? ""
        //data.str_CustomText2 = billingCustom2TextField.text ?? ""
        if DataManager.customText2Type == "numeric"  {
            data.str_CustomText2 = phoneNumberFormateRemoveText(number: billingCustom2TextField.text!)
        }else{
            data.str_CustomText2 = billingCustom2TextField.text ?? ""
        }
        data.str_billing_first_name = billingFirstNameTextField.text ?? ""
        data.str_billing_last_name = billingLastNameTextField.text ?? ""
        data.str_Billingemail = billingEmailTextField.text ?? ""
        data.str_Billingphone = phoneNumberFormateRemoveText(number: billingPhoneTextField.text!)
        data.str_company = billingCompanyTextField.text ?? ""
        data.str_Billingaddress = billingAddressTextField.text ?? ""
        data.str_Billingaddress2 = billingAddress2TextField.text ?? ""
        data.str_Billingcity = billingCityTextField.text ?? ""
        data.str_Billingregion = billingStateTextField.text ?? ""
        data.str_Billingpostal_code = billingZipTextField.text?.replacingOccurrences(of: "-", with: "") ?? ""
        data.billingCountry = billingCountryTextField.text ?? ""
        //First & last Name
        data.str_first_name = billingFirstNameTextField.text ?? ""
        data.str_last_name = billingLastNameTextField.text ?? ""
        data.str_email = billingEmailTextField.text ?? ""
        data.str_phone = phoneNumberFormateRemoveText(number: billingPhoneTextField.text!)
        data.str_company = billingCompanyTextField.text ?? ""
        data.str_address = billingAddressTextField.text ?? ""
        data.str_address2 = billingAddress2TextField.text ?? ""
        data.str_city = billingCityTextField.text ?? ""
        data.str_region = billingStateTextField.text ?? ""
        data.str_postal_code = billingZipTextField.text?.replacingOccurrences(of: "-", with: "") ?? ""
        data.country = billingCountryTextField.text ?? ""
        //
        data.userCoupan = customerList.userCoupan
        data.userCustomTax = customerList.userCustomTax
        data.cardDetail = customerList.cardDetail
        data.isDataAdded = customerList.isDataAdded
        data.str_bpid = customerList.str_bpid
        data.str_display_name = customerList.str_display_name
        data.str_order_id = customerList.str_order_id
        data.str_userID = customerList.str_userID
        
        return data
    }
    
    private func updateShippingAddress() {
        if isUserDataSelected {
            return
        }
        firstNameTextField.text = billingFirstNameTextField.text
        lastNameTextField.text = billingLastNameTextField.text
        emailTextField.text = billingEmailTextField.text
        phoneTextField.text = billingPhoneTextField.text
    }
    
    //MARK: IBAction Method
    
    @IBAction func actionCallTfValidationForBilling(_ sender: UITextField) {
        
        if DataManager.isshipOrderButton  {
            if DataManager.isPaymentBtnAddCustomer {
                callvalidationforBilling()
            }
            
        }
    }
    
    
    @IBAction func actionCallTfValidationForShipping(_ sender: UITextField) {
        if DataManager.isshipOrderButton  {
            if DataManager.isPaymentBtnAddCustomer {
                callValidationForShipping()
            }
        }
    }
    
    func callValidationForShipping() {
        
        if versionOb < 4 {
            return
        }
        
        if !DataManager.isPaymentBtnAddCustomer {
            return
        }
        
        if firstNameTextField.text == "" {
            updateError(textfieldIndex: 12, message: "Please enter First Name.")
        } else {
            firstNameTextField.resetCustomError()
        }
        if lastNameTextField.text == "" {
            updateError(textfieldIndex: 13, message: "Please enter Last Name.")
        } else {
            lastNameTextField.resetCustomError()
        }
        if firstNameTextField.text == "" || lastNameTextField.text == ""{
            
            if (billingFirstNameTextField.text == "" || billingLastNameTextField.text == "") {
                if billingCompanyTextField.text == ""{
                    updateError(textfieldIndex: 11, message: "Please enter Company Name.")
                }else{
                    billingCompanyTextField.resetCustomError()
                    lastNameTextField.resetCustomError()
                    firstNameTextField.resetCustomError()
                }
            } else if billingCompanyTextField.text != "" {
                billingCompanyTextField.resetCustomError()
                lastNameTextField.resetCustomError()
                firstNameTextField.resetCustomError()
            } else {
                billingCompanyTextField.resetCustomError()
            }
        }else{
            billingCompanyTextField.resetCustomError()
            lastNameTextField.resetCustomError()
            firstNameTextField.resetCustomError()
        }
        if addressTextField.text == "" {
            updateError(textfieldIndex: 5, message: "Please enter customer Address.")
        } else {
            addressTextField.resetCustomError()
        }
        if cityTextField.text == ""{
            updateError(textfieldIndex: 6, message: "Please enter customer City.")
        }else{
            cityTextField.resetCustomError()
        }
        if stateTextField.text == ""{
            updateError(textfieldIndex: 7, message: "Please select State.")
        }else {
            stateTextField.resetCustomError()
        }
        if zipTextField.text == ""{
            updateError(textfieldIndex: 8, message: "Please enter Zip Code.")
        }else{
            zipTextField.resetCustomError()
        }
        
        if zipTextField.text != "" && cityTextField.text != "" && (addressTextField.text != "") && billingCompanyTextField.text != "" {
            viewErrorShow.isHidden = true
        } else if zipTextField.text != "" && cityTextField.text != "" && (addressTextField.text != "") && firstNameTextField.text != "" && lastNameTextField.text != "" {
            viewErrorShow.isHidden = true
        } else {
            viewErrorShow.isHidden = false
        }
        
        billingFirstNameTextField.resetCustomError()
        billingLastNameTextField.resetCustomError()
        billingCityTextField.resetCustomError()
    }
    
    func callvalidationforBilling(){
        
        if versionOb < 4 {
            return
        }
        if !DataManager.isPaymentBtnAddCustomer {
            return
        }
        
        if DataManager.isCheckUncheckShippingBilling{
            if billingCompanyTextField.text != "" {
                billingLastNameTextField.resetCustomError()
                billingFirstNameTextField.resetCustomError()
                billingCompanyTextField.resetCustomError()
                firstNameTextField.resetCustomError()
                lastNameTextField.resetCustomError()
                
            } else if (billingFirstNameTextField.text == "" && billingLastNameTextField.text == "" && billingCompanyTextField.text == "") {
                updateError(textfieldIndex: 9, message: "Please enter First Name.")
                updateError(textfieldIndex: 10, message: "Please enter Last Name.")
                updateError(textfieldIndex: 11, message: "Please enter Company Name.")
                //billingLastNameTextField.setCustomError(text: "Please enter Last Name.", bottomSpace: 2)
                //billingFirstNameTextField.setCustomError(text: "Please enter First Name.", bottomSpace: 2)
                //billingCompanyTextField.setCustomError(text: "Please enter Company Name.", bottomSpace: 2)
            } else if (billingFirstNameTextField.text == "" && billingLastNameTextField.text == "") && billingCompanyTextField.text != "" {
                billingLastNameTextField.resetCustomError()
                billingFirstNameTextField.resetCustomError()
                billingCompanyTextField.resetCustomError()
            } else if (billingFirstNameTextField.text != "" && billingLastNameTextField.text != "") && billingCompanyTextField.text == "" {
                billingLastNameTextField.resetCustomError()
                billingFirstNameTextField.resetCustomError()
                billingCompanyTextField.resetCustomError()
            } else if billingFirstNameTextField.text != "" {
                billingFirstNameTextField.resetCustomError()
                updateError(textfieldIndex: 10, message: "Please enter Last Name.")
                updateError(textfieldIndex: 11, message: "Please enter Company Name.")
                //billingLastNameTextField.setCustomError(text: "Please enter Last Name.", bottomSpace: 2)
                //billingCompanyTextField.setCustomError(text: "Please enter Company Name.", bottomSpace: 2)
            } else if billingLastNameTextField.text != ""{
                billingLastNameTextField.resetCustomError()
                updateError(textfieldIndex: 9, message: "Please enter First Name.")
                updateError(textfieldIndex: 11, message: "Please enter Company Name.")
                //billingFirstNameTextField.setCustomError(text: "Please enter First Name.", bottomSpace: 2)
                //billingCompanyTextField.setCustomError(text: "Please enter Company Name.", bottomSpace: 2)
            }
            if contactSourceTextField.text == ""{
                updateError(textfieldIndex: 15, message: "Please enter Contact Source.")
            }else{
                contactSourceTextField.resetCustomError()
            }
            if officePhoneTextField.text == ""{
                updateError(textfieldIndex: 14, message: "Please enter Office Phone.")
            }else{
                officePhoneTextField.resetCustomError()
            }
            if billingAddressTextField.text == "" {
                updateError(textfieldIndex: 1, message: "Please enter customer Address.")
            }else{
                billingAddressTextField.resetCustomError()
            }
            
            if billingCityTextField.text == "" {
                updateError(textfieldIndex: 2, message: "Please enter customer City.")
            } else {
                billingCityTextField.resetCustomError()
            }
            
            if billingZipTextField.text == ""{
                updateError(textfieldIndex: 4, message: "Please enter Zip Code.")
            }else{
                billingZipTextField.resetCustomError()
            }
            
            if billingStateTextField.text == ""{
                updateError(textfieldIndex: 3, message: "Please select State.")
            }else{
                billingStateTextField.resetCustomError()
            }
            
            if billingZipTextField.text != "" && billingCityTextField.text != "" && (billingAddressTextField.text != "") && billingCompanyTextField.text != "" && billingStateTextField.text != "" {
                viewErrorShow.isHidden = true
            } else if billingZipTextField.text != "" && billingCityTextField.text != "" && (billingAddressTextField.text != "") && billingFirstNameTextField.text != "" && billingLastNameTextField.text != "" && billingStateTextField.text != "" {
                viewErrorShow.isHidden = true
            } else {
                viewErrorShow.isHidden = false
            }
            
        }
        else {
            if (billingCompanyTextField.text != "") || (billingFirstNameTextField.text != "" && billingLastNameTextField.text != ""){
                billingLastNameTextField.resetCustomError()
                billingFirstNameTextField.resetCustomError()
                billingCompanyTextField.resetCustomError()
                firstNameTextField.resetCustomError()
                lastNameTextField.resetCustomError()
                if billingCompanyTextField.text != "" {
                    firstNameTextField.resetCustomError()
                    lastNameTextField.resetCustomError()
                } else {
                    
                    if firstNameTextField.text == "" {
                        updateError(textfieldIndex: 12, message: "Please enter First Name.")
                    }
                    if lastNameTextField.text == "" {
                        updateError(textfieldIndex: 13, message: "Please enter Last Name.")
                    }
                    
                }
            } else if (billingCompanyTextField.text != "") && (billingFirstNameTextField.text != "" && billingLastNameTextField.text != "") {
                billingLastNameTextField.resetCustomError()
                billingFirstNameTextField.resetCustomError()
                billingCompanyTextField.resetCustomError()
                firstNameTextField.resetCustomError()
                lastNameTextField.resetCustomError()
            } else if (billingCompanyTextField.text != "") {
                firstNameTextField.resetCustomError()
                lastNameTextField.resetCustomError()
            } else if (firstNameTextField.text != "" && lastNameTextField.text != "") {
                billingCompanyTextField.resetCustomError()
                //updateError(textfieldIndex: 11, message: "Please enter Company Name.")
            } else {
                updateError(textfieldIndex: 11, message: "Please enter Company Name.")
                if firstNameTextField.text == "" {
                    updateError(textfieldIndex: 12, message: "Please enter First Name.")
                }
                if lastNameTextField.text == "" {
                    updateError(textfieldIndex: 13, message: "Please enter Last Name.")
                }
            }
            
            if zipTextField.text != "" && cityTextField.text != "" && (addressTextField.text != "") && billingCompanyTextField.text != "" && stateTextField.text != "" {
                viewErrorShow.isHidden = true
            } else if zipTextField.text != "" && cityTextField.text != "" && (addressTextField.text != "") && firstNameTextField.text != "" && lastNameTextField.text != "" && stateTextField.text != "" {
                viewErrorShow.isHidden = true
            } else {
                viewErrorShow.isHidden = false
            }
        }
        
        //        if billingCityTextField.text != "" && billingStateTextField.text != "" && billingZipTextField.text != "" {
        //            self.viewErrorShow.isHidden = true
        //        } else {
        //            self.viewErrorShow.isHidden = false
        //        }
        
        
    }
    
    @IBAction func actionSelectShipAddress(_ sender: Any) {
        
        addressShipping?.didCallAPIShipping!(strID: DataManager.customerForShippingAddressId)
        self.viewSelectShippingAddress.isHidden = false
    }
    
    @IBAction func newCustomerButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        iPadSelectCustomerViewController.isSelectCustomerOpen = false
        btnSelectShipAddress.isHidden = true
        //Set UI
        self.newCustomerView.isHidden = false
        self.doneCancelView.isHidden = false
        self.newCustomerButton.setTitleColor(UIColor.white, for: .normal)
        self.newCustomerButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1) //UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
        self.selectCustomerButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
        self.selectCustomerButton.backgroundColor = UIColor.white
        self.hideLineView(isNewselected: true)
        addCustomer = ""
        DataManager.customerId = ""
        if HomeVM.shared.customerUserId != "" {
            DataManager.customerId = HomeVM.shared.customerUserId
        }
        //DataManager.customerId = ""
        isUserSelected = false
        isUserDataSelected = false
        selectedUser = CustomerListModel()
        //        self.fillUserData(data: selectedUser)
        DataManager.selectedCustomer = nil
        //        customerDelegate?.didAddNewCustomer?()
        
        //        DataManager.isCheckUncheckShippingBilling = true
        //        self.isBillingSameShippingButton.isSelected = true
        //        shippingView.isHidden = DataManager.isCheckUncheckShippingBilling
        
        self.isBillingSameShippingButton.isSelected = true
        self.isBillingSameShippingTextButton.isSelected = true
        self.shippingView.isHidden =  true
        self.emailTextField.isHidden =  true
        DataManager.isCheckUncheckShippingBilling = true
        self.stateTextField.isHidden =  true
        self.stateDropDownImg.isHidden =   true
        self.countryTextField.isHidden =  true
        self.countryLineView.isHidden =  true
        self.countryDropDownImg.isHidden  = true
        
        if DataManager.isshipOrderButton {
            callvalidationforBilling()
        }
        
        selectCustomerTabelView.reloadData()
        
    }
    
    @IBAction func selectCustomerButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        iPadSelectCustomerViewController.isSelectCustomerOpen = true
        DataManager.customerId = ""
        if HomeVM.shared.customerUserId != "" {
            DataManager.customerId = HomeVM.shared.customerUserId
        }
        isUserSelected = false
        isUserDataSelected = false
        self.searchTextField.text = ""
        self.isSearching = false
        self.array_CustomerNames.removeAll()
        self.array_CustomersList.removeAll()
        self.array_searchCustomersList.removeAll()
        self.selectCustomerTabelView.reloadData()
        //Set UI
        self.newCustomerView.isHidden = true
        //        self.doneCancelView.isHidden = true
        self.selectCustomerButton.setTitleColor(UIColor.white, for: .normal)
        self.selectCustomerButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1) //UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
        self.newCustomerButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
        self.newCustomerButton.backgroundColor = UIColor.white
        self.hideLineView(isNewselected: false)
    }
    
    @IBAction func didvalueChanged(_ sender: UITextField) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        selectCustomerTabelView.isUserInteractionEnabled = true
        indexofPage = 1
        if (sender.text?.count ?? 0) != 0
        {
            isSearching = true
            //Remove all objects first.
            self.array_searchCustomersList.removeAll()
            self.selectCustomerTabelView.reloadData()
            getSearchCustomersList()
        }
        else
        {
            isSearching = false
            Indicator.isEnabledIndicator = true
            Indicator.sharedInstance.hideIndicator()
            array_searchCustomersList.removeAll()
            selectCustomerTabelView.reloadData()
        }
    }
    
    @IBAction func isBillingSameShippingButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        
        self.isBillingSameShippingButton.isSelected = !self.isBillingSameShippingButton.isSelected
        self.isBillingSameShippingTextButton.isSelected = !self.isBillingSameShippingTextButton.isSelected
        self.shippingView.isHidden = self.isBillingSameShippingButton.isSelected
        //self.emailTextField.isHidden = self.isBillingSameShippingButton.isSelected
        DataManager.isCheckUncheckShippingBilling = self.isBillingSameShippingButton.isSelected
        
        self.stateTextField.isHidden = DataManager.isCheckUncheckShippingBilling
        self.stateDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
        
        self.countryTextField.isHidden = DataManager.isCheckUncheckShippingBilling
        self.countryLineView.isHidden = DataManager.isCheckUncheckShippingBilling
        self.countryDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
        
        if !DataManager.isShowCountry {
            self.countryTextField.isHidden = true
            self.countryLineView.isHidden = true
            self.countryDropDownImg.isHidden = true
        }
        let chck = DataManager.shippingaddressCount > 1
        if !isUserSelected && !chck {
            updateShippingAddress()
        }
        
        if !self.isBillingSameShippingButton.isSelected {
            
            if  DataManager.isPaymentBtnAddCustomer {
                resetCustomerBilingInfromationError()
                customerInformationErrorShowForShipping()
                callValidationForShipping()
            }
            if DataManager.shippingaddressCount > 1{
                btnSelectShipAddress.isHidden = false
            }else{
                btnSelectShipAddress.isHidden = true
            }
        }else{
            if  DataManager.isPaymentBtnAddCustomer {
                customerInformationErrorShowForBilling()
                callvalidationforBilling()
            }
            btnSelectShipAddress.isHidden = true
        }
        
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
            MainSocketManager.shared.connect()
            MainSocketManager.shared.onCustomerFound(CustomerId: DataManager.customerId)
        }
        isMultiShippingAdrs = false
        if DataManager.isshipOrderButton  {
            if  DataManager.isPaymentBtnAddCustomer {
                
                if DataManager.isCheckUncheckShippingBilling {
                    if billingCityTextField.text == "" || billingStateTextField.text == "" || billingZipTextField.text == ""{
                        
                        customerInformationErrorShowForBilling()
                        
                        
                    }else{
                        if (billingAddressTextField.text != "" || billingAddress2TextField.text != "") {
                            iPadSelectCustomerViewController.isSelectCustomerOpen = false
                            DataManager.isCheckUncheckShippingBilling = self.isBillingSameShippingButton.isSelected
                            handledoneAction()
                            
                        }else{
                            customerInformationErrorShowForBilling()
                        }
                    }
                    
                }else{
                    if cityTextField.text == "" || stateTextField.text == "" || zipTextField.text == ""{
                        
                        customerInformationErrorShowForShipping()
                        resetCustomerBilingInfromationError()
                        
                        
                    }else{
                        if (addressTextField.text != "" || address2TextField.text != "") {
                            
                            iPadSelectCustomerViewController.isSelectCustomerOpen = false
                            DataManager.isCheckUncheckShippingBilling = self.isBillingSameShippingButton.isSelected
                            handledoneAction()
                            
                        }else{
                            customerInformationErrorShowForShipping()
                            resetCustomerBilingInfromationError()
                        }
                    }
                    
                }
                
            }else{
                iPadSelectCustomerViewController.isSelectCustomerOpen = false
                DataManager.isCheckUncheckShippingBilling = self.isBillingSameShippingButton.isSelected
                handledoneAction()
            }
            
        } else {
            iPadSelectCustomerViewController.isSelectCustomerOpen = false
            DataManager.isCheckUncheckShippingBilling = self.isBillingSameShippingButton.isSelected
            handledoneAction()
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        isMultiShippingAdrs = false
        selectCustomerStatusTextField.text = self.strCustomeStatusTemp
        if isUserSelected && iPadSelectCustomerViewController.selectCustomerViewType == .selectOrNew {
            self.segmentView.isHidden = false
            //            self.doneCancelView.isHidden = true
            self.newCustomerView.isHidden = true
            selectedUser = CustomerListModel()
            fillUserData(data: selectedUser)
            isUserSelected = false
            isUserDataSelected = false
            iPadSelectCustomerViewController.isSelectCustomerOpen = true
            return
        }
        
        iPadSelectCustomerViewController.isSelectCustomerOpen = false
        
        if firstNameTextField.isEmpty && lastNameTextField.isEmpty && emailTextField.isEmpty && phoneTextField.isEmpty && addressTextField.isEmpty && address2TextField.isEmpty && cityTextField.isEmpty && selectedTextField.isEmpty && zipTextField.isEmpty && billingFirstNameTextField.isEmpty && billingLastNameTextField.isEmpty && billingEmailTextField.isEmpty && billingPhoneTextField.isEmpty && billingCompanyTextField.isEmpty && billingAddressTextField.isEmpty && billingAddress2TextField.isEmpty && billingCityTextField.isEmpty && billingStateTextField.isEmpty && billingZipTextField.isEmpty && billingCustom1TextField.isEmpty && billingCustom2TextField.isEmpty && contactSourceTextField.isEmpty && officePhoneTextField.isEmpty{
            UserDefaults.standard.removeObject(forKey: "CustomerObj")
            UserDefaults.standard.synchronize()
            customerDelegate?.didRefreshNewCustomer?()
            self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
            return
        }
        
        if addCustomer == "" {
            self.customerDelegate?.didCancelButtonTapped?()
            self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
            DataManager.customerId = ""
            if HomeVM.shared.customerUserId != "" {
                DataManager.customerId = HomeVM.shared.customerUserId
            }
            selectCustomerTabelView.reloadData()
        }else {
            handledoneAction()
        }
    }
    
    //Handle Done Button Action
    func handledoneAction() {
        
        if  billingEmailTextField.text != "" && !billingEmailTextField.isValidEmail() {
            billingEmailTextField.setCustomError(text: "Please enter valid email.", bottomSpace: 0)
            return
        }
        
        if !isBillingSameShippingButton.isSelected {
            emailTextField.text = billingEmailTextField.text
            if  emailTextField.text != "" && !emailTextField.isValidEmail() {
                emailTextField.setCustomError(text: "Please enter valid email.", bottomSpace: 0)
                return
            }
        }
        
        if (isUserSelected || selectedUser.str_userID != "") || !firstNameTextField.isEmpty || !lastNameTextField.isEmpty || !emailTextField.isEmpty || !phoneTextField.isEmpty || !addressTextField.isEmpty || !address2TextField.isEmpty || !cityTextField.isEmpty || !(countryTextField.text == DataManager.selectedCountry) || !stateTextField.isEmpty || !zipTextField.isEmpty || !billingFirstNameTextField.isEmpty || !billingLastNameTextField.isEmpty || !billingEmailTextField.isEmpty || !billingPhoneTextField.isEmpty || !billingCompanyTextField.isEmpty || !billingAddressTextField.isEmpty || !billingAddress2TextField.isEmpty || !billingCityTextField.isEmpty || !(billingCountryTextField.text == DataManager.selectedCountry) || !billingStateTextField.isEmpty || !billingZipTextField.isEmpty || !billingCustom1TextField.isEmpty || !billingCustom2TextField.isEmpty || !contactSourceTextField.isEmpty || !officePhoneTextField.isEmpty{
            
            let customerObj: JSONDictionary = ["country": billingCountryTextField.text ?? "", "billingCountry":billingCountryTextField.text ?? "","shippingCountry":countryTextField.text ?? "","coupan": selectedUser.userCoupan, "str_first_name":billingFirstNameTextField.text ?? "", "str_last_name":billingLastNameTextField.text ?? "", "str_address":billingAddressTextField.text ?? "", "str_bpid":selectedUser.str_bpid, "str_city":billingCityTextField.text ?? "", "str_order_id": selectedUser.str_order_id, "str_email":billingEmailTextField.text ?? "", "str_userID":DataManager.customerId, "str_phone":billingPhoneTextField.text ?? "","str_region":billingStateTextField.text ?? "", "str_address2":billingAddress2TextField.text ?? "", "str_Billingcity":billingCityTextField.text ?? "", "str_postal_code":billingZipTextField.text ?? "", "str_Billingphone": billingPhoneTextField.text ?? "", "str_company": billingCompanyTextField.text ?? "", "str_Billingaddress":billingAddressTextField.text ?? "", "str_Billingaddress2":billingAddress2TextField.text ?? "", "str_Billingregion":billingStateTextField.text ?? "", "str_Billingpostal_code":billingZipTextField.text ?? "","shippingPhone": phoneTextField.text ?? "","shippingAddress" : addressTextField.text ?? "", "shippingAddress2": address2TextField.text ?? "", "shippingCity": cityTextField.text ?? "", "shippingRegion" : stateTextField.text ?? "", "shippingPostalCode": zipTextField.text ?? "", "billing_first_name":billingFirstNameTextField.text ?? "", "billing_last_name":billingLastNameTextField.text ?? "","user_custom_tax":selectedUser.userCustomTax,"shipping_first_name":firstNameTextField.text ?? "", "shipping_last_name":lastNameTextField.text ?? "","shippingEmail": emailTextField.text ?? "", "str_Billingemail":billingEmailTextField.text ?? "","str_BillingCustom1TextField": billingCustom1TextField.text ?? "", "str_BillingCustom2TextField": billingCustom2TextField.text ?? "", "loyalty_balance" : selectedUser.doubleloyalty_balance, "emv_card_count": selectedUser.emv_card_Count,"office_phone":officePhoneTextField.text ?? "", "contact_source":contactSourceTextField.text ?? "", "customer_status":selectCustomerStatusTextField.text ?? ""]
            DataManager.customerObj = customerObj
            //DataManager.customerStatusDefaultName = selectCustomerStatusTextField.text ?? ""
            if isUserSelected {
                if isSearching
                {
                    if array_searchCustomersList.count > 0
                    {
                        for list in array_searchCustomersList
                        {
                            if addCustomer == list.str_display_name
                            {
                                UserDefaults.standard.setValue(HieCOR.encode(data: list.cardDetail), forKey: "SelectedCustomer")
                                UserDefaults.standard.synchronize()
                              
                                self.customerDelegate?.didSelectCustomer?(data: self.getNewData(customerList: list))
                            }
                        }
                    }
                }
                else
                {
                    for list in array_CustomersList
                    {
                        if addCustomer == list.str_display_name
                        {
                            UserDefaults.standard.setValue(HieCOR.encode(data: list.cardDetail), forKey: "SelectedCustomer")
                            UserDefaults.standard.synchronize()
                            self.customerDelegate?.didSelectCustomer?(data: self.getNewData(customerList: list))
                        }
                    }
                }
            }
        }
        else{
            let customerObj: JSONDictionary = ["country": billingCountryTextField.text ?? "", "billingCountry":billingCountryTextField.text ?? "","shippingCountry":countryTextField.text ?? "","coupan": selectedUser.userCoupan, "str_first_name":billingFirstNameTextField.text ?? "", "str_last_name":billingLastNameTextField.text ?? "", "str_company": billingCompanyTextField.text ?? "" ,"str_address":billingAddressTextField.text ?? "", "str_bpid":selectedUser.str_bpid, "str_city":billingCityTextField.text ?? "", "str_order_id": selectedUser.str_order_id, "str_email":billingEmailTextField.text ?? "", "str_userID":DataManager.customerId, "str_phone":billingPhoneTextField.text ?? "","str_region":billingStateTextField.text ?? "", "str_address2":billingAddress2TextField.text ?? "", "str_Billingcity":billingCityTextField.text ?? "", "str_postal_code":billingZipTextField.text ?? "", "str_Billingphone": billingPhoneTextField.text ?? "", "str_Billingaddress":billingAddressTextField.text ?? "", "str_Billingaddress2":billingAddress2TextField.text ?? "", "str_Billingregion":billingStateTextField.text ?? "", "str_Billingpostal_code":billingZipTextField.text ?? "","shippingPhone": phoneTextField.text ?? "","shippingAddress" : addressTextField.text ?? "", "shippingAddress2": address2TextField.text ?? "", "shippingCity": cityTextField.text ?? "", "shippingRegion" : stateTextField.text ?? "", "shippingPostalCode": zipTextField.text ?? "", "billing_first_name":billingFirstNameTextField.text ?? "", "billing_last_name":billingLastNameTextField.text ?? "","user_custom_tax":selectedUser.userCustomTax,"shipping_first_name":firstNameTextField.text ?? "", "shipping_last_name":lastNameTextField.text ?? "","shippingEmail": emailTextField.text ?? "", "str_Billingemail":billingEmailTextField.text ?? "",  "str_BillingCustom1TextField": billingCustom1TextField.text ?? "", "str_BillingCustom2TextField": billingCustom2TextField.text ?? "","loyalty_balance" : selectedUser.doubleloyalty_balance, "emv_card_count": selectedUser.emv_card_Count,"office_phone":officePhoneTextField.text ?? "", "contact_source":contactSourceTextField.text ?? "", "customer_status":selectCustomerStatusTextField.text ?? ""]
            DataManager.customerObj = customerObj
        }
        //  callForAllCustValidation()
        customerDelegateForAddNewCustomer?.didRefreshNewCustomer?()
        if str_CustomerTag == "" && !isMultiShippingAdrs{
            self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
        }else if DataManager.showMultipleShippingPopup == "" {
            self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
        }
        
    }
    
    
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
        
        billingCustom1TextField.inputAccessoryView = toolbar
        billingCustom1TextField.inputView = datePicker
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
    }
    
    @objc func donedatePickerCustomText1(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        billingCustom1TextField.text = formatter.string(from: datePicker.date)
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
        
        billingCustom2TextField.inputAccessoryView = toolbar
        billingCustom2TextField.inputView = datePicker
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
    }
    
    @objc func donedatePickerCustomText2(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyym y"
        billingCustom2TextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePickerCustomText2(){
        self.view.endEditing(true)
    }
    
    
    
}

//MARK:- Tableview Datasource and Delegate Methods
extension iPadSelectCustomerViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isSearching
        {
            return array_searchCustomersList.count
        }
        else
        {
            return self.array_CustomersList.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let customerList =  isSearching ? self.array_searchCustomersList[indexPath.row] : self.array_CustomersList[indexPath.row]
        
        let lbl_Name = cell.contentView.viewWithTag(2) as? UILabel
        
        lbl_Name?.text = customerList.str_display_name
        
        let btn_select = cell.contentView.viewWithTag(1) as? UIButton
        btn_select?.isUserInteractionEnabled = false
        if(DataManager.customerId == customerList.str_userID)
        {
            lbl_Name?.textColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            btn_select?.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
        else
        {
            lbl_Name?.textColor = UIColor.black
            btn_select?.setImage(UIImage(named: "radio-unchecked"), for: .normal)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clickedIndex(index: indexPath.row)
    }
    
    func clickedIndex(index: Int) {
        self.view.endEditing(true)
        
        DataManager.isCheckUncheckShippingBilling = true
        
        iPadSelectCustomerViewController.isSelectCustomerOpen = false
        let customerList =  isSearching ? array_searchCustomersList[index] : self.array_CustomersList[index]
        self.addCustomer = customerList.str_display_name
        str_CustomerTag = customerList.str_customerTags
        DataManager.isUserPaxToken = ""
        DataManager.isUserPaxToken = customerList.userPaxToken
        //        print("DataManager.isUserPaxToken",DataManager.isUserPaxToken)
        //        print("customerList.userPaxToken",customerList.userPaxToken)
        //        print("datamanager token enable",DataManager.isPaxTokenEnable)
        
        DataManager.shippingaddressCount = 0
        DataManager.CardCount = 0
        DataManager.EmvCardCount = 0
        DataManager.IngenicoCardCount = 0
        DataManager.Bbpid = ""
        DataManager.customerId = ""
        DataManager.customerId = customerList.str_userID
        DataManager.customerForShippingAddressId = ""
        DataManager.customerForShippingAddressId = customerList.str_userID
        DataManager.CardCount = customerList.cardCount
        DataManager.EmvCardCount = Int(customerList.emv_card_Count)
        DataManager.IngenicoCardCount = Int(customerList.ingenico_card_count)
        DataManager.Bbpid = customerList.str_bpid
        DataManager.shippingaddressCount = customerList.shippingaddressCount ?? 0
        HomeVM.shared.customerUserId = ""
        HomeVM.shared.customerUserId = customerList.str_userID
        isMultiShippingAdrs = customerList.shippingaddressCount ?? 0 > 1
        if  !customerList.str_email.isValidEmail() {
            customerList.str_email = ""
            customerList.str_Shippingemail = ""
            customerList.str_Billingemail = ""
        }
        
        selectCustomerTabelView.reloadData()
        selectedUser = customerList
        isUserSelected = true
        isUserDataSelected = true
        self.fillUserData(data: customerList)
        // self.newCustomerView.isHidden = false
        self.doneCancelView.isHidden = false
        self.segmentView.isHidden = true
        //        customerDelegateForAddNewCustomer?.didRefreshNewCustomer?()
        //        self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
        
        customizeUI()
        customText1AndCustomText2View()
        handledoneAction()
        
        //        if  !customerList.str_email.isValidEmail() {
        //            //billingEmailTextField.setCustomError(text: "Please enter valid email.", bottomSpace: 0)
        //            iPadSelectCustomerViewController.isSelectCustomerOpen = false
        //            btnSelectShipAddress.isHidden = true
        //            //Set UI
        //            self.newCustomerView.isHidden = false
        //            self.doneCancelView.isHidden = false
        //            self.newCustomerButton.setTitleColor(UIColor.white, for: .normal)
        //            self.newCustomerButton.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1) //UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
        //            self.selectCustomerButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
        //            self.selectCustomerButton.backgroundColor = UIColor.white
        //            self.hideLineView(isNewselected: true)
        //            addCustomer = ""
        //            DataManager.customerId = ""
        //            if HomeVM.shared.customerUserId != "" {
        //                DataManager.customerId = HomeVM.shared.customerUserId
        //            }
        //            //DataManager.customerId = ""
        //            isUserSelected = false
        //            isUserDataSelected = false
        //            selectedUser = CustomerListModel()
        //            //        self.fillUserData(data: selectedUser)
        //            DataManager.selectedCustomer = nil
        //            //        customerDelegate?.didAddNewCustomer?()
        //
        //            //        DataManager.isCheckUncheckShippingBilling = true
        //            //        self.isBillingSameShippingButton.isSelected = true
        //            //        shippingView.isHidden = DataManager.isCheckUncheckShippingBilling
        //
        //            self.isBillingSameShippingButton.isSelected = true
        //            self.isBillingSameShippingTextButton.isSelected = true
        //            self.shippingView.isHidden =  true
        //            self.emailTextField.isHidden =  true
        //            DataManager.isCheckUncheckShippingBilling = true
        //            self.stateTextField.isHidden =  true
        //            self.stateDropDownImg.isHidden =   true
        //            self.countryTextField.isHidden =  true
        //            self.countryLineView.isHidden =  true
        //            self.countryDropDownImg.isHidden  = true
        //
        //            if DataManager.isshipOrderButton {
        //                callvalidationforBilling()
        //            }
        //
        //            selectCustomerTabelView.reloadData()
        //            return
        //        }
        if customerList.user_has_open_invoice == "true" {
            print("true")
            if UI_USER_INTERFACE_IDIOM() == .pad {
                //mark: start anand
                let check = DataManager.shippingaddressCount > 1
                DataManager.isCheckUncheckShippingBilling = !check
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "iPad_OrdersHistoryViewController") as! iPad_OrdersHistoryViewController
                if str_CustomerTag == ""{
                    self.navigationController?.pushViewController(controller, animated: true)
                }else{
                    self.closeAlert(title: "Customer Tags Found", message: str_CustomerTag, cancelTitle: "Close", cancelAction: { (_) in
                        self.str_CustomerTag = ""
                        self.navigationController?.pushViewController(controller, animated: true)
                        
                    })
                }
            }
            //end anand            }
        } else {
            if str_CustomerTag != ""{
                self.closeAlert(title: "Customer Tags Found", message: str_CustomerTag, cancelTitle: "Close", cancelAction: { (_) in
                    self.str_CustomerTag = ""
                    if DataManager.shippingaddressCount > 1 && DataManager.showMultipleShippingPopup == "true" {
                        self.isMultiShippingAdrs = true
                        self.addressShipping?.didCallAPIShipping!(strID: DataManager.customerForShippingAddressId)
                        self.viewSelectShippingAddress.isHidden = false
                        self.isBillingSameShippingButton.isSelected = !self.isBillingSameShippingButton.isSelected
                        self.isBillingSameShippingTextButton.isSelected = !self.isBillingSameShippingTextButton.isSelected
                        self.shippingView.isHidden = self.isBillingSameShippingButton.isSelected
                        //self.emailTextField.isHidden = self.isBillingSameShippingButton.isSelected
                        DataManager.isCheckUncheckShippingBilling = self.isBillingSameShippingButton.isSelected
                        
                        self.stateTextField.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.stateDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
                        
                        self.countryTextField.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.countryLineView.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.countryDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
                        if DataManager.shippingaddressCount > 1{
                            self.btnSelectShipAddress.isHidden = false
                        }else{
                            self.btnSelectShipAddress.isHidden = true
                        }
                    }else{
                        self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
                        //  let check = DataManager.shippingaddressCount > 1
                        self.isBillingSameShippingButton.isSelected = true//!check
                        self.isBillingSameShippingTextButton.isSelected = true //!self.isBillingSameShippingTextButton.isSelected
                        self.shippingView.isHidden = self.isBillingSameShippingButton.isSelected
                        //self.emailTextField.isHidden = self.isBillingSameShippingButton.isSelected
                        DataManager.isCheckUncheckShippingBilling = self.isBillingSameShippingButton.isSelected
                        
                        self.stateTextField.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.stateDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
                        
                        self.countryTextField.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.countryLineView.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.countryDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
                        if DataManager.shippingaddressCount > 1{
                            self.btnSelectShipAddress.isHidden = true
                        }else{
                            self.btnSelectShipAddress.isHidden = true
                        }
                    }
                })
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:  {
                    if DataManager.shippingaddressCount > 1 && DataManager.showMultipleShippingPopup == "true" {
                        self.isMultiShippingAdrs = true
                        self.addressShipping?.didCallAPIShipping!(strID: DataManager.customerForShippingAddressId)
                        self.viewSelectShippingAddress.isHidden = false
                        self.isBillingSameShippingButton.isSelected = !self.isBillingSameShippingButton.isSelected
                        self.isBillingSameShippingTextButton.isSelected = !self.isBillingSameShippingTextButton.isSelected
                        self.shippingView.isHidden = self.isBillingSameShippingButton.isSelected
                        //self.emailTextField.isHidden = self.isBillingSameShippingButton.isSelected
                        DataManager.isCheckUncheckShippingBilling = self.isBillingSameShippingButton.isSelected
                        
                        self.stateTextField.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.stateDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
                        
                        self.countryTextField.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.countryLineView.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.countryDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
                        if DataManager.shippingaddressCount > 1{
                            self.btnSelectShipAddress.isHidden = false
                        }else{
                            self.btnSelectShipAddress.isHidden = true
                        }
                    }else{
                        let check = DataManager.shippingaddressCount > 1
                        self.isBillingSameShippingButton.isSelected = true //!check
                        self.isBillingSameShippingTextButton.isSelected = true//!self.isBillingSameShippingTextButton.isSelected
                        self.shippingView.isHidden = self.isBillingSameShippingButton.isSelected
                        //self.emailTextField.isHidden = self.isBillingSameShippingButton.isSelected
                        DataManager.isCheckUncheckShippingBilling = self.isBillingSameShippingButton.isSelected
                        
                        self.stateTextField.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.stateDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
                        
                        self.countryTextField.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.countryLineView.isHidden = DataManager.isCheckUncheckShippingBilling
                        self.countryDropDownImg.isHidden = DataManager.isCheckUncheckShippingBilling
                        if DataManager.shippingaddressCount > 1{
                            self.btnSelectShipAddress.isHidden = true
                        }else{
                            self.btnSelectShipAddress.isHidden = true
                        }
                    }
                    if !DataManager.isShowCountry {
                        self.countryTextField.isHidden = true
                        self.countryLineView.isHidden = true
                        self.countryDropDownImg.isHidden = true
                    }
                })
            }
        }
        //        if !DataManager.isShowCountry {
        //            self.countryTextField.isHidden = true
        //            self.countryLineView.isHidden = true
        //            self.countryDropDownImg.isHidden = true
        //        }
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.onCustomerFound(CustomerId: DataManager.customerId)
        }
    }
    
    //MARK: Scroll View Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if searchTextField.text != "" {
            self.searchTextField.resignFirstResponder()
        }
        let threshold   = isSearching == true ? self.array_searchCustomersList.count : self.array_CustomersList.count ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(fabs(triggerThreshold),1.0);
        if pullRatio >= 1 {
            self.isDataLoading = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if(scrollView == selectCustomerTabelView)
        {
            let contentOffset = scrollView.contentOffset.y;
            let contentHeight = scrollView.contentSize.height;
            let diffHeight = contentHeight - contentOffset;
            let frameHeight = scrollView.bounds.size.height;
            let pullHeight  = fabs(diffHeight - frameHeight);
            if pullHeight == 0.0
            {
                if self.isDataLoading
                {
                    indexofPage = indexofPage + 1
                    
                    if !isLastIndex {
                        isSearching == true ? getSearchCustomersList() : getCustomersList()
                    }
                }else {
                    self.isDataLoading = false
                }
            }
            selectCustomerTabelView.reloadData()
        }
    }
    
}

//MARK: API Methods
extension iPadSelectCustomerViewController {
    
    func getSearchCustomersList() {
        let searchText = (searchTextField.text ?? "")
        
        HomeVM.shared.getSearchCustomer(searchText: searchText, searchFetchLimit: onLineFetchLimit, searchPageCount: indexofPage, responseCallBack: { (success, message, error) in
            if success == 1 {
                //Update Data
                if !HomeVM.shared.isMoreSearchCustomerFound {
                    self.indexofPage = self.indexofPage - 1
                }
                self.array_CustomerNames.removeAll()
                DispatchQueue.main.async {
                    self.array_searchCustomersList = HomeVM.shared.searchCustomerList
                    self.selectCustomerTabelView.reloadData()
                }
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }
            else {
                Indicator.isEnabledIndicator = true
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
    
    func getCustomersList() {
        HomeVM.shared.getCustomerList(indexOfPage: indexofPage, responseCallBack: { (success, message, error) in
            if success == 1 {
                //Update Data
                if !HomeVM.shared.isMoreCustomerFound {
                    self.indexofPage = self.indexofPage - 1
                }
                self.array_CustomerNames.removeAll()
                for data in HomeVM.shared.customerList {
                    self.array_CustomerNames.append(data.str_display_name)
                }
                self.array_CustomersList = HomeVM.shared.customerList
                DispatchQueue.main.async {
                    self.selectCustomerTabelView.reloadData()
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

//MARK: CustomerDelegates
extension iPadSelectCustomerViewController: CustomerDelegates {
    func resetCart() {
        self.viewSelectShippingAddress.isHidden = true
        resetCustomerInfromationError()
        self.viewErrorShow.isHidden = true
        selectedUser = CustomerListModel()
        self.fillUserData(data: selectedUser)
        self.updateView()
        DataManager.selectedCustomer = nil
        customerDelegate?.didAddNewCustomer?()
    }
    
    func didSelectAddCustomerButton() {
        DispatchQueue.main.async {
            self.updateView()
            if DataManager.customerObj == nil || self.selectedUser.str_userID == "" {
                if DataManager.isPaymentBtnAddCustomer {
                    
                }else{
                    self.searchTextField.becomeFirstResponder()
                }
                
            }else{
                self.searchTextField.resignFirstResponder()
            }
            
        }
    }
    
    func didSelectCustomer(data: CustomerListModel) {
        DispatchQueue.main.async {
            //self.searchTextField.becomeFirstResponder()
            iPadSelectCustomerViewController.isSelectCustomerOpen = false
            self.scrollView.scrollToTop()
            self.isUserSelected = false
            self.isUserDataSelected = data.str_bpid != ""
            self.segmentView.isHidden = false
            self.doneCancelView.isHidden = false
            self.newCustomerView.isHidden = false
            self.selectedUser = data
            self.fillUserData(data: data)
            if DataManager.isPaymentBtnAddCustomer {
                if DataManager.isCheckUncheckShippingBilling {
                    self.customerInformationErrorShowForBilling()
                }else{
                    self.customerInformationErrorShowForShipping()
                    self.resetCustomerBilingInfromationError()
                }
                
            }else{
                self.resetCustomerInfromationError()
                self.viewErrorShow.isHidden = true
            }
        }
    }
    
    //Update View Data
    private func updateView() {
        scrollView.scrollToTop()
        
        customText1AndCustomText2View()
        self.array_CustomerNames.removeAll()
        self.array_CustomersList.removeAll()
        self.array_searchCustomersList.removeAll()
        selectCustomerTabelView.reloadData()
        searchTextField.text = ""
        isSearching = false
        searchTextField.resignFirstResponder()
        
        self.segmentView.isHidden = false
        isUserSelected = false
        isUserDataSelected = false
        //Reset UI
        self.newCustomerView.isHidden = false
        self.newCustomerButton.setTitleColor(UIColor.white, for: .normal)
        self.newCustomerButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
        self.selectCustomerButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
        self.selectCustomerButton.backgroundColor = UIColor.white
        selectCustomerTabelView.reloadData()
        iPadSelectCustomerViewController.isSelectCustomerOpen = false
        //self.newCustomerButton.setTitle((DataManager.customerObj == nil && DataManager.customerId == "") ? "New Customer" : "Edit Customer", for: .normal)
        self.newCustomerButton.setTitle((DataManager.customerId == "") ? "New Customer" : "Edit Customer", for: .normal)
        
        //DataManager.isCheckUncheckShippingBilling = self.isBillingSameShippingButton.isSelected
        
        
        self.isBillingSameShippingButton.isSelected = DataManager.isCheckUncheckShippingBilling
        self.isBillingSameShippingTextButton.isSelected = DataManager.isCheckUncheckShippingBilling
        self.shippingView.isHidden =  DataManager.isCheckUncheckShippingBilling
        //self.emailTextField.isHidden =  DataManager.isCheckUncheckShippingBilling
        DataManager.isCheckUncheckShippingBilling = DataManager.isCheckUncheckShippingBilling
        self.stateTextField.isHidden =  DataManager.isCheckUncheckShippingBilling
        self.stateDropDownImg.isHidden =   DataManager.isCheckUncheckShippingBilling
        self.countryTextField.isHidden =  DataManager.isCheckUncheckShippingBilling
        self.countryLineView.isHidden =  DataManager.isCheckUncheckShippingBilling
        self.countryDropDownImg.isHidden  = DataManager.isCheckUncheckShippingBilling
        self.selectCustomerStatusTextField.text = DataManager.customerStatusDefaultName
        if !self.isBillingSameShippingButton.isSelected {
            if DataManager.shippingaddressCount > 1{
                btnSelectShipAddress.isHidden = false
            }else{
                btnSelectShipAddress.isHidden = true
            }
        }else{
            btnSelectShipAddress.isHidden = true
        }
        if !DataManager.isShowCountry {
            self.countryTextField.isHidden = true
            self.countryLineView.isHidden = true
            self.countryDropDownImg.isHidden = true
        }
    }
    func didRefreshNewCustomer() {
        customText1AndCustomText2View()
         checkString1 = DataManager.customText1Label ?? ""
         checkString2 = DataManager.customText2Label ?? ""
    }
}
//MARK: UITextFieldDelegate
extension iPadSelectCustomerViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.hideAssistantBar()
        //textField.resetCustomError(isAddAgain: false)
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        
        if textField == billingEmailTextField || textField == emailTextField {
            //textField.resetCustomError(isAddAgain: false)
        }
        
        if textField == searchTextField {
            //Hide Tool Bar
            let shortcut: UITextInputAssistantItem? = textField.inputAssistantItem
            shortcut?.leadingBarButtonGroups = []
            shortcut?.trailingBarButtonGroups = []
            
            Indicator.isEnabledIndicator = false
            isSearching = true
            DataManager.customerId = ""
            if HomeVM.shared.customerUserId != "" {
                DataManager.customerId = HomeVM.shared.customerUserId
            }
            self.selectCustomerTabelView.reloadData()
            
            if textField.text == "" {
                self.array_searchCustomersList.removeAll()
            }
            self.selectCustomerTabelView.reloadData()
            return
        }
        
        self.selectedTextField = textField
        
        if textField == stateTextField {
            textField.tintColor = UIColor.clear
            textField.resetCustomError(isAddAgain: false)
            textField.resignFirstResponder()
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
            if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (DataManager.isShowCountry ? (countryTextField.text ?? "") : DataManager.selectedCountry)}) {
                let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                    self.stateTextField.text = text
                    self.stateTextField.resetCustomError()
                }
            }else {
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
        
        if textField == billingStateTextField {
            textField.tintColor = UIColor.clear
            //textField.resetCustomError(isAddAgain: false)
            textField.resignFirstResponder()
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
            
            if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (DataManager.isShowCountry ? (billingCountryTextField.text ?? "") : DataManager.selectedCountry)}) {
                let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                    self.billingStateTextField.text = text
                    self.billingStateTextField.resetCustomError()
                }
            }else {
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
        
        if textField == countryTextField {
            textField.tintColor = UIColor.clear
            self.stateTextField.text = ""
            textField.resignFirstResponder()
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
            self.showCustomTableView(self, sourceView: textField, countryName: "") { (text) in
                textField.text = text
            }
        }
        
        if textField == billingCountryTextField {
            textField.tintColor = UIColor.clear
            self.billingStateTextField.text = ""
            textField.resignFirstResponder()
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
            self.showCustomTableView(self, sourceView: textField, countryName: "") { (text) in
                textField.text = text
            }
        }
        //by anand
        if textField == contactSourceTextField {
            textField.tintColor = UIColor.clear
            // self.contactSourceTextField.text = ""
            textField.resignFirstResponder()
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
            self.showContactSourceCustomTableView(self, sourceView: textField, contactSource: ""){
                (text) in
                textField.text = text
            }
        }
        //end anand
        
        //by anand
        if textField == selectCustomerStatusTextField {
            textField.tintColor = UIColor.clear
            textField.resignFirstResponder()
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
            self.customerStatus(self, sourceView: textField, contactSource: ""){
                (text) in
                self.strCustomeStatusTemp = textField.text ?? ""
                textField.text = text
                appDelegate.isHomeProductAPICall = true
            }
        }
        //end anand
        // for custom text 1
        
        if textField == billingCustom1TextField {
            billingCustom1TextField.inputView = nil
            billingCustom1TextField.reloadInputViews()
            if DataManager.customText1Type == "date" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                showDatePickerCustomeText1()
                billingCustom1TextField.selectAll(nil)
            }else{
                
                if DataManager.customText1Type == "numeric" {
                    billingCustom1TextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
                }else{
                    if DataManager.customText1Type == "text" && (checkString1.lowercased().range(of:"phone") != nil){
                       // billingCustom1TextField.keyboardType = UIKeyboardType.asciiCapable
                        billingCustom1TextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
                    }else{
                        billingCustom1TextField.keyboardType = UIKeyboardType.asciiCapable
                    }
                    
                }
            }
        }
        
        // for custom text 2
        
        if textField == billingCustom2TextField {
            billingCustom2TextField.inputView = nil
            billingCustom2TextField.reloadInputViews()
            if DataManager.customText2Type == "date" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                showDatePickerCustomeText2()
                billingCustom2TextField.selectAll(nil)
            }else{
                if DataManager.customText2Type == "numeric" {
                    billingCustom2TextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
                }else{
                    if DataManager.customText2Type == "text" && (checkString2.lowercased().range(of:"phone") != nil){
                        //billingCustom2TextField.keyboardType = UIKeyboardType.asciiCapable
                        billingCustom2TextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
                    }else{
                        billingCustom2TextField.keyboardType = UIKeyboardType.asciiCapable
                    }
                    
                }
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == billingEmailTextField || textField == emailTextField {
            textField.resetCustomError(isAddAgain: false)
        }
        if textField == searchTextField {
            Indicator.isEnabledIndicator = true
            textField.resignFirstResponder()
            if textField.text == "" {
                isSearching = false
            }else {
                isSearching = true
            }
            self.selectCustomerTabelView.reloadData()
        }
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            //Inilialize SearchProductVC
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == billingFirstNameTextField {
            billingLastNameTextField.becomeFirstResponder()
        }
        
        if textField == billingLastNameTextField {
            billingEmailTextField.becomeFirstResponder()
        }
        
        if textField == billingEmailTextField {
            billingPhoneTextField.becomeFirstResponder()
        }
        
        if textField == billingPhoneTextField {
            billingCompanyTextField.becomeFirstResponder()
        }
        if textField == billingCompanyTextField {
            billingAddressTextField.becomeFirstResponder()
        }
        
        if textField == billingAddressTextField {
            billingAddress2TextField.becomeFirstResponder()
        }
        
        if textField == billingAddress2TextField {
            billingCityTextField.becomeFirstResponder()
        }
        
        if textField == billingCityTextField {
            billingStateTextField.becomeFirstResponder()
        }
        
        if textField == billingStateTextField {
            billingZipTextField.becomeFirstResponder()
        }
        
        if textField == billingZipTextField {
            if !billingCountryTextField.isHidden {
                billingCountryTextField.becomeFirstResponder()
            }
        }
        
        if textField == billingCountryTextField {
            textField.resignFirstResponder()
        }
        
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        }
        
        if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        }
        
        if textField == emailTextField {
            phoneTextField.becomeFirstResponder()
        }
        
        if textField == phoneTextField {
            addressTextField.becomeFirstResponder()
        }
        
        if textField == addressTextField {
            address2TextField.becomeFirstResponder()
        }
        
        if textField == address2TextField {
            cityTextField.becomeFirstResponder()
        }
        
        if textField == cityTextField {
            stateTextField.becomeFirstResponder()
        }
        
        if textField == stateTextField {
            zipTextField.becomeFirstResponder()
        }
        
        if textField == zipTextField {
            if !countryTextField.isHidden {
                countryTextField.becomeFirstResponder()
            }
        }
        
        if textField == countryTextField {
            textField.resignFirstResponder()
        }
        if textField == billingCustom1TextField {
            billingCustom1TextField.becomeFirstResponder()
        }
        
        if textField == billingCustom2TextField {
            billingCustom2TextField.becomeFirstResponder()
        }
        
        if textField == contactSourceTextField{
            contactSourceTextField.becomeFirstResponder()
        }
        
        if textField == officePhoneTextField{
            officePhoneTextField.becomeFirstResponder()
        }
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
        
        if textField == emailTextField || textField == billingEmailTextField {
            if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
                return false
            }
            return true
        }
        
        if textField == searchTextField {
            if range.location == 0 && string == " " {
                return false
            }
            if string == "\t" {
                return false
            }
            return true
        }
        
        if textField == firstNameTextField || textField == lastNameTextField || textField == billingFirstNameTextField || textField == billingLastNameTextField {
            if charactersCount > 25 {
                return false
            }
        }
        
        
        if textField == billingZipTextField || textField == zipTextField {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedZIPCodeNumber(number: newString)
            
            if DataManager.isshipOrderButton {
                if textField == billingZipTextField {
                    callvalidationforBilling()
                }
                
                if textField == zipTextField {
                    callValidationForShipping()
                }
            }
            
            return false
        }
        
        if textField == phoneTextField || textField == billingPhoneTextField || textField == officePhoneTextField{
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedPhoneNumber(number: newString)
            
            return false
        }
        
        if textField == phoneTextField || textField == billingPhoneTextField || textField == zipTextField || textField == billingZipTextField || textField == officePhoneTextField{
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 20 {
                return false
            }
            return string == filtered
        }
        
        if textField == billingCustom1TextField {
            if DataManager.customText1Type == "numeric" {
                let cs = NSCharacterSet(charactersIn: "0123456789").inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if charactersCount > 20 {
                    return false
                }
                return string == filtered
            }else if DataManager.customText1Type == "text" && (checkString1.lowercased().range(of:"phone") != nil) {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                textField.text = formattedPhoneNumber(number: newString)
                return false
            }
            
        }
        
        if textField == billingCustom2TextField {
            if DataManager.customText2Type == "numeric" {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                textField.text = formattedPhoneNumber(number: newString)
                return false
            }else if DataManager.customText2Type == "text" && (checkString2.lowercased().range(of:"phone") != nil) {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                textField.text = formattedPhoneNumber(number: newString)
                return false
            }
            
        }
        
        if textField == billingCustom2TextField {
            if DataManager.customText2Type == "numeric" {
                let cs = NSCharacterSet(charactersIn: "0123456789").inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if charactersCount > 20 {
                    return false
                }
                return string == filtered
            }else if DataManager.customText2Type == "text" && (checkString2.lowercased().range(of:"phone") != nil) {
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                textField.text = formattedPhoneNumber(number: newString)
                return false
            }
        }
        
        if textField == addressTextField || textField == address2TextField || textField == billingCompanyTextField || textField == billingAddressTextField || textField == billingAddress2TextField || textField == cityTextField || textField == billingCityTextField || textField == zipTextField || textField == billingZipTextField || textField == billingCustom1TextField || textField == billingCustom2TextField {
            if textField.text == "" && string == " " {
                return false
            }
        }
        
        if textField == addressTextField || textField == address2TextField || textField == billingCompanyTextField || textField == billingAddressTextField || textField == billingAddress2TextField {
            if charactersCount > 100 {
                return false
            }
        }
        
        if textField == cityTextField || textField == billingCityTextField {
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
        
        if DataManager.isshipOrderButton {
            callValidationForShipping()
            callvalidationforBilling()
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        //callForDisableGreenBtnAllCustValidation()
        textField.resignFirstResponder()
        return false
    }
    
}

//MARK: ShippingDelegate
extension iPadSelectCustomerViewController: ShippingDelegate {
    func didSelectShipping(data: CustomerListModel) {
        scrollView.scrollToTop()
        isUserSelected = false
        self.segmentView.isHidden = true
        self.doneCancelView.isHidden = false
        self.newCustomerView.isHidden = false
        self.selectedUser = data
        isUserDataSelected = data.str_bpid != ""
        fillUserData(data: data)
    }
}

extension iPadSelectCustomerViewController: SelectShippingDelegate {
    
    func didHideSelectShippingView(isRefresh: Bool) {
        self.viewSelectShippingAddress.isHidden = true
    }
    func sendSelectShippingAddessData(ShippingSelectDataArray: Array<AnyObject>) {
        print(ShippingSelectDataArray)
        
        if ShippingSelectDataArray.count == 0 {
            return
        }
        
        self.viewSelectShippingAddress.isHidden = true
        let object = ShippingSelectDataArray[0] as! UserShippingAddress
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
        
        firstNameTextField.text = object.firstname
        lastNameTextField.text = object.lastname
        addressTextField.text = object.addressline1
        address2TextField.text = object.addressline2
        cityTextField.text = object.city
        stateTextField.text = object.region
        zipTextField.text = object.postalcode
        countryTextField.text = object.country
        countryTextField.isHidden = DataManager.isShowCountry == false
        countryLineView.isHidden = DataManager.isShowCountry == false
        self.countryDropDownImg.isHidden = DataManager.isShowCountry == false
        customerInformationErrorShowForShipping()
    }
    
}

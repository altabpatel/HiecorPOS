//
//  UserDetailViewController.swift
//  HieCOR
//
//  Created by Hiecor Software on 16/08/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

class UserDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var btnHideTable: UIButton!
    @IBOutlet weak var tableMailing: UITableView!
    @IBOutlet weak var tfCustomer2: UITextField!
    @IBOutlet weak var tfCustomer1: UITextField!
    @IBOutlet weak var tfMailingList: UITextField!
    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfRegion: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfAddress2: UITextField!
    @IBOutlet weak var tfAddress1: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfCompanyName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    
    var orderInfoDelegate: OrderInfoViewControllerDelegate?
    var orderInfoDetail = OrderInfoModel()
    var array_RegionsList = [RegionsListModel]()
    var array_CountryList = [CountryDetail]()
    var array_MailingList = [MailingListModel]()
    var userDetailDelegate : UserDetailsDelegate?
    
    var orderString = String()
    var ischeckCountry = false
    var selectedIndex = Int()
    var selectedCells:[Int] = []
    var selectedName:[String] = []
    var selectedIds:[String] = []
    var orderIdStr = String()
    var selectedTemp:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableMailing.isHidden = true
        setDelegates()
        print("orderId",orderIdStr)
        
        //IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        //IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [ UIStackView.self, UIView.self, UIView.self, UIView.self, UIStackView.self, UIView.self]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        customizeUI()
        SetDataforIphone()
    }
    
    private func SetDataforIphone(){
        tfMailingList.text = ""
        
        selectedIds.removeAll()
        selectedName.removeAll()
        selectedCells.removeAll()
        
        self.callAPItoGetMailingList()
        
        print("string===",orderIdStr)
        orderInfoDetail = OrderVM.shared.orderInfo
        print("orderInfoDetail===",orderInfoDetail)
        orderString = orderInfoDetail.orderID
        if orderIdStr == orderString {
            
            tfFirstName.text = orderInfoDetail.cust_first_name
            tfLastName.text = orderInfoDetail.cust_last_name
            tfCompanyName.text = orderInfoDetail.cust_company_name
            tfAddress1.text = orderInfoDetail.cust_address1
            tfAddress2.text = orderInfoDetail.cust_address2
            tfCity.text = orderInfoDetail.cust_city
            tfRegion.text = orderInfoDetail.cust_region
            tfCountry.text = orderInfoDetail.cust_country
            tfCustomer1.text = orderInfoDetail.cust_customer1
            tfCustomer2.text = orderInfoDetail.cust_customer2
            tfEmail.text = orderInfoDetail.email
            
            print("orderInfoDetail.userID====",orderInfoDetail.userID)
            print("First Name====",orderInfoDetail.cust_first_name)
            print("last Name====",orderInfoDetail.cust_last_name)
            print("cust_company_name ====",orderInfoDetail.cust_company_name)
            print("cust_address1====",orderInfoDetail.cust_address1)
            print("cust_address2====",orderInfoDetail.cust_address2)
            print("cust_city====",orderInfoDetail.cust_city)
            print("cust_region====",orderInfoDetail.cust_region)
            print("cust_country====",orderInfoDetail.cust_country)
            print("cust_customer1====",orderInfoDetail.cust_customer1)
            print("cust_customer2====",orderInfoDetail.cust_customer2)
            print("cust_customerList",orderInfoDetail.cust_mailingList)
        }
    }
    
    //MARK: Private Functions
    private func setDelegates() {
        tfFirstName.delegate = self
        tfLastName.delegate = self
        tfCompanyName.delegate = self
        tfCustomer2.delegate = self
        tfCountry.delegate = self
        tfRegion.delegate = self
        tfCity.delegate = self
        tfAddress2.delegate = self
        tfAddress1.delegate = self
        tfMailingList.delegate = self
        tfEmail.delegate = self
    }
    private func customizeUI() {
        tfCountry.setDropDown()
        tfRegion.setDropDown()
        tfMailingList.setDropDown()
    }
    
    //MARK: IBAction
    @IBAction func actionHideTable(_ sender: Any) {
        self.tableMailing?.isHidden = true
        self.btnHideTable.isHidden = true
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.tableMailing?.isHidden = true
            self.userDetailDelegate?.didHideUserDetailView?(isRefresh: false)
        }else{
            appDelegate.strIphoneApi = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func actionDone(_ sender: Any) {
        
        if tfEmail.text != ""{
            if !tfEmail.isValidEmail()
            {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    tfEmail.setCustomError(text: "Please enter valid Email.", bottomSpace: 2)
                } else {
//                    self.showAlert(message: "Please enter valid Email.")
                    appDelegate.showToast(message: "Please enter valid Email.")
                }
                return
            }
        }
        
        let parameters: Parameters = [
            "userID": orderInfoDetail.userID,
            "first_name": tfFirstName.text,
            "last_name": tfLastName.text!,
            "company": tfCompanyName.text!,
            "address": tfAddress1.text!,
            "address2": tfAddress2.text!,
            "city": tfCity.text!,
            "region": tfRegion.text!,
            "country": tfCountry.text!,
            "custom_text_1": tfCustomer1.text!,
            "custom_text_2": tfCustomer2.text!,
            "mailing_list": selectedIds,
            "email": tfEmail.text!
            
        ]
        self.callAPItoSendUserDetail(parameters: parameters)
    }
    
    
    @IBAction func tf_StateAction(_ sender: Any)
    {
        ischeckCountry = false
        let array = array_RegionsList.compactMap({$0.str_regionName})
        if array.count > 0 {
            self.pickerDelegate = self
            self.setPickerView(textField: tfRegion, array: array)
        }else {
            tfRegion.resignFirstResponder()
            self.callAPItoGetRegionList(isTextField: true)
        }
    }
    
    @IBAction func tfCountryAction(_ sender: Any) {
        ischeckCountry = true
        let array = array_CountryList.compactMap({$0.name})
        if array.count > 0 {
            self.pickerDelegate = self
            self.setPickerView(textField: tfCountry, array: array)
        }else {
            tfCountry.resignFirstResponder()
            self.callAPItoGetCountryList(isTextField: true)
        }
    }
    
    @IBAction func tfMailingAction(_ sender: Any) {
        ischeckCountry = false
        tableMailing.isHidden = false
        btnHideTable.isHidden = false
    }
    
    func tableViewSelectCell() {
        selectedIds.removeAll()
        selectedName.removeAll()
        tfMailingList.text = ""
        
        for i in selectedTemp {
            for data in 0..<array_MailingList.count {
                let name = array_MailingList[data].str_list_name
                let id = array_MailingList[data].str_listid
                if "\(i)" == id {
                    selectedIds.append(id)
                    selectedName.append(name)
                    selectedCells.append(data)
                    tfMailingList.text = name + "," + tfMailingList.text!
                }
            }
        }
    }
    
    func selectValueInTable() {
        selectedIds.removeAll()
        selectedName.removeAll()
        tfMailingList.text = ""
        
        
//        for i in selectedCells {
//            for data in 0..<array_MailingList.count {
//                let name = array_MailingList[data].str_list_name
//                let id = array_MailingList[data].str_listid
//                if "\(i)" == id {
//                    selectedIds.append(id)
//                    selectedName.append(name)
//                    tfMailingList.text = name + "," + tfMailingList.text!
//                }
//            }
//        }
        
        
        for val in selectedCells {
            for data in 0..<array_MailingList.count {
                if val == data {
                    let name = array_MailingList[val].str_list_name
                    let id = array_MailingList[val].str_listid
                    selectedIds.append(id)
                    selectedName.append(name)
                    tfMailingList.text = name + "," + tfMailingList.text!
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return array_MailingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MailingListTableViewCell", for: indexPath) as! MailingListTableViewCell
        cell.selectionStyle = .none
        let objMailing = array_MailingList[indexPath.row]
        cell.btnSelect.tag = indexPath.row
        cell.lableTilte.text  = objMailing.str_list_name
        if selectedCells.contains(indexPath.row) {
            cell.btnSelect.setImage(UIImage(named:"boxSelect"), for: .normal)
        } else {
            cell.btnSelect.setImage(UIImage(named:"boxUnselect"), for: .normal)
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.selectedCells.contains(indexPath.row) {
            let myIndex = self.selectedCells.index(of: indexPath.row)
            self.selectedCells.remove(at: myIndex!)
        } else {
            self.selectedCells.append(indexPath.row)
        }
        selectValueInTable()
        tableView.reloadData()
    }
}

extension UserDetailViewController: UserDetailsDelegate {
    func didgetUserOrderId(with orderId: String) {
        
        tfMailingList.text = ""
        
        selectedIds.removeAll()
        selectedName.removeAll()
        selectedCells.removeAll()
        
        self.callAPItoGetMailingList()
        
        print("string===",orderId)
        orderInfoDetail = OrderVM.shared.orderInfo
        print("orderInfoDetail===",orderInfoDetail)
        orderString = orderInfoDetail.orderID
        if orderId == orderString {
            
            tfFirstName.text = orderInfoDetail.cust_first_name
            tfLastName.text = orderInfoDetail.cust_last_name
            tfCompanyName.text = orderInfoDetail.cust_company_name
            tfAddress1.text = orderInfoDetail.cust_address1
            tfAddress2.text = orderInfoDetail.cust_address2
            tfCity.text = orderInfoDetail.cust_city
            tfRegion.text = orderInfoDetail.cust_region
            tfCountry.text = DataManager.selectedCountry//orderInfoDetail.cust_country
            tfCustomer1.text = orderInfoDetail.cust_customer1
            tfCustomer2.text = orderInfoDetail.cust_customer2
            tfEmail.text = orderInfoDetail.email
            
            print("orderInfoDetail.userID====",orderInfoDetail.userID)
            print("First Name====",orderInfoDetail.cust_first_name)
            print("last Name====",orderInfoDetail.cust_last_name)
            print("cust_company_name ====",orderInfoDetail.cust_company_name)
            print("cust_address1====",orderInfoDetail.cust_address1)
            print("cust_address2====",orderInfoDetail.cust_address2)
            print("cust_city====",orderInfoDetail.cust_city)
            print("cust_region====",orderInfoDetail.cust_region)
            print("cust_country====",orderInfoDetail.cust_country)
            print("cust_customer1====",orderInfoDetail.cust_customer1)
            print("cust_customer2====",orderInfoDetail.cust_customer2)
            print("cust_customerList",orderInfoDetail.cust_mailingList)
        }
    }
}

//MARK: UITextFieldDelegate
extension UserDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError(isAddAgain: false)
        textField.hideAssistantBar()
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        
        if textField == tfMailingList{
            textField.resignFirstResponder()
            self.btnHideTable.isHidden = false
            self.tableMailing.isHidden = false
        }
        
        if textField == tfRegion {
            if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (DataManager.selectedCountry ?? "")}) {
                let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                    self.tfRegion.text = text
                }
            }
        }
        if textField == tfCountry {
            textField.tintColor = UIColor.clear
            textField.resignFirstResponder()
            DispatchQueue.main.async {
                textField.resignFirstResponder()
            }
            self.showCustomTableView(self, sourceView: textField, countryName: "") { (text) in
                self.tfCountry.text = text
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
            return false
        }
        if range.location == 0 && string == " " {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == tfFirstName {
            tfLastName.becomeFirstResponder()
        }
        
        if textField == tfLastName {
            tfEmail.becomeFirstResponder()
        }
        
        if textField == tfEmail {
            tfCompanyName.becomeFirstResponder()
        }
        
        if textField == tfCompanyName {
            tfAddress1.becomeFirstResponder()
        }
        
        if textField == tfAddress1 {
            tfAddress2.becomeFirstResponder()
        }
        if textField == tfAddress2 {
            tfCity.becomeFirstResponder()
        }
        
        if textField == tfCity {
            tfRegion.becomeFirstResponder()
        }
        
        if textField == tfRegion {
            tfCountry.becomeFirstResponder()
        }
        
        if textField == tfCountry {
            tfMailingList.becomeFirstResponder()
        }
        
        if textField == tfMailingList {
            tfCustomer1.becomeFirstResponder()
        }
        
        if textField == tfCustomer1 {
            tfCustomer2.becomeFirstResponder()
        }
        
        
        if textField == tfCustomer2 {
            textField.resignFirstResponder()
        }
        
        
        
        return true
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
}

//MARK: API Methods
extension UserDetailViewController {
    func callAPItoGetRegionList(isTextField: Bool? = false) {
        HomeVM.shared.getRegionList { (success, message, error) in
            if success == 1 {
                self.array_RegionsList = HomeVM.shared.regionsList
                if isTextField! {
                    self.tfRegion.becomeFirstResponder()
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
    
    func callAPItoGetCountryList(isTextField: Bool? = false) {
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            return
        }
        
        HomeVM.shared.getCountryList(country: "") { (success, message, error) in
            if success == 1 {
                self.array_CountryList = HomeVM.shared.countryDetail
                if isTextField! {
                    self.tfCountry.becomeFirstResponder()
                }
                //self.tbl_Settings.reloadData()
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
    
    func callAPItoGetMailingList() {
        //Indicator.isEnabledIndicator = false
        //Indicator.sharedInstance.showIndicator()
        HomeVM.shared.getMailingList(responseCallBack: { (success, message, error) in
            if success == 1 {
                self.array_MailingList.removeAll()
                self.array_MailingList =  HomeVM.shared.MailingList
                self.selectedTemp.removeAll()
                DispatchQueue.main.async {
                   
                    //Indicator.isEnabledIndicator = true
                    //Indicator.sharedInstance.hideIndicator()
                    
                    for j in 0..<self.orderInfoDetail.cust_mailingList.count {
                        for id in self.array_MailingList {
                            if id.str_listid == self.orderInfoDetail.cust_mailingList[j] {
                                self.selectedTemp.append(Int(id.str_listid)!)
                                self.tfMailingList.text = id.str_list_name + "," + self.tfMailingList.text!
                            }
                        }
                    }
                    self.tableViewSelectCell()
                    self.tableMailing.reloadData()
    
                }
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
    
    // MARK: - API Call....
    func callAPItoSendUserDetail(parameters: JSONDictionary) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.putUserDetail(parameters: parameters) { (success, message, error) in
            if success == 1 {
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    self.tableMailing?.isHidden = true
                    self.userDetailDelegate?.didHideUserDetailView?(isRefresh: true)
                }else{
                    appDelegate.strIphoneApi = true
                    self.dismiss(animated: true, completion: nil)
                }
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error!)
                }
            }
        }
    }
}
//MARK: HieCORPickerDelegate
extension UserDetailViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        if ischeckCountry{
            let array = HomeVM.shared.countryDetail.compactMap({$0.abbreviation})
            tfCountry.text = array[index]
        }else{
            tfRegion.text = "\(self.array_RegionsList[index].str_regionAbv)"
        }
    }
}



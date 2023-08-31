//
//  SelectCustomerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 04/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import CoreData
import SocketIO

class SelectCustomerViewController: BaseViewController  {
    
    //MARK: IBOutlets
    @IBOutlet weak var addButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btn_Done: UIButton!
    @IBOutlet var HeaderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var btn_AddCustomerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var view_Header: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var tbl_SelectCustomer: UITableView!
    @IBOutlet var selectButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var addNewCostomerButton: UIButton!
    
    //MARK: Variables
    var str_CustomerId = String()
    var str_AddCustomer = String()
    var isSearching = Bool()
    var selectedUser = CustomerListModel()
    var array_CustomersList = [CustomerListModel]()
    var array_searchCustomersList = [CustomerListModel]()
    var catAndProductDelegate: CatAndProductsViewControllerDelegate?
    var customerDelegate: CustomerDelegates?
    var delegate:SelectedCutomerDelegate? = nil
  
    
    //MARK: Private Variables
    private var indexofPage:Int = 1
    private var isDataLoading:Bool = false
    private var isLastIndex: Bool = false
    private var onLineFetchLimit:Int = 30
    var str_CustomerTag = ""
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            searchCustomerSocket()
        }
        //addNewCostomerButton.setTitle((DataManager.customerObj == nil && DataManager.customerId == "") ? "Add Customer" : "Edit Customer", for: .normal)
        addNewCostomerButton.setTitle((HomeVM.shared.customerUserId == "") ? "New Customer" : "Edit Customer", for: .normal)

        if DataManager.customerObj != nil{
            addNewCostomerButton.setTitle((DataManager.customerObj == nil) ? "New Customer" : "Edit Customer", for: .normal)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tbl_SelectCustomer.tableFooterView = UIView()
        onLineFetchLimit = 30
        //Reset View Height
        UIView.animate(withDuration: 0.5, animations: {
            self.addButtonTopConstraint.constant = 8
            self.addButtonTopConstraint.constant = 8
        }) { (success) in
            self.view.backgroundColor = #colorLiteral(red: 0.8406313062, green: 0.844358325, blue: 0.8570885062, alpha: 1)
            self.view_Header.isHidden = false
        }
        
       // searchTextField.becomeFirstResponder()
    }
    // for socket sudama
    func searchCustomerSocket(){
                  MainSocketManager.shared.connect()
        //        MainSocketManager.shared.onConnect {
        //            // MainSocketManager.shared.userJoinOnConnect(deviceId: self.deviceId!)
        //        }
        let socketConnectionStatus = MainSocketManager.shared.socket.status
        
        switch socketConnectionStatus {
        case SocketIOStatus.connected:
            print("socket connected")
            
            MainSocketManager.shared.searchCustomerNumber { (searchCustomerForSocketObj) in
                if DataManager.sessionID == searchCustomerForSocketObj.session_id {
                    //self.getCustomerApiForSocket(customerID: searchCustomerForSocketObj.phone)
                }
            }
            
            MainSocketManager.shared.emitselectCustomer { (selectCustomerForSocketObj) in
                if DataManager.sessionID == selectCustomerForSocketObj.session_id{
                    //self.getCustomerApiForSocket(customerID: selectCustomerForSocketObj.userId)
                    
                }
            }
            
        case SocketIOStatus.connecting:
            print("socket connecting")
        case SocketIOStatus.disconnected:
            print("socket disconnected")
        case SocketIOStatus.notConnected:
            print("socket not connected")
        }
    }
      
      func getCustomerApiForSocket(customerID : String){
          Indicator.isEnabledIndicator = false
          Indicator.sharedInstance.showIndicator()
          HomeVM.shared.getSearchCustomer(searchText: customerID, searchFetchLimit: 1, searchPageCount: 1, responseCallBack: { (success, message, error) in
              if success == 1 {
                  //Update Data
                  if !HomeVM.shared.isMoreSearchCustomerFound {
                     // self.indexofPage = self.indexofPage - 1
                  }
                 self.isSearching = true
                //self.array_CustomerNames.removeAll()
                  DispatchQueue.main.async {
                      self.array_searchCustomersList = HomeVM.shared.searchCustomerList
                    if self.array_searchCustomersList.count > 0 {
                        self.clickedOnIndexForSocket(index: 0)
                    }else{
                        MainSocketManager.shared.onSearchPhoneNoError()
                    }
                   //   self.tbl_SelectCustomer.reloadData()
                      Indicator.isEnabledIndicator = true
                      Indicator.sharedInstance.hideIndicator()
                  }
              }
              else {
                MainSocketManager.shared.onSearchPhoneNoError()
                  Indicator.isEnabledIndicator = true
                  Indicator.sharedInstance.hideIndicator()
                  if message != nil {
//                      self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                  }else {
                      self.showErrorMessage(error: error)
                  }
              }
          })
      }

    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddNewCutomerViewController
        vc.selectedUser = self.selectedUser
        vc.isNewUser = DataManager.customerObj == nil
        vc.delegate = self
    }
    
    //MARK: IBAction Method 
    @IBAction func btn_AddNewCustomerAction(_ sender: Any) {
        self.view.endEditing(true)
        self.selectedUser.isUserCustSelected = false
        if DataManager.customerObj == nil {
            str_AddCustomer = ""
            str_CustomerId = ""
            selectedUser = CustomerListModel()
            UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
            UserDefaults.standard.synchronize()
        }
        customerDelegate?.didAddNewCustomer?()
        tbl_SelectCustomer.reloadData()
        self.performSegue(withIdentifier: "addnewcustomer", sender: nil)
        
    }
    
    @IBAction func btn_CancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_DoneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textfieldDidChangeValue(_ sender: UITextField) {
//        self.view.frame.origin.y = -10
        UIApplication.shared.isStatusBarHidden = true
        tbl_SelectCustomer.isUserInteractionEnabled = true
        indexofPage = 1
        if (sender.text?.count ?? 0) != 0
        {
            isSearching = true
            //Remove all objects first.
            self.array_searchCustomersList.removeAll()
            self.tbl_SelectCustomer.reloadData()
            getSearchCustomersList()
        }
        else
        {
            isSearching = false
            array_searchCustomersList.removeAll()
            tbl_SelectCustomer.reloadData()
        }
    }
}

//MARK:- ScrollView Delegates
extension SelectCustomerViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchTextField.text != "" {
            self.searchTextField.resignFirstResponder()
        }
        
        let threshold   = isSearching == true ? self.array_searchCustomersList.count : self.array_CustomersList.count;
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == tbl_SelectCustomer)
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
                } else {
                    self.isDataLoading = false
                }
            }
            tbl_SelectCustomer.reloadData()
        }
    }
}

//MARK:- Tableview Datasource and Delegate Methods
extension SelectCustomerViewController: UITableViewDataSource, UITableViewDelegate {
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
        if(str_CustomerId == customerList.str_userID) {
            lbl_Name?.textColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            btn_select?.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            btn_Done.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        }
        else {
            lbl_Name?.textColor = UIColor.black
            btn_select?.setImage(UIImage(named: "radio-unchecked"), for: .normal)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clickedOnIndex(index: indexPath.row)
        
    }
    
    func clickedOnIndex(index: Int) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, animations: {
            self.addButtonTopConstraint.constant = 8
            self.addButtonTopConstraint.constant = 8
            self.HeaderViewHeightConstraint.constant = 45
            self.btn_AddCustomerHeightConstraint.constant = 40
        }) { (success) in
            self.view.backgroundColor = #colorLiteral(red: 0.8406313062, green: 0.844358325, blue: 0.8570885062, alpha: 1)
            self.view_Header.isHidden = false
            self.view.layoutIfNeeded()
        }
        let customerList =  isSearching ? array_searchCustomersList[index] : self.array_CustomersList[index]
        self.str_AddCustomer = customerList.str_display_name
        self.str_CustomerId = customerList.str_userID
        str_CustomerTag = customerList.str_customerTags
        DataManager.isUserPaxToken = ""
        DataManager.isUserPaxToken = customerList.userPaxToken
        print("DataManager.isUserPaxToken",DataManager.isUserPaxToken)
        print("customerList.userPaxToken",customerList.userPaxToken)
        print("datamanager token enable",DataManager.isPaxTokenEnable)
        DataManager.customerForShippingAddressId = ""
        DataManager.customerForShippingAddressId = customerList.str_userID
        DataManager.shippingaddressCount = 0
        DataManager.CardCount = 0
        DataManager.EmvCardCount = 0
        DataManager.IngenicoCardCount = 0
        DataManager.Bbpid = ""
        DataManager.customerId = ""
        DataManager.customerId = customerList.str_userID
        DataManager.CardCount = customerList.cardCount
        DataManager.EmvCardCount = Int(customerList.emv_card_Count)
        DataManager.IngenicoCardCount = Int(customerList.ingenico_card_count)
        DataManager.Bbpid = customerList.str_bpid
        DataManager.shippingaddressCount = customerList.shippingaddressCount
        HomeVM.shared.customerUserId = ""
        HomeVM.shared.customerUserId = customerList.str_userID
        DataManager.isCheckUncheckShippingBilling = true//customerList.shippingaddressCount > 1 ? false : true
        tbl_SelectCustomer.reloadData()
        selectedUser = customerList
        selectedUser.isUserCustSelected = true
        if str_CustomerTag == ""{
            self.performSegue(withIdentifier: "addnewcustomer", sender: nil)
        }else{
            self.closeAlert(title: "Customer Tags Found", message: str_CustomerTag, cancelTitle: "Close", cancelAction: { (_) in
                self.performSegue(withIdentifier: "addnewcustomer", sender: nil)
            })
        }
//        self.performSegue(withIdentifier: "addnewcustomer", sender: nil)
        //for socket sudama
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.onCustomerFound(CustomerId: DataManager.customerId)
        }
        //
        
    }
    
    func clickedOnIndexForSocket(index: Int) {
//        self.view.endEditing(true)
//        UIView.animate(withDuration: 0.5, animations: {
//            self.addButtonTopConstraint.constant = 8
//            self.addButtonTopConstraint.constant = 8
//            self.HeaderViewHeightConstraint.constant = 60
//            self.btn_AddCustomerHeightConstraint.constant = 40
//        }) { (success) in
//            self.view.backgroundColor = #colorLiteral(red: 0.8406313062, green: 0.844358325, blue: 0.8570885062, alpha: 1)
//            self.view_Header.isHidden = false
//            self.view.layoutIfNeeded()
//        }
        let customerList =  isSearching ? array_searchCustomersList [index] : self.array_CustomersList[index]
        self.str_AddCustomer = customerList.str_display_name
        self.str_CustomerId = customerList.str_userID
        DataManager.isUserPaxToken = ""
        DataManager.isUserPaxToken = customerList.userPaxToken
        print("DataManager.isUserPaxToken",DataManager.isUserPaxToken)
        print("customerList.userPaxToken",customerList.userPaxToken)
        print("datamanager token enable",DataManager.isPaxTokenEnable)
        DataManager.customerForShippingAddressId = ""
        DataManager.customerForShippingAddressId = customerList.str_userID
        DataManager.shippingaddressCount = 0
        DataManager.CardCount = 0
        DataManager.EmvCardCount = 0
        DataManager.IngenicoCardCount = 0
        DataManager.Bbpid = ""
        DataManager.customerId = ""
        DataManager.customerId = customerList.str_userID
        DataManager.CardCount = customerList.cardCount
        DataManager.EmvCardCount = Int(customerList.emv_card_Count)
        DataManager.IngenicoCardCount = Int(customerList.ingenico_card_count)
        DataManager.Bbpid = customerList.str_bpid
        DataManager.shippingaddressCount = customerList.shippingaddressCount
        HomeVM.shared.customerUserId = ""
        HomeVM.shared.customerUserId = customerList.str_userID
        
       // tbl_SelectCustomer.reloadData()
        selectedUser = customerList
        selectedUser.isUserCustSelected = true
        //self.performSegue(withIdentifier: "addnewcustomer", sender: nil)
        //for socket sudama
        if DataManager.customerObj == nil {
            let customerObj: JSONDictionary = ["country": "", "billingCountry": "","shippingCountry": "","coupan": "", "str_first_name":"", "str_last_name":"", "str_company": "" ,"str_address": "", "str_bpid":"", "str_city": "", "str_order_id": "", "str_email": "", "str_userID": "", "str_phone": "","str_region": "", "str_address2": "", "str_Billingcity": "", "str_postal_code": "", "str_Billingphone": "", "str_Billingaddress": "", "str_Billingaddress2": "", "str_Billingregion": "", "str_Billingpostal_code": "","shippingPhone": "","shippingAddress" : "", "shippingAddress2": "", "shippingCity": "", "shippingRegion" : "", "shippingPostalCode":  "", "billing_first_name": "", "billing_last_name": "","user_custom_tax": "","shipping_first_name": "", "shipping_last_name": "","shippingEmail":  "", "str_Billingemail": "",  "str_BillingCustom1TextField": "", "str_BillingCustom2TextField": "","office_phone": "", "contact_source": "", "customer_status": ""]
            DataManager.customerObj = customerObj
        }
        
        let customerObj = ["country": customerList.country, "billingCountry":customerList.billingCountry,"shippingCountry":customerList.shippingCountry,"coupan": "", "str_first_name":customerList.str_first_name, "str_last_name":customerList.str_last_name, "str_address":customerList.str_address, "str_bpid":customerList.str_bpid, "str_city":customerList.str_city, "str_order_id":customerList.str_order_id, "str_email":customerList.str_email, "str_userID":customerList.str_userID, "str_phone":customerList.str_phone,"str_region":customerList.str_region, "str_address2":customerList.str_address2, "str_Billingcity":customerList.str_Billingcity, "str_postal_code":customerList.str_postal_code, "str_Billingphone":customerList.str_Billingphone, "str_Billingaddress":customerList.str_Billingaddress, "str_Billingaddress2":customerList.str_Billingaddress2, "str_Billingregion":customerList.str_Billingregion, "str_Billingpostal_code":customerList.str_Billingpostal_code,"shippingPhone": customerList.str_Shippingphone,"str_company": customerList.str_company,"shippingAddress" : customerList.str_Shippingaddress, "shippingAddress2": customerList.str_Shippingaddress2, "shippingCity": customerList.str_Shippingcity, "shippingRegion" : customerList.str_Shippingregion, "shippingPostalCode": customerList.str_Shippingpostal_code, "billing_first_name":customerList.str_billing_first_name, "billing_last_name":customerList.str_billing_last_name,"user_custom_tax":customerList.userCustomTax,"shipping_first_name":customerList.str_shipping_first_name, "shipping_last_name":customerList.str_shipping_last_name,"shippingEmail": customerList.str_Shippingemail,"str_Billingemail": customerList.str_Billingemail, "str_BillingCustom1TextField": customerList.str_CustomText1, "str_BillingCustom2TextField": customerList.str_CustomText2, "loyalty_balance" : customerList.doubleloyalty_balance, "emv_card_count": customerList.emv_card_Count,"office_phone":customerList.str_office_phone ?? "", "contact_source": customerList.str_contact_source, "customer_status": customerList.str_customer_status] as [String : Any]
        DataManager.customerObj = customerObj
        
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.onCustomerFound(CustomerId: DataManager.customerId)
        }
        //
        
    }
    private func saveCustomerData() {
         
       }
    
}

//MARK: UITextFieldDelegate
extension SelectCustomerViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
//        self.view.frame.origin.y = 0
        UIApplication.shared.isStatusBarHidden = false
        
        if textField.text == "" {
          //  isSearching = false
            UIView.animate(withDuration: 0.5, animations: {
                self.addButtonTopConstraint.constant = 8
                self.addButtonTopConstraint.constant = 8
                self.HeaderViewHeightConstraint.constant = 45
                self.btn_AddCustomerHeightConstraint.constant = 40
            }) { (success) in
                self.view.backgroundColor = #colorLiteral(red: 0.8406313062, green: 0.844358325, blue: 0.8570885062, alpha: 1)
                self.view_Header.isHidden = false
                self.view.layoutIfNeeded()
            }
        }else {
            isSearching = true
        }
        self.tbl_SelectCustomer.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearching = true
        self.str_CustomerId = ""
        self.tbl_SelectCustomer.reloadData()
        
//        self.view.frame.origin.y = -10
        UIApplication.shared.isStatusBarHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.white
            self.HeaderViewHeightConstraint.constant = 10
            self.btn_AddCustomerHeightConstraint.constant = 0
            self.addButtonTopConstraint.constant = 0
            self.addButtonTopConstraint.constant = 0
            self.view_Header.isHidden = true
            self.view.layoutIfNeeded()
        })
        if textField.text == "" {
            self.array_searchCustomersList.removeAll()
        }
        self.tbl_SelectCustomer.reloadData()
        
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
}


//MARK: API Methods
extension SelectCustomerViewController {
    func getSearchCustomersList() {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        
        let searchText = (searchTextField.text ?? "")
        
        HomeVM.shared.getSearchCustomer(searchText: searchText, searchFetchLimit: onLineFetchLimit, searchPageCount: indexofPage, responseCallBack: { (success, message, error) in
            if success == 1 {
                //Update Data
                if !HomeVM.shared.isMoreSearchCustomerFound {
                    self.indexofPage = self.indexofPage - 1
                }
                DispatchQueue.main.async {
                    self.array_searchCustomersList = HomeVM.shared.searchCustomerList
                    self.tbl_SelectCustomer.reloadData()
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
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
    
    func getCustomersList() {
        HomeVM.shared.getCustomerList(indexOfPage: indexofPage, responseCallBack: { (success, message, error) in
            if success == 1 {
                //Update Data
                if !HomeVM.shared.isMoreCustomerFound {
                    self.indexofPage = self.indexofPage - 1
                }
                self.array_CustomersList = HomeVM.shared.customerList
                DispatchQueue.main.async {
                    self.tbl_SelectCustomer.reloadData()
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

//MARK: AddNewCutomerViewControllerDelegate
extension SelectCustomerViewController: AddNewCutomerViewControllerDelegate {
    
    func didAddNewCustomer(data: CustomerListModel) {
        indexofPage = 1
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        
//        self.view.frame.origin.y = 0
        UIView.animate(withDuration: 0.5) {
            self.HeaderViewHeightConstraint.constant = 45
            self.btn_AddCustomerHeightConstraint.constant = 40
            self.view.layoutIfNeeded()
        }
        
        if str_CustomerId == "" {
            delegate?.selectedCustomerData(customerdata: selectedUser)
        }else {
            
            if isSearching
            {
                if array_searchCustomersList.count > 0
                {
                    for list in array_searchCustomersList
                    {
                        if str_AddCustomer == list.str_display_name
                        {
                            UserDefaults.standard.setValue(HieCOR.encode(data: list.cardDetail), forKey: "SelectedCustomer")
                            UserDefaults.standard.synchronize()
                            delegate?.selectedCustomerData(customerdata: self.selectedUser)
                        }
                    }
                }
            }
            else
            {
                for list in array_CustomersList
                {
                    if str_AddCustomer == list.str_display_name
                    {
                        UserDefaults.standard.setValue(HieCOR.encode(data: list.cardDetail), forKey: "SelectedCustomer")
                        UserDefaults.standard.synchronize()
                        delegate?.selectedCustomerData(customerdata: self.selectedUser)
                    }
                }
            }
        }
        // For mutli shipping adress screen open
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.dismiss(animated: true, completion: nil)
//        }
    }
}


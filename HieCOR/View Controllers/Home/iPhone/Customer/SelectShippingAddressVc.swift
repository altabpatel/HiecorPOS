//
//  SelectShippingAddressVc.swift
//  HieCOR
//
//  Created by Hiecor Software on 03/09/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

protocol ClassShipEditAddressDelegate: class {
    func SendShipAddressIphone(arrayAddress:Array<AnyObject>)
}

class SelectShippingAddressVc: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableShipping: UITableView!
    
    
    private var dateCellExpanded: Bool = false
    var index = Int()
    var ischeckCountry = false
    var bpidString = String()
    var isCallUpdate = true
    var shippingDelegate : SelectShippingDelegate?
    var userShippingAddressModel = [UserShippingAddress]()
    var array_RegionsList = [RegionsListModel]()
    var array_CountryList = [CountryDetail]()
    var arrayAddressSelectedIndex = [UserShippingAddress]()
    weak var delegateShipIphone: ClassShipEditAddressDelegate?
    var addressDelgate : addressShippingDelegate?
    var StrID = String()
    var isAddNewAdrs = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableShipping.tableFooterView = UIView()
        tableShipping.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.callAPItoGetUserShippingAddress(strId: StrID)
        }
    }
    
    @objc func actionRegion(textField: UITextField) {
        print("myTargetFunction")
        ischeckCountry = false
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
        let array = array_RegionsList.compactMap({$0.str_regionName})
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if array.count > 0 {
                self.pickerDelegate = self
                self.setPickerView(textField: cell!.tfRegion, array: array)
            }else {
                cell!.tfRegion.resignFirstResponder()
                self.callAPItoGetRegionList(isTextField: true)
            }
        }else{
            if array.count > 0 {
                self.pickerDelegate = self
                self.setPickerView(textField: cell!.tfStateIphone, array: array)
            }else {
                cell!.tfStateIphone.resignFirstResponder()
                self.callAPItoGetRegionList(isTextField: true)
            }
        }
    }
    
    @objc func actionCountry(textField: UITextField) {
        ischeckCountry = true
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
        let array = array_CountryList.compactMap({$0.name})
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if array.count > 0 {
                self.pickerDelegate = self
                self.setPickerView(textField: cell!.tfCountry, array: array)
            }else {
                cell!.tfCountry.resignFirstResponder()
                self.callAPItoGetCountryList(isTextField: true)
            }
        }else{
            if array.count > 0 {
                self.pickerDelegate = self
                self.setPickerView(textField: cell!.tfCountryIphone, array: array)
            }else {
                cell!.tfCountryIphone.resignFirstResponder()
                self.callAPItoGetCountryList(isTextField: true)
            }
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.shippingDelegate?.didHideSelectShippingView!(isRefresh: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func actionSave(_ sender: Any) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if isAddNewAdrs {
                let indexPath = IndexPath(item: index, section: 0)
                let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
                
                let UserShippingDataModelObj = UserShippingAddress()
                
                UserShippingDataModelObj.bpid = ""
                UserShippingDataModelObj.firstname = cell?.tfFirstName.text ?? ""
                UserShippingDataModelObj.lastname =  cell?.tfLastName.text ?? ""
                UserShippingDataModelObj.addressline1 = cell?.tfAddress.text ?? ""
                UserShippingDataModelObj.addressline2 = cell?.tfAddress2.text ?? ""
                UserShippingDataModelObj.city = cell?.tfCity.text ?? ""
                UserShippingDataModelObj.region = cell?.tfRegion.text ?? ""
                UserShippingDataModelObj.country = cell?.tfCountry.text ?? ""
                UserShippingDataModelObj.postalcode = cell?.tfZip.text?.replacingOccurrences(of: "-", with: "") ?? ""
                UserShippingDataModelObj.displayname =  ""
                
                var arrayAddressSelectedIndex1 = [UserShippingAddress]()
                arrayAddressSelectedIndex1.append(UserShippingDataModelObj)
                self.shippingDelegate?.sendSelectShippingAddessData!(ShippingSelectDataArray: arrayAddressSelectedIndex1)
                self.shippingDelegate?.didHideSelectShippingView!(isRefresh: true)
            }else {
                if arrayAddressSelectedIndex.count > 0 {
                    self.shippingDelegate?.sendSelectShippingAddessData!(ShippingSelectDataArray: arrayAddressSelectedIndex)
                    self.shippingDelegate?.didHideSelectShippingView!(isRefresh: true)
                }
            }
        }else{
            if isAddNewAdrs {
                let indexPath = IndexPath(item: index, section: 0)
                let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
                
                let UserShippingDataModelObj = UserShippingAddress()
                
                UserShippingDataModelObj.bpid = ""
                UserShippingDataModelObj.firstname = cell?.tfFirstName.text ?? ""
                UserShippingDataModelObj.lastname =  cell?.tfLastName.text ?? ""
                UserShippingDataModelObj.addressline1 = cell?.tfAddress.text ?? ""
                UserShippingDataModelObj.addressline2 = cell?.tfAddress2.text ?? ""
                UserShippingDataModelObj.city = cell?.tfCity.text ?? ""
                UserShippingDataModelObj.region = cell?.tfRegion.text ?? ""
                UserShippingDataModelObj.country = cell?.tfCountry.text ?? ""
                UserShippingDataModelObj.postalcode = cell?.tfZip.text?.replacingOccurrences(of: "-", with: "") ?? ""
                UserShippingDataModelObj.displayname =  ""
                
                var arrayAddressSelectedIndex1 = [UserShippingAddress]()
                arrayAddressSelectedIndex1.append(UserShippingDataModelObj)
                delegateShipIphone?.SendShipAddressIphone(arrayAddress: arrayAddressSelectedIndex1)
                self.dismiss(animated: true, completion: nil)
            }else {
                if arrayAddressSelectedIndex.count > 0 {
                    delegateShipIphone?.SendShipAddressIphone(arrayAddress: arrayAddressSelectedIndex)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    // For add new shipping adress
    @IBAction func btnAddNewShippingAdrs_action(_ sender: Any) {
        if isAddNewAdrs {
            return
        }
            isAddNewAdrs = true
            index = userShippingAddressModel.count
          //  tableShipping.reloadData()
            if isAddNewAdrs {
//                let indexPath = IndexPath(item: index, section: 0)
//                let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
//               cell?.tfFirstName.text = ""
//                cell?.tfLastName.text = ""
//                cell?.tfAddress.text = ""
//                cell?.tfAddress2.text = ""
//                cell?.tfCity.text = ""
//                cell?.tfRegion.text = ""
//                cell?.tfCountry.text = ""
//                cell?.tfZip.text = ""
                let obj = UserShippingAddress()
                obj.displayname = ""
                obj.firstname = ""
                obj.lastname = ""
                obj.addressline1 = ""
                obj.addressline2 = ""
                obj.city = ""
                obj.postalcode = ""
               obj.region = ""
                userShippingAddressModel.append(obj)
                tableShipping.reloadData()
            }
        }
    @objc func actionUpdate(_ sender: UIButton) {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let parameters: Parameters = [
                "bp_id": bpidString,
                "update_firstname": cell?.tfFirstName.text as Any,
                "update_lastname": cell?.tfLastName.text as Any,
                "update_addr1": cell?.tfAddress.text as Any,
                "update_addr2": cell?.tfAddress2.text as Any,
                "update_city": cell?.tfCity.text as Any,
                "update_region": cell?.tfRegion.text as Any,
                "update_postal": cell?.tfZip.text?.replacingOccurrences(of: "-", with: "") as Any,
                "update_country": cell?.tfCountry.text as Any
            ]
            self.callAPItoUpdateShippingAddress(parameters: parameters)
        }else{
            let parameters: Parameters = [
                "bp_id": bpidString,
                "update_firstname": cell?.tfFirstName.text as Any,
                "update_lastname": cell?.tfLastName.text as Any,
                "update_addr1": cell?.tfAddress.text as Any,
                "update_addr2": cell?.tfAddress2.text as Any,
                "update_city": cell?.tfCityIphone.text as Any,
                "update_region": cell?.tfStateIphone.text as Any,
                "update_postal": cell?.tfZipIphone.text?.replacingOccurrences(of: "-", with: "") as Any,
                "update_country": cell?.tfCountryIphone.text as Any
            ]
            self.callAPItoUpdateShippingAddress(parameters: parameters)
        }
        
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if isAddNewAdrs { // For add new cell add new shipping address
//            return userShippingAddressModel.count + 1
//        }
        return userShippingAddressModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectShippingCell", for: indexPath) as! SelectShippingCell
        if isAddNewAdrs && index == indexPath.row {
                cell.view1.isHidden = true
                cell.btnUpdate.isHidden = true
                cell.heightConstOfView1.constant = 0
                
                cell.tfFirstName.delegate = self
                cell.tfLastName.delegate = self
               if UI_USER_INTERFACE_IDIOM() == .pad {
                   if DataManager.isShowCountry{
                       cell.tfCountry.isHidden = false
    //                   cell.tfCountry.text = obj.country
                   }else{
                       cell.tfCountry.isHidden = true
                       cell.viewPartCountryipad.isHidden = true
                   }
                   cell.viewZipIphone.isHidden = true
                   cell.viewCityIphone.isHidden = true
                   cell.viewStateIphone.isHidden = true
                   cell.viewCountryIphone.isHidden = true
               }else{
                   if DataManager.isShowCountry{
                    cell.tfCountryIphone.isHidden = false
    //                cell.tfCountryIphone.text = obj.country
                   }else{
                    cell.tfCountryIphone.isHidden = true
                    cell.viewCountryIphone.isHidden = true
                   }
                   cell.viewCityRegIpad.isHidden = true
                   cell.viewZipCountryIpad.isHidden = true
               }
               cell.btnUpdate.addTarget(self, action: #selector(self.actionUpdate), for: .touchUpInside)
               cell.tfRegion.addTarget(self, action: #selector(actionRegion), for: .touchUpInside)
               cell.tfCountry.addTarget(self, action: #selector(actionCountry), for: .touchUpInside)
                let obj = userShippingAddressModel[indexPath.row]
                cell.labelTitle.text = obj.displayname
                cell.tfFirstName.text = obj.firstname
                cell.tfLastName.text = obj.lastname
                cell.tfAddress.text = obj.addressline1
                cell.tfAddress2.text = obj.addressline2
                cell.tfCity.text = obj.city
                cell.tfZip.text = formattedZIPCodeNumber(number: obj.postalcode)
                cell.tfRegion.text = obj.region

            }else {
                cell.view1.isHidden = false
                cell.btnUpdate.isHidden = false
                cell.heightConstOfView1.constant = 50
                let obj = userShippingAddressModel[indexPath.row]
                 cell.tfFirstName.delegate = self
                 cell.tfLastName.delegate = self
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    if DataManager.isShowCountry{
                        cell.tfCountry.isHidden = false
                        cell.tfCountry.text = obj.country
                    }else{
                        cell.tfCountry.isHidden = true
                        cell.viewPartCountryipad.isHidden = true
                    }
                    cell.viewZipIphone.isHidden = true
                    cell.viewCityIphone.isHidden = true
                    cell.viewStateIphone.isHidden = true
                    cell.viewCountryIphone.isHidden = true
                    cell.labelTitle.text = obj.displayname
                    cell.tfFirstName.text = obj.firstname
                    cell.tfLastName.text = obj.lastname
                    cell.tfAddress.text = obj.addressline1
                    cell.tfAddress2.text = obj.addressline2
                    cell.tfCity.text = obj.city
                    cell.tfZip.text = formattedZIPCodeNumber(number: obj.postalcode)
                    cell.tfRegion.text = obj.region
                    
                }else{
                    if DataManager.isShowCountry{
                     cell.tfCountryIphone.isHidden = false
                     cell.tfCountryIphone.text = obj.country
                    }else{
                     cell.tfCountryIphone.isHidden = true
                     cell.viewCountryIphone.isHidden = true
                    }
                    cell.viewCityRegIpad.isHidden = true
                    cell.viewZipCountryIpad.isHidden = true
                    cell.labelTitle.text = obj.displayname
                    cell.tfFirstName.text = obj.firstname
                    cell.tfLastName.text = obj.lastname
                    cell.tfAddress.text = obj.addressline1
                    cell.tfAddress2.text = obj.addressline2
                    cell.tfCityIphone.text = obj.city
                    cell.tfZipIphone.text = formattedZIPCodeNumber(number: obj.postalcode)
                    cell.tfStateIphone.text = obj.region
                }
                cell.btnUpdate.addTarget(self, action: #selector(self.actionUpdate), for: .touchUpInside)
                cell.tfRegion.addTarget(self, action: #selector(actionRegion), for: .touchUpInside)
                cell.tfCountry.addTarget(self, action: #selector(actionCountry), for: .touchUpInside)
                
                if index == indexPath.row{
                    let imgOb: UIImage = UIImage(named: "radio-checked-new")!
                    cell.imgSelect.image = imgOb
                    self.arrayAddressSelectedIndex.removeAll()
                    self.arrayAddressSelectedIndex.append(obj)
                }else{
                    let imgOb: UIImage = UIImage(named: "radio-unchecked-new")!
                    cell.imgSelect.image = imgOb
                }
            }
            
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAddNewAdrs && indexPath.row == index {
            
        }else{
            if isAddNewAdrs {
                userShippingAddressModel.remove(at: index)
            }
            isAddNewAdrs = false
            index = indexPath.row
            let obj = userShippingAddressModel[index]
            bpidString = obj.bpid
            self.arrayAddressSelectedIndex.removeAll()
            self.arrayAddressSelectedIndex.append(obj)
            print("obj", obj)
            let indexPath = IndexPath(item: self.index, section: 0)
            let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
            if dateCellExpanded {
                dateCellExpanded = false
            } else {
                dateCellExpanded = true
            }
            let imgOb: UIImage = UIImage(named: "radio-checked-new")!
            cell?.imgSelect.image = imgOb
            
            tableShipping.reloadData()
        }
        //        tableView.beginUpdates()
        //        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if isAddNewAdrs && indexPath.row == index {
                return 300
            }else{
                if index == indexPath.row {
                    return 400
                } else {
                    return 50
                }
            }
        }else{
            if isAddNewAdrs && indexPath.row == index {
                return DataManager.isShowCountry ? 410 : 370
            }
            if DataManager.isShowCountry{
                if index == indexPath.row {
                    return 520
                } else {
                    return 50
                }
            }else{
                if index == indexPath.row {
                    return 468.5
                } else {
                    return 50
                }
            }
        }
        
    }
}

//MARK: UITextFieldDelegate
extension SelectShippingAddressVc: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError(isAddAgain: false)
        textField.hideAssistantBar()
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if textField == cell!.tfRegion {
                if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (DataManager.selectedCountry ?? "")}) {
                    let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                    self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                        cell!.tfRegion.text = text
                    }
                }
            }
            if textField == cell!.tfCountry {
                textField.tintColor = UIColor.clear
                textField.resignFirstResponder()
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                }
                self.showCustomTableView(self, sourceView: textField, countryName: "") { (text) in
                    cell!.tfCountry.text = text
                }
            }
        }else{
            if textField == cell!.tfStateIphone {
                if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (DataManager.selectedCountry ?? "")}) {
                    let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                    self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                        cell!.tfStateIphone.text = text
                    }
                }
            }
            if textField == cell!.tfCountryIphone {
                textField.tintColor = UIColor.clear
                textField.resignFirstResponder()
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                }
                self.showCustomTableView(self, sourceView: textField, countryName: "") { (text) in
                    cell!.tfCountryIphone.text = text
                }
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "SelectShippingCell", for: indexPath) as! SelectShippingCell
        
        //let cell = textField.superview?.superview as? SelectShippingCell
        
        if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
            return false
        }
        if range.location == 0 && string == " " {
            return false
        }
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
        if textField == cell!.tfZip || textField == cell!.tfZipIphone {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedZIPCodeNumber(number: newString)
            return false
        }
    
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if textField == cell!.tfFirstName {
                cell!.tfLastName.becomeFirstResponder()
            }
            
            if textField == cell!.tfLastName {
                cell!.tfAddress.becomeFirstResponder()
            }
            
            if textField == cell!.tfAddress {
                cell!.tfAddress2.becomeFirstResponder()
            }
            
            if textField == cell!.tfAddress2 {
                cell!.tfCity.becomeFirstResponder()
            }
            if textField == cell!.tfCity {
                cell!.tfRegion.becomeFirstResponder()
            }
            
            if textField == cell!.tfRegion {
                cell!.tfRegion.becomeFirstResponder()
            }
            
            if textField == cell!.tfRegion {
                cell!.tfZip.becomeFirstResponder()
            }
            
            if textField == cell!.tfZip {
                cell!.tfCountry.becomeFirstResponder()
            }
            
            if textField == cell!.tfCountry {
                cell!.tfCountry.resignFirstResponder()
            }
        }else{
            if textField == cell!.tfFirstName {
                cell!.tfLastName.becomeFirstResponder()
            }
            
            if textField == cell!.tfLastName {
                cell!.tfAddress.becomeFirstResponder()
            }
            
            if textField == cell!.tfAddress {
                cell!.tfAddress2.becomeFirstResponder()
            }
            
            if textField == cell!.tfAddress2 {
                cell!.tfCityIphone.becomeFirstResponder()
            }
            if textField == cell!.tfCityIphone {
                cell!.tfStateIphone.becomeFirstResponder()
            }
            
            if textField == cell!.tfStateIphone {
                cell!.tfZipIphone.becomeFirstResponder()
            }
            
            if textField == cell!.tfZipIphone {
                cell!.tfCountryIphone.becomeFirstResponder()
            }
            
            if textField == cell!.tfCountryIphone {
                cell!.tfCountryIphone.becomeFirstResponder()
            }
            
            if textField == cell!.tfCountryIphone {
                cell!.tfCountryIphone.resignFirstResponder()
            }
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
extension SelectShippingAddressVc {
    
    func callAPItoGetRegionList(isTextField: Bool? = false) {
        HomeVM.shared.getRegionList { (success, message, error) in
            if success == 1 {
                self.array_RegionsList = HomeVM.shared.regionsList
                let indexPath = IndexPath(item: self.index, section: 0)
                let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    if isTextField! {
                        cell!.tfRegion.becomeFirstResponder()
                    }
                }else{
                    if isTextField! {
                        cell!.tfStateIphone.becomeFirstResponder()
                    }
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
                let indexPath = IndexPath(item: self.index, section: 0)
                let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    if isTextField! {
                        cell!.tfCountry.becomeFirstResponder()
                    }
                }else{
                    if isTextField! {
                        cell!.tfCountryIphone.becomeFirstResponder()
                    }
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
    
    func callAPItoGetUserShippingAddress(strId:String)
    {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.getUserShippingAddress(UserId: strId, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.userShippingAddressModel = HomeVM.shared.ShippingUserAddress
                if self.isCallUpdate {
                    self.index = self.userShippingAddressModel.count + 2
                    self.isCallUpdate = true
                }
                self.tableShipping.reloadData()
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                } else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func callAPItoUpdateShippingAddress(parameters: JSONDictionary) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.updateUserShippingAddress(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.isCallUpdate = false
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                self.callAPItoGetUserShippingAddress(strId: self.StrID)
//                self.showAlert(message: "Updated successfully.")
                appDelegate.showToast(message: "Updated successfully.")
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
extension SelectShippingAddressVc: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableShipping?.cellForRow(at: indexPath) as? SelectShippingCell
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if ischeckCountry{
                let array = HomeVM.shared.countryDetail.compactMap({$0.abbreviation})
                cell?.tfCountry.text = array[index]
            }else{
                cell?.tfRegion.text = "\(self.array_RegionsList[index].str_regionAbv)"
            }
        }else{
            if ischeckCountry{
                let array = HomeVM.shared.countryDetail.compactMap({$0.abbreviation})
                cell?.tfCountryIphone.text = array[index]
            }else{
                cell?.tfStateIphone.text = "\(self.array_RegionsList[index].str_regionAbv)"
            }
        }
    }
}

extension SelectShippingAddressVc : addressShippingDelegate {
    func didCallAPIShipping(strID: String) {
        print(strID)
        StrID = strID
        isAddNewAdrs = false
        self.isCallUpdate = true
        self.callAPItoGetUserShippingAddress(strId: StrID)
    }
}

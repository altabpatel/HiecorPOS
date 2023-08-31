//
//  AdvancedSettingsViewController.swift
//  HieCOR
//
//  Created by Hiecor on 19/02/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import Foundation

class AdvancedSettingsViewController: BaseViewController, SWRevealViewControllerDelegate {
    
    //MARK: IBOutlet
    @IBOutlet var tbl_Settings: UITableView!
    @IBOutlet weak var backBtnLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: Variables
    private var array_List = Array<Any>()
    private var array_iconsList = Array<Any>()
    private var discountView: UIView?
    
    //MARK: Delegate
    var advanceSettingsDelegate: SettingViewControllerDelegate?
    
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if UI_USER_INTERFACE_IDIOM() == .pad {
            backBtnLeadingContraint.constant = 20
            backBtn.isHidden = true
        }else {
            backBtnLeadingContraint.constant = 60
            backBtn.isHidden = false
        }
        array_List = ["Coupons List", "Show Country", "Split Row", "Line Item Tax Exempt", "Discount Options", "Pin Login Every Transaction"]
        self.callAPItoGetCountryList()
        
        
    }
    
    @IBAction func advanceSettingBackAction(_ sender: Any) {
        advanceSettingsDelegate?.didMoveToNextScreen?(with: "Setting")
        
    }
}
//MARK: UITableViewDataSource, UITableViewDelegate
extension AdvancedSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_Settings.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! SettingsTableCell
        let lbl_Name = cell.contentView.viewWithTag(1) as? UILabel
        lbl_Name?.text = array_List[indexPath.row] as? String
        
//        let switchBtn = cell.contentView.viewWithTag(2) as? UISwitch
        //  discount_Switch = switchBtn
        let advacView = cell.contentView.viewWithTag(101)
        discountView = advacView
        let newTextField = cell.contentView.viewWithTag(100) as? UITextField
        let redTextfield = cell.contentView.viewWithTag(1004) as? UITextField
        let blueTextfield = cell.contentView.viewWithTag(1005) as? UITextField
        let greenTextfield = cell.contentView.viewWithTag(1006) as? UITextField
        cell.switchButton.removeTarget(self, action: #selector(btn_switchAction(sender:)), for: .allEvents) // for manage switch tag
        cell.switchButton.tag = indexPath.row
        cell.accessoryType = .none
        cell.accessoryView = nil
        discountView?.backgroundColor = UIColor.white
        discountView?.isHidden = !DataManager.isDiscountOptions
        if DataManager.isDiscountOptions {
            discountView?.isHidden = false
        }else {
            discountView?.isHidden = true
        }
        
        //cell.textfield.delegate = self
        redTextfield?.delegate = self
        blueTextfield?.delegate = self
        greenTextfield?.delegate = self
        
        
        redTextfield?.text = ""
        blueTextfield?.text = ""
        greenTextfield?.text = ""
        
        redTextfield?.setPadding()
        blueTextfield?.setPadding()
        greenTextfield?.setPadding()
        redTextfield?.setRightPadding()
        blueTextfield?.setRightPadding()
        greenTextfield?.setRightPadding()
        redTextfield?.keyboardType = .decimalPad
        blueTextfield?.keyboardType = .decimalPad
        greenTextfield?.keyboardType = .decimalPad
        redTextfield?.text = "\(DataManager.seventyDiscountValue.newValue)%"
        blueTextfield?.text = "\(DataManager.twentyDiscountValue.newValue)%"
        greenTextfield?.text = "\(DataManager.tenDiscountValue.newValue)%"
        newTextField?.isHidden = true
        if indexPath.row == 0 {
            cell.switchButton.setOn(DataManager.isCouponList, animated: false)
        }
        if indexPath.row == 2 {
            cell.switchButton.setOn(DataManager.isSplitRow, animated: false)
        }
        if indexPath.row == 3 {
            cell.switchButton.setOn(DataManager.isLineItemTaxExempt, animated: false)
        }
        if indexPath.row == 4 {
            //  bottomView?.isHidden = DataManager.isDiscountOptions
            cell.switchButton.setOn(DataManager.isDiscountOptions, animated: false)
            
        }
        if indexPath.row == 5 {
            cell.switchButton.setOn(DataManager.pinloginEveryTransaction, animated: false)
        }
        
        if array_List[indexPath.row] as? String == "Show Country" {
            newTextField?.isHidden = false
            newTextField?.placeholder = "Select Country"
            newTextField?.addLeftSidePadding()
            newTextField?.setDropDown()
            newTextField?.delegate = self
            
            newTextField?.superview?.tag = 1003
            
            newTextField?.isUserInteractionEnabled = DataManager.isShowCountry && NetworkConnectivity.isConnectedToInternet()
            cell.switchButton.isUserInteractionEnabled = DataManager.isShowCountry || NetworkConnectivity.isConnectedToInternet()
            newTextField?.alpha = DataManager.isShowCountry ? 1.0 : 0.5
            newTextField?.text = DataManager.selectedCountry
            cell.switchButton.setOn(DataManager.isShowCountry, animated: false)
            
        }
        //img?.image = UIImage(named: array_iconsList[indexPath.row] as! String)
        cell.switchButton.addTarget(self, action:#selector(btn_switchAction(sender:)), for: .touchUpInside)
       
        return cell
    }
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 4 && DataManager.isDiscountOptions {
            return 130
        }
        return 50//selectedIndex.contains(indexPath.section) ? (indexPath.section == 17 && DataManager.isDiscountOptions) ? 75 : 50 : 0
    }
    
    @objc func btn_switchAction(sender: UISwitch)
    {
        if sender.tag == 0 {
            DataManager.isCouponList = sender.isOn
            //  DataManager.isOffline = sender.isOn
        }
        if sender.tag == 1 {
            DataManager.isShowCountry = sender.isOn
            if !DataManager.isShowCountry {
                DataManager.selectedCountry = "US"
            }
            tbl_Settings.reloadData()
        }
        if sender.tag == 2 {
            DataManager.isSplitRow = sender.isOn
            // DataManager.isTaxOn = sender.isOn
        }
        if sender.tag == 3 {
            DataManager.isLineItemTaxExempt = sender.isOn
        }
        
        if sender.tag == 4 {
            
            
            DataManager.isDiscountOptions = sender.isOn
            //updatePaymentArray()
            tbl_Settings.reloadData()
            tbl_Settings.layoutIfNeeded()
            //   DataManager.isCustomerManagementOn = sender.isOn
            
        }
        if sender.tag == 5 {
            DataManager.pinloginEveryTransaction = sender.isOn
        }
        
    }
    @objc func doneAction() {
        self.view.endEditing(true)
    }
    
}

//MARK: UITextFieldDelegate
extension AdvancedSettingsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.superview?.tag == 1003 {
            if HomeVM.shared.countryDetail.count == 0 {
                textField.resignFirstResponder()
                self.callAPItoGetCountryList(textField: textField)
            }else {
                let array = HomeVM.shared.countryDetail.compactMap({$0.name})
                self.pickerDelegate = self
                textField.text = HomeVM.shared.countryDetail.first?.abbreviation
                DataManager.selectedCountry = HomeVM.shared.countryDetail.first?.abbreviation ?? ""
                setPickerView(textField: textField, array: array)
            }
            return
        }
        if textField.tag == 1004 || textField.tag == 1005 || textField.tag == 1006 {
            textField.selectAll(nil)
        }
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneAction))
        doneButton.tintColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1004 || textField.tag == 1005 || textField.tag == 1006 {
            let value = (Double(textField.text ?? "") ?? 0.0)
            if textField.tag == 1004 {
                DataManager.seventyDiscountValue = value
            }
            
            if textField.tag == 1005 {
                DataManager.twentyDiscountValue = value
            }
            
            if textField.tag == 1006 {
                DataManager.tenDiscountValue = value
            }
            
            self.tbl_Settings.reloadData()
            return
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }
        
        
        
        
        if textField.tag == 1004 || textField.tag == 1005 || textField.tag == 1006 {
            let replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            let amount = Double(replacementText) ?? 0.0
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
        }
        
        return charactersCount < 21
    }
    
}

//MARK: API Methods
extension AdvancedSettingsViewController {
    func callAPItoGetCountryList(textField: UITextField? = nil) {
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            return
        }
        
        HomeVM.shared.getCountryList(country: "") { (success, message, error) in
            if success == 1 {
                if textField != nil {
                    textField!.becomeFirstResponder()
                }
                self.tbl_Settings.reloadData()
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
}

//MARK: HieCORPickerDelegate
extension AdvancedSettingsViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        let array = HomeVM.shared.countryDetail.compactMap({$0.abbreviation})
        pickerTextfield.text = array[index]
    }
    
    func didClickOnPickerViewDoneButton() {
        DataManager.selectedCountry = pickerTextfield.text ?? ""
        pickerTextfield.resignFirstResponder()
        HomeVM.shared.regionsList.removeAll()
    }
    
    func didClickOnPickerViewCancelButton() {
        pickerTextfield.text = "US"
        DataManager.selectedCountry = "US"
        pickerTextfield.resignFirstResponder()
        HomeVM.shared.regionsList.removeAll()
    }
}

//
//  CheckoutOptionsListViewController.swift
//  HieCOR
//
//  Created by Hiecor on 17/02/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift


class CheckoutOptionsListViewController: BaseViewController, SettingViewControllerDelegate, SWRevealViewControllerDelegate {
    
    //MARK: IBOutlet
    @IBOutlet var tbl_Settings: UITableView!
    @IBOutlet weak var backBtnLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: Variables
    private var array_List = Array<Any>()
    private var array_iconsList = Array<Any>()
    var textF : DropDown?
    var tempSourcesName = ""
    var deviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
    //MARK: Delegate
    var checkoutOptionsSettingDelegate: SettingViewControllerDelegate?
    var deviceNameUpdateDelegate: SettingViewControllerDelegate?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        array_List = ["Device Name", "Taxes", "Customer Management", "Enable Auth", "Collect Tips", "Swipe To Pay", "Payment Method", "Signature And Receipt"]
        tbl_Settings.rowHeight = 50
        if UI_USER_INTERFACE_IDIOM() == .pad {
            backBtnLeadingContraint.constant = 20
            backBtn.isHidden = true
        }else {
            backBtnLeadingContraint.constant = 60
            backBtn.isHidden = false
        }
        tempSourcesName = DataManager.deviceNameText ?? deviceName
        
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    @IBAction func checkoutBackAction(_ sender: Any) {
        textF?.resignFirstResponder()
        checkoutOptionsSettingDelegate?.didMoveToNextScreen?(with: "Setting")
    }
    
    @objc func btn_DeviceNameAction(sender: UIButton) {
        if sender.tag == 6 {
            textF?.becomeFirstResponder()
        }
    }
    
    @objc func btn_switchAction(sender: UISwitch)
    {
        
        if sender.tag == 1 {
            DataManager.isTaxOn = sender.isOn
        }
        if sender.tag == 2 {
            DataManager.isCustomerManagementOn = sender.isOn
            // for Prompt Add Customer
            if !DataManager.isCustomerManagementOn{
                DataManager.isPromptAddCustomer = false
            }
        }
        
        if sender.tag == 3 {
            DataManager.isAuthentication = sender.isOn
        }
        if sender.tag == 4 {
            DataManager.collectTips = sender.isOn
            DataManager.tempCollectTips = sender.isOn
        }
        
        
        if sender.tag == 5 {
            DataManager.isSwipeToPay = sender.isOn
        }
        
    }
    func deviceNameUpdate(){
        tbl_Settings.reloadData()
    }
    
}
//MARK: UITableViewDataSource, UITableViewDelegate
extension CheckoutOptionsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_Settings.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! SettingsTableCell
        
        let lbl_Name = cell.contentView.viewWithTag(1) as? UILabel
        let switchBtn = cell.contentView.viewWithTag(2) as? UISwitch
        let img_Arrow = cell.contentView.viewWithTag(4) as? UIImageView
        
        //lbl_Name?.text = array_List[indexPath.row] as? String
        if indexPath.row != 0 {
            lbl_Name?.text = array_List[indexPath.row] as? String
        }
        
        if indexPath.row == 1 {
            switchBtn?.setOn(DataManager.isTaxOn, animated: false)
        }
        if indexPath.row == 2 {
            switchBtn?.setOn(DataManager.isCustomerManagementOn, animated: false)
        }
        if indexPath.row == 3 {
            switchBtn?.setOn(DataManager.isAuthentication, animated: false)
        }
        if indexPath.row == 4 {
            switchBtn?.setOn(DataManager.collectTips, animated: false)
        }
        if indexPath.row == 5 {
            switchBtn?.setOn(DataManager.isSwipeToPay, animated: false)
        }
        
        if array_List[indexPath.row] as? String == "Device Name" {
            switchBtn?.isHidden = true
            img_Arrow?.isHidden = true
            let textFeild = cell.contentView.viewWithTag(3) as? DropDown
            // let txt = textFeild as? DropDown
            textF = textFeild!
            
            textFeild?.didSelect(completion: { (str, index, id) in
                textFeild?.text = str.condenseWhitespace()
                DataManager.deviceNameText = str.condenseWhitespace()
                self.deviceNameUpdateDelegate?.deviceNameUpdate?(with: str.condenseWhitespace())
                textFeild?.searchText = str.condenseWhitespace()
                self.tempSourcesName = DataManager.deviceNameText!
            })
            textFeild?.optionArray = HomeVM.shared.sourcesList
            textFeild?.settingdelegate = self
            //            textFeild?.searchText = DataManager.deviceNameText ?? ""
            let deviceNameIcon = cell.contentView.viewWithTag(5) as? UIButton
            deviceNameIcon?.isHidden = false
            let editDebiveNameClickBtn = cell.contentView.viewWithTag(6) as? UIButton
            editDebiveNameClickBtn?.isHidden = false
            editDebiveNameClickBtn?.addTarget(self, action:#selector(btn_DeviceNameAction(sender:)), for: .touchUpInside)
            textFeild?.placeholder = "Enter Device Name"
            if let name = DataManager.deviceNameText {
                textFeild?.text = name
                //  textFeild?.searchText = name
            }else {
                textFeild?.text = deviceName
                // textFeild?.searchText = "POS"
            }
            
            textFeild?.isHidden = false
            textFeild?.keyboardType = .asciiCapable
            
            // textFeild?.delegate = self
            
            if DataManager.isDrawerOpen{
                textFeild?.isUserInteractionEnabled = false
                textFeild?.isUserInteractionEnabled = false
            }else{
                textFeild?.isUserInteractionEnabled = true
                textFeild?.isUserInteractionEnabled = true
            }
        }
        
        if array_List[indexPath.row] as? String == "Payment Method" {
            switchBtn?.isHidden = true
            img_Arrow?.isHidden = false
        }
        if array_List[indexPath.row] as? String == "Signature And Receipt" {
            switchBtn?.isHidden = true
            img_Arrow?.isHidden = false
        }
        
        switchBtn?.addTarget(self, action:#selector(btn_switchAction(sender:)), for: .touchUpInside)
        switchBtn?.tag = indexPath.row
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if array_List[indexPath.row] as? String == "Payment Method" || array_List[indexPath.row] as? String == "Signature And Receipt" {
            checkoutOptionsSettingDelegate?.didMoveToNextScreen?(with: array_List[indexPath.row] as! String)
        }
    }
    
}

//MARK: UITextFieldDelegate
extension CheckoutOptionsListViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var name = textField.text, name != "" {
            name = name.trimmingCharacters(in: .whitespaces).condenseWhitespace()
            name = name == "" ? deviceName : name
            DataManager.deviceNameText = name
            deviceNameUpdateDelegate?.deviceNameUpdate?(with: name)
            
        }else {
            DataManager.deviceNameText = deviceName
            deviceNameUpdateDelegate?.deviceNameUpdate?(with: deviceName)
            
        }
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        return true
    }
}
extension CheckoutOptionsListViewController: ChangeDeviceNamePopupVCDelegate {
    
    func deviceNameUpdatePopup(with string: String) {
        
        if string.trimmingCharacters(in: .whitespaces) == "" {
            // view_bgPopup.isHidden = true
            DataManager.deviceNameText = deviceName
            self.tempSourcesName = DataManager.deviceNameText!
            // posLabel.text = DataManager.deviceNameText
        }else {
            if  !HomeVM.shared.sourcesList.contains(string)  && tempSourcesName != string {
                self.showAlert(title:"Confirm", message: "This will generate a new location, are you sure you want to proceed?", otherButtons: [kCancel:{ (_) in
                    //...
                    
                    //    self.view_bgPopup.isHidden = true
                    // self.tbl_Settings.reloadData()
                    if DataManager.deviceNameText != "" && DataManager.deviceNameText != nil{
                        self.textF?.text = DataManager.deviceNameText
                    }else{
                        self.textF?.text = self.deviceName
                    }
                    
                }], cancelTitle:"OK") { (_) in
                    //    self.view_bgPopup.isHidden = true
                    if string != "" {
                        var name = string.condenseWhitespace()
                        name = name.trimmingCharacters(in: .whitespaces)
                        name = name == "" ? self.deviceName : name
                        DataManager.deviceNameText = name
                        self.deviceNameUpdateDelegate?.deviceNameUpdate?(with: name)
                        // self.delegate?.deviceNameUpdate?(with: name)
                        
                    }else {
                        DataManager.deviceNameText = self.deviceName
                        self.deviceNameUpdateDelegate?.deviceNameUpdate?(with: self.deviceName)
                        
                    }
                    self.tempSourcesName = DataManager.deviceNameText!
                    //  self.posLabel.text = DataManager.deviceNameText
                }
                
            }else{
                // view_bgPopup.isHidden = true
                if string != "" {
                    var name = string.condenseWhitespace()
                    name = name.trimmingCharacters(in: .whitespaces)
                    name = name == "" ? self.deviceName : name
                    DataManager.deviceNameText = name
                    self.deviceNameUpdateDelegate?.deviceNameUpdate?(with: name)
                    // self.delegate?.deviceNameUpdate?(with: name)
                    
                }else {
                    DataManager.deviceNameText = self.deviceName
                    self.deviceNameUpdateDelegate?.deviceNameUpdate?(with: self.deviceName)
                }
                self.tempSourcesName = DataManager.deviceNameText!
                //   posLabel.text = DataManager.deviceNameText
            }
        }
    }
    
}

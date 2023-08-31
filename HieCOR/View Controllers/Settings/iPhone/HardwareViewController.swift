//
//  HardwareViewController.swift
//  HieCOR
//
//  Created by Hiecor on 19/02/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

class HardwareViewController: BaseViewController, SWRevealViewControllerDelegate {
    
    //MARK: IBOutlet
    @IBOutlet var tbl_Settings: UITableView!
    @IBOutlet weak var backBtnLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: Variables
    private var array_List = Array<Any>()
    private var array_iconsList = Array<Any>()
    //var textF = UITextField()
     var textF : DropDown?
    var tempSourcesName = ""
    var deviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
    //MARK: Delegate
    var hardwareSettingDelegate: SettingViewControllerDelegate?
  //  var deviceNameUpdateDelegate: SettingViewControllerDelegate?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //array_List = ["Device Name", "USB/Headphone Jack Card Reader", "Printers", "Barcode Scanners"]
        //if UI_USER_INTERFACE_IDIOM() == .pad {
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing  {
                array_List = ["USB/Headphone Jack Card Reader", "Printers", "Barcode Scanners", "Customer Facing App"]
            }else{
                array_List = ["USB/Headphone Jack Card Reader", "Printers", "Barcode Scanners"]
            }
//        }else{
//            array_List = ["USB/Headphone Jack Card Reader", "Printers", "Barcode Scanners"]
//        }
       
        //array_List = ["USB/Headphone Jack Card Reader", "Printers", "Barcode Scanners", "Customer Facing App"]
        tbl_Settings.rowHeight = 50
        if UI_USER_INTERFACE_IDIOM() == .pad {
            backBtnLeadingContraint.constant = 20
            backBtn.isHidden = true
        }else {
            backBtnLeadingContraint.constant = 60
            backBtn.isHidden = false
        }
        
       // tempSourcesName = DataManager.deviceNameText ?? "POS"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    @IBAction func hardwareBackAction(_ sender: Any) {
       // textF?.resignFirstResponder()
        hardwareSettingDelegate?.didMoveToNextScreen?(with: "Setting")
    }
    
//    @objc func btn_DeviceNameAction(sender: UIButton) {
//        if sender.tag == 6 {
//            textF?.becomeFirstResponder()
//        }
//    }
    
    @objc func btn_switchAction(sender: UISwitch) {
        if sender.tag == 0 {
            DataManager.cardReaders = sender.isOn
        }
        if sender.tag == 2 {
            DataManager.isBarCodeReaderOn = sender.isOn
        }
    }
    
    func deviceNameUpdate(){
        tbl_Settings.reloadData()
    }
    
}
//MARK: UITableViewDataSource, UITableViewDelegate
extension HardwareViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_Settings.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! SettingsTableCell
        
        let lbl_Name = cell.contentView.viewWithTag(1) as? UILabel
        let switchBtn = cell.contentView.viewWithTag(2) as? UISwitch
        let img_Dropdown = cell.contentView.viewWithTag(4) as? UIImageView
        
      //  if indexPath.row != 0 {
            lbl_Name?.text = array_List[indexPath.row] as? String
      //  }
        
        
       /* if array_List[indexPath.row] as? String == "Device Name" {
            switchBtn?.isHidden = true
            img_Dropdown?.isHidden = true
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
                textFeild?.text = "POS"
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
        }*/
        
        if indexPath.row == 0 {
            switchBtn?.setOn(DataManager.cardReaders, animated: false)
        }
        if indexPath.row == 2 {
            switchBtn?.setOn(DataManager.isBarCodeReaderOn, animated: false)
        }
        
        if array_List[indexPath.row] as? String == "Printers" {
            switchBtn?.isHidden = true
            img_Dropdown?.isHidden = false
        }
        if array_List[indexPath.row] as? String == "Customer Facing App" {
            switchBtn?.isHidden = true
            img_Dropdown?.isHidden = true
        }
        switchBtn?.addTarget(self, action:#selector(btn_switchAction(sender:)), for: .touchUpInside)
        switchBtn?.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if array_List[indexPath.row] as? String == "Printers" {
            hardwareSettingDelegate?.didMoveToNextScreen?(with: array_List[indexPath.row] as! String)
        } else if array_List[indexPath.row] as? String == "Customer Facing App" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let customeFacingVCObj = storyboard.instantiateViewController(withIdentifier: "ConnectCustomeFacingVC") as! ConnectCustomeFacingVC
            customeFacingVCObj.modalPresentationStyle = .fullScreen
            present(customeFacingVCObj, animated: true, completion: nil)
        }
    }
}

/*//MARK: UITextFieldDelegate
extension HardwareViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var name = textField.text, name != "" {
            name = name.trimmingCharacters(in: .whitespaces).condenseWhitespace()
            name = name == "" ? "POS" : name
            DataManager.deviceNameText = name
            deviceNameUpdateDelegate?.deviceNameUpdate?(with: name)
            
        }else {
            DataManager.deviceNameText = "POS"
            deviceNameUpdateDelegate?.deviceNameUpdate?(with: "POS")
            
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
extension HardwareViewController: ChangeDeviceNamePopupVCDelegate {
    
    func deviceNameUpdatePopup(with string: String) {
  
        if string.trimmingCharacters(in: .whitespaces) == "" {
            // view_bgPopup.isHidden = true
            DataManager.deviceNameText = "POS"
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
                        self.textF?.text = "POS"
                    }
                    
                    }], cancelTitle:"OK") { (_) in
                        //    self.view_bgPopup.isHidden = true
                        if string != "" {
                            var name = string.condenseWhitespace()
                            name = name.trimmingCharacters(in: .whitespaces)
                            name = name == "" ? "POS" : name
                            DataManager.deviceNameText = name
                            self.deviceNameUpdateDelegate?.deviceNameUpdate?(with: name)
                            // self.delegate?.deviceNameUpdate?(with: name)
                            
                        }else {
                            DataManager.deviceNameText = "POS"
                            self.deviceNameUpdateDelegate?.deviceNameUpdate?(with: "POS")
                            
                        }
                        self.tempSourcesName = DataManager.deviceNameText!
                        //  self.posLabel.text = DataManager.deviceNameText
                }
                
            }else{
                // view_bgPopup.isHidden = true
                if string != "" {
                    var name = string.condenseWhitespace()
                    name = name.trimmingCharacters(in: .whitespaces)
                    name = name == "" ? "POS" : name
                    DataManager.deviceNameText = name
                    self.deviceNameUpdateDelegate?.deviceNameUpdate?(with: name)
                    // self.delegate?.deviceNameUpdate?(with: name)
                    
                }else {
                    DataManager.deviceNameText = "POS"
                    self.deviceNameUpdateDelegate?.deviceNameUpdate?(with: "POS")
                }
                self.tempSourcesName = DataManager.deviceNameText!
                //   posLabel.text = DataManager.deviceNameText
            }
        }
    }
    
}
*/

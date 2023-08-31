//
//  PaxHeartlandGiftCardViewController.swift
//  HieCOR
//
//  Created by Priya  on 24/06/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire

class PaxHeartlandGiftCardViewController: BaseViewController {
    
    @IBOutlet var viewBase: UIView!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var tfAmtReverse: UITextField!
    @IBOutlet var lblMsgResult: UILabel!
    @IBOutlet var tfAmtActivate: UITextField!
    @IBOutlet var tfDevice: UITextField!
    @IBOutlet var tfAmtLoad: UITextField!
    @IBOutlet weak var lblSelectDevice: UILabel!
    
    var isDeviceSelected = false
    var strPort = String()
    var strTempPort = String()
    var balanceModel = [GetBalanceModel]()
    var str_balanaceData = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        
        tfAmtLoad.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0),font: tfAmtLoad.font!)
        tfAmtReverse.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0),font: tfAmtReverse.font!)
        tfAmtActivate.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0),font: tfAmtActivate.font!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.revealViewController() != nil)
        {
            revealViewController().delegate = self as? SWRevealViewControllerDelegate
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    func loadUI() {
        //Add Shadow
        viewBase?.layer.shadowColor = UIColor.lightGray.cgColor
        viewBase?.layer.shadowOffset = CGSize.zero
        viewBase?.layer.shadowOpacity = 0.3
        viewBase?.layer.shadowRadius = 5.0
        viewBase?.layer.cornerRadius = 5
        lblMsgResult.isHidden = true
        let image = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
        btnMenu.setImage(image, for: .normal)
        btnMenu.tintColor = UIColor.white
        tfDevice.setPadding()
        tfDevice.setDropDown()
        self.callAPItoGetPAXDeviceList()
        
    }
    
    @IBAction func actionReplaceCard(_ sender: UIButton) {
        var isGreenBtn = false
           
        if sender.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        sender.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        let parameters: Parameters = [
            "type": "pax_gift",
            "terminal_port": strPort
        ]
        self.callAPIReplaceCard(parameters: parameters)
    }
    
    @IBAction func actionGetBalance(_ sender: UIButton) {
        var isGreenBtn = false
           
        if sender.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        sender.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        self.callAPItoGetBalance()
    }
    
    @IBAction func actionTfDevice(_ sender: UIButton) {
        var isGreenBtn = false
           
        if sender.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        sender.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        isDeviceSelected = true
        if HomeVM.shared.paxDeviceList.count > 0 {
            let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
            tfDevice.text = HomeVM.shared.paxDeviceList[0].name
            //url = HomeVM.shared.paxDeviceList[0].url
            if array.count == 1 {
                self.tfDevice.resignFirstResponder()
                return
            }
            self.pickerDelegate = self
            self.setPickerView(textField: tfDevice, array: array)
        }else {
            tfDevice.resignFirstResponder()
            self.callAPItoGetPAXDeviceList()
        }
    }
    
    @IBAction func actionAmtReverse(_ sender: UIButton) {
        var isGreenBtn = false
           
        if sender.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        sender.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if (tfAmtReverse.text?.isEmpty)!{
            tfAmtReverse.setCustomError(text: "Required.")
        }else{
            let parameters: Parameters = [
                "type": "pax_gift",
                "terminal_port": strPort,
                "amount": tfAmtReverse.text!,
                ]
            self.callAPIgiftCardReverse(parameters: parameters)
        }
    }
    
    @IBAction func actionDeactivateCard(_ sender: UIButton) {
        var isGreenBtn = false
           
        if sender.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        sender.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        let parameters: Parameters = [
            "type": "pax_gift",
            "terminal_port": strPort
        ]
        self.callAPIgiftCardDeactivate(parameters: parameters)
    }
    
    @IBAction func actionLoadBalance(_ sender: UIButton) {
        var isGreenBtn = false
           
        if sender.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        sender.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if (tfAmtLoad.text?.isEmpty)!{
            tfAmtLoad.setCustomError(text: "Required.")
        }else{
            let parameters: Parameters = [
                "type": "pax_gift",
                "amount": tfAmtLoad.text!,
                "terminal_port": strPort
            ]
            self.callAPILoadBalance(parameters: parameters)
        }
    }
    
    @IBAction func actionActivateCard(_ sender: UIButton) {
        
        var isGreenBtn = false
           
        if sender.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        sender.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        
        if (tfAmtActivate.text?.isEmpty)!{
            tfAmtActivate.setCustomError(text: "Required.")
        }else{
            let parameters: Parameters = [
                "type": "pax_gift",
                "terminal_port": strPort,
                "amount": tfAmtActivate.text!,
                ]
            self.callAPIgiftCardActivate(parameters: parameters)
        }
    }
}

//MARK: HieCORPickerDelegate
extension PaxHeartlandGiftCardViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        tfDevice.text = HomeVM.shared.paxDeviceList[index].name
        strPort = HomeVM.shared.paxDeviceList[index].port
    }
    
    func didClickOnPickerViewDoneButton() {
        tfDevice.resignFirstResponder()
        strTempPort = tfDevice.text!
    }
    
    func didClickOnPickerViewCancelButton() {
        if DataManager.selectedPaxDeviceName != "" {
            self.tfDevice.text = DataManager.selectedPaxDeviceName
        }else{
            if strTempPort == "" {
                 self.tfDevice.text = HomeVM.shared.paxDeviceList[0].name
            } else {
                self.tfDevice.text = strTempPort
            }
            
        }
    }
}

//MARK: API Methods
extension PaxHeartlandGiftCardViewController {
    
    func callAPItoGetPAXDeviceList() {
        HomeVM.shared.getPaxDeviceList(responseCallBack: { (success, message, error) in
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                self.tfDevice.isHidden = HomeVM.shared.paxDeviceList.count == 1
                self.lblSelectDevice.isHidden = HomeVM.shared.paxDeviceList.count == 1
                
                if HomeVM.shared.paxDeviceList.count > 0 {
                    if self.tfDevice.isEmpty {
                        if DataManager.selectedPaxDeviceName != "" {
                            self.tfDevice.text = DataManager.selectedPaxDeviceName
                        }else{
                            self.tfDevice.text = HomeVM.shared.paxDeviceList[0].name
                        }
                        //self.tfDevice.text = HomeVM.shared.paxDeviceList[0].name
                        self.strPort = HomeVM.shared.paxDeviceList[0].port
                    }
                }
                if self.isDeviceSelected {
                    self.tfDevice.becomeFirstResponder()
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
    
    //MARK call api to activate card
    func callAPIgiftCardActivate(parameters: JSONDictionary) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.giftCardActivate(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.lblMsgResult.isHidden = false
                self.tfAmtActivate.text = ""
                self.lblMsgResult.text = "Card Activated Successfully."
                self.lblMsgResult.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                print("success")
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                    // self.showAlert(message: message!)
                    self.lblMsgResult.text = ""
                    self.lblMsgResult.isHidden = false
                    self.lblMsgResult.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    self.lblMsgResult.text = message
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    //MARK call api to load balance
    func callAPILoadBalance(parameters: JSONDictionary) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.giftCardBalance(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.lblMsgResult.isHidden = false
                self.tfAmtLoad.text = ""
                self.lblMsgResult.text = "Balance loaded Successfully."
                self.lblMsgResult.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                print("success")
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                    //self.showAlert(message: message!)
                    self.lblMsgResult.text = ""
                    self.lblMsgResult.isHidden = false
                    self.lblMsgResult.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    self.lblMsgResult.text = message
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    //MARK call api to load balance
    func callAPItoGetBalance()
    {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        
        HomeVM.shared.giftGetBalance(number: strPort, type:"pax_gift",responseCallBack: { (success, message, error) in
            if success == 1 {
                self.balanceModel = HomeVM.shared.giftBalance
                for obj in self.balanceModel{
                    self.str_balanaceData = obj.str_balance
                }
                // self.tfLoadAmount.text = ""
                self.lblMsgResult.isHidden = false
                self.lblMsgResult.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                if self.str_balanaceData == ""{
                    self.lblMsgResult.text = "Current Balance:" + " " + "$" + "0"
                }else{
                    self.lblMsgResult.text = "Current Balance:" + " " + "$" + self.str_balanaceData
                }
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                    //self.showAlert(message: message!)
                    self.lblMsgResult.text = ""
                    self.lblMsgResult.isHidden = false
                    self.lblMsgResult.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    self.lblMsgResult.text = message
                } else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    //MARK call api to replace card
    func callAPIReplaceCard(parameters: JSONDictionary) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.giftCardReplace(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.lblMsgResult.isHidden = false
                self.lblMsgResult.text = "Card replace Successfully."
                self.lblMsgResult.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                print("success")
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                    //self.showAlert(message: message!)
                    self.lblMsgResult.text = ""
                    self.lblMsgResult.isHidden = false
                    self.lblMsgResult.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    self.lblMsgResult.text = message
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    //MARK call api to reverse card
    func callAPIgiftCardReverse(parameters: JSONDictionary) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.giftCardReverse(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.lblMsgResult.isHidden = false
                self.tfAmtReverse.text = ""
                self.lblMsgResult.text = "Card reverse Successfully."
                self.lblMsgResult.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                print("success")
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                    // self.showAlert(message: message!)
                    self.lblMsgResult.text = ""
                    self.lblMsgResult.isHidden = false
                    self.lblMsgResult.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    self.lblMsgResult.text = message
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    //MARK call api to deactivate card
    func callAPIgiftCardDeactivate(parameters: JSONDictionary) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.giftCardDeactivate(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.lblMsgResult.isHidden = false
                self.lblMsgResult.text = "Card deactivated Successfully."
                 self.lblMsgResult.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                print("success")
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                    // self.showAlert(message: message!)
                    self.lblMsgResult.text = ""
                    self.lblMsgResult.isHidden = false
                    self.lblMsgResult.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    self.lblMsgResult.text = message
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
}

extension PaxHeartlandGiftCardViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError(isAddAgain: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        var replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }
        
        if string == "\t" {
            return false
        }
        
        print(string)
        print(textField.text)
        
        if string == " " {
            return false
        }
        
        replacementText = replacementText.replacingOccurrences(of: "$", with: "")
        return replacementText.isValidDecimal(maximumFractionDigits: 2)
    }
}

//
//  HeartlandGiftCardViewController.swift
//  HieCOR
//
//  Created by Priya  on 24/06/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import MediaPlayer
import IQKeyboardManagerSwift

class HeartlandGiftCardViewController: BaseViewController {
    
    @IBOutlet var lblMsgResult: UILabel!
    @IBOutlet var tfAmtToReverse: UITextField!
    @IBOutlet var tfCardToReplace: UITextField!
    @IBOutlet var tfAmtLoad: UITextField!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var viewBase: UIView!
    @IBOutlet var tfAmtActivate: UITextField!
    @IBOutlet var tfGiftCardPin: UITextField!
    @IBOutlet var tfGiftCardNumber: UITextField!
    
    var balanceModel = [GetBalanceModel]()
    var str_balanaceData = String()
    var dummyCardNumber = String()
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var isCardReplace = false
    var cardSwipe = "tfGiftCardNumber"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfGiftCardNumber.delegate = self
        
        tfAmtLoad.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0),font: tfAmtLoad.font!)
        tfAmtActivate.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0),font: tfAmtActivate.font!)
        tfAmtToReverse.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0),font: tfAmtToReverse.font!)
        
        loadUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SwipeAndSearchVC.shared.isProductSearching = false
        SwipeAndSearchVC.shared.imagReadLib?.start()
        self.enableCardReader()
        
        if (self.revealViewController() != nil)
        {
            revealViewController().delegate = self as? SWRevealViewControllerDelegate
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
                    //self.showAlert(message: message!)
                    self.lblMsgResult.isHidden = false
                    self.lblMsgResult.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                    self.lblMsgResult.text = message
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    //MARK call api to replace card
    func callAPIReplaceCard(parameters: JSONDictionary) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.giftCardReplace(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.lblMsgResult.isHidden = false
                self.tfCardToReplace.text = ""
                self.lblMsgResult.text = "Card replace Successfully."
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
    
    //MARK call api to reverse card
    func callAPIgiftCardReverse(parameters: JSONDictionary) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.giftCardReverse(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.lblMsgResult.isHidden = false
                self.tfAmtToReverse.text = ""
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
    
    //MARK call api to load balance
    func callAPItoGetBalance()
    {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        
        HomeVM.shared.giftGetBalance(number: tfGiftCardNumber.text!, type:"gift",responseCallBack: { (success, message, error) in
            if success == 1 {
                self.balanceModel = HomeVM.shared.giftBalance
                for obj in self.balanceModel{
                    self.str_balanaceData = obj.str_balance
                }
                // self.tfLoadAmount.text = ""
                self.lblMsgResult.isHidden = false
                if self.str_balanaceData == ""{
                    self.lblMsgResult.text = "Current Balance:" + " " + "$" + "0"
                }else{
                    self.lblMsgResult.text = "Current Balance:" + " " + "$" + self.str_balanaceData
                }
                self.lblMsgResult.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
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
    
    @IBAction func actionDeactivate(_ sender: Any) {
        if (tfGiftCardNumber.text?.isEmpty)!{
            tfGiftCardNumber.setCustomError(text: "Required.")
        }else{
            let parameters: Parameters = [
                "type": "gift",
                "number": tfGiftCardNumber.text!,
                "giftcard_pin": tfGiftCardPin.text!
            ]
            self.callAPIgiftCardDeactivate(parameters: parameters)
        }
    }
    
    @IBAction func actionReverse(_ sender: UIButton) {
        var isGreenBtn = false
           
        if sender.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        sender.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if (tfGiftCardNumber.text?.isEmpty)!{
            tfGiftCardNumber.setCustomError(text: "Required.")
        }else if (tfAmtToReverse.text?.isEmpty)!{
            tfAmtToReverse.setCustomError(text: "Required.")
        }else{
            let parameters: Parameters = [
                "type": "gift",
                "number": tfGiftCardNumber.text!,
                "amount": tfAmtToReverse.text!,
                "giftcard_pin": tfGiftCardPin.text!
            ]
            self.callAPIgiftCardReverse(parameters: parameters)
        }
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
        if (tfGiftCardNumber.text?.isEmpty)!{
            tfGiftCardNumber.setCustomError(text: "Required.")
        }else if (tfCardToReplace.text?.isEmpty)!{
            tfCardToReplace.setCustomError(text: "Required.")
        }else{
            let parameters: Parameters = [
                "type": "gift",
                "number": tfGiftCardNumber.text!,
                "replace_gift_number": tfCardToReplace.text!,
                "giftcard_pin": tfGiftCardPin.text!
            ]
            self.callAPIReplaceCard(parameters: parameters)
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
        if (tfGiftCardNumber.text?.isEmpty)!{
            tfGiftCardNumber.setCustomError(text: "Required.")
        }else if (tfAmtActivate.text?.isEmpty)!{
            tfAmtActivate.setCustomError(text: "Required.")
        }else{
            let parameters: Parameters = [
                "type": "gift",
                "number": tfGiftCardNumber.text!,
                "amount": tfAmtActivate.text!,
                "giftcard_pin": tfGiftCardPin.text!
            ]
            self.callAPIgiftCardActivate(parameters: parameters)
        }
    }
    
    @IBAction func actionGetBalanace(_ sender: UIButton) {
        var isGreenBtn = false
           
        if sender.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        sender.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if tfGiftCardNumber.text == "" {
            tfGiftCardNumber.setCustomError(text: "Required.")
        } else {
            self.callAPItoGetBalance()
        }
        
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
        if (tfGiftCardNumber.text?.isEmpty)!{
            tfGiftCardNumber.setCustomError(text: "Required.")
        }else if (tfAmtLoad.text?.isEmpty)!{
            tfAmtLoad.setCustomError(text: "Required.")
        }else{
            let parameters: Parameters = [
                "type": "gift",
                "number": tfGiftCardNumber.text!,
                "amount": tfAmtLoad.text!,
                "giftcard_pin": tfGiftCardPin.text!
            ]
            self.callAPILoadBalance(parameters: parameters)
        }
    }
}

extension HeartlandGiftCardViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError(isAddAgain: false)
        if textField == tfGiftCardNumber {
            isCardReplace = false
            cardSwipe = "tfGiftCardNumber"
        } else  if textField == tfCardToReplace {
            isCardReplace = true
            cardSwipe = "tfCardToReplace"
        } else {
            cardSwipe = "data"
        }
        //enableCardReader()
//         if Keyboard._isExternalKeyboardAttached() {
//                enableCardReader()
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //self.enableCardReader()
        if Keyboard._isExternalKeyboardAttached() {
                   textField.resignFirstResponder()
                   //SwipeAndSearchVC.shared.enableTextField()
                   return
               }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfGiftCardNumber  || textField == tfCardToReplace {
            let isSingleBeepSwiper = String(describing: dummyCardNumber.prefix(1)) == ";"
            if (String(describing: dummyCardNumber.prefix(2)) != "%B" && !isSingleBeepSwiper) || (String(describing: dummyCardNumber.prefix(1)) != ";" && isSingleBeepSwiper) {
                self.tfGiftCardNumber.tintColor = UIColor.blue
                self.dummyCardNumber = ""
                textField.resignFirstResponder()
                return true
            }
            
            let cardNumberArray = dummyCardNumber.split(separator: isSingleBeepSwiper ? "=" : "^")
            if isSingleBeepSwiper ? cardNumberArray.count > 1 : cardNumberArray.count > 2 {
                let number = String(describing: String(describing: cardNumberArray.first ?? "").dropFirst(isSingleBeepSwiper ? 1 : 2))
                if cardSwipe == "tfCardToReplace" {
                    tfCardToReplace.resetCustomError()
                    tfCardToReplace.text = number
                } else {
                    tfGiftCardNumber.resetCustomError()
                    tfGiftCardNumber.text = number
                }
                
            }else {
                if cardSwipe == "tfCardToReplace" {
                    if tfCardToReplace.isEmpty {
                        tfCardToReplace.setCustomError()
                    }
                } else {
                    if tfGiftCardNumber.isEmpty {
                        tfGiftCardNumber.setCustomError()
                    }
                }
               
            }
        }
        self.dummyCardNumber = ""
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        dummyCardNumber.append(string)
        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            textField.tintColor = UIColor.clear
            return false
        }
        dummyCardNumber = ""
        
        if textField == tfGiftCardNumber || textField == tfCardToReplace{
            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            //enableCardReader()
            return string == filtered
        } else {
            let currentText = textField.text ?? ""
            var replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let amount = Double(replacementText) ?? 0.0
            //return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
            
             replacementText = replacementText.replacingOccurrences(of: "$", with: "")
            return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
    }
}

////MARK: UITextFieldDelegate
//extension HeartlandGiftCardViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //Handle Swipe Reader Data
//        if textField == tfGiftCardNumber  {
//            let isSingleBeepSwiper = String(describing: dummyCardNumber.prefix(1)) == ";"
//            if (String(describing: dummyCardNumber.prefix(2)) != "%B" && !isSingleBeepSwiper) || (String(describing: dummyCardNumber.prefix(1)) != ";" && isSingleBeepSwiper) {
//                self.tfGiftCardNumber.tintColor = UIColor.blue
//                self.dummyCardNumber = ""
//                textField.resignFirstResponder()
//                return true
//            }
//
//            let cardNumberArray = dummyCardNumber.split(separator: isSingleBeepSwiper ? "=" : "^")
//            if isSingleBeepSwiper ? cardNumberArray.count > 1 : cardNumberArray.count > 2 {
//                let number = String(describing: String(describing: cardNumberArray.first ?? "").dropFirst(isSingleBeepSwiper ? 1 : 2))
//
//                tfGiftCardNumber.resetCustomError(isAddAgain: false)
//                tfGiftCardNumber.text = number
//            }else {
//                if tfGiftCardNumber.isEmpty {
//                    tfGiftCardNumber.setCustomError()
//                }
//            }
//        }
//        self.tfGiftCardNumber.tintColor = UIColor.blue
//        self.dummyCardNumber = ""
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        //Handle Swipe Reader Data
//        dummyCardNumber.append(string)
//        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
//            textField.tintColor = UIColor.clear
//            return false
//        }
//        dummyCardNumber = ""
//
//        if textField == tfGiftCardNumber {
//            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
//            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
//            let filtered = string.components(separatedBy: cs).joined(separator: "")
//            if charactersCount > 50 {
//                return false
//            }
//            return string == filtered
//        }
//
//        return false
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == tfGiftCardNumber {
//            tfGiftCardNumber.resetCustomError(isAddAgain: false)
//        }
//        textField.hideAssistantBar()
//
//        if Keyboard._isExternalKeyboardAttached() {
//            IQKeyboardManager.shared.enableAutoToolbar = false
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        //Check For External Accessory
//        if Keyboard._isExternalKeyboardAttached() {
//            textField.resignFirstResponder()
//            SwipeAndSearchVC.shared.enableTextField()
//            return
//        }
//    }
//}
//MARK: PaymentTypeDelegate
extension HeartlandGiftCardViewController: PaymentTypeDelegate {
    func updateError(textfieldIndex: Int, message: String) {
        tfGiftCardNumber.setCustomError(text: message, bottomSpace: 2)
    }
    
    //    func saveData() {
    //        self.view.endEditing(true)
    //        PaymentsViewController.paymentDetailDict["data"] = ["cardpin":tf_CardPin.text ?? "", "giftcardnumber":tf_GiftCardNumber.text ?? "" ]
    //    }
    
    func disableCardReader() {
        //        SwipeAndSearchVC.delegate = nil
    }
    
    func enableCardReader() {
        
        delegate?.disableCardReaders?()
        SwipeAndSearchVC.delegate = nil
        SwipeAndSearchVC.delegate = self
        //SwipeAndSearchVC.shared.enableTextField()
    }
    
    //    func sendGiftCardData(isIPad: Bool) {
    //        let Obj = ["cardpin":tf_CardPin.text ?? "", "giftcardnumber":tf_GiftCardNumber.text ?? "" ]
    //        delegate?.getPaymentData?(with: Obj)
    //
    //        if UI_USER_INTERFACE_IDIOM() == .pad {
    //            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
    //        }
    //    }
    
    func reset() {
        tfGiftCardNumber.resetCustomError(isAddAgain: false)
        tfGiftCardNumber.text = ""
    }
}

//MARK: SwipeReaderVCVCDelegate
extension HeartlandGiftCardViewController: SwipeAndSearchDelegate {
    func didGetCardDetail(number: String, month: String, year: String) {
        if cardSwipe == "tfCardToReplace" {
            tfCardToReplace.resetCustomError(isAddAgain: false)
            tfCardToReplace.text = number
            enableCardReader()
        } else if cardSwipe == "tfGiftCardNumber" {
            tfGiftCardNumber.resetCustomError(isAddAgain: false)
            tfGiftCardNumber.text = number
            enableCardReader()
        }
        
    }
    
    func noCardDetailFound() {
        if cardSwipe == "tfCardToReplace" {
            tfCardToReplace.setCustomError()
        } else if cardSwipe == "tfGiftCardNumber"  {
            tfGiftCardNumber.setCustomError()
        }
        
    }
    
    func didUpdateDevice() {
        if cardSwipe == "tfCardToReplace" {
             tfCardToReplace.resetCustomError(isAddAgain: false)
        } else if cardSwipe == "tfGiftCardNumber"  {
             tfGiftCardNumber.resetCustomError(isAddAgain: false)
        }
    }
}

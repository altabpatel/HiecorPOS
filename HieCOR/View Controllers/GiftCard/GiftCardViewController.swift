//
//  GiftCardViewController.swift
//  HieCOR
//
//  Created by Priya  on 18/03/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire

class GiftCardViewController: BaseViewController  {
    
    @IBOutlet var tfGiftCardNumber: UITextField!
    @IBOutlet var viewBase: UIView!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var tfLoadAmount: UITextField!
    @IBOutlet var btnLoadBalance: UIButton!
    @IBOutlet var labelHeader: UILabel!
    @IBOutlet weak var viewLoadBalance: UIView!
    @IBOutlet weak var hieghtConstLoadBalanceView: NSLayoutConstraint!
    
    var balanceModel = [GetBalanceModel]()
    var str_balanaceData = String()
    var str_numberText = String()
    var dummyCardNumber = String()
    var isGiftCard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelHeader.isHidden = true
        loadUI()
        
        tfLoadAmount.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0),font: tfLoadAmount.font!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableCardReader()
        if (self.revealViewController() != nil)
        {
            revealViewController().delegate = self as? SWRevealViewControllerDelegate
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    
    func updateError(textfieldIndex: Int, message: String) {
        switch textfieldIndex {
        case 1:
            tfGiftCardNumber.setCustomError(text: message, bottomSpace: 2.0)
            break
        case 2:
            tfLoadAmount.setCustomError(text: message, bottomSpace: 2)
            break
        default: break
        }
    }
    
    //MARK load UI
    func loadUI() {
        //Add Shadow
        viewBase?.layer.shadowColor = UIColor.lightGray.cgColor
        viewBase?.layer.shadowOffset = CGSize.zero
        viewBase?.layer.shadowOpacity = 0.3
        viewBase?.layer.shadowRadius = 5.0
        viewBase?.layer.cornerRadius = 5
        
        let image = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
        btnMenu.setImage(image, for: .normal)
        btnMenu.tintColor = UIColor.white
        if DataManager.loadGiftCardOnlyOnPurchase != "true"{
            viewLoadBalance.isHidden = false
            hieghtConstLoadBalanceView.constant = 75
        }else{
            viewLoadBalance.isHidden = true
            hieghtConstLoadBalanceView.constant = 0
        }
    }
    
    //MARK Call giftCard balance api
    func callAPILoadBalance(parameters: JSONDictionary) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.giftCardBalance(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.tfLoadAmount.text = ""
                self.labelHeader.isHidden = false
                self.labelHeader.text = "Balance loaded Successfully."
                print("success")
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    //Validate Data
    private func isValidData() -> Bool {
        if tfGiftCardNumber.isEmpty {
            
            updateError(textfieldIndex: 1, message: "Please enter Gift Card Number.")
            return false
        }
        
        if tfLoadAmount.isEmpty {
            
            updateError(textfieldIndex: 2, message: "Please enter Amount.")
            return false
        }
        return true
    }
    
    // MARK Call API for get balance
    func callAPItoGetBalance()
    {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        
        HomeVM.shared.giftGetBalance(number: tfGiftCardNumber.text!, type:"internal_gift",responseCallBack: { (success, message, error) in
            if success == 1 {
                self.balanceModel = HomeVM.shared.giftBalance
                for obj in self.balanceModel{
                    self.str_balanaceData = obj.str_balance
                }
                self.tfLoadAmount.text = ""
                self.labelHeader.isHidden = false
                if self.str_balanaceData == ""{
                    self.labelHeader.text = "Current Balance:" + " " + "$" + "0"
                }else{
                    self.labelHeader.text = "Current Balance:" + " " + "$" + self.str_balanaceData
                }
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            } else {
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
    
    
    @IBAction func actionGetBalance(_ sender: UIButton) {
        var isGreenBtn = false
           
        if sender.backgroundColor == #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) {
            isGreenBtn = true
        }
        sender.backgroundColor = isGreenBtn == false ? #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor = isGreenBtn ? #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if (tfGiftCardNumber.text?.isEmpty)!{
            updateError(textfieldIndex: 1, message: "Please enter Gift Card Number.")
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
        if tfGiftCardNumber.text == "" {
            updateError(textfieldIndex: 1, message: "Please enter Gift Card Number.")
        } else if tfLoadAmount.text == "" {
            updateError(textfieldIndex: 2, message: "Please enter Amount.")
        } else {
            callLoadAPI()
        }
        
    }
    
    func callLoadAPI()  {
        let parameters: Parameters = [
            "type": "internal_gift",
            "number": tfGiftCardNumber.text!,
            "amount": tfLoadAmount.text!
        ]
        self.callAPILoadBalance(parameters: parameters)
        str_numberText = tfGiftCardNumber.text!
    }
    
    func enableCardReader() {
        
        //delegate?.disableCardReaders?()
        SwipeAndSearchVC.delegate = nil
        SwipeAndSearchVC.delegate = self
        //SwipeAndSearchVC.shared.enableTextField()
    }
    
}

//MARK: UITextFieldDelegate
extension GiftCardViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.resetCustomError()
//        if textField == tfGiftCardNumber {
//            isGiftCard = true
//            self.enableCardReader()
//        } else {
//            isGiftCard = false
//            SwipeAndSearchVC.delegate = nil
//        }
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfGiftCardNumber {
            tfGiftCardNumber.resetCustomError(isAddAgain: false)
        }
        if textField == tfLoadAmount {
            tfLoadAmount.selectAll(nil)
        }
        textField.hideAssistantBar()
        
//        if Keyboard._isExternalKeyboardAttached() {
//            IQKeyboardManager.shared.enableAutoToolbar = false
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == tfGiftCardNumber {
//            self.enableCardReader()
//        } else {
//            SwipeAndSearchVC.delegate = nil
//        }
        
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Handle Swipe Reader Data
        if textField == tfGiftCardNumber  {
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
                
                tfGiftCardNumber.resetCustomError()
                tfGiftCardNumber.text = number
            }else {
                if tfGiftCardNumber.isEmpty {
                    tfGiftCardNumber.setCustomError()
                }
            }
        }
        self.tfGiftCardNumber.tintColor = UIColor.blue
        self.dummyCardNumber = ""
        textField.resignFirstResponder()
        return true
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            
//            if textField == tfGiftCardNumber  {
//                let isSingleBeepSwiper = String(describing: dummyCardNumber.prefix(1)) == ";"
//                if (String(describing: dummyCardNumber.prefix(2)) != "%B" && !isSingleBeepSwiper) || (String(describing: dummyCardNumber.prefix(1)) != ";" && isSingleBeepSwiper) {
//                    self.tfGiftCardNumber.tintColor = UIColor.blue
//                    self.dummyCardNumber = ""
//                    textField.resignFirstResponder()
//                    return true
//                }
//                
//                let cardNumberArray = dummyCardNumber.split(separator: isSingleBeepSwiper ? "=" : "^")
//                if isSingleBeepSwiper ? cardNumberArray.count > 1 : cardNumberArray.count > 2 {
//                    let number = String(describing: String(describing: cardNumberArray.first ?? "").dropFirst(isSingleBeepSwiper ? 1 : 2))
//                    
//                    tfGiftCardNumber.resetCustomError()
//                    tfGiftCardNumber.text = number
//                }else {
//                    if tfGiftCardNumber.isEmpty {
//                        tfGiftCardNumber.setCustomError()
//                    }
//                }
//                
//            } else {
//                textField.resignFirstResponder()
//                //Validate Data
//                if self.isValidData() {
//                    self.callLoadAPI()
//                }
//            }
//
//        enableCardReader()
//        return true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Handle Swipe Reader Data
        dummyCardNumber.append(string)
        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            textField.tintColor = UIColor.clear
            return false
        }
        dummyCardNumber = ""
        
        if textField == tfLoadAmount {
            let currentText = textField.text ?? ""
            var replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let amount = Double(replacementText) ?? 0.0
            //return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
            
             replacementText = replacementText.replacingOccurrences(of: "$", with: "")
            return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
        
        if textField == tfGiftCardNumber {
            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            //enableCardReader()
            return string == filtered
        }
        return false
    }
    
}

//MARK: SwipeReaderVCVCDelegate
extension GiftCardViewController: SwipeAndSearchDelegate {
    func didGetCardDetail(number: String, month: String, year: String) {
        //if isGiftCard {
            tfGiftCardNumber.resetCustomError(isAddAgain: false)
                   tfGiftCardNumber.text = number
                   //SwipeAndSearchVC.delegate = self
                   enableCardReader()
        //}
        //callValidateToChangeColor()
    }
    
    func noCardDetailFound() {
        if tfGiftCardNumber.isEmpty {
            tfGiftCardNumber.setCustomError()
            //disableValidateToChangeColor()
        }
    }
    
    func didUpdateDevice() {
        tfGiftCardNumber.resetCustomError(isAddAgain: false)
        //disableValidateToChangeColor()
    }
    
}

////MARK: PaymentTypeDelegate
//extension GiftCardViewController: PaymentTypeDelegate {
//    func updateError(textfieldIndex: Int, message: String) {
//        tfGiftCardNumber.setCustomError(text: message, bottomSpace: 2)
//    }
//
//    func didUpdateTotal(amount: Double , subToal : Double) {
//        tfAmount.text = amount.currencyFormatA
//        total = amount
//        callValidateToChangeColor()
//    }
//
//    func saveData() {
//        self.view.endEditing(true)
//        PaymentsViewController.paymentDetailDict["data"] = ["internalGiftCardNumber":tf_GiftCardNumber.text ?? "" ]
//    }
//
//    func disableCardReader() {
//        //        SwipeAndSearchVC.delegate = nil
//    }
//
//    func enableCardReader() {
//        //delegate?.disableCardReaders?()
//        SwipeAndSearchVC.delegate = nil
//        SwipeAndSearchVC.delegate = self
//        //        SwipeAndSearchVC.shared.enableTextField()
//    }
//
//    func sendInternalGiftCardData(isIPad: Bool) {
////        let Obj = ["internalGiftCardNumber":tfGiftCardNumber.text ?? "", "amount": tfAmount.text ?? "" ]
////        delegate?.getPaymentData?(with: Obj)
////
////        if UI_USER_INTERFACE_IDIOM() == .pad {
////            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
////        }
//    }
//
//    func reset() {
//        tfGiftCardNumber.resetCustomError(isAddAgain: false)
//        tfGiftCardNumber.text = ""
//        //disableValidateToChangeColor()
//    }
//
//}

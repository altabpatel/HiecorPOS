//
//  CheckContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CheckContainerViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tf_CheckNumber: UITextField!
    @IBOutlet weak var tf_CheckAmount: UITextField!
    
    //MARK: Variables
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var totalAmount = Double()
    var total = Double()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Delegate To Self
        tf_CheckAmount.delegate = self
        tf_CheckNumber.delegate = self
        //
        tf_CheckAmount.text = total.currencyFormatA
        tf_CheckAmount.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0), font: tf_CheckAmount.font!)
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            MultiCardContainerViewController.isClassLoaded = false
        }
        //Update Previous Data If Available
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key.lowercased() == "check" {
            if let data = PaymentsViewController.paymentDetailDict["data"] as? JSONDictionary {
                tf_CheckAmount.text = data["checkamount"] as? String ?? ""
                tf_CheckNumber.text = data["checknumber"] as? String ?? ""
                callValidateToChangeColor()
            }
        }
        tf_CheckAmount.addTarget(self, action: #selector(handleAmountTextField(sender:)), for: .editingChanged)
        tf_CheckNumber.addTarget(self, action: #selector(handleCardNumberTextField(sender:)), for: .editingChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Enter Value  viewDidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Enter Value  viewWillAppear")
        super.viewWillAppear(true)
        if HomeVM.shared.DueShared > 0 {
            tf_CheckAmount.text = HomeVM.shared.DueShared.currencyFormatA
        } else {
            tf_CheckAmount.text = total.currencyFormatA
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tf_CheckAmount.updateCustomBorder()
        tf_CheckNumber.updateCustomBorder()
    }
    
    func callValidateToChangeColor() {
        let obEx = (tf_CheckAmount.text! as NSString).replacingOccurrences(of: "$", with: "")
        
        if DataManager.isSplitPayment {
            if UI_USER_INTERFACE_IDIOM() == .pad{
                if tf_CheckAmount.text != "" && tf_CheckNumber.text != "" {
                    delegate?.checkPayButtonColorChange?(isCheck: true, text: "CHECK")
                }else{
                    delegate?.checkPayButtonColorChange?(isCheck: false, text: "CHECK")
                }
            } else {
                if tf_CheckAmount.text != "" && tf_CheckNumber.text != ""{
                    delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "CHECK")
                }else{
                    delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CHECK")
                }
            }
            
        } else {
            if UI_USER_INTERFACE_IDIOM() == .pad{
                if tf_CheckAmount.text != ""  && tf_CheckNumber.text != "" && ((obEx as NSString).doubleValue == totalAmount ||  totalAmount < (obEx as NSString).doubleValue)  {
                    delegate?.checkPayButtonColorChange?(isCheck: true, text: "CHECK")
                }else{
                    delegate?.checkPayButtonColorChange?(isCheck: false, text: "CHECK")
                }
            }else{
                if tf_CheckAmount.text != "" && tf_CheckNumber.text != "" && ((obEx as NSString).doubleValue == totalAmount ||  totalAmount < (obEx as NSString).doubleValue)  {
                    delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "CHECK")
                }else{
                    delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CHECK")
                }
            }
        }
        
    }
    func disableValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad{
            if tf_CheckAmount.text == "" || (tf_CheckAmount.text != String(totalAmount) ||  tf_CheckAmount.text! < String(totalAmount)) || tf_CheckNumber.text == ""  {
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "CHECK")
            }
        }else{
            if tf_CheckAmount.text == "" || (tf_CheckAmount.text != String(totalAmount) ||  tf_CheckAmount.text! < String(totalAmount)) || tf_CheckNumber.text == ""  {
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CHECK")
            }
        }
    }
    
    @objc func handleAmountTextField(sender: UITextField) {
        
        callValidateToChangeColor()
    }
    
    @objc func handleCardNumberTextField(sender: UITextField) {
        
        callValidateToChangeColor()
    }
}

//MARK: PaymentTypeDelegate
extension CheckContainerViewController: PaymentTypeDelegate {
    func updateError(textfieldIndex: Int, message: String) {
        if textfieldIndex == 1 {
            tf_CheckAmount.setCustomError(text: message, bottomSpace: 2)
        }else {
            tf_CheckNumber.setCustomError(text: message, bottomSpace: 2)
        }
    }
    
    func saveData() {
        self.view.endEditing(true)
        PaymentsViewController.paymentDetailDict["data"] = ["checkamount":tf_CheckAmount.text ?? "", "checknumber":tf_CheckNumber.text ?? ""]
    }
    
    func sendCheckData(isIPad: Bool) {
        let Obj = ["checkamount":tf_CheckAmount.text ?? "", "checknumber":tf_CheckNumber.text ?? ""]
        delegate?.getPaymentData?(with: Obj)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func reset() {
        tf_CheckAmount.text = ""
        tf_CheckNumber.text = ""
        tf_CheckAmount.resetCustomError(isAddAgain: false)
        tf_CheckNumber.resetCustomError(isAddAgain: false)
        disableValidateToChangeColor()
    }
    
    func didUpdateTotal(amount: Double , subToal : Double) {
        print("amount",amount)
        totalAmount = amount
        total = amount
        tf_CheckAmount.text = amount.currencyFormatA
        callValidateToChangeColor()
    }
    
}

//MARK: UITextFieldDelegate
extension CheckContainerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Check For External Accessory
        if DataManager.isSplitPayment {
            if textField == tf_CheckAmount {
                delegate?.balanceDueRemaining?(with: tf_CheckAmount.text?.toDouble() ?? 0.0)
            }
        }
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError(isAddAgain: false)
        textField.hideAssistantBar()
        if textField == tf_CheckAmount {
            tf_CheckAmount.selectAll(nil)
        }
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        
        if textField == tf_CheckAmount {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            callValidateToChangeColor()
            let amount = Double(replacementText) ?? 0.0
            if HomeVM.shared.DueShared > 0 {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= HomeVM.shared.DueShared
            } else {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= total
            }
            //return replacementText.isValidDecimal(maximumFractionDigits: 2)
            
        }
        
        if textField == tf_CheckNumber {
//            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
//            let filtered = string.components(separatedBy: cs).joined(separator: "")
//            if charactersCount > 50 {
//                return false
//            }
            callValidateToChangeColor()
            return true //string == filtered
        }
        
        return false
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        if DataManager.isSplitPayment {
            if textField == tf_CheckAmount {
                delegate?.balanceDueRemaining?(with: tf_CheckAmount.text?.toDouble() ?? 0.0)
            }
        }
        disableValidateToChangeColor()
        textField.resignFirstResponder()
        return false
    }
}

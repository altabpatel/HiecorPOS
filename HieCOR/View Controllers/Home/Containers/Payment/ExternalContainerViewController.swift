//
//  ExternalContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ExternalContainerViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var tf_Amount: UITextField!
    @IBOutlet weak var tf_Approval_No: UITextField!
    
    //MARK: Variables
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var totalAmount = Double()
    var total = Double()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Delegate To Self
        tf_Amount.delegate = self
        tf_Approval_No.delegate = self
        tf_Amount.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0),font: tf_Amount.font!)
        //
        if UI_USER_INTERFACE_IDIOM() == .phone {
            MultiCardContainerViewController.isClassLoaded = false
            
        }
        //Update Previous Data If Available
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key.lowercased() == "external" {
            if let data = PaymentsViewController.paymentDetailDict["data"] as? JSONDictionary {
                tf_Amount.text = data["amount"] as? String ?? ""
                tf_Approval_No.text = data["external_approval_number"] as? String ?? ""
                callValidateToChangeColor()
            }
        }
        tf_Amount.addTarget(self, action: #selector(handleCardNumberTextField(sender:)), for: .editingChanged)
        tf_Amount.isUserInteractionEnabled = DataManager.isSplitPayment
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Enter Value  viewDidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Enter Value  viewWillAppear")
        if HomeVM.shared.DueShared > 0 {
            tf_Amount.text = HomeVM.shared.DueShared.currencyFormatA
        } else {
            tf_Amount.text = total.currencyFormatA
        }
    }
    
    @objc func handleCardNumberTextField(sender: UITextField) {
        
        callValidateToChangeColor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tf_Amount.updateCustomBorder()
    }
    
    func callValidateToChangeColor() {
        let obEx = (tf_Amount.text! as NSString).replacingOccurrences(of: "$", with: "")
        if DataManager.isSplitPayment {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if (tf_Amount.text != "" && tf_Approval_No.text != "") {
                    delegate?.checkPayButtonColorChange?(isCheck: true, text: "EXTERNAL")
                }else{
                    delegate?.checkPayButtonColorChange?(isCheck: false, text: "EXTERNAL")
                }
            } else {
                if (tf_Amount.text != "" && tf_Approval_No.text != "") {
                    delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "EXTERNAL")
                }else{
                    delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "EXTERNAL")
                }
            }
            
        } else {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if tf_Amount.text != "" && ((obEx as NSString).doubleValue == totalAmount ||  totalAmount < (obEx as NSString).doubleValue)  && tf_Approval_No.text != "" {
                    delegate?.checkPayButtonColorChange?(isCheck: true, text: "EXTERNAL")
                }else{
                    delegate?.checkPayButtonColorChange?(isCheck: false, text: "EXTERNAL")
                }
            }else{
                if tf_Amount.text != "" && ((obEx as NSString).doubleValue == totalAmount ||  totalAmount < (obEx as NSString).doubleValue) && tf_Approval_No.text != "" {
                    delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "EXTERNAL")
                }else{
                    delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "EXTERNAL")
                }
            }
        }
        
    }
    
    func disableValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if tf_Amount.text == "" || (tf_Amount.text != String(totalAmount) ||  tf_Amount.text! < String(totalAmount)) || tf_Approval_No.text!.count == 0  {
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "EXTERNAL")
            }
        }else{
            if tf_Amount.text == "" || (tf_Amount.text != String(totalAmount) ||  tf_Amount.text! < String(totalAmount)) || tf_Approval_No.text!.count == 0 {
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "EXTERNAL")
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension ExternalContainerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError(isAddAgain: false)
        textField.hideAssistantBar()
        if textField == tf_Amount {
            tf_Amount.selectAll(nil)
        }
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tf_Amount {
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
        if textField == tf_Approval_No{
            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
            let cs = NSCharacterSet(charactersIn: "[QWERTYUIOPLKJHGFDSAZXCVBNM1234567890-=poiuytrewqasdfghjkl;'/.,mnbvcxz!@#$%^&*() ]").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            callValidateToChangeColor()
            return string == filtered
            //            if  tf_Approval_No.text != "" && tf_Approval_No.isValidApprovalNo() {
            //                tf_Approval_No.setCustomError(text: "Please Do not Enter special characters", bottomSpace: 0)
            //                //return false
            //           }
            //callValidateToChangeColor()
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Check For External Accessory
        callValidateToChangeColor()
        if DataManager.isSplitPayment {
            if textField == tf_Amount {
                delegate?.balanceDueRemaining?(with: tf_Amount.text?.toDouble() ?? 0.0)
            }
        }
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        if DataManager.isSplitPayment {
            if textField == tf_Amount {
                delegate?.balanceDueRemaining?(with: tf_Amount.text?.toDouble() ?? 0.0)
            }
        }
        disableValidateToChangeColor()
        textField.resignFirstResponder()
        return false
    }
    
}

//MARK: PaymentTypeDelegate
extension ExternalContainerViewController: PaymentTypeDelegate {
    func updateError(textfieldIndex: Int, message: String) {
        if textfieldIndex == 1 {
            tf_Amount.setCustomError(text: message, bottomSpace: 2)
        }else{
            tf_Approval_No.setCustomError(text: message, bottomSpace: 2)
        }
    }
    
    func saveData() {
        self.view.endEditing(true)
        PaymentsViewController.paymentDetailDict["data"] = ["amount":tf_Amount.text ?? "", "external_approval_number":tf_Approval_No.text ?? ""]

    }
    
    func sendExternalCardData(isIPad: Bool) {
        let Obj = ["amount":tf_Amount.text ?? "", "external_approval_number":tf_Approval_No.text ?? ""]

        delegate?.getPaymentData?(with: Obj)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func reset() {
        tf_Amount.text = ""
        tf_Approval_No.text = ""
        tf_Amount.resetCustomError(isAddAgain: false)
        disableValidateToChangeColor()
    }
    
    func didUpdateTotal(amount: Double , subToal : Double) {
        print("amount",amount)
        totalAmount = amount
        tf_Amount.text = amount.currencyFormatA
        callValidateToChangeColor()
    }
    
}

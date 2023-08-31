//
//  InternalGiftCardViewController.swift
//  HieCOR
//
//  Created by Deftsoft on 29/10/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import IQKeyboardManagerSwift

class InternalGiftCardViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tf_GiftCardNumber: UITextField!
    @IBOutlet weak var constTopCard: NSLayoutConstraint!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var tfAmount: UITextField!
    
    //MARK: Variables
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var dummyCardNumber = String()
    var total = Double()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Delegate To Self
        tf_GiftCardNumber.delegate = self
        tfAmount.delegate = self
        tfAmount.setDollar()
        tfAmount.text = total.currencyFormatA
        if DataManager.isSplitPayment {
            viewAmount.isHidden = false
        } else {
            viewAmount.isHidden = true
            constTopCard.constant = 20
        }
        //
        if UI_USER_INTERFACE_IDIOM() == .phone {
            MultiCardContainerViewController.isClassLoaded = false
        }
        //Update Previous Data If Available
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key.lowercased() == "internal gift card" {
            if let data = PaymentsViewController.paymentDetailDict["data"] as? JSONDictionary {
                tf_GiftCardNumber.text = data["internalGiftCardNumber"] as? String ?? ""
                callValidateToChangeColor()
            }
        }
        
        tf_GiftCardNumber.addTarget(self, action: #selector(handleCardNumberTextField(sender:)), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Enter Value  viewDidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Enter Value  viewWillAppear")
        if HomeVM.shared.DueShared > 0 {
            tfAmount.text = HomeVM.shared.DueShared.currencyFormatA
        } else {
            tfAmount.text = total.currencyFormatA
        }
    }
    
    @objc func handleCardNumberTextField(sender: UITextField) {
        
        callValidateToChangeColor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tf_GiftCardNumber.updateCustomBorder()
    }
    
    func callValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if tf_GiftCardNumber.text != "" && tf_GiftCardNumber.text!.count >= 1  {
                delegate?.checkPayButtonColorChange?(isCheck: true, text: "INTERNAL GIFT CARD")
            }else{
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "INTERNAL GIFT CARD")
            }
        }else{
            if tf_GiftCardNumber.text != "" && tf_GiftCardNumber.text!.count >= 1  {
                delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "INTERNAL GIFT CARD")
            }else{
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "INTERNAL GIFT CARD")
            }
        }
    }
    func disableValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if tf_GiftCardNumber.text == "" ||  tf_GiftCardNumber.text!.count == 0 {
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "INTERNAL GIFT CARD")
            }
        }else{
            if tf_GiftCardNumber.text == "" ||  tf_GiftCardNumber.text!.count == 0 {
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "INTERNAL GIFT CARD")
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension InternalGiftCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Handle Swipe Reader Data
        if textField == tf_GiftCardNumber  {
            let isSingleBeepSwiper = String(describing: dummyCardNumber.prefix(1)) == ";"
            if (String(describing: dummyCardNumber.prefix(2)) != "%B" && !isSingleBeepSwiper) || (String(describing: dummyCardNumber.prefix(1)) != ";" && isSingleBeepSwiper) {
                self.tf_GiftCardNumber.tintColor = UIColor.blue
                self.dummyCardNumber = ""
                textField.resignFirstResponder()
                return true
            }
            
            let cardNumberArray = dummyCardNumber.split(separator: isSingleBeepSwiper ? "=" : "^")
            if isSingleBeepSwiper ? cardNumberArray.count > 1 : cardNumberArray.count > 2 {
                let number = String(describing: String(describing: cardNumberArray.first ?? "").dropFirst(isSingleBeepSwiper ? 1 : 2))
                
                tf_GiftCardNumber.resetCustomError()
                tf_GiftCardNumber.text = number
            }else {
                if tf_GiftCardNumber.isEmpty {
                    tf_GiftCardNumber.setCustomError()
                }
            }
        }
        self.tf_GiftCardNumber.tintColor = UIColor.blue
        self.dummyCardNumber = ""
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Handle Swipe Reader Data
        dummyCardNumber.append(string)
        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            textField.tintColor = UIColor.clear
            return false
        }
        dummyCardNumber = ""
        
        if textField == tfAmount {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let amount = Double(replacementText) ?? 0.0
            //return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
            
            if HomeVM.shared.DueShared > 0 {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= HomeVM.shared.DueShared
            } else {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= total
            }
        }
        
        if textField == tf_GiftCardNumber {
            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            callValidateToChangeColor()
            return string == filtered
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tf_GiftCardNumber {
            tf_GiftCardNumber.resetCustomError(isAddAgain: false)
        }
        if textField == tfAmount {
            tfAmount.selectAll(nil)
        }
        textField.hideAssistantBar()
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        callValidateToChangeColor()
        //Check For External Accessory
        if DataManager.isSplitPayment {
            if textField == tfAmount {
                appDelegate.amount = tfAmount.text?.toDouble() ?? 0.0
                delegate?.balanceDueRemaining?(with: tfAmount.text?.toDouble() ?? 0.0)
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
        disableValidateToChangeColor()
        textField.resignFirstResponder()
        return false
    }
}

//MARK: PaymentTypeDelegate
extension InternalGiftCardViewController: PaymentTypeDelegate {
    func updateError(textfieldIndex: Int, message: String) {
        tf_GiftCardNumber.setCustomError(text: message, bottomSpace: 2)
    }
    
    func didUpdateTotal(amount: Double , subToal : Double) {
        tfAmount.text = amount.currencyFormatA
        total = amount
        callValidateToChangeColor()
    }
    
    func saveData() {
        self.view.endEditing(true)
        PaymentsViewController.paymentDetailDict["data"] = ["internalGiftCardNumber":tf_GiftCardNumber.text ?? "" ]
    }
    
    func disableCardReader() {
        //        SwipeAndSearchVC.delegate = nil
    }
    
    func enableCardReader() {
        delegate?.disableCardReaders?()
        SwipeAndSearchVC.delegate = nil
        SwipeAndSearchVC.delegate = self
        //        SwipeAndSearchVC.shared.enableTextField()
    }
    
    func sendInternalGiftCardData(isIPad: Bool) {
        let Obj = ["internalGiftCardNumber":tf_GiftCardNumber.text ?? "", "amount": tfAmount.text ?? "" ]
        delegate?.getPaymentData?(with: Obj)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func reset() {
        tf_GiftCardNumber.resetCustomError(isAddAgain: false)
        tf_GiftCardNumber.text = ""
        disableValidateToChangeColor()
    }
    
}

//MARK: SwipeReaderVCVCDelegate
extension InternalGiftCardViewController: SwipeAndSearchDelegate {
    func didGetCardDetail(number: String, month: String, year: String) {
        tf_GiftCardNumber.resetCustomError(isAddAgain: false)
        tf_GiftCardNumber.text = number
        callValidateToChangeColor()
    }
    
    func noCardDetailFound() {
        if tf_GiftCardNumber.isEmpty {
            tf_GiftCardNumber.setCustomError()
            disableValidateToChangeColor()
        }
    }
    
    func didUpdateDevice() {
        tf_GiftCardNumber.resetCustomError(isAddAgain: false)
        disableValidateToChangeColor()
    }
    
}


//
//  CashViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CashViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var viewBaseBottom: NSLayoutConstraint!
    @IBOutlet weak var viewBaseHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewNumber: UIView!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var ViewStackDollar: UIStackView!
    @IBOutlet weak var tf_Cash: UITextField!
    @IBOutlet weak var btnZero: UIButton!
    @IBOutlet weak var btnLessThan: UIButton!
    @IBOutlet weak var labelReturn: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var btnDollarTotal: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: Variables
    var resigned = Bool()
    var cash = String()
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var totalCashAmount = String()
    var cartAmount = 0.00
    var customerAmount = 0.00
    var dueAmount = 0.00
    var changeAmt = 0.00
    var dummyCardNumber = String()
    
    //MARK: Private Variables
    private var ACCEPTABLE_CHARACTERS = "0123456789.$"
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Delegate To Self
        tf_Cash.delegate = self
        tf_Cash.setDollar(color: UIColor.darkGray, font: tf_Cash.font!)
        //Add Target
        tf_Cash.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        scrollView.isScrollEnabled = UIScreen.main.bounds.size.width < 414.0
        //
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.updateView()
            MultiCardContainerViewController.isClassLoaded = false
        }else {
            self.btnLessThan.imageEdgeInsets = UIEdgeInsets(top: 25, left: 20, bottom: 25, right: 20)
        }
        //Update Previous Data If Available
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key.lowercased() == "cash" {
            if let data = PaymentsViewController.paymentDetailDict["data"] as? JSONDictionary {
                let cashNew = (data["cash"] as? String ?? "").replacingOccurrences(of: "$", with: "")
                tf_Cash.text = cashNew
                cash = "$"+cashNew
                callValidateToChangeColor()
            }
        }
        
        let origImage = UI_USER_INTERFACE_IDIOM() == .pad ? UIImage(named: "backSpace") : UIImage(named: "left-arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btnLessThan.setImage(tintedImage, for: .normal)
        btnLessThan.tintColor = UIColor(red: 11/255, green: 118/255, blue: 201/255, alpha: 1)
        // MARK Hide for V5
        if HomeVM.shared.DueShared > 0{
            HomeVM.shared.DueShared = Double(HomeVM.shared.DueShared) ?? 0.0
            btnDollarTotal.setTitle(("$" + ceil(HomeVM.shared.DueShared).roundToTwoDecimal), for: .normal)
        }else{
            cartAmount = Double(totalCashAmount) ?? 0.0
            btnDollarTotal.setTitle(("$" + ceil(cartAmount).roundToTwoDecimal), for: .normal)
        }
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            heightConstraint.constant = 0.0
        }
        calculateAmount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let cartData = DataManager.cartData {
            let val = cartData["balance_due"] as? Double ?? 0.0
            
            if val != 0 {
                totalCashAmount = "\(val)"
            }
        }
        
        if HomeVM.shared.DueShared > 0{
            HomeVM.shared.DueShared = Double(totalCashAmount) ?? 0.0
            btnDollarTotal.setTitle(("$" + ceil(HomeVM.shared.DueShared).roundToTwoDecimal), for: .normal)
        }else{
            cartAmount = Double(totalCashAmount) ?? 0.0
            btnDollarTotal.setTitle(("$" + ceil(cartAmount).roundToTwoDecimal), for: .normal)
        }
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            heightConstraint.constant = 0.0
        }
        calculateAmount()
        self.updateView()
    }
    
    func updateView() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if UIDevice.current.orientation.isPortrait {
                viewBaseBottom.constant = 200
            }else{
                viewBaseBottom.constant = 10
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if UIDevice.current.orientation.isPortrait {
                viewBaseBottom.constant = 200
            }else{
                viewBaseBottom.constant = 10
            }
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tf_Cash.updateCustomBorder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: Private Functions
    private func setInitialValue() {
        // MARK Hide for V5
        if HomeVM.shared.DueShared > 0{
            HomeVM.shared.DueShared = Double(totalCashAmount) ?? 0.0
        }else{
            cartAmount = Double(totalCashAmount) ?? 0.0
        }
    }
    
    private func calculateAmount() {
        tf_Cash.resetCustomError(isAddAgain: false)
        if let text =  tf_Cash.text , text.count > 0 {
            customerAmount  =  Double(text) ?? 0
        }else{
            customerAmount = 0.00
        }
        // MARK Hide for V5
        if HomeVM.shared.DueShared > 0{
            if customerAmount > HomeVM.shared.DueShared{
                changeAmt = customerAmount - HomeVM.shared.DueShared
                dueAmount = 0.00
            }else{
                changeAmt = 0.0
                dueAmount = HomeVM.shared.DueShared - customerAmount
            }
        }else{
            if customerAmount > cartAmount {
                changeAmt = customerAmount - cartAmount
                dueAmount = 0.00
            }else{
                changeAmt = 0.0
                dueAmount = cartAmount - customerAmount
            }
        }
        
        cash = "$" + customerAmount.roundToTwoDecimal
        updateUI()
    }
    
    private func updateUI() {
        // MARK Hide for V5
        labelReturn.text = "$\(changeAmt.roundToTwoDecimal)"
        if HomeVM.shared.DueShared > 0 {
            labelTotal.text = "$\(dueAmount.roundToTwoDecimal)"
            delegate?.didUpdateCashValue?(returnDue: labelReturn.text!, totalDue: labelTotal.text!)
        }else{
            labelTotal.text = "$\(dueAmount.roundToTwoDecimal)"
            delegate?.didUpdateCashValue?(returnDue: labelReturn.text!, totalDue: labelTotal.text!)
        }
        if DataManager.isSplitPayment {
            //if textField == tf_Cash {
                delegate?.balanceDueRemaining?(with: tf_Cash.text?.toDouble() ?? 0.0)
            //}
        }
        callValidateToChangeColor()
    }
    
    //MARK: IBAction
    @IBAction func actionNumbers(_ sender: UIButton) {
        let tag = sender.tag
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        if let text = tf_Cash.text {
            if Double(text) == 0 {
                tf_Cash.text = ""
            }
        }
        
        if let text = tf_Cash.text {
            if text.contains(".") {
                let indexOfDot = text.distance(from: text.startIndex, to: text.index(of: ".")!)
                let totalIndexes = text.count - 1
                if (totalIndexes - indexOfDot) < 2 {
                    tf_Cash.text = "\(text)\(tag)"
                }
            } else {
                tf_Cash.text = "\(text)\(tag)"
            }
        } else {
            tf_Cash.text = "\(tag)"
        }
        
        calculateAmount()
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        tf_Cash.text = ""
        calculateAmount()
    }
    
    
    
    @IBAction func actionDot(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        if let text = tf_Cash.text {
            if !text.contains("."){
                tf_Cash.text = text.count == 0 ? "0\(text)." : "\(text)."
            }
        }else{
            tf_Cash.text = "0."
        }
        calculateAmount()
    }
    
    @IBAction func actionClear(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        if let text = tf_Cash.text , text.count > 0 {
            let start = text.index(text.startIndex, offsetBy: 0)
            let end = text.index(text.endIndex, offsetBy: -1)
            let result = text[start..<end]
            tf_Cash.text = String(result)
        }
        calculateAmount()
        disableValidateToChangeColor()
    }
    
    @IBAction func actionDollar(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8, green: 0.9058823529, blue: 1, alpha: 0.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  #colorLiteral(red: 0.8, green: 0.9058823529, blue: 1, alpha: 1)
        }
        if sender.tag == 0{
            let title = sender.titleLabel?.text?.replacingOccurrences(of: "$", with: "") ?? "0.0"
            let amt = Double(title) ?? 0.0
            tf_Cash.text = amt.roundToTwoDecimal
            callValidateToChangeColor()
        }else{
            tf_Cash.text = Double(customerAmount + Double(sender.tag)).roundToTwoDecimal
            callValidateToChangeColor()
        }
        calculateAmount()
    }
    
    func callValidateToChangeColor() {
        let obEx = (tf_Cash.text! as NSString).replacingOccurrences(of: "$", with: "")
        if DataManager.isSplitPayment {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if tf_Cash.text != "" {
                    delegate?.checkPayButtonColorChange?(isCheck: true, text: "CASH")
                }else{
                    delegate?.checkPayButtonColorChange?(isCheck: false, text: "CASH")
                }
            } else {
                if tf_Cash.text != "" {
                    delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "CASH")
                }else{
                    delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CASH")
                }
            }
            
        } else {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if tf_Cash.text != "" && (tf_Cash.text?.toDouble()?.currencyFormatA == totalCashAmount.toDouble()?.currencyFormatA || cartAmount < (obEx as NSString).doubleValue ) {
                    delegate?.checkPayButtonColorChange?(isCheck: true, text: "CASH")
                }else{
                    delegate?.checkPayButtonColorChange?(isCheck: false, text: "CASH")
                }
            }else{
                if tf_Cash.text != "" && (tf_Cash.text?.toDouble()?.currencyFormatA == totalCashAmount.toDouble()?.currencyFormatA || cartAmount < (obEx as NSString).doubleValue ) {
                    delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "CASH")
                }else{
                    delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CASH")
                }
            }
        }
        
    }
    
    func disableValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if tf_Cash.text == "" && (tf_Cash.text != totalCashAmount || tf_Cash.text! < totalCashAmount) {
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "CASH")
            }
        }else{
            if tf_Cash.text == "" && (tf_Cash.text != totalCashAmount || tf_Cash.text! < totalCashAmount) {
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CASH")
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension CashViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        //Handle Swipe Reader Data
        dummyCardNumber.append(string)
        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            return false
        }
        dummyCardNumber = ""
        
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        callValidateToChangeColor()
        return replacementText.isValidDecimal(maximumFractionDigits: 2)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cash = "$"+tf_Cash.text!
        if DataManager.isSplitPayment {
            if textField == tf_Cash {
                delegate?.balanceDueRemaining?(with: tf_Cash.text?.toDouble() ?? 0.0)
            }
        }
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dummyCardNumber = ""
        tf_Cash.resetCustomError(isAddAgain: false)
        textField.hideAssistantBar()
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
            calculateAmount()
        }else{
            tf_Cash.resignFirstResponder()
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        labelReturn.text = "$0.00"
        if DataManager.isSplitPayment {
            if textField == tf_Cash {
                delegate?.balanceDueRemaining?(with: tf_Cash.text?.toDouble() ?? 0.0)
            }
        }
        disableValidateToChangeColor()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        calculateAmount()
    }
    
}

extension CashViewController: PaymentTypeDelegate {
    func didUpdateTotal(amount: Double , subToal : Double) {
        // MARK Hide for V5
        
        if HomeVM.shared.DueShared > 0{
            totalCashAmount = "\(amount)"
            btnDollarTotal.setTitle(("$" + ceil(amount).roundToTwoDecimal), for: .normal)
        }else{
            totalCashAmount = "\(amount)"
            
            cartAmount = amount
            btnDollarTotal.setTitle(("$" + ceil(amount).roundToTwoDecimal), for: .normal)
        }
        calculateAmount()
    }
    
    func updateError(textfieldIndex: Int, message: String) {
        // MARK Hide for V5
        if HomeVM.shared.DueShared > 0 {
            tf_Cash.setCustomError(text: message, bottomSpace: 2)
        }else{
            tf_Cash.setCustomError(text: message, bottomSpace: 2)
        }
    }
    
    func saveData() {
        self.view.endEditing(true)
        // MARK Hide for V5
        if HomeVM.shared.DueShared > 0{
            PaymentsViewController.paymentDetailDict["data"] = ["cash": HomeVM.shared.DueShared]
        }else{
            PaymentsViewController.paymentDetailDict["data"] = ["cash": cash]
        }
    }
    
    func sendCashData(isIPad: Bool) {
        let Obj = ["cash":cash]
        UserDefaults.standard.set(changeAmt, forKey: "changeAmountKey")
        delegate?.getPaymentData?(with: Obj)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func reset() {
        tf_Cash.resetCustomError(isAddAgain: false)
        tf_Cash.text = ""
        // MARK Hide for V5
        if HomeVM.shared.DueShared > 0{
            btnDollarTotal.setTitle(("$" + ceil(HomeVM.shared.DueShared).roundToTwoDecimal), for: .normal)
        }else{
            cartAmount = Double(totalCashAmount) ?? 0.0
            btnDollarTotal.setTitle(("$" + ceil(cartAmount).roundToTwoDecimal), for: .normal)
        }
        calculateAmount()
        disableValidateToChangeColor()
    }
}

//
//  ACHcheckContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ACHcheckContainerViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tf_DLNumber: UITextField!
    @IBOutlet weak var tf_DLState: UITextField!
    @IBOutlet weak var tf_AccountNumber: UITextField!
    @IBOutlet weak var tf_RoutingNumber: UITextField!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var tf_Amount: UITextField!
    @IBOutlet weak var constTopCard: NSLayoutConstraint!
    
    
    //MARK: Variables
    var array_RegionsList = [RegionsListModel]()
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var total = Double()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        //
        if UI_USER_INTERFACE_IDIOM() == .phone {
            MultiCardContainerViewController.isClassLoaded = false
        }
        tf_Amount.delegate = self
        tf_Amount.setDollar()
        tf_Amount.text = total.currencyFormatA
        
        if DataManager.isSplitPayment {
            viewAmount.isHidden = false
        } else {
            viewAmount.isHidden = true
            constTopCard.constant = 20
        }
        //Update Previous Data If Available
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key.lowercased() == "ach check" {
            if let data = PaymentsViewController.paymentDetailDict["data"] as? JSONDictionary {
                tf_RoutingNumber.text = data["routingnumber"] as? String ?? ""
                tf_AccountNumber.text = data["accountnumber"] as? String ?? ""
                tf_DLState.text = data["dlstate"] as? String ?? ""
                tf_DLNumber.text = data["dlnumber"] as? String ?? ""
                callValidateToChangeColor()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Enter Value  viewDidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Enter Value  viewWillAppear")
        super.viewWillAppear(true)
        customizeUI()
        if HomeVM.shared.DueShared > 0 {
            tf_Amount.text = HomeVM.shared.DueShared.currencyFormatA
        } else {
            tf_Amount.text = total.currencyFormatA
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tf_RoutingNumber.updateCustomBorder()
        tf_AccountNumber.updateCustomBorder()
        tf_DLNumber.updateCustomBorder()
        tf_DLState.updateCustomBorder()
    }
    
    //MARK: Private Functions
    private func setDelegates() {
        tf_DLState.delegate = self
        tf_DLNumber.delegate = self
        tf_RoutingNumber.delegate = self
        tf_AccountNumber.delegate = self
    }
    
    private func customizeUI() {
        tf_DLState.setDropDown()
    }
    
    //MARK: IBAction
    @IBAction func tf_DLStateAction(_ sender: Any)
    {
        let array = array_RegionsList.compactMap({$0.str_regionName})
        if array.count > 0 {
            self.pickerDelegate = self
            self.setPickerView(textField: tf_DLState, array: array)
        }else {
            tf_DLState.resignFirstResponder()
            self.callAPItoGetRegionList(isTextField: true)
        }
    }
    
    func callValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad{
            if tf_RoutingNumber.text != ""  && tf_AccountNumber.text != ""  && tf_DLNumber.text != "" && tf_DLState.text != ""{
                delegate?.checkPayButtonColorChange?(isCheck: true, text: "ACH CHECK")
            }else{
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "ACH CHECK")
            }
        }else{
            if tf_RoutingNumber.text != ""  && tf_AccountNumber.text != ""  && tf_DLNumber.text != "" && tf_DLState.text != ""{
                delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "ACH CHECK")
            }else{
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "ACH CHECK")
            }
        }
    }
    func disableValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad{
            if tf_RoutingNumber.text == "" || tf_AccountNumber.text == ""  || tf_DLNumber.text == ""  || tf_DLState.text == ""  {
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "ACH CHECK")
            }
        }else{
            if tf_RoutingNumber.text == "" || tf_AccountNumber.text == ""  || tf_DLNumber.text == ""  || tf_DLState.text == ""  {
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "ACH CHECK")
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension ACHcheckContainerViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError(isAddAgain: false)
        textField.hideAssistantBar()
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        if textField == tf_Amount {
            tf_Amount.selectAll(nil)
        }
        
        if textField == tf_DLState {
            if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (DataManager.selectedCountry ?? "")}) {
                let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                    self.tf_DLState.text = text
                    self.callValidateToChangeColor()
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        let cs = NSCharacterSet(charactersIn: "0123456789").inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        if charactersCount > 50 {
            return false
        }
        if textField == tf_Amount {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let amount = Double(replacementText) ?? 0.0
            if HomeVM.shared.DueShared > 0 {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= HomeVM.shared.DueShared
            } else {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= total
            }
            //return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
            //return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= total
        }
        callValidateToChangeColor()
        return string == filtered
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Check For External Accessory
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
        disableValidateToChangeColor()
        textField.resignFirstResponder()
        return false
    }
}

//MARK: API Methods
extension ACHcheckContainerViewController {
    func callAPItoGetRegionList(isTextField: Bool? = false) {
        HomeVM.shared.getRegionList { (success, message, error) in
            if success == 1 {
                self.array_RegionsList = HomeVM.shared.regionsList
                if isTextField! {
                    self.tf_DLState.becomeFirstResponder()
                }
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

//MARK: PaymentTypeDelegate
extension ACHcheckContainerViewController: PaymentTypeDelegate {
    func updateError(textfieldIndex: Int, message: String) {
        switch textfieldIndex {
        case 1:
            tf_RoutingNumber.setCustomError(text: message, bottomSpace: 2)
            break
        case 2:
            tf_AccountNumber.setCustomError(text: message, bottomSpace: 2)
            break
        case 3:
            tf_DLNumber.setCustomError(text: message, bottomSpace: 2)
            break
        case 4:
            tf_DLState.setCustomError(text: message, bottomSpace: 2)
            break
        default: break
        }
    }
    
    func loadClassData() {
        self.callAPItoGetRegionList()
    }
    
    func saveData() {
        self.view.endEditing(true)
        PaymentsViewController.paymentDetailDict["data"] = ["routingnumber":tf_RoutingNumber.text ?? "", "accountnumber":tf_AccountNumber.text ?? "", "dlstate":tf_DLState.text ?? "" , "dlnumber":tf_DLNumber.text ?? ""]
    }
    
    func didUpdateTotal(amount: Double , subToal : Double) {
           print("amount",amount)
           total = amount
           tf_Amount.text = amount.currencyFormatA
           //appDelegate.CardReaderAmount = txfAmount.text?.toDouble() ?? 0.0
           callValidateToChangeColor()
       }
    
    func sendACHCheckData(isIPad: Bool) {
        let Obj = ["routingnumber":tf_RoutingNumber.text ?? "", "accountnumber":tf_AccountNumber.text ?? "", "dlstate":tf_DLState.text ?? "" , "dlnumber":tf_DLNumber.text ?? "", "amount":tf_Amount.text ?? ""]
        delegate?.getPaymentData?(with: Obj)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func reset() {
        tf_RoutingNumber.text = ""
        tf_AccountNumber.text = ""
        tf_DLState.text = ""
        tf_DLNumber.text = ""
        tf_RoutingNumber.resetCustomError(isAddAgain: false)
        tf_AccountNumber.resetCustomError(isAddAgain: false)
        tf_DLState.resetCustomError(isAddAgain: false)
        tf_DLNumber.resetCustomError(isAddAgain: false)
        disableValidateToChangeColor()
    }
    
}

//MARK: HieCORPickerDelegate
extension ACHcheckContainerViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        tf_DLState.text = "\(self.array_RegionsList[index].str_regionAbv)"
        callValidateToChangeColor()
    }
}

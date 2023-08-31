//
//  ManualPaymentVC.swift
//  HieCOR
//
//  Created by Deftsoft on 15/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class ManualPaymentVC: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet var totalAmountTextField: UITextField!
    @IBOutlet var backView: UIView!
    @IBOutlet var crossButtonIPAD: UIButton!
    @IBOutlet var crossButton: UIButton!
    @IBOutlet weak var backViiewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomConstraintConstant: NSLayoutConstraint!
    
    //MARK: Variables
    var delegate: ManualPaymentDelegate?
    var dummyCardNumber = String()
    var ACCEPTABLE_CHARACTERS = "0123456789"
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //OfflineDataManager Delegate
        OfflineDataManager.shared.manualPaymentDelegate = self
        //Hide Croll Button When Offline
        crossButton.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        crossButtonIPAD.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            //Add Shadow
            self.backView.layer.shadowColor = UIColor.darkGray.cgColor
            self.backView.layer.shadowOffset = CGSize.zero
            self.backView.layer.shadowOpacity = 0.5
            self.backView.layer.shadowRadius = 3
            self.backView.layer.cornerRadius = 4
        }
        self.updateBottomConstraint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwipeAndSearchVC.shared.textChangeDelegate = nil
    }
    
    override func viewWillLayoutSubviews() {
        if UI_USER_INTERFACE_IDIOM() == .pad {  //Update view height
            backViiewBottomConstraint.constant = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? 15 : UIScreen.main.bounds.size.height * 0.3
        }
    }
    
    //MARK: Private Functions
    private func updateBottomConstraint() {
        DispatchQueue.main.async {
            self.viewBottomConstraintConstant.constant = ((UI_USER_INTERFACE_IDIOM() == .phone) && ((DataManager.cartProductsArray?.count ?? 0) > 0)) ? 80:0.0
        }
    }
    
    private func addProductToCart() {
        var text = self.totalAmountTextField.text ?? ""
        text = text == "$0" ? "0" : text.replacingOccurrences(of: "$", with: "")
        
        if text == "0" {
            text = "0.00"
        }
        
        var dict = JSONDictionary()
        dict["producttitle"] = "Manual Payment"
        dict["productid"] = "0"
        dict["productqty"] = "1"
        dict["productprice"] = text
        dict["mainprice"] = text
        dict["isManualProduct"] = true
        dict["productimage"] = ""
        dict["productstock"] = "0"
        dict["productlimitqty"] = "0"
        //dict["productistaxable"] = "No"
        //dict["isTaxExempt"] = "No"
        dict["productunlimitedstock"] = "Yes"
        dict["qty_allow_decimal"] = true
        
        if DataManager.manual_product_tax_data == "" {
            dict["productistaxable"] = "Yes"
        }else {
            dict["productistaxable"] = DataManager.manual_product_tax_data
        }
        
        dict["textPrice"] = text
        
//        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
//            dict["productistaxable"] = "No"
//        }
        
        dict["row_id"] = Date().millisecondsSince1970  //For Local Use

        //        var isProductFound = false
        
        //        if !DataManager.isSplitRow {
        //            if var cartArray = DataManager.cartProductsArray {
        //                for i in 0..<cartArray.count {
        //                    let data = cartArray[i]
        //                    if let newDict = data as? JSONDictionary {
        //                        let isManualProduct = newDict["isManualProduct"] as? Bool ?? false
        //                        if isManualProduct {
        //
        //                            let mainPrice = newDict["mainprice"] as? String ?? "0.0"
        //                            let price = ((Double(mainPrice) ?? 0.0) + (Double(text) ?? 0.0))
        //                            dict["productprice"] = price.roundToTwoDecimal
        //                            dict["mainprice"] = price.roundToTwoDecimal
        //
        //                            DataManager.cartProductsArray![i] = dict
        //                            isProductFound = true
        //                            break
        //                        }
        //                    }
        //                }
        //            }
        //        }
        
        //        if !isProductFound {
        if DataManager.cartProductsArray == nil {
            DataManager.cartProductsArray = [dict]
        }else {
            DataManager.cartProductsArray!.append(dict)
        }
        //        }
    }
    
    private func checkPreviousProduct() {
        if NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            return
        }
        
        var tempProductsArray = Array<Any>()
        
        if let cartArray = DataManager.cartProductsArray {
            for i in 0..<cartArray.count {
                let data = cartArray[i]
                if let newDict = data as? JSONDictionary {
                    let isManualProduct = newDict["isManualProduct"] as? Bool ?? false
                    if isManualProduct {
                        tempProductsArray.append(newDict)
                    }
                }
            }
        }
        
        DataManager.cartProductsArray = tempProductsArray
    }
    
    //MARK: IBAction Method 
    @IBAction func numericButtonActions(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        var text = self.totalAmountTextField.text ?? ""
        if text == "$0.00" {
            text = text == "$0.00" ? "$" : text
        } else if text == "$0" {
            text = text == "$0" ? "$" : text
        }
        

        if text.count > 7 {
            return
        }

        var number = sender.titleLabel?.text ?? ""
        number = (number == "." && text == "$") ? "0." : number
        
        if (number == "." && text.contains(".")) {
            return
        }
        
        if text.replacingOccurrences(of: "$", with: "").isValidDecimal(maximumFractionDigits: 1) {
            text.append(number)
        }
        
        self.totalAmountTextField.text = text
    }
    
    @IBAction func backcspaceButtonAction(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        var text = self.totalAmountTextField.text ?? ""
        
        if text == "$0" || text.count == 1 {
            self.totalAmountTextField.text = "$0"
            return
        }
        
        text.removeLast()
        self.totalAmountTextField.text = text == "$" ? "$0" : text
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        self.checkPreviousProduct()
        self.addProductToCart()
        self.totalAmountTextField.text = "$0"
        delegate?.didTapOnAddButton?()
        
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
        self.updateBottomConstraint()
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.totalAmountTextField.text = "$0"
        delegate?.didTapOnCrossButton?()
        SwipeAndSearchVC.shared.textChangeDelegate = nil
    }
}

//MARK: OfflineDataManagerDelegate
extension ManualPaymentVC: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        self.updateBottomConstraint()
        if DataManager.isOffline {
            crossButton.isHidden = !isOn
            crossButtonIPAD.isHidden = !isOn
            
            if isOn {
                self.totalAmountTextField.text = "$0"
                delegate?.didTapOnCrossButton?()
                SwipeAndSearchVC.shared.textChangeDelegate = nil
            }
        }
    }
}

//MARK: CatAndProductsViewControllerDelegate
extension ManualPaymentVC: CatAndProductsViewControllerDelegate {
    func didTapOnManualPayment() {
        SwipeAndSearchVC.shared.textChangeDelegate = self
        //Check For External Accessory
        self.updateBottomConstraint()
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
        self.totalAmountTextField.text = "$0"
    }
}


//MARK: UITextFieldDelegate
extension ManualPaymentVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        //Handle Swipe Reader Data
        dummyCardNumber.append(string)
        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            return false
        }
        dummyCardNumber = ""
        var text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        if string == filtered {
            if textField.text == "$0" && string != "" {
                textField.text = "$"
            }
            if text == "" {
                textField.text = "$"
                return false
            }
            text = text.replacingOccurrences(of: "$", with: "")
            return text.count < 8
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.checkPreviousProduct()
        self.addProductToCart()
        self.totalAmountTextField.text = "$0"
        delegate?.didTapOnAddButton?()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dummyCardNumber = ""
        
        if !Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
        }
    }
    
}

//MARK: SwipeAndSearchTextDidChangeDelegate
extension ManualPaymentVC: SwipeAndSearchTextDidChangeDelegate {
    func textDidchange(text: String) {
        if text == "" {
            self.totalAmountTextField.text = "$0"
        }else {
            self.totalAmountTextField.text = "$" + text
        }
    }
    
    func textDidBeginEditing() {
        print("Begin")
    }
    
    func textDidEndEditing() {
        self.checkPreviousProduct()
        self.addProductToCart()
        self.totalAmountTextField.text = "$0"
        delegate?.didTapOnAddButton?()
        
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
    
}


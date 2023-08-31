//
//  PayInOutViewController.swift
//  HieCOR
//
//  Created by Rajshekar Pothu on 27/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PayInOutViewController: BaseViewController ,UITextFieldDelegate {
    
    //MARK: Variables
    private var array_currentDrawer = [DrawerHistoryModel]()
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var tvBottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tvDescription1: UITextView!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfNumbers: UITextField!
    @IBOutlet weak var viewBottomEdit: UIView!
    @IBOutlet weak var viewSideEdit: UIView!
    @IBOutlet weak var viewHeader: UIView!
    //MARK: Delegate
    var currentDrawerVC : CurrentDrawerViewController?
    var strExpectedInDrawer = String()
    var textViewPlaceholder = String()
    var strtvDescription = String()
    
    var isLandscape = true
    
    @IBOutlet weak var tfDescription: UITextField!
    
    var PayInOutDelegate : PayInPayOutDelegate?
    var refreshCurrentVCDataDelegateObj : refreshCurrentVCDataDelegate?
    var refreshCurrentVCDataForIphoneDelegateObj : refreshCurrentVCDataForIphoneDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("strExpectedInDrawer",strExpectedInDrawer)
        isLandscape = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        //tfAmount.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0), font: tfAmount.font!)
        //fillData()
        showOrientationDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLandscape = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        if UI_USER_INTERFACE_IDIOM() == .phone{
            self.tvBottomHeightConstraint.constant = 60
        }else{
            if isLandscape {
                self.tvBottomHeightConstraint.constant = 120
            }
        }
        DispatchQueue.main.async(){
            self.updateUI()
        }
        //showOrientationDesign()
        tvDescription.text = textViewPlaceholder
        tvDescription.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
        self.textViewPlaceholder = "Add Description"
        
        if tvDescription.text == "" {
            tvDescription.text = textViewPlaceholder
            tvDescription.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
        }
        
        tvDescription1.text = textViewPlaceholder
        tvDescription1.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
        self.textViewPlaceholder = "Add Description"
        
        if tvDescription1.text == "" {
            tvDescription1.text = textViewPlaceholder
            tvDescription1.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
        }
        
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.endEditing(true)
        self.isLandscape = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
        
        
        if isLandscape {
            print("Landscape")
            self.tvDescription.delegate = self
            self.tvDescription1.delegate = self
            self.tvDescription1.text = self.tvDescription.text
            self.viewBottomEdit.isHidden = true
            self.viewSideEdit.isHidden = false
            if tvDescription.text == textViewPlaceholder || tvDescription1.text == textViewPlaceholder  {
                tvDescription1.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
                tvDescription.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
            }else{
                tvDescription1.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
                tvDescription.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
            }
            
        }else{
            print("portrait")
            self.tvDescription.delegate = self
            self.tvDescription1.delegate = self
            self.tvDescription.text = self.tvDescription1.text
            self.viewSideEdit.isHidden = true
            self.viewBottomEdit.isHidden = false
            if tvDescription.text == textViewPlaceholder || tvDescription1.text == textViewPlaceholder  {
                tvDescription1.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
                tvDescription.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
            }else{
                tvDescription1.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
                tvDescription.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
            }
        }
    }
    
    func updateUI(){
        if isLandscape {
            print("Landscape")
            self.tvDescription.delegate = self
            self.tvDescription1.delegate = self
            self.viewBottomEdit.isHidden = true
            self.viewSideEdit.isHidden = false
            
            
        }else{
            print("portrait")
            self.tvDescription.delegate = self
            self.tvDescription1.delegate = self
            self.viewSideEdit.isHidden = true
            self.viewBottomEdit.isHidden = false
        }
    }
    
    func showOrientationDesign() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            self.viewBottomEdit.isHidden = true
            self.viewSideEdit.isHidden = false
            
        }else{
            print("portrait")
            self.viewSideEdit.isHidden = true
            self.viewBottomEdit.isHidden = false
        }
    }
    
    func fillData()  {
        let origImage = UIImage(named: "cancel")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        buttonCancel.setImage(tintedImage, for: .normal)
        buttonCancel.tintColor = UIColor(red: 11/255, green: 118/255, blue: 201/255, alpha: 1)
        
        tfNumbers.setRightPadding()
        // tfDescription.setRightPadding()
    }
    
    func getExpectedStrValue(expectedStr: String) {
        print("getValue : \(expectedStr)")
        strExpectedInDrawer = expectedStr
        tvDescription1.resignFirstResponder()
        tvDescription.resignFirstResponder()
        tvDescription1.text = ""
        tvDescription.text = ""
        tfNumbers.text = ""
        tvDescription.text = textViewPlaceholder
        tvDescription.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
        self.textViewPlaceholder = "Add Description"
        
        if tvDescription.text == "" {
            tvDescription.text = textViewPlaceholder
            tvDescription.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
        }
        
        tvDescription1.text = textViewPlaceholder
        tvDescription1.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
        self.textViewPlaceholder = "Add Description"
        
        if tvDescription1.text == "" {
            tvDescription1.text = textViewPlaceholder
            tvDescription1.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
        }
        
    }
    
    func getIphoneExpectedStrValue(expectedStr: String) {
        print("getValue : \(expectedStr)")
        strExpectedInDrawer = expectedStr
    }
    // MARK: - Action:-
    
    //    @IBAction func buttonBackAction(_ sender: Any) {
    //
    //        if UI_USER_INTERFACE_IDIOM() == .pad
    //        {
    //            //self.navigationController?.popViewController(animated: true)
    //            PayInOutDelegate?.hidePayInPayOutView!()
    //        }else{
    //            self.navigationController?.popViewController(animated: true)
    //        }
    //    }
    
    @IBAction func actionPayIn(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        let inputStr:String = tfNumbers.text ?? ""
        if  inputStr == "" || tfNumbers.isEmpty {//}|| (inputStr as NSString).integerValue <= 0 {
//            self.showAlert(message: "Please enter Amount.")
            appDelegate.showToast(message: "Please Enter Amount")
            return
        }else{
            tvDescription1.resignFirstResponder()
            tvDescription.resignFirstResponder()
            loadPayIn()
        }
        
    }
    
    @IBAction func actionPayOut(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        let inputStr:String = tfNumbers.text ?? ""
        let ob = (inputStr as NSString).replacingOccurrences(of: "$", with: "")
        let obEx = (strExpectedInDrawer as NSString).replacingOccurrences(of: "$", with: "")
        let obexpected = (obEx as NSString).replacingOccurrences(of: ",", with: "")
        if  ob == "" || tfNumbers.isEmpty {//}|| (inputStr as NSString).integerValue <= 0 {
//            self.showAlert(message: "Please enter Amount.")
            appDelegate.showToast(message: "Please  Enter Amount")
            return
        }else{
            if (ob as NSString).doubleValue <= (obexpected as NSString).doubleValue{
                tvDescription1.resignFirstResponder()
                tvDescription.resignFirstResponder()
                loadPayOut()
            }else{
//                self.showAlert(message: "Pay Out amount must be less or equal to Expected in Drawer amount:" + strExpectedInDrawer)
                appDelegate.showToast(message: "Pay Out amount must be less or equal to Expected in Drawer amount:" + strExpectedInDrawer)
            }
            
        }
        
    }
    @IBAction func actionRemove(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        if let text = tfNumbers.text , text.count > 0 {
            let start = text.index(text.startIndex, offsetBy: 0)
            let end = text.index(text.endIndex, offsetBy: -1)
            let result = text[start..<end]
            tfNumbers.text = String(result)
        }
    }
    
    @IBAction func actionPoint(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        if let text = tfNumbers.text {
            if !text.contains("."){
                tfNumbers.text = text.count == 0 ? "0\(text)." : "\(text)."
            }
        }else{
            tfNumbers.text = "0."
        }
    }
    
    
    @IBAction func actionNumbers(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        let tag = sender.tag
        if let text = tfNumbers.text {
            if text.contains(".") {
                let indexOfDot = text.distance(from: text.startIndex, to: text.index(of: ".")!)
                let totalIndexes = text.count - 1
                if (totalIndexes - indexOfDot) < 2 {
                    tfNumbers.text = "\(text)\(tag)"
                }
            } else {
                tfNumbers.text = "\(text)\(tag)"
            }
        } else {
            tfNumbers.text = "\(tag)"
        }
    }
    
    func loadPayIn() {
        //Device Name
        var str_DeviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        let tfAmountob = tfNumbers.text?.replacingOccurrences(of: "$", with: "")
        strtvDescription = self.tvDescription1.text
        strtvDescription = self.tvDescription.text
        //Parameters
        let parameters: JSONDictionary = [
            "userID":DataManager.userID,
            "amount": tfAmountob ?? 0.0,
            "type":"in",
            "description": strtvDescription ,
            "source":str_DeviceName
        ]
        //callAPItoStartPayIn
        self.callAPItoStartPayIn(parameters: parameters)
    }
    
    
    
    func loadPayOut() {
        //Device Name
        var str_DeviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        let tfAmountob = tfNumbers.text?.replacingOccurrences(of: "$", with: "")
        strtvDescription = self.tvDescription1.text
        strtvDescription = self.tvDescription.text
        //Parameters
        let parameters: JSONDictionary = [
            "userID":DataManager.userID,
            "amount": tfAmountob ?? 0.0,
            "type":"out",
            "description": strtvDescription,
            "source":str_DeviceName
        ]
        //callAPItoStartPayOut
        self.callAPItoStartPayOut(parameters: parameters)
    }
    
    
    // MARK: - API Methods
    
    func callAPItoStartPayIn(parameters: JSONDictionary) {
        
        HomeVM.shared.startPayIn(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.tfNumbers.text = ""
                self.tvDescription.text = ""
                self.tvDescription1.text = ""
                self.array_currentDrawer = HomeVM.shared.payInDataDetail
                if UI_USER_INTERFACE_IDIOM() == .pad
                {
                    if self.array_currentDrawer.count>0
                    {
                        for i in (0...self.array_currentDrawer.count-1)
                        {
                            //  self.currentDrawerVC?.updateCurrentDrawerPaidInData(with: [self.array_currentDrawer[i]])
                            self.refreshCurrentVCDataDelegateObj?.refreshCurrentViewContollPayInData(data: [self.array_currentDrawer[i]])
                        }
                    }
                    self.PayInOutDelegate?.hidePayInPayOutView!()
                    // self.navigationController?.popViewController(animated: true)
                }else{
                    if self.array_currentDrawer.count>0
                    {
                        for i in (0...self.array_currentDrawer.count-1)
                        {
                            // self.currentDrawerVC?.updateCurrentDrawerPaidInData(with: [self.array_currentDrawer[i]])
                            self.refreshCurrentVCDataForIphoneDelegateObj?.refreshCurrentViewContollPayInDataForIphone(data: [self.array_currentDrawer[i]])
                        }
                    }
                    self.PayInOutDelegate?.hideIphonePayInOut!()
                    // self.navigationController?.popViewController(animated: true)
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
    
    func callAPItoStartPayOut(parameters: JSONDictionary) {
        
        HomeVM.shared.startPayOut(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.tfNumbers.text = ""
                self.tvDescription.text = ""
                self.tvDescription1.text = ""
                self.array_currentDrawer = HomeVM.shared.payOutDataDetail
                if UI_USER_INTERFACE_IDIOM() == .pad
                {
                    if self.array_currentDrawer.count>0
                    {
                        for i in (0...self.array_currentDrawer.count-1)
                        {
                            // self.currentDrawerVC?.updateCurrentDrawerPaidOutData(with: [self.array_currentDrawer[i]])
                            self.refreshCurrentVCDataDelegateObj?.refreshCurrentViewContollPayOutData(data: [self.array_currentDrawer[i]])
                        }
                    }
                    self.PayInOutDelegate?.hidePayInPayOutView!()
                    //self.navigationController?.popViewController(animated: true)
                }else{
                    if self.array_currentDrawer.count>0
                    {
                        for i in (0...self.array_currentDrawer.count-1)
                        {
                            // self.currentDrawerVC?.updateCurrentDrawerPaidOutData(with: [self.array_currentDrawer[i]])
                            // self.refreshCurrentVCDataDelegateObj?.refreshCurrentViewContollPayOutData(data: [self.array_currentDrawer[i]])
                            self.refreshCurrentVCDataForIphoneDelegateObj?.refreshCurrentViewContollPayOutDataForIphone(data: [self.array_currentDrawer[i]])
                        }
                    }
                    self.PayInOutDelegate?.hideIphonePayInOut!()
                    //self.navigationController?.popViewController(animated: true)
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
    
    
    
    /*
     //MARK: Textfield Delegate Methods
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     if tvDescription1.text == "" {
     tvDescription1.text = textViewPlaceholder
     tvDescription1.textColor = UIColor.darkGray
     }
     if tvDescription.text == "" {
     tvDescription.text = textViewPlaceholder
     tvDescription.textColor = UIColor.darkGray
     }
     return true
     }
     func textFieldShouldClear(_ textField: UITextField) -> Bool {
     return true
     }
     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
     return true
     }
     //
     //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     //        // changes by hiecor team
     ////        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
     ////            return true
     ////        }
     ////
     ////        let newText = oldText.replacingCharacters(in: r, with: string)
     ////        let isNumeric = newText.isEmpty || (Double(newText) != nil)
     ////        let numberOfDots = newText.components(separatedBy: ".").count - 1
     ////
     ////        let numberOfDecimalDigits: Int
     ////        if let dotIndex = newText.index(of: ".") {
     ////            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
     ////        } else {
     ////            numberOfDecimalDigits = 0
     ////        }
     ////
     ////        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
     //
     //        if textField == tfDescription {
     //            if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
     //                return false
     //            }
     //            if range.location == 0 && string == " " {
     //                return false
     //            }
     //        } else if textField == tfAmount {
     //            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
     //            var replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
     //
     //            if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
     //                return false
     //            }
     //
     //            if range.location == 0 && string == " " {
     //                return false
     //            }
     //
     //            if string == "\t" {
     //                return false
     //            }
     //
     //            print(string)
     //            print(textField.text)
     //
     //            if string == " " {
     //                return false
     //            }
     //
     //            replacementText = replacementText.replacingOccurrences(of: "$", with: "")
     //            return replacementText.isValidDecimal(maximumFractionDigits: 2)
     //        }
     //        return true
     //    }
     
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     // changes by hiecor team
     //        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
     //            return true
     //        }
     //
     //        let newText = oldText.replacingCharacters(in: r, with: string)
     //        let isNumeric = newText.isEmpty || (Double(newText) != nil)
     //        let numberOfDots = newText.components(separatedBy: ".").count - 1
     //
     //        let numberOfDecimalDigits: Int
     //        if let dotIndex = newText.index(of: ".") {
     //            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
     //        } else {
     //            numberOfDecimalDigits = 0
     //        }
     //
     //        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
     
     if textField == tfDescription {
     if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
     return false
     }
     if range.location == 0 && string == " " {
     return false
     }
     } else if textField == tfNumbers {
     //            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
     //            var replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
     //
     //            if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
     //                return false
     //            }
     //
     //            if range.location == 0 && string == " " {
     //                return false
     //            }
     //
     //            if string == "\t" {
     //                return false
     //            }
     //
     //            print(string)
     //            print(textField.text)
     //
     //            if string == " " {
     //                return false
     //            }
     
     guard let oldText = textField.text, let r = Range(range, in: oldText) else {
     return true
     }
     
     var newText = oldText.replacingCharacters(in: r, with: string)
     newText = newText.replacingOccurrences(of: "$", with: "")
     let isNumeric = newText.isEmpty || (Double(newText) != nil)
     let numberOfDots = newText.components(separatedBy: ".").count - 1
     
     let numberOfDecimalDigits: Int
     if let dotIndex = newText.index(of: ".") {
     numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
     } else {
     numberOfDecimalDigits = 0
     }
     
     
     if isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 {
     tfNumbers.text = ""
     tfNumbers.text = "$" + newText
     
     return false
     }
     
     // replacementText = replacementText.replacingOccurrences(of: "$", with: "")
     //return replacementText.isValidDecimal(maximumFractionDigits: 2)
     return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
     }
     return true
     }
     
     func getWidth(text: String) -> CGFloat
     {
     let txtField = UITextField(frame: .zero)
     txtField.text = text
     txtField.sizeToFit()
     return txtField.frame.size.width
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     if textField == tfNumbers {
     textField.resignFirstResponder()
     tfDescription.becomeFirstResponder()
     }else if textField == tfDescription {
     textField.resignFirstResponder()
     
     }
     return true
     }
     */
}

extension PayInOutViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.resetCustomError(isAddAgain: false)
        if textView.text == textViewPlaceholder || textView.text == "" {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        if range.location == 0 && text == " " {
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
        if textView.text == textViewPlaceholder || textView.text == "" || (textView.text)!.trimmingCharacters(in: .whitespaces).isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        }
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
            IQKeyboardManager.shared.enable = false
        }
    }
}

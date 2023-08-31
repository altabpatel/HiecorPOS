//
//  CreditCardContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import IQKeyboardManagerSwift

class CreditCardContainerViewController: BaseViewController, ClassBVCDelegate {
    
    //MARK: IBOutlet
    @IBOutlet weak var tf_CVV: UITextField!
    @IBOutlet weak var tf_YYYY: UITextField!
    @IBOutlet weak var tf_MM: UITextField!
    @IBOutlet weak var tf_CreditCard: UITextField!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet var noTripBtn: UIButton!
    @IBOutlet var fifteenBtn: UIButton!
    @IBOutlet var twentyBtn: UIButton!
    @IBOutlet var twentyFiveBtn: UIButton!
    @IBOutlet var numberField: UITextField!
    @IBOutlet weak var tipView: UIStackView!
    @IBOutlet weak var viewSavedCredit: UIView!
    @IBOutlet weak var viewCreditCardHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var labelCredit: UILabel!
    @IBOutlet weak var btnSavedCard: UIButton!
    @IBOutlet weak var tf_Amount: UITextField!
    @IBOutlet weak var constTopCard: NSLayoutConstraint!
    @IBOutlet weak var viewAmount: UIView!
    
    //MARK: Variables
    var totalAmount = Double()
    var paymentType = String()
    var total = Double()
    var tipAmount = Double()
    var MM_Array = [String]()
    var isMM = Bool()
    var YY_Array = [String]()
    var selectedYear = String()
    var dummyCardNumber = String()
    var isCreditCardNumberDetected = false
    var delegate: PaymentTypeContainerViewControllerDelegate?
    private var myPickerView: UIPickerView!
    private var ACCEPTABLE_CHARACTERS = "0123456789"
    private var tipType: Double = 0.0
    var creditCardDataShow : creditInfoDelegate?
    
    var cardSavedbpid = String()
    var CustomerObj = CustomerListModel()
    
    var strMonth = ""
    var strYear = ""
    var isScanCreditCard = false
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tf_Amount.setDollar()
        
        if DataManager.isSplitPayment {
            print("enterrrrrrrrrrrrrrrrr")
            viewAmount.isHidden = false
        } else {
            viewAmount.isHidden = true
            constTopCard.constant = 20
            print("outerrrrrrrrrrrrrrrrr")
        }
        
        SwipeAndSearchVC.delegate = nil
        self.customiseUI()
        self.upadateMonthArray()
        self.fillCardDetail()
        //Temp.
        self.authButton.isHidden = true
       // callValidateToChangeColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        customiseUI()
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.fillCardDetail()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tf_CreditCard.updateCustomBorder()
        tf_MM.updateCustomBorder()
        tf_YYYY.updateCustomBorder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        numberField.setBorder(color: UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0))
        callValidateToChangeColor()
    }
    
    //MARK: Private Functions
    private func upadateMonthArray() {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        YY_Array.removeAll()
        MM_Array.removeAll()
        
        if selectedYear == "\(year)" {
            for i in (month..<13) {
                MM_Array.append(String(format: "%02d", i))
            }
        }else {
            MM_Array = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        }
        
        for i in (year..<2050) {
            YY_Array.append("\(i)")
        }
    }
    
    private func customiseUI() {
        if DataManager.CardCount > 1{
            self.viewCreditCardHeightConstriant.constant = 40
            self.viewSavedCredit.isHidden  = false
            self.viewSavedCredit.layoutIfNeeded()
            btnSavedCard.isHidden = false
        }else{
            self.viewCreditCardHeightConstriant.constant = 0
            self.viewSavedCredit.isHidden  = true
            self.viewSavedCredit.layoutIfNeeded()
            btnSavedCard.isHidden = true
        }
        numberField.text = ""
        //tipType = 0.0
        tf_CreditCard.tintColor = UIColor.blue
        tf_CreditCard.keyboardType = .numberPad
        tf_CVV.keyboardType = .asciiCapableNumberPad
        tf_MM.setDropDown()
        tf_YYYY.setDropDown()
        numberField.setDollar(font: numberField.font!)
        noTripBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        noTripBtn.setTitleColor(.white, for: .normal)
        //tipView.isHidden = !DataManager.collectTips
        tipView.isHidden = true
        
        //
        fifteenBtn.backgroundColor = UIColor.white
        fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyBtn.backgroundColor = UIColor.white
        twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyFiveBtn.backgroundColor = UIColor.white
        twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        noTripBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        noTripBtn.setTitleColor(.white, for: .normal)
        
        updateTipUI(type: tipType)
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            btnSavedCard.isHidden = true
        }
    }
    
    private func fillCardDetail() {
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        if HomeVM.shared.DueShared > 0 {
            tf_Amount.text = "\(HomeVM.shared.DueShared.currencyFormatA)"
        } else {
            tf_Amount.text = "\(totalAmount.currencyFormatA)"
        }
        
        
        if isCreditCardNumberDetected {
            tf_CreditCard.text = SwipeAndSearchVC.shared.cardData.number
            tf_MM.text = SwipeAndSearchVC.shared.cardData.month
            tf_YYYY.text = SwipeAndSearchVC.shared.cardData.year
            return
        }
        
        if let dict = UserDefaults.standard.value(forKey: "SelectedCustomer") as? NSDictionary {
            if isScanCreditCard {
                print("isscancredit")
            }else{
                let cardDetail = decode(dict: dict as! [String : Any])
                var number = cardDetail.cardNumber ?? ""
                if number.count == 4 {
                    number = "************" + number
                }
                if DataManager.errorOccure {
                    DataManager.last4DigitCard = tf_CreditCard.text
                    tf_CreditCard.text = tf_CreditCard.text
                    tf_MM.text = tf_MM.text
                    tf_YYYY.text = tf_YYYY.text
                    //DataManager.Bbpid = cardDetail.bpId
                    DataManager.errorOccure = false
                } else {
                    DataManager.last4DigitCard = cardDetail.cardNumber
                    tf_CreditCard.text = number
                    tf_MM.text = cardDetail.month
                    tf_YYYY.text = cardDetail.year
                    //DataManager.Bbpid = cardDetail.bpId
                    if DataManager.CardCount > 1 {
                        DataManager.Bbpid = cardDetail.bpId
                    }
                }

                callValidateToChangeColor()
            }
            return
        }
        
        //Update Previous Data If Available
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key.lowercased() == "credit" {
            if let data = PaymentsViewController.paymentDetailDict["data"] as? JSONDictionary {
                if DataManager.errorOccure {
                    tf_CreditCard.text = tf_CreditCard.text
                    tf_MM.text = tf_MM.text
                    tf_YYYY.text = tf_YYYY.text
                    tf_CVV.text = tf_CVV.text
                    //tipType = tipType
                    //tipAmount = data["tip"] as? Double ?? 0
                    DataManager.errorOccure = false
                } else {
                    tf_CreditCard.text = data["cardnumber"] as? String ?? ""
                    tf_MM.text = data["mm"] as? String ?? ""
                    tf_YYYY.text = data["yyyy"] as? String ?? ""
                    tf_CVV.text = data["cvv"] as? String ?? ""
                    tipType = data["tipType"] as? Double ?? 0
                    tipAmount = data["tip"] as? Double ?? 0
                }
                
                numberField.text = tipAmount.roundToTwoDecimal
                self.updateTipUI(type: self.tipType)
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                //
                //                }
            }
        }
    }
    
    private func validateData() -> Bool {
        if tf_CreditCard.text == "" {
            updateError(textfieldIndex: 1, message: "Please enter Credit Card Number.")
            return false
        }
        // Mark change for validate green button only validate for 16 digit count of credit textfield
        /*if tf_CreditCard.text!.count < 12 {
         updateError(textfieldIndex: 1, message: "Please enter valid Credit Card Number.")
         return false
         }*/
        
        if tf_CreditCard.text!.count < 15 {
            updateError(textfieldIndex: 1, message: "Please enter valid Credit Card Number.")
            return false
        }
        
        if tf_YYYY.text == "" {
            updateError(textfieldIndex: 2, message: "Please select Year.")
            return false
        }
        
        if tf_MM.text == "" {
            updateError(textfieldIndex: 3, message: "Please select Month.")
            return false
        }
        
        if tf_Amount.text == "" {
            updateError(textfieldIndex: 4, message: "Please enter amount.")
            return false
        }
        
        return true
    }
    
    private func updateTipUI(type: Double) {
        switch type {
        case 0:
            numberField.resignFirstResponder()
            fifteenBtn.backgroundColor = UIColor.white
            fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyBtn.backgroundColor = UIColor.white
            twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.white
            twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            noTripBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            noTripBtn.setTitleColor(.white, for: .normal)
            
            tipAmount = 0
            tipType = 0.0
            numberField.text = ""
            self.delegate?.updateTotal?(with: tipAmount)
            break
        case 15:
            numberField.resignFirstResponder()
            fifteenBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            fifteenBtn.setTitleColor(.white, for: .normal)
            twentyBtn.backgroundColor = UIColor.white
            twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.white
            twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            noTripBtn.backgroundColor = UIColor.white
            noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            
            tipAmount = (total/100)*15
            tipType = 15
            numberField.text = ""
            numberField.text = tipAmount.roundToTwoDecimal
            self.delegate?.updateTotal?(with: tipAmount)
            break
        case 20:
            numberField.resignFirstResponder()
            fifteenBtn.backgroundColor = UIColor.white
            fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            twentyBtn.setTitleColor(.white, for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.white
            twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            noTripBtn.backgroundColor = UIColor.white
            noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            
            tipAmount = (total/100)*20
            tipType = 20
            numberField.text = ""
            numberField.text = tipAmount.roundToTwoDecimal
            self.delegate?.updateTotal?(with: tipAmount)
            break
        case 25:
            numberField.resignFirstResponder()
            fifteenBtn.backgroundColor = UIColor.white
            fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyBtn.backgroundColor = UIColor.white
            twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            twentyFiveBtn.setTitleColor(.white, for: .normal)
            noTripBtn.backgroundColor = UIColor.white
            noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            
            tipAmount = (total/100)*25
            tipType = 25
            numberField.text = ""
            numberField.text = tipAmount.roundToTwoDecimal
            self.delegate?.updateTotal?(with: tipAmount)
            break
        case -1:    //Manual
            fifteenBtn.backgroundColor = UIColor.white
            fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyBtn.backgroundColor = UIColor.white
            twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.white
            twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            noTripBtn.backgroundColor = UIColor.white
            noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            
            tipAmount = Double(numberField.text ?? "0") ?? 0.00
            tipType = -1
            if tipAmount > 0 {
                numberField.text = tipAmount.roundToTwoDecimal
            } else {
                numberField.text = ""
            }
            
            self.delegate?.updateTotal?(with: tipAmount)
            break
        default: break
        }
    }
    
    //MARK: IBActions Method
    @IBAction func btn_AuthAction(_ sender: Any) {
        self.view.endEditing(true)
        if !validateData() {
            return
        }
        
        let Obj = ["cardnumber":tf_CreditCard.text!, "mm":tf_MM.text!, "yyyy":tf_YYYY.text!, "cvv":tf_CVV.text!, "auth":"AUTH"]
        delegate?.getPaymentData?(with: Obj)
    }
    
    @IBAction func btn_SacnCreditCardAction(_ sender: Any) {
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        SwipeAndSearchVC.shared.cardIOSelected = true
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.hideCardIOLogo = true
        cardIOVC?.collectCVV = false
        cardIOVC?.collectExpiry = true
        isScanCreditCard = true
        cardIOVC?.modalPresentationStyle = .currentContext
        present(cardIOVC!, animated: true, completion: nil)
    }
    
    @IBAction func noTripTapped(_ sender: UIButton)
    {
        updateTipUI(type: 0)
    }
    
    @IBAction func fifteenTapped(_ sender: UIButton)
    {
        updateTipUI(type: 15)
    }
    
    @IBAction func twentyTapped(_ sender: UIButton)
    {
        updateTipUI(type: 20)
    }
    
    @IBAction func twentyFiveTapped(_ sender: UIButton)
    {
        updateTipUI(type: 25)
    }
    
    //TextField IBActions
    @IBAction func tf_CreditCardAction(_ sender: Any) {
        //...
    }
    
    @IBAction func tf_MMAction(_ sender: Any) {
        upadateMonthArray()
        self.pickerDelegate = self
        self.setPickerView(textField: tf_MM, array: MM_Array)
    }
    
    @IBAction func tf_YYYYAction(_ sender: Any) {
        self.pickerDelegate = self
        self.setPickerView(textField: tf_YYYY, array: YY_Array)
    }
    
    @IBAction func actionSavedCard(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        HomeVM.shared.customerUserId  = DataManager.customerId
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if DataManager.CardCount > 0 {
                self.creditCardDataShow?.didDataShowCreditcard?(paymentMethod: "credit")
                self.delegate?.showCreditCard!()
            }else{
            }
        }else{
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "SavedCardViewController") as! SavedCardViewController
            secondVC.delegateOne = self
            present(secondVC, animated: true, completion: nil)
        }
    }
    
    func savedCardInfoInphone(cartSavedArray:Array<AnyObject>) {
        print("cartDataArray",cartSavedArray)
        let object = cartSavedArray[0] as! SavedCardList
        
        let last_4 = object.last_4
        let cardexpyr = object.cardexpyr
        let cardexpmo = object.cardexpmo
        cardSavedbpid = object.bpid
        DataManager.Bbpid = object.bpid
        print("bpid",cardSavedbpid as Any)
        print("last_4",last_4 as Any)
        print("cardexpyr",cardexpyr as Any)
        print("cardexpmo",cardexpmo as Any)
        
        tf_CreditCard.text = last_4
        tf_MM.text = cardexpmo
        tf_YYYY.text = cardexpyr
    }
}

//MARK: CardIOPaymentViewControllerDelegate
extension CreditCardContainerViewController: CardIOPaymentViewControllerDelegate {
    
    func validateCreditCardFormat(text:String)->  Bool {
        return true
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        SwipeAndSearchVC.shared.cardIOSelected = false
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        paymentViewController?.dismiss(animated: true, completion: nil)
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            tf_CreditCard.text = info.cardNumber
            tf_MM.text = "\(String(format: "%02d", info.expiryMonth))"
            tf_YYYY.text = "\(info.expiryYear)"
            tf_CVV.text = info.cvv
            tf_CreditCard.resetCustomError(isAddAgain: false)
            print("card holder name",info.cardholderName)
        }
        SwipeAndSearchVC.shared.cardIOSelected = false
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        paymentViewController?.dismiss(animated: true, completion: nil)
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
}

//MARK:- PickerView Delegate Methods
extension CreditCardContainerViewController: HieCORPickerDelegate {
    
    func didSelectPickerViewAtIndex(index: Int) {
        if pickerTextfield == tf_MM {
            //tf_MM?.text = "\(MM_Array[index])"
            strMonth = "\(MM_Array[index])"
        }
        else {
            strYear = "\(YY_Array[index])"
            //tf_YYYY?.text = "\(YY_Array[index])"
            selectedYear = "\(YY_Array[index])"
        }
    }
    
    override func pickerViewDoneAction() {
        
        if pickerTextfield == tf_MM {
            tf_MM?.text = strMonth
        }
        else {
            
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            
            
            if strYear == "\(year)" {
                
                let month = calendar.component(.month, from: date)
                if strMonth != "" {
                    if month > Int(strMonth)! {
                        tf_MM.text = ""
                    }
                } else {
                    tf_MM.text = ""
                }
            }
            
            tf_YYYY?.text = strYear
            selectedYear = strYear
        }
        
        callValidateToChangeColor()
        pickerTextfield.resignFirstResponder()
    }
    
    override func pickerViewCancelAction() {
        //pickerTextfield.text = ""
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        
        
        if strYear == "\(year)" {
            
            let month = calendar.component(.month, from: date)
            
            if strMonth != "" {
                if month > Int(strMonth)! {
                    tf_MM.text = ""
                }
            }
        }
        
        pickerTextfield?.resignFirstResponder()
    }
    
    func callValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad{
            if tf_CreditCard.text != "" && tf_CreditCard.text!.count > 14 && tf_YYYY.text != "" && tf_MM.text != "" && tf_Amount.text != ""{
                delegate?.checkPayButtonColorChange?(isCheck: true, text: "CREDIT")
            }else{
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "CREDIT")
            }
        }else{
            if tf_CreditCard.text != "" && tf_CreditCard.text!.count > 14 && tf_YYYY.text != "" && tf_MM.text != "" && tf_Amount.text != ""{
                delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "CREDIT")
            }else{
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CREDIT")
            }
        }
    }
    
    func disableValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad{
            if tf_CreditCard.text == "" || tf_YYYY.text == "" || tf_MM.text == ""{
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "CREDIT")
            }
        }else{
            if tf_CreditCard.text == "" || tf_YYYY.text == "" || tf_MM.text == ""{
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CREDIT")
            }
        }
    }
    
}

//MARK:- Textfield Delegate Methods
extension CreditCardContainerViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.hideAssistantBar()
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        
        if textField == tf_Amount {
            tf_Amount.selectAll(nil)
        }
        
        if textField == numberField {
            numberField.selectAll(nil)
        }
        
        self.dummyCardNumber = ""
        textField.resetCustomError(isAddAgain: false)
        if textField == tf_MM {
            if MM_Array.count > 0 {
                tf_MM?.text = "\(MM_Array[0])"
                strMonth = "\(MM_Array[0])"
            }
        }
        
        if textField == tf_YYYY {
            //tf_MM.text = ""
            if YY_Array.count > 0 {
                tf_YYYY?.text = "\(YY_Array[0])"
                strYear = "\(YY_Array[0])"
                selectedYear = "\(YY_Array[0])"
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Handle Swipe Reader Data
        if textField == tf_CreditCard  {
            let isSingleBeepSwiper = String(describing: dummyCardNumber.prefix(1)) == ";"
            
            if (String(describing: dummyCardNumber.prefix(2)) != "%B" && !isSingleBeepSwiper) || (String(describing: dummyCardNumber.prefix(1)) != ";" && isSingleBeepSwiper) {
                self.tf_CreditCard.tintColor = UIColor.blue
                self.dummyCardNumber = ""
                textField.resignFirstResponder()
                return true
            }
            
            let cardNumberArray = dummyCardNumber.split(separator: isSingleBeepSwiper ? "=" : "^")
            if isSingleBeepSwiper ? cardNumberArray.count > 1 : cardNumberArray.count > 2 {
                let number = String(describing: String(describing: cardNumberArray.first ?? "").dropFirst(isSingleBeepSwiper ? 1 : 2))
                let month = String(describing: String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(4)).dropFirst(2))
                let year = String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(2))
                
                tf_CreditCard.resetCustomError(isAddAgain: false)
                tf_CreditCard.text = number
                tf_MM.text = month
                tf_YYYY.text = "20" + year
            }else {
                if tf_CreditCard.isEmpty {
                    tf_CreditCard.setCustomError()
                }
            }
        }
        self.tf_CreditCard.tintColor = UIColor.blue
        self.dummyCardNumber = ""
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        //Handle Swipe Reader Data
        dummyCardNumber.append(string)
        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            textField.tintColor = UIColor.clear
            return false
        }
        dummyCardNumber = ""
        
        if textField == tf_Amount {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let amount = Double(replacementText) ?? 0.0
            HomeVM.shared.errorTip = 0.0
            if HomeVM.shared.DueShared > 0 {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= HomeVM.shared.DueShared
            } else {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= totalAmount
            }
            
            //return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
            //return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= totalAmount
        }
        
        if textField == numberField {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
        
        callValidateToChangeColor()
        
        if textField == self.tf_CreditCard || textField == tf_CVV {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string == filtered {
                if textField == tf_CVV {
                    return charactersCount < 5
                }
                if textField == tf_CreditCard {
                    return charactersCount < 17
                }
                //                if textField == tf_CreditCard {
                //
                //                    let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                //                    textField.text = newString
                //                    return false
                //
                //                    //return charactersCount < 17
                //                }
            }else {
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == numberField {
            updateTipUI(type: -1)
        }
        callValidateToChangeColor()
        if DataManager.isSplitPayment {
            if textField == tf_Amount {
                appDelegate.amount = tf_Amount.text?.toDouble() ?? 0.0 /// check this code for sourabh sir issue
                delegate?.balanceDueRemaining?(with: tf_Amount.text?.toDouble() ?? 0.0)
            }
        }
        
        
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        disableValidateToChangeColor()
        if textField == tf_Amount {
            delegate?.balanceDueRemaining?(with: tf_Amount.text?.toDouble() ?? 0.0)
        }
        textField.resignFirstResponder()
        return false
    }
}

//MARK: PaymentTypeDelegate
extension CreditCardContainerViewController: PaymentTypeDelegate {
    func didUpdateRemainingAmt(RemainingAmt: Double){
        print("RemainingAmt",RemainingAmt)
        if HomeVM.shared.DueShared > 0 {
            if appDelegate.amount > 0 {
                tf_Amount.text = "\(appDelegate.amount.currencyFormatA)"
            }else {
                tf_Amount.text = "\(HomeVM.shared.DueShared.currencyFormatA)"
            }
        } else {
            tf_Amount.text = "\(totalAmount.currencyFormatA)"
        }
    }
    
    func didSendCreditSavedCardData(cartDataArray:Array<AnyObject>){
        print("cartDataArray",cartDataArray)
        let object = cartDataArray[0] as! SavedCardList
        
        let last_4 = object.last_4
        let cardexpyr = object.cardexpyr
        let cardexpmo = object.cardexpmo
        let last4 = object.last4
        cardSavedbpid = object.bpid
        DataManager.Bbpid = object.bpid
        print("bpid",cardSavedbpid as Any)
        print("last_4",last_4 as Any)
        print("cardexpyr",cardexpyr as Any)
        print("cardexpmo",cardexpmo as Any)
        
        tf_CreditCard.text = last_4
        tf_MM.text = cardexpmo
        tf_YYYY.text = cardexpyr
        var cardDetailValue = CardDataModel()
        cardDetailValue.cardNumber = last4
        cardDetailValue.bpId = object.bpid
        cardDetailValue.month = cardexpmo
        cardDetailValue.year = cardexpyr
        cardDetailValue.type = object.cardtype
//        dict["cardNumber"] = data?.cardNumber
//        dict["month"] = data?.month
//        dict["year"] = data?.year
//        dict["type"] = data?.type
//        dict["bpid"] = data?.bpId
        
        UserDefaults.standard.setValue(HieCOR.encode(data: cardDetailValue), forKey: "SelectedCustomer")
        UserDefaults.standard.synchronize()
        
    }
    
    func placeOrder(isIpad: Bool) {
        if DataManager.isSwipeToPay {
            SwipeAndSearchVC.delegate = nil
            tf_CreditCard.resetCustomError(isAddAgain: false)
            
            DataManager.tempSignature = DataManager.signature
            
            
            //            if DataManager.signature {
            //                DataManager.signature = false
            //            }
            
            delegate?.placeOrder?(isIpad: UI_USER_INTERFACE_IDIOM() == .pad)
        }
    }
    
    func didUpdateCustomer(data: CustomerListModel) {
        fillCardDetail()
    }
    
    func didUpdateTotal(amount: Double , subToal : Double) {
        print("subToal" ,subToal)
        // Start ..... by priya loyalty change
        //self.total = amount
        self.total = subToal
        totalAmount = amount
        tf_Amount.text = amount.currencyFormatA
        // end......by priya
        
        if tipType == -1 {
            return
        }
        tipAmount = (total/100) * tipType
        
        if tipAmount > 0 {
            numberField.text = tipAmount.roundToTwoDecimal
        } else {
            numberField.text = ""
        }
        
        //fillCardDetail()
        
        if HomeVM.shared.DueShared > 0 {
            if appDelegate.amount > 0 {
                tf_Amount.text = "\(appDelegate.amount.currencyFormatA)"
            }else {
                tf_Amount.text = "\(HomeVM.shared.DueShared.currencyFormatA)"
            }
           // tf_Amount.text = "\(HomeVM.shared.DueShared.currencyFormatA)"
        } else {
            tf_Amount.text = "\(totalAmount.currencyFormatA)"
        }
        
        self.delegate?.updateTotal?(with: tipAmount)
    }
    
    func updateError(textfieldIndex: Int, message: String) {
        switch textfieldIndex {
        case 1:
            tf_CreditCard.setCustomError(text: message, bottomSpace: 2.0)
            break
        case 2:
            tf_YYYY.setCustomError(text: message, bottomSpace: 2)
            break
        case 3:
            tf_MM.setCustomError(text: message, bottomSpace: 2)
        case 4:
            tf_Amount.setCustomError(text: message, bottomSpace: 2)
            break
        default: break
        }
    }
    
    func saveData() {
        self.view.endEditing(true)
        PaymentsViewController.paymentDetailDict["data"] = ["cardnumber":tf_CreditCard.text ?? "","mm":tf_MM.text ?? "", "yyyy":tf_YYYY.text ?? "", "cvv":tf_CVV.text ?? "","tip":tipAmount,"tipType": tipType]
    }
    
    func didGetCardDetail() {
        tf_CreditCard.resetCustomError(isAddAgain: false)
        isCreditCardNumberDetected = true
        tf_CreditCard.text = SwipeAndSearchVC.shared.cardData.number
        tf_MM.text = SwipeAndSearchVC.shared.cardData.month
        tf_YYYY.text = SwipeAndSearchVC.shared.cardData.year//11242400505
    }
    
    func didUpdateDevice() {
        isCreditCardNumberDetected = false
        tf_CreditCard.resetCustomError(isAddAgain: false)
    }
    
    func noCardDetailFound() {
        isCreditCardNumberDetected = false
        tf_CreditCard.setCustomError()
    }
    
    func disableCardReader() {
        disableValidateToChangeColor()
        self.updateTipUI(type: 0)
        //        SwipeAndSearchVC.delegate = nil
    }
    
    func enableCardReader() {
        self.delegate?.disableCardReaders?()
        SwipeAndSearchVC.delegate = nil
        SwipeAndSearchVC.delegate = self
        //        SwipeAndSearchVC.shared.enableTextField()
    }
    
    func sendCreditCardData(with key: String, isIPad: Bool) {
        tf_CreditCard.resetCustomError(isAddAgain: false)
        
        if key == "auth" {
            let Obj = ["cardnumber":tf_CreditCard.text!,"mm":tf_MM.text!, "yyyy":tf_YYYY.text!, "amount": tf_Amount.text!, "cvv":tf_CVV.text!, "auth":"AUTH"]
            delegate?.getPaymentData?(with: Obj)
        }
        else {
            let Obj = ["cardnumber":tf_CreditCard.text!,"mm":tf_MM.text!, "yyyy":tf_YYYY.text!, "amount": tf_Amount.text!, "cvv":tf_CVV.text!, "auth":"AUTH_CAPTURE", "tip":tipAmount] as [String : Any]
            delegate?.getPaymentData?(with: Obj)
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func reset() {
        numberField.text = ""
        tipAmount = 0
        tipType = 0.0
        //numberField.text = tipAmount.currencyFormatA
        self.delegate?.updateTotal?(with: tipAmount)
        tf_CreditCard.resetCustomError(isAddAgain: false)
        tf_MM.resetCustomError(isAddAgain: false)
        tf_YYYY.resetCustomError(isAddAgain: false)
        selectedYear = ""
        upadateMonthArray()
        updateTipUI(type: 0)
        if DataManager.selectedPayment?.count == 1 || (DataManager.selectedPayment?.count == 2 && (DataManager.selectedPayment!.contains("MULTI CARD"))){
            didUpdateRemainingAmt(RemainingAmt: 0.0)
        }
        //Reset Credit Card Data If Not Selected By Existing User
        if let dict = UserDefaults.standard.value(forKey: "SelectedCustomer") as? NSDictionary {
            let cardDetail = decode(dict: dict as! [String : Any])
            var number = cardDetail.cardNumber ?? ""
            if number.count == 4 {
                number = "************" + number
            }
            if DataManager.isBalanceDueData && appDelegate.orderDataClear == false {
//                           DataManager.last4DigitCard = ""
//                           tf_CreditCard.text = ""
//                           tf_MM.text = ""
//                           tf_YYYY.text = ""
//                           tf_CVV.text = ""
                       } else {
                           DataManager.last4DigitCard = cardDetail.cardNumber
                           tf_CreditCard.text = number
                           tf_MM.text = cardDetail.month
                           tf_YYYY.text = cardDetail.year
                           tf_CVV.text = ""
                       }
            return
        }
        
        tf_CreditCard.text = ""
        tf_MM.text = ""
        tf_YYYY.text = ""
        tf_CVV.text = ""
        
        disableValidateToChangeColor()
    }
}

//MARK: SwipeAndSearchDelegate
extension CreditCardContainerViewController: SwipeAndSearchDelegate {
    func didGetCardDetail(number: String, month: String, year: String) {
        tf_CreditCard.resetCustomError(isAddAgain: false)
        tf_CreditCard.text = number
        tf_MM.text = month
        tf_YYYY.text = year
        if DataManager.isSwipeToPay {
            //SwipeAndSearchVC.delegate = nil
            
            DataManager.tempSignature = DataManager.signature
            //            if DataManager.signature {
            //                DataManager.signature = false
            //            }
            
            delegate?.placeOrder?(isIpad: UI_USER_INTERFACE_IDIOM() == .pad)
        }
        callValidateToChangeColor()
    }
}

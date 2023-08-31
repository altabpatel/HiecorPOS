//
//  PaxPayContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PaxPayContainerViewController: BaseViewController, ClassEMVDelegate {
    func savedCardEMVInfoInphone(cartSavedArray: Array<AnyObject>) {
        print("khgfkkjhjjgjjjjgkjhkjhkjh")
        print("cartDataArray",cartSavedArray)
         let object = cartSavedArray[0] as! SavedCardList
         
         let last_4 = object.last_4
         let cardexpyr = object.cardexpyr
         let cardexpmo = object.cardexpmo
         let last4 = object.last4
         let token = object.emv_card_token
         paxCardToken = token
         strLastFourDigit = "(\(last_4))"
         lblLastFourDigit.text = strLastFourDigit
         //cardSavedbpid = object.bpid
        // DataManager.Bbpid = object.bpid
         //print("bpid",cardSavedbpid as Any)
         print("last_4",last_4 as Any)
         print("cardexpyr",cardexpyr as Any)
         print("cardexpmo",cardexpmo as Any)
         print("token", token as Any)
    }
    
    
    //MARK: IBOutlet
    @IBOutlet var paxTypeSegemnt: UISegmentedControl!
    @IBOutlet weak var btnSelectPax: UIButton!
    @IBOutlet var noTripBtn: UIButton!
    @IBOutlet var fifteenBtn: UIButton!
    @IBOutlet var twentyBtn: UIButton!
    @IBOutlet var twentyFiveBtn: UIButton!
    @IBOutlet var numberField: UITextField!
    @IBOutlet weak var tf_SelectDevice: UITextField!
    @IBOutlet weak var tipView: UIStackView!
    @IBOutlet weak var textfieldStackView: UIStackView!
    @IBOutlet weak var viewIsCheckPax: UIView!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var tf_Amount: UITextField!
    @IBOutlet weak var btnSavedCard: UIButton!
    @IBOutlet weak var lblLastFourDigit: UILabel!
    
    //MARK: Variables
    var isDeviceSelected = false
    var paymentMode = "CREDIT"   // GIFT/CREDIT/DEBIT
    var tip = "0"
    var tipType = "0"
    var total = String()
    var totalAmount = Double()
    var url = String()
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var paxArray = [String]()
    var str_isPaxTokenEnable = String()
    var str_isUserPaxToken = String()
    var isCardFileSelected = Bool()
    var creditCardDataShow : creditInfoDelegate?
    var paxCardToken = ""
    var strLastFourDigit = ""
    var cardSavedModel = [SavedCardList]()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        self.updateUI()
        tf_Amount.delegate = self
        tf_Amount.setPadding()
        tf_Amount.setDollar()
        tf_Amount.text = totalAmount.currencyFormatA
        
        if DataManager.isSplitPayment {
            print("enterrrrrrrrrrrrrrrrr")
            viewAmount.isHidden = false
        } else {
            viewAmount.isHidden = true
            //constTopCard.constant = 20
            print("outerrrrrrrrrrrrrrrrr")
        }
        lblLastFourDigit.isHidden = true
        //btnSavedCard.isHidden = true
        customiseUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Enter Value  viewDidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Enter Value  viewWillAppear")
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if DataManager.EmvCardCount > 0 {
                callAPItoGetEmvSavedCard()
            }else{
                lblLastFourDigit.text = ""
            }
        }
        if HomeVM.shared.DueShared > 0 {
            tf_Amount.text = HomeVM.shared.DueShared.currencyFormatA
        } else {
            tf_Amount.text = totalAmount.currencyFormatA
        }
        
        if paymentMode == "GIFT" {
            appDelegate.strPaxMode = "GIFT"
        } else {
            appDelegate.strPaxMode = ""
        }
        customiseUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        numberField.setBorder(color: UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0))
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tf_SelectDevice.updateCustomBorder()
    }
    
    //MARK: Private Function
    private func customiseUI() {
        if DataManager.EmvCardCount > 1 {
            btnSavedCard.isHidden = false
        } else{
            btnSavedCard.isHidden = true
        }
    }
    
    private func updateUI() {
        numberField.keyboardType = .decimalPad
        numberField.delegate = self
        numberField.setDollar(font: numberField.font!)
        tf_SelectDevice.setDropDown()
        tf_SelectDevice.setPadding()
        tf_Amount.setPadding()
        tf_SelectDevice.setPlaceholder()
        tf_SelectDevice.isHidden = true
        tf_SelectDevice.tintColor = UIColor.clear
        paxTypeSegemnt.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5019106269, green: 0.5176784396, blue: 0.5607143641, alpha: 1)], for: .normal)
        fixBackgroundSegmentControl(paxTypeSegemnt)
    }
    
    private func loadData() {
        fifteenBtn.backgroundColor = UIColor.white
        fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyBtn.backgroundColor = UIColor.white
        twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyFiveBtn.backgroundColor = UIColor.white
        twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        noTripBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        noTripBtn.setTitleColor(.white, for: .normal)
        
        //Hide Tip View
        //tipView.isHidden = !DataManager.collectTips || DataManager.selectedPAX.first?.lowercased() != "CREDIT".lowercased()
        tipView.isHidden = true
        //Update Pax Type
        paxArray.removeAll()
        
        for type in DataManager.selectedPAX {
            switch type {
            case "CREDIT":
                paxArray.append("Pay By Credit")
                break
            case "DEBIT":
                paxArray.append("Pay By Debit")
                break
            case "GIFT":
                paxArray.append("Pay By Gift")
                break
            default: break
            }
        }
        paxTypeSegemnt.replaceSegments(segments: paxArray)
        paxTypeSegemnt.selectedSegmentIndex = 0
        
        //Update Previous Data If Available
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key.lowercased() == "pax pay" {
            if let data = PaymentsViewController.paymentDetailDict["data"] as? JSONDictionary {
                paymentMode = data["pax_payment_type"] as? String ?? ""
                tf_SelectDevice.text = data["device"] as? String ?? ""
                url = data["url"] as? String ?? ""
                tip = data["tip"] as? String ?? ""
                tipType = data["tipType"] as? String ?? "0"
                total = data["total"] as? String ?? ""
                callValidateToChangeColor()
                //Update Tip
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    switch self.tipType {
                    case "0":
                        self.noTipTapped()
                        break
                    case "15":
                        self.fifteenTipTapped()
                        break
                    case "20":
                        self.twentyTipTapped()
                        break
                    case "25":
                        self.twentyfiveTipTapped()
                        break
                    case "Manual":
                        self.numberField.text = (Double(self.tip) ?? 0.0).roundToTwoDecimal
                        self.tipType = "Manual"
                        self.manualTip()
                        break
                    default: break
                    }
                }
                //Update Segment
                if let index = DataManager.selectedPAX.firstIndex(where: {$0.lowercased() == paymentMode.lowercased()}) {
                    paxTypeSegemnt.selectedSegmentIndex = index
                }else {
                    paxTypeSegemnt.selectedSegmentIndex = 0
                    paymentMode = DataManager.selectedPAX.first ?? ""
                }
                //            paxTypeSegemnt.selectedSegmentIndex = paymentMode == "CREDIT" ? 0 : paymentMode ==  "DEBIT" ? 1 : 2
                if DataManager.collectTips {
                    //tipView.isHidden = paymentMode != "CREDIT"
                    tipView.isHidden = true
                }else {
                    tipType = "0"
                    tipView.isHidden = true
                }
            }
        }
    }
    
    func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl){
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(segmentControl.numberOfSegments-1)  {
                    let backgroundSegmentView = segmentControl.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    //backgroundSegmentView.isHidden = true
                    
                    self.paxTypeSegemnt.tintColor = .white
                    self.paxTypeSegemnt.backgroundColor = .white
                    
                    self.paxTypeSegemnt.layer.borderColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    self.paxTypeSegemnt.selectedSegmentTintColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                    self.paxTypeSegemnt.layer.borderWidth = 1

                        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5019106269, green: 0.5176784396, blue: 0.5607143641, alpha: 1)]
                    self.paxTypeSegemnt.setTitleTextAttributes(titleTextAttributes, for:.normal)

                        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
                    self.paxTypeSegemnt.setTitleTextAttributes(titleTextAttributes1, for:.selected)
                  //  }
                }
            }
        }
    }
    private func noTipTapped() {
        numberField.resignFirstResponder()
        fifteenBtn.backgroundColor = UIColor.white
        fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyBtn.backgroundColor = UIColor.white
        twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyFiveBtn.backgroundColor = UIColor.white
        twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        noTripBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        noTripBtn.setTitleColor(.white, for: .normal)
        
        tip = "0"
        tipType = "0"
        numberField.text = ""
        self.delegate?.updateTotal?(with: Double(tip) ?? 0.0)
    }
    
    private func fifteenTipTapped() {
        numberField.resignFirstResponder()
        fifteenBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        fifteenBtn.setTitleColor(.white, for: .normal)
        twentyBtn.backgroundColor = UIColor.white
        twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyFiveBtn.backgroundColor = UIColor.white
        twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        noTripBtn.backgroundColor = UIColor.white
        noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        
        let totalAmount = Double(total) ?? 0.0
        tip = ((totalAmount/100)*15).roundToTwoDecimal
        tipType = "15"
        numberField.text = tip
        self.delegate?.updateTotal?(with: Double(tip) ?? 0.0)
    }
    
    private func twentyTipTapped() {
        numberField.resignFirstResponder()
        fifteenBtn.backgroundColor = UIColor.white
        fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        twentyBtn.setTitleColor(.white, for: .normal)
        twentyFiveBtn.backgroundColor = UIColor.white
        twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        noTripBtn.backgroundColor = UIColor.white
        noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        
        let totalAmount = Double(total) ?? 0.0
        tip = ((totalAmount/100)*20).roundToTwoDecimal
        tipType = "20"
        numberField.text = tip
        self.delegate?.updateTotal?(with: Double(tip) ?? 0.0)
    }
    
    private func twentyfiveTipTapped() {
        numberField.resignFirstResponder()
        fifteenBtn.backgroundColor = UIColor.white
        fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyBtn.backgroundColor = UIColor.white
        twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyFiveBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        twentyFiveBtn.setTitleColor(.white, for: .normal)
        noTripBtn.backgroundColor = UIColor.white
        noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        
        let totalAmount = Double(total) ?? 0.0
        tip = ((totalAmount/100)*25).roundToTwoDecimal
        tipType = "25"
        numberField.text = tip
        self.delegate?.updateTotal?(with: Double(tip) ?? 0.0)
    }
    
    private func manualTip() {
        fifteenBtn.backgroundColor = UIColor.white
        fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyBtn.backgroundColor = UIColor.white
        twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyFiveBtn.backgroundColor = UIColor.white
        twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        noTripBtn.backgroundColor = UIColor.white
        noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        
        tip = numberField.text ?? "0.00"
        numberField.text = (Double(tip) ?? 0.0).roundToTwoDecimal
        tipType = "Manual"
        self.delegate?.updateTotal?(with: Double(tip) ?? 0.0)
    }
    
    //MARK: IBAction
    @IBAction func paxSegmentChanged(_ sender: UISegmentedControl) {
        //Hide Tip View
        //tipView.isHidden = !DataManager.collectTips || DataManager.selectedPAX[sender.selectedSegmentIndex].lowercased() != "CREDIT".lowercased()
        paymentMode = DataManager.selectedPAX[sender.selectedSegmentIndex].uppercased()
        
        if paymentMode == "GIFT"{
            appDelegate.strPaxMode = "GIFT"
        } else {
            appDelegate.strPaxMode = ""
        }
        
        if paymentMode == "CREDIT" {
            loadClassData()
        } else {
            viewIsCheckPax.isHidden = true
        }
        
        if DataManager.selectedPAX[sender.selectedSegmentIndex].uppercased() != "CREDIT" {
            //            fifteenBtn.backgroundColor = UIColor.white
            //            fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            //            twentyBtn.backgroundColor = UIColor.white
            //            twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            //            twentyFiveBtn.backgroundColor = UIColor.white
            //            twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            //            noTripBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            //            noTripBtn.setTitleColor(.white, for: .normal)
            
            //tip = "0"
            //tipType = "0"
            //numberField.text = ""  10060625075  IDFB0041322
            self.delegate?.updateTotal?(with: Double(tip) ?? 0.0)
        }
        
        self.delegate?.paxModeCheckAuth?(strPaxMode: paymentMode)
    }
    
    @IBAction func tf_SelectDeviceAction(_ sender: Any) {
        isDeviceSelected = true
        if HomeVM.shared.paxDeviceList.count > 0 {
            let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
            tf_SelectDevice.text = HomeVM.shared.paxDeviceList[0].name
            url = HomeVM.shared.paxDeviceList[0].url
            if array.count == 1 {
                self.tf_SelectDevice.resignFirstResponder()
                return
            }
            self.pickerDelegate = self
            self.setPickerView(textField: tf_SelectDevice, array: array)
        }else {
            tf_SelectDevice.resignFirstResponder()
            self.callAPItoGetPAXDeviceList()
        }
    }
    
    @IBAction func noTripTapped(_ sender: UIButton) {
        noTipTapped()
    }
    
    @IBAction func fifteenTapped(_ sender: UIButton) {
        fifteenTipTapped()
    }
    
    @IBAction func twentyTapped(_ sender: UIButton) {
        twentyTipTapped()
    }
    
    @IBAction func twentyFiveTapped(_ sender: UIButton) {
        twentyfiveTipTapped()
    }
    
    @IBAction func actionSelectPax(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true)
        {
            lblLastFourDigit.isHidden = false
            isCardFileSelected = true
            sender.setImage(UIImage(named:"boxSelect"), for: UIControlState.normal)
        }
        else
        {
            lblLastFourDigit.isHidden = true
            isCardFileSelected = false
            sender.setImage(UIImage(named:"boxUnselect"), for: UIControlState.normal)
        }
    }
    
    @IBAction func btnSavedCard_Action(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if DataManager.EmvCardCount > 0 {
                self.creditCardDataShow?.didDataShowCreditcard?(paymentMethod: "paxpay")
                self.delegate?.showCreditCard!()
            }else{
            }
        }else{
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "SavedCardViewController") as! SavedCardViewController
            secondVC.strPaymentName = "paxpay"
            secondVC.delegateEmv = self
            present(secondVC, animated: true, completion: nil)
        }
    }
    
    func callValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if tf_SelectDevice.text != "" && tf_Amount.text != "" {
                delegate?.checkPayButtonColorChange?(isCheck: true, text: "PAX PAY")
            }else{
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "PAX PAY")
            }
        }else{
            if tf_SelectDevice.text != "" {
                delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "PAX PAY")
            }else{
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "PAX PAY")
            }
        }
    }
    func disableValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if tf_SelectDevice.text == "" && tf_Amount.text != "" {
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "PAX PAY")
            }
        }else{
            if tf_SelectDevice.text == ""  {
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "PAX PAY")
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension PaxPayContainerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.hideAssistantBar()
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        
        if textField == tf_SelectDevice {
            textField.resetCustomError(isAddAgain: false)
            textfieldStackView.spacing = 8
        }
        if textField == tf_Amount {
            tf_Amount.selectAll(nil)
        }
        
        if textField == numberField {
            textField.selectAll(nil)
            fifteenBtn.backgroundColor = UIColor.white
            fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyBtn.backgroundColor = UIColor.white
            twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.white
            twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            noTripBtn.backgroundColor = UIColor.white
            noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == numberField {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            callValidateToChangeColor()
            return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
        
        if textField == tf_Amount {
            HomeVM.shared.errorTip = 0.0
            HomeVM.shared.tipValue = 0.0
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let amount = Double(replacementText) ?? 0.0
            if HomeVM.shared.DueShared > 0 {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= HomeVM.shared.DueShared
            } else {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= totalAmount
            }
            //return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
            //return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= totalAmount
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == numberField {
            tip = numberField.text ?? "0.00"
            textField.text = (Double(tip) ?? 0.0).roundToTwoDecimal
            tipType = "Manual"
            self.delegate?.updateTotal?(with: Double(tip) ?? 0.0)
        }
        callValidateToChangeColor()
        if DataManager.isSplitPayment {
            if textField == tf_Amount {
                appDelegate.amount = tf_Amount.text?.toDouble() ?? 0.0
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

//MARK: HieCORPickerDelegate
extension PaxPayContainerViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        tf_SelectDevice.text = HomeVM.shared.paxDeviceList[index].name
        let ob : [String] = [HomeVM.shared.paxDeviceList[index].name]
        DataManager.selectedPaxRefund = ob
        print(DataManager.selectedPaxRefund)
        url = HomeVM.shared.paxDeviceList[index].url
    }
    
    func didClickOnPickerViewDoneButton() {
        tf_SelectDevice.resignFirstResponder()
        callValidateToChangeColor()
    }
    
    func didClickOnPickerViewCancelButton() {
        tf_SelectDevice.text = ""
        url = ""
    }
}

//MARK: PaymentTypeDelegate
extension PaxPayContainerViewController: PaymentTypeDelegate {
   
    func didSendCreditSavedCardData(cartDataArray:Array<AnyObject>){
        print("cartDataArray",cartDataArray)
        let object = cartDataArray[0] as! SavedCardList
        
        let last_4 = object.last_4
        let cardexpyr = object.cardexpyr
        let cardexpmo = object.cardexpmo
        let last4 = object.last4
        let token = object.emv_card_token
        paxCardToken = token
        strLastFourDigit = "(\(last_4))"
        lblLastFourDigit.text = strLastFourDigit
        btnSelectPax.isSelected = true
        if(btnSelectPax.isSelected == true)
        {
            lblLastFourDigit.isHidden = false
            isCardFileSelected = true
            btnSelectPax.setImage(UIImage(named:"boxSelect"), for: UIControlState.normal)
        }
        //cardSavedbpid = object.bpid
       // DataManager.Bbpid = object.bpid
        //print("bpid",cardSavedbpid as Any)
        print("last_4",last_4 as Any)
        print("cardexpyr",cardexpyr as Any)
        print("cardexpmo",cardexpmo as Any)
        print("token", token as Any)
        
    }
    
    func didUpdateTotal(amount: Double , subToal : Double) {
        //self.total = amount.roundToTwoDecimal 
        self.total = subToal.roundToTwoDecimal
        if tipType == "Manual" {
            return
        }
        totalAmount = amount
        tf_Amount.text = amount.currencyFormatA
        let tipAmount = ((Double(self.total) ?? 0.0)/100) * (Double(tipType) ?? 0.0)
        self.delegate?.updateTotal?(with: tipAmount)
    }
    
    func updateError(textfieldIndex: Int, message: String) {
        switch textfieldIndex {
        case 1:
            textfieldStackView.spacing = 25
            tf_SelectDevice.setCustomError(text: message, bottomSpace: 2)
            break
        default: break
        }
    }
    
    func loadClassData() {
        self.viewIsCheckPax.isHidden = true
        if let val = DataManager.isPaxTokenEnable {
            self.str_isPaxTokenEnable = val
        }
        if let val2 = DataManager.isUserPaxToken {
            self.str_isUserPaxToken = val2
        }
        
        if str_isPaxTokenEnable == "true" && str_isUserPaxToken != ""{
            self.viewIsCheckPax.isHidden = false
        }else{
            self.viewIsCheckPax.isHidden = true
        }
        //self.creditCardDataShow?.didDataShowCreditcard?(paymentMethod: "paxpay")
        //self.delegate?.showCreditCard!()
        reset()
        isDeviceSelected = false
        self.callAPItoGetPAXDeviceList()
        
    }
    
    func saveData() {
        self.view.endEditing(true)
        PaymentsViewController.paymentDetailDict["data"] = ["pax_payment_type":paymentMode, "device": tf_SelectDevice.text ?? "","url": url, "tip": tip, "tipType": tipType,"total": total,"use_token":isCardFileSelected, "user_pax_token":paxCardToken]
    }
    
    func sendPAXData(with key: String, isIPad: Bool) {
        let Obj: JSONDictionary = ["auth": key == "auth" ? "AUTH" : "AUTH_CAPTURE","pax_payment_type":paymentMode, "device": tf_SelectDevice.text ?? "","url": url, "tip": tip,"total": total ,"use_token":isCardFileSelected, "amount": tf_Amount.text!,  "user_pax_token":paxCardToken]
        delegate?.getPaymentData?(with: Obj)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func reset() {
        numberField.text = ""
        tf_SelectDevice.resetCustomError(isAddAgain: false)
        numberField.text = ""
        //paxTypeSegemnt.selectedSegmentIndex = 0
        paymentMode = "CREDIT"
        tip = "0"
        isCardFileSelected = false
        if HomeVM.shared.paxDeviceList.count > 0 {
            if DataManager.selectedPaxDeviceName != "" {
                self.tf_SelectDevice.text = DataManager.selectedPaxDeviceName
            }else{
                self.tf_SelectDevice.text = HomeVM.shared.paxDeviceList[0].name
            }
            // self.tf_SelectDevice.text = HomeVM.shared.paxDeviceList[0].name
            
            for i in 0..<HomeVM.shared.paxDeviceList.count {
                if self.tf_SelectDevice.text == HomeVM.shared.paxDeviceList[i].name {
                     self.url = HomeVM.shared.paxDeviceList[i].url
                }
            }
        }
        
        fifteenBtn.backgroundColor = UIColor.white
        fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyBtn.backgroundColor = UIColor.white
        twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        twentyFiveBtn.backgroundColor = UIColor.white
        twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        noTripBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        noTripBtn.setTitleColor(.white, for: .normal)
        self.delegate?.updateTotal?(with: Double(tip) ?? 0.0)
        disableValidateToChangeColor()
    }
    
}

//MARK: API Methods
extension PaxPayContainerViewController {
    
    func callAPItoGetEmvSavedCard()
        {
            Indicator.isEnabledIndicator = false
            Indicator.sharedInstance.showIndicator()

        var strId = HomeVM.shared.customerUserId
        if HomeVM.shared.customerUserId == "" {
            if DataManager.customerId != "" {
                strId = DataManager.customerId
                HomeVM.shared.customerUserId = strId
            }
        }
            HomeVM.shared.getEmvSavedCardData(id:strId,responseCallBack: { (success, message, error) in
                if success == 1 {
                    self.cardSavedModel = HomeVM.shared.savedCardList
                    
                    DataManager.EmvCardCount = self.cardSavedModel.count
                    
                    for i in 0..<self.cardSavedModel.count {

                        let object = self.cardSavedModel[0]
                        
                        let last_4 = object.last_4
                        let cardexpyr = object.cardexpyr
                        let cardexpmo = object.cardexpmo
                        let last4 = object.last4
                        let token = object.emv_card_token
                        self.paxCardToken = token
                        self.strLastFourDigit = "(\(last_4))"
                        self.lblLastFourDigit.text = self.strLastFourDigit
                    }
                    
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                }else {
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
    
    func callAPItoGetPAXDeviceList() {
        HomeVM.shared.getPaxDeviceList(responseCallBack: { (success, message, error) in
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                self.tf_SelectDevice.isHidden = HomeVM.shared.paxDeviceList.count == 1
                if HomeVM.shared.paxDeviceList.count > 0 {
                    if self.tf_SelectDevice.isEmpty {
                        if DataManager.selectedPaxDeviceName != "" {
                            self.tf_SelectDevice.text = DataManager.selectedPaxDeviceName
                        }else{
                            self.tf_SelectDevice.text = HomeVM.shared.paxDeviceList[0].name
                        }
                        self.url = HomeVM.shared.paxDeviceList[0].url
                    }
                }
                if self.isDeviceSelected {
                    self.tf_SelectDevice.becomeFirstResponder()
                }
                self.callValidateToChangeColor()
            }
            else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
}

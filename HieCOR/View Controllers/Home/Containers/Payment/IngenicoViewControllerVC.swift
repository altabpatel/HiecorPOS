//
//  IngenicoViewControllerVC.swift
//  HieCOR
//
//  Created by Hiecor on 17/06/20.
//  Copyright © 2020 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class IngenicoViewControllerVC: BaseViewController {

    
    var totalAmount = Double()
    @IBOutlet weak var txfAmount: UITextField!
    @IBOutlet weak var btnSaveCard: UIButton!
    @IBOutlet weak var btnSelectcheckbox: UIButton!
    @IBOutlet weak var stackUseCardView: UIStackView!
    @IBOutlet weak var stackCardLastDigit: UIStackView!
    @IBOutlet weak var lblCardNumber: UILabel!
    
    var creditCardDataShow : creditInfoDelegate?
    var strLastFourDigit = ""
    var cardSavedModel = [SavedCardList]()
    var ingenicoCardToken = ""
    var isCardFileSelected = false
    var delegate: PaymentTypeContainerViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSaveCard.isHidden = true
        stackUseCardView.isHidden = true
        stackCardLastDigit.isHidden = true
        lblCardNumber.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txfAmount.delegate = self
        txfAmount.setDollar(font: txfAmount.font!)
        if HomeVM.shared.DueShared > 0 {
            txfAmount.text = HomeVM.shared.DueShared.currencyFormatA
            appDelegate.amount = HomeVM.shared.DueShared
        } else {
            txfAmount.text = totalAmount.currencyFormatA
        }
        if appDelegate.isOpenUrl {
           
            let amt = Double(appDelegate.openUrlCardReaderAmmount)
            txfAmount.text = amt?.currencyFormatA
            appDelegate.amount = amt ?? 0.0
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            if DataManager.IngenicoCardCount > 0 {
                callAPItoGetIngenicoSavedCard()
                stackCardLastDigit.isHidden = false
                stackUseCardView.isHidden = false
            }else{
                lblCardNumber.text = ""
                stackCardLastDigit.isHidden = true
                stackUseCardView.isHidden = true
            }
        }
        
        if DataManager.IngenicoCardCount > 1 {
            btnSaveCard.isHidden = false
        } else{
            btnSaveCard.isHidden = true
        }
        
        
        
        if DataManager.isSplitPayment {
            txfAmount.isEnabled = true
        } else {
            txfAmount.isEnabled = false
        }
        appDelegate.strIngenicoAmount = txfAmount.text ?? ""
        appDelegate.CardReaderAmount = txfAmount.text?.toDouble() ?? 0.0
        if appDelegate.isOpenUrl {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                appDelegate.isOpenUrl = false
                let amt = Double(appDelegate.openUrlCardReaderAmmount)
                self.txfAmount.text = amt?.currencyFormatA
                appDelegate.amount = amt ?? 0.0
                appDelegate.strIngenicoAmount = self.txfAmount.text ?? ""
                appDelegate.CardReaderAmount = self.txfAmount.text?.toDouble() ?? 0.0
                self.delegate?.balanceDueRemaining?(with: self.txfAmount.text?.toDouble() ?? 0.0)
                self.callValidateToChangeColor()
            }
        }
    }
    
    @objc func handleCardNumberTextField(sender: UITextField) {
        
        callValidateToChangeColor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        txfAmount.updateCustomBorder()
    }

    
    @IBAction func btnSelectUseCardDetails_Action(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if(sender.isSelected == true)
        {
            lblCardNumber.isHidden = false
            isCardFileSelected = true
            appDelegate.isIngenicoTokenAvl = true
            sender.setImage(UIImage(named:"boxSelect"), for: UIControlState.normal)
        }
        else
        {
            lblCardNumber.isHidden = true
            isCardFileSelected = false
            appDelegate.isIngenicoTokenAvl = false
            sender.setImage(UIImage(named:"boxUnselect"), for: UIControlState.normal)
        }
    }
    
    @IBAction func btnSaveCard_Action(_ sender: Any) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if DataManager.IngenicoCardCount > 0 {
                self.creditCardDataShow?.didDataShowCreditcard?(paymentMethod: "cardReader")
                self.delegate?.showCreditCard!()
            }else{
            }
        }else{
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "SavedCardViewController") as! SavedCardViewController
            //secondVC.strPaymentName = "paxpay"
            //secondVC.delegateEmv = self
            present(secondVC, animated: true, completion: nil)
        }
    }
    
    func callValidateToChangeColor() {
        txfAmount.resetCustomError(isAddAgain: false)
        txfAmount.hideAssistantBar()

        if appDelegate.isErrorCreateOrderCase {
            txfAmount.setCustomError(text: appDelegate.strErrorMsg, bottomSpace: 2.0)
            appDelegate.isErrorCreateOrderCase = false
            
        }
        let obEx = (txfAmount.text! as NSString).replacingOccurrences(of: "$", with: "")
        if DataManager.isSplitPayment {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if txfAmount.text != "" {
                    delegate?.checkPayButtonColorChange?(isCheck: true, text: "CARD READER")
                }else{
                    delegate?.checkPayButtonColorChange?(isCheck: false, text: "CARD READER")
                }
            } else {
                if txfAmount.text != "" {
                    delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "CARD READER")
                }else{
                    delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CARD READER")
                }
            }
            
        } else {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if txfAmount.text != "" && ((obEx as NSString).doubleValue == totalAmount ||  totalAmount < (obEx as NSString).doubleValue)  {
                    delegate?.checkPayButtonColorChange?(isCheck: true, text: "CARD READER")
                }else{
                    delegate?.checkPayButtonColorChange?(isCheck: false, text: "CARD READER")
                }
            }else{
                if txfAmount.text != "" && ((obEx as NSString).doubleValue == totalAmount ||  totalAmount < (obEx as NSString).doubleValue) {
                    delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "CARD READER")
                }else{
                    delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CARD READER")
                }
            }
        }
        
    }
    
    func disableValidateToChangeColor() {
           if UI_USER_INTERFACE_IDIOM() == .pad {
               if txfAmount.text == "" || (txfAmount.text != String(totalAmount) ||  txfAmount.text! < String(totalAmount))  {
                   delegate?.checkPayButtonColorChange?(isCheck: false, text: "CARD READER")
               }
           }else{
               if txfAmount.text == "" || (txfAmount.text != String(totalAmount) ||  txfAmount.text! < String(totalAmount))  {
                   delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "CARD READER")
               }
           }
       }
    
    func callAPItoGetIngenicoSavedCard()
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
            HomeVM.shared.getingenicoSavedCardData(id:strId,responseCallBack: { (success, message, error) in
                if success == 1 {
                    self.cardSavedModel = HomeVM.shared.savedCardList
                    
                    DataManager.IngenicoCardCount = self.cardSavedModel.count
                    
                    for i in 0..<self.cardSavedModel.count {

                        let object = self.cardSavedModel[0]
                        
                        let last_4 = object.last_4
                        let cardexpyr = object.cardexpyr
                        let cardexpmo = object.cardexpmo
                        let last4 = object.last4
                        let token = object.ingenico_card_token
                        let systemRefID = object.systemtokenRefId
                        appDelegate.strIngenicoBPID = object.bpid
                        appDelegate.strIngenicoTokenData = token
                        appDelegate.strIngenicoSystemRefId = systemRefID

                        self.ingenicoCardToken = token
                        self.strLastFourDigit = "(\(last_4))"
                        self.lblCardNumber.text = self.strLastFourDigit
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
}

//MARK: PaymentTypeDelegate
extension IngenicoViewControllerVC: PaymentTypeDelegate {
    
    func didUpdateRemainingAmt(RemainingAmt: Double){
        print("RemainingAmt",RemainingAmt)
        if HomeVM.shared.DueShared > 0 {
            if appDelegate.amount > 0 {
                txfAmount.text = "\(appDelegate.amount.currencyFormatA)"
            }else {
                txfAmount.text = "\(HomeVM.shared.DueShared.currencyFormatA)"
            }
        } else {
            txfAmount.text = "\(totalAmount.currencyFormatA)"
        }
        callValidateToChangeColor()
    }
    
    func didUpdateTotal(amount: Double , subToal : Double) {
        txfAmount.resetCustomError(isAddAgain: false)
        txfAmount.hideAssistantBar()
        print("amount",amount)
        totalAmount = amount
        txfAmount.text = amount.currencyFormatA
        appDelegate.strIngenicoAmount = txfAmount.text ?? ""
        appDelegate.CardReaderAmount = txfAmount.text?.toDouble() ?? 0.0
        callValidateToChangeColor()
    }
    
    func didSendCreditSavedCardData(cartDataArray:Array<AnyObject>){
        print("cartDataArray",cartDataArray)
        let object = cartDataArray[0] as! SavedCardList
        
        let last_4 = object.last_4
        let cardexpyr = object.cardexpyr
        let cardexpmo = object.cardexpmo
        let last4 = object.last4
        let token = object.ingenico_card_token
        let systemRefID = object.systemtokenRefId
        appDelegate.strIngenicoBPID = object.bpid
        appDelegate.strIngenicoTokenData = token
        appDelegate.strIngenicoSystemRefId = systemRefID
        ingenicoCardToken = token
        strLastFourDigit = "(\(last_4))"
        lblCardNumber.text = strLastFourDigit
        appDelegate.isIngenicoTokenAvl = true
        btnSelectcheckbox.isSelected = true
        if(btnSelectcheckbox.isSelected == true)
        {
            lblCardNumber.isHidden = false
            isCardFileSelected = true
            btnSelectcheckbox.setImage(UIImage(named:"boxSelect"), for: UIControlState.normal)
        }
        //cardSavedbpid = object.bpid
       // DataManager.Bbpid = object.bpid
        //print("bpid",cardSavedbpid as Any)
        print("last_4",last_4 as Any)
        print("cardexpyr",cardexpyr as Any)
        print("cardexpmo",cardexpmo as Any)
        print("token", token as Any)
        
    }
    func updateError(textfieldIndex: Int, message: String) {
        switch textfieldIndex {
        case 1:
            txfAmount.setCustomError(text: message, bottomSpace: 2.0)
            break
        default: break
        }
    }
    
    func sendIngenicoCardData(with key: String, isIPad: Bool, data: Any) {
        
        print(data)
        let ingenicoData = data as! IMSTransactionResponse
        //txfAmount.text = "\(ingenicoData.submittedAmount.total)"
        let numnber = ingenicoData.redactedCardNumber
        var expYear = ""
        var expmounth = ""
        let hh = ingenicoData.transactionType
        
        if ingenicoData.cardExpirationDate == "" || ingenicoData.cardExpirationDate == nil {
            expYear = ""
            expmounth = ""
        } else {
            expYear = "\(ingenicoData.cardExpirationDate.prefix(2))"
            expmounth = "\(ingenicoData.cardExpirationDate.suffix(2))"
        }
        
        let amt = Double(ingenicoData.submittedAmount.total - ingenicoData.submittedAmount.tip)/100
        var transaction : [String:Any]
        var transactionCode = ""
        if ingenicoData.transactionResponseCode.rawValue == 2  {
            transactionCode = "declined"
        } else if ingenicoData.transactionResponseCode.rawValue == 1 {
            transactionCode = "approved"
        }
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = format.string(from: date)
        
        let strName = timestamp.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        let newString = strName.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let newName = newString.replacingOccurrences(of: ":", with: "", options: .literal, range: nil)
        var entryMode = ""
        var strBPID = ""
        let transactionTokendata = ["token_response_code":ingenicoData.tokenResponseParameters.responseCode.rawValue ,
                                    "token_id":ingenicoData.tokenResponseParameters.tokenIdentifier ?? "",//"IdToken-\(newName)",//ingenicoData.tokenResponseParameters.tokenIdentifier ?? "",
                                    "source":ingenicoData.tokenResponseParameters.tokenSource ?? "",
                                    "tokensourcedata":ingenicoData.tokenResponseParameters.tokenSourceData ?? "",
                                    "tokenfeeincents":ingenicoData.tokenResponseParameters.tokenFeeInCents,
                                    "systemtokenRefId":appDelegate.strRefId] as? [String : Any]
        
        if ingenicoData.posEntryMode == .POSEntryModeToken {
            entryMode = "POSEntryModeToken"
            strBPID = appDelegate.strIngenicoBPID
        }
        let cardTypeData = self.getStringFromCardType(type: ingenicoData.cardType)
        
        transaction = [ "authorization_code": ingenicoData.authCode ?? "",
                        "authorized_amount": Double(ingenicoData.authorizedAmount)/100 ,
                        "avs_response": "Unknown",
        "batch_number": ingenicoData.batchNumber ?? "",
        "card_type": cardTypeData,
        "clerk_display": ingenicoData.clerkDisplay ?? "",
        "client_transaction_id": ingenicoData.clientTransactionID ?? "",
        "currency_code": ingenicoData.submittedAmount.currency ?? "",
        "customer_display": ingenicoData.customerDisplay ?? "",
        "cvd_response": "Unknown",
        "expiration_date": ingenicoData.cardExpirationDate ?? "",
        "mcm_transaction_id": ingenicoData.transactionID ?? "",
        "original_amount": Double(ingenicoData.submittedAmount.total)/100,
        "primary_account_number_masked": ingenicoData.redactedCardNumber ?? "" ,
        "request_transaction_code": "CreditSale",
        "sequence_no": ingenicoData.sequenceNumber ?? "",
        "transaction_amount": Double(ingenicoData.submittedAmount.total)/100,
        "transaction_code":transactionCode,
        "transaction_group_id": ingenicoData.transactionGroupID ?? "",
        "transaction_id": ingenicoData.transactionGUID ?? "",
        "cardholderName": ingenicoData.cardholderName ?? "",
        "error_code": appDelegate.strIngenicoErrorMsg,
        "entry_Mode": entryMode,
                        
        "token_bill_id": strBPID,
        "tipAmountValue": Double(ingenicoData.submittedAmount.tip)/100,
        "token_service_response": transactionTokendata ?? [:]]

        let transactiondata = ["transaction":transaction]
        
        let Obj = ["cardnumber":numnber,"mm":expmounth, "yyyy":expYear, "amount": amt, "cvv":"", "auth":"AUTH_CAPTURE", "orig_txn_response":ingenicoData.description, "merchant": "ingenico", "txn_response": transactiondata] as [String : Any]
        
        appDelegate.arrIngenicoData = transactiondata
        delegate?.getPaymentData?(with: Obj)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func getStringFromCardType(type:IMSCardType)->String{
        
        let typeString :String
        switch type {
        case .CardTypeAMEX:
            typeString = "amx"
        case .CardTypeDiners:
            typeString = "dine"
        case .CardTypeDiscover:
            typeString = "disc"
        case .CardTypeJCB:
            typeString = "jcb"
        case .CardTypeMasterCard:
            typeString = "mast"
        case .CardTypeVISA:
            typeString = "visa"
        case .CardTypeMaestro:
            typeString = "mast"
        default:
            typeString = ""
        }
        return typeString as String
    }
    
    private func sendIngenicoCardData(with key: String, isIPad: Bool) {
//        tf_CreditCard.resetCustomError(isAddAgain: false)
//q
//        if key == "auth" {
//            let Obj = ["cardnumber":tf_CreditCard.text!,"mm":tf_MM.text!, "yyyy":tf_YYYY.text!, "amount": tf_Amount.text!, "cvv":tf_CVV.text!, "auth":"AUTH"]
//            delegate?.getPaymentData?(with: Obj)
//        }
//        else {
//            let Obj = ["cardnumber":tf_CreditCard.text!,"mm":tf_MM.text!, "yyyy":tf_YYYY.text!, "amount": tf_Amount.text!, "cvv":tf_CVV.text!, "auth":"AUTH_CAPTURE", "tip":tipAmount] as [String : Any]
//            delegate?.getPaymentData?(with: Obj)
//        }
        
        //let Obj = ["cardnumber":tf_CreditCard.text!,"mm":tf_MM.text!, "yyyy":tf_YYYY.text!, "amount": tf_Amount.text!, "cvv":tf_CVV.text!, "auth":"AUTH_CAPTURE", "tip":tipAmount] as [String : Any]
        //delegate?.getPaymentData?(with: Obj)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
}

//MARK: UITextFieldDelegate
extension IngenicoViewControllerVC: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError(isAddAgain: false)
        textField.hideAssistantBar()
        if textField == txfAmount {
            txfAmount.selectAll(nil)
        }
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txfAmount {
            HomeVM.shared.errorTip = 0.0
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            callValidateToChangeColor()
            let amount = Double(replacementText) ?? 0.0
            appDelegate.CardReaderAmount = amount
            if HomeVM.shared.DueShared > 0 {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= HomeVM.shared.DueShared
            } else {
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= totalAmount
            }
            //return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Check For External Accessory
        if DataManager.isSplitPayment {
            if textField == txfAmount {
                appDelegate.amount = txfAmount.text?.toDouble() ?? 0.0
                appDelegate.strIngenicoAmount = txfAmount.text ?? ""
                delegate?.balanceDueRemaining?(with: txfAmount.text?.toDouble() ?? 0.0)
                appDelegate.CardReaderAmount = txfAmount.text?.toDouble() ?? 0.0
            }
        }
        callValidateToChangeColor()
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        appDelegate.strIngenicoAmount = ""
        if DataManager.isSplitPayment {
            if textField == txfAmount {
                delegate?.balanceDueRemaining?(with: txfAmount.text?.toDouble() ?? 0.0)
            }
        }
        disableValidateToChangeColor()
        textField.resignFirstResponder()
        return false
    }
}

//
//  TipViewController.swift
//  HieCOR
//
//  Created by hiecor on 19/03/20.
//  Copyright © 2020 HyperMacMini. All rights reserved.
//

import UIKit


protocol TipViewCellDelegate: class {
    func didFinishTask()
}

class TipViewController: BaseViewController {
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var btnProcessTip: UIButton!

    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var txtDeviceName: UITextField!
    @IBOutlet weak var txtTipAmount: UITextField!
    @IBOutlet weak var lblTotalAmt: UILabel!
    @IBOutlet weak var viewWiedthConstraint: NSLayoutConstraint!

    @IBOutlet weak var lblDeviceName: UILabel!
    @IBOutlet weak var lblTipAmount: UILabel!
    @IBOutlet weak var lblTransactionTotal: UILabel!
    @IBOutlet weak var paxfieldView: UIView!
    @IBOutlet weak var view_deviceName: UIStackView!
    @IBOutlet weak var viewCardDetail: UIStackView!
    @IBOutlet weak var lblPaidBy: UILabel!
    @IBOutlet weak var lblCardTipNumber: UILabel!
    
    //private var DeviceNamePicker: UIPickerView!
    //var strDeviceName = String()
    //weak var delegateSelf: TipViewCellDelegate?

    //var isPercentageDiscountApplied = false
    //var str_AddDiscountPercent = String()
    //var st][pr_AddDiscount = String()
    
    //var isCard : Bool?
    //var ddd = ""
    //var isWhiteBackButton : Bool = false
    
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var isDeviceSelected = false
    var amount : Float = 0.00
    var arrTransactionData = NSDictionary() //= [String: Any]
    var isEmv = ""
    var orderId = String()
    var transactionID = String()
    var cardNumber = String()
    var url = String()
    var pickerSelectedValue = String()
    var buttonAction: (() -> Void)?
    weak var delegateTipView : TipViewCellDelegate?
    var isShowPaxDevice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UI_USER_INTERFACE_IDIOM() == .pad){
            viewWiedthConstraint.constant = 450
        }
        txtTipAmount.becomeFirstResponder()
        btnProcessTip.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        btnProcessTip.isEnabled = false
        
//        txtTipAmount.text = "0.00"
        txtTipAmount.delegate = self

        addPaddingAndBorder(to: txtTipAmount)
        txtTipAmount.setCenterDollar(color: UIColor.darkGray, font: lblTotalAmt.font!)
    }
    
    func addPaddingAndBorder(to textfield: UITextField) {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 10.0, width: 100.0, height: 2.0))
        textfield.leftView = leftView
        textfield.leftViewMode = .always
    }


        override func viewWillAppear(_ animated: Bool) {
            print(arrTransactionData)
            isEmv = arrTransactionData.value(forKey: "isTypeEVM") as! String //as? String
            lblTotalAmt.text = arrTransactionData.value(forKey: "amount") as? String
            lblDeviceName.text = arrTransactionData.value(forKey: "type") as? String
            isShowPaxDevice  = arrTransactionData.value(forKey: "isShowPaxDevice") as? String ?? "false"// ?? false
            view_deviceName.isHidden = isShowPaxDevice == "true" ? false : true
            viewCardDetail.isHidden = isShowPaxDevice == "true" ? true : false
            if isEmv == "true"{
                callAPItoGetPAXDeviceList()
                lblCardNumber.isHidden = true
                paxfieldView.isHidden = false
            } else {
                if cardNumber == "************" {
                    lblCardNumber.isHidden = true
                } else {
                    lblCardNumber.isHidden = false
                    lblCardNumber.text = cardNumber
                }
                lblPaidBy.text = lblDeviceName.text
                lblCardTipNumber.text = cardNumber
                paxfieldView.isHidden = true
                //lblCardNumber.isHidden = false
            }
        }
    
    @IBAction func txtTipAmountAction(_ sender: Any) {
        txtTipAmount.delegate = self
        txtTipAmount.keyboardType = .decimalPad
    }
    
    @IBAction func txtDeviceNameAction(_ sender: Any) {
        isDeviceSelected = true
        self.pickerDelegate = self as HieCORPickerDelegate
       // self.setPickerView(textField: txtDeviceName, array: DeviceNameArray)
        let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
         txtDeviceName.text = HomeVM.shared.paxDeviceList[0].name ?? ""
         url = HomeVM.shared.paxDeviceList[0].url
         if array.count == 1 {
             self.txtDeviceName.resignFirstResponder()
             return
         }
         self.pickerDelegate = self
         self.setPickerView(textField: txtDeviceName, array: array)
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
        //buttonAction?()                 // action writen on view controller by than change the value of VC button
    }
    
    @IBAction func processTipButtonAction(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sender.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
        }
        let tipamt = Double(txtTipAmount.text!)
        if  tipamt != 0.00 {
            let stringURL = String(format: "%@%@",BaseURL, kSendTip)
            //Parameters
            var parameters: JSONDictionary = [:]
            if isEmv == "true" {
                parameters = [
                    "orderId": self.orderId,
                    "txnId": self.transactionID,
                    "pax_port":  isShowPaxDevice == "true" ? self.url : "" ,
                    "device_name": isShowPaxDevice == "true" ? self.txtDeviceName.text as Any : "",
                    "tip_amount": phoneNumberFormateRemoveText(number: txtTipAmount.text!)
                ]
            } else {
                parameters = [
                    "orderId": self.orderId,
                    "txnId": self.transactionID,
                    "tip_amount": phoneNumberFormateRemoveText(number: txtTipAmount.text!)
                ]
            }
            //Call API
            callAPItoSendTip(url: stringURL, parameters: parameters)
        } else {
            appDelegate.showToast(message: "Please Add Tip Amount")
        }
        buttonAction?()                 // action writen on view controller by than change the value of VC button
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//extension TipViewController: NumericKeyboardDelegate {
//    func numericKeyPressed(key: Int) {
//        print("Numeric key \(key) pressed!")
//    }
//
//    func numericBackspacePressed() {
//        print("Backspace pressed!")
//    }
//
//    func numericSymbolPressed(symbol: String) {
//        print("Symbol \(symbol) pressed!")
//    }
//
//    // MARK: - UITextfieldDelegate: switch between textfields.
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField ==  txtTipAmount { //customNumericTextfield {
//            AppDelegate.isStart = true
//            AppDelegate.isDecimal = true
//            AppDelegate.dd = ""
//            txtTipAmount.setAsNumericKeyboard(delegate: self)
//
//        return true
//    }
//
//}

extension TipViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtTipAmount{
            txtTipAmount.selectAll(nil)
        }
    }
     
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == txtTipAmount{
            let min = Float(txtTipAmount.text!) ?? 0
            var amtString = arrTransactionData.value(forKey: "amount") as? String
            
            let range = amtString?.range(of: "$")
            amtString?.removeSubrange(range!)
            amount = Float(amtString!) ?? 0.00
            
            // dd: int? = Int(txtTipAmount.text!)
            let totalAmt = Double(Float(Float(amount) + Float(min)))
            lblTotalAmt.text = "$\((totalAmt).roundToTwoDecimal)" //
            txtTipAmount.becomeFirstResponder()
        }
        
        if textField.text == "0.00"||textField.text == "0.0"||textField.text == "0"||textField.text == ""{
            btnProcessTip.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            btnProcessTip.isEnabled = false
        }else{
            btnProcessTip.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            btnProcessTip.isEnabled = true
        }
         
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
}

//MARK: HieCORPickerDelegate
extension TipViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        pickerSelectedValue = HomeVM.shared.paxDeviceList[index].name
        let ob : [String] = [HomeVM.shared.paxDeviceList[index].name]
        DataManager.selectedPaxRefund = ob
        print(DataManager.selectedPaxRefund)
        url = HomeVM.shared.paxDeviceList[index].url
    }
    
    func didClickOnPickerViewDoneButton() {
        txtDeviceName.text = pickerSelectedValue
        txtDeviceName.resignFirstResponder()
        callValidateToChangeColor()
    }
    
    func didClickOnPickerViewCancelButton() {
        //txtDeviceName.text = ""
        //url = ""
    }
}

class TipCustomView {
    func alert(title: String, completion: @escaping () -> Void) -> TipViewController {
        let storyboard = UIStoryboard(name: "iPad", bundle: .main)
        let customMenu = storyboard.instantiateViewController(withIdentifier: "TipViewController") as! TipViewController
        customMenu.buttonAction = completion
        return customMenu
    }
}

//MARK: API Methods
extension TipViewController {
    func callValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if txtDeviceName.text != "" {
                delegate?.checkPayButtonColorChange?(isCheck: true, text: "PAX PAY")
            }else{
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "PAX PAY")
            }
        }else{
            if txtDeviceName.text != "" {
                delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "PAX PAY")
            }else{
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "PAX PAY")
            }
        }
    }
    
    func callAPItoGetPAXDeviceList() {
        HomeVM.shared.getPaxDeviceList(responseCallBack: { (success, message, error) in
            Indicator.sharedInstance.hideIndicator()
            if success == 1 {
                self.txtDeviceName.isHidden = HomeVM.shared.paxDeviceList.count == 1
                self.paxfieldView.isHidden = HomeVM.shared.paxDeviceList.count == 1
                if HomeVM.shared.paxDeviceList.count > 0 {
                    if self.txtDeviceName.isEmpty {
                        if DataManager.selectedPaxDeviceName != "" {
                            self.txtDeviceName.text = DataManager.selectedPaxDeviceName
                        }else{
                            self.txtDeviceName.text = HomeVM.shared.paxDeviceList[0].name
                        }
                        self.url = HomeVM.shared.paxDeviceList[0].url
                    }
                }
                if self.isDeviceSelected {
                    self.txtDeviceName.becomeFirstResponder()
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
    
    func callAPItoSendTip(url: String, parameters: JSONDictionary) {
                OrderVM.shared.sendEmailOrText(url: url, parameters: parameters, responseCallBack: { (success, message, error) in
                     if success == 1 {
                                    //Hiec@r
                        self.delegateTipView?.didFinishTask()
                                 if UI_USER_INTERFACE_IDIOM() == .pad {
                                            appDelegate.showToast(message: "Tip updated successfully.")
                                    
                                            self.dismiss(animated: true)
                                        } else {
                                           // self.setRootViewControllerForIphone()
                                            appDelegate.showToast(message: "Tip updated successfully.")
                                            self.dismiss(animated: true)
                                        }
                                    } else {
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

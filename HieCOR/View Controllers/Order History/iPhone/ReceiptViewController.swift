//
//  ReceiptViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 06/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire

enum SelectedButonType {
    case email
    case text
    case other
}

class ReceiptViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var buttonsBackView: UIView!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var buttonsView: UIStackView!
    @IBOutlet var img_Done: UIImageView!
    @IBOutlet var lbl_DoneTitle: UILabel!
    @IBOutlet var view_Done: UIView!
    @IBOutlet var img_ReceiptType: UIImageView!
    @IBOutlet var lbl_ReceiptTypeTitle: UILabel!
    @IBOutlet var tf_PhoneNumber: UITextField!
    @IBOutlet var viewShadow: UIView!
    @IBOutlet var view_Border: UIView!
    @IBOutlet weak var btnSend: UIButton!
    
    //MARK: Varaibles
    var isReceiptText = Bool()
    var isReceiptEmail = Bool()
    var orderID = String()
    var userEmail = String()
    var userPhone = String()
    var selectedButonType: SelectedButonType = .email
    var receiptModel = ReceiptContentModel()
    var strGooglePrinterURL = ""
    var strEmailPhone = ""
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Delegate To Self
        tf_PhoneNumber.delegate = self
        view_Done.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UI_USER_INTERFACE_IDIOM() == .pad ? .default : .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.customizeUI()
        self.addShadow()
        self.checkPrinterConnection()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        addShadow()
        tf_PhoneNumber.updateCustomBorder()
    }
    
    //MARK: Private Functions
    private func checkPrinterConnection() {
        if PrintersViewController.centeralManager == nil || PrintersViewController.printerManager == nil {
            return
        }
        
        if let manager = PrintersViewController.printerManager, !manager.canPrint {
            if let index = PrintersViewController.printerArray.firstIndex(where: {$0.identifier == PrintersViewController.printerUUID}) {
                DispatchQueue.main.async {
                    PrintersViewController.printerManager?.connect(PrintersViewController.printerArray[index])
                }
            }
        }
    }
    
    private func customizeUI() {
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            buttonsView.isHidden = false
            buttonsBackView.isHidden = false
        }else {
            buttonsView.isHidden = true
            buttonsBackView.isHidden = true
        }
        
        if selectedButonType == .email {
            isReceiptEmail = true
            isReceiptText = false
        }
        
        if selectedButonType == .text {
            isReceiptEmail = false
            isReceiptText = true
        }
        
        if selectedButonType == .other {
            isReceiptEmail = false
            isReceiptText = false
        }
        self.setColor(type: selectedButonType)
        
        if isReceiptText {
            tf_PhoneNumber.text = formattedPhoneNumber(number: userPhone)
            tf_PhoneNumber.placeholder = "Phone Number"
            lbl_ReceiptTypeTitle.text = "Enter Phone Number"
            img_ReceiptType.image = UIImage(named: "receipt-phone")
            tf_PhoneNumber.keyboardType = .asciiCapableNumberPad
        }
        if(isReceiptEmail)
        {
            tf_PhoneNumber.text = userEmail
            tf_PhoneNumber.placeholder = "Email"
            lbl_ReceiptTypeTitle.text = "Enter Email Address"
            img_ReceiptType.image = UIImage(named: "recepit-email")
            tf_PhoneNumber.keyboardType = .emailAddress
        }
        
        callValidateToChangeColor()
        
        view_Border.layer.borderColor = UIColor.red.cgColor
        tf_PhoneNumber.setBorder()
    }
    
    private func addShadow() {
        let shadowSize : CGFloat = 5.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: (viewShadow.frame.size.width) + shadowSize,
                                                   height: (viewShadow.frame.size.height) + shadowSize))
        viewShadow.layer.masksToBounds = false
        viewShadow.layer.shadowColor = UIColor.lightGray.cgColor
        viewShadow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewShadow.layer.shadowOpacity = 0.5
        viewShadow.layer.shadowPath = shadowPath.cgPath
    }
    
    private func printData() {
        if BluetoothPrinter.sharedInstance.isConnected() || DataManager.isStarPrinterConnected
        {
            let str_footerText = receiptModel.card_agreement_text + "<br>" + receiptModel.refund_policy_text + "<br>" + receiptModel.footer_text
            
            var add = ""
            if self.receiptModel.city == "" && self.receiptModel.region == "" && self.receiptModel.postal_code == "" {
                add = ""
            } else if self.receiptModel.city != "" && (self.receiptModel.region != "" || self.receiptModel.postal_code != "") {
                add = ","
            } else if self.receiptModel.city == "" && (self.receiptModel.region != "" || self.receiptModel.postal_code != ""){
                add = ""
            }
            
            let order: JSONDictionary = ["title" : self.receiptModel.packing_slip_title ,
                                         "address" : "\(self.receiptModel.address_line1)\n\(self.receiptModel.address1)\n\(self.receiptModel.address2)" ,
                "addressDetail" : "\(self.receiptModel.city)\(add)\(self.receiptModel.region) \(self.receiptModel.postal_code)",
                "date" : self.receiptModel.date_added ,
                "orderid": self.receiptModel.order_id ,
                "products" : self.receiptModel.array_ReceiptContent ,
                "total" : self.receiptModel.total ,
                "tip" : self.receiptModel.tip ,
                "subtotal" : self.receiptModel.sub_total ,
                "discount" : self.receiptModel.discount ,
                "shipping" : self.receiptModel.shipping ,
                "tax" : self.receiptModel.tax ,
                "footertext" : str_footerText ,
                "card_agreement_text" : receiptModel.card_agreement_text,
                "refund_policy_text" : receiptModel.refund_policy_text,
                "footer_text" : receiptModel.footer_text,
                "transactiontype" : self.receiptModel.transaction_type,
                "paymentmode" : self.receiptModel.payment_type,
                "order_time" : self.receiptModel.order_time,
                "sale_location" : self.receiptModel.sale_location,
                "bar_code" : self.receiptModel.bar_code,
                "card_details" : self.receiptModel.array_ReceiptCardContent,
                "entry_method" : self.receiptModel.entry_method,
                "card_number" : self.receiptModel.card_number,
                "approval_code" : self.receiptModel.approval_code,
                "coupon_code" : self.receiptModel.coupon_code,
                "change_due" : self.receiptModel.change_due,
                "signature" : self.receiptModel.signature,
                "card_holder_name" : self.receiptModel.card_holder_name,
                "card_holder_label" : self.receiptModel.card_holder_label,
                "company_name" : self.receiptModel.company_name,
                "city" : self.receiptModel.city,
                "region" :self.receiptModel.region,
                "customer_service_phone" :self.receiptModel.customer_service_phone,
                "customer_service_email" :self.receiptModel.customer_service_email,
                "postal_code" :self.receiptModel.postal_code,
                "header_text" :self.receiptModel.header_text,
                "balance_due" :self.receiptModel.balance_Due,
                "payment_status" :self.receiptModel.payment_status,
                "source" :self.receiptModel.source,
                "show_company_address" : self.receiptModel.show_company_address,
                "show_all_final_transactions" :self.receiptModel.show_all_final_transactions,
                "print_all_transactions" :self.receiptModel.print_all_transactions,
                "extra_merchant_copy" :self.receiptModel.extra_merchant_copy,
                "showtipline_status" : self.receiptModel.showtipline_status,
                "total_refund_amount" : self.receiptModel.total_refund_amount,
                "notes" : self.receiptModel.notes,
                "isNotes" : self.receiptModel.isNotes,
                "lowvaluesig_status" : self.receiptModel.lowvaluesig_status,
                "qr_code_data":self.receiptModel.qr_code_data,
                "qr_code": self.receiptModel.qr_code,
                "hide_qr_code":self.receiptModel.hide_qr_code
            ]
            
            
            BluetoothPrinter.sharedInstance.printContent(dict:order)
            
        }
        else if DataManager.isStarPrinterConnected
        {
        //            self.showAlert(message: "No Printer Found.")
                  //  {
                     //   {
//                            let commands: Data
//                            
//                            let emulation: StarIoExtEmulation = LoadStarPrinter.getEmulation()
//                            print(emulation)
//                            
//                            let width: Int = LoadStarPrinter.getSelectedPaperSize().rawValue
//                            
//                            let paperSize: PaperSizeIndex = LoadStarPrinter.getSelectedPaperSize()
//                            let language: LanguageIndex = LanguageIndex.english//LoadStarPrinter.getSelectedLanguage()
//                            let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(language,
//                                                                                                              paperSizeIndex: paperSize)
//                            commands = PrinterFunctions.createTextReceiptApiData(emulation,utf8: true)
//                            
//                            //self.blind = true
//                            
//                  //  if #available(iOS 13.0, *) {
//                        Communication.sendCommandsForPrintReDirection(commands,
//                                                                      timeout: 10000) { (communicationResultArray) in
//                                                                       // self.blind = false
//                                                                        
//                                                                        var message: String = ""
//                                                                        
//                                                                        for i in 0..<communicationResultArray.count {
//                                                                            if i == 0 {
//                                                                                message += "[Destination]\n"
//                                                                            }
//                                                                            else {
//                                                                                message += "[Backup]\n"
//                                                                            }
//                                                                            
//                                                                            message += "Port Name: " + communicationResultArray[i].0 + "\n"
//                                                                            
//                                                                            switch communicationResultArray[i].1.result {
//                                                                            case .success:
//                                                                                message += "----> Success!\n\n";
//                                                                            case .errorOpenPort:
//                                                                                message += "----> Fail to openPort\n\n";
//                                                                            case .errorBeginCheckedBlock:
//                                                                                message += "----> Printer is offline (beginCheckedBlock)\n\n";
//                                                                            case .errorEndCheckedBlock:
//                                                                                message += "----> Printer is offline (endCheckedBlock)\n\n";
//                                                                            case .errorReadPort:
//                                                                                message += "----> Read port error (readPort)\n\n";
//                                                                            case .errorWritePort:
//                                                                                message += "----> Write port error (writePort)\n\n";
//                                                                            default:
//                                                                                message += "----> Unknown error\n\n";
//                                                                            }
//                                                                        }
//                                                                        
//                                                                        
//                                                                        
//                                                                        //                                                                    self.showSimpleAlert(title: "Communication Result",
//                                                                        //                                                                                         message: message,
//                                                                        //                                                                                         buttonTitle: "OK",
//                                                                        //                                                                                         buttonStyle: .cancel)
//                                                                        appDelegate.showToast(message: message)
//                        }
//            
//            if  HomeVM.shared.receiptModel.extra_merchant_copy == "true" {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    let commands: Data
//                    
//                    let emulation: StarIoExtEmulation = LoadStarPrinter.getEmulation()
//                    print(emulation)
//                    
//                    let width: Int = LoadStarPrinter.getSelectedPaperSize().rawValue
//                    
//                    let paperSize: PaperSizeIndex = LoadStarPrinter.getSelectedPaperSize()
//                    let language: LanguageIndex = LanguageIndex.english//LoadStarPrinter.getSelectedLanguage()
//                    let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(language,
//                                                                                                      paperSizeIndex: paperSize)
//                    commands = PrinterFunctions.createTextReceiptApiData(emulation,utf8: true)
//                    
//                    //self.blind = true
//                    
//                    //  if #available(iOS 13.0, *) {
//                    Communication.sendCommandsForPrintReDirection(commands,
//                                                                  timeout: 10000) { (communicationResultArray) in
//                                                                    // self.blind = false
//                                                                    
//                                                                    var message: String = ""
//                                                                    
//                                                                    for i in 0..<communicationResultArray.count {
//                                                                        if i == 0 {
//                                                                            message += "[Destination]\n"
//                                                                        }
//                                                                        else {
//                                                                            message += "[Backup]\n"
//                                                                        }
//                                                                        
//                                                                        message += "Port Name: " + communicationResultArray[i].0 + "\n"
//                                                                        
//                                                                        switch communicationResultArray[i].1.result {
//                                                                        case .success:
//                                                                            message += "----> Success!\n\n";
//                                                                        case .errorOpenPort:
//                                                                            message += "----> Fail to openPort\n\n";
//                                                                        case .errorBeginCheckedBlock:
//                                                                            message += "----> Printer is offline (beginCheckedBlock)\n\n";
//                                                                        case .errorEndCheckedBlock:
//                                                                            message += "----> Printer is offline (endCheckedBlock)\n\n";
//                                                                        case .errorReadPort:
//                                                                            message += "----> Read port error (readPort)\n\n";
//                                                                        case .errorWritePort:
//                                                                            message += "----> Write port error (writePort)\n\n";
//                                                                        default:
//                                                                            message += "----> Unknown error\n\n";
//                                                                        }
//                                                                    }
//                                                                    
//                                                                    
//                                                                    
//                                                                    //                                                                    self.showSimpleAlert(title: "Communication Result",
//                                                                    //                                                                                         message: message,
//                                                                    //                                                                                         buttonTitle: "OK",
//                                                                    //                                                                                         buttonStyle: .cancel)
//                                                                    appDelegate.showToast(message: message)
//                    }
//                }
//            }
//        //            } else {
//        //                // Fallback on earlier versions
//        //                 appDelegate.showToast(message: "#available(iOS 13.0, *)")
//        //            }
//                      //  }
//                   // }
                    //appDelegate.showToast(message: "No Printer Found.")
        } else {
            appDelegate.showToast(message: "No Printer Found.")
        }
    }
    
    private func setColor(type: SelectedButonType) {
        switch type {
        case .email:
            self.emailButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            self.printButton.backgroundColor = UIColor.white
            self.textButton.backgroundColor = UIColor.white
            
            self.emailButton.setTitleColor(UIColor.white, for: .normal)
            self.printButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
            self.textButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
            break
            
        case .text:
            self.textButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            self.printButton.backgroundColor = UIColor.white
            self.emailButton.backgroundColor = UIColor.white
            
            self.emailButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
            self.printButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
            self.textButton.setTitleColor(UIColor.white, for: .normal)
            break
            
        case .other:
            self.printButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            self.emailButton.backgroundColor = UIColor.white
            self.textButton.backgroundColor = UIColor.white
            
            self.printButton.setTitleColor(UIColor.white, for: .normal)
            self.emailButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
            self.textButton.setTitleColor(UIColor.HieCORColor.gray.colorWith(alpha: 1.0), for: .normal)
            break
        }
    }
    
    private func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        }, completion: nil)
    }
    
    private func prepareToSendEmailOrText()
    {
        //Validate Data
        if isReceiptEmail {
            tf_PhoneNumber.setBorder()
            
            if tf_PhoneNumber.isEmpty
            {
                tf_PhoneNumber.setCustomError(text: "Please enter Email.", bottomSpace: 2)
                return
            }
            
            if !tf_PhoneNumber.isValidEmail()
            {
                tf_PhoneNumber.setCustomError(text: "Please enter valid Email.", bottomSpace: 2)
                return
            }
        }
        
        if isReceiptText {
            tf_PhoneNumber.setBorder()
            if tf_PhoneNumber.text == ""
            {
                tf_PhoneNumber.setCustomError(text: "Please enter Phone Number.", bottomSpace: 2)
                return
            }
            
            tf_PhoneNumber.text = phoneNumberFormateRemoveText(number: tf_PhoneNumber.text!)
            
            if !tf_PhoneNumber.validatePhoneNumber()
            {
                tf_PhoneNumber.setCustomError(text: "Please enter valid Phone Number.", bottomSpace: 2)
                return
            }
        }
        
        var stringURL = String()
        
        var parameters: Parameters = [
            "order_id":orderID,
        ]
        if isReceiptEmail
        {
            stringURL = String(format: "%@%@",BaseURL, kSendEmail)
            parameters["email"] = tf_PhoneNumber.text!
        }
        else
        {
            stringURL = String(format: "%@%@",BaseURL, kSendText)
            parameters["phone"] = tf_PhoneNumber.text!
            tf_PhoneNumber.text = formattedPhoneNumber(number: tf_PhoneNumber.text!)
        }
        
        //Call API
        callAPItoSendEmailOrMessage(url: stringURL, parameters: parameters)
    }
    //MARK: IBAction
    @IBAction func printButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        tf_PhoneNumber.resetCustomError(isAddAgain: true)
        
        if lbl_ReceiptTypeTitle.text == "Enter Email Address" {
            setColor(type: .email)
        } else {
            setColor(type: .text)
        }
        
        if !DataManager.isBluetoothPrinter && !DataManager.isGooglePrinter {
//            self.showAlert(message: "Please first enable the printer from settings")
            appDelegate.showToast(message: "Please first enable the printer from settings")
            return
        }
        
        if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter{
            
            //let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            self.callAPItoGetReceiptContent()
        }
        
//        if DataManager.isGooglePrinter {
//            let Url = strGooglePrinterURL
//            //let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//            if let url:NSURL = NSURL(string: Url) {
//                UIApplication.shared.open(url as URL)
//            }
//        }
        
        //        if !DataManager.printers {
        //            self.showAlert(message: "Please first enable the printer from settings")
        //            return
        //        }
        //
        //        callAPItoGetReceiptContent()
        //tf_PhoneNumber.text = ""
    }
    
    @IBAction func emailButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        tf_PhoneNumber.resetCustomError(isAddAgain: true)
        tf_PhoneNumber.text = userEmail
        setColor(type: .email)
        tf_PhoneNumber.setBorder()
        isReceiptEmail = true
        isReceiptText = false
        tf_PhoneNumber.placeholder = "Email"
        lbl_ReceiptTypeTitle.text = "Enter Email Address"
        img_ReceiptType.image = UIImage(named: "recepit-email")
        tf_PhoneNumber.keyboardType = .emailAddress
        //tf_PhoneNumber.text = ""
        callValidateToChangeColor()
    }
    
    @IBAction func textButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        tf_PhoneNumber.resetCustomError(isAddAgain: true)
        tf_PhoneNumber.text = formattedPhoneNumber(number: userPhone)
        setColor(type: .text)
        tf_PhoneNumber.setBorder()
        isReceiptEmail = false
        isReceiptText = true
        tf_PhoneNumber.placeholder = "Phone Number"
        lbl_ReceiptTypeTitle.text = "Enter Phone Number"
        img_ReceiptType.image = UIImage(named: "receipt-phone")
        tf_PhoneNumber.keyboardType = .asciiCapableNumberPad
        // tf_PhoneNumber.text = ""
        callValidateToChangeColor()
    }
    
    @IBAction func btn_SendAction(_ sender: UIButton) {
        var isGreen = false
        if sender.backgroundColor == #colorLiteral(red: 0, green: 0.6662763357, blue: 0.1810612977, alpha: 1){
            isGreen = true
        }
        sender.backgroundColor =  isGreen ? #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1) : #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor =  isGreen ? #colorLiteral(red: 0, green: 0.6662763357, blue: 0.1810612977, alpha: 1) : #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        tf_PhoneNumber.resignFirstResponder()
        self.prepareToSendEmailOrText()
    }
    
    @IBAction func btn_DoneAction(_ sender: UIButton)
    {
        sender.backgroundColor = #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_BackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func callValidateToChangeColor() {
        if tf_PhoneNumber.text != "" {
            if isReceiptText {
                btnSend.backgroundColor = #colorLiteral(red: 0, green: 0.6662763357, blue: 0.1810612977, alpha: 1)
            }
            if isReceiptEmail{
                if !tf_PhoneNumber.isValidEmail()
                {
                    //tf_PhoneNumber.setCustomError(text: "Please enter valid Email.", bottomSpace: 2)
                    return
                }
                btnSend.backgroundColor = #colorLiteral(red: 0, green: 0.6662763357, blue: 0.1810612977, alpha: 1)
            }
        }else{
            if isReceiptEmail || isReceiptText {
                btnSend.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
            }
        }
    }
    
}

//MARK: UITextFieldDelegate
extension ReceiptViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError(isAddAgain: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.textInputMode?.primaryLanguage == "emoji" || textField.textInputMode?.primaryLanguage == nil {
            return false
        }
        if range.location == 0 && string == " " {
            return false
        }
        
        if isReceiptText {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            textField.text = formattedPhoneNumber(number: newString)
            callValidateToChangeColor()
            return false
        }
        
        if isReceiptText {
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            callValidateToChangeColor()
            return string == filtered
        }
        
        if isReceiptEmail{
            callValidateToChangeColor()
        }
        
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        callValidateToChangeColor()
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        callValidateToChangeColor()
        textField.resignFirstResponder()
    }
}

//MARK: API Methods
extension ReceiptViewController {
    
    func callAPItoGetReceiptContent()
    {
        if orderID == "" {
            return
        }
        //Call API
        HomeVM.shared.getReceiptContent(orderID: orderID, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.receiptModel = HomeVM.shared.receiptModel
                self.printData()
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func callAPItoSendEmailOrMessage(url: String, parameters: JSONDictionary)
    {
        OrderVM.shared.sendEmailOrText(url: url, parameters: parameters, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.setView(view: self.view_Done, hidden: false)
                if self.isReceiptText {
                    self.lbl_DoneTitle.text = "Message Sent."
                    UIView.animate(withDuration: 2.0, delay: 0, options: .curveLinear, animations: {() -> Void in
                        self.img_Done.transform = CGAffineTransform(scaleX : 1.5, y: 1.5)
                    }, completion: {(_ finished: Bool) -> Void in
                        UIView.animate(withDuration: 2.0, animations: {() -> Void in
                            self.img_Done.transform = CGAffineTransform(scaleX: 1, y: 1)
                        })
                    })
                }
                else if(self.isReceiptEmail)
                {
                    self.lbl_DoneTitle.text = "Mail Sent."
                    UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {() -> Void in
                        self.img_Done.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }, completion: {(_ finished: Bool) -> Void in
                        UIView.animate(withDuration: 1.0, animations: {() -> Void in
                            self.img_Done.transform = CGAffineTransform(scaleX: 1, y: 1)
                        })
                    })
                }
            }else {
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

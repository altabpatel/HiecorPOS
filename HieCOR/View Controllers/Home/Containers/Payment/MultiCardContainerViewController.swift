//
//  MultiCardContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import IQKeyboardManagerSwift

struct CustomError {
    var index: Int!
    var message: String!
}

class MultiCardContainerViewController: BaseViewController, ClassBVCDelegate {
    
    //MARK: IBOutlet
    @IBOutlet weak var lbl_AmountRemaining: UILabel!
    @IBOutlet var paymnetsModeTable: UITableView!
    @IBOutlet weak var lbl_ChangeDue: UILabel!
    
    @IBOutlet weak var multicardHeightConstraint: NSLayoutConstraint!
    @IBOutlet var plusButton: UIButton!
    
    
    //MARK: Variables
    var tableData = [[String:AnyObject]]()
    var populatedData = [[String:AnyObject]]()
    var totalAmount: Double = 0.0
    var multicardAmount: Double = 0.0
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var paymentModeViewDelegate: MultiCardContainerViewControllerDelegate?
    var creditCardDataShow : creditInfoDelegate?
    var customError = [CustomError]()
    var filledCellIndex = [Int]()
    var recentAmount = Double()
    var tipAmount = Double()
    var tipPaxAmount = Double()
    var grandTotalAmount = Double()
    var selectedYear = String()
    var customerData = CustomerListModel()
    var isCardNumberReceived = false
    static var isClassLoaded = false
    var paxArray = [String]()
    var isPaymentDataContainAPIResponse = false
    var isinternalGift = false
    var TempAmount = 0.0
    var intCardIndex = Int()
    var deviceNameFlag = false
    var isCashOn = true
    var ChangeDueAmount = 0.0
    var strMonth = ""
    var strYear = ""
    var voidTransaction = VoidTransactionDataModel()
    
    
    //MARK: Private Variables
    private var ACCEPTABLE_CHARACTERS = "0123456789"
    private var MM_Array = [String]()
    private var YY_Array = [String]()
    private var array_RegionsList = [RegionsListModel]()
    private var selectedIndexPath: IndexPath?
    private var dummyCardNumber = String()
    private var selectedTextField: UITextField? = nil
    private var reader: iMagRead?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Update Amount
        
        if HomeVM.shared.DueShared > 0 {
            grandTotalAmount = HomeVM.shared.DueShared
        } else {
            grandTotalAmount = totalAmount
        }
        
        TempAmount = grandTotalAmount.rounded(toPlaces: 2)
        
        
        
        // grandTotalAmount = totalAmount
        //Update Pax Type
        paxArray.removeAll()
        if UI_USER_INTERFACE_IDIOM() == .phone {
            multicardHeightConstraint.constant = 0.0
        }
        
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Update Amount
        
        lbl_ChangeDue.text = "$0.00"
        ChangeDueAmount = 0.00
        isCashOn = true
        
        if HomeVM.shared.DueShared > 0 {
            grandTotalAmount = HomeVM.shared.DueShared
        } else {
            grandTotalAmount = totalAmount
        }
        
        //TempAmount = grandTotalAmount
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            MultiCardContainerViewController.isClassLoaded = false
            multicardHeightConstraint.constant = 0.0
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.paymnetsModeTable.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.paymnetsModeTable.reloadData()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let identifier = segue.identifier
        {
            if identifier == "paymentModeMenu"
            {
                if let viewController = segue.destination as? PaymentModeMenuViewController
                {
                    viewController.delegate = self
                    viewController.isCashOn = isCashOn
                    paymentModeViewDelegate = viewController
                }
            }
        }
    }
    
    //MARK: Private Functions
    private func reloadTable() {
        self.paymnetsModeTable.reloadData {
            self.paymnetsModeTable.reloadData {
                DispatchQueue.main.async {
                    if MultiCardContainerViewController.isClassLoaded {
                        self.selectedTextField?.becomeFirstResponder()
                        self.selectedTextField?.selectAll(nil)
                    }
                    self.paymnetsModeTable.scrollToBottom()
                }
            }
        }
    }
    
    private func loadData() {
        //Reset
        PaymentModeMenuViewController.hiddenButtonstags = [Int]()
        customError.removeAll()
        filledCellIndex.removeAll()
        multicardAmount = 0
        tipAmount = 0
        tipPaxAmount = 0
        totalAmount = 0
        self.delegate?.updateTotal?(with: tipAmount)
        self.delegate?.updateTotal?(with: tipPaxAmount)
        _ = self.setTotal(amount: 0.0)
        self.resetMulticardData()
        populatedData = [["index"  : 1 as AnyObject,
                          "cellID" : "CreditCardTableViewCell" as AnyObject,
                          "ccNo"   : "" as AnyObject,
                          "ccMM"   : "" as AnyObject,
                          "ccYear" : "" as AnyObject,
                          "ccCVV"  : "" as AnyObject,
                          "amount"  : "" as AnyObject,
                          "isSwipedProperly" : true as AnyObject,
                          "bp_id" : "" as AnyObject,
                          "tip" : "" as AnyObject,
                          "digital_signature" : "" as AnyObject],
                         
                         ["index":2 as AnyObject,
                          "cellID" : "CashTableViewCell" as AnyObject,
                          "amount" : "" as AnyObject],
                         
                         ["index":3 as AnyObject,
                          "cellID" : "CheckTableViewCell" as AnyObject,
                          "chNo" : "" as AnyObject,
                          "amount" : "" as AnyObject],
                         
                         ["index":4 as AnyObject,
                          "cellID" : "ExternalTableViewCell" as AnyObject,
                          "amount" : "" as AnyObject],
                         
                         ["index":5 as AnyObject,
                          "cellID" : "ExternalGiftCardTableViewCell" as AnyObject,
                          "amount" : "" as AnyObject,
                          "isSwipedProperly" : true as AnyObject,
                          "ccNo" : "" as AnyObject],
                         
                         ["index":6 as AnyObject,
                          "cellID" : "GiftCardTableViewCell" as AnyObject,
                          "amount" : "" as AnyObject,
                          "ccNo" : "" as AnyObject,
                          "isSwipedProperly" : true as AnyObject,
                          "gcpin" : "" as AnyObject],
                         
                         ["index":7 as AnyObject,
                          "cellID" : "ACHCheckTableViewCell" as AnyObject,
                          "name" : "" as AnyObject,
                          "phone" : "" as AnyObject,
                          "address" : "" as AnyObject,
                          "amount" : "" as AnyObject,
                          "achRoutNo" : "" as AnyObject,
                          "achACNo" : "" as AnyObject,
                          "achDlNo" : "" as AnyObject,
                          "achDlState" : "" as AnyObject],
                         
                         ["index":8 as AnyObject,
                          "cellID" : "PaxTableViewCell" as AnyObject,
                          "amount" : "" as AnyObject,
                          "paymentMode" : "" as AnyObject,
                          "device" : "" as AnyObject,
                          "url" : "" as AnyObject,
                          "tip" : "" as AnyObject,
                          "digital_signature" : "" as AnyObject,
                          "paxNumber": "" as AnyObject],
            
                         
                         ["index":9 as AnyObject,
                          "cellID" : "InternalGiftCardTableViewCell" as AnyObject,
                          "amount" : "" as AnyObject,
                          "isSwipedProperly" : true as AnyObject,
                          "ccNo" : "" as AnyObject]]
        
        self.upadateMonthArray()
        paymnetsModeTable.estimatedRowHeight = 100.0
        paymnetsModeTable.rowHeight = UITableViewAutomaticDimension
        //Update Previous Data If Available
        self.loadPreviousData()
    }
    
    private func voidTransaction(index: Int, sender:UIButton) {
        
        let txnID = tableData[index]["txnID"]  as? String ?? ""
        //let orderID = tableData[index]["orderID"] as? Int ?? 0
        let userID = tableData[index]["userID"] as? String ?? ""
        //let amount = tableData[index]["amount"] as? String ?? ""
        //let type = tableData[index]["type"] as? String ?? ""
        
        let parameters:JSONDictionary = [
            "txn_id": txnID,
            "custID": userID
        ]
        self.callAPItoVoidTransaction(paramneters: parameters,index: index, sender: sender)
    }
    
    private func loadPreviousData() {
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key.lowercased() == "multi card" {
            if let data = PaymentsViewController.paymentDetailDict["data"] as? [[String:AnyObject]] {
                self.tableData = data
                
                var total = Double()
                for dict in tableData {
                    if let amount = dict["amount"] as? String {
                        total += (Double(amount) ?? 0.0)
                    }
                }
                
                let newAmt = grandTotalAmount - total
                self.totalAmount = newAmt > 0 ? newAmt : 0
                
                if newAmt < 0 {
                    var remainingAmt = -(newAmt)
                    for i in stride(from: (tableData.count - 1), through: 0, by: -1) {
                        if let amount = tableData[i]["amount"] as? String {
                            let amt = Double(amount) ?? 0.0
                            
                            if amt >= remainingAmt {
                                tableData[i]["amount"] = (amt - remainingAmt).roundToTwoDecimal as AnyObject
                                break
                            }else {
                                tableData[i]["amount"] = "\(0.00)" as AnyObject
                                remainingAmt -= amt
                            }
                        }
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.updateTipTotal()
                }
                _ = setTotal(amount: 0)
            }
        }
    }
    
    private func resetMulticardData() {
        if let sectionArray = DataManager.selectedPayment {
            if !sectionArray.contains("CREDIT") {
                totalAmount = grandTotalAmount
                _ = self.setTotal(amount: 0.0)
                selectedIndexPath = nil
                return
            }
        }
        
        self.selectedIndexPath = IndexPath(row: 0, section: 0)
        
        var dict = ["index"  : 1 as AnyObject,
                    "cellID" : "CreditCardTableViewCell" as AnyObject,
                    "ccNo"   : "" as AnyObject,
                    "ccMM"   : "" as AnyObject,
                    "ccYear" : "" as AnyObject,
                    "ccCVV"  : "" as AnyObject,
                    "amount"  : "" as AnyObject,
                    "isSwipedProperly" : true as AnyObject,
                    "bp_id" : "" as AnyObject,
                    "tip" : "" as AnyObject,
                    "digital_signature" : "" as AnyObject]
        dict["amount"] = TempAmount.roundToTwoDecimal as AnyObject
        self.tableData = [dict]
        
    }
    
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
    
    private func validateData()-> Bool {
        for i in 0..<tableData.count {
            let dict = tableData[i]
            let index = dict["index"] as? Int ?? 0
            let isApproved = dict["isApproved"] as? Bool ?? false
            
            switch index {
            case 1:
                let cardNumber = dict["ccNo"] as? String ?? ""
                let month = dict["ccMM"] as? String ?? ""
                let year = dict["ccYear"] as? String ?? ""
                let cvv = dict["ccCVV"] as? String ?? ""
                let amount = dict["amount"] as? String ?? ""
                let tip = dict["tip"] as? String ?? ""
                let bpId = dict["bp_id"] as? String ?? ""
                
                if cardNumber == "" {
                    updateError(index: i, message: "Please enter Card number.")
                    return false
                }
                
                if cardNumber.count < 12 {
                    updateError(index: i, message: "Enter valid Credit Card number.")
                    return false
                }
                
                if month == "" {
                    updateError(index: i, message: "Please select Month.")
                    return false
                }
                if year == "" {
                    updateError(index: i, message: "Please select Year.")
                    return false
                }
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                    return false
                }
                
                break
                
            case 2:
                let cash = dict["amount"] as? String ?? ""
                
                if cash == "" {
                    updateError(index: i, message: "Please enter Amount.")
                    return false
                }
                
                break
                
            case 3:
                let number = dict["chNo"] as? String ?? ""
                let amount = dict["amount"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Check Amount.")
                    return false
                }
                
                if number == "" {
                    updateError(index: i, message: "Please enter Check Number.")
                    return false
                }
                
                
                break
                
            case 4:
                let amount = dict["amount"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter External Amount.")
                    return false
                }
                
                
                break
                
            case 5:
                let number = dict["ccNo"] as? String ?? ""
                let amount = dict["amount"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                    return false
                }
                
                if number == "" {
                    updateError(index: i, message: "Please enter Gift Card Number.")
                    return false
                }
                
                break
                
            case 6:
                let number = dict["ccNo"] as? String ?? ""
                let pin = dict["gcpin"] as? String ?? ""
                let amount = dict["amount"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                    return false
                }
                
                if number == "" {
                    updateError(index: i, message: "Please enter Gift Card Number.")
                    return false
                }
                
                break
                
            case 7:
                let amount = dict["amount"] as? String ?? ""
                let routeNumber = dict["achRoutNo"] as? String ?? ""
                let accountNumber = dict["achACNo"] as? String ?? ""
                let dlNumber = dict["achDlNo"] as? String ?? ""
                let dlState = dict["achDlState"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                    return false
                }
                
                if routeNumber == "" {
                    updateError(index: i, message: "Please enter Routing Number.")
                    return false
                }
                
                if accountNumber == "" {
                    updateError(index: i, message: "Please enter Account Number.")
                    return false
                }
                
                if dlNumber == "" {
                    updateError(index: i, message: "Please enter DL Number.")
                    return false
                }
                
                if dlState == "" {
                    updateError(index: i, message: "Please select DL State.")
                    return false
                }
                
                break
                
            case 8:
                let amount = dict["amount"] as? String ?? ""
                let device = dict["device"] as? String ?? ""
                let url = dict["url"] as? String ?? ""
                let paymentMode = dict["paymentMode"] as? String ?? ""
                let tip = dict["tip"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                    return false
                }
                
                if device == "" {
                    updateError(index: i, message: "Please select Device.")
                    return false
                }
                
                break
                
            case 9:
                let number = dict["ccNo"] as? String ?? ""
                let amount = dict["amount"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                    return false
                }
                
                if number == "" {
                    updateError(index: i, message: "Please enter Gift Card Number.")
                    return false
                }
                
                
                break
                
            default: break
            }
            
        }
        return true
    }
    
    private func getDataForAPI() -> JSONDictionary {
        
        self.updateTipTotal()
        //Parameters Array
        var creditCardArray = JSONArray()
        var cashArray = JSONArray()
        var checkArray = JSONArray()
        var externalArray = JSONArray()
        var externalGiftCardArray = JSONArray()
        var internalGiftCardArray = JSONArray()
        var giftCardArray = JSONArray()
        var achCheckArray = JSONArray()
        var paxArray = JSONArray()
        //
        customError.removeAll()
        filledCellIndex.removeAll()
        multicardAmount = 0
        
        for i in 0..<tableData.count {
            let dict = tableData[i]
            let index = dict["index"] as? Int ?? 0
            let isApproved = dict["isApproved"] as? Bool ?? false
            
            switch index {
            case 1:
                let cardNumber = dict["ccNo"] as? String ?? ""
                let month = dict["ccMM"] as? String ?? ""
                let year = dict["ccYear"] as? String ?? ""
                let cvv = dict["ccCVV"] as? String ?? ""
                let amount = dict["amount"] as? String ?? ""
                var tip = dict["tip"] as? String ?? ""
                let bpId = dict["bp_id"] as? String ?? ""
                
                if let data =  DataManager.arrTempListing {
                    for i in 0..<data.count {
                        let arrsign = data[i]
                        let tipVal = arrsign["tip"] as? String
                        let cardNumberVal = arrsign["card_number"] as? String
                        let card = cardNumberVal?.suffix(4)
                        if cardNumber.suffix(4) == card {
                            tip = tipVal ?? "0.00"
                        }
                    }
                }
                
                
                if cardNumber == "" {
                    updateError(index: i, message: "Please enter Card number.")
                    //return nil
                }
                
                if cardNumber.count < 12 {
                    updateError(index: i, message: "Enter valid Credit Card number.")
                }
                
                if month == "" {
                    updateError(index: i, message: "Please select Month.")
                }
                if year == "" {
                    updateError(index: i, message: "Please select Year.")
                }
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                }
                
                if !cardNumber.isEmpty && !month.isEmpty && !year.isEmpty && !amount.isEmpty && (cardNumber.count > 11) {
                    filledCellIndex.append(i)
                }
                
                let dict: JSONDictionary = [
                    "cc_account": cardNumber,
                    "cc_exp_mo": month,
                    "cc_exp_yr": year,
                    "cc_cvv": cvv,
                    "tip": tip,
                    "amount": amount,
                    "status": "",
                    "s_no": i + 1,
                    "message": "",
                    "bp_id" : bpId,
                    "partially_approved_amount": 0,
                    "digital_signature" : ""
                ]
                
                multicardAmount = multicardAmount + (Double(amount) ?? 0.0)
                
                if !isApproved {
                    creditCardArray.append(dict)
                }
                break
                
            case 2:
                let cash = dict["amount"] as? String ?? ""
                
                if cash == "" {
                    updateError(index: i, message: "Please enter Amount.")
                }
                
                let dict: JSONDictionary = [
                    "amount": cash,
                    "status": "",
                    "s_no": i + 1,
                    "message": ""
                ]
                
                if !cash.isEmpty {
                    filledCellIndex.append(i)
                }
                
                multicardAmount = multicardAmount + (Double(cash) ?? 0.0)
                
                if !isApproved {
                    cashArray.append(dict)
                }
                break
                
            case 3:
                let number = dict["chNo"] as? String ?? ""
                let amount = dict["amount"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Check Amount.")
                }
                
                if number == "" {
                    updateError(index: i, message: "Please enter Check Number.")
                }
                
                if !amount.isEmpty && !number.isEmpty {
                    filledCellIndex.append(i)
                }
                
                let dict: JSONDictionary = [
                    "amount": amount,
                    "check_number": number,
                    "status": "",
                    "s_no": i + 1,
                    "message": ""
                ]
                
                multicardAmount = multicardAmount + (Double(amount) ?? 0.0)
                if !isApproved {
                    checkArray.append(dict)
                }
                
                break
                
            case 4:
                let amount = dict["amount"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter External Amount.")
                }
                
                if !amount.isEmpty {
                    filledCellIndex.append(i)
                }
                
                let dict: JSONDictionary = [
                    "amount": amount,
                    "status": "",
                    "s_no": i + 1,
                    "message": ""
                ]
                
                multicardAmount = multicardAmount + (Double(amount) ?? 0.0)
                if !isApproved {
                    externalArray.append(dict)
                }
                
                break
                
            case 5:
                let number = dict["ccNo"] as? String ?? ""
                let amount = dict["amount"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                }
                
                if number == "" {
                    updateError(index: i, message: "Please enter Gift Card Number.")
                }
                
                if !amount.isEmpty && !number.isEmpty {
                    filledCellIndex.append(i)
                }
                
                let dict: JSONDictionary = [
                    "gift_card_number": number,
                    "amount": amount,
                    "status": "",
                    "s_no": i + 1,
                    "message": ""
                ]
                
                multicardAmount = multicardAmount + (Double(amount) ?? 0.0)
                if !isApproved {
                    externalGiftCardArray.append(dict)
                }
                
                break
                
            case 6:
                let number = dict["ccNo"] as? String ?? ""
                let pin = dict["gcpin"] as? String ?? ""
                let amount = dict["amount"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                }
                
                if number == "" {
                    updateError(index: i, message: "Please enter Gift Card Number.")
                }
                
                if !number.isEmpty && !amount.isEmpty {
                    filledCellIndex.append(i)
                }
                
                let dict: JSONDictionary = [
                    "gift_card_number": number,
                    "gift_card_pin": pin,
                    "amount": amount,
                    "status": "",
                    "s_no": i + 1,
                    "message": ""
                ]
                
                multicardAmount = multicardAmount + (Double(amount) ?? 0.0)
                if !isApproved {
                    giftCardArray.append(dict)
                }
                
                break
                
            case 7:
                let amount = dict["amount"] as? String ?? ""
                let routeNumber = dict["achRoutNo"] as? String ?? ""
                let accountNumber = dict["achACNo"] as? String ?? ""
                let dlNumber = dict["achDlNo"] as? String ?? ""
                let dlState = dict["achDlState"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                }
                
                if routeNumber == "" {
                    updateError(index: i, message: "Please enter Routing Number.")
                }
                
                if accountNumber == "" {
                    updateError(index: i, message: "Please enter Account Number.")
                }
                
                if dlNumber == "" {
                    updateError(index: i, message: "Please enter DL Number.")
                }
                
                if dlState == "" {
                    updateError(index: i, message: "Please select DL State.")
                }
                
                if !amount.isEmpty && !routeNumber.isEmpty && !accountNumber.isEmpty && !dlNumber.isEmpty && !dlState.isEmpty {
                    filledCellIndex.append(i)
                }
                
                let dict: JSONDictionary = [
                    "routing_number": routeNumber,
                    "account_number": accountNumber,
                    "dl_number": dlNumber,
                    "amount": amount,
                    "dl_state": dlState,
                    "check_type": "",
                    "sec_code": "",
                    "account_type": "",
                    "status": "",
                    "s_no": i + 1,
                    "message": "",
                    "name": "",
                    "phone": "",
                    "address": ""
                ]
                
                multicardAmount = multicardAmount + (Double(amount) ?? 0.0)
                if !isApproved {
                    achCheckArray.append(dict)
                }
                
                break
                
            case 8:
                let amount = dict["amount"] as? String ?? ""
                let device = dict["device"] as? String ?? ""
                let url = dict["url"] as? String ?? ""
                let paymentMode = dict["paymentMode"] as? String ?? ""
                let tip = dict["tip"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                }
                
                if device == "" {
                    updateError(index: i, message: "Please select Device.")
                }
                
                if !amount.isEmpty && !device.isEmpty {
                    filledCellIndex.append(i)
                }
                
                let dict: JSONDictionary = [
                    "amount": amount,
                    "device_name": device,
                    "pax_payment_type": paymentMode,
                    "pax_port": url,
                    "status": "",
                    "s_no": i + 1,
                    "message": "",
                    "pax_pay_receipt" : DataManager.isSingatureOnEMV,
                    "tip" : tip,
                    "digital_signature" : "",
                    "paxNumber" : ""
                ]
                
                multicardAmount = multicardAmount + (Double(amount) ?? 0.0)
                if !isApproved {
                    paxArray.append(dict)
                }
                
                break
                
            case 9:
                let number = dict["ccNo"] as? String ?? ""
                let amount = dict["amount"] as? String ?? ""
                
                if amount == "" {
                    updateError(index: i, message: "Please enter Amount.")
                }
                
                if number == "" {
                    updateError(index: i, message: "Please enter Gift Card Number.")
                }
                
                if !amount.isEmpty && !number.isEmpty {
                    filledCellIndex.append(i)
                }
                
                let dict: JSONDictionary = [
                    "gift_card_number": number,
                    "amount": amount,
                    "status": "",
                    "s_no": i + 1,
                    "message": ""
                ]
                
                multicardAmount = multicardAmount + (Double(amount) ?? 0.0)
                if !isApproved {
                    internalGiftCardArray.append(dict)
                }
                
                break
                
            default: break
            }
            
        }
        
        DispatchQueue.main.async {
            self.paymnetsModeTable.reloadData()
        }
        
        //Parameter Dict
        var parametersDict = JSONDictionary()
        
        if creditCardArray.count > 0 {
            parametersDict["credit"] = creditCardArray
        }
        
        if cashArray.count > 0 {
            parametersDict["cash"] = cashArray
        }
        
        if paxArray.count > 0 {
            parametersDict["pax_pay"] = paxArray
        }
        
        if achCheckArray.count > 0 {
            parametersDict["ach_check"] = achCheckArray
        }
        
        if giftCardArray.count > 0 {
            parametersDict["gift_card"] = giftCardArray
        }
        
        if externalArray.count > 0 {
            parametersDict["external"] = externalArray
        }
        
        if externalGiftCardArray.count > 0 {
            parametersDict["external_gift"] = externalGiftCardArray
        }
        
        if internalGiftCardArray.count > 0 {
            parametersDict["internal_gift_card"] = internalGiftCardArray
        }
        
        if checkArray.count > 0 {
            parametersDict["check"] = checkArray
        }
        
        return ["multi_card": parametersDict, "totalAmount": multicardAmount,"tipAmount": tipAmount , "tipPaxAmount" : tipPaxAmount]
    }
    
    private func updateError(index: Int, message: String) {
        customError.append(CustomError(index: index, message: message))
        Indicator.sharedInstance.hideIndicator()
    }
    
    private func removeError(index: Int, message: String) {
        if let i = customError.index(where: {$0.message == message}) {
            customError.remove(at: i)
        }
    }
    
    private func updateTipTotal() {
        tipAmount = 0
        tipPaxAmount = 0
        for dict in tableData {
            if let tip = dict["tip"] as? String {
                tipAmount += (Double(tip) ?? 0.0)
            }
        }
        self.delegate?.updateTotal?(with: tipAmount)
    }
    
    private func setTotal(amount: Double) -> Bool {
        if amount == 0.0 {
            
            //            if HomeVM.shared.DueShared > 0 {
            //                lbl_AmountRemaining.text = "Amount Remain $\(HomeVM.shared.DueShared < 0 ? "0.00" : HomeVM.shared.DueShared.roundToTwoDecimal)"
            //                delegate?.didUpdateAmountRemaining?(amount: "$\(HomeVM.shared.DueShared < 0 ? "0.00" : HomeVM.shared.DueShared.roundToTwoDecimal)")
            //            } else {
            //lbl_AmountRemaining.text = "Amount Remain $\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)"
            lbl_AmountRemaining.text = "$\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)"
            
            delegate?.didUpdateAmountRemaining?(amount: "$\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)")
            //}
            callValidateToChangeColor()
            return false
        }
        disableValidateToChangeColor()
        totalAmount -= amount
        
        if isCashOn {
            if (round(totalAmount)) < 0 {
                totalAmount += amount
//                self.showAlert(message: "Remaining amount is less than entered amount.")
                appDelegate.showToast(message: "Remaining amount is less than entered amount.")
                lbl_AmountRemaining.text = "$\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)"
                
                //lbl_AmountRemaining.text = "Amount Remain $\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)"
                delegate?.didUpdateAmountRemaining?(amount: "$\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)")
                return true
            }
        }
        
        lbl_AmountRemaining.text = "$\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)"
        
        //lbl_AmountRemaining.text = "Amount Remain $\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)"
        delegate?.didUpdateAmountRemaining?(amount: "$\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)")
        return false
    }
    
    private func fillUserDataForACHCheck() {
        if customerData.str_first_name == "" || customerData.str_last_name == "" || customerData.str_email == "" || customerData.str_phone == "" || customerData.str_address == "" || customerData.str_postal_code == "" || customerData.str_region == "" || customerData.str_city == "" {
                    //Hiec@r
        //            self.showAlert(title: kAlert, message: "Please add customer details to make payment.", otherButtons: nil, cancelTitle: kOkay) { (action) in
                        //Save Data
                        PaymentsViewController.paymentDetailDict.removeAll()
                        PaymentsViewController.paymentDetailDict["key"] = "MULTI CARD"
                        self.saveData()
                        //Move Back
                        if UI_USER_INTERFACE_IDIOM() == .phone {
                            self.navigationController?.popToViewController((self.navigationController?.previousThirdViewController())!, animated: true)
                        }
                        self.delegate?.moveBackPage?()
                        appDelegate.showToast(message: "Please add customer details to make payment.")
        //            }
                }else {
            if !validateData() {
                DispatchQueue.main.async {
                    self.paymnetsModeTable.reloadData()
                }
                return
            }
            let data = self.getDataForAPI()
            self.delegate?.getPaymentData?(with: data)
            if UI_USER_INTERFACE_IDIOM() == .pad {
                self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
            }
        }
    }
    
    func paymentModeList(selctedIndex: Int, amountVal:Double, index:Int)
    {
        
        isinternalGift = false
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            plusButton.isSelected = false
        }
        // let amount = lbl_AmountRemaining.text!.replacingOccurrences(of: "Amount Remain $", with: "")
        var dict = populatedData[selctedIndex - 1]
        dict["amount"] = amountVal as AnyObject
        
        tableData[index]["amount"] = amountVal as AnyObject
        
        //tableData.append(dict)
        
        totalAmount = 0
        _ = self.setTotal(amount: 0.0)
        
        //Disable buttons
        if selctedIndex == 2 || selctedIndex == 4 || selctedIndex == 8 {
            paymentModeViewDelegate?.didHideButton(with: selctedIndex, isHidden: true)
        }
        
        if selctedIndex == 1 || selctedIndex == 5 || selctedIndex == 6 || selctedIndex == 9 {
            self.selectedIndexPath = IndexPath(row: self.tableData.count - 1, section: 0)
        }
        
        self.paymnetsModeTable.reloadData()
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
        //            self.reloadTable()
        //            //Check For External Accessory
        //            if Keyboard._isExternalKeyboardAttached() {
        //                self.view.endEditing(true)
        //                SwipeAndSearchVC.shared.enableTextField()
        //            }
        //        })
    }
    
    
    func deleteAfterVoidFunction(Index: Int, sender:UIButton) {
        
        self.view.endEditing(true)
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell)
        {
            superview = view.superview
        }
        
        guard let cell = superview as? UITableViewCell else
        {
            print("button is not contained in a table view cell")
            return
        }
        
        guard let indexPath = paymnetsModeTable.indexPath(for: cell) else
        {
            print("failed to get index path for cell containing button")
            return
        }
        
        print("button is in row \(indexPath.row)")
        
        let mode = tableData[indexPath.row]["index"] as? Int ?? 0
        print("Mode: \(mode)")
        
        switch mode {
        case 1:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! CreditCardTableViewCell
            let amount = Double(cell.ccAmountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            break
        case 2:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! CashTableViewCell
            let amount = Double(cell.cashAmountField.text!) ?? 0.0
            totalAmount += amount
            
            isCashOn = true
            
            _ = self.setTotal(amount: 0.0)
            //Remove from Selection
            if let index = PaymentModeMenuViewController.hiddenButtonstags.index(where: {$0 == mode}) {
                PaymentModeMenuViewController.hiddenButtonstags.remove(at: index)
            }
            break
        case 3:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! CheckTableViewCell
            let amount = Double(cell.chequeAmountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            //Remove from Selection
            if let index = PaymentModeMenuViewController.hiddenButtonstags.index(where: {$0 == mode}) {
                PaymentModeMenuViewController.hiddenButtonstags.remove(at: index)
            }
            break
        case 4:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! ExternalTableViewCell
            let amount = Double(cell.extAmount.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            //Remove from Selection
            if let index = PaymentModeMenuViewController.hiddenButtonstags.index(where: {$0 == mode}) {
                PaymentModeMenuViewController.hiddenButtonstags.remove(at: index)
            }
            break
        case 5:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! ExternalGiftCardTableViewCell
            let amount = Double(cell.amountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            break
        case 6:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! GiftCardTableViewCell
            let amount = Double(cell.amountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            break
        case 7:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! ACHCheckTableViewCell
            let amount = Double(cell.amountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            break
        case 8:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! PaxTableViewCell
            let amount = Double(cell.amountTextField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            //Remove from Selection
            if let index = PaymentModeMenuViewController.hiddenButtonstags.index(where: {$0 == mode}) {
                PaymentModeMenuViewController.hiddenButtonstags.remove(at: index)
            }
            break
        case 9:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! InternalGiftCardTableViewCell
            let amount = Double(cell.amountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            break
        default:
            break
        }
        self.tableData.remove(at: indexPath.row)
        
        if tableData.count == 0 {
            ChangeDueAmount = 0.0
            lbl_ChangeDue.text = "$0.00"
        }
        
        self.selectedIndexPath = nil
        self.filledCellIndex.removeAll()
        self.customError.removeAll()
        self.paymnetsModeTable.reloadData()
        self.updateTipTotal()
    }
    
    //MARK: IBAction
    @IBAction func addPaymentModeTapped(_ sender: UIButton)
    {
        deviceNameFlag = false
        self.view.endEditing(true)
        if let sectionArray = DataManager.selectedPayment, sectionArray.count == 1 {
            if sectionArray.contains("MULTI CARD") {
//                self.showAlert(message: "Please add payment methods for multicard from Settings.")
                appDelegate.showToast(message: "Please add payment methods for multicard from Settings.")
                return
            }
        }
        
        let amount = Double(totalAmount.roundToTwoDecimal) ?? 0
        if amount <= 0.0 {
//            let alertController = UIAlertController(title: "Alert", message: "No Pending Amount", preferredStyle:.alert)
            appDelegate.showToast(message: "No Pending Amount")
//            alertController.addAction(UIAlertAction.init(title: kOkay, style: .default, handler: { (UIAlertAction) in alertController.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alertController, animated: true, completion: nil)
            return
        }
        self.performSegue(withIdentifier: "paymentModeMenu", sender: sender)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            sender.isSelected = !sender.isSelected
        }
    }
    
    func callValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if lbl_AmountRemaining.text == "$0.00"{
                delegate?.checkPayButtonColorChange?(isCheck: true, text: "MULTI CARD")
            }else{
                delegate?.checkPayButtonColorChange?(isCheck: false, text: "MULTI CARD")
            }
        }else{
            if lbl_AmountRemaining.text == "$0.00"{
                delegate?.checkIphonePayButtonColorChange?(isCheck: true, text: "MULTI CARD")
            }else{
                delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "MULTI CARD")
            }
        }
    }
    
    func disableValidateToChangeColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            delegate?.checkPayButtonColorChange?(isCheck: false, text: "MULTI CARD")
        }else{
            delegate?.checkIphonePayButtonColorChange?(isCheck: false, text: "MULTI CARD")
        }
    }
    
}

//MARK: UITableViewDataSource
extension MultiCardContainerViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let mode = tableData[indexPath.row]["index"] as? Int ?? 0
        
        if mode == 2 {
            isCashOn = false
        }
        
        switch mode {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableData[indexPath.row]["cellID"] as! String) as! CreditCardTableViewCell
            cell.load()
            cell.ccAmountField.delegate = self
            cell.CCNoField.delegate = self
            cell.ccExpMM.delegate = self
            cell.ccExpyear.delegate = self
            cell.ccCVV.delegate = self
            cell.ccTripAmount.delegate = self
            cell.ccAmountField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.CCNoField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.ccExpMM.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.ccExpyear.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.ccCVV.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.ccTripAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.voidButton.tag = indexPath.row
            cell.voidButton.addTarget(self, action: #selector(handleVoidButtonAction(_:)), for: .touchUpInside)
            cell.btnSavedCard.tag = indexPath.row
            cell.btnSavedCard.addTarget(self, action: #selector(handleSavedCardButtonAction(_:)), for: .touchUpInside)
            
            if DataManager.CardCount > 1 {
                cell.btnSavedCard.isHidden = false
            }
            
            //            //Fill Data
            //            if let value = tableData[indexPath.row]["ccNo"] as? String, value != "" {
            //                if value.contains("****-****-****-") {
            //                    cell.CCNoField.text = value
            //                } else if value.contains("************") {
            //                    cell.CCNoField.text = "****-****-****-\(formattedCreditCardNumber(number: value))"
            //                } else {
            //                    cell.CCNoField.text = formattedCreditCardNumber(number: value)
            //                }
            //
            //            }else {
            //                cell.CCNoField.text = ""
            //            }
            
            //Fill Data
            if let value = tableData[indexPath.row]["ccNo"] as? String, value != "" {
                if value.count == 4 {
                    cell.CCNoField.text = "************" + value
                } else {
                    cell.CCNoField.text = value
                }
                
            }else {
                cell.CCNoField.text = ""
            }
            
            if let value = tableData[indexPath.row]["ccMM"] as? String, value != "" {
                cell.ccExpMM.text = value
            }else {
                cell.ccExpMM.text = ""
            }
            
            if let value = tableData[indexPath.row]["ccYear"] as? String, value != "" {
                cell.ccExpyear.text = value
            }else {
                cell.ccExpyear.text = ""
            }
            
            if let value = tableData[indexPath.row]["ccCVV"] as? String, value != "" {
                cell.ccCVV.text = value
            }else {
                cell.ccCVV.text = ""
            }
            
            if let value = tableData[indexPath.row]["amount"] as? String, value != "" {
                cell.ccAmountField.text = value
            }else {
                cell.ccAmountField.text = ""
            }
            
            if let value = tableData[indexPath.row]["tip"] as? String, value != "" {
                cell.ccTripAmount.text = value
            }else {
                cell.ccTripAmount.text = ""
            }
            
            if (self.tableData[indexPath.row]["isSwipedProperly"] as? Bool ?? false) {
                cell.CCNoField.resetCustomError(isAddAgain: false)
            }else {
                cell.CCNoField.setCustomError()
                cell.CCNoField.text = ""
                cell.ccTripAmount.text = ""
                cell.ccCVV.text = ""
                cell.ccExpyear.text = ""
                cell.ccExpMM.text = ""
            }
            
            cell.ccRemoveBtn.addTarget(self, action: #selector(removeSelectedPayment(sender:)), for: .touchUpInside)
            //Set Shadow & Corner Radius
            cell.backView.layer.cornerRadius = 5
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.backView.layer.shadowOpacity = 0.5
            
            if let value = tableData[indexPath.row]["isApproved"] as? Bool, value == true {
                cell.voidButton.isHidden = false
                cell.CCNoField.isEnabled = false
                cell.ccExpMM.isEnabled = false
                cell.ccExpyear.isEnabled = false
                cell.ccCVV.isEnabled = false
                cell.ccAmountField.isEnabled = false
                cell.ccTripAmount.isEnabled = false
                cell.ccRemoveBtn.isEnabled = false
                cell.ccRemoveBtn.alpha = 0.5
                appDelegate.isVoidPayment = true
            }else {
                cell.voidButton.isHidden = true
                cell.CCNoField.isEnabled = true
                cell.ccExpMM.isEnabled = true
                cell.ccExpyear.isEnabled = true
                cell.ccCVV.isEnabled = true
                cell.ccAmountField.isEnabled = true
                cell.ccTripAmount.isEnabled = true
                cell.ccRemoveBtn.isEnabled = true
                cell.ccRemoveBtn.alpha = 1.0
            }
            
            if let value = tableData[indexPath.row]["errorMessage"] as? String, value != "" {
                cell.errorMessageLabel.text = value
                cell.backView.layer.shadowColor = UIColor.red.cgColor
            }else {
                let array = customError.filter({$0.index == indexPath.row})
                if array.count > 0 {
                    cell.errorMessageLabel.text = array.first?.message
                    cell.backView.layer.shadowColor = UIColor.red.cgColor
                }else {
                    cell.errorMessageLabel.text = ""
                    cell.backView.layer.shadowColor = filledCellIndex.contains(indexPath.row) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
                }
            }
            
            if indexPath.row == tableData.count - 1 && MultiCardContainerViewController.isClassLoaded {
                self.selectedTextField = cell.ccAmountField
            }
            cell.ccTripAmount.isHidden = true
            //Set Header Text
            cell.headerLabel.text = "Card #\(indexPath.row + 1)"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableData[indexPath.row]["cellID"] as! String) as! CashTableViewCell
            cell.load()
            cell.cashAmountField.delegate = self
            cell.cashAmountField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.voidButton.tag = indexPath.row
            cell.voidButton.addTarget(self, action: #selector(handleVoidButtonAction(_:)), for: .touchUpInside)
            
            //Fill Data
            if let value = tableData[indexPath.row]["amount"] as? String, value != "" {
                cell.cashAmountField.text = value
            }else {
                cell.cashAmountField.text = ""
            }
            
            cell.cashRemoveBtn.addTarget(self, action: #selector(removeSelectedPayment(sender:)), for: .touchUpInside)
            //Set Shadow & Corner Radius
            cell.backView.layer.cornerRadius = 5
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.backView.layer.shadowOpacity = 0.5
            
            if let value = tableData[indexPath.row]["isApproved"] as? Bool, value == true {
                cell.voidButton.isHidden = false
                cell.cashAmountField.isEnabled = false
                cell.cashRemoveBtn.isEnabled = false
                appDelegate.isVoidPayment = true
            }else {
                cell.voidButton.isHidden = true
                cell.cashAmountField.isEnabled = true
                cell.cashRemoveBtn.isEnabled = true
            }
            
            if let value = tableData[indexPath.row]["errorMessage"] as? String, value != "" {
                cell.errorMessageLabel.text = value
                cell.backView.layer.shadowColor = UIColor.red.cgColor
            }else {
                let array = customError.filter({$0.index == indexPath.row})
                if array.count > 0 {
                    cell.errorMessageLabel.text = array.first?.message
                    cell.backView.layer.shadowColor = UIColor.red.cgColor
                }else {
                    cell.errorMessageLabel.text = ""
                    cell.backView.layer.shadowColor = filledCellIndex.contains(indexPath.row) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
                }
            }
            
            if indexPath.row == tableData.count - 1 && MultiCardContainerViewController.isClassLoaded {
                self.selectedTextField = cell.cashAmountField
            }
            
            //Set Header Text
            cell.headerLabel.text = "Cash #\(indexPath.row + 1)"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableData[indexPath.row]["cellID"] as! String) as! CheckTableViewCell
            cell.load()
            cell.chequeNoField.delegate = self
            cell.chequeAmountField.delegate = self
            cell.chequeNoField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.chequeAmountField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.voidButton.tag = indexPath.row
            cell.voidButton.addTarget(self, action: #selector(handleVoidButtonAction(_:)), for: .touchUpInside)
            
            //Fill Data
            if let value = tableData[indexPath.row]["chNo"] as? String, value != "" {
                cell.chequeNoField.text = value
            }else {
                cell.chequeNoField.text = ""
            }
            
            if let value = tableData[indexPath.row]["amount"] as? String, value != "" {
                cell.chequeAmountField.text = value
            }else {
                cell.chequeAmountField.text = ""
            }
            
            cell.chequeRemoveBtn.addTarget(self, action: #selector(removeSelectedPayment(sender:)), for: .touchUpInside)
            //Set Shadow & Corner Radius
            cell.backView.layer.cornerRadius = 5
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.backView.layer.shadowOpacity = 0.5
            
            if let value = tableData[indexPath.row]["isApproved"] as? Bool, value == true {
                cell.voidButton.isHidden = false
                cell.chequeNoField.isEnabled = false
                cell.chequeAmountField.isEnabled = false
                cell.chequeRemoveBtn.isEnabled = false
                appDelegate.isVoidPayment = true
            }else {
                cell.voidButton.isHidden = true
                cell.chequeNoField.isEnabled = true
                cell.chequeAmountField.isEnabled = true
                cell.chequeRemoveBtn.isEnabled = true
            }
            
            if let value = tableData[indexPath.row]["errorMessage"] as? String, value != "" {
                cell.errorMessageLabel.text = value
                cell.backView.layer.shadowColor = UIColor.red.cgColor
            }else {
                let array = customError.filter({$0.index == indexPath.row})
                if array.count > 0 {
                    cell.errorMessageLabel.text = array.first?.message
                    cell.backView.layer.shadowColor = UIColor.red.cgColor
                }else {
                    cell.errorMessageLabel.text = ""
                    cell.backView.layer.shadowColor = filledCellIndex.contains(indexPath.row) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
                }
            }
            
            if indexPath.row == tableData.count - 1 && MultiCardContainerViewController.isClassLoaded {
                self.selectedTextField = cell.chequeAmountField
            }
            
            //Set Header Text
            cell.headerLabel.text = "Check #\(indexPath.row + 1)"
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableData[indexPath.row]["cellID"] as! String) as! ExternalTableViewCell
            cell.load()
            cell.extAmount.delegate = self
            cell.extAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.voidButton.tag = indexPath.row
            cell.voidButton.addTarget(self, action: #selector(handleVoidButtonAction(_:)), for: .touchUpInside)
            
            //Fill Data
            if let value = tableData[indexPath.row]["amount"] as? String, value != "" {
                cell.extAmount.text = value
            }else {
                cell.extAmount.text = ""
            }
            
            cell.extRemoveBtn.addTarget(self, action: #selector(removeSelectedPayment(sender:)), for: .touchUpInside)
            //Set Shadow & Corner Radius
            cell.backView.layer.cornerRadius = 5
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.backView.layer.shadowOpacity = 0.5
            
            if let value = tableData[indexPath.row]["isApproved"] as? Bool, value == true {
                cell.voidButton.isHidden = false
                cell.extAmount.isEnabled = false
                cell.extRemoveBtn.isEnabled = false
                appDelegate.isVoidPayment = true
            }else {
                cell.voidButton.isHidden = true
                cell.extAmount.isEnabled = true
                cell.extRemoveBtn.isEnabled = true
            }
            
            if let value = tableData[indexPath.row]["errorMessage"] as? String, value != "" {
                cell.errorMessageLabel.text = value
                cell.backView.layer.shadowColor = UIColor.red.cgColor
            }else {
                let array = customError.filter({$0.index == indexPath.row})
                if array.count > 0 {
                    cell.errorMessageLabel.text = array.first?.message
                    cell.backView.layer.shadowColor = UIColor.red.cgColor
                }else {
                    cell.errorMessageLabel.text = ""
                    cell.backView.layer.shadowColor = filledCellIndex.contains(indexPath.row) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
                }
            }
            
            if indexPath.row == tableData.count - 1 && MultiCardContainerViewController.isClassLoaded {
                self.selectedTextField = cell.extAmount
            }
            
            //Set Header Text
            cell.headerLabel.text = "External #\(indexPath.row + 1)"
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableData[indexPath.row]["cellID"] as! String) as! ExternalGiftCardTableViewCell
            cell.load()
            cell.amountField.delegate = self
            cell.giftCardNoField.delegate = self
            cell.amountField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.giftCardNoField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.voidButton.tag = indexPath.row
            cell.voidButton.addTarget(self, action: #selector(handleVoidButtonAction(_:)), for: .touchUpInside)
            
            //Fill Data
            if let value = tableData[indexPath.row]["ccNo"] as? String, value != "" {
                cell.giftCardNoField.text = value
            }else {
                cell.giftCardNoField.text = ""
            }
            
            if let value = tableData[indexPath.row]["amount"] as? String, value != "" {
                cell.amountField.text = value
            }else {
                cell.amountField.text = ""
            }
            
            if (self.tableData[indexPath.row]["isSwipedProperly"] as? Bool ?? false) {
                cell.giftCardNoField.resetCustomError(isAddAgain: false)
            }else {
                cell.giftCardNoField.setCustomError()
            }
            
            cell.giftCardRemoveBtn.addTarget(self, action: #selector(removeSelectedPayment(sender:)), for: .touchUpInside)
            //Set Shadow & Corner Radius
            cell.backView.layer.cornerRadius = 5
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.backView.layer.shadowOpacity = 0.5
            
            if let value = tableData[indexPath.row]["isApproved"] as? Bool, value == true {
                cell.voidButton.isHidden = false
                cell.giftCardNoField.isEnabled = false
                cell.amountField.isEnabled = false
                cell.giftCardRemoveBtn.isEnabled = false
                appDelegate.isVoidPayment = true
            }else {
                cell.voidButton.isHidden = true
                cell.giftCardNoField.isEnabled = true
                cell.amountField.isEnabled = true
                cell.giftCardRemoveBtn.isEnabled = true
            }
            
            if let value = tableData[indexPath.row]["errorMessage"] as? String, value != "" {
                cell.errorMessageLabel.text = value
                cell.backView.layer.shadowColor = UIColor.red.cgColor
            }else {
                let array = customError.filter({$0.index == indexPath.row})
                if array.count > 0 {
                    cell.errorMessageLabel.text = array.first?.message
                    cell.backView.layer.shadowColor = UIColor.red.cgColor
                }else {
                    cell.errorMessageLabel.text = ""
                    cell.backView.layer.shadowColor = filledCellIndex.contains(indexPath.row) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
                }
            }
            
            if indexPath.row == tableData.count - 1 && MultiCardContainerViewController.isClassLoaded {
                self.selectedTextField = cell.amountField
            }
            
            //Set Header Text
            cell.headerLabel.text = "External Gift Card #\(indexPath.row + 1)"
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableData[indexPath.row]["cellID"] as! String) as! GiftCardTableViewCell
            cell.load()
            cell.giftCardNoField.delegate = self
            cell.giftCardPinField.delegate = self
            cell.amountField.delegate = self
            cell.giftCardNoField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.giftCardPinField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.amountField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.voidButton.tag = indexPath.row
            cell.voidButton.addTarget(self, action: #selector(handleVoidButtonAction(_:)), for: .touchUpInside)
            
            //Fill Data
            if let value = tableData[indexPath.row]["ccNo"] as? String, value != "" {
                cell.giftCardNoField.text = value
            }else {
                cell.giftCardNoField.text = ""
            }
            
            if let value = tableData[indexPath.row]["gcpin"] as? String, value != "" {
                cell.giftCardPinField.text = value
            }else {
                cell.giftCardPinField.text = ""
            }
            
            if let value = tableData[indexPath.row]["amount"] as? String, value != "" {
                cell.amountField.text = value
            }else {
                cell.amountField.text = ""
            }
            
            if (self.tableData[indexPath.row]["isSwipedProperly"] as? Bool ?? false) {
                cell.giftCardNoField.resetCustomError(isAddAgain: false)
            }else {
                cell.giftCardNoField.setCustomError()
            }
            
            cell.giftCardRemoveBtn.addTarget(self, action: #selector(removeSelectedPayment(sender:)), for: .touchUpInside)
            //Set Shadow & Corner Radius
            cell.backView.layer.cornerRadius = 5
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.backView.layer.shadowOpacity = 0.5
            
            if let value = tableData[indexPath.row]["isApproved"] as? Bool, value == true {
                cell.voidButton.isHidden = false
                cell.giftCardNoField.isEnabled = false
                cell.giftCardPinField.isEnabled = false
                cell.amountField.isEnabled = false
                cell.giftCardRemoveBtn.isEnabled = false
                appDelegate.isVoidPayment = true
            }else {
                cell.voidButton.isHidden = true
                cell.giftCardNoField.isEnabled = true
                cell.giftCardPinField.isEnabled = true
                cell.amountField.isEnabled = true
                cell.giftCardRemoveBtn.isEnabled = true
            }
            
            if let value = tableData[indexPath.row]["errorMessage"] as? String, value != "" {
                cell.errorMessageLabel.text = value
                cell.backView.layer.shadowColor = UIColor.red.cgColor
            }else {
                let array = customError.filter({$0.index == indexPath.row})
                if array.count > 0 {
                    cell.errorMessageLabel.text = array.first?.message
                    cell.backView.layer.shadowColor = UIColor.red.cgColor
                }else {
                    cell.errorMessageLabel.text = ""
                    cell.backView.layer.shadowColor = filledCellIndex.contains(indexPath.row) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
                }
            }
            
            if indexPath.row == tableData.count - 1 && MultiCardContainerViewController.isClassLoaded {
                self.selectedTextField = cell.amountField
            }
            
            //Set Header Text
            cell.headerLabel.text = "Gift Card #\(indexPath.row + 1)"
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableData[indexPath.row]["cellID"] as! String) as! ACHCheckTableViewCell
            cell.load()
            cell.achRoutingNoField.delegate = self
            cell.achAccountNoField.delegate = self
            cell.achDLField.delegate = self
            cell.achSelectDLField.delegate = self
            cell.amountField.delegate = self
            cell.achRoutingNoField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.achAccountNoField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.achDLField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.achSelectDLField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.amountField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.voidButton.tag = indexPath.row
            cell.voidButton.addTarget(self, action: #selector(handleVoidButtonAction(_:)), for: .touchUpInside)
            
            //Fill Data
            if let value = tableData[indexPath.row]["achRoutNo"] as? String, value != "" {
                cell.achRoutingNoField.text = value
            }else {
                cell.achRoutingNoField.text = ""
            }
            
            if let value = tableData[indexPath.row]["achACNo"] as? String, value != "" {
                cell.achAccountNoField.text = value
            }else {
                cell.achAccountNoField.text = ""
            }
            
            if let value = tableData[indexPath.row]["achDlNo"] as? String, value != "" {
                cell.achDLField.text = value
            }else {
                cell.achDLField.text = ""
            }
            
            if let value = tableData[indexPath.row]["achDlState"] as? String, value != "" {
                cell.achSelectDLField.text = value
            }else {
                cell.achSelectDLField.text = ""
            }
            
            if let value = tableData[indexPath.row]["amount"] as? String, value != "" {
                cell.amountField.text = value
            }else {
                cell.amountField.text = ""
            }
            
            cell.achRemoveBtn.addTarget(self, action: #selector(removeSelectedPayment(sender:)), for: .touchUpInside)
            //Set Shadow & Corner Radius
            cell.backView.layer.cornerRadius = 5
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.backView.layer.shadowOpacity = 0.5
            
            if let value = tableData[indexPath.row]["isApproved"] as? Bool, value == true {
                cell.voidButton.isHidden = false
                cell.achRoutingNoField.isEnabled = false
                cell.achAccountNoField.isEnabled = false
                cell.achDLField.isEnabled = false
                cell.achSelectDLField.isEnabled = false
                cell.amountField.isEnabled = false
                cell.achRemoveBtn.isEnabled = false
                appDelegate.isVoidPayment = true
            }else {
                cell.voidButton.isHidden = true
                cell.achRoutingNoField.isEnabled = true
                cell.achAccountNoField.isEnabled = true
                cell.achDLField.isEnabled = true
                cell.achSelectDLField.isEnabled = true
                cell.amountField.isEnabled = true
                cell.achRemoveBtn.isEnabled = true
            }
            
            if let value = tableData[indexPath.row]["errorMessage"] as? String, value != "" {
                cell.errorMessageLabel.text = value
                cell.backView.layer.shadowColor = UIColor.red.cgColor
            }else {
                let array = customError.filter({$0.index == indexPath.row})
                if array.count > 0 {
                    cell.errorMessageLabel.text = array.first?.message
                    cell.backView.layer.shadowColor = UIColor.red.cgColor
                }else {
                    cell.errorMessageLabel.text = ""
                    cell.backView.layer.shadowColor = filledCellIndex.contains(indexPath.row) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
                }
            }
            
            if indexPath.row == tableData.count - 1 && MultiCardContainerViewController.isClassLoaded {
                self.selectedTextField = cell.amountField
            }
            
            //Set Header Text
            cell.headerLabel.text = "ACH Check #\(indexPath.row + 1)"
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableData[indexPath.row]["cellID"] as! String) as! PaxTableViewCell
            cell.load()
            cell.amountTextField.delegate = self
            cell.tfTipAmount.delegate = self
            cell.selectDeviceTextField.delegate = self
            cell.amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.tfTipAmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.selectDeviceTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.voidButton.tag = indexPath.row
            cell.voidButton.addTarget(self, action: #selector(handleVoidButtonAction(_:)), for: .touchUpInside)
            cell.paxTypeSegemnt.replaceSegments(segments: paxArray)
            cell.paxTypeSegemnt.selectedSegmentIndex = 0
            cell.paxTypeSegemnt.tag = indexPath.row
            cell.paxTypeSegemnt.addTarget(self, action: #selector(paxSegmentChanged(_:)), for: .valueChanged)
            
            let paymentMode = tableData[indexPath.row]["paymentMode"] as? String ?? ""
            //Update Segment
            if let index = DataManager.selectedPAX.firstIndex(where: {$0.lowercased() == paymentMode.lowercased()}) {
                cell.paxTypeSegemnt.selectedSegmentIndex = index
            }else {
                cell.paxTypeSegemnt.selectedSegmentIndex = 0
                tableData[indexPath.row]["paymentMode"] = DataManager.selectedPAX.first as AnyObject
            }
            
            //Fill Data
            if let value = tableData[indexPath.row]["amount"] as? String, value != "" {
                cell.amountTextField.text = value
            }else {
                cell.amountTextField.text = ""
            }
            
            if let value = tableData[indexPath.row]["tip"] as? String, value != "" {
                cell.tfTipAmount.text = value
            }else {
                cell.tfTipAmount.text = ""
            }
            
            if let value = tableData[indexPath.row]["device"] as? String, value != "" {
                if DataManager.selectedPaxDeviceName != "" {
                    if deviceNameFlag {
                        cell.selectDeviceTextField.text = value
                    }else{
                        cell.selectDeviceTextField.text = DataManager.selectedPaxDeviceName
                    }
                    
                } else {
                    cell.selectDeviceTextField.text = value
                }
                
                let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
                cell.selectDeviceTextField.isHidden = array.count == 1
            }else {
                let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
                let arrayURL = HomeVM.shared.paxDeviceList.compactMap({$0.url})
                
                cell.selectDeviceTextField.text = array.first ?? ""
                tableData[indexPath.row]["device"] = (array.first ?? "") as AnyObject
                tableData[indexPath.row]["url"] = (arrayURL.first ?? "") as AnyObject
                cell.selectDeviceTextField.isHidden = array.count == 1
            }
            
            cell.paxRemoveBtn.addTarget(self, action: #selector(removeSelectedPayment(sender:)), for: .touchUpInside)
            //Set Shadow & Corner Radius
            cell.backView.layer.cornerRadius = 5
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.backView.layer.shadowOpacity = 0.5
            
            if let value = tableData[indexPath.row]["isApproved"] as? Bool, value == true {
                cell.voidButton.isHidden = false
                cell.selectDeviceTextField.isEnabled = false
                cell.paxTypeSegemnt.isEnabled = false
                cell.amountTextField.isEnabled = false
                cell.tfTipAmount.isEnabled = false
                cell.paxRemoveBtn.isEnabled = false
                appDelegate.isVoidPayment = true
            }else {
                cell.voidButton.isHidden = true
                cell.selectDeviceTextField.isEnabled = true
                cell.paxTypeSegemnt.isEnabled = true
                cell.amountTextField.isEnabled = true
                cell.tfTipAmount.isEnabled = true
                cell.paxRemoveBtn.isEnabled = true
            }
            
            if let value = tableData[indexPath.row]["errorMessage"] as? String, value != "" {
                cell.errorMessageLabel.text = value
                cell.backView.layer.shadowColor = UIColor.red.cgColor
            }else {
                let array = customError.filter({$0.index == indexPath.row})
                if array.count > 0 {
                    cell.errorMessageLabel.text = array.first?.message
                    cell.backView.layer.shadowColor = UIColor.red.cgColor
                }else {
                    cell.errorMessageLabel.text = ""
                    cell.backView.layer.shadowColor = filledCellIndex.contains(indexPath.row) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
                }
            }
            
            if indexPath.row == tableData.count - 1 && MultiCardContainerViewController.isClassLoaded {
                self.selectedTextField = cell.amountTextField
            }
            
            cell.tfTipAmount.isHidden = true
            
            //Set Header Text
            cell.headerLabel.text = "PAX #\(indexPath.row + 1)"
            return cell
            
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: tableData[indexPath.row]["cellID"] as! String) as! InternalGiftCardTableViewCell
            cell.load()
            cell.amountField.delegate = self
            cell.giftCardNoField.delegate = self
            cell.amountField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.giftCardNoField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.voidButton.tag = indexPath.row
            cell.voidButton.addTarget(self, action: #selector(handleVoidButtonAction(_:)), for: .touchUpInside)
            
            //Fill Data
            if let value = tableData[indexPath.row]["ccNo"] as? String, value != "" {
                cell.giftCardNoField.text = value
            }else {
                cell.giftCardNoField.text = ""
            }
            
            if let value = tableData[indexPath.row]["amount"] as? String, value != "" {
                cell.amountField.text = value
            }else {
                cell.amountField.text = ""
            }
            
            if (self.tableData[indexPath.row]["isSwipedProperly"] as? Bool ?? false) {
                cell.giftCardNoField.resetCustomError(isAddAgain: false)
            }else {
                cell.giftCardNoField.setCustomError()
            }
            
            cell.giftCardRemoveBtn.addTarget(self, action: #selector(removeSelectedPayment(sender:)), for: .touchUpInside)
            //Set Shadow & Corner Radius
            cell.backView.layer.cornerRadius = 5
            cell.backView.layer.masksToBounds = false
            cell.backView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.backView.layer.shadowOpacity = 0.5
            
            if let value = tableData[indexPath.row]["isApproved"] as? Bool, value == true {
                cell.voidButton.isHidden = false
                cell.giftCardNoField.isEnabled = false
                cell.amountField.isEnabled = false
                cell.giftCardRemoveBtn.isEnabled = false
                appDelegate.isVoidPayment = true
            }else {
                cell.voidButton.isHidden = true
                cell.giftCardNoField.isEnabled = true
                cell.amountField.isEnabled = true
                cell.giftCardRemoveBtn.isEnabled = true
            }
            
            if let value = tableData[indexPath.row]["errorMessage"] as? String, value != "" {
                
                //paymentModeMenu(sender: <#T##UIButton#>, selctedIndex: mode)
                
                if let amount = tableData[indexPath.row]["pending_payment"] as? Double, amount != 0 {
                    print("allow pending_payment data \(amount)")
                    
                    if isinternalGift {
                        cell.amountField.text = "\(amount)"
                        tableData[indexPath.row]["amount"] = amount as AnyObject
                        //                        cell.amountField.isEnabled = false
                        //                        paymentModeList(selctedIndex: mode, amountVal: amount, index: indexPath.row)
                    }
                }
                
                cell.errorMessageLabel.text = value
                cell.backView.layer.shadowColor = UIColor.red.cgColor
            }else {
                let array = customError.filter({$0.index == indexPath.row})
                if array.count > 0 {
                    cell.errorMessageLabel.text = array.first?.message
                    cell.backView.layer.shadowColor = UIColor.red.cgColor
                }else {
                    cell.errorMessageLabel.text = ""
                    cell.backView.layer.shadowColor = filledCellIndex.contains(indexPath.row) ? UIColor.green.cgColor : UIColor.lightGray.cgColor
                }
            }
            
            if indexPath.row == tableData.count - 1 && MultiCardContainerViewController.isClassLoaded {
                self.selectedTextField = cell.amountField
            }
            
            //Set Header Text
            cell.headerLabel.text = "Internal Gift Card #\(indexPath.row + 1)"
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    @objc func paxSegmentChanged(_ sender: UISegmentedControl) {
        self.tableData[sender.tag]["paymentMode"] = DataManager.selectedPAX[sender.selectedSegmentIndex].uppercased() as AnyObject
    }
    
    @objc func removeSelectedPayment(sender:UIButton)
    {
        self.view.endEditing(true)
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell)
        {
            superview = view.superview
        }
        
        guard let cell = superview as? UITableViewCell else
        {
            print("button is not contained in a table view cell")
            return
        }
        
        guard let indexPath = paymnetsModeTable.indexPath(for: cell) else
        {
            print("failed to get index path for cell containing button")
            return
        }
        
        print("button is in row \(indexPath.row)")
        
        let mode = tableData[indexPath.row]["index"] as? Int ?? 0
        print("Mode: \(mode)")
        
        switch mode {
        case 1:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! CreditCardTableViewCell
            let amount = Double(cell.ccAmountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            
            if let data =  DataManager.arrTempListing {
                for i in 0..<data.count {
                    let arrsign = data[i]
                    let tipVal = arrsign["tip"] as? String
                    let cardNumberVal = arrsign["card_number"] as? String
                    let numerCard = cell.CCNoField.text!
                    let card = cardNumberVal?.suffix(4)
                    if numerCard.suffix(4) == card {
//
                        let tipa = tipVal ?? "0.00"
                        
                        //delegate?.checkPayButtonColorChange?(isCheck: true, text: "MULTI CARD")
                        delegate?.balanceRemoveTip?(with: tipa.toDouble()!)
                        //HomeVM.shared.DueShared = HomeVM.shared.DueShared - (tipa.toDouble())!
                    }
                }
            }
            
            break
        case 2:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! CashTableViewCell
            let amount = Double(cell.cashAmountField.text!) ?? 0.0
            totalAmount += amount
            
            isCashOn = true
            
            _ = self.setTotal(amount: 0.0)
            //Remove from Selection
            if let index = PaymentModeMenuViewController.hiddenButtonstags.index(where: {$0 == mode}) {
                PaymentModeMenuViewController.hiddenButtonstags.remove(at: index)
            }
            break
        case 3:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! CheckTableViewCell
            let amount = Double(cell.chequeAmountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            //Remove from Selection
            if let index = PaymentModeMenuViewController.hiddenButtonstags.index(where: {$0 == mode}) {
                PaymentModeMenuViewController.hiddenButtonstags.remove(at: index)
            }
            break
        case 4:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! ExternalTableViewCell
            let amount = Double(cell.extAmount.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            //Remove from Selection
            if let index = PaymentModeMenuViewController.hiddenButtonstags.index(where: {$0 == mode}) {
                PaymentModeMenuViewController.hiddenButtonstags.remove(at: index)
            }
            break
        case 5:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! ExternalGiftCardTableViewCell
            let amount = Double(cell.amountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            break
        case 6:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! GiftCardTableViewCell
            let amount = Double(cell.amountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            break
        case 7:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! ACHCheckTableViewCell
            let amount = Double(cell.amountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            break
        case 8:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! PaxTableViewCell
            let amount = Double(cell.amountTextField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            //Remove from Selection
            if let index = PaymentModeMenuViewController.hiddenButtonstags.index(where: {$0 == mode}) {
                PaymentModeMenuViewController.hiddenButtonstags.remove(at: index)
            }
            break
        case 9:
            let cell = paymnetsModeTable.cellForRow(at: indexPath) as! InternalGiftCardTableViewCell
            let amount = Double(cell.amountField.text!) ?? 0.0
            totalAmount += amount
            _ = self.setTotal(amount: 0.0)
            break
        default:
            break
        }
        self.tableData.remove(at: indexPath.row)
        
        if tableData.count == 0 {
            ChangeDueAmount = 0.0
            lbl_ChangeDue.text = "$0.00"
        }
        
        self.selectedIndexPath = nil
        self.filledCellIndex.removeAll()
        self.customError.removeAll()
        self.paymnetsModeTable.reloadData()
        self.updateTipTotal()
    }
    
    @objc func handleVoidButtonAction(_ sender: UIButton) {
        self.showAlert(title: "Confirm", message: "Are you sure?", otherButtons: ["Cancel":{ (_) in
            //...
            }], cancelTitle: "OK") { (_) in
                self.voidTransaction(index: sender.tag, sender: sender)
        }
    }
    
    @objc func handleSavedCardButtonAction(_ sender: UIButton) {
        
        intCardIndex = sender.tag
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if DataManager.CardCount > 0 {
                self.creditCardDataShow?.didDataShowCreditcard?(paymentMethod: "")
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
}

//MARK: UITableViewDelegate
extension MultiCardContainerViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let mode = tableData[indexPath.row]["index"] as? Int ?? 0
        
        switch mode - 1 {
        case 0:
            return 230
        case 1:
            return 135
        case 2:
            return 180
        case 3:
            return 135
        case 4:
            return 183
        case 5:
            return 228
        case 6:
            return 323
        case 7:
            return HomeVM.shared.paxDeviceList.count == 1 ? 200 : 235
        case 8:
            return 183
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

//MARK: PaymentModeMenuDelegate
extension MultiCardContainerViewController: PaymentModeMenuDelegate
{
    func paymentModeMenu(sender: UIButton, selctedIndex: Int)
    {
        if selctedIndex == 9 {
            isinternalGift = true
        }
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            plusButton.isSelected = false
        }
        //let amount = lbl_AmountRemaining.text!.replacingOccurrences(of: "Amount Remain $", with: "")
        let amount = lbl_AmountRemaining.text!.replacingOccurrences(of: "$", with: "")
        var dict = populatedData[selctedIndex - 1]
        dict["amount"] = amount as AnyObject
        tableData.append(dict)
        
        totalAmount = 0
        _ = self.setTotal(amount: 0)
        
        //Disable buttons
        if selctedIndex == 2 || selctedIndex == 4 || selctedIndex == 8 {
            paymentModeViewDelegate?.didHideButton(with: selctedIndex, isHidden: true)
        }
        
        if selctedIndex == 1 || selctedIndex == 5 || selctedIndex == 6 || selctedIndex == 9 {
            self.selectedIndexPath = IndexPath(row: self.tableData.count - 1, section: 0)
        }
        
        self.paymnetsModeTable.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.reloadTable()
            //Check For External Accessory
            if Keyboard._isExternalKeyboardAttached() {
                self.view.endEditing(true)
                SwipeAndSearchVC.shared.enableTextField()
            }
        })
    }
    
    func didDismiss() {
        plusButton.isSelected = false
    }
}

//MARK: UITextFieldDelegate
extension MultiCardContainerViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.hideAssistantBar()
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        self.isCardNumberReceived = false
        let indexPoint :CGPoint = textField.convert(.zero, to: paymnetsModeTable)
        guard let indexPathValue:IndexPath = paymnetsModeTable.indexPathForRow(at: indexPoint) else {
            return
        }
        print("the index of current cell \(indexPathValue.row)")
        
        let mode = tableData[indexPathValue.row]["index"] as? Int ?? 0
        selectedIndexPath = indexPathValue
        dummyCardNumber = ""
        switch mode {
        case 1:
            let cell = textField.superview?.superview?.superview as? CreditCardTableViewCell ?? textField.superview?.superview?.superview?.superview as! CreditCardTableViewCell
            recentAmount = Double(cell.ccAmountField.text ?? "0") ?? 0.0
            tipAmount = Double(cell.ccTripAmount.text ?? "0") ?? 0.0
            if textField == cell.ccExpMM {
                self.upadateMonthArray()
                textField.tag = 10
                textField.tintColor = UIColor.clear
                self.pickerDelegate = self
                textField.text = MM_Array.first
                strMonth = "\(MM_Array[0])"
                self.setPickerView(textField: textField, array: MM_Array)
            }
            
            if textField == cell.ccExpyear {
                textField.tag = 20
                textField.tintColor = UIColor.clear
                self.pickerDelegate = self
                textField.text = YY_Array.first
                selectedYear = textField.text ?? ""
                strYear = "\(YY_Array[0])"
                //cell.ccExpMM.text = ""
                self.setPickerView(textField: textField, array: YY_Array)
            }
            
            if textField == cell.ccAmountField {
                DispatchQueue.main.async {
                    textField.selectAll(nil)
                }
            }
            
            if textField == cell.CCNoField {
                cell.CCNoField.resetCustomError(isAddAgain: false)
                tableData[indexPathValue.row]["isSwipedProperly"] = true as AnyObject
            }
            break
        case 2:
            let cell  = textField.superview?.superview?.superview as? CashTableViewCell ?? textField.superview?.superview?.superview?.superview as! CashTableViewCell
            recentAmount = Double(cell.cashAmountField.text ?? "0") ?? 0.0
            
            if textField == cell.cashAmountField {
                DispatchQueue.main.async {
                    textField.selectAll(nil)
                }
            }
            break
        case 3:
            let cell  = textField.superview?.superview?.superview?.superview as! CheckTableViewCell
            recentAmount = Double(cell.chequeAmountField.text ?? "0") ?? 0.0
            
            if textField == cell.chequeAmountField {
                DispatchQueue.main.async {
                    textField.selectAll(nil)
                }
            }
            break
        case 4:
            let cell  = textField.superview?.superview?.superview?.superview as! ExternalTableViewCell
            recentAmount = Double(cell.extAmount.text ?? "0") ?? 0.0
            
            if textField == cell.extAmount {
                DispatchQueue.main.async {
                    textField.selectAll(nil)
                }
            }
            break
        case 5:
            let cell  = textField.superview?.superview?.superview as! ExternalGiftCardTableViewCell
            recentAmount = Double(cell.amountField.text ?? "0") ?? 0.0
            
            if textField == cell.amountField {
                DispatchQueue.main.async {
                    textField.selectAll(nil)
                }
            }
            
            if textField == cell.giftCardNoField {
                cell.giftCardNoField.resetCustomError(isAddAgain: false)
                tableData[indexPathValue.row]["isSwipedProperly"] = true as AnyObject
            }
            break
        case 6:
            let cell  = textField.superview?.superview?.superview?.superview as! GiftCardTableViewCell
            recentAmount = Double(cell.amountField.text ?? "0") ?? 0.0
            
            if textField == cell.amountField {
                DispatchQueue.main.async {
                    textField.selectAll(nil)
                }
            }
            
            if textField == cell.giftCardNoField {
                cell.giftCardNoField.resetCustomError(isAddAgain: false)
                tableData[indexPathValue.row]["isSwipedProperly"] = true as AnyObject
            }
            
            break
        case 7:
            let cell = textField.superview?.superview?.superview?.superview as!  ACHCheckTableViewCell
            recentAmount = Double(cell.amountField.text ?? "0") ?? 0.0
            if textField == cell.achSelectDLField {
                textField.tag = 30
                textField.tintColor = UIColor.clear
                let array = array_RegionsList.compactMap({$0.str_regionName})
                self.pickerDelegate = self
                self.setPickerView(textField: textField, array: array)
            }
            
            if textField == cell.amountField {
                DispatchQueue.main.async {
                    textField.selectAll(nil)
                }
            }
            break
        case 8:
            let cell  = textField.superview?.superview?.superview?.superview?.superview as? PaxTableViewCell ?? textField.superview?.superview?.superview?.superview?.superview?.superview as! PaxTableViewCell
            recentAmount = Double(cell.amountTextField.text ?? "0") ?? 0.0
            tipPaxAmount = Double(cell.tfTipAmount.text ?? "0") ?? 0.0
            cell.selectDeviceTextField.tintColor = UIColor.clear
            
            if textField == cell.selectDeviceTextField {
                deviceNameFlag = true
                textField.tag = 40
                let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
                if array.count == 1 {
                    DispatchQueue.main.async {
                        textField.resignFirstResponder()
                    }
                }else {
                    self.pickerDelegate = self
                    self.setPickerView(textField: cell.selectDeviceTextField, array: array)
                }
            }
            
            if textField == cell.amountTextField {
                DispatchQueue.main.async {
                    textField.selectAll(nil)
                }
            }
            
            if textField == cell.tfTipAmount {
                DispatchQueue.main.async {
                    textField.selectAll(nil)
                }
            }
            break
        case 9:
            let cell  = textField.superview?.superview?.superview as! InternalGiftCardTableViewCell
            recentAmount = Double(cell.amountField.text ?? "0") ?? 0.0
            
            if textField == cell.amountField {
                DispatchQueue.main.async {
                    textField.selectAll(nil)
                }
            }
            
            if textField == cell.giftCardNoField {
                cell.giftCardNoField.resetCustomError(isAddAgain: false)
                tableData[indexPathValue.row]["isSwipedProperly"] = true as AnyObject
            }
            break
            
        default: break
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let indexPoint :CGPoint = textField.convert(.zero, to: paymnetsModeTable)
        let indexPathValue:IndexPath = paymnetsModeTable.indexPathForRow(at: indexPoint)!
        print("the index of current cell \(indexPathValue.row)")
        
        let mode = tableData[indexPathValue.row]["index"] as? Int ?? 0
        
        switch mode {
        case 1:
            let cell = textField.superview?.superview?.superview as? CreditCardTableViewCell ?? textField.superview?.superview?.superview?.superview as! CreditCardTableViewCell
            tableData[indexPathValue.row]["ccNo"] = cell.CCNoField.text?.replacingOccurrences(of: "************", with: "") as AnyObject
            tableData[indexPathValue.row]["ccMM"] = cell.ccExpMM.text as AnyObject
            tableData[indexPathValue.row]["ccYear"] = cell.ccExpyear.text as AnyObject
            tableData[indexPathValue.row]["ccCVV"] = cell.ccCVV.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.ccAmountField.text as AnyObject
            tableData[indexPathValue.row]["tip"] = cell.ccTripAmount.text as AnyObject
            self.updateTipTotal()
            break
        case 2:
            let cell  = textField.superview?.superview?.superview as? CashTableViewCell ?? textField.superview?.superview?.superview?.superview as! CashTableViewCell
            tableData[indexPathValue.row]["amount"] = cell.cashAmountField.text as AnyObject
            //tableData[indexPathValue.row][""] = cell.cashAmountField.text as AnyObject
            break
        case 3:
            let cell  = textField.superview?.superview?.superview?.superview as! CheckTableViewCell
            tableData[indexPathValue.row]["chNo"] = cell.chequeNoField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.chequeAmountField.text as AnyObject
            break
        case 4:
            let cell  = textField.superview?.superview?.superview?.superview as! ExternalTableViewCell
            tableData[indexPathValue.row]["amount"] = cell.extAmount.text as AnyObject
            break
        case 5:
            let cell  = textField.superview?.superview?.superview as! ExternalGiftCardTableViewCell
            tableData[indexPathValue.row]["ccNo"] = cell.giftCardNoField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.amountField.text as AnyObject
            break
        case 6:
            let cell  = textField.superview?.superview?.superview?.superview as! GiftCardTableViewCell
            tableData[indexPathValue.row]["ccNo"] = cell.giftCardNoField.text as AnyObject
            tableData[indexPathValue.row]["gcpin"] = cell.giftCardPinField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.amountField.text as AnyObject
            break
        case 7:
            let cell  = textField.superview?.superview?.superview?.superview as! ACHCheckTableViewCell
            tableData[indexPathValue.row]["achRoutNo"] = cell.achRoutingNoField.text as AnyObject
            tableData[indexPathValue.row]["achACNo"] = cell.achAccountNoField.text as AnyObject
            tableData[indexPathValue.row]["achDlNo"] = cell.achDLField.text as AnyObject
            tableData[indexPathValue.row]["achDlState"] = cell.achSelectDLField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.amountField.text as AnyObject
            break
        case 8:
            let cell  = textField.superview?.superview?.superview?.superview?.superview as? PaxTableViewCell ?? textField.superview?.superview?.superview?.superview?.superview?.superview as! PaxTableViewCell
            tableData[indexPathValue.row]["device"] = cell.selectDeviceTextField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.amountTextField.text as AnyObject
            tableData[indexPathValue.row]["tip"] = cell.tfTipAmount.text as AnyObject
            self.updateTipTotal()
            break
        case 9:
            let cell  = textField.superview?.superview?.superview as! InternalGiftCardTableViewCell
            tableData[indexPathValue.row]["ccNo"] = cell.giftCardNoField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.amountField.text as AnyObject
            break
            
        default: break
        }
    }
    
    func updateRemaining() {
        var total = Double()
        for dict in tableData {
            let amount = Double(dict["amount"] as? String ?? "0") ?? 0.0
            total += amount
        }
        totalAmount = grandTotalAmount - total
        lbl_AmountRemaining.text = "$\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)"
        
        //lbl_AmountRemaining.text = "Amount Remain $\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)"
        delegate?.didUpdateAmountRemaining?(amount: "$\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)")
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPoint :CGPoint = textField.convert(.zero, to: paymnetsModeTable)
        guard let indexPathValue:IndexPath = paymnetsModeTable.indexPathForRow(at: indexPoint) else {return}
        print("the index of current cell \(indexPathValue.row)")
        
        //Handle Swipe Reader Data
        if Keyboard._isExternalKeyboardAttached() {
            if dummyCardNumber != "" {
                let isSingleBeepSwiper = String(describing: dummyCardNumber.prefix(1)) == ";"
                if (String(describing: dummyCardNumber.prefix(2)) != "%B" && !isSingleBeepSwiper) || (String(describing: dummyCardNumber.prefix(1)) != ";" && isSingleBeepSwiper) {
                    dummyCardNumber = ""
                    self.updateRemaining()
                    return
                }
                
                let cardNumberArray = dummyCardNumber.split(separator: isSingleBeepSwiper ? "=" : "^")
                if isSingleBeepSwiper ? cardNumberArray.count > 1 : cardNumberArray.count > 2 {
                    let number = String(describing: String(describing: cardNumberArray.first ?? "").dropFirst(isSingleBeepSwiper ? 1 : 2))
                    let month = String(describing: String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(4)).dropFirst(2))
                    let year = String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(2))
                    
                    self.fillCardDetail(number: number, month: month, year: "20" + year)
                    dummyCardNumber = ""
                    textField.tintColor = UIColor.blue
                    self.updateRemaining()
                    self.callValidateToChangeColor()
                    return
                }else {
                    dummyCardNumber = ""
                    tableData[indexPathValue.row]["isSwipedProperly"] = false as AnyObject
                    textField.tintColor = UIColor.blue
                    self.updateRemaining()
                    self.callValidateToChangeColor()
                    DispatchQueue.main.async {
                        self.paymnetsModeTable.reloadData {
                            SwipeAndSearchVC.shared.enableTextField()
                        }
                    }
                    return
                }
            }
        }
        
        if self.isCardNumberReceived {
            return
        }
        
        let mode = tableData[indexPathValue.row]["index"] as? Int ?? 0
        
        switch mode {
        case 1:
            let cell = textField.superview?.superview?.superview as? CreditCardTableViewCell ?? textField.superview?.superview?.superview?.superview as! CreditCardTableViewCell
            tableData[indexPathValue.row]["ccNo"] = cell.CCNoField.text?.replacingOccurrences(of: "************", with: "") as AnyObject
            tableData[indexPathValue.row]["ccMM"] = cell.ccExpMM.text as AnyObject
            tableData[indexPathValue.row]["ccYear"] = cell.ccExpyear.text as AnyObject
            tableData[indexPathValue.row]["ccCVV"] = cell.ccCVV.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.ccAmountField.text as AnyObject
            tableData[indexPathValue.row]["tip"] = cell.ccTripAmount.text as AnyObject
            
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            
            if (cell.ccExpyear.text ?? "") == "\(year)" && (Int(cell.ccExpMM.text ?? "0") ?? 0 ) < month {
                cell.ccExpMM.text = ""
                tableData[indexPathValue.row]["ccMM"] = "" as AnyObject
            }
            
            tipAmount = Double(cell.ccTripAmount.text ?? "0") ?? 0.0
            
            let amount = Double(cell.ccAmountField.text ?? "0") ?? 0.0
            
            if amount == recentAmount {
                break
            }
            totalAmount = totalAmount + recentAmount
            if self.setTotal(amount: amount) {
                cell.ccAmountField.text = ""
                tableData[indexPathValue.row]["amount"] = "" as AnyObject
            }
            break
        case 2:
            let cell  = textField.superview?.superview?.superview as? CashTableViewCell ?? textField.superview?.superview?.superview?.superview as! CashTableViewCell
            tableData[indexPathValue.row]["amount"] = cell.cashAmountField.text as AnyObject
            let amount = Double(cell.cashAmountField.text!) ?? 0.0
            if amount == recentAmount {
                break
            }
            totalAmount = totalAmount + recentAmount
            if self.setTotal(amount: amount) {
                cell.cashAmountField.text = ""
                tableData[indexPathValue.row]["amount"] = "" as AnyObject
            }
            break
        case 3:
            let cell  = textField.superview?.superview?.superview?.superview as! CheckTableViewCell
            tableData[indexPathValue.row]["chNo"] = cell.chequeNoField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.chequeAmountField.text as AnyObject
            let amount = Double(cell.chequeAmountField.text!) ?? 0.0
            if amount == recentAmount {
                break
            }
            totalAmount = totalAmount + recentAmount
            if self.setTotal(amount: amount) {
                cell.chequeAmountField.text = ""
                tableData[indexPathValue.row]["amount"] = "" as AnyObject
            }
            break
        case 4:
            let cell  = textField.superview?.superview?.superview?.superview as! ExternalTableViewCell
            tableData[indexPathValue.row]["amount"] = cell.extAmount.text as AnyObject
            let amount = Double(cell.extAmount.text!) ?? 0.0
            if amount == recentAmount {
                break
            }
            totalAmount = totalAmount + recentAmount
            if self.setTotal(amount: amount) {
                cell.extAmount.text = ""
                tableData[indexPathValue.row]["amount"] = "" as AnyObject
            }
            break
        case 5:
            let cell  = textField.superview?.superview?.superview as! ExternalGiftCardTableViewCell
            tableData[indexPathValue.row]["ccNo"] = cell.giftCardNoField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.amountField.text as AnyObject
            
            let amount = Double(cell.amountField.text ?? "0") ?? 0.0
            
            if amount == recentAmount {
                break
            }
            totalAmount = totalAmount + recentAmount
            if self.setTotal(amount: amount) {
                cell.amountField.text = ""
                tableData[indexPathValue.row]["amount"] = "" as AnyObject
            }
            break
        case 6:
            let cell  = textField.superview?.superview?.superview?.superview as! GiftCardTableViewCell
            tableData[indexPathValue.row]["ccNo"] = cell.giftCardNoField.text as AnyObject
            tableData[indexPathValue.row]["gcpin"] = cell.giftCardPinField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.amountField.text as AnyObject
            
            let amount = Double(cell.amountField.text ?? "0") ?? 0.0
            
            if amount == recentAmount {
                break
            }
            totalAmount = totalAmount + recentAmount
            if self.setTotal(amount: amount) {
                cell.amountField.text = ""
                tableData[indexPathValue.row]["amount"] = "" as AnyObject
            }
            break
        case 7:
            let cell  = textField.superview?.superview?.superview?.superview as! ACHCheckTableViewCell
            tableData[indexPathValue.row]["achRoutNo"] = cell.achRoutingNoField.text as AnyObject
            tableData[indexPathValue.row]["achACNo"] = cell.achAccountNoField.text as AnyObject
            tableData[indexPathValue.row]["achDlNo"] = cell.achDLField.text as AnyObject
            tableData[indexPathValue.row]["achDlState"] = cell.achSelectDLField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.amountField.text as AnyObject
            
            let amount = Double(cell.amountField.text ?? "0") ?? 0.0
            
            if amount == recentAmount {
                break
            }
            totalAmount = totalAmount + recentAmount
            if self.setTotal(amount: amount) {
                cell.amountField.text = ""
                tableData[indexPathValue.row]["amount"] = "" as AnyObject
            }
            break
        case 8:
            let cell  = textField.superview?.superview?.superview?.superview?.superview as? PaxTableViewCell ?? textField.superview?.superview?.superview?.superview?.superview?.superview as! PaxTableViewCell
            tableData[indexPathValue.row]["device"] = cell.selectDeviceTextField.text as AnyObject
            tableData[indexPathValue.row]["tip"] = cell.tfTipAmount.text as AnyObject
            
            if let index = HomeVM.shared.paxDeviceList.firstIndex(where: {$0.name == (cell.selectDeviceTextField.text ?? "")}) {
                tableData[indexPathValue.row]["url"] = HomeVM.shared.paxDeviceList[index].url as AnyObject
            }
            tipPaxAmount = Double(cell.tfTipAmount.text ?? "0") ?? 0.0
            
            tableData[indexPathValue.row]["amount"] = cell.amountTextField.text as AnyObject
            let amount = Double(cell.amountTextField.text!) ?? 0.0
            if amount == recentAmount {
                break
            }
            totalAmount = totalAmount + recentAmount
            if self.setTotal(amount: amount) {
                cell.amountTextField.text = ""
                tableData[indexPathValue.row]["amount"] = "" as AnyObject
            }
            break
        case 9:
            let cell  = textField.superview?.superview?.superview as! InternalGiftCardTableViewCell
            tableData[indexPathValue.row]["ccNo"] = cell.giftCardNoField.text as AnyObject
            tableData[indexPathValue.row]["amount"] = cell.amountField.text as AnyObject
            
            let amount = Double(cell.amountField.text ?? "0") ?? 0.0
            
            if amount == recentAmount {
                break
            }
            totalAmount = totalAmount + recentAmount
            if self.setTotal(amount: amount) {
                cell.amountField.text = ""
                tableData[indexPathValue.row]["amount"] = "" as AnyObject
            }
            break
            
        default: break
        }
        updateTipTotal()
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Handle Swipe Reader Data
        dummyCardNumber.append(string)
        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            textField.tintColor = UIColor.clear
            return false
        }
        dummyCardNumber = ""
        
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        let indexPoint :CGPoint = textField.convert(.zero, to: paymnetsModeTable)
        let indexPathValue:IndexPath = paymnetsModeTable.indexPathForRow(at: indexPoint)!
        let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        let mode = tableData[indexPathValue.row]["index"] as? Int ?? 0
        
        switch mode {
        case 1:
            let cell = textField.superview?.superview?.superview as? CreditCardTableViewCell ?? textField.superview?.superview?.superview?.superview as! CreditCardTableViewCell
            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
            
            if textField == cell.CCNoField || textField == cell.ccCVV {
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if string == filtered {
                    if textField == cell.ccCVV {
                        return charactersCount < 5
                    }
                    if textField == cell.CCNoField {
                        return charactersCount < 17
                    }
                }else {
                    return false
                }
            }
            
            if textField == cell.ccAmountField || textField == cell.ccTripAmount {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                if charactersCount > 50 {
                    return false
                }
                let amount = Double(text) ?? 0.0
                let amountRemaining = totalAmount + recentAmount
                return textField == cell.ccAmountField ? replacementText.isValidDecimal(maximumFractionDigits: 2) ? amount <= amountRemaining : false : replacementText.isValidDecimal(maximumFractionDigits: 2)
            }
            return true
        case 2:
            let cell  = textField.superview?.superview?.superview as? CashTableViewCell ?? textField.superview?.superview?.superview?.superview as! CashTableViewCell
            let currentText = cell.cashAmountField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            if charactersCount > 50 {
                return false
            }
            let amount = Double(text) ?? 0.0
            let amountRemaining = totalAmount + recentAmount
            
            let valAmount = amount - amountRemaining
            
            if valAmount > 0 {
                ChangeDueAmount = valAmount
                lbl_ChangeDue.text = valAmount.currencyFormat
                delegate?.didUpdateAmountChangeDue?(amount: lbl_ChangeDue.text!)
            } else {
                lbl_ChangeDue.text = "$0.00"
                delegate?.didUpdateAmountChangeDue?(amount: lbl_ChangeDue.text!)
            }
            
            print("amount change due == \(valAmount)")
            
            //return replacementText.isValidDecimal(maximumFractionDigits: 2) ? amount <= amountRemaining : false
            return replacementText.isValidDecimal(maximumFractionDigits: 2)
        case 3:
            let cell  = textField.superview?.superview?.superview?.superview as! CheckTableViewCell
            
            if textField == cell.chequeAmountField {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                if charactersCount > 50 {
                    return false
                }
                let amount = Double(text) ?? 0.0
                let amountRemaining = totalAmount + recentAmount
                return replacementText.isValidDecimal(maximumFractionDigits: 2) ? amount <= amountRemaining : false
            }
            
            if textField == cell.chequeNoField {
                let cs = NSCharacterSet(charactersIn: "0123456789").inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if charactersCount > 50 {
                    return false
                }
                return string == filtered
            }
            return false
        case 4:
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let amount = Double(text) ?? 0.0
            let amountRemaining = totalAmount + recentAmount
            return replacementText.isValidDecimal(maximumFractionDigits: 2) ? amount <= amountRemaining : false
        case 5:
            let cell  = textField.superview?.superview?.superview as! ExternalGiftCardTableViewCell
            if textField == cell.amountField {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                if charactersCount > 50 {
                    return false
                }
                let amount = Double(text) ?? 0.0
                let amountRemaining = totalAmount + recentAmount
                return replacementText.isValidDecimal(maximumFractionDigits: 2) ? amount <= amountRemaining : false
            }
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            return string == filtered
        case 6:
            let cell  = textField.superview?.superview?.superview?.superview as! GiftCardTableViewCell
            if textField == cell.amountField {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                if charactersCount > 50 {
                    return false
                }
                let amount = Double(text) ?? 0.0
                let amountRemaining = totalAmount + recentAmount
                return replacementText.isValidDecimal(maximumFractionDigits: 2) ? amount <= amountRemaining : false
            }
            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            return string == filtered
        case 7:
            let cell  = textField.superview?.superview?.superview?.superview as! ACHCheckTableViewCell
            if textField == cell.amountField {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                if charactersCount > 50 {
                    return false
                }
                let amount = Double(text) ?? 0.0
                let amountRemaining = totalAmount + recentAmount
                return replacementText.isValidDecimal(maximumFractionDigits: 2) ? amount <= amountRemaining : false
            }
            let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            return string == filtered
        case 8:
            let cell  = textField.superview?.superview?.superview?.superview?.superview as? PaxTableViewCell ?? textField.superview?.superview?.superview?.superview?.superview?.superview as! PaxTableViewCell
            if textField == cell.amountTextField {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                if charactersCount > 50 {
                    return false
                }
                let amount = Double(text) ?? 0.0
                let amountRemaining = totalAmount + recentAmount
                return replacementText.isValidDecimal(maximumFractionDigits: 2) ? amount <= amountRemaining : false
            }
            
            if textField == cell.tfTipAmount {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                if charactersCount > 50 {
                    return false
                }
                //let amount = Double(text) ?? 0.0
                //let amountRemaining = totalAmount + recentAmount
                return replacementText.isValidDecimal(maximumFractionDigits: 2)
            }
            
            if textField == cell.selectDeviceTextField {
                let cs = CharacterSet.alphanumerics.inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if charactersCount > 50 {
                    return false
                }
                return string == filtered
            }
            return false
        case 9:
            let cell  = textField.superview?.superview?.superview as! InternalGiftCardTableViewCell
            if textField == cell.amountField {
                let currentText = textField.text ?? ""
                let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
                if charactersCount > 50 {
                    return false
                }
                let amount = Double(text) ?? 0.0
                let amountRemaining = totalAmount + recentAmount
                return replacementText.isValidDecimal(maximumFractionDigits: 2) ? amount <= amountRemaining : false
            }
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 50 {
                return false
            }
            return string == filtered
        default: return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: PaymentTypeDelegate
extension MultiCardContainerViewController: PaymentTypeDelegate {
    
    func didUpdateRemainingAmt(RemainingAmt: Double){
        print("RemainingAmt",RemainingAmt)
    }
    
    func savedCardInfoInphone(cartSavedArray: Array<AnyObject>) {
        //print("enter value data on multicard")
        let object = cartSavedArray[0] as! SavedCardList
        
        let last_4 = object.last_4
        let cardexpyr = object.cardexpyr
        let cardexpmo = object.cardexpmo
        //cardSavedbpid = object.bpid
        //DataManager.Bbpid = object.bpid
        print("bpid",object.bpid as Any)
        print("last_4",last_4 as Any)
        print("cardexpyr",cardexpyr as Any)
        print("cardexpmo",cardexpmo as Any)
        
        tableData[intCardIndex]["ccNo"] = last_4 as AnyObject
        tableData[intCardIndex]["ccMM"] = cardexpmo as AnyObject
        tableData[intCardIndex]["ccYear"] = cardexpyr as AnyObject
        tableData[intCardIndex]["bp_id"] = object.bpid as AnyObject
        
        
        paymnetsModeTable.reloadData()
    }
    
    func didSendCreditSavedCardData(cartDataArray:Array<AnyObject>){
        print("cartDataArray",cartDataArray)
        let object = cartDataArray[0] as! SavedCardList
        
        let last_4 = object.last_4
        let cardexpyr = object.cardexpyr
        let cardexpmo = object.cardexpmo
        let last4 = object.last4
        
        print("bpid",object.bpid as Any)
        print("last_4",last_4 as Any)
        print("cardexpyr",cardexpyr as Any)
        print("cardexpmo",cardexpmo as Any)
        
        tableData[intCardIndex]["ccNo"] = last4 as AnyObject
        tableData[intCardIndex]["ccMM"] = cardexpmo as AnyObject
        tableData[intCardIndex]["ccYear"] = cardexpyr as AnyObject
        tableData[intCardIndex]["bp_id"] = object.bpid as AnyObject
        
        paymnetsModeTable.reloadData()
    }
    
    func gettingErrorDuringPayment(isMulticard: Bool, message: String?, error: NSError?) {
        
        if message != nil {
            self.isPaymentDataContainAPIResponse = true
            var isDataFound = false
            
            if let data = HomeVM.shared.multicardErrorResponse["data"] as? JSONDictionary {
                if let errorDict = data["multi_card"] as? JSONDictionary {
                    for (key, value) in errorDict {
                        if let valueArray = value as? JSONArray {
                            for valueDict in valueArray {
                                
                                let orderID =  data["order_id"] as? Int ?? 0
                                let userID =  data["userID"] as? String ?? ""
                                let errorMessage =  valueDict["message"] as? String ?? ""
                                let ramainingAmount =  valueDict["pending_payment"] as? Double ?? 0.0
                                let txnID =  valueDict["txn_id"] as? String ?? ""
                                
                                if let status =  valueDict["status"] as? String , status == "Approved" {
                                    if let serialNumber =  valueDict["s_no"] as? Int {
                                        if serialNumber <= self.tableData.count {
                                            tableData[serialNumber - 1]["isApproved"] = true as AnyObject
                                            tableData[serialNumber - 1]["txnID"] = txnID as AnyObject
                                            tableData[serialNumber - 1]["orderID"] = orderID as AnyObject
                                            tableData[serialNumber - 1]["userID"] = userID as AnyObject
                                            tableData[serialNumber - 1]["type"] = key as AnyObject
                                            isDataFound = true
                                        }
                                    }
                                }else {
                                    if let serialNumber =  valueDict["s_no"] as? Int {
                                        if serialNumber <= self.tableData.count {
                                            tableData[serialNumber - 1]["errorMessage"] = errorMessage as AnyObject
                                            tableData[serialNumber - 1]["pending_payment"] = ramainingAmount as AnyObject
                                            tableData[serialNumber - 1]["txnID"] = txnID as AnyObject
                                            tableData[serialNumber - 1]["orderID"] = orderID as AnyObject
                                            tableData[serialNumber - 1]["userID"] = userID as AnyObject
                                            tableData[serialNumber - 1]["type"] = key as AnyObject
                                            tableData[serialNumber - 1]["isApproved"] = false as AnyObject
                                            isDataFound = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if !isDataFound  {
//                self.showAlert(message: message!)
                appDelegate.showToast(message: message!)
            }
        }else {
            self.showErrorMessage(error: error)
        }
        
        DispatchQueue.main.async {
            
            if HomeVM.shared.DueShared > 0 {
                self.grandTotalAmount = HomeVM.shared.DueShared
            }
            self.paymnetsModeTable.reloadData()
        }
    }
    
    func didUpdateDataOnrow(amount : Double) {
        TempAmount = amount.rounded(toPlaces: 2)
        
        if grandTotalAmount < amount {
            var remainingAmount = Double(lbl_AmountRemaining.text!.replacingOccurrences(of: "$", with: "")) ?? 0.0
            remainingAmount += (amount - grandTotalAmount)
            totalAmount = remainingAmount
            lbl_AmountRemaining.text = "$\(totalAmount.roundToTwoDecimal)"
            
            //lbl_AmountRemaining.text = "Amount Remain $\(totalAmount.roundToTwoDecimal)"
            delegate?.didUpdateAmountRemaining?(amount: "$\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)")
            
            self.grandTotalAmount = amount
        }else {
            self.grandTotalAmount = amount
            
            var total = Double()
            for dict in tableData {
                if let amount = dict["amount"] as? String {
                    total += (Double(amount) ?? 0.0)
                }
            }
        }
        
    }
    
    func didUpdateTotal(amount: Double , subToal : Double) {
        
        //totalAmount = amount
        
        if ChangeDueAmount > 0 {
            var total = Double()
            for dict in tableData {
                if let amountSave = dict["amount"] as? String {
                    total += (Double(amountSave) ?? 0.0)
                }
            }
            grandTotalAmount = total
        }
        
        TempAmount = amount.rounded(toPlaces: 2)
        ChangeDueAmount = 0.0
        lbl_ChangeDue.text = "$0.00"
        if grandTotalAmount < amount {
            var remainingAmount = Double(lbl_AmountRemaining.text!.replacingOccurrences(of: "$", with: "")) ?? 0.0
            remainingAmount += (amount - grandTotalAmount)
            totalAmount = remainingAmount
            lbl_AmountRemaining.text = "$\(totalAmount.roundToTwoDecimal)"
            
            //lbl_AmountRemaining.text = "Amount Remain $\(totalAmount.roundToTwoDecimal)"
            delegate?.didUpdateAmountRemaining?(amount: "$\(totalAmount < 0 ? "0.00" : totalAmount.roundToTwoDecimal)")
            
            self.grandTotalAmount = amount
        }else {
            //self.grandTotalAmount = amount
            
            var value = grandTotalAmount - amount
            
            var total = Double()
            for dict in tableData {
                if let amountSave = dict["amount"] as? String {
                    total += (Double(amountSave) ?? 0.0)
                }
            }
            
            let newAmt =  amount - total
            self.totalAmount = newAmt > 0 ? newAmt : 0
            
            if newAmt < 0 {
                var remainingAmt = -(newAmt)
                for i in stride(from: (tableData.count - 1), through: 0, by: -1) {
                    if let amountData = tableData[i]["amount"] as? String {
                        let amt = Double(amountData) ?? 0.0
                        
                        if let data = tableData[i]["isApproved"] as? Bool , data == true {
                            //tableData[i]["amount"] = amt as AnyObject
                            remainingAmt -= amt
                        } else if let data = tableData[i]["isApproved"] as? Bool , data == false {
                            
                            if amt > remainingAmt {
                                tableData[i]["amount"] = (amt - remainingAmt).roundToTwoDecimal as AnyObject
                                break
                            } else if amt <= remainingAmt {
                                let val = amt - value
                                if val > 0 {
                                    tableData[i]["amount"] = (amt - value).roundToTwoDecimal as AnyObject
                                    break
                                } else {
                                    value = -(val)
                                    tableData[i]["amount"] = "\(0.00)" as AnyObject
                                }
                                remainingAmt -= amt
                            }
                            
                        } else {
                            if amt > remainingAmt {
                                tableData[i]["amount"] = (amt - remainingAmt).roundToTwoDecimal as AnyObject
                                break
                            } else {
                                remainingAmt -= amt
                            }
                        }
                        
                    }
                }
            }
            
            self.grandTotalAmount = amount
            
            _ = setTotal(amount: 0)
            
            DispatchQueue.main.async {
                self.paymnetsModeTable.reloadData()
            }
        }
        callValidateToChangeColor()
    }
    
    func saveData() {
        self.view.endEditing(true)
        //if isPaymentDataContainAPIResponse {
        //    PaymentsViewController.paymentDetailDict.removeAll()
        //}else {
            PaymentsViewController.paymentDetailDict["data"] = self.tableData
        //}
    }
    
    func disableCardReader() {
        MultiCardContainerViewController.isClassLoaded = false
        //        SwipeAndSearchVC.delegate = nil
    }
    
    func enableCardReader() {
        
        MultiCardContainerViewController.isClassLoaded = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //Load Data
            self.loadData()
            //Get RegionList
            self.callAPItoGetRegionList()
            self.callAPItoGetPAXDeviceList()
            
            self.tableData.removeAll()
            
            if UI_USER_INTERFACE_IDIOM() == .phone {
                if self.tableData.count == 0 {
                    self.ChangeDueAmount = 0.0
                    self.lbl_ChangeDue.text = "$0.00"
                    self.totalAmount = self.TempAmount
                    if UI_USER_INTERFACE_IDIOM() == .phone {
                        self.delegate?.didUpdateAmountChangeDue!(amount: self.lbl_ChangeDue.text!)
                    }
                    
                } else {
                    self.totalAmount += self.TempAmount
                }
            } else {
                self.totalAmount += self.TempAmount
            }
            
            if self.tableData.count == 0 {
                self.ChangeDueAmount = 0.0
                self.lbl_ChangeDue.text = "$0.00"
            }
            
            self.selectedIndexPath = nil
            self.filledCellIndex.removeAll()
            self.customError.removeAll()
            self.paymnetsModeTable.reloadData()
            self.updateTipTotal()
            
            _ = self.setTotal(amount: 0.0)
        }
        delegate?.disableCardReaders?()
        SwipeAndSearchVC.delegate = nil
        SwipeAndSearchVC.delegate = self
        //        SwipeAndSearchVC.shared.enableTextField()
        
        
    }
    
    func sendMulticardData(isIPad: Bool) {
        Indicator.sharedInstance.showIndicator()
        if !validateData() {
            DispatchQueue.main.async {
                self.paymnetsModeTable.reloadData()
                Indicator.sharedInstance.hideIndicator()
            }
            return
        }
        let data = getDataForAPI()
        
        //Validate Data
        let cardAmount = Double(multicardAmount.roundToTwoDecimal) ?? 0.0
        var totalAmount = Double(grandTotalAmount.roundToTwoDecimal) ?? 0.0
        
        if totalAmount < 0 {
            self.showAlert(message: "Payment Amount is less than total.")
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        if HomeVM.shared.MultiTipValue > 0 {
            totalAmount = totalAmount - HomeVM.shared.tipValue
        }
        
        if cardAmount < totalAmount {
            //If No Payment card Added
            if tableData.count == 0 {
                self.showAlert(message: "Please add any Payment Card.")
                Indicator.sharedInstance.hideIndicator()
                return
            }
            if customError.count == 0 {
                self.showAlert(message: "Payment Amount is less than total.")
                Indicator.sharedInstance.hideIndicator()
            }
            self.showAlert(message: "Payment Amount is less than total.")
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        
        if let _ = tableData.index(where: {(Double((($0 as JSONDictionary)["amount"] as? String ?? "-1"))) == 0}), totalAmount > 0 {
            self.showAlert(message: "Pay able amount should be greater than zero.")
            Indicator.sharedInstance.hideIndicator()
            return
        }
        
        delegate?.getPaymentData?(with: data)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            Indicator.sharedInstance.showIndicator()
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func reset() {
        self.view.endEditing(true)
        loadData()
        selectedYear = ""
        upadateMonthArray()
        self.resetMulticardData()
        self.paymnetsModeTable.contentOffset = .zero
        totalAmount = 0
        _ = self.setTotal(amount: 0.0)
        
        tableData.removeAll()
        totalAmount += TempAmount
        if tableData.count == 0 {
            ChangeDueAmount = 0.0
            lbl_ChangeDue.text = "$0.00"
        }
        
        self.selectedIndexPath = nil
        self.filledCellIndex.removeAll()
        self.customError.removeAll()
        self.paymnetsModeTable.reloadData()
        self.updateTipTotal()
        disableValidateToChangeColor()
    }
}

//MARK: API Methods
extension MultiCardContainerViewController {
    func callAPItoVoidTransaction(paramneters: JSONDictionary,index: Int, sender:UIButton) {
        OrderVM.shared.voidRefundTransaction(parameters: paramneters, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.voidTransaction = OrderVM.shared.transactionVoidData
                let message = self.voidTransaction.message
//                self.showAlert(title: kAlert, message: message, otherButtons: nil, cancelTitle: kOkay, cancelAction: { (_) in
                    self.tableData[index].removeValue(forKey: "txnID")
                    self.tableData[index].removeValue(forKey: "orderID")
                    self.tableData[index].removeValue(forKey: "userID")
                    self.tableData[index].removeValue(forKey: "type")
                    self.tableData[index].removeValue(forKey: "errorMessage")
                    self.tableData[index].removeValue(forKey: "isApproved")
                    
                    var tempError = [CustomError]()
                    
                    for error in self.customError {
                        if error.index != index {
                            tempError.append(error)
                        }
                    }
                    
                    self.customError = tempError
                    
                    if let i = self.filledCellIndex.firstIndex(where: {$0 == index}) {
                        self.filledCellIndex.remove(at: i)
                    }
                    
                    let amount = self.voidTransaction.balance_due
                    DataManager.cartData!["balance_due"] = Double(amount)!
                    HomeVM.shared.DueShared = Double(amount)!
                    
                    self.delegate?.balanceDueAfterVoid?(with: Double(amount)!)
                    
                    self.deleteAfterVoidFunction(Index: index, sender: sender)
                    
                    self.paymnetsModeTable.reloadData()
                appDelegate.showToast(message: message)
//                })
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
    
    func callAPItoGetRegionList() {
        HomeVM.shared.getRegionList { (success, message, error) in
            if success == 1 {
                self.array_RegionsList = HomeVM.shared.regionsList
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
    
    func callAPItoGetPAXDeviceList() {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        HomeVM.shared.getPaxDeviceList(responseCallBack: { (success, message, error) in
            if success == 1 {
                DispatchQueue.main.async {
                    self.reloadTable()
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                }
            }
            else {
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
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

//MARK: HieCORPickerDelegate
extension MultiCardContainerViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        switch pickerTextfield.tag {
        case 10:
            //pickerTextfield.text = "\(MM_Array[index])"
            strMonth = "\(MM_Array[index])"
            break
        case 20:
            //pickerTextfield.text = "\(YY_Array[index])"
            strYear = "\(YY_Array[index])"
            selectedYear = "\(YY_Array[index])"
            break
        case 30:
            pickerTextfield.text = "\(self.array_RegionsList[index].str_regionAbv)"
            break
        case 40:
            let array = HomeVM.shared.paxDeviceList.compactMap({$0.name})
            pickerTextfield.text = array[index]
            break
        default:
            break
        }
    }
    
    override func pickerViewDoneAction() {
        
        switch pickerTextfield.tag {
        case 10:
            
            let cell = pickerTextfield.superview?.superview?.superview as? CreditCardTableViewCell ?? pickerTextfield.superview?.superview?.superview?.superview as! CreditCardTableViewCell
            
            cell.ccExpMM.text = strMonth
            
            //pickerTextfield.text = "\(MM_Array[index])"
            break
        case 20:
            
            let cell = pickerTextfield.superview?.superview?.superview as? CreditCardTableViewCell ?? pickerTextfield.superview?.superview?.superview?.superview as! CreditCardTableViewCell
            
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            
            
            if strYear == "\(year)" {
                
                let month = calendar.component(.month, from: date)
                
                if strMonth != "" {
                    if month > Int(strMonth)! {
                        cell.ccExpMM.text = ""
                    }
                }
                
            }
            
            cell.ccExpyear.text = strYear
            selectedYear = strYear
            
            break
        default:
            break
        }
        
        pickerTextfield.resignFirstResponder()
    }
    
    override func pickerViewCancelAction() {
        let cell = pickerTextfield.superview?.superview?.superview as? CreditCardTableViewCell ?? pickerTextfield.superview?.superview?.superview?.superview as! CreditCardTableViewCell
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        
        
        if strYear == "\(year)" {
            
            let month = calendar.component(.month, from: date)
            
            if month > Int(strMonth)! {
                cell.ccExpMM.text = ""
            }
            
        }
        
        pickerTextfield?.resignFirstResponder()
    }
}

//MARK: SwipeAndSearchDelegate
extension MultiCardContainerViewController: SwipeAndSearchDelegate {
    func didGetCardDetail(number: String, month: String, year: String) {
        fillCardDetail(number: number, month: month, year: year)
    }
    
    func didUpdateDevice() {
        guard  let indexPathValue = selectedIndexPath else {
            return
        }
        
        tableData[indexPathValue.row]["isSwipedProperly"] = true as AnyObject
        DispatchQueue.main.async {
            self.paymnetsModeTable.reloadData()
        }
    }
    
    func noCardDetailFound() {
        guard  let indexPathValue = selectedIndexPath else {
            return
        }
        
        //        if let cardNumber = tableData[indexPathValue.row]["ccNo"] as? String, cardNumber == "" {
        tableData[indexPathValue.row]["isSwipedProperly"] = false as AnyObject
        //        }
        
        DispatchQueue.main.async {
            self.paymnetsModeTable.reloadData()
        }
    }
    
    func fillCardDetail(number: String, month: String, year: String) {
        self.view.endEditing(true)
        
        guard  let indexPathValue = selectedIndexPath else {
            return
        }
        
        tableData[indexPathValue.row]["isSwipedProperly"] = true as AnyObject
        
        let mode = tableData[indexPathValue.row]["index"] as? Int ?? 0
        
        switch mode {
        case 1:
            tableData[indexPathValue.row]["ccNo"] = number as AnyObject
            tableData[indexPathValue.row]["ccMM"] = month as AnyObject
            tableData[indexPathValue.row]["ccYear"] = year as AnyObject
            break
        case 5:
            tableData[indexPathValue.row]["ccNo"] = number as AnyObject
            break
        case 6:
            tableData[indexPathValue.row]["ccNo"] = number as AnyObject
            break
        case 9:
            tableData[indexPathValue.row]["ccNo"] = number as AnyObject
            break
        default: break
        }
        
        self.isCardNumberReceived = true
        
        
        DispatchQueue.main.async {
            self.paymnetsModeTable.reloadData {
                //Check For External Accessory
                if Keyboard._isExternalKeyboardAttached() {
                    SwipeAndSearchVC.shared.enableTextField()
                    self.callValidateToChangeColor()
                    return
                }
            }
        }
    }
}


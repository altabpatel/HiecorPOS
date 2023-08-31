//
//  MainSocketManager.swift
//  CustomerView
//
//  Created by Sudama dewda on 07/11/19.
//  Copyright © 2019 Hiecor. All rights reserved.
//

import Foundation
import SocketIO
import Alamofire

class MainSocketManager {
    var productsArray = [ProductsModel]()
    // var signArrayData = [SignatureDataModel]()
    static let shared = MainSocketManager()
    var saveSignArrayData = [SaveSignatureDataModel]()
    //let manager = SocketManager(socketURL: URL(string: DataManager.socketAppUrl)!, config: [.log(true), .compress])
    let manager = SocketManager(socketURL: URL(string: DataManager.socketAppUrl) ?? URL(string: "https://devb.hiecor.biz:3000")!, config: [.log(true), .compress])
    
    var socket:SocketIOClient!
    var auth_key = ""
    
    //MARK: Connect
    func connect() {
        guard DataManager.socketAppUrl != "" else {
            return
            
        }
        socket = manager.defaultSocket
        socket.connect()
    }
    
    //MARK: Disconnect
    func disconnect() {
        socket = manager.defaultSocket
        socket.disconnect()
    }
    
    //MARK: OnConnect
    func onConnect(handler: @escaping () -> Void) {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            handler()
        }
    }
    
    //MARK:  reset to first screen
    
    func onreset() {
        let param: [String: String] = ["room": DataManager.roomID,
                                       "session_id" : DataManager.sessionID]
        self.socket.emit("reset", with: [param])
    }
    
    //MARK: User Join Connection
    func userJoinOnConnect(deviceId: String) {
        let param: [String: String] = ["room": deviceId]
        self.socket.emit("room", with: [param])
    }
    
    //MARK: Join Handle
    func handleJoinData(roomID: String) {
        //        if let data = UserDefaults.standard.object(forKey: "auth_key") as? String {
        //            auth_key = data
        //        }
        var sourseName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        if DataManager.deviceNameText != nil {
            sourseName = DataManager.deviceNameText ?? ""
        }
        let param: Parameters = ["configData" :
            ["username": DataManager.userName,
             "auth_key" : DataManager.authKey,
             "agent_id": DataManager.userID,
             "api_end_point": "\(DataManager.baseUrl)/rest/v1/",
                "source": sourseName],
                                 "session_id": randomString(length: 8),
                                 "room" : roomID
        ]
        self.socket.emit("joined", with: [param])
    }
    
    //MARK: listener On close receipt page
    
    func onerrorRecieptModal(errorMessage: String) {
        let param: Parameters = ["room": DataManager.roomID,
                                 "error_message": errorMessage,
                                 "session_id" : DataManager.sessionID]
        self.socket.emit("receiptError", with: [param])
        
    }
    
    //MARK: listener On OrderProcessignloader
    
    func onOrderProcessignloader(paymentType: String) {
        let param: Parameters = ["room": DataManager.roomID,
                                 "payment_type": paymentType,
                                 "session_id" : DataManager.sessionID]
        self.socket.emit("orderProcessing", with: [param])
        
    }
    
    //MARK: listener On addtip
    
    func onAddTip(tip: String) {
        let param: Parameters = ["room": DataManager.roomID,
                                 "tip": tip,
                                 "session_id" : DataManager.sessionID]
        self.socket.emit("addTip", with: [param])
        
    }
    
    //MARK: PaymentError
    func onPaymentError(errorMessage: String) {
        let param: Parameters = ["room": DataManager.roomID,
                                 "error_message": errorMessage,
                                 "session_id" : DataManager.sessionID]
        self.socket.emit("paymentError", with: [param])
        
    }
    
    //MARK: paymentMesssage socket event
    func onPaymentMessage(paymentMesssage: String) {
        let param: Parameters = ["room": DataManager.roomID,
                                 "message": paymentMesssage,
                                 "session_id" : DataManager.sessionID]
        self.socket.emit("paymentMesssage", with: [param])
        
    }
    
    func onCartUpdate(Arr: Array<Any>, cartDataSocketModel: CartDataSocketModel, variationData:  [Int: Any]){
        var dict = [String: Any]()
        var productsArray = Array<Any>()
        
        if Arr.count > 0{
            for i in (0..<Arr.count) {
                let productsData = (Arr as AnyObject).object(at: i)
                dict["title"] = ((productsData as AnyObject).value(forKey: "producttitle")) as? String ?? ""
                dict["productprice"] = (((productsData as AnyObject).value(forKey: "productprice")) as? String ?? "").replacingOccurrences(of: ",", with: "")
                dict["man_price"] = (((productsData as AnyObject).value(forKey: "productprice")) as? String ?? "").replacingOccurrences(of: ",", with: "")
                dict["product_id"] = ((productsData as AnyObject).value(forKey: "productid")) as? String ?? ""
                dict["product_code"] = ((productsData as AnyObject).value(forKey: "productCode")) as? String ?? ""
                dict["long_description"] = ((productsData as AnyObject).value(forKey: "productdesclong")) as? String ?? ""
                dict["short_description"] = ((productsData as AnyObject).value(forKey: "productdescshort")) as? String ?? ""
                dict["product_image"] = ((productsData as AnyObject).value(forKey: "productimage")) as? String ?? ""
                dict["manual_description"] = ((productsData as AnyObject).value(forKey: "productNotes")) as? String ?? ""
                print(variationData)
                dict["cartSubTitle"] = variationData[i]//[["value": "blue", "key": "color"], ["value": "extratest2longtextfield", "key": "Extra"], ["value": "xxl", "key": "size"], ["value": "test long text field attribute1", "key": "Test"], ["value": "b", "key": "test1"]]
                let isAllowDecimal = (productsData as AnyObject).value(forKey: "qty_allow_decimal") as? Bool ?? false
                if isAllowDecimal{
                    dict["qty"] = Double((productsData as AnyObject).value(forKey: "productqty") as? String ?? "")?.roundToTwoDecimal
                }else{
                    dict["qty"] = ((productsData as AnyObject).value(forKey: "productqty") as? Double ?? 1)
                    dict["qty"] = Double((productsData as AnyObject).value(forKey: "productqty") as? String ?? "")
                }
                //dict["qty"] = ((productsData as AnyObject).value(forKey: "productqty") as? Double ?? 1)
                //dict["qty"] = Double((productsData as AnyObject).value(forKey: "productqty") as? String ?? "")
                dict["height"] = ((productsData as AnyObject).value(forKey: "height")) as? Double ?? 0.0
                dict["length"] = ((productsData as AnyObject).value(forKey: "length")) as? Double ?? 0.0
                dict["weight"] = ((productsData as AnyObject).value(forKey: "weight")) as? Double ?? 0.0
                
                productsArray.append(dict)
            }
            
        }
        
        
        let parameters: Parameters = [  "cartData": [
            "customTax": cartDataSocketModel.coupon,
            "products": productsArray,
             "customer": [ "cust_id": DataManager.customerId],
            "subTotal": cartDataSocketModel.subTotal,
            "discount": "",
            "manualDiscount": cartDataSocketModel.manualDiscount,
            "shippingAmount": cartDataSocketModel.shippingAmount,
            "tax": cartDataSocketModel.tax,
            "custom_tax_id": "",
            "couponDiscount" : cartDataSocketModel.couponDiscount,
            "coupon" : cartDataSocketModel.strAddCouponName,
            "total": cartDataSocketModel.total,
            "amount_paid":  HomeVM.shared.amountPaid,
            "balance_due": cartDataSocketModel.balance_due,
            "totalTip":  "\(HomeVM.shared.tipValue)"
            ],
                                        "room" : DataManager.roomID,
                                        "session_id" : DataManager.sessionID
        ]
        
        self.socket.emit("cartUpdate", with: [parameters])
    }
    
    //MARK: listener On open receipt page
    
    func onOpenRecieptModal(receiptModelForSocket: ReceiptModelForSocket) {
        
        let parameters: Parameters = [  "orderData": [
            "email": receiptModelForSocket.email,
            "phone": receiptModelForSocket.phone,
            "session_id": receiptModelForSocket.session_id,
            "change_due": receiptModelForSocket.change_due,
            "order_id": receiptModelForSocket.order_id,
            "payment_method": receiptModelForSocket.paymentMethod
            ],
                                        "room" : DataManager.roomID,
                                        "session_id" : DataManager.sessionID
        ]
        
        self.socket.emit("openRecieptModal", with: [parameters])
        
    }
    
    //MARK: listener ON siganture
    
    func onOpenSignature(signArry : NSMutableArray, subTotal: Double, total: Double, paxLoader: Bool) {
        var dict = [String: Any]()
        var signatureArray = Array<Any>()
        var tipFlag = false
        if signArry.count > 0{
            
            
            for i in (0..<signArry.count) {
                
                let productsData = (signArry as AnyObject).object(at: i)
                
                if let card = ((productsData as AnyObject).value(forKey: "card_number")) as? String {
                    if card == "EMV" {
                        dict["last4"] = card
                    }else if card == "Cash" || card == "Check" || card == "Internal Gift Card" || card == "External" || card == "External Gift Card" || card == "Gift Card" || card == "Ach Check"{
                        dict["last4"] = card
                        tipFlag = true
                    } else if card == "Ingenico" {
                        dict["last4"] = card
                    }else if card == "****" {
                        dict["last4"] = "EMV"
                    }else{
                        dict["last4"] = "**** **** **** \(card)"
                    }
                }
                dict["txn_id"] = ((productsData as AnyObject).value(forKey: "txn_id")) as? String ?? ""
                dict["tip"] =  Double(((productsData as AnyObject).value(forKey: "tipAmount")) as? String ?? "") ?? 0.00
                dict["paxNumber"] = ((productsData as AnyObject).value(forKey: "paxNumber")) as? String ?? ""
                //dict["TotalAmount"] = ((productsData as AnyObject).value(forKey: "TotalAmount")) as? String ?? ""
                
                signatureArray.append(dict)
            }
        }
        
        var tipEnable = DataManager.collectTips
        if DataManager.collectTips {
            if appDelegate.strPaxMode == "GIFT"{
                tipEnable = false
            }
        }
        if tipFlag {
            tipEnable = false
        }
        let parameters: Parameters = [  "signatureData": signatureArray,
                                        "tipEnable" : tipEnable, //HomeVM.shared.DueShared > 0 ? false : DataManager.collectTips,
            "signatureEnabled" : DataManager.signature,
            "paxOrderSignature": DataManager.isSingatureOnEMV,
            "showPaxLoader": paxLoader,
            "room" : DataManager.roomID,
            "session_id" : DataManager.sessionID,
            "paymentData" : [
                "total" : String(total),
                "tip" : 0,
                "tips" : [
                    "15": TipCal(subTotal: ((subTotal/100)*(15))),//((subTotal/100)*(15)).currencyFormatA,
                    "20": TipCal(subTotal: ((subTotal/100)*(20))),//((subTotal/100)*(20)).currencyFormatA,
                    "25": TipCal(subTotal: ((subTotal/100)*(25)))//((subTotal/100)*(25)).currencyFormatA,
                ]
            ]
        ]
        
        self.socket.emit("openSignaturePad", with: [parameters])
    }
    
    func TipCal(subTotal: Double) -> String{
        
        var tipDVal = subTotal
        var strT = "\(tipDVal)"
        var strIn = ""
        if let range = strT.range(of: ".") {
            let num = strT[range.upperBound...]
            print(num)
            strT = String(num)
        }
        
        strIn = strT[0 ..< 3]
        
        var newtipTotal = tipDVal.rounded(toPlaces: 3)
        
        let strLastDigitFive = strIn.last
        if strLastDigitFive == "5" {
            newtipTotal = newtipTotal + 0.001
            newtipTotal = newtipTotal.rounded(toPlaces: 2)
            tipDVal = newtipTotal
        }
        
       
        return (tipDVal + 0.0000011).currencyFormatA
    }
    
    //MARK: listener On OrderProcessignloader
    //    //MARK: Signatire emit for next button
    //    func emitSignature(signature: String, signIndex: Int) {
    //        let param: [String: Any] = ["room": DataManager.roomID,
    //                                       "index": signIndex,
    //                                       "signatureUrl": signature,
    //                                       "session_id": DataManager.sessionID]
    //
    //        self.socket.emit("signed", with: [param])
    //    }
    
    //MARK: emitConnectionResponse
    func emitConnectionResponse(handler: @escaping (_ joinData: JoinDataSocketModel) -> Void){
        socket.on("connectionResponse") { (data, ack) in
            
            let app = UIApplication.shared as? TimerApplication
            app?.resetIdleTimer()
            
            var joinModelObj = JoinDataSocketModel()
            print("connectionResponse")
            let AllData = data[0] as! [String: Any]
            joinModelObj.session_id = AllData["session_id"] as! String
            joinModelObj.response = AllData["response"] as! String
            handler(joinModelObj)
            
        }
    }
    //MARK: listener On close receipt page
    
    func oncloseRecieptModal() {
        
        let param: [String: String] = ["room": DataManager.roomID,
                                       "session_id": DataManager.sessionID]
        self.socket.emit("closeRecieptModal", with: [param])
    }
    
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    //
    //    //MARK: emitConnectionResponse
    //    func emitConnectionResponse(responseValue: String, sessionID: String){
    //
    //        let param: [String: String] = ["room": DataManager.roomID,
    //                                       "response": responseValue ,
    //                                       "session_id": sessionID]
    //        self.socket.emit("connectionResponse", with: [param])
    //
    //    }
    
    //MARK: Signatire emit for next button
    func emitSignature(handler: @escaping (_ signatureDataModelForSocket: SignatureDataModelForSocket) -> Void) {
        
        socket.on("signed") { (data, ack) in
            
            let app = UIApplication.shared as? TimerApplication
            app?.resetIdleTimer()
            
            var signatureDataModelObj = SignatureDataModelForSocket()
            print("signed")
            let AllData = data[0] as! [String: Any]
            signatureDataModelObj.sessionID = AllData["session_id"] as! String
            signatureDataModelObj.signData = AllData["signatureUrl"] as! String
            signatureDataModelObj.signIndex = AllData["index"] as! Int
            signatureDataModelObj.tip = AllData["tip"] as! String
            signatureDataModelObj.tipPercent = AllData["tipPercent"] as! Int
            
            handler(signatureDataModelObj)
            
        }
    }
    
    
    //MARK: Signatire emit for continue button
    func emitSignatureContinue(handler: @escaping (_ saveSignatureDataModel: [SaveSignatureDataModel], _ sid: String)-> Void) {
        if socket != nil {
            socket.on("saveSignature") { (data, ack) in
                
                let app = UIApplication.shared as? TimerApplication
                app?.resetIdleTimer()
                
                let AllData = data[0] as! [String: Any]
                let sId =  AllData["session_id"] as? String ?? ""
                if let arraySignData = (AllData as AnyObject).value(forKey: "signatureData") as? Array<Dictionary<String,AnyObject>> {
                    self.saveSignArrayData.removeAll()
                    if arraySignData.count > 0 {
                        var tempSignData = [SaveSignatureDataModel]()
                        for i in (0...arraySignData.count-1) {
                            let signData = (arraySignData as AnyObject).object(at: i)
                            var sigModellObj = SaveSignatureDataModel()
                            sigModellObj.sessionID =  AllData["session_id"] as? String ?? ""
                            sigModellObj.txn_id = ((signData as AnyObject).value(forKey: "txn_id")) as? String ?? ""
                            sigModellObj.dataUrl = ((signData as AnyObject).value(forKey: "dataUrl")) as? String ?? ""
                            sigModellObj.tip = ((signData as AnyObject).value(forKey: "tip")) as? String ?? ""
                            sigModellObj.cardNumber = ((signData as AnyObject).value(forKey: "card_number")) as? String ?? ""
                            sigModellObj.paxNumber = ((signData as AnyObject).value(forKey: "paxNumber")) as? String ?? ""
                            sigModellObj.totalAmount = ((signData as AnyObject).value(forKey: "TotalAmount")) as? String ?? ""
                            
                            tempSignData.append(sigModellObj)
                        }
                        self.saveSignArrayData.append(contentsOf: tempSignData)
                        
                        print(self.saveSignArrayData)
                    }
                }
                handler(self.saveSignArrayData, sId)
            }
        }
    }
    
    
    //MARK: emit Customer Number
    func  searchCustomerNumber(handler: @escaping  (_ searchCustomerForSocketObj: searchCustomerForSocket) -> Void) {
        socket.on("searchCustomer") { (data, ack) in
            
            let app = UIApplication.shared as? TimerApplication
            app?.resetIdleTimer()
            
            var searchCustomerForSocketObj = searchCustomerForSocket()
            print("searchCustomerCall")
            let AllData = data[0] as! [String: Any]
            searchCustomerForSocketObj.session_id = AllData["session_id"] as! String
            searchCustomerForSocketObj.phone = AllData["phone"] as! String
            //                   signatureDataModelObj.signIndex = AllData["indsession_idex"] as! Int
            handler(searchCustomerForSocketObj)
            
        }
        
    }
    
    //MARK: Customer Not Found
    
    func  onSearchPhoneNoError() {
        
        let param: [String: String] = ["room": DataManager.roomID,
                                       "message": "User not found." ,
                                       "session_id": DataManager.sessionID]
        self.socket.emit("cusomerNotFound", with: [param])
        
        
    }
    
    //MARK: Customer Found
    
    func onCustomerFound(CustomerId: String) {
        
        let param: [String: String] = ["room": DataManager.roomID,
                                       "userID": CustomerId ,
                                       "session_id": DataManager.sessionID]
        self.socket.emit("cusomerFound", with: [param])
    }
    
    //MARK: emit select Customer
    func emitselectCustomer(handler: @escaping  (_ selectCustomerForSocketObj: SelectCustomerForSocket) -> Void) {
        
        
        socket.on("selectCustomer") { (data, ack) in
            
            let app = UIApplication.shared as? TimerApplication
            app?.resetIdleTimer()
            
            var selectCustomerForSocketObj = SelectCustomerForSocket()
            print("selectCustomer")
            let AllData = data[0] as! [String: Any]
            selectCustomerForSocketObj.session_id = AllData["session_id"] as! String
            selectCustomerForSocketObj.userId = AllData["userID"] as! String
            // selectCustomerForSocketObj.room = AllData["room"] as! String
            handler(selectCustomerForSocketObj)
            
        }
    }
    
    //MARK: listener ON closeSignaturePad
    
    func onCloseSignature() {
        
        let param: [String: String] = ["room": DataManager.roomID,
                                       "session_id": DataManager.sessionID]
        self.socket.emit("closeSignaturePad", with: [param])
    }
    
    
    //MARK: emit select receipt option
    func emitselectRecieptOption(handler: @escaping  (_ selectRecieptOptionForSocketObj: selectRecieptOptionForSocket) -> Void) {
        
        //        let param: Parameters = ["orderData" :
        //            [
        //                "email": email ,
        //                "phone" : phoneNumber,
        //                "change_due": Double(receiptData.change_due) ?? 0,
        //                "order_id": receiptData.order_id,
        //                "reciept_type": reciept_type
        //            ],
        //                                 "session_id": DataManager.sessionID,
        //                                 "room": DataManager.roomID
        //        ]
        //        self.socket.emit("selectRecieptOption", with: [param])
        //
        
        socket.on("selectRecieptOption") { (data, ack) in
            
            let app = UIApplication.shared as? TimerApplication
            app?.resetIdleTimer()
            
            var selectRecieptOptionForSocketObj = selectRecieptOptionForSocket()
            let AllData = data[0] as! [String: Any]
            let configData = AllData["orderData"] as! [String: Any]
            selectRecieptOptionForSocketObj.email = (configData as AnyObject).value(forKey: "email") as? String ?? ""
            selectRecieptOptionForSocketObj.phone = (configData as AnyObject).value(forKey: "phone") as? String ?? ""
            selectRecieptOptionForSocketObj.session_id = (AllData as AnyObject).value(forKey: "session_id") as? String ?? ""
            selectRecieptOptionForSocketObj.change_due = (configData as AnyObject).value(forKey: "change_due") as? String ?? ""
           // selectRecieptOptionForSocketObj.order_id = (configData as AnyObject).value(forKey: "order_id") as? Double ?? 0
            if let odrer_id = ((configData as AnyObject).value(forKey: "order_id") as? String) {
                selectRecieptOptionForSocketObj.order_id = Double(odrer_id) ?? 0
            }else{
                selectRecieptOptionForSocketObj.order_id = (configData as AnyObject).value(forKey: "order_id") as? Double ?? 0
            }
           
            selectRecieptOptionForSocketObj.reciept_type = (configData as AnyObject).value(forKey: "reciept_type") as? String ?? ""
            handler(selectRecieptOptionForSocketObj)
            
        }
        
    }
}

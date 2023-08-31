//
//  OrderDataModal.swift
//  HieCOR
//
//  Created by Deftsoft on 21/08/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation

class OrdersHistoryList
{
    var order_id = String()
    var date_added = Double()
    var status = String()
    var total = String()
    var test_order = Int()
    var background_color = String()
}

class OrdersListModel
{
    var order_id = String()
    var date_added = String()
    var status = String()
    var total = String()
}

class OrderInfoModel
{
    var firstName = String()
    var lastName = String()
    var addressLine1 = String()
    var addressLine2 = String()
    var city = String()
    var region = String()
    var country = String()
    var postalCode = String()
    var email = String()
    var phone = String()
    var product_status = String()
    
    var shippingFirstName = String()
    var shippingLastName = String()
    var shippingAddressLine1 = String()
    var shippingAddressLine2 = String()
    var shippingCity = String()
    var shippingRegion = String()
    var shippingCountry = String()
    var shippingPostalCode = String()
    var shippingEmail = String()
    var shippingPhone = String()
    
    var invoiceDueDate = String()
    var invoiceDate = String()
    var invoiceterms = String()
    
    var orderDate = String()
    var orderID = String()
    var admin_comments = String()
    var merchantId = String()
    var transactionType = String()
    var cardHolderName = String()
    var saleLocation = String()
    var companyName = String()
    var appName = String()
    var approvalCode = String()
    var entryMethod = String()
    var paymentStatus = String()
    var userID = String()
    var bpId = String()
    var paymentMethod = String()
    var googleReceipturl = String()
    var payNowUrl = String()
    var status = String()
    var isBillingSame = Int()
    var changeDue = String()
    var balanceDue = String()
    var refundUrl = String()
    var showPayNow = String()
    var showRefundButton = String()
    var user_comments = String()
    var customer_status = String()
    var str_first_name = String()
    var str_last_name = String()
    var str_email = String()
    var str_phone = String()
    
    var cust_first_name = String()
    var cust_last_name = String()
    var cust_company_name = String()
    var cust_address1 = String()
    var cust_address2 = String()
    var cust_city = String()
    var cust_region = String()
    var cust_country = String()
    var cust_mailingList = [String]()
    var cust_customer1 = String()
    var cust_customer2 = String()
    
    var couponCode = String()
    var couponPrice = Double()
    var couponId = String()
    var couponTitle = String()
    
    var total = Double()
    var subTotal = Double()
    var discount = Double()
    var shipping = Double()
    var refundShippingAmount = Double()
    var tax = Double()
    var tip = Double()
    var customTax = String()
    var showRefundShipping = Bool()
    var showRefundTip = Bool()
    var isSubscription = Bool()
    var isProductReturn = Bool()
    var isshippingRefundSelected = Bool()
    var isTipRefundSelected = Bool()
    var productsArray = [ItemsDetailModel]()
    var OrderInfo_MetaFeilds_arr = [OrderInfoMetaFeildsModel]()
    var Exchange_Payment_Method_arr = [ExchangePaymentMethodModel]()
    var transactionArray = [TransactionsDetailModel]()
    var refundPaymentTypeArray = [String]()
    var paxDeviceListRefund = [PaxDevicesList]()
    var refundTransactionList = [RefundTransactionList]()
    
    var cardDetail: CardData?
    var isOrderRefund = Bool()
    var showSubscriptionsCancel = Bool()
    
    var showDateColumn = Bool()
    var showPosCustomerPickup = Bool()
    var agent = String()
    var po_number = String()
    var title = String()
    var showInvoiceUpdateButtonInPos = String()
    var updateInvoiceURL = String()
    var scheduled_date = String()
    var newProductArray = NSArray()
    var card_info = CardDataModel()
}

struct TransactionList {
    var id: String!
    var status: String!
    var date: String!
    var amount: String!
    var type: String!
}

class ItemsDetailModel
{
    var code = String()
    var status = String()
    var title = String()
    var qty = Double()
    var availableQtyRefund = Double()
    var price = Double()
    var wholesalePricce = Double()
    var mainPrice = Double()
    var refundAmount = Double()
    var isRefunded = Bool()
    var isExchanged = Bool()
    var isReturn = Bool()
    var isLineTaxExempt = Bool()
    var salesID = String()
    var productID = String()
    var image = String()
    var shippingPrice = String()
    var soldBy = String()
    var attribute = String()
    var metaFeildsStringValue = String()
    var product_condition = String()
    var man_desc = String()
    var isRefundSelected = Bool()
    var isshippingRefundSelected = Bool()
    var isExchangeSelected = Bool()
    var qtyAllowDecimal = Bool()
    var isTaxable = String()
    var paymentMethod = String()
    var mainDesc = String()
    var stock = String()
    var limit_qty = String()
    var unlimited_stock = String()
    var isEditPrice = Bool()
    var isEditQty = Bool()
    var perProductDiscount = Double()
    var perProductTax = Double()
    var date = String()
    var variations = JSONDictionary()
    var attributesData = JSONArray()
    var variationsData = JSONArray()
    var surchagevariationsData = JSONArray()
    var surchargeVariations = JSONDictionary()
    var selectedAttributesData = JSONArray()
    var meta_fieldsDictionary = JSONDictionary()
}

class TransactionsDetailModel
{
    
    //"recurring": "No",
    //"NAME": "Received",
    //"date_finalized": "2019-12-31 00:00:40",
    //"parent_merchant_transaction_id": "cash",
    //"transaction_status": null,
    //"transaction_amount": null,
    //"cardNumber": "************",
    //"last4": "",
    //"txnLabel": " TXN 106853 Cash $143.00"
    var txnLabel = String()
    var last4 = String()
    var cardNumber = String()
    var transaction_amount = String()
    var transaction_status = String()
    var parent_merchant_transaction_id = String()
    var date_finalized = String()
    var NAME = String()
    var recurring = String()
    var date = String()
    var dateAdded = String()
    var type = String()
    var txnId = String()
    var merchantTxnId = String()
    var approval = String()
    var authCode = String()
    var paymentType = String()
    var amount = Double()
    var userID = String()
    var orderId = String()
    var aiType = String()
    var merchantId = String()
    var merchant = String()
    var cardType = String()
    var refundAmount = Double()
    var availableRefundAmount = Double()
    var availableRefundAmountCopy = Double()
    var isRefund = Bool()
    var isVoid = Bool()
    var isFullRefundSelected = Bool()
    var isPartialRefundSelected = Bool()
    var isVoidSelected = Bool()
    var partialAmount = String()
    var manualPaymentType = String()    //Not for API use
    // changes by hiecor team
    var Payment_Method_arr = [PaymentMethodModel]()
    var selectPaymentIndex = Int()
    var isSelectedRefund = false
    var transactionGoogle_receipt_url = String()
    var test_order = Int()
    var show_pax_device = Bool()
}

class PaymentMethodModel {
    var label = String()
    var value = String()
}

class ExchangePaymentMethodModel {
    var label = String()
    var value = String()
    var isPaymentSelected = Bool()
}
class OrderInfoMetaFeildsModel {
    var label = String()
    var value = String()
    var name = String()
}

class RefundTransactionList {
    var card_type = String()
    var amount = String()
    var card_number = String()
    var txn_id = String()
    var date = String()
    var show_tip_button = Bool()
    var is_txn_type_EMV = Bool()
    var show_pax_device = Bool()
}

class PaxDevicesList {
    var pax_terminal_device_name = String()
    var pax_terminal_url =  String()
    var pax_terminal_port = String()
}

class TransactionsModel
{
    var txn_id = String()
    var merchant_txn_id = String()
    var approval = String()
    var amount = String()
    var userID = String()
    var order_id = String()
    var ai_type = String()
    var merchant_id = String()
    var date_added = String()
    var isRefund = Bool()
}

class TransactionInfoModel
{
    var txn_id = String()
    var merchant_transaction = String()
    var status = String()
    var amount = String()
    var userID = String()
    var order_id = String()
    var payment_type = String()
    var merchant_id = String()
    var merchant = String()
    var billing_profile_id = String()
    var date_added = String()
    var auth_code = String()
    var card_type = String()
}

class ConditionsForReturnModel
{
    var name = String()
    var id = String()
}

class RepresentativesListForInvoiceModel
{
    var display_name = String()
    var id = String()
}
class RefundOrderDataModel
{
    var order_id = String()
    var checkRefund = false
    var total = Double()
    var email = String()
    var userName = String()
    var phone = String()
    var userID = String()
    var payment_status = String()
    var refund_amount = Double()
    var refundedBy = [RefundedByDataModel]()
}

class VoidTransactionDataModel
{
    var message = String()
    var balance_due = String()
}
class RefundedByDataModel {
    var type = String()
    var amount = String()
}
struct OrderDeliveryStatus {
    var status_id = String()
    var name = String()
    var color = String()
    var isDisabled = Bool()
    var isSelected = Bool()
}
extension OrderVM {
    
    func parseOrderData(responseDict: JSONDictionary) {
        
        if let data = responseDict["data"] as? Dictionary<String, AnyObject>
        {
            self.totalRecord = data["total_records"] as? String ?? "0"
            
            if let arrayData = data["order_list"] as? Array<Dictionary<String, AnyObject>>
            {
                if arrayData.count>0
                {
                    self.isMoreOrderFound = true
                    for i in (0...arrayData.count-1)
                    {
                        let ordersData = (arrayData as AnyObject).object(at: i)
                        
                        let ordersModelObj = OrdersHistoryList()
                        ordersModelObj.order_id = ((ordersData as AnyObject).value(forKey: "order_id")) as? String ?? ""
                        ordersModelObj.total = (((ordersData as AnyObject).value(forKey: "total")) as? String ?? "").replacingOccurrences(of: ",", with: "")
                        ordersModelObj.status = ((ordersData as AnyObject).value(forKey: "status")) as? String ?? ""
                        ordersModelObj.test_order = ((ordersData as AnyObject).value(forKey: "test_order")) as? Int ?? 0
                        ordersModelObj.background_color = ((ordersData as AnyObject).value(forKey: "background_color")) as? String ?? ""
                        var dateInString = ((ordersData as AnyObject).value(forKey: "date_added")) as? String ?? ""
                        dateInString = dateInString.components(separatedBy: " ")[0]
                        
                        if let key = ordersList.index(where: {$0.key == dateInString}) {
                            var newValue = self.ordersList[key].value
                            newValue.append(ordersModelObj)
                            ordersList[dateInString] = newValue
                        }else {
                            ordersList[dateInString] = [ordersModelObj]
                        }
                    }
                }
                else
                {
                    self.isMoreOrderFound = false
                }
            }
        }
    }
    
    func parseOrderInfoData(responseDict: JSONDictionary) {
        self.orderInfo = OrderInfoModel()
        
        if let data = responseDict["data"] as? JSONDictionary {
            
            self.orderInfo.total = Double((data["total"] as? String ?? "").replacingOccurrences(of: ",", with: "")) ?? 0
            self.orderInfo.orderDate = data["date_added"] as? String ?? ""
            self.orderInfo.orderID = data["order_id"] as? String ?? ""
            self.orderInfo.admin_comments = data["admin_comments"] as? String ?? ""
            self.orderInfo.userID = data["userID"] as? String ?? ""
            self.orderInfo.bpId = data["billing_profile_id"] as? String ?? ""
            self.orderInfo.transactionType = data["transaction_type"] as? String ?? ""
            self.orderInfo.cardHolderName = data["card_holder_name"] as? String ?? ""
            self.orderInfo.saleLocation = data["source"] as? String ?? ""
            self.orderInfo.companyName = data["company"] as? String ?? ""
            self.orderInfo.appName = data["app_name"] as? String ?? ""
            self.orderInfo.approvalCode = data["approval_code"] as? String ?? ""
            self.orderInfo.entryMethod = data["entry_method"] as? String ?? ""
            self.orderInfo.paymentStatus = data["payment_status"] as? String ?? ""
            self.orderInfo.isOrderRefund = data["isOrderRefund"] as? Bool ?? false
            self.orderInfo.product_status = data["product_status"] as? String ?? ""
            self.orderInfo.status = data["status"] as? String ?? ""
            self.orderInfo.user_comments = data["user_comments"] as? String ?? ""
            
            self.orderInfo.str_first_name = data["first_name"] as? String ?? ""
            self.orderInfo.str_last_name = data["last_name"] as? String ?? ""
            self.orderInfo.str_email = data["email"] as? String ?? ""
            self.orderInfo.str_phone = data["phone"] as? String ?? ""
            
            self.orderInfo.subTotal = data["sub_total"] as? Double ?? 0
            self.orderInfo.discount = Double((data["discount"] as? String ?? "").replacingOccurrences(of: ",", with: "")) ?? 0
            self.orderInfo.shipping = Double((data["shipping"] as? String ?? "").replacingOccurrences(of: ",", with: "")) ?? 0
            self.orderInfo.refundShippingAmount = Double((data["refundShippingAmount"] as? String ?? "").replacingOccurrences(of: ",", with: "")) ?? 0
            self.orderInfo.tax = Double((data["tax"] as? String ?? "").replacingOccurrences(of: ",", with: "")) ?? 0
            self.orderInfo.tip = Double((data["tip"] as? String ?? "").replacingOccurrences(of: ",", with: "")) ?? 0
            self.orderInfo.isSubscription = data["isSubscription"] as? Bool ?? false
            self.orderInfo.showRefundShipping = data["showRefundShipping"] as? Bool ?? false
            self.orderInfo.showRefundTip = data["showRefundTip"] as? Bool ?? false
            self.orderInfo.isProductReturn = data["isProductReturn"] as? Bool ?? false
            self.orderInfo.merchantId = data["merchant_id"] as? String ?? ""
            self.orderInfo.paymentMethod = data["payment_method"] as? String ?? ""
            self.orderInfo.googleReceipturl = data["google_receipt_url"] as? String ?? ""
            self.orderInfo.customTax = data["cutomTaxId"] as? String ?? ""
            self.orderInfo.isBillingSame = data["isBillingSame"] as? Int ?? 0
            self.orderInfo.customer_status = data["customer_status"] as? String ?? ""
            self.orderInfo.changeDue = data["change_due"] as? String ?? ""
            self.orderInfo.balanceDue = data["balance_due"] as? String ?? ""
            self.orderInfo.payNowUrl = data["pay_now_url"] as? String ?? ""
            self.orderInfo.refundUrl = data["refund_url"] as? String ?? ""
            self.orderInfo.showPayNow = data["show_pay_now"] as? String ?? ""
            self.orderInfo.showRefundButton = data["show_refund_button"] as? String ?? ""
            self.orderInfo.showSubscriptionsCancel = data["show_subscriptions_cancel"] as? Bool ?? false

            self.orderInfo.showDateColumn = data["showDateColumn"] as? Bool ?? false
            self.orderInfo.showPosCustomerPickup = data["showPosCustomerPickup"] as? Bool ?? false
            self.orderInfo.showInvoiceUpdateButtonInPos = data["showInvoiceUpdateButtonInPos"] as? String ?? ""
            self.orderInfo.updateInvoiceURL = data["updateInvoiceURL"] as? String ?? ""
            self.orderInfo.scheduled_date = data["scheduled_date"] as? String ?? ""
            if let agent = data["agent"] as? String {
                self.orderInfo.agent = agent
            }
            if let po_number = data["po_number"] as? String {
                self.orderInfo.po_number = po_number
            }
            if let title = data["title"] as? String {
                self.orderInfo.title = title
            }
//            self.orderInfo.agent = data["agent"] as? String ?? ""
//            self.orderInfo.po_number = data["po_number"] as? String ?? ""
//            self.orderInfo.title = data["title"] as? String ?? ""
            print(self.orderInfo.googleReceipturl)
            
            if let array = data["paxDevices"] as? NSArray {
                for item in array {
                    let pax = PaxDevicesList()
                    if let dict = item as? NSDictionary {
                        pax.pax_terminal_device_name = dict.value(forKey: "pax_terminal_device_name") as? String ?? ""
                        pax.pax_terminal_url = dict.value(forKey: "pax_terminal_url") as? String ?? ""
                        pax.pax_terminal_port = dict.value(forKey: "pax_terminal_port") as? String ?? ""
                        orderInfo.paxDeviceListRefund.append(pax)
                        print(orderInfo.paxDeviceListRefund.count)
                    }
                }
            }
            
            
            let cardType = (data["card_type"] as? String ?? "").lowercased()
            
            //if cardType == "credit" || cardType == "visa" || cardType == "credit card" || cardType == "credit_card" || cardType == "mast" {
                if let cardDict = data["card_information"] as? JSONDictionary {
                    var cardDetail = CardData()
                    if cardDict["last4"] as? String ?? "" != "" {
                        cardDetail.number = cardDict["last4"] as? String ?? ""
                        cardDetail.year = cardDict["card_exp_yr"] as? String ?? ""
                        cardDetail.month = cardDict["card_exp_mo"] as? String ?? ""
                        self.orderInfo.cardDetail = cardDetail
                    }
                }
            if let cardDict = data["card_info"] as? JSONDictionary {
                var cardDetail = CardDataModel()
                if cardDict["last4"] as? String ?? "" != "" {
                    cardDetail.cardNumber = cardDict["last4"] as? String ?? ""
                    cardDetail.year = cardDict["card_exp_yr"] as? String ?? ""
                    cardDetail.month = cardDict["card_exp_mo"] as? String ?? ""
                    cardDetail.bpId = cardDict["bpID"] as? String ?? ""
                    cardDetail.type = cardDict["type"] as? String ?? ""
                    self.orderInfo.card_info = cardDetail
                }
            }
            
            //}
            
            
            
            if let array = data["transactions"] as? NSArray {
                //self.orderInfo.transactionArray.removeAll()
                for item in array {
                    if let dict = item as? NSDictionary {
                        let transactions = TransactionsDetailModel()
                        
                        transactions.recurring = dict.value(forKey: "recurring") as? String ?? ""
                        transactions.NAME = dict.value(forKey: "NAME") as? String ?? ""
                        transactions.date_finalized = dict.value(forKey: "date_finalized") as? String ?? ""
                        transactions.parent_merchant_transaction_id = dict.value(forKey: "parent_merchant_transaction_id") as? String ?? ""
                        transactions.transaction_status = dict.value(forKey: "transaction_status") as? String ?? ""
                        transactions.transaction_amount = dict.value(forKey: "transaction_amount") as? String ?? ""
                        transactions.cardNumber = dict.value(forKey: "cardNumber") as? String ?? ""
                        transactions.last4 = dict.value(forKey: "last4") as? String ?? ""
                        transactions.txnLabel = dict.value(forKey: "txnLabel") as? String ?? ""
                        transactions.txnId = dict.value(forKey: "transaction_id") as? String ?? ""
                        transactions.merchantTxnId = dict.value(forKey: "merchant_txn_id") as? String ?? ""
                        transactions.approval = dict.value(forKey: "approval") as? String ?? ""
                        transactions.amount = Double((dict.value(forKey: "amount") as? String ?? "").replacingOccurrences(of: ",", with: "")) ?? 0
                        transactions.userID = dict.value(forKey: "userID") as? String ?? ""
                        transactions.orderId = dict.value(forKey: "order_id") as? String ?? ""
                        transactions.aiType = dict.value(forKey: "ai_type") as? String ?? ""
                        transactions.merchantId = dict.value(forKey: "merchant_id") as? String ?? ""
                        transactions.merchant = dict.value(forKey: "merchant") as? String ?? ""
                        transactions.authCode = dict.value(forKey: "auth_code") as? String ?? ""
                        transactions.cardType = dict.value(forKey: "card_type") as? String ?? ""
                        transactions.refundAmount = dict.value(forKey: "refund_amount") as? Double ?? 0
                        transactions.availableRefundAmount = dict.value(forKey: "amount_available_for_refund") as? Double ?? 0
                        transactions.availableRefundAmountCopy = dict.value(forKey: "amount_available_for_refund") as? Double ?? 0
                        transactions.isRefund = dict.value(forKey: "isRefund") as? Bool ?? false
                        transactions.isVoid = dict.value(forKey: "isVoid") as? Bool ?? false
                        transactions.type = dict.value(forKey: "transaction_type") as? String ?? ""
                        transactions.date = dict.value(forKey: "transaction_date") as? String ?? ""
                        transactions.dateAdded = dict.value(forKey: "date_added") as? String ?? ""
                        transactions.paymentType = dict.value(forKey: "payment_status") as? String ?? ""
                        transactions.show_pax_device = dict.value(forKey: "show_pax_device") as? Bool ?? false
                        
                        if let PaymentArray = (dict as AnyObject).value(forKey: "payment_methods") as? NSArray {
                            for i in 0..<PaymentArray.count {
                                if let dictvar = PaymentArray[i] as? NSDictionary {
                                    print(dictvar)
                                    let value = dictvar.value(forKey: "value") as? String ?? ""
                                    
                                    if transactions.type == value {
                                        transactions.selectPaymentIndex = i
                                    }
                                }
                            }
                            
                            for tempdict in PaymentArray {
                                let array_PaymentMethodModel = PaymentMethodModel()
                                if let dictvar = tempdict as? NSDictionary {
                                    print(dictvar)
                                    array_PaymentMethodModel.value = dictvar.value(forKey: "value") as? String ?? ""
                                    print(array_PaymentMethodModel.value)
                                    
                                    array_PaymentMethodModel.label = dictvar.value(forKey: "label") as? String ?? ""
                                    print(array_PaymentMethodModel.label)
                                    
                                    transactions.Payment_Method_arr.append(array_PaymentMethodModel)
                                }
                            }
                        }
                        
                        self.orderInfo.transactionArray.append(transactions)
                    }
                }
            }
            
            if let array = data["refund_payment"] as? NSArray {
                for item in array {
                    if let type = item as? String {
                        orderInfo.refundPaymentTypeArray.append(type)
                    }
                }
            }
            
            if let couponData = data["coupon_applied"] as? JSONDictionary {
                self.orderInfo.couponCode = couponData["code"] as? String ?? ""
                self.orderInfo.couponPrice = couponData["price"] as? Double ?? 0
                self.orderInfo.couponId = couponData["coupon_id"] as? String ?? ""
                self.orderInfo.couponTitle = couponData["title"] as? String ?? ""
            }
            
            if let array = data["refundPaymentMethods"] as? NSArray {
                refundPaymentMethods.removeAll()
                for item in array {
                    if let type = item as? String {
                        refundPaymentMethods.append(type)
                        print("refundPaymentMethods :- "+type)
                    }
                }
            }
            
            //---------------------- Start exchange_payment_method ------------------//
            
            if let array = data["exchange_payment_method"] as? NSArray {
                for item in array {
                    if let dict = item as? NSDictionary {
                        let itemObj = ExchangePaymentMethodModel()
                        itemObj.label = dict.value(forKey: "label") as? String ?? ""
                        itemObj.value = dict.value(forKey: "value") as? String ?? ""
                        self.orderInfo.Exchange_Payment_Method_arr.append(itemObj)
                    }
                }
            }
            if DataManager.selectedPayment != nil {
                self.orderInfo.Exchange_Payment_Method_arr.removeAll()
                for itemData in DataManager.selectedPayment! {
                    if let dict = itemData as? String {
                        let itemObj = ExchangePaymentMethodModel()
                        itemObj.label = dict as? String ?? ""
                        itemObj.value = dict.lowercased() as? String ?? ""
                        self.orderInfo.Exchange_Payment_Method_arr.append(itemObj)
                    }
                }
            }
            
            
            //---------------------- End exchange_payment_method ------------------//
            
            
            //---------------------- Start refundTransactionList ------------------//
            
            if let array = data["refundTransactionList"] as? NSArray {
                for item in array {
                    if let dict = item as? NSDictionary {
                        let itemObj = RefundTransactionList()
                        itemObj.card_type = dict.value(forKey: "card_type") as? String ?? ""
                        itemObj.card_number = dict.value(forKey: "card_number") as? String ?? ""
                        itemObj.show_tip_button = dict.value(forKey: "show_tip_button") as? Bool ?? false
                        itemObj.is_txn_type_EMV = dict.value(forKey: "is_txn_type_EMV") as? Bool ?? false
                        itemObj.amount = dict.value(forKey: "amount") as? String ?? ""
                        itemObj.txn_id = dict.value(forKey: "txn_id") as? String ?? ""
                        itemObj.date = dict.value(forKey: "date_added") as? String ?? ""
                        itemObj.show_pax_device = dict.value(forKey: "show_pax_device") as? Bool ?? false
                        self.orderInfo.refundTransactionList.append(itemObj)
                    }
                }
            }
            
            //---------------------- End refundTransactionList ------------------//
            
            
            if let array = data["contents"] as? NSArray {
                self.orderInfo.newProductArray = array
                for item in array {
                    if let dict = item as? NSDictionary {
                        let itemObj = ItemsDetailModel()
                        
                        itemObj.status = dict.value(forKey: "product_status") as? String ?? ""
                        itemObj.isExchanged = itemObj.status == "Exchanged"
                        itemObj.isRefunded = itemObj.status == "Refunded"
                        
                        itemObj.code = dict.value(forKey: "code") as? String ?? ""
                        itemObj.title = dict.value(forKey: "title") as? String ?? ""
                        
                        if let valOne = dict.value(forKey: "available_qty_refund") as? Double {
                            itemObj.availableQtyRefund = dict.value(forKey: "available_qty_refund") as? Double ?? 0
                        } else {
                            itemObj.availableQtyRefund = Double(dict.value(forKey: "available_qty_refund") as? String ?? "") ?? 0
                        }
                        
                        if let val = dict.value(forKey: "qty") as? Double {
                            itemObj.qty = dict.value(forKey: "qty") as? Double ?? 0
                        } else {
                            itemObj.qty = Double(dict.value(forKey: "qty") as? String ?? "") ?? 0
                        }
                        
                        //itemObj.qty = (dict.value(forKey: "qty") as? String ?? "0").toDouble()?.rounded(toPlaces: 2) ?? 0.0
                        itemObj.price = dict.value(forKey: "price") as? Double ?? 0
                        itemObj.mainPrice = dict.value(forKey: "man_price") as? Double ?? 0
                        itemObj.refundAmount = dict.value(forKey: "refund_amount") as? Double ?? 0
                        itemObj.isReturn = dict.value(forKey: "product_return") as? Bool ?? false
                        itemObj.isLineTaxExempt = dict.value(forKey: "tax_exempt") as? Bool ?? false
                        itemObj.isEditPrice = (dict.value(forKey: "prompt_for_price") as? String ?? "0") == "1"
                        itemObj.isEditQty = (dict.value(forKey: "prompt_for_quantity") as? String ?? "0") == "1"
                        itemObj.perProductDiscount = dict.value(forKey: "per_product_discount") as? Double ?? 0
                        itemObj.perProductTax = dict.value(forKey: "per_product_tax") as? Double ?? 0
                        
                        itemObj.salesID = String(describing: (dict.value(forKey: "sales_id") as? String ?? ""))
                        itemObj.productID = dict.value(forKey: "product_id") as? String ?? ""
                        itemObj.image = dict.value(forKey: "image") as? String ?? ""
                        itemObj.isTaxable = dict.value(forKey: "is_taxable") as? String ?? ""
                        itemObj.shippingPrice = dict.value(forKey: "shipping_price") as? String ?? ""
                        //itemObj.shippingPrice = dict.value(forKey: "shipping") as? String ?? ""
                        itemObj.mainDesc = dict.value(forKey: "man_desc") as? String ?? ""
                        itemObj.soldBy = dict.value(forKey: "sold_by") as? String ?? ""
                        itemObj.attribute = dict.value(forKey: "attr_id") as? String ?? ""
                        itemObj.man_desc = dict.value(forKey: "man_desc") as? String ?? ""
                        itemObj.qtyAllowDecimal = (dict.value(forKey: "qty_allow_decimal") as? String ?? "0") == "1"
                        itemObj.stock = dict.value(forKey: "stock") as? String ?? ""
                        itemObj.limit_qty = dict.value(forKey: "limit_qty") as? String ?? ""
                        itemObj.unlimited_stock = dict.value(forKey: "unlimited_stock") as? String ?? ""
                        itemObj.attributesData = dict.value(forKey: "product_attributes") as? JSONArray ?? JSONArray()      //DD
                        itemObj.variationsData = dict.value(forKey: "product_variations") as? JSONArray ?? JSONArray()
                        itemObj.surchagevariationsData = dict.value(forKey: "product_surcharge") as? JSONArray ?? JSONArray()    //DD
                        itemObj.selectedAttributesData = dict.value(forKey: "selectedAttributes") as? JSONArray ?? JSONArray()
                        itemObj.date = dict.value(forKey: "date") as? String ?? ""
                        itemObj.product_condition = dict.value(forKey: "product_condition") as? String ?? ""
                        /*var variations = JSONDictionary()
                         var attributesData = JSONArray()
                         var variationsData = JSONArray()
                         var surchagevariationsData = JSONArray()
                         var surchargeVariations = JSONDictionary()*/
                        //---------------------- Start meta feilds data model numer serial number ------------------//
                        var str = ""
                        var index = 0
                        var strMetaField = ""
                        var metaFieldDict = JSONDictionary()
                        if let array = dict["meta_fields"] as? NSArray {
                            for item in array {
                                
                                if let dict = item as? NSDictionary {
                                    let itemObj = OrderInfoMetaFeildsModel()
                                    itemObj.label = dict.value(forKey: "label") as? String ?? ""
                                    itemObj.value = dict.value(forKey: "value") as? String ?? ""
                                    itemObj.name = dict.value(forKey: "name") as? String ?? ""
                                    self.orderInfo.OrderInfo_MetaFeilds_arr.append(itemObj)
                                    if index == 0 {
                                        str.append("\(itemObj.label + ": " + itemObj.value)")
                                        metaFieldDict[itemObj.name] = itemObj.value
                                    }else{
                                        str.append(",\(itemObj.label + ": " + itemObj.value)")
                                        metaFieldDict[itemObj.name] = itemObj.value
                                    }
                                    index = index + 1
                                }
                            }
                        }
                        itemObj.metaFeildsStringValue = str
                        itemObj.meta_fieldsDictionary = metaFieldDict
                        //---------------------- End Start meta feilds data model numer serial number ------------------//
                        
                        
                        self.orderInfo.productsArray.append(itemObj)
                    }
                }
            }
            
            if let invoiceInfo = data["invoice_info"]as? Dictionary<String, AnyObject>
            {
                self.orderInfo.invoiceDate = ((invoiceInfo as AnyObject).value(forKey: "invoiceDate")) as? String ?? ""
                self.orderInfo.invoiceDueDate = ((invoiceInfo as AnyObject).value(forKey: "duedate")) as? String ?? ""
                self.orderInfo.invoiceterms = ((invoiceInfo as AnyObject).value(forKey: "terms")) as? String ?? ""
                
            }
            
            if let shippingAddress = data["shipping_addr"]as? Dictionary<String, AnyObject>
            {
                self.orderInfo.shippingFirstName = ((shippingAddress as AnyObject).value(forKey: "first_name")) as? String ?? ""
                self.orderInfo.shippingLastName = ((shippingAddress as AnyObject).value(forKey: "last_name")) as? String ?? ""
                self.orderInfo.shippingCity = ((shippingAddress as AnyObject).value(forKey: "city")) as? String ?? ""
                self.orderInfo.shippingRegion = ((shippingAddress as AnyObject).value(forKey: "region")) as? String ?? ""
                self.orderInfo.shippingCountry = ((shippingAddress as AnyObject).value(forKey: "country")) as? String ?? ""
                self.orderInfo.shippingAddressLine1 = ((shippingAddress as AnyObject).value(forKey: "address_line_1")) as? String ?? ""
                self.orderInfo.shippingAddressLine2 = ((shippingAddress as AnyObject).value(forKey: "address_line_2")) as? String ?? ""
                self.orderInfo.shippingPostalCode = ((shippingAddress as AnyObject).value(forKey: "postal_code")) as? String ?? ""
                self.orderInfo.shippingEmail = ((shippingAddress as AnyObject).value(forKey: "email")) as? String ?? ""
                self.orderInfo.shippingPhone = ((shippingAddress as AnyObject).value(forKey: "phone")) as? String ?? ""
            }
            
            if let shippingAddress = data["billing_addr"]as? Dictionary<String, AnyObject>
            {
                self.orderInfo.firstName = ((shippingAddress as AnyObject).value(forKey: "first_name")) as? String ?? ""
                self.orderInfo.lastName = ((shippingAddress as AnyObject).value(forKey: "last_name")) as? String ?? ""
                self.orderInfo.city = ((shippingAddress as AnyObject).value(forKey: "city")) as? String ?? ""
                self.orderInfo.region = ((shippingAddress as AnyObject).value(forKey: "region")) as? String ?? ""
                self.orderInfo.country = ((shippingAddress as AnyObject).value(forKey: "country")) as? String ?? ""
                self.orderInfo.addressLine1 = ((shippingAddress as AnyObject).value(forKey: "address_line_1")) as? String ?? ""
                self.orderInfo.addressLine2 = ((shippingAddress as AnyObject).value(forKey: "address_line_2")) as? String ?? ""
                self.orderInfo.postalCode = ((shippingAddress as AnyObject).value(forKey: "postal_code")) as? String ?? ""
                self.orderInfo.phone = ((shippingAddress as AnyObject).value(forKey: "phone")) as? String ?? ""
                self.orderInfo.email = ((shippingAddress as AnyObject).value(forKey: "email")) as? String ?? ""
            }
            
            if let CustomerAddress = data["customer_info"]as? Dictionary<String, AnyObject>
            {
                self.orderInfo.cust_first_name = ((CustomerAddress as AnyObject).value(forKey: "first_name")) as? String ?? ""
                self.orderInfo.cust_last_name = ((CustomerAddress as AnyObject).value(forKey: "last_name")) as? String ?? ""
                self.orderInfo.cust_company_name = ((CustomerAddress as AnyObject).value(forKey: "company")) as? String ?? ""
                self.orderInfo.cust_address1 = ((CustomerAddress as AnyObject).value(forKey: "address")) as? String ?? ""
                self.orderInfo.cust_address2 = ((CustomerAddress as AnyObject).value(forKey: "address2")) as? String ?? ""
                self.orderInfo.cust_city = ((CustomerAddress as AnyObject).value(forKey: "city")) as? String ?? ""
                self.orderInfo.cust_region = ((CustomerAddress as AnyObject).value(forKey: "region")) as? String ?? ""
                self.orderInfo.cust_country = ((CustomerAddress as AnyObject).value(forKey: "country")) as? String ?? ""
                self.orderInfo.cust_customer1 = ((CustomerAddress as AnyObject).value(forKey: "custom_text_1")) as? String ?? ""
                self.orderInfo.cust_customer2 = ((CustomerAddress as AnyObject).value(forKey: "custom_text_2")) as? String ?? ""
                self.orderInfo.email = ((CustomerAddress as AnyObject).value(forKey: "email")) as? String ?? ""
                
                orderInfo.cust_mailingList.removeAll()
                if let arraymailing = CustomerAddress["mailing_list"] as? NSArray {
                    for item in arraymailing {
                        if let type = item as? String {
                            orderInfo.cust_mailingList.append(type)
                        }
                    }
                }
            }
            
        }
    }
    
    func parseTransactionInfoData(responseDict: JSONDictionary) {
        self.transactionInfoArray = [TransactionsDetailModel]()
        
        if let data = responseDict["data"] as? JSONDictionary {
            if let array = data["transactionList"] as? NSArray {
                for item in array {
                    if let dict = item as? NSDictionary {
                        let transactions = TransactionsDetailModel()
                        
                        transactions.txnId = dict.value(forKey: "txn_id") as? String ?? ""
                        transactions.merchantTxnId = dict.value(forKey: "merchant_txn_id") as? String ?? ""
                        transactions.approval = dict.value(forKey: "approval") as? String ?? ""
                        transactions.amount = Double((dict.value(forKey: "amount") as? String ?? "").replacingOccurrences(of: ",", with: "")) ?? 0
                        transactions.userID = dict.value(forKey: "userID") as? String ?? ""
                        transactions.orderId = dict.value(forKey: "order_id") as? String ?? ""
                        transactions.aiType = dict.value(forKey: "ai_type") as? String ?? ""
                        transactions.merchantId = dict.value(forKey: "merchant_id") as? String ?? ""
                        transactions.merchant = dict.value(forKey: "merchant") as? String ?? ""
                        transactions.authCode = dict.value(forKey: "auth_code") as? String ?? ""
                        transactions.cardType = dict.value(forKey: "card_type") as? String ?? ""
                        transactions.refundAmount = dict.value(forKey: "refund_amount") as? Double ?? 0
                        transactions.availableRefundAmount = dict.value(forKey: "amount_available_for_refund") as? Double ?? 0
                        transactions.availableRefundAmountCopy = dict.value(forKey: "amount_available_for_refund") as? Double ?? 0

                        transactions.isRefund = dict.value(forKey: "isRefund") as? Bool ?? false
                        transactions.isVoid = dict.value(forKey: "isVoid") as? Bool ?? false
                        transactions.type = dict.value(forKey: "transaction_type") as? String ?? ""
                        transactions.date = dict.value(forKey: "transaction_date") as? String ?? ""
                        transactions.dateAdded = dict.value(forKey: "date_added") as? String ?? ""
                        transactions.paymentType = dict.value(forKey: "payment_status") as? String ?? ""
                        transactions.authCode = dict.value(forKey: "auth_code") as? String ?? ""
                        transactions.transactionGoogle_receipt_url = dict.value(forKey: "google_receipt_url") as? String ?? ""
                        //-======************------------***********
                        transactions.test_order = dict.value(forKey: "test_order") as? Int ?? 0
                        //=-----------*****************_------------******

                        
                        self.transactionInfoArray.append(transactions)
                    }
                }
            }
        }
    }
    
    func parseReturnConditionData(responseDict: JSONDictionary) {
        self.returnConditions = [ConditionsForReturnModel]()
        if let arrayData:Array = responseDict["data"] as? Array<AnyObject>
        {
            if arrayData.count>0
            {
                for i in (0...arrayData.count-1)
                {
                    let conditionsdata = (arrayData as AnyObject).object(at: i)
                    let conditionsModelObj = ConditionsForReturnModel()
                    conditionsModelObj.id = ((conditionsdata as AnyObject).value(forKey: "id")) as? String ?? "0"
                    conditionsModelObj.name = ((conditionsdata as AnyObject).value(forKey: "name")) as? String ?? ""
                    
                    self.returnConditions.append(conditionsModelObj)
                }
            }
        }
    }
    
    func parseDrawerHistoryData(responseDict: JSONDictionary) {
        self.drawerHistory = [DrawerHistoryModel]()
        //        if let arrayData:Array = responseDict["data"] as? NSArray as! Array
        //        {
        //            if arrayData.count>0
        //            {
        //                for i in (0...arrayData.count-1)
        //                {
        //                    let conditionsdata = (arrayData as AnyObject).object(at: i)
        //                    let conditionsModelObj = DrawerHistoryModel()
        //                    conditionsModelObj.end_time = ((conditionsdata as AnyObject).value(forKey: "end_time")) as? String ?? ""
        //                    conditionsModelObj.closed = ((conditionsdata as AnyObject).value(forKey: "end_time")) as? String ?? ""
        //                    conditionsModelObj.started = ((conditionsdata as AnyObject).value(forKey: "started")) as? String ?? ""
        //                    conditionsModelObj.starting_cash = ((conditionsdata as AnyObject).value(forKey: "starting_cash")) as? String ?? ""
        //                    conditionsModelObj.actualin_drawer = ((conditionsdata as AnyObject).value(forKey: "actualin_drawer")) as? String ?? ""
        //                    conditionsModelObj.expected_in_drawer = ((conditionsdata as AnyObject).value(forKey: "expected_in_drawer")) as? String ?? ""
        //                    conditionsModelObj.drawer_difference = ((conditionsdata as AnyObject).value(forKey: "drawer_difference")) as? String ?? ""
        //                    conditionsModelObj.paid_in = ((conditionsdata as AnyObject).value(forKey: "pay_in")) as? String ?? ""
        //                    conditionsModelObj.paid_out = ((conditionsdata as AnyObject).value(forKey: "pay_out")) as? String ?? ""
        //                    conditionsModelObj.cash_sales = ((conditionsdata as AnyObject).value(forKey: "cash_sales")) as? String ?? ""
        //                    conditionsModelObj.cash_refunds = ((conditionsdata as AnyObject).value(forKey: "cash_refunds")) as? String ?? ""
        //                    conditionsModelObj.drawer_desc = ((conditionsdata as AnyObject).value(forKey: "drawer_desc")) as? String ?? ""
        //                    conditionsModelObj.drawer_id = ((conditionsdata as AnyObject).value(forKey: "drawer_id")) as? String ?? ""
        //                    conditionsModelObj.user_name = ((conditionsdata as AnyObject).value(forKey: "user_name")) as? String ?? ""
        //                    conditionsModelObj.source = ((conditionsdata as AnyObject).value(forKey: "source")) as? String ?? ""
        //
        //
        //                    self.drawerHistory.append(conditionsModelObj)
        //                }
        //            }
        
        if let data = responseDict["data"] as? JSONDictionary {
            if let array = data["open_drawer_list"] as? NSArray {
                for item in array {
                    if let dict = item as? NSDictionary {
                        let conditionsModelObj = DrawerHistoryModel()
                        
                        conditionsModelObj.end_time = ((dict as AnyObject).value(forKey: "end_time")) as? String ?? ""
                        conditionsModelObj.closed = ((dict as AnyObject).value(forKey: "end_time")) as? String ?? ""
                        conditionsModelObj.started = ((dict as AnyObject).value(forKey: "started")) as? String ?? ""
                        conditionsModelObj.starting_cash = ((dict as AnyObject).value(forKey: "starting_cash")) as? String ?? ""
                        conditionsModelObj.actualin_drawer = ((dict as AnyObject).value(forKey: "actualin_drawer")) as? String ?? ""
                        conditionsModelObj.expected_in_drawer = ((dict as AnyObject).value(forKey: "expected_in_drawer")) as? String ?? ""
                        conditionsModelObj.drawer_difference = ((dict as AnyObject).value(forKey: "drawer_difference")) as? String ?? ""
                        conditionsModelObj.paid_in = ((dict as AnyObject).value(forKey: "pay_in")) as? String ?? ""
                        conditionsModelObj.paid_out = ((dict as AnyObject).value(forKey: "pay_out")) as? String ?? ""
                        conditionsModelObj.cash_sales = ((dict as AnyObject).value(forKey: "cash_sales")) as? String ?? ""
                        conditionsModelObj.cash_refunds = ((dict as AnyObject).value(forKey: "cash_refunds")) as? String ?? ""
                        conditionsModelObj.drawer_desc = ((dict as AnyObject).value(forKey: "drawer_desc")) as? String ?? ""
                        conditionsModelObj.drawer_id = ((dict as AnyObject).value(forKey: "drawer_id")) as? String ?? ""
                        conditionsModelObj.user_name = ((dict as AnyObject).value(forKey: "user_name")) as? String ?? ""
                        conditionsModelObj.cashdrawerID = ((dict as AnyObject).value(forKey: "cashdrawerID")) as? String ?? ""
                        conditionsModelObj.source = ((dict as AnyObject).value(forKey: "source")) as? String ?? ""
                        conditionsModelObj.last_action = ((dict as AnyObject).value(forKey: "last_action")) as? String ?? ""
                        conditionsModelObj.total_amount = ((dict as AnyObject).value(forKey: "total_amount")) as? String ?? ""
                        conditionsModelObj.username_login = ((dict as AnyObject).value(forKey: "username_login")) as? String ?? ""
                        self.drawerHistoryOpen.append(conditionsModelObj)
                    }
                }
            }
            if let array = data["closed_drawer_list"] as? NSArray {
                for item in array {
                    if let dict = item as? NSDictionary {
                        let conditionsModelObj = DrawerHistoryModel()
                        
                        conditionsModelObj.end_time = ((dict as AnyObject).value(forKey: "end_time")) as? String ?? ""
                        conditionsModelObj.closed = ((dict as AnyObject).value(forKey: "end_time")) as? String ?? ""
                        conditionsModelObj.started = ((dict as AnyObject).value(forKey: "started")) as? String ?? ""
                        conditionsModelObj.starting_cash = ((dict as AnyObject).value(forKey: "starting_cash")) as? String ?? ""
                        conditionsModelObj.actualin_drawer = ((dict as AnyObject).value(forKey: "actualin_drawer")) as? String ?? ""
                        conditionsModelObj.expected_in_drawer = ((dict as AnyObject).value(forKey: "expected_in_drawer")) as? String ?? ""
                        conditionsModelObj.drawer_difference = ((dict as AnyObject).value(forKey: "drawer_difference")) as? String ?? ""
                        conditionsModelObj.paid_in = ((dict as AnyObject).value(forKey: "pay_in")) as? String ?? ""
                        conditionsModelObj.paid_out = ((dict as AnyObject).value(forKey: "pay_out")) as? String ?? ""
                        conditionsModelObj.cash_sales = ((dict as AnyObject).value(forKey: "cash_sales")) as? String ?? ""
                        conditionsModelObj.cash_refunds = ((dict as AnyObject).value(forKey: "cash_refunds")) as? String ?? ""
                        conditionsModelObj.drawer_desc = ((dict as AnyObject).value(forKey: "drawer_desc")) as? String ?? ""
                        conditionsModelObj.drawer_id = ((dict as AnyObject).value(forKey: "drawer_id")) as? String ?? ""
                        conditionsModelObj.user_name = ((dict as AnyObject).value(forKey: "user_name")) as? String ?? ""
                        conditionsModelObj.cashdrawerID = ((dict as AnyObject).value(forKey: "cashdrawerID")) as? String ?? ""
                        conditionsModelObj.source = ((dict as AnyObject).value(forKey: "source")) as? String ?? ""
                        conditionsModelObj.last_action = ((dict as AnyObject).value(forKey: "last_action")) as? String ?? ""
                        conditionsModelObj.total_amount = ((dict as AnyObject).value(forKey: "total_amount")) as? String ?? ""
                        conditionsModelObj.username_login = ((dict as AnyObject).value(forKey: "username_login")) as? String ?? ""
                        self.drawerHistoryEnd.append(conditionsModelObj)
                    }
                }
            }
        }
    }
    
    func parseCheckDrawerEndData(responseDict: JSONDictionary) {
        self.checkDrawerEnd = [DrawerHistoryModel]()
        
        if let drawerData = responseDict["data"] as? NSDictionary
        {
            
            let currentDrawerObj = DrawerHistoryModel()
            currentDrawerObj.drawer_id = drawerData["cashdrawerID"] as? String ?? ""
            currentDrawerObj.starting_cash = drawerData["starting_cash"] as? String ?? ""
            currentDrawerObj.started = drawerData["started"] as? String ?? ""
            currentDrawerObj.cash_sales = drawerData["cash_sales"] as? String ?? ""
            currentDrawerObj.cash_refunds = drawerData["cash_refunds"] as? String ?? ""
            currentDrawerObj.actualin_drawer = drawerData["actualin_drawer"] as? String ?? ""
            currentDrawerObj.expected_in_drawer = drawerData["expected_in_drawer"] as?String ?? ""
            currentDrawerObj.drawer_difference = drawerData["drawer_difference"] as? String ?? ""
            currentDrawerObj.paid_in = drawerData["pay_in"] as? String ?? ""
            currentDrawerObj.paid_out = drawerData["pay_out"] as? String ?? ""
            
            self.checkDrawerEnd.append(currentDrawerObj)
            
            
        }
        
    }
    
    func parseRefundOrderData(responseDict: JSONDictionary) {
        self.refundData = RefundOrderDataModel()
        if let Data = responseDict["data"] as? NSDictionary
        {
            refundData.order_id = Data["order_id"] as? String ?? ""
            refundData.total = Data["total"] as? Double ?? 0.00
            refundData.email = Data["email"] as? String ?? ""
            refundData.userName = Data["userName"] as? String ?? ""
            refundData.phone = Data["phone"] as? String ?? ""
            refundData.userID = Data["userID"] as? String ?? ""
            refundData.payment_status = Data["payment_status"] as? String ?? ""
            refundData.refund_amount = Data["refund_amount"] as? Double ?? 0.00
            if let array = Data["refundedBy"] as? NSArray {
                for item in array {
                    let refundbyData = RefundedByDataModel()
                    if let dict = item as? NSDictionary {
                        refundbyData.type = dict.value(forKey: "type") as? String ?? ""
                        refundbyData.amount = dict.value(forKey: "amount") as? String ?? ""
                        refundData.refundedBy.append(refundbyData)
                        print(refundData.refundedBy.count)
                    }
                }
            }
        }
    }
    
    func parseVoidTrnsactionData(responseDict: JSONDictionary) {
        self.transactionVoidData = VoidTransactionDataModel()
        if let Data = responseDict["data"] as? NSDictionary
        {
            transactionVoidData.message = Data["message"] as? String ?? ""
            transactionVoidData.balance_due = Data["balance_due"] as? String ?? ""
            
            if let amt = Data["balance_due"] as? String {
                let Value = amt.toDouble() ?? 0.0
                DataManager.cartData!["balance_due"] = Value
                //let price = Double((obj as AnyObject).value(forKey: "productprice") as? String  ?? "0") ?? 0.00
            }
        }
    }
}

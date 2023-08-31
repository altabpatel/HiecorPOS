//
//  SocketModel.swift
//  HieCOR
//
//  Created by Sudama dewda on 28/01/20.
//  Copyright © 2020 HyperMacMini. All rights reserved.
//

import Foundation

struct JoinDataSocketModel {
    var response = String()
    var room = String()
    var session_id = String()
    
}

struct CartDataSocketModel {
    var sessionID = String()
    var customTax = String()
    var manualDiscount = Double()
    var coupon = String()
    var productExist = Bool()
    var subTotal = Double()
    var couponDiscount = Double()
    var tax = Double()
    var total = Double()
    var shippingAmount = Double()
    var balance_due = Double()
    var customerID = String()
    var strAddCouponName = String()
}

struct SignatureDataModelForSocket {
    var signData = String()
    var last4 = String()
    var sessionID = String()
    var signIndex = Int()
    var tip = String()
    var tipPercent = Int()
}
struct searchCustomerForSocket {
    var session_id = String()
    var phone = String()
}
struct SelectCustomerForSocket {
    var session_id = String()
    var phone = String()
    var room = String()
    var userId = String()
}

struct ReceiptModelForSocket {
    var email = String()
    var phone = String()
    var order_id = Double()
    var change_due = String()
    var session_id = String()
    var paymentMethod = String()
    var authCode = String()
    
}

struct selectRecieptOptionForSocket {
    var email = String()
    var phone = String()
    var order_id = Double()
    var change_due = String()
    var session_id = String()
    var reciept_type = String()
    
}



struct SaveSignatureDataModel {
    var txn_id = String()
    var dataUrl = String()
    var sessionID = String()
    var tip = String()
    var totalAmount = String()
    var cardNumber = String()
    var paxNumber = String()
}

class ProductsSocketModel: NSObject
{
    var row_id = Double()
    var str_title = String()
    var str_product_id = String()
    var str_product_categoryName = String()
    var str_external_prod_id = String()
    var str_product_code = String()
    var str_stock = String()
    var str_price = String()
    var str_short_description = String()
    var str_long_description = String()
    var str_product_image = String()
    var productImageData: Data?
    var str_limit_qty = String()
    var str_manual_description = String()
    var str_keywords = String()
    var str_fileID = String()
    var is_taxable = String()
    var unlimited_stock = String()
    var shippingPrice = String()
    var mainPrice = String()
    var isAllowDecimal = Bool()
    var isEditPrice = Bool()
    var isQtyDouble = Double()
    var isQtyString = String()
    var variations = JSONDictionary()
    var attributesData = JSONArray()
    var variationsData = JSONArray()
    var surchagevariationsData = JSONArray()
    var surchargeVariations = JSONDictionary()
    //    var productSetting: ProductSetting?
    var width = Double()
    var height = Double()
    var length = Double()
    var weight = Double()
}

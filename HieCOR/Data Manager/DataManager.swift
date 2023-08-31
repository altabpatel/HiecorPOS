//
//  DataManager.swift
//  HieCOR
//
//  Created by Apple on 27/06/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation

class DataManager {
    
    //Login
    static var pinloginEveryTransaction: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kPinloginEveryTransaction)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kPinloginEveryTransaction)
        }
    }
    
    static var userTypeFlag: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kUserTypeFleg)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kUserTypeFleg)
        }
    }
    
    
    static var isUserLogin: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsUserLogin)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsUserLogin)
        }
    }
    
    static var isFirstTimeUserLogin: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsFirstTimeUserLogin)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsFirstTimeUserLogin)
        }
    }
    
    static var loginBaseUrl: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kLoginBaseUrl)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kLoginBaseUrl) ?? kEmptyString
        }
    }
    static var urlTextFeildValue: String {
           set {
               UserDefaults.standard.setValue(newValue, forKey: kUrlTextFeildValue)
               UserDefaults.standard.synchronize()
           }
           get {
               return UserDefaults.standard.string(forKey: kUrlTextFeildValue) ?? kEmptyString
           }
       }
    
    static var appVersion: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KIsAppVersion)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: KIsAppVersion) as! String //string(forKey: KIsAppVersion)
        }
    }
    
    static var defaultTaxID: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kDefaultTaxID)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kDefaultTaxID) ?? kEmptyString
        }
    }
    
    static var RemaingAmount: Double {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kRemaingAmt)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kRemaingAmt) as? Double ?? 0
            
        }
    }
    
    static var recentOrderID: Int? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kRecentOrderID)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kRecentOrderID) as? Int ?? nil
        }
    }
    
    
    
    
    static var tenDiscountValue: Double {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kTenDiscountValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kTenDiscountValue) as? Double ?? 10
        }
    }
    
    static var twentyDiscountValue: Double {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kTwentyDiscountValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kTwentyDiscountValue) as? Double ?? 20
        }
    }
    
    static var seventyDiscountValue: Double {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kSeventyDiscountValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kSeventyDiscountValue) as? Double ?? 70
        }
    }
    
    static var recentOrder: JSONDictionary {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kRecentOrder)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.dictionary(forKey: kRecentOrder) ?? JSONDictionary()
        }
    }
    
    static var baseUrl: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kBaseURL)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kBaseURL) ?? kEmptyString
        }
    }
    
    static var loginUsername: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kLoginUsername)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kLoginUsername) ?? kEmptyString
        }
    }
    
    static var errorOccure: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kerrorOccure)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kerrorOccure) as? Bool ?? false
        }
    }
    
    static var loginPassword: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kLoginPassword)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kLoginPassword) ?? kEmptyString
        }
    }
    
    static var userName: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kUserName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kUserName) ?? kEmptyString
        }
    }
    
    static var authKey: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kAuthKey)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kAuthKey) ?? kEmptyString
        }
    }
    
    static var userID: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kUserID)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kUserID) ?? kEmptyString
        }
    }
    
    //Home
    static var cartProductsArray: Array<Any>? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kCartProductsArray)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.array(forKey: kCartProductsArray) ?? nil
        }
    }
    //Home
    static var cartShippingProductsArray: Array<Any>? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kcartShippingProductsArray)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.array(forKey: kcartShippingProductsArray) ?? nil
        }
    }
    
    static var isOffline: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsOffline)
            UserDefaults.standard.synchronize()
        }
        get {
            return true
            //            return UserDefaults.standard.bool(forKey: kIsOffline)
        }
    }
    
    static var isAuthentication: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsAuthentication)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsAuthentication)
        }
    }
    
    static var isDefaultCategory: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsDefaultCategory)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsDefaultCategory)
        }
    }
    
    static var isCouponList: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsCouponList)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsCouponList)
        }
    }
    
    static var isShowCountry: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsShowCountry)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsShowCountry)
        }
    }
    
    static var isSplitRow: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsSplitRow)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsSplitRow)
        }
    }
    
    static var isDiscountOptions: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsDiscountOptions)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsDiscountOptions)
        }
    }
    
    static var isLineItemTaxExempt: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsLineItemtaxExempt)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsLineItemtaxExempt)
        }
    }
    
    static var isEditOrder: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsEditOrder)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsEditOrder)
        }
    }
    static var isProductEdit: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: KIsEditProduct)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: KIsEditProduct)
        }
    }
    static var isTaxOn: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kTaxes)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kTaxes)
        }
    }
    
    static var isProductsSYNC: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kProductsSYNC)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kProductsSYNC)
        }
    }
    
    static var isCustomerManagementOn: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kCustomerManagement)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kCustomerManagement)
        }
    }
    // for Prompt Add Customer
    static var isPromptAddCustomer: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kPromptAddCustomer)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kPromptAddCustomer)
        }
    }
    
    static var isIngenicPaymentMethodCancelAndMessage: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kingenicpaymentmethodcancelandmessage)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kingenicpaymentmethodcancelandmessage)
        }
    }
    
    static var printers: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kPrinters)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kPrinters)
        }
    }
    
    static var deviceName: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kDeviceName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kDeviceName)
        }
    }
    
    static var receipt: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kReceipt)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kReceipt)
        }
    }
    
    static var deviceNameText: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kDeviceNameText)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kDeviceNameText)
        }
    }
    
    static var selectedCountry: String {
        set {
            UserDefaults.standard.set(newValue, forKey: kSelectedCountry)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kSelectedCountry) ?? "US"
        }
    }
    
    static var logoImageUrl: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kLogoImageUrl)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kLogoImageUrl)
        }
    }
    
    static var noInventoryPurchase: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: knoInventoryPurchase)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: knoInventoryPurchase)
        }
    }
    static var showImagesFunctionality: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kshowImagesFunctionality)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kshowImagesFunctionality)
        }
    }
    static var showShipOrderInPos: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kshowShipOrderInPos)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kshowShipOrderInPos)
        }
    }
    static var showShippingCalculatiosInPos: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kshowShippingCalculatiosInPos)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kshowShippingCalculatiosInPos)
        }
    }
    static var customFieldShow: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kcustomFieldShow)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kcustomFieldShow)
        }
    }
    static var customText1Type: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kcustomText1Type)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kcustomText1Type)
        }
    }
    static var customText2Type: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kcustomText2Type)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kcustomText2Type)
        }
    }
    static var customText1Label: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kcustomText1Label)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kcustomText1Label)
        }
    }
    static var customText2Label: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kcustomText2Label)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kcustomText2Label)
        }
    }
    static var selectedCategory: String {
        set {
            UserDefaults.standard.set(newValue, forKey: kSelectedCategory)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kSelectedCategory) ?? "Home"
        }
    }
    static var selectedPaxRefund: [String]? {
        set {
            UserDefaults.standard.set(newValue, forKey: kselectedPaxRefund)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kselectedPaxRefund) as? [String]
        }
    }
    static var selectedCarrier: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kselectedCarrier)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kselectedCarrier) as? String
        }
    }
    // Start ..... by priya loyalty change
    static var loyaltyMaxSaveOrder: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kloyaltyMaxSaveOrder)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kloyaltyMaxSaveOrder)
        }
    }
    
    static var loyaltyPercentSaving: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kloyaltyPercentSaving)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kloyaltyPercentSaving)
        }
    }
    static var finalLoyaltyDiscount: Double {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kfinalLoyaltyDiscount)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kfinalLoyaltyDiscount) as? Double ?? 0.0
        }
    }
    static var selectedService: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kselectedService)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kselectedService) as? String
        }
    }
    static var selectedServiceName: String? {
           set {
               UserDefaults.standard.set(newValue, forKey: kselectedServiceName)
               UserDefaults.standard.synchronize()
           }
           get {
               return UserDefaults.standard.value(forKey: kselectedServiceName) as? String
           }
       }
       static var selectedServiceId: String? {
           set {
               UserDefaults.standard.set(newValue, forKey: kselectedServiceId)
               UserDefaults.standard.synchronize()
           }
           get {
               return UserDefaults.standard.value(forKey: kselectedServiceId) as? String
           }
       }
    static var selectedShippingRate: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kselectedShippingRate)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kselectedShippingRate) as? String
        }
    }
    static var shippingWeight: Double {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kshippingWeight)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kshippingWeight) as? Double ?? 0.0
        }
    }
    static var shippingLength: Double {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kshippingLength)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kshippingLength) as? Double ?? 0.0
        }
    }
    static var shippingWidth: Double {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kshippingWidth)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kshippingWidth) as? Double ?? 0.0
        }
    }
    static var shippingHeight: Double {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kshippingHeight)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kshippingHeight) as? Double ?? 0.0
        }
    }
    static var selectedCustomer: [String: Any]? {
        set {
            UserDefaults.standard.set(newValue, forKey: kSelectedCustomer)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kSelectedCustomer) as? [String: Any]
        }
    }
    
    static var selectedPayment: [String]? {
        set {
            UserDefaults.standard.set(newValue, forKey: kArraySelectedPaymet)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kArraySelectedPaymet) as? [String]
        }
    }
    
    static var customerObj: JSONDictionary? {
        set {
            UserDefaults.standard.set(newValue, forKey: kCustomerObj)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kCustomerObj) as? JSONDictionary
        }
    }
    
    static var cartData: JSONDictionary? {
        set {
            UserDefaults.standard.set(newValue, forKey: kCartData)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kCartData) as? JSONDictionary
        }
    }
    
    static var duebalanceData: Double? {
        set {
            UserDefaults.standard.set(newValue, forKey: kdueBalnaceData)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kdueBalnaceData) as? Double ?? 0.0
        }
    }
    
    static var selectedPAX: [String] {
        set {
            UserDefaults.standard.set(newValue, forKey: kArraySelectedPAX)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kArraySelectedPAX) as? [String] ?? ["CREDIT"]
        }
    }
    
    static var isCheckUncheckShippingBilling: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsCheckUncheckShippingBilling)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kIsCheckUncheckShippingBilling) as? Bool ?? true
        }
    }
    
    static var recentCategorySearchArray: [String]? {
        set {
            UserDefaults.standard.set(newValue, forKey: kRecentCategorySearchArray)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.array(forKey: kRecentCategorySearchArray) as? [String]
        }
    }
    
    static var recentProductSearchArray: [String]? {
        set {
            UserDefaults.standard.set(newValue, forKey: kRecentProductSearchArray)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.array(forKey: kRecentProductSearchArray) as? [String]
        }
    }
    
    static var cardReaders: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kCardReaders)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kCardReaders)
        }
    }
    
    static var isSwipeToPay: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsSwipeToPay)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsSwipeToPay)
        }
    }
    
    static var isBarCodeReaderOn: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsBarCodeReaderOn)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsBarCodeReaderOn)
        }
    }
    
    static var collectTips: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kCollectTips)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kCollectTips)
        }
    }
    
    static var tempCollectTips: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kTempCollectTips)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kTempCollectTips)
        }
    }
    
    static var signature: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kSignature)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kSignature)
        }
    }
    static var signatureOnReceipt: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kSignatureOnReceipt)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kSignatureOnReceipt)
        }
    }
    
    static var tempSignature: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kTempSignature)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kTempSignature)
        }
    }
    
    static var paperSize: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: kPaperSize)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kPaperSize) as? Int ?? 58
        }
    }
    
    static var isInternalGift: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kInternalGiftCard)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kInternalGiftCard)
        }
    }
    
    static var isGiftCard: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kGiftCard)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kGiftCard)
        }
    }
    
    static var isPaxPayGiftCard: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kPaxPayGiftCard)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kPaxPayGiftCard)
        }
    }
    
    static var isSingatureOnEMV: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kSingatureOnEMV)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kSingatureOnEMV)
        }
    }
    
    static var isGooglePrinter: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kGooglePrinter)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kGooglePrinter)
        }
    }
    static var isBluetoothPrinter: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kBluetoothPrinter)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kBluetoothPrinter)
        }
    }
    
    static var customerId: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kCustomeId)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kCustomeId) ?? kEmptyString
        }
    }
    
    static var customerForShippingAddressId: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KcustomerForShippingAddressId)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: KcustomerForShippingAddressId) ?? kEmptyString
        }
    }
    
    static var shippingValue: Double? {
        set {
            UserDefaults.standard.set(newValue, forKey: kshippingValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kshippingValue) as? Double ?? 0.0
        }
    }
    
    static var shippingValueForAddress: Double? {
        set {
            UserDefaults.standard.set(newValue, forKey: kShippingValueForAddress)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kShippingValueForAddress) as? Double ?? 0.0
        }
    }
    
    static var isSettingCRM: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kSettingCRM)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kSettingCRM) as? Bool ?? true
        }
    }
    static var CardCount: Int {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kCardCount)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kCardCount) as? Int ?? 0
        }
    }
    
    static var EmvCardCount: Int {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kEmvCardCount)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kEmvCardCount) as? Int ?? 0
        }
    }
    
    static var IngenicoCardCount: Int {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kIngenicoCardCount)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kIngenicoCardCount) as? Int ?? 0
        }
    }
    
    static var shippingaddressCount: Int {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Kshippingaddress)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: Kshippingaddress) as? Int ?? 0
        }
    }
    static var Bbpid: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kbpId)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kbpId) ?? kEmptyString
        }
    }
    
    static var ErrorBbpid: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kErrorbpId)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kErrorbpId) ?? kEmptyString
        }
    }
    
    static var BaseUrlData: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kBaseUrlData)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kBaseUrlData) ?? kEmptyString
        }
    }
    static var selectedFullfillmentId: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kselectedFullfillmentId)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kselectedFullfillmentId) as? String
        }
    }
    
    static var isshipOrderButton : Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: KshipOrderButton)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: KshipOrderButton) as? Bool ?? false
        }
    }
    
    static var isUserPaxToken: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: KuserPaxToken)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: KuserPaxToken) as? String
        }
    }
    static var isPaxTokenEnable: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kPaxTokenEnable)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kPaxTokenEnable) as? String
        }
    }
    
    static var isCaptureButton : Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: KCaptureButton)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: KCaptureButton) as? Bool ?? false
        }
    }
    
    static var selectedPaxDeviceName: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kselectedPaxDeviceName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kselectedPaxDeviceName) ?? kEmptyString
        }
    }
    
    //OrderDataModel
    //    static var OrderDataModel: Array<Any>? {
    //        set {
    //            UserDefaults.standard.setValue(newValue, forKey: kOrderDataModel)
    //            UserDefaults.standard.synchronize()
    //        }
    //        get {
    //            return UserDefaults.standard.array(forKey: kOrderDataModel) ?? nil
    //        }
    //    }
    
    static var OrderDataModel: JSONDictionary? {
        set {
            UserDefaults.standard.set(newValue, forKey: kOrderDataModel)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kOrderDataModel) as? JSONDictionary
        }
    }
    
    static var isShippOpen : Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsShippOpen)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kIsShippOpen) as? Bool ?? false
        }
    }
    
    static var isPaymentBtnAddCustomer : Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: KPaymentBtnAddCustomer)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: KPaymentBtnAddCustomer) as? Bool ?? false
        }
    }
    
    static var isDrawerOpen: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisDrawerOpen)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kisDrawerOpen)
        }
    }
    
    static var last4DigitCard: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kLast4DigitCard)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kLast4DigitCard)
        }
    }
    
    static var SavedPaymentArray: JSONArray? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kSavedPaymentArray)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kSavedPaymentArray) as? JSONArray
        }
    }
    
    static var appUserID: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kappUserId)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kappUserId) as! String
        }
    }
    
    static var appUserName: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kappUserName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kappUserName) as! String
        }
    }
    
    static var manual_product_tax_data: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kmanual_product_tax_data)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kmanual_product_tax_data)
        }
    }
    
    static var posTaxOnShippingHandlingFunctionality: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kpostaxonshippinghandlingfunctionality)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kpostaxonshippinghandlingfunctionality)
        }
    }
    
    static var posiOSVersion: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kposiOSVersion)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kposiOSVersion)
        }
    }
    
    static var posAppVersion: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kposAppVersion)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kposAppVersion)
        }
    }
    
    static var posBuildNumber: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kposBuildNumber)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kposBuildNumber)
        }
    }
    
    static var isCheckForAppUpdate : Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisCheckForAppUpdate)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kisCheckForAppUpdate) as? Bool ?? false
        }
    }
    static var isShowUpdateNow : Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisShowUpdateNow)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kisShowUpdateNow) as? Bool ?? false
        }
    }
    
    // by sudama offline
    static var offlineccProcess: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kofflineccProcess)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kofflineccProcess)
        }
    }
    
    static var showQueuedOfflineOrders: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kshowQueuedOfflineOrders)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kshowQueuedOfflineOrders)
        }
    }
    static var showSubscription: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kshowSubscription)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kshowSubscription)
        }
    }
    
    static var offlineOrderdata: JSONArray? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kofflineOrderData)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kofflineOrderData) as? JSONArray
        }
    }
    
    static var offlineOrderdataAPIData: JSONArray? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kofflineOrderdataAPIData)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kofflineOrderdataAPIData) as? JSONArray
        }
    }
    static var paxTokenizationEnable: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kpaxTokenizationEnable)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kpaxTokenizationEnable) as? String
        }
    }
    static var allowZeroDollarTxn: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kallowZeroDollarTxn)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kallowZeroDollarTxn) as? String
        }
    }
    
    static var offlineTaxData: Array<Any>? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kofflineTaxData)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.array(forKey: kofflineTaxData) ?? nil
        }
    }
    
    static var productTermsData: JSONArray? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kproductSettingTerms)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kproductSettingTerms) as? JSONArray
        }
    }
    
    static var posInvoiceTerms: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kInvoiceTerms)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kInvoiceTerms)
        }
    }
    static var posInvoiceRep: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kInvoiceRep)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kInvoiceRep)
        }
    }
    static var posInvoiceDate: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kInvoiceDate)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kInvoiceDate)
        }
    }
    static var posInvoiceTitle: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kInvoiceTitle)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kInvoiceTitle)
        }
    }
    static var posInvoicePoNumber: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kInvoicePoNumber)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kInvoicePoNumber)
        }
    }
    static var posInvoiceCountry: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kInvoiceCountry)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kInvoiceCountry)
        }
    }
    
    // socket sudama
    static var socketAppUrl: String {
          set {
              UserDefaults.standard.setValue(newValue, forKey: ksocketAppUrl)
              UserDefaults.standard.synchronize()
          }
          get {
              return UserDefaults.standard.string(forKey: ksocketAppUrl) ?? kDeaultString
          }
      }
    static var roomID: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kRoomID)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kRoomID) ?? kEmptyString
        }
    }
    static var sessionID: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kSessionID)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kSessionID) ?? kEmptyString
        }
    }

    static var subTotalForSocket: Double? {
           set {
               UserDefaults.standard.set(newValue, forKey: ksubTotalForSocket)
               UserDefaults.standard.synchronize()
           }
           get {
               return UserDefaults.standard.value(forKey: ksubTotalForSocket) as? Double ?? 0.0
           }
       }
    
    static var showCustomerFacing: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kshowCustomerFacing)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kshowCustomerFacing)
        }
    }
    
    static var showCustomerFacingForMobile: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kshowCustomerFacingForMobile)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kshowCustomerFacingForMobile)
        }
    }
    //
    
    
    static var FirstNameCardHolder: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KFirstNameCardHolder)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: KFirstNameCardHolder) as! String
        }
    }
    
    static var LastNameCardHolder: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: KLastNameCardHolder)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: KLastNameCardHolder) as! String 
        }
    }
    
    static var isTotalTipCalculation: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsTotalTipCount)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsTotalTipCount)
        }
    }
    
    static var arrTempListing: JSONArray? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: karrTempListing)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: karrTempListing) as? JSONArray
        }
    }
    
    static var isPartialAprrov: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisPartialAprrov)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kisPartialAprrov) as? Bool ?? false
        }
    }
    
    static var tempBalanceDuedata: Double? {
        set {
            UserDefaults.standard.set(newValue, forKey: "ktempBalanceDuedata")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: "ktempBalanceDuedata") as? Double ?? 0.0
        }
    }
    
    static var isBalanceDueData: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisBalanceDueData)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kisBalanceDueData) as? Bool ?? false
        }
    }
    
    static var isSplitPayment: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisSplitPayment)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kisSplitPayment) as? Bool ?? false
        }
    }
    
    static var isshippingRefundOnly: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsshippingRefundOnly)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsshippingRefundOnly) as? Bool ?? false
        }
    }
    
    static var isTipRefundOnly: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsTipRefundOnly)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsTipRefundOnly) as? Bool ?? false
        }
    }
    
    static var allowUserPriceChange: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kallowUserPriceChange)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kallowUserPriceChange) as? String
        }
    }
    
    static var allowIngenicoPaymentMethod: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kallowIngenicoPaymentMethod)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kallowIngenicoPaymentMethod) as? String
        }
    }
    
    static var isSideMenuSwiperCard: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsSideMenuSwiperCard)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsSideMenuSwiperCard) as? Bool ?? false
        }
    }
    
    static var isExternalKeyBoardAttach: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsExternalKeyBoardAttach)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsExternalKeyBoardAttach) as? Bool ?? false
        }
    }
        
    static var isCardReader: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kCardReader)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kCardReader)
        }
    }
    
    static var isIngenicoConnected: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisIngenicoConnected)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kisIngenicoConnected)
        }
    }
    static var showPriceFunctionality: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kshowPriceFunctionality)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kshowPriceFunctionality)
        }
    }
    static var showProductCodeFunctionality: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kshowProductCodeFunctionality)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kshowProductCodeFunctionality)
        }
    }
    static var posAutoPrintCreditCardFunctionality: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kposAutoPrintCreditCardFunctionality)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kposAutoPrintCreditCardFunctionality)
        }
    }
    
    static var refundExchangeCheckForCustomerApp: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: krefundExchangeCheckForCustomerApp)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: krefundExchangeCheckForCustomerApp)
        }
    }

    
    static var posTaxListData: Dictionary<String,AnyObject>? {
        set {
            UserDefaults.standard.set(newValue, forKey: kTaxListData)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kTaxListData) as? Dictionary<String, AnyObject>
        }
    }
    var taxSetting = Dictionary<String,AnyObject>()

// For screen saver
static var isScreenSaverOn: Bool {
    set {
        UserDefaults.standard.set(newValue, forKey: kisScreenSaverOn)
        UserDefaults.standard.synchronize()
    }
    get {
        return UserDefaults.standard.bool(forKey: kisScreenSaverOn)
    }
}

static var screenSaverTimeInSec: Int {
    set {
        UserDefaults.standard.setValue(newValue, forKey: kscreenSaverTimeInSec)
        UserDefaults.standard.synchronize()
    }
    get {
        return UserDefaults.standard.integer(forKey: kscreenSaverTimeInSec)
    }
}

static var isScreenSaverOnThenKeyboardHide: Bool {
       set {
           UserDefaults.standard.set(newValue, forKey: kisScreenSaverOnThenKeyboardHide)
           UserDefaults.standard.synchronize()
       }
       get {
           return UserDefaults.standard.bool(forKey: kisScreenSaverOnThenKeyboardHide)
       }
   }
    
    
    static var isStarPrinterConnected: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kStarPrinterConnected)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kStarPrinterConnected)
        }
    }
    static var isLoginByPin: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "isLoginByPin")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: "isLoginByPin") as? Bool ?? false
        }
    }
    
    static var RUADeviceTypeValueDataSet: RUADeviceType.RawValue {
         set {
             UserDefaults.standard.set(newValue, forKey: kRUADeviceTypeValue)
             UserDefaults.standard.synchronize()
         }
         get {
            return UserDefaults.standard.value(forKey: kRUADeviceTypeValue) as? RUADeviceType.RawValue ?? 9
         }
     }
    static var starCloudMACaAddress: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kStarCloudMACaAddress)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kStarCloudMACaAddress) ?? ""
        }
    }
    
    static var strIngenicoDeviceName: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kstrIngenicoDeviceName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kstrIngenicoDeviceName)
        }
    }
    
    
    
    static var RUADeviceConnectValueDataSet: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kRUADeviceConnectValueDataSet)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kRUADeviceConnectValueDataSet)
        }
    }
    
    static var ShowPaxHeartlandGiftcardsMethod: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kShowPaxHeartlandGiftcardsMethod)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kShowPaxHeartlandGiftcardsMethod) as? String
        }
    }
    
    static var ShowHeartlandGiftcardsMethod: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kShowHeartlandGiftcardsMethod)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kShowHeartlandGiftcardsMethod) as? String
        }
    }
    static var selectedCarrierName: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kselectedCarrierName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kselectedCarrierName) as? String
        }
    }
    // For pos_single_result_auto_add_to_cart
    static var isPosSingleResultAutoAddToCart: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisPosSingleResultAutoAddToCart)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kisPosSingleResultAutoAddToCart)
        }
    }
    
    static var automatic_upsellData: [String] {
        set {
            UserDefaults.standard.set(newValue, forKey: kautomaticupsell)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kautomaticupsell) as? [String] ?? []
        }
    }
    
    static var isUPSellProduct: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsUPSellProduct)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsUPSellProduct)
        }
    }
    //For Load balance show hide
    static var loadGiftCardOnlyOnPurchase: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kLoadGiftCardOnlyOnPurchase)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kLoadGiftCardOnlyOnPurchase) as? String ?? ""
        }
    }
    
    static var customerStatusType: [String]? {
        set {
            UserDefaults.standard.set(newValue, forKey: kCustomerStatus)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.array(forKey: kCustomerStatus) as? [String]
        }
    }
    
    static var isPosProductViewInfo: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kPosProductViewInfo)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kPosProductViewInfo) as? String
        }
    }
    
    static var customerStatusDefaultName: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kcustomerStatusDefaultName)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kcustomerStatusDefaultName) ?? kEmptyString
        }
    }
    
    static var showCustomerStatusAllInOne: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kshowCustomerStatusAllInOne)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kshowCustomerStatusAllInOne) ?? kEmptyString
        }
    }
    
    static var showFullRecieptOptionForPrint: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kshowFullRecieptOptionForPrint)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kshowFullRecieptOptionForPrint) ?? kEmptyString
        }
    }
    
    static var showMultipleShippingPopup: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kshowMultipleShippingPopup)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kshowMultipleShippingPopup) ?? kEmptyString
        }
    }
    
    static var posDisableDiscountFeature: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: kposDisableDiscountFeature)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kposDisableDiscountFeature) ?? kEmptyString
        }
    }
    
    static var isEditProductForUpsell: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kIsEditProductForUpsell)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kIsEditProductForUpsell)
        }
    }
    static var posHideOutofStockFunctionality: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "pos_hide_out_of_stock_functionality")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "pos_hide_out_of_stock_functionality")
        }
    }
    static var showTerminalIntregationSettings: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "show_terminal_intregation_settings")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "show_terminal_intregation_settings") ?? kEmptyString
        }
    }
    static var showProductInStockCheckbox: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "show_product_in_stock_checkbox")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "show_product_in_stock_checkbox") ?? kEmptyString
        }
    }
    static var showProductNewScan: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "show_product_new_scan")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: "show_product_new_scan") ?? kEmptyString
        }
    }
    static var showOfficePhoneAllInOne: String {
            set {
                UserDefaults.standard.setValue(newValue, forKey: kshowOfficePhoneAllInOne)
                UserDefaults.standard.synchronize()
            }
            get {
                return UserDefaults.standard.string(forKey: kshowOfficePhoneAllInOne) ?? kEmptyString
            }
        }
        
        static var showContactSourceBoxAllInOne: String {
            set {
                UserDefaults.standard.setValue(newValue, forKey: kshowContactSourceBoxAllInOne)
                UserDefaults.standard.synchronize()
            }
            get {
                return UserDefaults.standard.string(forKey: kshowContactSourceBoxAllInOne) ?? kEmptyString
            }
        }
    
    static var posDefaultPaymentMethod: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kposDefaultPaymentMethod)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kposDefaultPaymentMethod) ?? kEmptyString
        }
    }
    
    static var customeStatusSelecForWholSale: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: kposDefaultPaymentMethod)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.string(forKey: kposDefaultPaymentMethod) ?? kEmptyString
        }
    }
    static var posDropdownDefaultRegionState: String? {//pos_dropdown_default_region  // By Altab 18 Aug 2022
        set {
            UserDefaults.standard.set(newValue, forKey: kposDropDownDefaultRegion)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kposDropDownDefaultRegion) as? String ?? ""
        }
    }
    static var ingenicoOflineCaseData: JSONArray? { // DD for Ingnico case fail 08 nov 2022
        set {
            UserDefaults.standard.set(newValue, forKey: kIngenicoOflineCaseData)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: kIngenicoOflineCaseData) as? JSONArray
        }
    }
    static var isZreportLowerCase: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisZreportLowerCase)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kisZreportLowerCase)
        }
    }
    
    static var isTaxTenDecimal: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisTaxTenDecimal)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kisTaxTenDecimal)
        }
    }
    
    static var isOpenPayNowInApp: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: kisOpenPayNowInApp)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: kisOpenPayNowInApp)
        }
    }

    static var posCollectSignatureOnEveryOrder : Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "pos_collect_signature_on_every_order")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: "pos_collect_signature_on_every_order") as? Bool ?? false
        }
    }
    static var showPaymentMethodCcInvoice : Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "show_payment_method_cc_invoice")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: "show_payment_method_cc_invoice") as? Bool ?? false
        }
    }
}

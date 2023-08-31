//
//  APIServices+Home.swift
//  HieCOR
//
//  Created by Deftsoft on 20/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation
import UIKit

//MARK: Enumeration
enum HomeAPIServices: APIService {
    case getTransactionPrintReceiptContent(transactionID: String,print_cloud_recipt: String,cloud_printer_address: String)
    case getCategory(pageNumber: Int)
    case getProduct(categoryName: String, pageNumber: Int)
    case getSearchProduct(searchText: String, searchFetchLimit: Int, searchPageCount: Int)
    case updateProductService(parameters: JSONDictionary)
    case getSearchCategory(searchText: String)
    case getTaxList()
    case getCoupanList()
    case getIngenicoData(source: String)
    case getCustomerList(indexOfPage: Int)
    case getRegionList(countryName: String?)
    case getSearchCustomer(searchText: String, searchFetchLimit: Int, searchPageCount: Int)
    case createOrder(parametersDict: JSONDictionary,isInvoice: Bool)
    case pushMultipleOrder(parameters: JSONArray)
    case getRepresentativesList()
    case sendEmail(parametersDict: JSONDictionary)
    case sendNote(parametersDict: JSONDictionary)
    case getReceiptContent(orderId: String,print_cloud_recipt:String,cloud_printer_address:String)
    case getReceiptEndDrawerContentURL(orderId: String)
    case getReceiptEndDrawerDetails(orderId: String,print_cloud_recipt:String,cloud_printer_address: String)
    case getCoupanProductIDList(coupan: String)
    case getPaxDeviceList()
    case getCountryList(country: String)
    case getCustomerDetail(id: String)
    case calculateCart(parametersDict: JSONDictionary)
    case startDrawer(parametersDict: JSONDictionary)
    case startPayIn(parametersDict: JSONDictionary)
    case startPayOut(parametersDict: JSONDictionary)
    case endDrawer(parametersDict: JSONDictionary)
    case giftCardBalance(parametersDict: JSONDictionary)
    case giftCardActivate(parametersDict: JSONDictionary)
    case giftCardDeactivate(parametersDict: JSONDictionary)
    case giftCardReplace(parametersDict: JSONDictionary)
    case giftCardReverse(parametersDict: JSONDictionary)
    case giftGetBalance(number:String,type:String)
    case getSetting()
    //by anand
    case getContactSources()
    //end anand
    case getSavedCardData(id:String,type:String)
    case getEmvSavedCardData(id:String)
    case getIngenicoSavedCardData(id:String)
    case getShippingCarrierList()
    case sendShippingService(parametersDict: JSONDictionary)
    case deletSavedCardData(id:String,type:String)
    case updateSavedCardData(parametersDict: JSONDictionary)
    case getMailingList()
    case putUserDetail(parametersDict: JSONDictionary)
    case getUserShippingAddress(UserId : String)
    case updateUserShippingAddress(parametersDict: JSONDictionary)
    case getSourcesList
    case getPrinterList
    case updatePrinterName(cloudPrinterAddress: String,cloudPrinterName:String)
    case updateDeliveryStatus(parametersDict: JSONDictionary)
    case getSerialNumber(productId: String)
    case getInvoiceTemplatesList()
    case getProductInfoDetails(productId: String) // For product details Api By Altab (20Dec2022)
    // for socket sudama
    case roomApi()
    //
    //Path
    var path: String {
        var path = ""
        
        var isLandscape = false
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            isLandscape = true
        }
        
        switch self {
        case let .getCategory(pageNumber):
            if pageNumber == -1 {
                path = BaseURL.appending(kGetAllCategories)
            }else {
                path = BaseURL.appending(kGetCategories + DataManager.userID + "&perpage=\(UI_USER_INTERFACE_IDIOM() == .pad ? (isLandscape ? 30 :18) : 21)&page=\(pageNumber)")
            }
            break
            
        case let .getProduct(categoryName, pageNumber):
            if categoryName == "" && pageNumber == -1 {
                path = BaseURL + kGetAllProducts
            }else {
                if (categoryName == "") {
                    path = BaseURL + kGetTotalProducts + "?perpage=\(isLandscape ? 36 : 45)&page=\(pageNumber)"
                }
                else {
                    path = BaseURL + categoryName + "&perpage=\(isLandscape ? 36 : 45)&page=\(pageNumber)"
                }
            }
            break
            
        case let .getSearchProduct(searchText, searchFetchLimit, searchPageCount):
            path = BaseURL + searchText + "&perpage=\(searchFetchLimit)&page=\(searchPageCount)"
            break
            
        case .updateProductService:
            path = BaseURL.appending(kUpdateProduct)
            break
            
        case let  .getSearchCategory(searchText):
            path = String(format: "%@%@%@&key=%@",BaseURL, kGetCategories, DataManager.userID, searchText)
            break
            
        case .getTaxList:
            path = String(format: "%@%@",BaseURL, kGetTaxList)
            break
            
        case .getMailingList():
            path = String(format: "%@%@",BaseURL, kMailingList)
            break
            
        case .getCoupanList:
            path = String(format: "%@%@",BaseURL, kGetCouponsList)
            break
            
        case let .getIngenicoData(source):
            path = String(format: "%@%@&source=%@",BaseURL, kGetIngenicoData, source)
            break
            
        case let .getCustomerList(indexOfPage):
            if indexOfPage == -1 {
                path = BaseURL + kGetCustomerList
            }else {
                path = BaseURL + kGetCustomerList + "?perpage=30&page=\(indexOfPage)"
            }
            break
            
        case let .getRegionList(countryName):
            path = String(format: "%@%@",BaseURL, kGetRegionsList + (countryName == nil ? "" : "?country=\(countryName!)"))
            break
            
        case let .getSearchCustomer(searchText, searchFetchLimit, searchPageCount):
            path = BaseURL + kGetCustomerList + "?key=\(searchText)&perpage=\(searchFetchLimit)&page=\(searchPageCount)"
            break
            
        case let .createOrder(_,isInvoice):
            path = String(format: "%@%@",BaseURL,  (isInvoice ? kCreateInvoice : kCreateOrder))
            break
            
        case .pushMultipleOrder:
            path = String(format: "%@%@",BaseURL,kMultiOrder)
            break
            
        case .getRepresentativesList:
            path = String(format: "%@%@",BaseURL, kGetRepresentativesList)
            break
            
        case .sendEmail:
            path = String(format: "%@%@",BaseURL, kSendEmail)
            break
            
        case .sendNote:
            path = String(format: "%@%@",BaseURL, kOrderAddNote)
            break
            
        case let .getReceiptContent(orderId,print_cloud_recipt,cloud_printer_address):
            path =  String(format: "%@%@%@%@",BaseURL,kReceiptContent,orderId as CVarArg,"?cloud_printer_address=\(cloud_printer_address)&print_cloud_recipt=\(print_cloud_recipt)")
            break
            
        case let .getTransactionPrintReceiptContent(transactionID,print_cloud_recipt,cloud_printer_address):
            path =  String(format: "%@%@%@%@",BaseURL,kTransactionPrintReceiptContent,transactionID as CVarArg,"?cloud_printer_address=\(cloud_printer_address)&print_cloud_recipt=\(print_cloud_recipt)")
            break
            
        case let .getReceiptEndDrawerContentURL(orderId):
            path =  String(format: "%@%@%@",BaseURL,kReceiptEndDrawerURL,orderId as CVarArg)
            break
            
        case let .getReceiptEndDrawerDetails(orderId,print_cloud_recipt,cloud_printer_address):
            path =  String(format: "%@%@%@%@",BaseURL,kReceiptEndDrawerDetails,orderId as CVarArg,"?cloud_printer_address=\(cloud_printer_address)&print_cloud_recipt=\(print_cloud_recipt)")
            break
            
        case let .getCoupanProductIDList(coupan):
            path =  String(describing: BaseURL + kGetCouponsList + "?coupon_code=" + coupan)
            break
            
        case let .getCountryList(country):
            path = BaseURL + kCountryList + (country == "" ? "" : "?country=\(country)")
            break
            
        case let .giftGetBalance(number,type):
            path = BaseURL + kGiftGetBalance + ("?number=\(number)&type=\(type)")
            break
            
        case .getPaxDeviceList:
            path = String(format: "%@%@",BaseURL, kPaxSettings)
            break
            
        case let .getCustomerDetail(id):
            path = BaseURL.appending(kGetUserDetails + "\(id)/")
            break
            
        case .calculateCart:
            path = BaseURL + kCart
            break
            
        case .startDrawer:
            path = String(format: "%@%@",BaseURL, kStartDrawer)
            break
            
        case .startPayIn:
            path = String(format: "%@%@",BaseURL, kStartDrawer)
            break
            
        case .startPayOut:
            path = String(format: "%@%@",BaseURL, kStartDrawer)
            break
            
        case .endDrawer:
            path = String(format: "%@%@",BaseURL, kEndDrawer)
            break
            
        case .giftCardBalance:
            path = String(format: "%@%@",BaseURL, kGiftCardBalance)
            break
            
        case .giftCardActivate:
            path = String(format: "%@%@",BaseURL, kGiftCardActivate)
            break
            
        case .giftCardDeactivate:
            path = String(format: "%@%@",BaseURL, kGiftCardDeactivate)
            break
            
        case .giftCardReplace:
            path = String(format: "%@%@",BaseURL, kGiftCardReplace)
            break
            
        case .giftCardReverse:
            path = String(format: "%@%@",BaseURL, kGiftCardReverse)
            break
            
        case .getSetting:
            path = String(format: "%@%@",BaseURL, kSettingsList)
            break
            //by anand
        case .getContactSources():
            path = String(format: "%@%@",BaseURL, KContactSourcesList)
            break
            //end anand
        case let .getSavedCardData(id,_):
            path = BaseURL.appending(KUserCardId + "\(id)/")
            break
            
        case let .getEmvSavedCardData(id):
            path = BaseURL.appending(KUserEmvCardId + "\(id)/")
            break
            
        case let .getIngenicoSavedCardData(id):
            path = BaseURL.appending(KUserIngenicoCard + "\(id)/")
            break
            
            
            
        case let .getUserShippingAddress(userId):
            //path = BaseURL.appending(KUserShippingAddress + "\(userId)/")
            path = BaseURL.appending(KUserShippingAddress + userId)
            break
            
        case let .deletSavedCardData(id,_):
            path = BaseURL.appending(KUserCardDeleteId + "\(id)/")
            break
        
        case .getShippingCarrierList:
            path = String(format: "%@%@",BaseURL, kShippingCarrier)
            break
            
        case .sendShippingService:
            path = String(format: "%@%@",BaseURL, kShippingService)
            break

        case .updateSavedCardData:
            path = String(format: "%@%@",BaseURL, KUserCardUpdate)
            
        case .updateUserShippingAddress:
            path = String(format: "%@%@",BaseURL, KUpdateShippingAddress)
            
        case .putUserDetail:
            path = String(format: "%@%@",BaseURL, KUserPutDetail)
            
        //socket sudama
        case .roomApi:
            
            let aString = DataManager.loginBaseUrl
            let newString = aString.replacingOccurrences(of: "https://", with: "")
            path = String(format: "%@%@",DataManager.socketAppUrl, kroomApi + "?site_url=\(newString)")
            break
            //
            
        case .getSourcesList:
            path = String(format: "%@%@",BaseURL, kSourcesList)
            break
            
        case .getPrinterList:
            path = String(format: "%@%@",BaseURL, kGetPrinterList)
            break
            
        case let .updatePrinterName(cloudPrinterAddress, cloudPrinterName):
            path =  String(format: "%@%@%@%@",BaseURL,kUpdatePrinterName,"?cloud_printer_address=\(cloudPrinterAddress)" as CVarArg,"&   cloud_printer_name=\(cloudPrinterName)")

        case .updateDeliveryStatus:
            path = String(format: "%@%@",BaseURL, kupdateDeliveryStatus)
        case let .getSerialNumber(productId): // By Altab 18 Aug 2022
            path =  String(format: "%@%@%@",BaseURL,kSerialNumber,productId)
            break
        case .getInvoiceTemplatesList: // By Altab 24 Aug 2022
            path =  String(format: "%@%@",BaseURL,kInvoiceTemplates)
            break
        case .getProductInfoDetails(productId: let productId):  // For product details Api By Altab (20Dec2022)
            path = String(format: "%@%@%@",BaseURL, kUpdateProduct,productId)
        }
        
        
        
        return path
    }
    
    var multiOrder: MultiOrder {
        let resource: MultiOrder!
        let headers = ["Content-Type": "application/json", "X-USERNAME": DataManager.userName, "X-AUTH-KEY": DataManager.authKey, "X-AGENT-ID": DataManager.userID, "device_id": appDelegate.strDeviceUDID]
        
        switch self {
        case let .pushMultipleOrder(parameters: parameters):
            resource = MultiOrder(method: .post, parameters: parameters, headers: headers)
        default:
            resource = MultiOrder(method: .post, parameters: nil, headers: nil)
        }
        return resource
    }
    
    //Resource
    var resource: Resource {
        var resource: Resource!
        let headers = ["Content-Type": "application/json", "X-USERNAME": DataManager.userName, "X-AUTH-KEY": DataManager.authKey, "X-AGENT-ID": DataManager.userID, "device_id": appDelegate.strDeviceUDID]
        
        switch self {
        case .getCategory:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getProduct:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break

        case .getSearchProduct:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case let .updateProductService(parameters):
            let header = ["X-USERNAME": DataManager.userName, "X-AUTH-KEY": DataManager.authKey, "X-AGENT-ID": DataManager.userID]
            resource = Resource(method: .post, parameters: parameters, headers: header)
            break
            
        case .getSearchCategory:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getTaxList:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getMailingList():
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getCoupanList:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getIngenicoData:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .giftGetBalance:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getCustomerList:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case .getRegionList:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case .getSearchCustomer:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case let .createOrder(parametersDict,_):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case .pushMultipleOrder:
            resource = Resource(method: .post, parameters: nil, headers: headers)
            break
        case .getRepresentativesList:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case let .sendEmail(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case let .sendNote(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case .getReceiptContent:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getTransactionPrintReceiptContent:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case .getReceiptEndDrawerContentURL:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getReceiptEndDrawerDetails:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getCoupanProductIDList:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getCountryList:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case .getPaxDeviceList:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case .getCustomerDetail:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case let .calculateCart(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case let .startDrawer(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case let .startPayIn(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case let .startPayOut(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case let .endDrawer(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case let .giftCardBalance(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case let .giftCardActivate(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case let .giftCardDeactivate(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case let .giftCardReplace(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
        case let .giftCardReverse(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
            
        case .getSetting:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            //by anand
        case .getContactSources():
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            //end anand
        case .getSavedCardData:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getEmvSavedCardData:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getIngenicoSavedCardData:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getUserShippingAddress:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        
        case .deletSavedCardData:
            resource = Resource(method: .delete, parameters: nil, headers: headers)
            break
            
        case .getShippingCarrierList():
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        
        case let .sendShippingService(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
            
        case let .updateSavedCardData(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
            
        case let .updateUserShippingAddress(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            break
           
        case let .putUserDetail(parametersDict):
            resource = Resource(method: .put, parameters: parametersDict, headers: headers)
            break
            
        // socket sudama
        case let .roomApi():
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            //
            
        case .getSourcesList:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case .getPrinterList:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case .updatePrinterName:
            resource = Resource(method: .get, parameters: nil, headers: headers)
        case .updateDeliveryStatus(parametersDict: let parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
        case .getSerialNumber: // By Altab 18 Aug 2022
            resource = Resource(method: .get, parameters: nil, headers: headers)
        case .getInvoiceTemplatesList: // By Altab 24 Aug 2022
            resource = Resource(method: .get, parameters: nil, headers: headers)
        case .getProductInfoDetails: // For product details Api By Altab (20Dec2022)
            resource = Resource(method: .get, parameters: nil, headers: headers)
        }
        
        return resource
    }
}

//MARK: Class Functions
extension APIManager {
    
    class func getCategory(pageNumber: Int,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getCategory(pageNumber: pageNumber).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getProduct(categoryName: String, pageNumber: Int,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getProduct(categoryName: categoryName, pageNumber: pageNumber).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getCoupanProductIDList(coupan: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getCoupanProductIDList(coupan: coupan).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getCountryList(country: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getCountryList(country: country).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getSearchProduct(searchText: String, searchFetchLimit: Int, searchPageCount: Int,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getSearchProduct(searchText: searchText, searchFetchLimit: searchFetchLimit, searchPageCount: searchPageCount).request(cancelAllRequests: true,success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func updateProductService(parameters: JSONDictionary, imageDict: [String: Data]?,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.updateProductService(parameters: parameters).uploadMultiple(imageDict: imageDict, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getSearchCategory(searchText: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getSearchCategory(searchText: searchText).request(cancelAllRequests: true, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getTaxList(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getTaxList().request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    class func getMailingList(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getMailingList().request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    //by anand
    class func getContactSources(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getContactSources().request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    //end anand
    
    class func getCoupanList(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getCoupanList().request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getIngenicoData(source:String, successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getIngenicoData(source: source).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getCustomerList(indexOfPage: Int, successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getCustomerList(indexOfPage: indexOfPage).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getRegionList(countryName: String?, successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getRegionList(countryName: countryName).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getPaxDeviceList(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getPaxDeviceList().request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getSetting(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getSetting().request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getSearchCustomer(searchText: String, searchFetchLimit: Int, searchPageCount: Int,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getSearchCustomer(searchText: searchText, searchFetchLimit: searchFetchLimit, searchPageCount: searchPageCount).request(cancelAllRequests: true, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getCustomerDetail(id: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getCustomerDetail(id: id).request(cancelAllRequests: false, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func createOrder(parameters: JSONDictionary,isInvoice: Bool,requestTime: TimeInterval ,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.createOrder(parametersDict: parameters,isInvoice: isInvoice).requestNew(requestTime: requestTime, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func pushMultipleOrder(parameters: JSONArray,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.pushMultipleOrder(parameters: parameters).requestNew(isMultiOrder: true, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getRepresentativesList(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getRepresentativesList().request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func sendEmail(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.sendEmail(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func sendNote(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.sendNote(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getReceiptContent(orderID: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        let status = DataManager.isGooglePrinter ? "true" : "false"
        let MacAdrs = (DataManager.isGooglePrinter ? DataManager.starCloudMACaAddress : "") ?? ""
        HomeAPIServices.getReceiptContent(orderId: orderID, print_cloud_recipt: status, cloud_printer_address: MacAdrs).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    class func getTransactionPrintReceiptContent(transactionID: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        let status = DataManager.isGooglePrinter ? "true" : "false"
        let MacAdrs = (DataManager.isGooglePrinter ? DataManager.starCloudMACaAddress : "") ?? ""
        HomeAPIServices.getTransactionPrintReceiptContent(transactionID: transactionID, print_cloud_recipt: status, cloud_printer_address: MacAdrs).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    class func getReceiptEndDrawerContentURL(orderID: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getReceiptEndDrawerContentURL(orderId: orderID).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getReceiptEndDrawerDetails(orderID: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        let status = DataManager.isGooglePrinter ? "true" : "false"
        let MacAdrs = (DataManager.isGooglePrinter ? DataManager.starCloudMACaAddress : "") ?? ""
        HomeAPIServices.getReceiptEndDrawerDetails(orderId: orderID, print_cloud_recipt: status, cloud_printer_address: MacAdrs).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func calculateCart(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.calculateCart(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    class func startDrawer(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.startDrawer(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func startPayIn(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.startPayIn(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    class func startPayOut(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.startPayOut(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func endDrawer(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.endDrawer(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func giftCardBalance(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.giftCardBalance(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    class func giftCardActivate(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.giftCardActivate(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    class func giftCardDeactivate(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.giftCardDeactivate(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    class func giftCardReplace(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.giftCardReplace(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    class func giftCardReverse(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.giftCardReverse(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func giftGetBalance(number:String,type:String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.giftGetBalance(number: number, type: type).request(cancelAllRequests: true, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getSavedCardData(id: String,type: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getSavedCardData(id: id, type: type).request(cancelAllRequests: true, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getEmvSavedCardData(id: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getEmvSavedCardData(id: id).request(cancelAllRequests: true, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
    }
    
    class func getIngenicoSavedCardData(id: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        HomeAPIServices.getIngenicoSavedCardData(id: id).request(cancelAllRequests: true, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
    }
    
    class func getUserShippingAddress(UserId: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {

        HomeAPIServices.getUserShippingAddress(UserId: UserId).request(cancelAllRequests: true, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)

    }
    
    class func deletSavedCardData(id: String,type: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.deletSavedCardData(id: id, type: type).request(cancelAllRequests: true, success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getShippingCarrierList(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getShippingCarrierList().request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func sendShippingService(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.sendShippingService(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func updateSavedCardData(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.updateSavedCardData(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
    }
    
    class func updateUserShippingAddress(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.updateUserShippingAddress(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
    }
    
    class func putUserDetail(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.putUserDetail(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
      // socket sudama
    class func roomApi(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.roomApi().request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    //
    class func getSourcesList(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getSourcesList.request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getPrinterList(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getPrinterList.request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func getUpdatePrinterName(cloudPrinterAddress: String,cloudPrinterName: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.updatePrinterName(cloudPrinterAddress: cloudPrinterAddress, cloudPrinterName: cloudPrinterName).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    
    class func updateDeliveryStatus(parametersDict: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.updateDeliveryStatus(parametersDict: parametersDict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    // By Altab 18 Aug 2022
    class func getSerialNumberApi(productId: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getSerialNumber(productId: productId).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    // By Altab 24 Aug 2022
    class func getInvoiceTemplatesListApi(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        HomeAPIServices.getInvoiceTemplatesList().request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
    class func getProductInfoDetailsApi(productId: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) { // For product details Api By Altab (20Dec2022)
        
        HomeAPIServices.getProductInfoDetails(productId: productId).request(success: { (response) in
            if let responseDict = response as? JSONDictionary
            {
                successCallBack(responseDict)
            }
            else
            {
                successCallBack([:])
            }
        }, failure: failureCallBack)
        
    }
}

//
//  APIServices+Order.swift
//  HieCOR
//
//  Created by Deftsoft on 21/08/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation

//MARK: Enumeration
enum OrderAPIServices: APIService {
    case getOrder(url: String)
    case getSearchOrder(searchText: String , indexOfPage : Int)
    case getOrderInfo(orderId: String)
    case getTransactionInfo(orderId: String,isTransactionID: Bool)
    case getReturnConditions()
    case returnOrder(parameters: JSONDictionary)
    case refundOrder(parameters: JSONDictionary)
    case voidRefundTransaction(parameters: JSONDictionary)
    case saveSignatureOrder(parameters: JSONDictionary)
    case sendEmailOrText(url: String, parameters: JSONDictionary)
    case getDrawerHistory(source: String ,pageNumber: Int)
    case checkDrawerEnd(source: String)
    case saveCustomerPickupOrder(parameters: JSONDictionary)
    //Path
    var path: String {
        var path = ""
        
        switch self {
        case let .getOrder(url):
            path = url
            break
            
        case let .getSearchOrder(searchText, indexOfPage):
            if indexOfPage == -1 {
                path = String(format: "%@%@%@",BaseURL, kOrdersList,"orderID=\(searchText)")
            }else {
                path = String(format: "%@%@%@%@",BaseURL , kOrdersList , "orderID=\(searchText)" , "&perpage=20&page=\(indexOfPage)")
            }
            // path = String(format: "%@%@%@",BaseURL, kOrdersList,"orderID=\(searchText)")
            break
            
        case let .getOrderInfo(orderId):
            path = String(format: "%@%@%@",BaseURL,kGetOrderInfo,orderId)
            break
            
        case let .getTransactionInfo(orderId, isTransactionID):
            if isTransactionID {
                path = String(format: "%@%@%@",BaseURL,kGetTransations,orderId)
            }else {
                path = String(format: "%@%@%@%@",BaseURL,kGetTransations,"?orderID=",orderId)
            }
            break
            
        case .getReturnConditions():
            path = String(format: "%@%@",BaseURL, kGetReturnConditions)
            break
            
        case .returnOrder:
            path = String(format: "%@%@",BaseURL, kReturnProducts)
            break
            
        case .refundOrder:
            path = String(format: "%@%@",BaseURL, kRefund)
            break
            
        case .voidRefundTransaction:
            path = String(format: "%@%@",BaseURL, KVoidTransaction)
            break
            
        case .saveSignatureOrder:
            path = String(format: "%@%@",BaseURL, KSaveSignatureOrder)
            break
            
        case let .sendEmailOrText(url,_):
            path = url
            break
            
        case let .getDrawerHistory(source , pageNumber):
            //            path = String(format: "%@%@%@/?source=%@",BaseURL, kDrawerHistory ,DataManager.userID,source , "&perpage=20&page=\(pageNumber)")
            //            break
            
            if pageNumber == -1 {
                path = String(format: "%@%@%@/?source=%@",BaseURL, kDrawerHistory ,DataManager.userID,source)
            }else {
                path = String(format: "%@%@%@/?source=%@%@",BaseURL, kDrawerHistory ,DataManager.userID,source , "&perpage=10&page=\(pageNumber)")
            }
            break
            
        case let .checkDrawerEnd(source):
            path = String(format: "%@%@%@/?source=%@",BaseURL,kCheckDrawerEnd ,DataManager.userID,source)
            // path = String(format: "%@%@%@&key=%@",BaseURL, kGetCategories, DataManager.userID, searchText)
            
        case .saveCustomerPickupOrder:
            path = String(format: "%@%@",BaseURL, kSaveCustomerPickup)
            break
        }
        
        return path
    }
    
    //Resource
    var resource: Resource {
        var resource: Resource!
        let headers = ["Content-Type": "application/json", "X-USERNAME": DataManager.userName, "X-AUTH-KEY": DataManager.authKey, "X-AGENT-ID": DataManager.userID, "device_id": appDelegate.strDeviceUDID]
        
        switch self {
        case .getOrder:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getSearchOrder:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getOrderInfo:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getTransactionInfo:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .getReturnConditions:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case let .returnOrder(parameters):
            resource = Resource(method: .post, parameters: parameters, headers: headers)
            break
            
        case let .refundOrder(parameters):
            resource = Resource(method: .post, parameters: parameters, headers: headers)
            break
            
        case let .voidRefundTransaction(parameters):
            resource = Resource(method: .post, parameters: parameters, headers: headers)
            break
            
        case let .saveSignatureOrder(parameters):
            resource = Resource(method: .post, parameters: parameters, headers: headers)
            break
            
        case let .sendEmailOrText(_,parameters):
            resource = Resource(method: .post, parameters: parameters, headers: headers)
            break
            
        case .getDrawerHistory:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
            
        case .checkDrawerEnd:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            break
        case .saveCustomerPickupOrder(parameters: let parameters):
            resource = Resource(method: .post, parameters: parameters, headers: headers)
        }
        
        return resource
    }
    
    var multiOrder: MultiOrder {
        let resource: MultiOrder!
        switch self {
        default:
            resource = MultiOrder(method: .post, parameters: nil, headers: nil)
        }
        return resource
    }
    
}

//MARK: Class Functions
extension APIManager {
    
    class func getOrder(url: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.getOrder(url: url).request(success: { (response) in
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
    
    class func getSearchOrder(searchText: String,indexOfPage : Int ,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.getSearchOrder(searchText: searchText, indexOfPage: indexOfPage).request(success: { (response) in
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
    
    class func getOrderInfo(orderId: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.getOrderInfo(orderId: orderId).request(success: { (response) in
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
    
    class func getTransactionInfo(orderId: String,isTransactionID: Bool,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.getTransactionInfo(orderId: orderId,isTransactionID: isTransactionID).request(cancelAllRequests: true,success: { (response) in
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
    
    class func getReturnConditions(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.getReturnConditions().request(success: { (response) in
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
    
    class func returnOrder(parameters: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.returnOrder(parameters: parameters).request(success: { (response) in
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
    
    class func refundOrder(parameters: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.refundOrder(parameters: parameters).request(success: { (response) in
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
    
    class func voidRefundTransaction(parameters: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.voidRefundTransaction(parameters: parameters).request(success: { (response) in
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
    
    class func saveSignatureOrder(parameters: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.saveSignatureOrder(parameters: parameters).request(success: { (response) in
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
    
    class func sendEmailOrText(url: String,parameters: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.sendEmailOrText(url: url,parameters: parameters).request(success: { (response) in
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
    
    class func checkDrawerEnd(source: String,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.checkDrawerEnd(source: source).request(success: { (response) in
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
    
    class func getDrawerHistory(source: String ,pageNumber: Int ,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.getDrawerHistory(source: source , pageNumber: pageNumber).request(success: { (response) in
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
    
    class func saveCustomerPickupOrder(parameters: JSONDictionary,successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        OrderAPIServices.saveCustomerPickupOrder(parameters: parameters).request(success: { (response) in
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

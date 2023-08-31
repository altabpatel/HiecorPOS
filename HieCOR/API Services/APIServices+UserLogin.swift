//
//  UserLogin+APIServices.swift
//  HieCOR
//
//  Created by Deftsoft on 17/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

//MARK: Enumeration
enum LoginAPIServices: APIService {
    case ping()
    case login(parametersDict: JSONDictionary)
    case validatePIN(pin: String)
    case nonAdminValidatePIN(pin: String)
    case ZreportData(parametersDict: JSONDictionary)
    
    var path: String {
        var path = ""
        
        switch self {
        case .ping:
            path = BaseURL.appending(kGetPing)
        case .login:
            path = BaseURL.appending(kLogin)
        case .validatePIN:
            path = BaseURL.appending(kAccessPIN)
        case .nonAdminValidatePIN:
            path = BaseURL.appending(kNonAdminValidatePIN)
        case .ZreportData:
            path = BaseURL.appending(kZreportCheckData)
        }
        return path
    }
    
    var resource: Resource {
        var resource: Resource!
        let headers = ["Content-Type": "application/json", "X-USERNAME": DataManager.userName, "X-AUTH-KEY": DataManager.authKey, "X-AGENT-ID": DataManager.userID, "device_id": appDelegate.strDeviceUDID]
        
        switch self {
        case .ping:
            resource = Resource(method: .get, parameters: nil, headers: headers)
            
        case let .login(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            
        case let .validatePIN(pin):
            var parametersDict = JSONDictionary()
            parametersDict[APIKeys.kPin] = pin
            parametersDict[APIKeys.kUserID] = DataManager.userID
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            
        case let .nonAdminValidatePIN(pin):
            var parametersDict = JSONDictionary()
            parametersDict[APIKeys.kPin] = pin
            parametersDict[APIKeys.kUserID] = DataManager.userID
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
            
        case let .ZreportData(parametersDict):
            resource = Resource(method: .post, parameters: parametersDict, headers: headers)
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
    
    class func ping(successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        LoginAPIServices.ping().request(success: { (response) in
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
    
    class func login(parametersDict: JSONDictionary, successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        LoginAPIServices.login(parametersDict: parametersDict).request(success: { (response) in
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
    
    class func validatePIN(pin: String, successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        LoginAPIServices.validatePIN(pin: pin).request(success: { (response) in
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
    
    class func nonAdminValidatePIN(pin: String, successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        LoginAPIServices.nonAdminValidatePIN(pin: pin).request(success: { (response) in
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
    
    class func Zreport(parametersDict: JSONDictionary, successCallBack: @escaping JSONDictionaryResponseCallback, failureCallBack: @escaping APIServiceFailureCallback) {
        
        LoginAPIServices.ZreportData(parametersDict: parametersDict).request(success: { (response) in
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

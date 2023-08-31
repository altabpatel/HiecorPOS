//
//  LoginVM.swift
//  HieCOR
//
//  Created by Deftsoft on 17/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

class LoginVM {
    
    //MARK: Variables
    
    //Mark: Create Shared Instance
    public static let shared = LoginVM()
    private init() {}
    
    //MARK: Class Functions
    func ping(responseCallBack: @escaping responseCallBack) {
        
        APIManager.ping(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
            }else{
                responseCallBack(0, responseDict![APIKeys.kMessage] as? String, nil)
            }
        }) { (errorReason, error) in
            if error?.code != -999 {
                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                debugPrint(errorReason ?? "")
            }
        }
    }
    
    func login(parametersDict: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.login(parametersDict: parametersDict, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseUserloginData(responseDict: responseDict!)
                responseCallBack(1, kEmptyString, nil)
            }else{
                responseCallBack(0, responseDict![APIKeys.kError] as? String, nil)
            }
        }) { (errorReason, error) in
            if error?.code != -999 {
                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                debugPrint(errorReason ?? "")
            }
        }
    }
    
    func validatePIN(pin: String, responseCallBack: @escaping responseCallBack) {
        
        APIManager.validatePIN(pin: pin, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseUserPinData(responseDict: responseDict!)
                responseCallBack(1, kEmptyString, nil)
            }else{
                responseCallBack(0, responseDict![APIKeys.kError] as? String, nil)
            }
        }) { (errorReason, error) in
            if error?.code != -999 {
                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                debugPrint(errorReason ?? "")
            }
        }
    }
    
    func nonAdminValidatePIN(pin: String, responseCallBack: @escaping responseCallBack) {
        
        APIManager.nonAdminValidatePIN(pin: pin, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                // self.parseUserPinData(responseDict: responseDict!)
                responseCallBack(1, kEmptyString, nil)
            }else{
                responseCallBack(0, responseDict![APIKeys.kError] as? String, nil)
            }
        }) { (errorReason, error) in
            if error?.code != -999 {
                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                debugPrint(errorReason ?? "")
            }
        }
    }
    
    func zreportdata(parametersDict: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.Zreport(parametersDict: parametersDict, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                //self.parseUserloginData(responseDict: responseDict!)
                responseCallBack(1, kEmptyString, nil)
            }else{
                responseCallBack(0, responseDict![APIKeys.kError] as? String, nil)
            }
        }) { (errorReason, error) in
            if error?.code != -999 {
                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                debugPrint(errorReason ?? "")
            }
        }
    }
    
}

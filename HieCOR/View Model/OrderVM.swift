//
//  OrderVM.swift
//  HieCOR
//
//  Created by Deftsoft on 21/08/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation

class OrderVM {
    
    //MARK: Variables
    var isMoreOrderFound = true
    var isMoreEndDrawerFound = true
    var totalRecord = String()
    var ordersList = [String: [OrdersHistoryList]]()
    var orderInfo = OrderInfoModel()
    var productReturnStatus = Bool()
    var transactionInfoArray = [TransactionsDetailModel]()
    var returnConditions = [ConditionsForReturnModel]()
	var drawerHistory = [DrawerHistoryModel]()
    var drawerHistoryOpen = [DrawerHistoryModel]()
    var drawerHistoryEnd = [DrawerHistoryModel]()
    var checkDrawerEnd = [DrawerHistoryModel]()
    var refundData = RefundOrderDataModel()
    var transactionVoidData = VoidTransactionDataModel()
    
    //MARK: Create Shared Instance
    public static let shared = OrderVM()
    private init() {}
    
    //MARK: Class Functions
    func getOrder(url: String, startDate: String? = nil, endDate: String? = nil, pageNumber: Int? = nil, responseCallBack: @escaping responseCallBack) {
        //Offline
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            CDManager.shared.fetchAllOrders(startDate: startDate, endDate: endDate, pageNumber: pageNumber, responseCallBack: { (success, message, error) in
                responseCallBack(success, message, error)
            })
            return
        }
        //Online
        APIManager.getOrder(url: url, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseOrderData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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
    
    func getSearchOrder(searchText: String, pageNumber: Int? = nil, responseCallBack: @escaping responseCallBack) {
        
        APIManager.getSearchOrder(searchText: searchText, indexOfPage: pageNumber!, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.ordersList.removeAll()
                self.parseOrderData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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

    func getOrderInfo(orderId: String, responseCallBack: @escaping responseCallBack) {
        
        APIManager.getOrderInfo(orderId: orderId, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseOrderInfoData(responseDict: responseDict!)
            
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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

    func getTransactionInfo(orderId: String, isTransactionID: Bool? = false, responseCallBack: @escaping responseCallBack) {
        
        APIManager.getTransactionInfo(orderId: orderId,isTransactionID: isTransactionID!, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseTransactionInfoData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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

    func getReturnConditions(responseCallBack: @escaping responseCallBack) {
        
        APIManager.getReturnConditions(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseReturnConditionData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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
    
    func returnOrder(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.returnOrder(parameters: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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

    func refundOrder(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.refundOrder(parameters: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseRefundOrderData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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
    
    func voidRefundTransaction(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.voidRefundTransaction(parameters: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseVoidTrnsactionData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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
    
    func saveSignatureOrder(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.saveSignatureOrder(parameters: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                //self.parseVoidTrnsactionData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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

    func sendEmailOrText(url: String,parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.sendEmailOrText(url: url,parameters: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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

//    func checkDrawerEnd(source: String, responseCallBack: @escaping responseCallBack) {
//
//        APIManager.checkDrawerEnd(source: source, successCallBack: { (responseDict) in
//            if responseDict?[kSuccess] as? Int == 1 {
//                self.checkDrawerEnd.removeAll()
//                self.parseCheckDrawerEndData(responseDict: responseDict!)
//                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
//            }else{
//                responseCallBack(0, responseDict![APIKeys.kError] as? String, nil)
//            }
//        }) { (errorReason, error) in
//            if error?.code != -999 {
//                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
//                debugPrint(errorReason ?? "")
//            }
//        }
//    }
    
    func checkDrawerEnd(source: String,responseCallBack: @escaping responseCallBack) {
        let strurl = String(format: "%@%@%@/?source=%@",BaseURL,kCheckDrawerEnd ,DataManager.userID,source)
        print(strurl)

        let generalDelimitersToEncode = "#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;%"

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        let dataOne = strurl.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        print(dataOne ?? "")
        guard let url = URL(string: dataOne ?? "") else { return }
        print(url)
        let request = NSMutableURLRequest(url:url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(DataManager.userName, forHTTPHeaderField: "X-USERNAME")
        request.setValue(DataManager.authKey, forHTTPHeaderField:"X-AUTH-KEY")
        request.setValue(DataManager.userID, forHTTPHeaderField: "X-AGENT-ID")//**
        request.httpMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared

        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let res = response as? HTTPURLResponse {
                print("res: \(String(describing: res))")
                print("Response: \(String(describing: response))")
                guard let data = data else {
                    //completion(.failure(.noData))
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    if let responseDict = json as? JSONDictionary {
                        if responseDict[kSuccess] as? Int == 1 {
                            self.checkDrawerEnd.removeAll()
                            self.parseCheckDrawerEndData(responseDict: responseDict)
                            responseCallBack(1, responseDict[APIKeys.kMessage] as? String, nil)
                        }else{
                            responseCallBack(0, responseDict[APIKeys.kError] as? String, nil)
                        }
                    }

                } catch let error as NSError{
                    print(error.localizedDescription)
                    if error.code != -999 {
                        responseCallBack(0, nil, error)
                    }
                    //completion(.failure(.invalidSerialization))
                }
            }else{
                print("Error: \(String(describing: error))")
               // if error.code != -999 {
                responseCallBack(0, nil, error as NSError?)
              //  }
            }
        }
        mData.resume()

    }
    
    func getDrawerHistory(source: String,pageNumber: Int,responseCallBack: @escaping responseCallBack) {
        
        APIManager.getDrawerHistory(source: source,pageNumber: pageNumber , successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                if pageNumber == -1 {   // Offline Data Parsing if page number == -1
                    //  self.parseCategoryDataOffline(responseDict: responseDict!)
                }else {                 //Online Data Parsing
                    
                    if pageNumber == 1 {
                        self.isMoreEndDrawerFound = true
                         self.drawerHistoryEnd.removeAll()
                         self.drawerHistoryOpen.removeAll()
//                        self.isAllDataLoaded[1] = true
//                        self.checkIsDataLoaded()
                    }
                    self.drawerHistoryOpen.removeAll()
                     self.parseDrawerHistoryData(responseDict: responseDict!)
                }
                
                
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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
    
    //saveCustomerPickupOrder
    func saveCustomerPickupOrder(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.saveCustomerPickupOrder(parameters: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                //self.parseVoidTrnsactionData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
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

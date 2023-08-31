//
//  OfflineDataManager.swift
//  HieCOR
//
//  Created by Deftsoft on 18/10/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation
import CoreData

class OfflineDataManager: NSObject {
    
    //MARK: Variables
    var reach: Reachability?
    var delegate: OfflineDataManagerDelegate?
    var productContainerDelegate: OfflineDataManagerDelegate?
    var cartContainerDelegate: OfflineDataManagerDelegate?
    var manualPaymentDelegate: OfflineDataManagerDelegate?
    var paymentTypeDelegate: OfflineDataManagerDelegate?
    var iPadPaymentTypeDelegate: OfflineDataManagerDelegate?
    var orderSuccessDelegate: OfflineDataManagerDelegate?
    var settingDelegate: OfflineDataManagerDelegate?
    var menuDelegate: OfflineDataManagerDelegate?
    var orderHistoryDelegate: OfflineDataManagerDelegate?
    var orderArray = JSONArray()
    var orderNewArray = JSONArray()
    var orderNewArray1 = JSONArray()
    var orderArrayFinal = JSONArray()

    //Mark: Create Shared Instance
    public static let shared = OfflineDataManager()
    private override init() {}
    
    //MARK: Class Functions
    func initialize() {
        //Enable Reachability
        self.reach = Reachability.forInternetConnection()
        self.reach!.startNotifier()
        //Add Observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        //Check Orders
        self.checkOrders()
    }
    
    @objc func reachabilityChanged(notification: NSNotification) {
        if SwipeAndSearchVC.shared.isEnable {
            if (UI_USER_INTERFACE_IDIOM() == .pad && SwipeAndSearchVC.shared.isProductSearching) || (UI_USER_INTERFACE_IDIOM() == .phone) {
                delegate?.didUpdateInternetConnection?(isOn: self.reach?.currentReachabilityStatus().rawValue != 0 )
                productContainerDelegate?.didUpdateInternetConnection?(isOn: self.reach?.currentReachabilityStatus().rawValue != 0 )
            }
            cartContainerDelegate?.didUpdateInternetConnection?(isOn: self.reach?.currentReachabilityStatus().rawValue != 0 )
            manualPaymentDelegate?.didUpdateInternetConnection?(isOn: self.reach?.currentReachabilityStatus().rawValue != 0 )
            paymentTypeDelegate?.didUpdateInternetConnection?(isOn: self.reach?.currentReachabilityStatus().rawValue != 0 )
            iPadPaymentTypeDelegate?.didUpdateInternetConnection?(isOn: self.reach?.currentReachabilityStatus().rawValue != 0 )
        }
        orderSuccessDelegate?.didUpdateInternetConnection?(isOn: self.reach?.currentReachabilityStatus().rawValue != 0 )
        settingDelegate?.didUpdateInternetConnection?(isOn: self.reach?.currentReachabilityStatus().rawValue != 0 )
        orderHistoryDelegate?.didUpdateInternetConnection?(isOn: self.reach?.currentReachabilityStatus().rawValue != 0 )
        menuDelegate?.didUpdateInternetConnection?(isOn: self.reach?.currentReachabilityStatus().rawValue != 0 )
        //Check Orders
        self.checkOrders()
    }
    
    private func checkOrders() {
        if self.reach?.currentReachabilityStatus().rawValue != 0 {
            //Online
           // by sudama offline
            orderArray.removeAll()
            orderNewArray.removeAll()
            DispatchQueue.main.async {
                //var orderArray = JSONArray()
                var orderArrayOne = JSONArray()
                
                let orders: [Orders] = NSManagedObject.fetch()
                for order in orders {
                    if let orderData = order.data {
                        let parameters = NSKeyedUnarchiver.unarchiveObject(with: orderData)
                        if let parametersDict = parameters as? JSONDictionary {
                            self.orderArray.append(parametersDict)
                            orderArrayOne.append(["test": true])
                        }
                    }
                }
                
                if self.orderArray.count > 0{
                    for i in 0..<self.orderArray.count {
                        let val = self.orderArray[i]["isOfflineTransction"] as? Bool
                        if !val! {
                            self.orderNewArray.append(self.orderArray[i])
                        }
                    }
                }
                
//
//                if self.orderNewArray.count == 0 {
//                    return
//                }
                //Call API To Create Orders
                if self.orderNewArray.count > 0 {
                    self.callAPIToPushMultipleOrder(parameters: self.orderNewArray)
                }
            }//
        }
    }
}

//MARK: API Methods
extension OfflineDataManager {
    func callAPIToPushMultipleOrder(parameters: JSONArray) {
        //Call API
        HomeVM.shared.pushMultipleOrder(parameters: parameters, responseCallBack: { (success, message, error) in
//            if success == 1 {
                DataManager.offlineOrderdataAPIData?.removeAll()
                // by sudama offline
                //self.orderArray.removeAll()
                self.orderArrayFinal.removeAll()
                self.orderNewArray1.removeAll()
                var successOrder = 0
                var unSuccessOrder = 0
                
                for i in 0..<self.orderArray.count {
                    let val = self.orderArray[i]["isOfflineTransction"] as? Bool
                    if !val! {
                        self.orderNewArray1.append(self.orderArray[i])
                    }else{
                        self.orderArrayFinal.append(self.orderArray[i])
                    }
                }
                
                if self.orderNewArray1.count > 0 {
                    if HomeVM.shared.muttipleOrderList.count > 0 {
                        for i in 0..<HomeVM.shared.muttipleOrderList.count {
                            if !HomeVM.shared.muttipleOrderList[i].status {
//                                self.orderNewArray1[i]["isOfflineTransction"] = true
//                                self.orderArrayFinal.append(self.orderNewArray1[i])
//                                if DataManager.offlineOrderdata == nil {
//                                    DataManager.offlineOrderdata = self.orderArrayFinal
//                                } else {
//                                    DataManager.offlineOrderdata?.append(self.orderNewArray1[i])
//                                }
                                unSuccessOrder = unSuccessOrder + 1
                            }else{
                                 successOrder = successOrder + 1
                            }
                        }
                    }
                }
                    let pp = "\(successOrder)" + " order processed successfully & " + "\(unSuccessOrder)" + " orders invalid "
//                    let title = ""
//                    let message = pp
                appDelegate.showToast(message: pp)

//                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//                    alert.addAction(action)
//
//                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                
                if self.orderArrayFinal.count > 0 {
                    //DataManager.offlineOrderdata = self.orderArrayFinal
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: nil)
                    CDManager.shared.deleteAllData(with: .order)
                    self.orderArrayFinal.removeAll()
//                    let f = self.orderArrayFinal as? JSONDictionary
//                    CDManager.shared.saveOrder(parameters: f!, isInvoice: true) { (success, message, error) in
//
//                    }
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: nil)
                    CDManager.shared.deleteAllData(with: .order)
                    self.orderArrayFinal.removeAll()
                    DataManager.offlineOrderdataAPIData?.removeAll()
                }
                
               //
//            } else {
//                //Show Error Message
//            }
        })
    }
}

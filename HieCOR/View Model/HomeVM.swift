//
//  HomeVM.swift
//  HieCOR
//
//  Created by Deftsoft on 20/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation
import CoreData

class HomeVM {
    
    //MARK: Variables
    var isAllDataLoaded = [false, false, false]
    var categoriesArray = [CategoriesModel]()
    var searchCategoriesArray = [CategoriesModel]()
    var productsArray = [ProductsModel]()
    var updatedProduct = ProductsModel()
    var searchProductsArray = [ProductsModel]()
    var isMoreCategoryFound = true
    var isMoreProductFound = true
    var taxList = [TaxListModel]()
    var coupanList = [CouponsListModel]()
    var ingenicoData = [IngenicoModel]()
    var MailingList = [MailingListModel]()
    var taxSetting = Dictionary<String,AnyObject>()
    var customerList = [CustomerListModel]()
    var searchCustomerList = [CustomerListModel]()
    var customerDetail = CustomerListModel()
    var isMoreCustomerFound = true
    var isMoreSearchCustomerFound = true
    var regionsList = [RegionsListModel]()
    var userData = [String:AnyObject]()
    var representativesList = [RepresentativesListForInvoiceModel]()
    var receiptModel = ReceiptContentModel()
    var receiptEndDrawerURL = ReceiptEndDrawerURL()
    var receiptDetailsModel = ReceiptEndDrawerDetailsModel()
    var coupanDetail = CoupanDetail()
    var paxDeviceList = [PAXDeviceList]()
    var settingList = [SettingListData]()
    var muttipleOrderList = [MultipleOrderData]() // by sudama
    var contactSourcesList = [String]()    //by anand
    var countryDetail = [CountryDetail]()
    var cartCalculationDetail = CartCalculationDetail()
    var currentDrawerDetail = [DrawerHistoryModel]()
    var payInDataDetail = [DrawerHistoryModel]()
    var payOutDataDetail = [DrawerHistoryModel]()
    var paidInOutModel = DrawerHistoryModel()
    var multicardErrorResponse = JSONDictionary()
    var productSetting = [ProductSetting]()
    var delegate: CartContainerViewControllerDelegate?
    var DueShared = Double()
    var amountPaid = Double()
    var errorTip = 0.0
    var tipValue = Double()
    var MultiTipValue = Double()
    var TotalDue = Double()
    var customerUserId = String()
    var giftBalance = [GetBalanceModel]()
    var savedCardList = [SavedCardList]()
    var shippingCarrierList = [ShippingCarrierDataModel]()
    var shippingServiceList = [ShippingServiceDataModel]()
    var ShippingUserAddress = [UserShippingAddress]()
    var jsonArray = JSONArray()
    var customerFacingDeviceList = [CustomerFacingDeviceList]()
    var sourcesList = [String]()
    var starCloudPrinterModel = GetPrinterDataModel()
    var orderDeliveryStatusArry = [OrderDeliveryStatus]()
    var SerialNumberDataListAry = [SerialNumberDataModel]()//SerialNumberDataModel
    var objInvoiceTemplateModel = InvoiceTemplateDataModel()
    var customerStatusArray = [String]()
    var objProductsInfo = ProductsModel()
    //MARK: Create Shared Instance
    public static let shared = HomeVM()
    private init() {}
    
    //MARK: Class Functions
    private func checkIsDataLoaded() {
        if !self.isAllDataLoaded.contains(false) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ShowKeyboard"), object: nil)
        }
    }
    
    func getCategory(pageNumber: Int, responseCallBack: @escaping responseCallBack) {
        //Offline
        //        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline && pageNumber != -1  {
        //            CDManager.shared.fetchAllCategory(pageNumber: pageNumber, responseCallBack: { (success, message, error) in
        //                self.isAllDataLoaded[0] = true
        //                self.checkIsDataLoaded()
        //                responseCallBack(success, message, error)
        //            })
        //            return
        //        }
        //Online
        if UI_USER_INTERFACE_IDIOM() == .phone {
            SwipeAndSearchVC.shared.isResponseReceived = false
        }
        APIManager.getCategory(pageNumber: pageNumber, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                if pageNumber == -1 {   // Offline Data Parsing if page number == -1
                    self.parseCategoryDataOffline(responseDict: responseDict!)
                }else {                 //Online Data Parsing
                    self.isAllDataLoaded[0] = true
                    self.checkIsDataLoaded()
                    if pageNumber == 1 {
                        self.isMoreCategoryFound = true
                        self.categoriesArray.removeAll()
                    }
                    self.parseCategoryData(responseDict: responseDict!)
                }
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    SwipeAndSearchVC.shared.isResponseReceived = true
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
    
    func getProduct(categoryName: String, pageNumber: Int, responseCallBack: @escaping responseCallBack) {
        //Offline
        //        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline && pageNumber != -1  {
        //            CDManager.shared.fetchAllProducts(categoryName: categoryName,pageNumber: pageNumber, responseCallBack: { (success, message, error) in
        //                self.isAllDataLoaded[1] = true
        //                self.checkIsDataLoaded()
        //                responseCallBack(success, message, error)
        //            })
        //            return
        //        }
        //Online
        SwipeAndSearchVC.shared.isResponseReceived = false
        APIManager.getProduct(categoryName: categoryName, pageNumber: pageNumber, successCallBack: { (responseDict) in
            SwipeAndSearchVC.shared.isResponseReceived = true
            Indicator.sharedInstance.hideIndicator()
            if responseDict?[kSuccess] as? Int == 1 {
                if categoryName == "" && pageNumber == -1 { //Offline
                    self.parseProductDataOffline(responseDict: responseDict!)
                }else {                 //Online
                    if pageNumber == 1 {
                        self.isMoreProductFound = true
                        self.productsArray.removeAll()
                        self.isAllDataLoaded[1] = true
                        self.checkIsDataLoaded()
                    }
                    self.parseProductData(responseDict: responseDict!)
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
    
    func getSearchProduct(searchText: String, searchFetchLimit: Int, searchPageCount: Int, responseCallBack: @escaping responseCallBack) {
        //Offline
        //        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
        //            CDManager.shared.fetchAllProducts(searchText: searchText,pageNumber: searchPageCount, responseCallBack: { (success, message, error) in
        //                responseCallBack(success, message, error)
        //            })
        //            return
        //        }
        //Online
        APIManager.getSearchProduct(searchText: searchText, searchFetchLimit: searchFetchLimit, searchPageCount: searchPageCount, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                if searchPageCount == 1 {
                    self.isMoreProductFound = true
                    self.searchProductsArray.removeAll()
                }
                self.parseSearchProductData(responseDict: responseDict!)
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
    
    func updateProductService(parameters: JSONDictionary,imageDict: [String: Data]?, responseCallBack: @escaping responseCallBack) {
        
        APIManager.updateProductService(parameters: parameters, imageDict: imageDict, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseUpdatedProductData(responseDict: responseDict!)
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
    
    func getSearchCategory(searchText: String, responseCallBack: @escaping responseCallBack) {
        //Offline
        //        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline  {
        //            CDManager.shared.fetchAllCategory(searchText: searchText, responseCallBack: { (success, message, error) in
        //                responseCallBack(success, message, error)
        //            })
        //            return
        //        }
        //Online
        APIManager.getSearchCategory(searchText: searchText, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseSearchCategoryData(responseDict: responseDict!)
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
    
    func getTaxList(isForOffline: Bool? = false, responseCallBack: @escaping responseCallBack) {
        //Offline
        //        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline && !isForOffline! {
        //            CDManager.shared.fetchAllTaxes(responseCallBack: { (success, message, error) in
        //                self.isAllDataLoaded[2] = true
        //                self.checkIsDataLoaded()
        //                responseCallBack(success, message, error)
        //            })
        //            return
        //        }
        //Online
        APIManager.getTaxList(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                if isForOffline! {
                    self.parseTaxDataOffline(responseDict: responseDict!)
                }else {
                    self.isAllDataLoaded[2] = true
                    self.checkIsDataLoaded()
                    self.parseTaxData(responseDict: responseDict!)
                }
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
            }else{
                self.taxList.removeAll()
                responseCallBack(0, responseDict![APIKeys.kError] as? String, nil)
            }
        }) { (errorReason, error) in
            if error?.code != -999 {
                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                debugPrint(errorReason ?? "")
            }
        }
    }
    
    func getMailingList(responseCallBack: @escaping responseCallBack) {
        APIManager.getMailingList(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseMailingData(responseDict: responseDict!)
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
    
    func getCoupanList(responseCallBack: @escaping responseCallBack) {
        APIManager.getCoupanList(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseCoupanData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
            }else{
                self.coupanList.removeAll()
                responseCallBack(0, responseDict![APIKeys.kError] as? String, nil)
            }
        }) { (errorReason, error) in
            if error?.code != -999 {
                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                debugPrint(errorReason ?? "")
            }
        }
    }
    
    func getIngenicoData(source: String ,responseCallBack: @escaping responseCallBack) {
        APIManager.getIngenicoData(source: source, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseIngenicoData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
            }else{
                //self.coupanList.removeAll()
                responseCallBack(0, responseDict![APIKeys.kError] as? String, nil)
            }
        }) { (errorReason, error) in
            if error?.code != -999 {
                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                debugPrint(errorReason ?? "")
            }
        }
    }
    
    func getCustomerList(indexOfPage: Int,responseCallBack: @escaping responseCallBack) {
        //Offline
        //        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline && indexOfPage != -1  {
        //            CDManager.shared.fetchAllCustomer(pageNumber: indexOfPage, responseCallBack: { (success, message, error) in
        //                responseCallBack(success, message, error)
        //            })
        //            return
        //        }
        //Online
        APIManager.getCustomerList(indexOfPage: indexOfPage, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                if indexOfPage == -1 {
                    self.parseCustomerDataOffline(responseDict: responseDict!)
                }else {
                    if indexOfPage == 1 {
                        self.isMoreCustomerFound = true
                        self.customerList.removeAll()
                    }
                    
                    self.parseCustomerData(responseDict: responseDict!)
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
    
//    func getCoupanProductIDList(coupan: String,responseCallBack: @escaping responseCallBack) {
//
//        APIManager.getCoupanProductIDList(coupan: coupan, successCallBack: { (responseDict) in
//            if responseDict?[kSuccess] as? Int == 1 {
//                self.parseCoupanProductIDListData(responseDict: responseDict!)
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
    
    func getCoupanProductIDList(coupan: String,responseCallBack: @escaping responseCallBack) {
        let strurl = String(describing: BaseURL + kGetCouponsList + "?coupon_code=" + coupan)
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
                        self.parseCoupanProductIDListData(responseDict: responseDict )
                        responseCallBack(1, responseDict[APIKeys.kMessage] as? String, nil)
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
    
    func getCountryList(country: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.getCountryList(country: country, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseCountryListData(responseDict: responseDict!)
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
    
    func getRegionList(countryName: String? = nil, isForOffline: Bool? = false, responseCallBack: @escaping responseCallBack) {
        //Offline
        //        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline && !isForOffline! {
        //            CDManager.shared.fetchAllRegions(responseCallBack: { (success, message, error) in
        //                responseCallBack(success, message, error)
        //            })
        //            return
        //        }
        //Online
        APIManager.getRegionList(countryName:countryName, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                if isForOffline! {
                    self.parseRegionDataOffline(responseDict: responseDict!)
                }else {
                    self.parseRegionData(responseDict: responseDict!)
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
    
    func getPaxDeviceList(responseCallBack: @escaping responseCallBack) {
        
        APIManager.getPaxDeviceList(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parsePAXData(responseDict: responseDict!)
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
    
    
    func getSetting(responseCallBack: @escaping responseCallBack) {
                          
        APIManager.getSetting(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseSettingData(responseDict: responseDict!)
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
    
    //by anand
    func getContactSources(responseCallBack: @escaping responseCallBack) {
                          
        APIManager.getContactSources(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseGetContactSource(responseDict: responseDict!)
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
    //end anand
    func getSearchCustomer(searchText: String, searchFetchLimit: Int, searchPageCount: Int, responseCallBack: @escaping responseCallBack) {
        //Offline
        //        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline && searchPageCount != -1  {
        //            CDManager.shared.fetchAllCustomer(searchText: searchText,pageNumber: searchPageCount, responseCallBack: { (success, message, error) in
        //                responseCallBack(success, message, error)
        //            })
        //            return
        //        }
        //Online
        APIManager.getSearchCustomer(searchText: searchText, searchFetchLimit: searchFetchLimit, searchPageCount: searchPageCount, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                if searchPageCount == 1 {
                    self.isMoreSearchCustomerFound = true
                    self.searchCustomerList.removeAll()
                }
                self.parseSearchCustomerData(responseDict: responseDict!)
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
    
    func getCustomerDetail(id: String, responseCallBack: @escaping responseCallBack) {
        APIManager.getCustomerDetail(id: id, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseCustomerDetailData(responseDict: responseDict!)
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
    
    func createOrder(parameters: JSONDictionary, isInvoice: Bool, isMulticard: Bool = false, responseCallBack: @escaping responseCallBack) {
        self.multicardErrorResponse.removeAll()
        //Offline
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            CDManager.shared.saveOrder(parameters: parameters,isInvoice: isInvoice, responseCallBack: { (success, message, error) in
                responseCallBack(success, message, error)
               // DataManager.offlineOrderdata?.removeAll()
                self.jsonArray.removeAll()
                let orders: [Orders] = NSManagedObject.fetch()

                for order in orders {
                    if let orderData = order.data {
                        let parameters = NSKeyedUnarchiver.unarchiveObject(with: orderData)
                        if let parametersDict = parameters as? JSONDictionary {
                            self.jsonArray.append(parametersDict)
                            //DataManager.offlineOrderdata?.append(parametersDict)
                            //self.userData = parametersDict as [String : AnyObject]
                        }
                    }
                }
                
                DataManager.offlineOrderdataAPIData = self.jsonArray
                
            })
            return
        }
        
        //Set Request Time For Pax & Normal Payment methods, By Default it is 180 sec
        var requestTime: TimeInterval = 180
        if let multicard = parameters["multi_card"] as? JSONDictionary {
            if let paxArray = multicard["pax_pay"] as? JSONArray {
                var time = paxArray.count * 120
                time = time < 180 ? 180 : time
                requestTime = TimeInterval(exactly: time) ?? 180
            }
        }
        
        //Online
        APIManager.createOrder(parameters: parameters,isInvoice: isInvoice,requestTime: requestTime, successCallBack: { (responseDict) in
            
            DataManager.recentOrderID = nil
            //            DataManager.RemaingAmount = 0
            if responseDict?[kSuccess] as? Int == 1 {
                appDelegate.amount = 0.0
                DataManager.errorOccure = false
                self.parseCreateOrderData(responseDict: responseDict!)
                if let dict = responseDict!["data"] as? JSONDictionary {
                    
                    // MARK Hide for V5
                    
                    if let id = dict["userID"] as? String {
                        self.customerUserId = id
                       if DataManager.customerId == "" {
                           DataManager.customerId = id
                        }
                    }
                    
                    if let remainingamtAmt = dict["balance_due"] as? Double {
                        //  DataManager.cartData!["balance_due"] = remainingamt
                        
                        var remainingamt = remainingamtAmt
                        if remainingamt <= 0 {
                            remainingamt = 0
                            DataManager.isBalanceDueData = false
                            self.DueShared = remainingamt
                            self.amountPaid = 0.0
                            self.tipValue = 0.0
                            DataManager.duebalanceData = 0.0
                            DataManager.cartData?.removeAll()
                            //DataManager.cartData!["balance_due"] = 0.0
                            //DataManager.cartData!["Total_due"] = 0.0
                        } else {
                            remainingamt = remainingamtAmt
                            DataManager.isBalanceDueData = true
                            self.DueShared = remainingamt
                            
                            if let orderId = dict["order_id"] as? Int {
                                DataManager.recentOrderID = orderId
                            }
                            
                            if let tipamt = dict["totalTip"] as? String {
                                self.tipValue = tipamt.toDouble() ?? 0.00
                                if  DataManager.cartData != nil {
                                    DataManager.cartData!["tipAmount_due"] = self.tipValue
                                }
                                //let price = Double((obj as AnyObject).value(forKey: "productprice") as? String  ?? "0") ?? 0.00
                            }
                            
                            if let orderId = dict["order_id"] as? Int {
                                DataManager.recentOrderID = orderId
                            }
                            if let orderId = dict["order_id"] as? String {
                                DataManager.recentOrderID = Int(orderId)
                            }
                            if let amountPaid = dict["amount_paid"] as? Double {
                                self.amountPaid = amountPaid
                            }
                            
                            if  DataManager.cartData != nil {
                                DataManager.cartData!["balance_due"] = remainingamt
                            }
                            
                            let value = (dict["total"] as? String)?.toDouble()
                            
                            self.TotalDue = value ?? 0.00
                            
                            //let dueBal = value! - remainingamt
                            
                            if  DataManager.cartData != nil {
                                DataManager.cartData!["Total_due"] = value
                            }
                        }
                        
                        
//                        let rem =  value! - self.tipValue
//
//                        if remainingamt < rem {
//                            DataManager.isPartialAprrov = true
//                        } else {
//                            DataManager.isPartialAprrov = false
//                        }
                        //UserDefaults.standard.set(dueBal, forKey: "datavaluedue")
                        //DataManager.duebalanceData = remainingamt
                        //self.DueShared = remainingamt
                    } else{
                        if let paymentType = dict["payment_type"] as? String {
                            if paymentType == "invoice" {
                                DataManager.isBalanceDueData = false
                                self.DueShared = 0
                                self.amountPaid = 0.0
                                self.tipValue = 0.0
                                DataManager.duebalanceData = 0.0
                                DataManager.cartData?.removeAll()
                            }
                        }
                    }
                    
                }
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
            }else{
                if let dict = responseDict!["data"] as? JSONDictionary {
                    
                    if let error = responseDict!["error"] as? String {
                        if let nametype = dict["payment_type"] as? String {
                            if nametype == "credit" {
                                if error != "" {
                                    DataManager.errorOccure = true
                                } else {
                                    DataManager.errorOccure = false
                                }
                            } else {
                                DataManager.errorOccure = false
                            }
                        }
                    }
                    
                    if let orderId = dict["order_id"] as? Int {
                        DataManager.recentOrderID = orderId
                    }
                    
                    if let id = dict["userID"] as? String {
                        self.customerUserId = id
                    }
                    
                    // MARK Hide for V5
                    
                    if let tipamtVal = dict["tip"] as? String {
                        self.errorTip = tipamtVal.toDouble() ?? 0.00
                    }
                    
                    if let tipamt = dict["totalTip"] as? String {
                        self.tipValue = tipamt.toDouble() ?? 0.00
                        if DataManager.cartData != nil {
                            DataManager.cartData!["tipAmount_due"] = self.tipValue
                        }
                        //let price = Double((obj as AnyObject).value(forKey: "productprice") as? String  ?? "0") ?? 0.00

                    }
                    
                    if let orderId = dict["order_id"] as? Int {
                        DataManager.recentOrderID = orderId
                    }
                  
                    if let error_billing = dict["billing_profile_id"] as? String {
                        if error_billing != "" {
                            DataManager.Bbpid = error_billing
                            DataManager.ErrorBbpid = error_billing
                        }
                    }

                    
                    if let remainingamt = dict["balance_due"] as? Double {
                      //  DataManager.cartData!["balance_due"] = remainingamt
                        if  DataManager.cartData != nil {
                            DataManager.cartData!["balance_due"] = remainingamt
                        }
                        
                        let value = (dict["total"] as? String)?.toDouble()
                        
                        self.TotalDue = value ?? 0.00
                        
                        let dueBal = value! - remainingamt
                        if DataManager.cartData != nil {
                            DataManager.cartData!["Total_due"] = value
                        }
                        
                        let rem =  value! - self.tipValue
                        
                        if remainingamt < rem {
                            DataManager.isPartialAprrov = true
                        } else {
                            DataManager.isPartialAprrov = false
                        }
                        //UserDefaults.standard.set(dueBal, forKey: "datavaluedue")
                        //DataManager.duebalanceData = remainingamt
                        self.DueShared = remainingamt
                    }
                    
                }
                
                if isMulticard {
                    var valTip = 0.0
                    if let dict = responseDict {
                        self.multicardErrorResponse = dict
                        
                        if let data = dict["data"] as? JSONDictionary {
                            if let multi = data["multi_card"] as? JSONDictionary {
                                if let arrCredit = multi["credit"] as? JSONArray {
                                    for i in 0..<arrCredit.count {
                                        if let status = arrCredit[i]["status"] as? String {
                                            if status == "Fail" {
                                                print("value\(i)")
                                                if let tipamt = arrCredit[i]["tip"] as? String {
                                                    let tipAmount = tipamt.toDouble() ?? 0.0
                                                    valTip += tipAmount
                                                    //let price = Double((obj as AnyObject).value(forKey: "productprice") as? String  ?? "0") ?? 0.00
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if let arrPaxPay = multi["pax_pay"] as? JSONArray {
                                    for i in 0..<arrPaxPay.count {
                                        if let status = arrPaxPay[i]["status"] as? String {
                                            if status == "Fail" {
                                                print("valueOne\(i)")
                                                if let tipamt = arrPaxPay[i]["tip"] as? String {
                                                    let tipAmount = tipamt.toDouble() ?? 0.0
                                                    valTip += tipAmount
                                                    //let price = Double((obj as AnyObject).value(forKey: "productprice") as? String  ?? "0") ?? 0.00
                                                }
                                            }
                                        }
                                    }
                                }
                                self.MultiTipValue = valTip ?? 0.0
                                DataManager.cartData!["MultiTipAmount_due"] = valTip
                            }
                        }
                    }
                }
                
                let errorMessage = responseDict?[APIKeys.kError] as? String ?? String(describing: (responseDict?[APIKeys.kError] as? JSONDictionary)?.first?.value ?? "Something went wrong. Please try again!.")
                responseCallBack(0, errorMessage, nil)
            }
        }) { (errorReason, error) in
            if error?.code != -999 {
                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                debugPrint(errorReason ?? "")
            }
        }
    }
    
    func pushMultipleOrder(parameters: JSONArray, responseCallBack: @escaping responseCallBack) {
        APIManager.pushMultipleOrder(parameters: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parsePushMultipleOrderData(responseDict: responseDict!)
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
    
    func getRepresentativesList(responseCallBack: @escaping responseCallBack) {
        
        APIManager.getRepresentativesList(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseRepresentativesData(responseDict: responseDict!)
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
    
    func sendEmail(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.sendEmail(parametersDict: parameters, successCallBack: { (responseDict) in
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
    
    func sendNote(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.sendNote(parametersDict: parameters, successCallBack: { (responseDict) in
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
    
//    func getReceiptContent(orderID: String,responseCallBack: @escaping responseCallBack) {
//
//        APIManager.getReceiptContent(orderID: orderID, successCallBack: { (responseDict) in
//            if responseDict?[kSuccess] as? Int == 1 {
//                self.parseReceiptData(responseDict: responseDict!)
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
    
    func getReceiptContent(orderID: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.getReceiptContent(orderID: orderID, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                if DataManager.isGooglePrinter {
                    Indicator.sharedInstance.hideIndicator()
                    if let data = responseDict?[APIKeys.kData] as? Dictionary<String, AnyObject>{
                        appDelegate.showToast(message: data["meassage"] as? String ?? "")
                    }
                    
                }else{
                    self.parseReceiptData(responseDict: responseDict!)
                    responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
                }
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
    
//    func getTransactionPrintReceiptContent(transactionID: String,responseCallBack: @escaping responseCallBack) {
//
//        APIManager.getTransactionPrintReceiptContent(transactionID: transactionID, successCallBack: { (responseDict) in
//            if responseDict?[kSuccess] as? Int == 1 {
//                self.parseReceiptData(responseDict: responseDict!)
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
    
    func getTransactionPrintReceiptContent(transactionID: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.getTransactionPrintReceiptContent(transactionID: transactionID, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                if DataManager.isGooglePrinter {
                    if let data = responseDict?[APIKeys.kData] as? Dictionary<String, AnyObject>{
                        appDelegate.showToast(message: data["meassage"] as? String ?? "")
                    }
                    
                }else{
                self.parseReceiptData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
                }
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
    
    
    func getReceiptEndDrawerContentURL(orderID: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.getReceiptEndDrawerContentURL(orderID: orderID, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseReceiptEndDrawerURLData(responseDict: responseDict!)
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
    
//    func getReceiptEndDrawerDetails(orderID: String,responseCallBack: @escaping responseCallBack) {
//
//        APIManager.getReceiptEndDrawerDetails(orderID: orderID, successCallBack: { (responseDict) in
//            if responseDict?[kSuccess] as? Int == 1 {
//                self.parseReceiptEndDrawerDetailsData(responseDict: responseDict!)
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
    
    func getReceiptEndDrawerDetails(orderID: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.getReceiptEndDrawerDetails(orderID: orderID, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                if DataManager.isGooglePrinter {
                    if let data = responseDict?[APIKeys.kData] as? Dictionary<String, AnyObject>{
                        appDelegate.showToast(message: data["meassage"] as? String ?? "")
                    }
                    
                }else{
                self.parseReceiptEndDrawerDetailsData(responseDict: responseDict!)
                responseCallBack(1, responseDict![APIKeys.kMessage] as? String, nil)
                }
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
    
    func calculateCart(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.calculateCart(parametersDict: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseCartCalculationData(responseDict: responseDict!)
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
    func startDrawer(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.startDrawer(parametersDict: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseStartDrawerData(responseDict: responseDict!)
                
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
    
    
    func startPayIn(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.startPayIn(parametersDict: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parsePayInData(responseDict: responseDict!)
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
    
    func startPayOut(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.startPayOut(parametersDict: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parsePayOutData(responseDict: responseDict!)
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
    
    func endDrawer(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.endDrawer(parametersDict: parameters, successCallBack: { (responseDict) in
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
    func giftCardBalance(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.giftCardBalance(parametersDict: parameters, successCallBack: { (responseDict) in
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
    func giftCardActivate(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.giftCardActivate(parametersDict: parameters, successCallBack: { (responseDict) in
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
    
    //by anand
    func parseGetContactSource(responseDict: JSONDictionary) {
        
        if let arrayData: Array = responseDict["data"] as? [String]
        {
            self.contactSourcesList = arrayData
            
            }
        }
    // end anand
    func giftCardDeactivate(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.giftCardDeactivate(parametersDict: parameters, successCallBack: { (responseDict) in
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
    func giftCardReplace(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.giftCardReplace(parametersDict: parameters, successCallBack: { (responseDict) in
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
    func giftCardReverse(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.giftCardReverse(parametersDict: parameters, successCallBack: { (responseDict) in
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
    
    func giftGetBalance(number: String,type: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.giftGetBalance(number: number,type:type ,successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseGetBalanceData(responseDict: responseDict!)
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
    
    func getSavedCardData(id: String,type: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.getSavedCardData(id: id,type:type ,successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseGetCreditSavedData(responseDict: responseDict!)
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
    
    func getEmvSavedCardData(id: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.getEmvSavedCardData(id: id ,successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseGetCreditSavedData(responseDict: responseDict!)
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
    
    func getingenicoSavedCardData(id: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.getIngenicoSavedCardData(id: id ,successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseGetCreditSavedData(responseDict: responseDict!)
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
    
    func getUserShippingAddress(UserId: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.getUserShippingAddress(UserId: UserId,successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseGetUserShippingAddress(responseDict: responseDict!)
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
    
    func deletSavedCardData(id: String,type: String,responseCallBack: @escaping responseCallBack) {
        
        APIManager.deletSavedCardData(id: id,type:type ,successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                //self.parseGetCreditSavedData(responseDict: responseDict!)
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
    
    func getShippingCarrierList(responseCallBack: @escaping responseCallBack) {
        
        APIManager.getShippingCarrierList(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseShippinCarrierData(responseDict: responseDict!)
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
    
    func sendShippingService(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.sendShippingService(parametersDict: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseShippinServiceData(responseDict: responseDict!)
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
    
    func updateSavedCardData(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.updateSavedCardData(parametersDict: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                //self.parseShippinServiceData(responseDict: responseDict!)
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
    func updateUserShippingAddress(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.updateUserShippingAddress(parametersDict: parameters, successCallBack: { (responseDict) in
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
    
    func putUserDetail(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        
        APIManager.putUserDetail(parametersDict: parameters, successCallBack: { (responseDict) in
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
    
    // socket sudama
    func roomApi(responseCallBack: @escaping responseCallBack) {
        
        APIManager.roomApi( successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                 self.parseCustomerFacingDeviceList(responseDict: responseDict!)
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
    
    func getSourcesList(responseCallBack: @escaping responseCallBack) {
        
        APIManager.getSourcesList(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseSourcesListData(responseDict: responseDict!)
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
    
    func getPrinterList(responseCallBack: @escaping responseCallBack) {
        
        APIManager.getPrinterList(successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parsePrinterListData(responseDict: responseDict!)
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
    func getUpdatePrinterName(cloudPrinterAddress: String,cloudPrinterName: String,responseCallBack: @escaping responseCallBack) {
        
       
        APIManager.getUpdatePrinterName(cloudPrinterAddress: cloudPrinterAddress, cloudPrinterName: cloudPrinterName, successCallBack:{ (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
               // self.parsePrinterListData(responseDict: responseDict!)
                if let data = responseDict?[APIKeys.kData] as? Dictionary<String, AnyObject>{
                    responseCallBack(1, data["meassage"] as? String, nil)
                   // appDelegate.showToast(message: data["meassage"] as? String ?? "")
                }
                
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
    // By Altab 18 Aug 2022
    func getSerialNumberApi(productId: String,responseCallBack: @escaping responseCallBack) {
        APIManager.getSerialNumberApi(productId: productId, successCallBack:{ (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseSerialNumberListData(responseDict: responseDict!)
                responseCallBack(1, "", nil)
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
    // By Altab 24 Aug 2022
    func getInvoiceTemplatesListApi(responseCallBack: @escaping responseCallBack) {
        APIManager.getInvoiceTemplatesListApi(successCallBack:{ (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
               // self.parsePrinterListData(responseDict: responseDict!)
                self.parseInvoiceTemplateListData(responseDict: responseDict!)
               // if let data = responseDict?[APIKeys.kData] as? Dictionary<String, AnyObject>{
                    responseCallBack(1, "", nil)
                   // appDelegate.showToast(message: data["meassage"] as? String ?? "")
                //}
                
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
    func updateDeliveryStatus(parameters: JSONDictionary, responseCallBack: @escaping responseCallBack) {
        APIManager.updateDeliveryStatus(parametersDict: parameters, successCallBack: { (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
                self.parseUpdateDeliveryStatusListData(responseDict: responseDict!)
                if let data = responseDict?[APIKeys.kData] as? Dictionary<String, AnyObject>{
                    responseCallBack(1, data["meassage"] as? String, nil)
                   // appDelegate.showToast(message: data["meassage"] as? String ?? "")
                }
            } else {
                responseCallBack(0, responseDict![APIKeys.kError] as? String, nil)
            }
        }) { (errorReason, error) in
            if error?.code != -999 {
                responseCallBack(0, nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
                debugPrint(errorReason ?? "")
            }
        }
    }
    // By Altab 14 Dec 2022
    func getProductInfoDetailsApi(productId: String,responseCallBack: @escaping responseCallBack) {
        APIManager.getProductInfoDetailsApi(productId: productId, successCallBack:{ (responseDict) in
            if responseDict?[kSuccess] as? Int == 1 {
               // self.parseSerialNumberListData(responseDict: responseDict!)
                self.parseProductInfoData(responseDict: responseDict!)
                responseCallBack(1, "", nil)
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

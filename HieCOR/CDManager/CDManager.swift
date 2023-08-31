//
//  CDManager.swift
//  HieCOR
//
//  Created by Deftsoft on 12/10/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation
import CoreData

class CDManager {
    
    //MARK: Variables
    
    //MARK: Create Shared Instance
    public static let shared = CDManager()
    private init() {}
    
    //MARK: Class Functions
    func fetchAllCategory(searchText: String? = nil ,pageNumber: Int? = nil,responseCallBack: @escaping responseCallBack) {
        DispatchQueue.main.async {
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            
            let categoriesData: [Category] = NSManagedObject.fetch()
            let category = categoriesData.compactMap({$0.name})
            if category.count == 0 {
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(0, "No Data Found.", nil)
            }else {
                if searchText != nil {
                    HomeVM.shared.searchCategoriesArray.removeAll()
                    let searchedCategory = categoriesData.filter({($0.name ?? "").lowercased().contains(searchText!.replacingOccurrences(of: "%20", with: " ").lowercased())})
                    
                    for data in searchedCategory {
                        let categoryDataModal = CategoriesModel()
                        categoryDataModal.str_CategoryName = data.name ?? ""
                        HomeVM.shared.searchCategoriesArray.append(categoryDataModal)
                    }
                }else {
                    let fetchingCount = 20
                    let lastCount = category.count <= (fetchingCount * (pageNumber ?? 1)) ? category.count : (fetchingCount * (pageNumber ?? 1))
                    
                    HomeVM.shared.categoriesArray.removeAll()
                    for i in 0..<lastCount {
                        let itemName = category[i]
                        let categoryDataModal = CategoriesModel()
                        categoryDataModal.str_CategoryName = itemName
                        HomeVM.shared.categoriesArray.append(categoryDataModal)
                    }
                }
                
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(1, "Success", nil)
            }
        }
    }
    
    func fetchAllProducts(categoryName: String? = nil,searchText: String? = nil, pageNumber: Int, responseCallBack: @escaping responseCallBack) {
        DispatchQueue.main.async {
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            
            let productsData: [Product] = NSManagedObject.fetch()
            if productsData.count == 0 {
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(0, "No Data Found.", nil)
            }else {
                var isLandscape = false
                if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
                    isLandscape = true
                }
                
                let fetchingCount = isLandscape ? 36 : 45
                var lastCount = 0
                var isSearching = false
                var searchedProduct = [Product]()
                
                if searchText != nil {
                    let searchComponent = searchText!.components(separatedBy: "&category=")
                    let searchProductString = String(describing: searchComponent[0]).replacingOccurrences(of: "%20", with: " ").lowercased()
                    let category = String(describing: searchComponent[1]).replacingOccurrences(of: "%20", with: " ").lowercased()
                    isSearching = true
                    
                    if category == "home" {
                        searchedProduct = productsData.filter({$0.title?.lowercased().contains(searchProductString) ?? false})
                    }else {
                        searchedProduct = productsData.filter({$0.category?.lowercased() == category && $0.title?.lowercased().contains(searchProductString) ?? false})
                    }
                    
                    lastCount = searchedProduct.count <= (fetchingCount * pageNumber) ? searchedProduct.count : (fetchingCount * pageNumber)
                }else {
                    isSearching = false
                    //Search with category only
                    if var catName = categoryName {
                        catName = catName.replacingOccurrences(of: "%20", with: " ").lowercased()
                        searchedProduct = catName == "home" ? productsData : productsData.filter({($0.category?.lowercased() ?? "") == catName})
                        lastCount = searchedProduct.count <= (fetchingCount * pageNumber) ? searchedProduct.count : (fetchingCount * pageNumber)
                    }
                }
                
                HomeVM.shared.productsArray.removeAll()
                HomeVM.shared.searchProductsArray.removeAll()
                
                for i in 0..<lastCount {
                    let data = searchedProduct[i]
                    let product = ProductsModel()
                    product.str_title = data.title ?? ""
                    product.str_external_prod_id = data.externalProductId ?? ""
                    product.shippingPrice = data.shippingPrice ?? "0"
                    product.str_price = data.price ?? ""
                    product.str_stock = data.stock ?? ""
                    product.str_product_id = data.id ?? ""
                    product.str_product_code = data.productCode ?? ""
                    product.str_long_description = data.longDescp ?? ""
                    product.str_short_description = data.shortDescp ?? ""
                    product.str_product_image = ""
                    product.str_limit_qty = data.limitQty ?? ""
                    product.is_taxable = data.is_taxable ?? ""
                    product.unlimited_stock = data.unlimitedStock ?? ""
                    product.str_keywords = data.keywords ?? ""
                    product.str_fileID = data.fileId ?? ""
                    product.str_product_categoryName = data.category ?? ""
                    product.productImageData = data.image
                    if let arrayData = data.attributesArrayData {
                        if let arraydata = NSKeyedUnarchiver.unarchiveObject(with: arrayData) as? Array<Any> {
//                            product.array_Atributes = arraydata
                        }
                    }
                    if isSearching {
                        HomeVM.shared.searchProductsArray.append(product)
                    }else {
                        HomeVM.shared.productsArray.append(product)
                    }
                }
                
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(1, "Success", nil)
            }
        }
    }
    
    func fetchAllTaxes(responseCallBack: @escaping responseCallBack) {
        DispatchQueue.main.async {
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            
            let taxData: [Tax] = NSManagedObject.fetch()
            if taxData.count == 0 {
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(0, "No Data Found.", nil)
            }else {
                HomeVM.shared.taxList.removeAll()
                HomeVM.shared.taxSetting.removeAll()
                var settingsData: Data? = nil
                for data in taxData {
                    let  taxModelObj = TaxListModel()
                    taxModelObj.tax_title = data.title ?? ""
                    taxModelObj.tax_type = data.type ?? ""
                    taxModelObj.tax_amount = data.amount ?? ""
                    settingsData = data.settings
                    HomeVM.shared.taxList.append(taxModelObj)
                }
                if let data = settingsData {
                    if let settings = NSKeyedUnarchiver.unarchiveObject(with: data) as?  Dictionary<String,AnyObject> {
                        HomeVM.shared.taxSetting = settings
                    }
                }
                
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(1, "Success", nil)
            }
        }
    }
    
    func fetchAllRegions(responseCallBack: @escaping responseCallBack) {
        DispatchQueue.main.async {
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            
            let regionData: [Region] = NSManagedObject.fetch()
            if regionData.count == 0 {
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(0, "No Data Found.", nil)
            }else {
                HomeVM.shared.regionsList.removeAll()
                for data in regionData {
                    let regionsModelObj = RegionsListModel()
                    regionsModelObj.str_regionAbv = data.abbreviation ?? ""
                    regionsModelObj.str_regionName = data.name ?? ""
                    HomeVM.shared.regionsList.append(regionsModelObj)
                }
                
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(1, "Success", nil)
            }
        }
    }
    
    func fetchAllCustomer(searchText: String? = nil,pageNumber: Int,responseCallBack: @escaping responseCallBack) {
        DispatchQueue.main.async {
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            
            let customerData: [Customer] = NSManagedObject.fetch()
            if customerData.count == 0 {
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(0, "No Data Found.", nil)
            }else {
                let fetchingCount = 30
                var lastCount = 0
                var isSearching = false
                var searchedCustomer = [Customer]()
                
                if searchText != nil {
                    isSearching = true
                    searchedCustomer = customerData.filter({ (($0.firstName ?? "") + " " + ($0.lastName ?? "")).lowercased().contains(searchText!.replacingOccurrences(of: "%20", with: " ").lowercased()) })
                    lastCount = searchedCustomer.count <= (fetchingCount * pageNumber) ? searchedCustomer.count : (fetchingCount * pageNumber)
                }else {
                    isSearching = false
                    lastCount = customerData.count <= (fetchingCount * pageNumber) ? customerData.count : (fetchingCount * pageNumber)
                }
                
                HomeVM.shared.customerList.removeAll()
                HomeVM.shared.searchCustomerList.removeAll()
                
                for i in 0..<lastCount {
                    let data = isSearching ? searchedCustomer[i] : customerData[i]
                    
                    let customerModelObj = CustomerListModel()
                    let month = data.cardMonth ?? ""
                    let year = data.cardYear ?? ""
                    let cardType = data.cardType ?? ""
                    let cardnumber = data.cardNumber ?? ""
                    
                    customerModelObj.cardDetail = CardDataModel(cardNumber: cardnumber, month: month, year: year, type: cardType)
                    customerModelObj.str_first_name = data.firstName ?? ""
                    customerModelObj.str_last_name = data.lastName ?? ""
                    customerModelObj.str_email = data.email ?? ""
                    customerModelObj.str_phone = data.phone ?? ""
                    customerModelObj.str_address = data.address1 ?? ""
                    customerModelObj.str_address2 = data.address2 ?? ""
                    customerModelObj.str_city = data.city ?? ""
                    customerModelObj.str_region = data.region ?? ""
                    customerModelObj.str_postal_code = data.postalCode ?? ""
                    customerModelObj.str_bpid = data.bpId ?? ""
                    customerModelObj.str_userID = data.userId ?? ""
                    customerModelObj.str_order_id = data.orderId ?? ""
                    customerModelObj.str_display_name = data.displayName ?? ""
                    customerModelObj.userCoupan = data.userCoupan ?? ""
                    customerModelObj.userCustomTax = data.userCustomTax ?? ""
                    customerModelObj.str_Billingaddress = data.billingAddress1 ?? ""
                    customerModelObj.str_Billingaddress2 = data.billingAddress2 ?? ""
                    customerModelObj.str_Billingcity = data.billingCity ?? ""
                    customerModelObj.str_Billingregion = data.billingRegion ?? ""
                    customerModelObj.str_Billingpostal_code = data.billingPostalCode ?? ""
                    customerModelObj.str_Billingphone = data.billingPhone ?? ""
                    customerModelObj.str_Billingemail = data.billingEmail ?? ""
                    customerModelObj.str_billing_first_name = data.billingFirstName ?? ""
                    customerModelObj.str_billing_last_name = data.billingLastName ?? ""
                    customerModelObj.str_company = data.billingCompany ?? ""
                    customerModelObj.str_Shippingaddress = data.shippingAddress1 ?? ""
                    customerModelObj.str_Shippingaddress2 = data.shippingAddress2 ?? ""
                    customerModelObj.str_Shippingcity = data.shippingCity ?? ""
                    customerModelObj.str_Shippingregion = data.shippingRegion ?? ""
                    customerModelObj.str_Shippingpostal_code = data.shippingPostalCode ?? ""
                    customerModelObj.str_Shippingphone = data.shippingPhone ?? ""
                    customerModelObj.str_Shippingemail = data.shippingEmail ?? ""
                    customerModelObj.str_shipping_first_name = data.shippingFirstName ?? ""
                    customerModelObj.str_shipping_last_name = data.shippingLastName ?? ""
                    if isSearching {
                        HomeVM.shared.searchCustomerList.append(customerModelObj)
                    }else {
                        HomeVM.shared.customerList.append(customerModelObj)
                    }
                }
                
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(1, "Success", nil)
            }
        }
    }
    
    func fetchAllOrders(startDate: String? = nil, endDate: String? = nil, pageNumber: Int? = nil, responseCallBack: @escaping responseCallBack) {
        DispatchQueue.main.async {
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            
            let allOrders: [Orders] = NSManagedObject.fetch()
            
            if allOrders.count == 0 {
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                responseCallBack(0, "No Order Found.", nil)
            }else {
                var orders = allOrders
                orders.sort(by: { (o1, o2) -> Bool in
                    return o1.index > o2.index
                })
                
                OrderVM.shared.ordersList.removeAll()
                
                if startDate != nil && endDate != nil {
                    let firstDate = "\(startDate!.components(separatedBy: "T00:00:00").first ?? "")"
                    let lastDate = "\(endDate!.components(separatedBy: "T24:00:00").first ?? "")"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    let newStartDate = dateFormatter.date(from: firstDate)
                    let newEndDate = dateFormatter.date(from: lastDate)
                    
                    
                    if newStartDate != nil && newEndDate != nil {
                        for order in orders {
                            let ordersModelObj = OrdersHistoryList()
                            ordersModelObj.order_id = "Pending"
                            ordersModelObj.status = "Pending"
                            ordersModelObj.total = order.total ?? "0.0"
                            
                            let dateInString = order.date ?? ""
                            let orderDate = dateFormatter.date(from: dateInString) ?? Date()
                            
                            if orderDate.millisecondsSince1970 >= newStartDate!.millisecondsSince1970 && orderDate.millisecondsSince1970 <= newEndDate!.millisecondsSince1970 {
                                if let key = OrderVM.shared.ordersList.index(where: {$0.key == dateInString}) {
                                    var newValue = OrderVM.shared.ordersList[key].value
                                    newValue.append(ordersModelObj)
                                    OrderVM.shared.ordersList[dateInString] = newValue
                                }else {
                                    OrderVM.shared.ordersList[dateInString] = [ordersModelObj]
                                }
                            }
                            
                            let fetchingCount = 20
                            let totalValues = OrderVM.shared.ordersList.compactMap({$0.value.count}).reduce(0, +)
                            
                            let lastCount = totalValues <= (fetchingCount * (pageNumber ?? 1)) ? orders.count : (fetchingCount * (pageNumber ?? 1))
                            if totalValues == lastCount {
                                break
                            }
                        }
                    }
                }else {
                    let fetchingCount = 20
                    let lastCount = orders.count <= (fetchingCount * (pageNumber ?? 1)) ? orders.count : (fetchingCount * (pageNumber ?? 1))
                    
                    for i in 0..<lastCount {
                        let order = orders[i]
                        let ordersModelObj = OrdersHistoryList()
                        ordersModelObj.order_id = "Pending"
                        ordersModelObj.status = "Pending"
                        ordersModelObj.total = order.total ?? "0.0"
                        
                        let dateInString = order.date ?? ""
                        
                        if let key = OrderVM.shared.ordersList.index(where: {$0.key == dateInString}) {
                            var newValue = OrderVM.shared.ordersList[key].value
                            newValue.append(ordersModelObj)
                            OrderVM.shared.ordersList[dateInString] = newValue
                        }else {
                            OrderVM.shared.ordersList[dateInString] = [ordersModelObj]
                        }
                    }
                }
                
                if Indicator.isEnabledIndicator {
                    Indicator.sharedInstance.hideIndicator()
                }
                
                if OrderVM.shared.ordersList.count == 0 {
                    responseCallBack(0, "No Order Found.", nil)
                    return
                }

                responseCallBack(1, "Success", nil)
            }
        }
    }
    
    func saveOrder(parameters: JSONDictionary,isInvoice: Bool, responseCallBack: @escaping responseCallBack) {
        DispatchQueue.main.async {
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.showIndicator()
            }
            
            let allOrders: [Orders] = NSManagedObject.fetch()
            
            let data = NSKeyedArchiver.archivedData(withRootObject: parameters)
            let orders = Orders(context: context)
            orders.data = data
            orders.index = Int64(allOrders.count)
            orders.isInvoice = isInvoice
            
            var total = String()
            if let cartInfo = parameters["cart_info"] as? JSONDictionary {
                if let newTotal = cartInfo["total"] as? String {
                    total = newTotal
                }
            }
            
            orders.total = total == "" ? "0.00" : total
            orders.date = Date().stringFromDate(format: .ymdDate , type: .local)
            
            appDelegate.saveContext()
            
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.hideIndicator()
            }
            responseCallBack(1, "SavedOffline", nil)
        }
    }
    
    func deleteAllData(with typeOf: SyncingType) {
        if Indicator.isEnabledIndicator {
            Indicator.sharedInstance.showIndicator()
        }
        
        //Delete All Data
        do {
            switch typeOf {
            case .category:
                try context.execute(NSBatchDeleteRequest(fetchRequest: Category.fetchRequest()))
                break
            case .product:
                try context.execute(NSBatchDeleteRequest(fetchRequest: Product.fetchRequest()))
                break
            case .customer:
                try context.execute(NSBatchDeleteRequest(fetchRequest: Customer.fetchRequest()))
                break
            case .tax:
                try context.execute(NSBatchDeleteRequest(fetchRequest: Tax.fetchRequest()))
                break
            case .region:
                try context.execute(NSBatchDeleteRequest(fetchRequest: Region.fetchRequest()))
                break
            case .order:
                try context.execute(NSBatchDeleteRequest(fetchRequest: Orders.fetchRequest()))
                break
            }
            try context.save()
            
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.hideIndicator()
            }
            print("Deleted.")
        } catch {
            
            if Indicator.isEnabledIndicator {
                Indicator.sharedInstance.hideIndicator()
            }
            print ("There was an error for deleting.")
        }
    }
    
}

//MARK: NSManagedObject
extension NSManagedObject {
    class func fetch<T : NSManagedObject>() -> [T] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        let context = appDelegate.persistentContainer.viewContext
        do {
            return try context.fetch(T.fetchRequest()) as! [T]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
}


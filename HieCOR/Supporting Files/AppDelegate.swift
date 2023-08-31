//
//  AppDelegate.swift
//  HieCOR
//
//  Created by HyperMacMini on 24/11/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseAnalytics
import Crashlytics
import SocketIO

//@UIApplicationMain comment for mail.swift class and this class added for screen saver code // by altab
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: Variables
    var window: UIWindow?
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = 0
    var strSearch = ""
    var strPaymentType : String = ""
    var strIphoneApi = false
    var isOrderHistoryFirstTime = false
    var authOrderIdForOrderHistory : String = ""
    var str_Refundvalue = ""
    var isCustomerPageOpen = false
    var isVoidPayment = false
    var isPinlogin = false
    var UserTaxData = false
    var IS_DEFAULT_PAYMENT_FUNCTIONLITY = false
    static var isLoaderNotHide : Bool = false //SSK
    static var isDecimal : Bool?    //forKB
    static var isStart : Bool?    //forKB
    static var dd : String?    //forKB
    var shippingRefundOnly = 0.0
    var tipRefundOnly = 0.0
    var CardReaderAmount = 0.0
    var arrIngenicoSigTip = JSONArray()
    var strPaxMode = ""
    var strDeviceUDID = ""
    var strIngenicoDeviceName = ""
    var isErrorCreateOrderCase = false
    var strErrorMsg = ""
    var strIngenicoErrorMsg = ""
    var strIngenicoAmount = ""
    var strIngenicoShowDeviceName = ""
    var strRefId = ""
    var isIngenicoTokenAvl = false
    var strIngenicoTokenData = ""
    var strIngenicoSystemRefId = ""
    var strIngenicoBPID = ""
    
    var localBezierPath = UIBezierPath() // for signture local data store
    var amount = 0.0 // for partial payment local store 
    var isOpenUrl = false // for deeplinking (13 sept 200) by altab
    var openUrlOrderId = "" // for deeplinking (13 sept 200) by altab
    var isOderHistoryOpen = false // for deeplinking (13 sept 200) by altab
    var isOpenToOrderHistory = false // (September) for pay invoice on payment method
    var openUrlCardReaderAmmount = ""
    var openUrlPaymentType = ""
    var orderDataClear = false
    var isIngenicoDataFail = false // DD 08 nov 2022 for ingenico
    var arrIngenicoData = JSONDictionary()
    var arrIngenicoJsonArrayData = JSONArray()
    var isHomeProductAPICall = false // DD 09 Dec 2022
    //MARK: Applicatiojn Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Enable Firebase & Crashlytics
        
        //----- screen sever -------//
         
         NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.applicationDidTimeout(notification:)),
                                name: .appTimeout,
                                object: nil
         )
        //----- screen sever -------//
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        strDeviceUDID = deviceId ?? ""
        
        if DataManager.isCaptureButton == true {
            DataManager.cartProductsArray?.removeAll()
            DataManager.isCaptureButton = false
            DataManager.OrderDataModel = nil
        }
        DataManager.isSideMenuSwiperCard = false
        DataManager.isshippingRefundOnly = false
        DataManager.isTipRefundOnly = false
        if DataManager.isBalanceDueData == true {
            
            //self.cartProductsArray.removeAll()
            UserDefaults.standard.removeObject(forKey: "recentOrder")
            UserDefaults.standard.removeObject(forKey: "recentOrderID")
            UserDefaults.standard.removeObject(forKey: "isCheckUncheckShippingBilling")
            UserDefaults.standard.removeObject(forKey: "cartdata")
            UserDefaults.standard.removeObject(forKey: "CustomerObj")
            UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
            UserDefaults.standard.removeObject(forKey: "cartProductsArray")
            DataManager.selectedService = ""
            DataManager.selectedServiceName = ""
            DataManager.selectedServiceId = ""
            DataManager.selectedCarrier = ""
            DataManager.selectedShippingRate = ""
            DataManager.shippingWeight = 0
            DataManager.shippingWidth = 0
            DataManager.shippingLength = 0
            DataManager.shippingHeight = 0
            DataManager.selectedFullfillmentId = ""
            DataManager.selectedCarrierName = ""
            DataManager.cartShippingProductsArray?.removeAll()
            DataManager.isshipOrderButton = false
            DataManager.automatic_upsellData.removeAll()
            HomeVM.shared.searchProductsArray.removeAll()
            DataManager.isUPSellProduct = false
            DataManager.isEditProductForUpsell = false
            
            UserDefaults.standard.synchronize()
            PaymentsViewController.paymentDetailDict.removeAll()
            //customerNameLabel.text = "Customer #"
            
            DataManager.duebalanceData = 0.0
            HomeVM.shared.amountPaid = 0.0
            HomeVM.shared.tipValue = 0.0
            HomeVM.shared.DueShared = 0.0
            HomeVM.shared.coupanDetail.code = ""
            
            HomeVM.shared.customerUserId = ""
            DataManager.isBalanceDueData = false
            HomeVM.shared.tipValue = 0.0
            HomeVM.shared.amountPaid = 0.0
            HomeVM.shared.DueShared = 0.0
            DataManager.duebalanceData = 0.0
            DataManager.cartData?.removeAll()
            
            HomeVM.shared.isAllDataLoaded = [false, false, false]
            DataManager.isCheckUncheckShippingBilling = false
            DataManager.OrderDataModel = nil
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    //DataManager.selectedPaxDeviceName = ""
                    DataManager.isUserPaxToken = ""
                    DataManager.shippingaddressCount = 0
                    DataManager.CardCount = 0
                    DataManager.EmvCardCount = 0
                    DataManager.IngenicoCardCount = 0
                    DataManager.Bbpid = ""
                    DataManager.ErrorBbpid = ""
                    DataManager.customerId = ""
                    DataManager.customerForShippingAddressId = ""
                    DataManager.shippingValue = 0.0
                    DataManager.shippingValueForAddress = 0.0
                    DataManager.recentOrderID = nil
                    DataManager.recentOrder = JSONDictionary()
                    DataManager.isBalanceDueData = false
                    HomeVM.shared.amountPaid = 0.0
                    HomeVM.shared.tipValue = 0.0
                    HomeVM.shared.DueShared = 0.0
                    //Reset Cart
                    //if DataManager.isCaptureButton == true {
                        DataManager.cartProductsArray?.removeAll()
                        DataManager.isCaptureButton = false
                    //}
                }
            }
            
        }
        
        FirebaseApp.configure()
        Crashlytics.sharedInstance().debugMode = true
        Crashlytics.sharedInstance().setUserEmail("corcrmuser@gmail.com")
        DataManager.automatic_upsellData.removeAll()
        //Enable IQKeyBoard Manager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        //Enable External Accessory Notification
        Keyboard._registerForExternalKeyboardChangeNotification()
        //Initialize OfflineDataManager
        OfflineDataManager.shared.initialize()
        //Check Is First Time UserLogin
        self.checkUserLoginOrNot()
        if DataManager.isUserLogin {
            let app = UIApplication.shared as? TimerApplication
            app?.resetIdleTimer()
        }
        
//        DataManager.isCheckUncheckShippingBilling = false
        
        print(DataManager.SavedPaymentArray)
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        
        DataManager.posAppVersion = version
        DataManager.posBuildNumber = build
        
        print("version",version)
        print("build",build)
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        //Update Frame
        Indicator.sharedInstance.blurImg.frame = UIScreen.main.bounds
        Indicator.sharedInstance.indicator.center = Indicator.sharedInstance.blurImg.center
        Indicator.sharedInstance.EMVGifImg.center = Indicator.sharedInstance.blurImg.center
        Indicator.sharedInstance.blurImgGif.frame = UIScreen.main.bounds
        ScreenSaver.sharedInstance.blurImg.frame = UIScreen.main.bounds
        ScreenSaver.sharedInstance.label.center = Indicator.sharedInstance.blurImg.center
        ScreenSaver.sharedInstance.GifImg.center = Indicator.sharedInstance.blurImg.center
               
        //Set Orientation
        if UI_USER_INTERFACE_IDIOM() == .phone {
            return UIInterfaceOrientationMask.portrait
        }
        return UIInterfaceOrientationMask.all
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
    }
    // for deeplinking (13 sept 200) by altab
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.scheme == "hiecorposapp") {
            let str: String? = url.debugDescription
            print("print redirect url = \(url)")
            if let newURL = URL(string: str ?? "") {
                let orderID = newURL.valueOf("orderId")
                print(orderID ?? "")
                let amount = newURL.valueOf("amount")
                print(amount ?? "")
                openUrlCardReaderAmmount = amount ?? ""
                let payment_type = newURL.valueOf("payment_type")
                let base_url = newURL.valueOf("base_url")
                print(payment_type  ?? "")
                openUrlPaymentType = payment_type ?? ""
                if DataManager.isUserLogin  && iPad_AccessPINViewController.isPresented == false{
                    if DataManager.baseUrl + "/" == base_url {
                        //  if fullEventArr?.count ?? 0 > 0 {
                              isOpenToOrderHistory = true
                           //  if let orderid = fullEventArr?[1] {
                                 if UI_USER_INTERFACE_IDIOM() == .phone {
                                     openUrlOrderId = orderID ?? ""
                                     appDelegate.isOpenUrl = true
                                     self.window = UIWindow(frame: UIScreen.main.bounds)
                                     let baseVC = BaseViewController()
                                     baseVC.setRootOrderHistoryViewControllerForIphone(orderId: openUrlOrderId)
                                     BaseURL = DataManager.baseUrl
                                 }else{
                                     appDelegate.isOpenUrl = true
                                     if appDelegate.isOderHistoryOpen {
                                         openUrlOrderId = orderID ?? ""
                                         NotificationCenter.default.post(name: Notification.Name("OpenUrlOrderHistoryReload"), object: nil)
                                     }else {
                                        isOpenUrl = true
                                        openUrlOrderId = orderID ?? ""
                                         self.window = UIWindow(frame: UIScreen.main.bounds)
                                         let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                                         let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController")
                                         self.window?.rootViewController = vc
                                         self.window?.makeKeyAndVisible()
                                     }
                                 }
                           //  }
                         // }
                    }
                }
            }
        }
        return true
    }
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //...
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let app = UIApplication.shared as? TimerApplication
        app?.resetIdleTimer()
        self.endBackgroundUpdateTask()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //...
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if appDelegate.isOpenToOrderHistory {
            DataManager.cartData = nil
            DataManager.cartProductsArray = nil
            DataManager.customerObj = nil
            appDelegate.isOpenToOrderHistory = false
            HomeVM.shared.coupanDetail.code = ""
            HomeVM.shared.tipValue = 0.0
            DataManager.customerId = ""
        }
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            
            MainSocketManager.shared.connect()
            let socketConnectionStatus = MainSocketManager.shared.socket.status
            
            switch socketConnectionStatus {
            case SocketIOStatus.connected:
                print("socket connected")
                MainSocketManager.shared.onreset()
            case SocketIOStatus.connecting:
                print("socket connecting")
                showToast(message: "socket connecting")
            case SocketIOStatus.disconnected:
                print("socket disconnected")
                showToast(message: "socket disconnected")
            case SocketIOStatus.notConnected:
                print("socket not connected")
                showToast(message: "socket not connected")
            }
        }
        
        DataManager.isCheckForAppUpdate = false
        NotificationCenter.default.post(name: Notification.Name("SaveApplicationData"), object: nil)

        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
        saveContext()
    }
    
    // MARK: - Core Data Methods
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "OfflineDatabase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: Check User Login Or Not
    private func checkUserLoginOrNot() {
        //iPhone
        if UI_USER_INTERFACE_IDIOM() == .phone
        {
            if DataManager.isFirstTimeUserLogin
            {
                if DataManager.isUserLogin
                {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let baseVC = BaseViewController()
                    baseVC.setRootViewControllerForIphone()
                    BaseURL = DataManager.baseUrl
                
                }
                else
                {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                }
            }
            else
            {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }
            
        }
        //iPad
        else if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            if DataManager.isFirstTimeUserLogin
            {
                if DataManager.isUserLogin
                {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController")
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                    BaseURL = DataManager.baseUrl
                  
                }
                else
                {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "iPad_LoginViewController")
                    self.window?.rootViewController = vc
                    self.window?.makeKeyAndVisible()
                }
            }
            else
            {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }
        }
    }
    
    func showToastCenter(message : String) {
        window!.showToast(toastMessage: message, duration: 1.5, isCenter: true)
    }
    
    func showToast(message : String) {
        window!.showToast(toastMessage: message, duration: 1.5, isCenter: false)
    }
    
    func showIncreaseTimeToast(message : String) {
        window!.showToast(toastMessage: message, duration: 2.5, isCenter: false)
    }
    
    func showErrorToast(message : String) {
        window!.showErrorToast(toastMessage: message, duration: 1.5, isCenter: false)
    }
    
    func showToastForCleanBGColor(message : String) {
      window!.showToastForCleanBGColor(toastMessage: message, duration: 2.5, isCenter: false)
    }
    //----- screen sever -------//
       @objc func applicationDidTimeout(notification: NSNotification) {
                   
           print("application did timeout, perform actions")
          // Indicator.sharedInstance.showIndicatorGif()
           ScreenSaver.sharedInstance.showIndicatorGif()
           
       }
       //----- screen sever -------//
}

extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}

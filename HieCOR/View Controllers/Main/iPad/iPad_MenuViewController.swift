//
//  iPad_MenuViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 29/01/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import SafariServices
import PDFKit

class iPad_MenuViewController: BaseViewController, SWRevealViewControllerDelegate {
    
    //MARK: IBOutlet
    @IBOutlet var tbl_Menu: UITableView!
    @IBOutlet var img_UserImage: UIImageView!
    @IBOutlet var lbl_UserName: UILabel!
    
    //MARK: Variables
    private var array_List = Array<Any>()
    private var array_iconsList = Array<Any>()
    var versionOb = Int()
    var CardDelegate: PaymentTypeDelegate?
    var customerFacingDeviceList = [CustomerFacingDeviceList]()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load Data
        // MARK Hide for V5
        // array_iconsList = ["categoriesicon", "transactionicon", "settingsicon", "report-icon", "report-icon","logouticon"]
        
        // array_iconsList = ["categoriesicon", "transactionicon", "settingsicon", "report-icon","logouticon"]
        
        //InternalGiftCard
        
        versionOb = Int(DataManager.appVersion)!
        
        setDataOnMenuCardOnline()
        
        OfflineDataManager.shared.menuDelegate = self
        tbl_Menu.tableFooterView = UIView()
        tbl_Menu.rowHeight = 65.0
        
        if appDelegate.isOrderHistoryFirstTime {
            appDelegate.isOrderHistoryFirstTime = false
            self.performSegue(withIdentifier: "viewtransactions", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Fill  Name
        if let userObject = UserDefaults.standard.value(forKey: "userdata") as? NSData {
            let userdata = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data)
            lbl_UserName.text = (userdata as AnyObject).value(forKey: "username") as? String
        }
        
        lbl_UserName.text = DataManager.appUserName
        
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            // MARK Hide for V5
            // array_List = ["Home", "Orders History", "Settings","Drawer","Internal Gift Card"]
            
            setDataOnMenuCardOnline()
            
            //array_List = ["Home", "Orders History", "Settings","Heartland Gift Card","Pax Heartland Gift Card","ZReport","Drawer"]
        }else {
            // MARK Hide for V5
            //array_List = ["Home", "Orders History", "Settings","Drawer" ,"Internal Gift Card", "Log Out"]
            
            print(DataManager.appVersion)
            versionOb = Int(DataManager.appVersion)!
            
            setDataOnMenuCardOnline()
            
        }
        
        self.tbl_Menu.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue is SWRevealViewControllerSegue)
        {
            let rvcs: SWRevealViewControllerSegue = segue as! SWRevealViewControllerSegue
            rvcs.performBlock = {(rvc_segue, svc, dvc) in
                let nc:UINavigationController = self.revealViewController().frontViewController as! UINavigationController
                nc.pushViewController(dvc!, animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPositionLeft, animated: false)
            }
        }
    }
    
    func callAPIToZreport(parameters: JSONDictionary) {
        LoginVM.shared.zreportdata(parametersDict: parameters) { (success, message, error) in
            if success == 1 {
                
                self.getZreport()
                
            }else {
                if message != nil {
//                    self.showAlert(message: message)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }

    
    func getZreport()  {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var ZreportUrl : String
//            if let name = DataManager.deviceNameText {
//                ZreportUrl = BaseURL + "/download_report/?ai_skin=full_page&download_report_ajax=zreport&exportSelect=PDF&rsp_DateFrom=" + Date.getCurrentDate() + "&rsp_DateTo=" + Date.getCurrentDate() + "&rsp_OrderSource=" + name.capitalized.encodeUrl()
//            }else {
//                let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
//                ZreportUrl = BaseURL + "/download_report/?ai_skin=full_page&download_report_ajax=zreport&exportSelect=PDF&rsp_DateFrom=" + Date.getCurrentDate() + "&rsp_DateTo=" + Date.getCurrentDate() + "&rsp_OrderSource=" + nameDevice.encodeUrl()//UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
//            }
            if var name = DataManager.deviceNameText {
                name = name.condenseWhitespace()
                if DataManager.isZreportLowerCase {
                    ZreportUrl = BaseURL + "/download_report/?ai_skin=full_page&download_report_ajax=zreport&exportSelect=PDF&rsp_OrderSource=" + name.lowercased().encodeUrl()
                } else {
                    ZreportUrl = BaseURL + "/download_report/?ai_skin=full_page&download_report_ajax=zreport&exportSelect=PDF&rsp_OrderSource=" + name.capitalized.encodeUrl()
                }
            }else {
                let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name.condenseWhitespace()
                if DataManager.isZreportLowerCase {
                    ZreportUrl = BaseURL + "/download_report/?ai_skin=full_page&download_report_ajax=zreport&exportSelect=PDF&rsp_OrderSource=" + nameDevice.lowercased().encodeUrl()
                } else {
                    ZreportUrl = BaseURL + "/download_report/?ai_skin=full_page&download_report_ajax=zreport&exportSelect=PDF&rsp_OrderSource=" + nameDevice.capitalized.encodeUrl()
                }
            }
            
            
            let data = UserDefaults.standard.object(forKey: "account_type") as? String
            
            if self.versionOb > 3 && data != "Administrator"{
                  ZreportUrl = "\(ZreportUrl)&rsp_Rep=\(DataManager.userID)"
              }
            
            let originalString = ZreportUrl
            //let escapedString = ZreportUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            //print(escapedString!)
            
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timestamp = format.string(from: date)
            
            let newString = timestamp.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            let newName = newString.replacingOccurrences(of: ":", with: "_", options: .literal, range: nil)

            self.savePdf(urlString: originalString, fileName: "Zreport_\(newName)")
        }
    }
    
    func savePdf(urlString:String, fileName:String) {
        DispatchQueue.main.async {
            let formattedString = urlString.replacingOccurrences(of: " ", with: "")
            let url = URL(string: formattedString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
                self.showSavedPdf(url: urlString, fileName: fileName)
            } catch {
                print("Pdf could not be saved")
            }
        }
    }
    
    func saveBase64StringToPDF(_ base64String: String) {

        guard
            var documentsURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last,
            let convertedData = Data(base64Encoded: base64String)
            else {
            //handle error when getting documents URL
            return
        }

        //name your file however you prefer
        documentsURL.appendPathComponent("yourFileName.pdf")

        do {
            try convertedData.write(to: documentsURL)
        } catch {
            //handle write error here
        }

        //if you want to get a quick output of where your
        //file was saved from the simulator on your machine
        //just print the documentsURL and go there in Finder 915010007194199 UTIB0000570
        print(documentsURL)
    }
    
    
    func showSavedPdf(url:String, fileName:String) {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName).pdf") {
                        // its your file! do what you want with it!
                        if #available(iOS 11.0, *) {
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let pdfViewController = storyboard.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
                            pdfViewController.pdfURL = url
                            if #available(iOS 13.0, *) {
                                pdfViewController.modalPresentationStyle = .fullScreen
                            }
                            present(pdfViewController, animated: true, completion: nil)
                        } else {
                             UIApplication.shared.open(url)
                            // Fallback on earlier versions
                        }
                        
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
    }
    
    func setDataOnMenuCardOnline() {
         // by sudama offline start
         array_List.removeAll()
         array_iconsList.removeAll()
         
         if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
             array_List.append("Home")
             array_iconsList.append("categoriesicon")
             
             if DataManager.showQueuedOfflineOrders{
                 array_List.append("Queued Orders")
                 array_iconsList.append("queued-order")
             }
             
         } else {
             array_List.append("Home")
             array_iconsList.append("categoriesicon")
             
             array_List.append("Orders History")
             array_iconsList.append("transactionicon")
             
             array_List.append("Settings")
             array_iconsList.append("settingsicon")
             
             if versionOb > 3 {
                 array_List.append("Drawer")
                 array_iconsList.append("report-icon")
                 if DataManager.isInternalGift {
                     array_List.append("Internal Gift Card")
                     array_iconsList.append("InternalGiftCard")
                 }
                 if DataManager.isGiftCard {
                     array_List.append("Heartland Gift Card")
                     array_iconsList.append("HeartlandGiftCard")
                 }
                
                if let pax = DataManager.selectedPayment?.contains("PAX PAY") {
                    if pax && DataManager.isPaxPayGiftCard {
                        array_List.append("Pax Heartland Gift Card")
                        array_iconsList.append("PaxGiftCard")
                    }
                }
                
//                 if DataManager.isPaxPayGiftCard {
//                     array_List.append("Pax Heartland Gift Card")
//                     array_iconsList.append("PaxGiftCard")
//                 }
             }
            
            // socket sudama
//            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing  {
//                array_List.append("Customer Facing App")
//                array_iconsList.append("tablet")
//            }
            //
            
             array_List.append("ZReport")
             array_iconsList.append("ZReport")
             
             if DataManager.showQueuedOfflineOrders{
                 array_List.append("Queued Orders")
                 array_iconsList.append("queued-order")
             }
             
             array_List.append("Log Out")
             array_iconsList.append("logouticon")
             
         }
         // by sudama offline end
        
        /*if versionOb < 4 {
            array_iconsList = ["categoriesicon", "transactionicon", "settingsicon","ZReport","logouticon"]
            array_List = ["Home", "Orders History", "Settings","ZReport","Log Out"]
            
        }else{
            
            if DataManager.isInternalGift && DataManager.isGiftCard && DataManager.isPaxPayGiftCard {
                array_iconsList = ["categoriesicon", "transactionicon", "settingsicon","report-icon","InternalGiftCard","HeartlandGiftCard","PaxGiftCard","ZReport","logouticon"]
            } else if DataManager.isGiftCard && DataManager.isPaxPayGiftCard {
                array_iconsList = ["categoriesicon", "transactionicon", "settingsicon","report-icon","HeartlandGiftCard","PaxGiftCard","ZReport","logouticon"]
            } else if DataManager.isInternalGift &&  DataManager.isPaxPayGiftCard {
                array_iconsList = ["categoriesicon", "transactionicon", "settingsicon","report-icon","InternalGiftCard","PaxGiftCard","ZReport","logouticon"]
            } else if DataManager.isInternalGift && DataManager.isGiftCard {
                array_iconsList = ["categoriesicon", "transactionicon", "settingsicon","report-icon","InternalGiftCard","HeartlandGiftCard","ZReport","logouticon"]
            } else if DataManager.isGiftCard {
                array_iconsList = ["categoriesicon", "transactionicon", "settingsicon","report-icon","HeartlandGiftCard","ZReport","logouticon"]
            } else if DataManager.isInternalGift {
                array_iconsList = ["categoriesicon", "transactionicon", "settingsicon","report-icon","InternalGiftCard","ZReport","logouticon"]
            } else  {
                array_iconsList = ["categoriesicon", "transactionicon", "settingsicon","report-icon","ZReport","logouticon"]
            }
            
            if DataManager.isInternalGift && DataManager.isGiftCard && DataManager.isPaxPayGiftCard {
                array_List = ["Home", "Orders History", "Settings","Drawer","Internal Gift Card","Heartland Gift Card","Pax Heartland Gift Card","ZReport","Log Out"]
            } else if DataManager.isGiftCard && DataManager.isPaxPayGiftCard {
                array_List = ["Home", "Orders History", "Settings","Drawer","Heartland Gift Card","Pax Heartland Gift Card","ZReport","Log Out"]
            } else if DataManager.isInternalGift &&  DataManager.isPaxPayGiftCard {
                array_List = ["Home", "Orders History", "Settings","Drawer","Internal Gift Card","Pax Heartland Gift Card","ZReport","Log Out"]
            } else if DataManager.isInternalGift && DataManager.isGiftCard {
                array_List = ["Home", "Orders History", "Settings","Drawer","Internal Gift Card","Heartland Gift Card","ZReport","Log Out"]
            } else if DataManager.isGiftCard {
                array_List = ["Home", "Orders History", "Settings","Drawer","Heartland Gift Card","ZReport","Log Out"]
            } else if DataManager.isInternalGift {
                array_List = ["Home", "Orders History", "Settings","Drawer","Internal Gift Card","ZReport","Log Out"]
            } else  {
                array_List = ["Home", "Orders History", "Settings","Drawer","ZReport","Log Out"]
            }
            
        }
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            // MARK Hide for V5
             array_List = ["Home"]
             array_iconsList = ["categoriesicon"]

            //array_List.remove(at: array_List.count)

        }*/
    }
    
    // by sudama offline
    func offlineVC(){
        do {
            var jsonDataForView = ""
            
            if DataManager.offlineOrderdataAPIData?.count ?? 0 > 0 {
                DataManager.offlineOrderdata?.append(contentsOf: DataManager.offlineOrderdataAPIData!)
            }
            
            var jsonData = Data()
            
            if DataManager.offlineOrderdata == nil {
                jsonData = try JSONSerialization.data(withJSONObject:  DataManager.offlineOrderdataAPIData ?? [] , options: JSONSerialization.WritingOptions.prettyPrinted)
            } else {
                jsonData = try JSONSerialization.data(withJSONObject:  DataManager.offlineOrderdata ?? [] , options: JSONSerialization.WritingOptions.prettyPrinted)
            }
            
            //Convert to Data
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                jsonDataForView = JSONString
                if jsonDataForView == "[\n\n]" {
                    jsonDataForView = ""
                }
                print(JSONString)
            }
            
            if jsonDataForView != ""{
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let offlineDataShowObj = storyboard.instantiateViewController(withIdentifier: "OfflineDataShow") as! OfflineDataShow
                offlineDataShowObj.jsonDataForView = jsonDataForView
                present(offlineDataShowObj, animated: true, completion: nil)
            }else{
                if  jsonDataForView == "" {
                 //   DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.showAlert(message: "No queue for offline orders.")
                        appDelegate.showToast(message: "No queue for offline orders.")
                    //}
                }
            }
            
        } catch {
            //print(error.description)
        }
    }
    
    /*// socket sudama
    func customerFacingAppConnectVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customeFacingVCObj = storyboard.instantiateViewController(withIdentifier: "ConnectCustomeFacingVC") as! ConnectCustomeFacingVC
        //offlineDataShowObj.jsonDataForView = jsonDataForView
        present(customeFacingVCObj, animated: true, completion: nil)
        
        
        
    }//
    
    //MARK: API Call Method
            func RoomApiCall(){
                HomeVM.shared.roomApi(responseCallBack: {(success, message, error) in
                    if success == 1 {
                        self.customerFacingDeviceList =  HomeVM.shared.customerFacingDeviceList
                        if self.customerFacingDeviceList.count > 0 {
                            self.performSegue(withIdentifier: "connectFacing", sender: nil)
    //                        for i in 0..<self.customerFacingDeviceList.count {
    //                            if DataManager.sessionID != "" {
    //                                if DataManager.sessionID == self.customerFacingDeviceList[i].session_id{
    //                                    self.indexForSelectDevice = i
    //                                    self.tfSelectDevice.text = self.customerFacingDeviceList[i].room_name
    //                                }
    //                            }
    //
    //                        }
                        }else{
                              appDelegate.showToast(message: "No device available to connect, Please login into customer facing app.")
                       
                        }
                        
                    }else {
                        if message != nil {
        //                    self.showAlert(message: message!)
                            appDelegate.showToast(message: message!)
                        }else {
                            self.showErrorMessage(error: error)
                        }
                    }
                })
            }*/
    
    func nextPageGo(strIndexData:String) {
        appDelegate.str_Refundvalue = ""
        DataManager.isCaptureButton = false
        DataManager.isSideMenuSwiperCard = false
        if strIndexData == "Home"
        {
            
            DataManager.selectedCategory = "Home"
            DataManager.isTipRefundOnly = false
            DataManager.isshippingRefundOnly = false

            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as! SWRevealViewController
                appDelegate.window?.rootViewController = controller
                appDelegate.window?.makeKeyAndVisible()
            }
        }
        if strIndexData == "Orders History"
        {
            appDelegate.authOrderIdForOrderHistory = ""
            self.performSegue(withIdentifier: "viewtransactions", sender: nil)
        }
        if strIndexData == "Settings"
        {
            self.performSegue(withIdentifier: "settings", sender: nil)
        }
        if strIndexData == "Drawer"
        {
            self.performSegue(withIdentifier: "reports", sender: nil)
        }
        // MARK Hide for V5
        
        if strIndexData == "Internal Gift Card"
        {
            DataManager.isSideMenuSwiperCard = true
            self.performSegue(withIdentifier: "giftCard", sender: nil)
        }
        if strIndexData == "Heartland Gift Card"
        {
            DataManager.isSideMenuSwiperCard = true
            self.performSegue(withIdentifier: "HeartlandGiftCard", sender: nil)
        }
        if strIndexData == "Pax Heartland Gift Card"
        {
            DataManager.isSideMenuSwiperCard = true
            self.performSegue(withIdentifier: "PaxGiftCard", sender: nil)
        }
        if strIndexData == "ZReport"
        {
            //getZreport()
            var nameSource = ""
            
            if let name = DataManager.deviceNameText {
                nameSource = name

            }else {
                let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
                nameSource = nameDevice
            }
            
            var parameters = JSONDictionary()
            parameters["source"] = nameSource
            self.callAPIToZreport(parameters: parameters)
            
        }
        // socket sudama
        if strIndexData == "Customer Facing App" {
            
            //RoomApiCall()
            
            //self.performSegue(withIdentifier: "connectFacing", sender: nil)
            //customerFacingAppConnectVC()
        }
        //
        
        if strIndexData == "Queued Orders"    // by sudama offline
        {
            offlineVC()    // by sudama offline
        }
        if strIndexData == "Log Out"
        {
            alertForLogOut()
        }
    }
}

//MARK: -- Tableview Delegate

extension iPad_MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return array_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lbl_Name = cell.contentView.viewWithTag(2) as? UILabel
        lbl_Name?.text = array_List[indexPath.row] as? String
        let img = cell.contentView.viewWithTag(1) as? UIImageView
        img?.image = UIImage(named: array_iconsList[indexPath.row] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // by sudama offline
//        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline && indexPath.row == 1 {
//            return
//        }
//        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline && indexPath.row == 3  {
//            return
//        }
        
        versionOb = Int(DataManager.appVersion)!
        
        if versionOb < 4 {
            
            self.nextPageGo(strIndexData: array_List[indexPath.row] as! String)
        }else{
            self.nextPageGo(strIndexData: array_List[indexPath.row] as! String)
        }
    }
}

//MARK: OfflineDataManagerDelegate
extension iPad_MenuViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        versionOb = Int(DataManager.appVersion)!
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            // MARK Hide for V5
            // array_List = ["Home", "Orders History", "Settings","Drawer","Internal Gift Card"]
            //  array_List = ["Home", "Orders History", "Settings","Drawer"]
            setDataOnMenuCardOnline()
            
        } else {
            // MARK Hide for V5
            setDataOnMenuCardOnline()
        }
        
        self.tbl_Menu.reloadData()
    }
}

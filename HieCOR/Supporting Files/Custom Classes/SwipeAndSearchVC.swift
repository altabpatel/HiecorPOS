//
//  SwipeAndSearchVC.swift
//  HieCOR
//
//  Created by Deftsoft on 28/09/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import AVFoundation
import MediaPlayer


struct CardData {
    var number: String!
    var year: String!
    var month: String!
    var name: String?
}

class SwipeAndSearchVC: NSObject, SwipeAndSearchDelegate {
    
    //MARK: Variables
    var cardData = CardData()
    var isEnable = true
    var isEnableForCardHolderName = true
    var cardIOSelected = false
    var isSearchWithScanner = false
    var isProductSearching = true
    var isJackReaderConnected = false
    var isResponseReceived = false
    
    var imagReadLib: iMagRead?
    private var isSwipedSuccessfully = false
    private var searchTextField: UITextField?
    private var dummyCardNumber = String()
    private var dummyCardNumberForCardHolderName = String()

    private var ACCEPTABLE_CHARACTERS = "0123456789"
    static var delegate: SwipeAndSearchDelegate? = nil
    static var originalVolume = Float()
    var connectionDelegate: SwipeAndSearchConnectionDelegate? = nil
    var textChangeDelegate: SwipeAndSearchTextDidChangeDelegate? = nil
    
    //Mark: Create Shared Instance
    public static let shared = SwipeAndSearchVC()
    private override init() {}
    
    //MARK: Class Functions
    func initialize() {
//        appDelegate.showToast(message: "enter value swiper1")
        self.deinitialize()
        //Add Observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ExternalKeyboardStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(externalKeyboardStatus(notification:)), name: NSNotification.Name(rawValue: "ExternalKeyboardStatus"), object: nil)
        self.checkKeyboard()
        setupjackNotifications()
    }
    
    func deinitialize() {
        //Add Observer
        //NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "ExternalKeyboardStatus"), object: nil)
        IQKeyboardManager.shared.enableAutoToolbar = cardIOSelected ? false : true
        IQKeyboardManager.shared.enable = cardIOSelected ? false : true
        self.searchTextField?.text = ""
        self.searchTextField?.resignFirstResponder()
        self.searchTextField = nil
        imagReadLib?.stop()
        imagReadLib = nil
        isSwipedSuccessfully = false
        isSearchWithScanner = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ExternalKeyboardStatus"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CARREAD_MSG_ByteUpdate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CARREAD_MSG_Err"), object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionRouteChange, object: nil)
    }
    
    func enableTextField() {
        if !isEnable || iPad_AccessPINViewController.isPresented {
//            appDelegate.showToast(message: "enter value swiper2")
            return
        }
//        appDelegate.showToast(message: "enter value swiper12")
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        searchTextField?.text = ""
        searchTextField?.becomeFirstResponder()
    }
    
    //ExternalKeyboardStatus
    @objc func externalKeyboardStatus(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
            if !DataManager.isExternalKeyBoardAttach {
                DispatchQueue.main.async {
                    IQKeyboardManager.shared.enableAutoToolbar = false
                    IQKeyboardManager.shared.enable = false
                    self.searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
                    self.searchTextField?.textColor = UIColor.clear
                    self.searchTextField?.tintColor = UIColor.clear
                    self.searchTextField?.backgroundColor = UIColor.clear
                    self.searchTextField?.keyboardToolbar.isHidden = true
                    self.searchTextField?.hideAssistantBar()
                    self.searchTextField?.autocorrectionType = .no
                    self.searchTextField?.shouldHideToolbarPlaceholder = true
                    self.searchTextField?.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                    UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
                    UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self.searchTextField!)
                    self.searchTextField?.delegate = self
                    self.searchTextField?.becomeFirstResponder()
                    if self.isAlertPresented() {
                        self.triggerAlertAction()
                    }
                    SwipeAndSearchVC.delegate?.didBeginSearching?()
                    
                    if Keyboard._isExternalKeyboardAttached() {
                        DataManager.isExternalKeyBoardAttach = true
                    }
                }
            } else {
                self.checkKeyboard()
            }
        }
    }
    
    private func checkKeyboard() {
//        appDelegate.showToast(message: "enter value swiper11")
        DispatchQueue.main.async {
            if Keyboard._isExternalKeyboardAttached() {
                DataManager.isExternalKeyBoardAttach = true
                print("attached")
                DispatchQueue.main.async {
                    IQKeyboardManager.shared.enableAutoToolbar = false
                    IQKeyboardManager.shared.enable = false
                    self.searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
                    self.searchTextField?.textColor = UIColor.clear
                    self.searchTextField?.tintColor = UIColor.clear
                    self.searchTextField?.backgroundColor = UIColor.clear
                    self.searchTextField?.keyboardToolbar.isHidden = true
                    self.searchTextField?.hideAssistantBar()
                    self.searchTextField?.autocorrectionType = .no
                    self.searchTextField?.shouldHideToolbarPlaceholder = true
                    self.searchTextField?.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
                    UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
                    UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self.searchTextField!)
                    self.searchTextField?.delegate = self
                    self.searchTextField?.becomeFirstResponder()
                    if self.isAlertPresented() {
                        self.triggerAlertAction()
                    }
                    SwipeAndSearchVC.delegate?.didBeginSearching?()
                }
            }else {
                print("not attached")
                DataManager.isExternalKeyBoardAttach = false
                DispatchQueue.main.async {
                    IQKeyboardManager.shared.enableAutoToolbar = self.cardIOSelected ? false : true
                    IQKeyboardManager.shared.enable = self.cardIOSelected ? false : true
                    self.searchTextField?.text = ""
                    self.searchTextField?.resignFirstResponder()
                    self.searchTextField = nil
                    self.isSearchWithScanner = false
                    UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
                    if self.isAlertPresented() {
                        self.triggerAlertAction()
                    }
                    SwipeAndSearchVC.delegate?.didEndSearching?()
                }
            }
        }
    }
    
    private func checkEnableScanner() {
        let alert = UIAlertController(title: "Barcode Scanners", message: "Enable Barcode Scanners?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: {(action) in
            DataManager.isBarCodeReaderOn = true
            self.getSearchProductsList()
            self.dummyCardNumber = ""
            self.dummyCardNumberForCardHolderName = ""
        }))
        alert.addAction(UIAlertAction(title: kCancel, style: .default, handler: {(action) in
            self.searchTextField?.becomeFirstResponder()
            self.searchTextField?.text = ""
            self.dummyCardNumber = ""
            self.dummyCardNumberForCardHolderName = ""
        }))
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert,animated: true)
        }
    }
    
    private func getSearchProductsList() {
        
        if !isEnable {
            //appDelegate.showToast(message: "enter value swiper11")
            return
        }
        
        //Validate
        if searchTextField == nil {
            //appDelegate.showToast(message: "enter value swiper12")
            return
        }
        
        let searchText = searchTextField!.text!.replacingOccurrences(of: " ", with: "%20")
        if searchText == "" || searchText.hasPrefix(";") || searchText.hasSuffix("?") {
            //appDelegate.showToast(message: "enter value swiper13")
            return
        }
        
        if !isResponseReceived {
            self.searchTextField?.text = ""
            self.searchTextField?.becomeFirstResponder()
            return
        }
        
        if !DataManager.isBarCodeReaderOn {
            self.searchTextField?.resignFirstResponder()
            self.checkEnableScanner()
            return
        }
        
        if self.isAlertPresented() {
            self.triggerAlertAction()
        }

        SwipeAndSearchVC.delegate?.didSearchingProduct?()
         if UI_USER_INTERFACE_IDIOM() == .pad {
            SwipeAndSearchVC.delegate?.didSearchingProductScaner?(text: searchText)
            self.isSearchWithScanner = true
            self.searchTextField?.text = ""
             return
        }
        self.isSearchWithScanner = true
        self.searchTextField?.text = ""
        
        let searchUrl = kGetTotalProducts + "?key=" + searchText
        
        //Call API
        DispatchQueue.main.async {
            Indicator.isEnabledIndicator = false
            Indicator.sharedInstance.showIndicator()
        }
        HomeVM.shared.getSearchProduct(searchText: searchUrl, searchFetchLimit: 20, searchPageCount: 1) { (success, message, error) in
            if success == 1 {
                if self.isAlertPresented() {
                    self.triggerAlertAction()
                }

                if HomeVM.shared.searchProductsArray.count > 0 {
                    SwipeAndSearchVC.delegate?.didSearchedProduct?(product: HomeVM.shared.searchProductsArray.first!)
//                    if HomeVM.shared.searchProductsArray.count == 1 {
//                        SwipeAndSearchVC.delegate?.didSearchedProduct?(product: HomeVM.shared.searchProductsArray.first!)
//                    }else{
//                        SwipeAndSearchVC.delegate?.didSearchedProductMultiProduct?(product:  HomeVM.shared.searchProductsArray,text: searchText)
//                    }
                }else {
                    SwipeAndSearchVC.delegate?.noProductFound?()
                }
                
                DispatchQueue.main.async {
                    Indicator.isEnabledIndicator = false
                    Indicator.sharedInstance.hideIndicator()
                }
            }else {
                DispatchQueue.main.async {
                    Indicator.isEnabledIndicator = false
                    Indicator.sharedInstance.hideIndicator()
                }
                
                if self.isAlertPresented() {
                    self.triggerAlertAction()
                }

                SwipeAndSearchVC.delegate?.noProductFound?()
                if message != nil {
                    //...
                }else {
                    self.showErrorMessage(error: error)
                }
                
            }
            self.searchTextField?.becomeFirstResponder()
        }
    }
    
    func dismissAlertControllerIfPresent() {
        guard let window :UIWindow = UIApplication.shared.keyWindow , var topVC = window.rootViewController?.presentedViewController else {return}
        while topVC.presentedViewController != nil  {
            topVC = topVC.presentedViewController!
        }
        if topVC.isKind(of: UIAlertController.self) {
            topVC.dismiss(animated: false, completion: nil)
        }
        CatAndProductsViewController.visualEffectView.removeFromSuperview()
    }
    
    private func isAlertPresented() -> Bool {
        guard let window :UIWindow = UIApplication.shared.keyWindow , var topVC = window.rootViewController?.presentedViewController else {return false}
        while topVC.presentedViewController != nil  {
            topVC = topVC.presentedViewController!
        }
        if topVC.isKind(of: UIAlertController.self) {
            return true
        }
        return false
    }
    
    private func showAlert(title:String? = kAlert , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: {(action) in
            self.searchTextField?.becomeFirstResponder()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert,animated: true)
    }
    
    private func showErrorMessage(error: NSError?) {
        if error != nil {
            let alert = UIAlertController(title: error!.domain, message: error!.userInfo[APIKeys.kMessage] as? String ?? kUnableRequestMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: {(action) in
                self.searchTextField?.becomeFirstResponder()
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert,animated: true)
        }
        else {
            let alert = UIAlertController(title: kAlert, message: kUnableRequestMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: {(action) in
                self.searchTextField?.becomeFirstResponder()
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert,animated: true)
        }
    }
    
    private func triggerDelegateForCardData() {
//        appDelegate.showToast(message: "enter value swiper3")
        if self.isAlertPresented() {
            self.triggerAlertAction()
        }
//        if NetworkConnectivity.isConnectedToInternet() {
//            SwipeAndSearchVC.delegate?.didGetCardDetail?(number: self.cardData.number, month: self.cardData.month, year: self.cardData.year)
//        }else {
//            self.showAlert(message: "Pay by Credit Card is not available in the offline mode.")
//        }
        if (DataManager.selectedPayment?.contains("CREDIT"))! {
            SwipeAndSearchVC.delegate?.didGetCardDetail?(number: self.cardData.number, month: self.cardData.month, year: self.cardData.year)
        } else {
            appDelegate.showToast(message: "Please add payment method credit card from Settings.")
        }
        
       // SwipeAndSearchVC.delegate?.didGetCardDetail?(number: self.cardData.number, month: self.cardData.month, year: self.cardData.year)
    }
    
    private func triggerDelegateForNoCardData() {
//        appDelegate.showToast(message: "enter value swiper4")
        if self.isAlertPresented() {
            self.triggerAlertAction()
        }
        SwipeAndSearchVC.delegate?.noCardDetailFound?()
    }

    private func triggerAlertAction() {
        if let alert = UIApplication.topViewController() as? UIAlertController {
            if let index = alert.actions.firstIndex(where: {$0.title == kOkay}) {
                alert.tapButton(atIndex: index)
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension SwipeAndSearchVC: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
//        appDelegate.showToast(message: "enter value swiper5")
        if textChangeDelegate != nil {
            let text = textField.text ?? ""
            if (text.contains(".") && text.count < 11) || text.count < 8 {
                self.textChangeDelegate?.textDidchange?(text: text)
            }else {
                textField.text = String(text.prefix(7))
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        appDelegate.showToast(message: "enter value swiper6")
        self.textChangeDelegate?.textDidBeginEditing?()
        textField.text = ""
        dummyCardNumber = ""
       // dummyCardNumberForCardHolderName = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        appDelegate.showToast(message: "enter value swiper7")
        if textChangeDelegate != nil {
            textField.text = ""
            dummyCardNumber = ""
            dummyCardNumberForCardHolderName = ""
            textChangeDelegate?.textDidEndEditing?()
            return true
        }
        
        if !isEnable {
            
            return true
        }
        
        //Handle Scanner Data
        if isProductSearching {
            self.getSearchProductsList()
        }
        
        //Handle Swipe Data
        print("********************************************* Dummy Card Number Start ************************************************************")
        print(dummyCardNumber)
        print(dummyCardNumberForCardHolderName)
        print("********************************************* Dummy Card Number End ************************************************************")
        
        //Handle Swipe Reader Data
        let isSingleBeepSwiper = String(describing: dummyCardNumber.prefix(1)) == ";"
        if (String(describing: dummyCardNumber.prefix(1)) != ";" && isSingleBeepSwiper) || !isSingleBeepSwiper {
            self.dummyCardNumber = ""
            isEnableForCardHolderName = false
            if dummyCardNumberForCardHolderName == "" {
                isEnableForCardHolderName = true
            }else{
                isEnableForCardHolderName = false
            }
            self.triggerDelegateForNoCardData()
            return true
        }
        let cardNumberArray = dummyCardNumber.split(separator: isSingleBeepSwiper ? "=" : "^")
        if isSingleBeepSwiper ? cardNumberArray.count > 1 : cardNumberArray.count > 2 {
            let number = String(describing: String(describing: cardNumberArray.first ?? "").dropFirst(isSingleBeepSwiper ? 1 : 2))
            let month = String(describing: String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(4)).dropFirst(2))
            let year = String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(2))
           
 //           var name = ""
//            if dummyCardNumberForCardHolderName != "" {
//                 let cardHolderName = dummyCardNumberForCardHolderName["^", "^", false]
//                print(cardHolderName)
//                name = cardHolderName ?? ""
//            }
           
            
            // priya code for card
            var name = ""
            if !DataManager.isSideMenuSwiperCard {
                if dummyCardNumberForCardHolderName != "" {
                    let cardHolderName = dummyCardNumberForCardHolderName.getNameString(from: "^", to: "^")
                    print(cardHolderName)
                    name = cardHolderName ?? ""
                    
                    var strArray = name.replacingOccurrences(of: "/", with: " ")
                    
                    var nameArr = strArray.components(separatedBy: " ")
                    var nameFirst = ""
                    var nameLast = ""
                    for i in 0..<nameArr.count {
                        nameFirst = nameArr[0]
                        if i > 0 {
                            nameLast += nameArr[i] + " "
                        }
                    }
                    
                    DataManager.FirstNameCardHolder = nameLast
                    DataManager.LastNameCardHolder = nameFirst
                    
                    nameLast = nameLast.replacingOccurrences(of: " ", with: "")
                    nameFirst = nameFirst.replacingOccurrences(of: " ", with: "")

                     //let city = userData["city"]
                     //let region = userData["region"]
                     //let postal_code = userData["postal_code"]
                     //let country = userData["country"]
                     
                     //let customerObj: JSONDictionary = ["country": country ?? "", "billingCountry":country ?? "","shippingCountry":country ?? "","coupan": "", "str_first_name":"", "str_last_name":"", "str_company": "" ,"str_address": "", "str_bpid":"", "str_city":city ?? "", "str_order_id": "", "str_email": "", "str_userID": "", "str_phone": "","str_region":region ?? "", "str_address2": "", "str_Billingcity":city ?? "", "str_postal_code":postal_code ?? "", "str_Billingphone": "", "str_Billingaddress": "", "str_Billingaddress2": "", "str_Billingregion":region ?? "", "str_Billingpostal_code":postal_code ?? "","shippingPhone": "","shippingAddress" : "", "shippingAddress2": "", "shippingCity": city ?? "", "shippingRegion" : region ?? "", "shippingPostalCode": postal_code ?? "", "billing_first_name": "", "billing_last_name": "","user_custom_tax": "","shipping_first_name": "", "shipping_last_name": "","shippingEmail":  "", "str_Billingemail": "",  "str_BillingCustom1TextField": "", "str_BillingCustom2TextField": ""]
                     //DataManager.customerObj = customerObj
                    
                    if DataManager.customerObj == nil {
                        let customerObj: JSONDictionary = ["country": "", "billingCountry": "","shippingCountry": "","coupan": "", "str_first_name":"", "str_last_name":"", "str_company": "" ,"str_address": "", "str_bpid":"", "str_city": "", "str_order_id": "", "str_email": "", "str_userID": "", "str_phone": "","str_region": "", "str_address2": "", "str_Billingcity": "", "str_postal_code": "", "str_Billingphone": "", "str_Billingaddress": "", "str_Billingaddress2": "", "str_Billingregion": "", "str_Billingpostal_code": "","shippingPhone": "","shippingAddress" : "", "shippingAddress2": "", "shippingCity": "", "shippingRegion" : "", "shippingPostalCode":  "", "billing_first_name": "", "billing_last_name": "","user_custom_tax": "","shipping_first_name": "", "shipping_last_name": "","shippingEmail":  "", "str_Billingemail": "",  "str_BillingCustom1TextField": "", "str_BillingCustom2TextField": ""]
                        DataManager.customerObj = customerObj
                    }
                    
                    if let namefir = DataManager.customerObj?["str_first_name"] as? String  {
                        //invoiceEmail = name
                        if namefir == "" {
                            DataManager.customerObj?["str_first_name"] = nameLast
                            DataManager.customerObj?["shipping_first_name"] = nameLast
                            DataManager.customerObj?["billing_first_name"] = nameLast
                        }
                    } else {
                        DataManager.customerObj?["str_first_name"] = nameLast
                        DataManager.customerObj?["shipping_first_name"] = nameLast
                        DataManager.customerObj?["billing_first_name"] = nameLast
                    }
                    
                    if let namelast = DataManager.customerObj?["str_last_name"] as? String  {
                        //invoiceEmail = name
                        if namelast == "" {
                            DataManager.customerObj?["str_last_name"] = nameFirst
                            DataManager.customerObj?["shipping_last_name"] = nameFirst
                            DataManager.customerObj?["billing_last_name"] = nameFirst
                        }
                    } else {
                        DataManager.customerObj?["str_last_name"] = nameFirst
                        DataManager.customerObj?["shipping_last_name"] = nameFirst
                        DataManager.customerObj?["billing_last_name"] = nameFirst
                    }
                    
                    print(nameFirst)
                    print(nameLast)
                }
            }

// priya end
            self.dummyCardNumber = ""
            self.dummyCardNumberForCardHolderName = ""
            isEnableForCardHolderName = true
            self.cardData = CardData(number: number, year: "20" + year, month: month , name: name )
            self.triggerDelegateForCardData()
        }else {
            self.dummyCardNumber = ""
            self.dummyCardNumberForCardHolderName = ""
            self.triggerDelegateForNoCardData()
        }
        textField.text = ""
        return true   
	 }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       // appDelegate.showToast(message: "enter value swiper8")
        if !isEnable {
            return false
        }
        //Handle Swipe Reader Data
        dummyCardNumber.append(string)
        if isEnableForCardHolderName {
           dummyCardNumberForCardHolderName.append(string)
        }

        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            return false
        }
        dummyCardNumber = ""
dummyCardNumberForCardHolderName = ""
        if textChangeDelegate != nil {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
        return true
    }
    
}

//MARK: JACK READER
extension SwipeAndSearchVC {
    
    func setupjackNotifications() {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count != 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    self.enableSwipeReader()
                    print("headphone plugged in")
                } else {
                    print("headphone pulled out")
                }
            }
        } else {
            print("requires connection to device")
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .AVAudioSessionRouteChange, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleRouteChange(notification:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    @objc dynamic fileprivate func handleRouteChange(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSessionRouteChangeReason(rawValue:reasonValue) else {
                return
        }
        switch reason {
        case .newDeviceAvailable:
            let session = AVAudioSession.sharedInstance()
            
            SwipeAndSearchVC.originalVolume = session.outputVolume
            
            for output in session.currentRoute.outputs where output.portType == AVAudioSessionPortHeadphones {
                print("New device connected")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.enableSwipeReader()
                    if self.isAlertPresented() {
                        self.triggerAlertAction()
                    }
                    SwipeAndSearchVC.delegate?.didUpdateDevice?()
                    MPVolumeView.setVolume(1.0)
                    self.connectionDelegate?.didUpdateJackReader?(isConnected: true)
                })
                break
            }
        case .oldDeviceUnavailable:
            if let previousRoute =
                userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                for output in previousRoute.outputs where output.portType == AVAudioSessionPortHeadphones {
                    print("No device connected")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.imagReadLib?.stop()
                        self.imagReadLib = nil
                        self.isSwipedSuccessfully = false
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CARREAD_MSG_ByteUpdate"), object: nil)
                        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CARREAD_MSG_Err"), object: nil)
                        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
                        self.isJackReaderConnected = false
                        if self.isAlertPresented() {
                            self.triggerAlertAction()
                        }
                        SwipeAndSearchVC.delegate?.didUpdateDevice?()
                        MPVolumeView.setVolume(SwipeAndSearchVC.originalVolume)
                        self.connectionDelegate?.didUpdateJackReader?(isConnected: false)
                        
                        if Keyboard._isExternalKeyboardAttached() {
                            self.enableTextField()
                        }
                    })
                    break
                }
            }
        default: ()
        }
    }
    
    //Check Card Swipe Reader
    func checkAudioJack() {
        DispatchQueue.main.async {
            switch AVAudioSession.sharedInstance().recordPermission() {
            case AVAudioSessionRecordPermission.granted:
                print("Permission granted")
                break
            case AVAudioSessionRecordPermission.denied:
                print("Pemission denied")
                if !self.isHeadsetPluggedIn() {
                    return
                }
                let alert = UIAlertController(title: "Alert", message: "Please Enable Microphone Access From Settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { (action) in
                    guard let url = URL(string: UIApplicationOpenSettingsURLString) else {return}
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert,animated: true)
                break
            case AVAudioSessionRecordPermission.undetermined:
                print("Request permission here")
                AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                    if granted {
                    }
                })
                break
            }
        }
    }
    
    //Check Headphones
    func isHeadsetPluggedIn() -> Bool {
        let route: AVAudioSessionRouteDescription = AVAudioSession.sharedInstance().currentRoute
        for portDescription: AVAudioSessionPortDescription in (route.outputs) {
            if portDescription.portType == AVAudioSessionPortHeadphones {
                DispatchQueue.main.async {
                    self.isJackReaderConnected = true
                    self.connectionDelegate?.didUpdateJackReader?(isConnected: true)
                }
                return true
            }
        }
        //MPVolumeView.setVolume(SwipeAndSearchVC.originalVolume)
        return false
    }
    
    func enableSwipeReader() {
        if isHeadsetPluggedIn() {
            if !DataManager.cardReaders {
                let alert = UIAlertController(title: "Card Reader", message: "Enable Card Readers?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: {(action) in
                    DataManager.cardReaders = true
                    self.enableReader()
                }))
                alert.addAction(UIAlertAction(title: kCancel, style: .default, handler: {(action) in
                    self.searchTextField?.becomeFirstResponder()
                }))
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert,animated: true)
                }
                return
            }
            self.enableReader()
        }
    }
    
    private func enableReader() {
        DispatchQueue.main.async {
            //Remove Observer
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CARREAD_MSG_ByteUpdate"), object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CARREAD_MSG_Err"), object: nil)
            //Add Observer
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateBytes), name: NSNotification.Name(rawValue: "CARREAD_MSG_ByteUpdate"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateError), name: NSNotification.Name(rawValue: "CARREAD_MSG_Err"), object: nil)
            //Initiliaze
            self.isSwipedSuccessfully = false
            self.imagReadLib = iMagRead()
            self.imagReadLib?.start()
            self.checkAudioJack()
        }
    }
}

//MARK: Notification Observers
extension SwipeAndSearchVC {
    
    @objc func updateBytes(_ aNotification: Notification) {
        let str = aNotification.object as? String
        let strname = aNotification.name
        performSelector(onMainThread: #selector(self.updateBytCtl), with: str, waitUntilDone: false)
    }
    
    @objc func updateError(_ aNotification: Notification) {
        let str = aNotification.object as? String
        performSelector(onMainThread: #selector(self.updateErrorState), with: str, waitUntilDone: false)
    }
    
    @objc func updateErrorState(_ text: String) {
        print("Swipe Result: ",text)
        isSwipedSuccessfully = text == "Sucess"
        if text == "LRC Check Error" {
            self.triggerDelegateForNoCardData()
        }
        
    }
    
    @objc func updateBytCtl(_ text: String) {
//        appDelegate.showToast(message: "enter value swiper9")
        print("********************************************* Start BYTES ************************************************************")
        print(text)
        print("********************************************* End BYTES ************************************************************")
        if !isSwipedSuccessfully || !isEnable {
            return
        }
        // Update Data
        var listItems = text.components(separatedBy: ";")
        var year: NSNumber?
        var str_cardNumber: String
        var str_expYear: String
        var str_expMonth: String
        var str_expname : String
        listItems = text.components(separatedBy: "=")
        
        if listItems.count > 1 {
            str_cardNumber = "\(listItems[0])".replacingOccurrences(of: ";", with: "")
            if ("\(listItems[1])".count ) > 4 {
                year = Int((("\(listItems[1])" as NSString).substring(with: NSRange(location: 0, length: 2)))) as NSNumber? ?? 0 as NSNumber
                str_expYear = "20\(year!)"
                let str_Month = listItems[1] as NSString
                str_expMonth = str_Month.substring(with: NSRange(location: 2, length: 2))
                str_expname = (listItems[1] as NSString) as String
                
                let tempCardNumber = Int64(str_cardNumber)
                let tempCardMonth = Int64(str_expMonth)
                let tempCardYear = Int64(str_expYear)
                let tempCardName = Int64(str_expname)
                
                DispatchQueue.main.async {
                    if tempCardNumber == nil || tempCardMonth == nil || tempCardYear == nil {
                        self.triggerDelegateForNoCardData()
                        return
                    }
                    self.cardData = CardData(number: str_cardNumber, year: str_expYear, month: str_expMonth , name:str_expname)
                    self.triggerDelegateForCardData()
                    self.isSwipedSuccessfully = false
                }
            }
        }
    }
}


extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
    
    static func getVolume() -> Float {
        let audioSession = AVAudioSession.sharedInstance()
        var volume = Float()
        do {
            try audioSession.setActive(true)
            volume = audioSession.outputVolume
        } catch {
            print("Error Setting Up Audio Session")
        }
        return volume
    }
}

//priya
extension String {
    
    func getNameString(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
